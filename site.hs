--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


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
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "created" "%Y-%m-%d" `mappend`
    defaultContext
