--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend, mconcat)
import           Hakyll
import           System.Directory (getModificationTime)
import           Control.Monad (forM, liftM)
--import           System.Time (formatCalendarTime, toUTCTime)
import           Data.List (sortBy)
import           Data.Ord (comparing)

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

    match "docs/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "*.page" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    -- render RSS from recently changed files

    create ["rss.xml"] $ do
        route $ idRoute
        compile $ do
            posts <- fmap (take 10) . createdFirst =<<
                loadAllSnapshots "*.page" "content"
            renderRss feedConfiguration feedContext posts


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "created" "%Y-%m-%d" `mappend`
    modificationTimeField "updated" "%Y-%m-%d" `mappend`
    defaultContext

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Haoyang Xu"
    , feedDescription = "RSS feed for Haoyang's website"
    , feedAuthorName  = "Haoyang Xu"
    , feedAuthorEmail = "haoyang@idenizen.net"
    , feedRoot        = "http://idenizen.net"
    }

feedContext :: Context String
feedContext = postCtx `mappend`
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

createdFirst :: [Item String] -> Compiler [Item String]
createdFirst items =
    let itemsWithTime = unsafeCompiler $ forM items $ \item -> do
        utc <- getModificationTime $ toFilePath $ itemIdentifier item
        return (utc,item);
    in liftM (\xs -> reverse . map snd $ sortBy (comparing fst) xs) itemsWithTime
