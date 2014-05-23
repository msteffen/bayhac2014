-- {-# LANGUAGE OverloadedStrings, ImplicitParams #-}
{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

import Control.Monad.IO.Class (liftIO)
import Control.Monad (liftM)

import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T

import GHC.IO.Exception (ExitCode)

import Text.Blaze.Html.Renderer.Text (renderHtml)
import Text.Blaze.Html5 hiding (param,map,html)
import Text.Blaze.Html5.Attributes

import Network.Wai.Middleware.Static
import Network.Wai.Parse (FileInfo,fileName,fileContent)

import System.Process

-- Construct args to ImageMagick
genargs :: String -> String -> [String]
genargs infile other_args = [infile] ++ (splitstr other_args) ++ ["./out_image.jpg"]

-- Run ImageMagick
convert :: [String] -> IO (ExitCode, String, String)
convert args = readProcessWithExitCode "convert" args ""

-- Split string on commas
splitstr :: String -> [String]
splitstr = map T.unpack . T.split (== ',') . T.pack

-- Extract file info
fileinfo :: FileInfo BL.ByteString -> (String, BL.ByteString)
fileinfo f = (B.unpack (fileName f), fileContent f)

-- Cribbed from https://github.com/scotty-web/scotty/blob/master/examples/upload.hs
main :: IO ()
main = scotty 3000 $ do
  middleware $ staticPolicy noDots
  get "/" $ do
    text "Hello World!"
  post "/write" $ do
    (_, f) <- liftM Prelude.head $ files -- use lenses for this and next line
    let (fn, fc) = fileinfo f
    args <- param "commands"
    _ <- liftIO $ do
      putStrLn fn
      BL.writeFile fn fc
      convert $ genargs fn args
    html . renderHtml $ do img ! src "http://localhost:3000/out_image.jpg"
