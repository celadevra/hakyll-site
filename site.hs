--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend, mconcat)
import           Hakyll
import           System.Directory (getModificationTime)
import           Control.Monad (forM, liftM)
--import           System.Time (formatCalendarTime, toUTCTime)
import           Data.List (sortBy)
import           Data.Ord (comparing)
import           Text.Pandoc (HTMLMathMethod(MathJax),
                    ObfuscationMethod(ReferenceObfuscation), WriterOptions(..))

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["docs/*.pdf", "docs/*.mobi", "docs/*.epub"]) $ do
       route    idRoute
       compile  copyFileCompiler

    -- Tags
    tags <- buildTags "**.page" (fromCapture "tags/*")

    match "docs/*" $ do
        route $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions woptions
            >>= loadAndApplyTemplate "templates/default.html" (postCtx tags)
            >>= relativizeUrls

    match "**.page" $ do
        route $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions woptions
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

    tagsRules tags $ \tag pattern -> do
                 let title = "Tag: " ++ tag
                 route idRoute
                 compile $ tagPage tags title pattern
--------------------------------------------------------------------------------
postCtx :: Tags -> Context String
postCtx tags =
    dateField "created" "%Y-%m-%d" `mappend`
    modificationTimeField "updated" "%Y-%m-%d" `mappend`
    tagsField "tags" tags `mappend`
    defaultContext

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Haoyang Xu"
    , feedDescription = "RSS feed for Haoyang's website"
    , feedAuthorName  = "Haoyang Xu"
    , feedAuthorEmail = "haoyang@idenizen.net"
    , feedRoot        = "http://idenizen.net"
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
                                       writerStandalone = True,
                                       writerTableOfContents = True,
                                       writerColumns = 70,
                                       writerTemplate = "<div id=\"TOC\">$toc$</div>\n$body$",
                                       writerHtml5 = True,
                                       writerHTMLMathMethod = Text.Pandoc.MathJax "",
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
                    defaultContext)
        >>= relativizeUrls
