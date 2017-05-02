--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend, mconcat)
import           Data.Maybe (fromMaybe)
import           Hakyll
import           System.Directory (getModificationTime)
import           Control.Monad (forM, liftM)
--import           System.Time (formatCalendarTime, toUTCTime)
import           Data.List (sortBy)
import           Data.Ord (comparing)
import           Text.Pandoc (HTMLMathMethod(MathML),
                    ObfuscationMethod(ReferenceObfuscation), WriterOptions(..))

--------------------------------------------------------------------------------
testConf :: Configuration
testConf = defaultConfiguration
  { destinationDirectory = "_test",
    storeDirectory = "_testcache" }

main :: IO ()
main = hakyllWith testConf $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "fonts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "favicon.ico" $ do
        route   idRoute
        compile copyFileCompiler

    match "keybase.txt" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromRegex "^docs/.*[^\\.page]$") $ do
       route    idRoute
       compile  copyFileCompiler

    -- Tags
    tags <- buildTags "**.page" (fromCapture "tags/*")

    match "newsletters/*" $ do
        route $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions woptions
            >>= loadAndApplyTemplate "templates/default.html" (postCtx tags)
            >>= relativizeUrls
            
    match "blog/*.md" $ do
        route $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions woptions
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/posts.html" (blogPostCtx tags)
            >>= loadAndApplyTemplate "templates/bloglist.html" (blogPostCtx tags)
            >>= relativizeUrls

    -- create index page for blog posts
    create ["blog/index.html"] $ do
                               route idRoute
                               compile $ do
                                   posts <- loadAllSnapshots "blog/*.md" "content"
                                   sortedTen <- liftM (take 10) (recentFirst posts)
                                   itemTpl <- loadBody "templates/posts.html"
                                   list <- applyTemplateList itemTpl (blogPostCtx tags) sortedTen
                                   makeItem list
                                         >>= loadAndApplyTemplate "templates/bloglist.html" (allPostsCtx tags)
                                         >>= relativizeUrls

    -- create archive page for blog posts
    create ["blog/archive.html"] $ do
      route idRoute
      compile $ do
        posts <- loadAllSnapshots "blog/*.md" "content"
        sorted <- recentFirst posts
        itemsTpl <- loadBody "templates/postitem.html"
        list <- applyTemplateList itemsTpl defaultContext sorted
        makeItem (list)
          >>= loadAndApplyTemplate "templates/archives.html" (allPostsCtx tags)
          >>= relativizeUrls


    -- bibliography
    match "csl/*" $ compile cslCompiler

    match "bib/*" $ compile biblioCompiler

    match "**.page" $ do
        route $ setExtension "html"
        compile $ do
            item <- getUnderlying
            bibFile <- liftM (fromMaybe "") $ getMetadataField item "biblio"
            cslFile <- liftM (fromMaybe "chicago") $ getMetadataField item "csl"
            let compiler = if bibFile /= "" then
                              bibtexCompiler cslFile bibFile
                           else pandocCompilerWith defaultHakyllReaderOptions woptions
            compiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" (postCtx tags)
            >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    -- render RSS from recently changed files

    create ["rss.xml"] $ do
        route $ idRoute
        compile $ do
            posts <- fmap (take 10) . createdFirst =<<
                loadAllSnapshots "*.page" "content"
            renderRss feedConfiguration (feedContext tags) posts
            
    create ["blog/index.rss"] $ do
        route $ idRoute
        compile $ do
        posts <- fmap (take 10) . createdFirst =<<
            loadAllSnapshots "blog/*.md" "content"
        renderRss feedConfiguration (feedContext tags) posts

    tagsRules tags $ \tag pattern -> do
                 let title = "Tag: " ++ tag
                 route $ setExtension "html"
                 compile $ tagPage tags title pattern
                   >>= loadAndApplyTemplate "templates/bloglist.html" (allPostsCtx tags)
                   >>= relativizeUrls
--------------------------------------------------------------------------------
postCtx :: Tags -> Context String
postCtx tags =
    dateField "created" "%Y-%m-%d" `mappend`
    modificationTimeField "updated" "%Y-%m-%d" `mappend`
    tagsField "tags" tags `mappend`
    defaultContext

allPostsCtx :: Tags -> Context String
allPostsCtx tags =
    constField "title" "All posts" `mappend` (blogPostCtx tags)

blogPostCtx :: Tags -> Context String
blogPostCtx tags =
    dateField "created" "%Y-%m-%d" `mappend`
    tagsField "tags" tags `mappend`
    defaultContext

bibtexCompiler :: String -> String -> Compiler (Item String)
bibtexCompiler cslFileName bibFileName = do
    csl <- load (fromFilePath $ "csl/"++cslFileName)
    bib <- load (fromFilePath $ "bib/"++bibFileName)
    liftM (writePandocWith woptions) (getResourceBody >>= readPandocBiblio defaultHakyllReaderOptions csl bib)

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "徐栖"
    , feedDescription = "RSS feed for Haoyang's website"
    , feedAuthorName  = "徐栖"
    , feedAuthorEmail = "haoyang@expoundite.net"
    , feedRoot        = "https://expoundite.net"
    }

feedContext :: Tags -> Context String
feedContext tags = (postCtx tags) `mappend`
    modificationTimeField "published" "%Y-%m-%d" `mappend`
    mconcat
    [ rssBodyField "description"
    , rssTitleField "title"
    , urlField "url"
    , dateField "updated" "%B %e, %Y"
    ]

rssTitleField :: String -> Context a
rssTitleField key = field key $ \i -> do
    value <- getMetadataField (itemIdentifier i) "title"
    let value' = liftM (replaceAll "&" (const "&amp;")) value
    maybe empty return value'

empty :: Compiler String
empty = return ""

rssBodyField :: String -> Context String
rssBodyField key = field key $
    return . itemBody

woptions :: WriterOptions
woptions = defaultHakyllWriterOptions{ writerSectionDivs = True,
                                       writerTableOfContents = True,
                                       writerColumns = 70,
                                       writerTemplate = Just "<div id=\"TOC\">$toc$</div>\n$body$",
                                       writerHtml5 = True,
                                       writerHTMLMathMethod = Text.Pandoc.MathML (Just ""),
                                       writerHighlight = True,
                                       writerEmailObfuscation = ReferenceObfuscation}

createdFirst :: [Item String] -> Compiler [Item String]
createdFirst items =
    let itemsWithTime = unsafeCompiler $ forM items $ \item -> do
        utc <- getModificationTime $ toFilePath $ itemIdentifier item
        return (utc,item);
    in liftM (\xs -> reverse . map snd $ sortBy (comparing fst) xs) itemsWithTime

postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String]) -> Compiler String
postList tags pattern preprocess' = do
    postItemTemplate <- loadBody "templates/postitem.html"
    posts' <- loadAll pattern
    posts <- preprocess' posts'
    applyTemplateList postItemTemplate (postCtx tags) posts

tagPage :: Tags -> String -> Pattern -> Compiler (Item String)
tagPage tags title pattern = do
    list <- postList tags pattern (return . id)
    makeItem ""
        >>= loadAndApplyTemplate "templates/tags.html"
                (constField "posts" list `mappend` constField "title" title `mappend`
                    defaultContext) -- TODO: DRY tags.html, append default.html below
        >>= relativizeUrls
