{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Prelude hiding (div)

import Purview
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Warp
import qualified Network.WebSockets as WebSocket
import qualified Network.Wai.Handler.WebSockets as WaiWebSocket
import Network.HTTP.Types

import qualified Data.ByteString.Char8 as ByteString
import qualified Data.Text as Text

import qualified Cases.RendersAButton as RendersAButton
import qualified Cases.BasicsAndAttributes as BasicsAndAttributes
import qualified Cases.Counter as Counter
import qualified Cases.TextInput as TextInput
import qualified Cases.Weather as Weather
import qualified Cases.BlurAndChange as BlurAndChange
import qualified Cases.NestedStates as NestedStates

type Path = String

root :: Path -> Purview () IO
root location = case location of
  "/renders-a-button"      -> RendersAButton.render
  "/basics-and-attributes" -> BasicsAndAttributes.render
  "/counter"               -> Counter.render
  "/text-input"            -> TextInput.render
  "/weather"               -> Weather.render
  "/blur-and-change"       -> BlurAndChange.render
  "/nested-states"         -> NestedStates.render
  _ -> div [ text "Unknown test" ]

main :: IO ()
main =
  let
    port = 8001
    settings = Warp.setPort port Warp.defaultSettings
  in
   Warp.runSettings settings
     $ WaiWebSocket.websocketsOr
         WebSocket.defaultConnectionOptions
         (webSocketHandler root)
         (httpHandler root)

webSocketHandler component pendingConnection = do
  let
    path = ByteString.unpack
      $ WebSocket.requestPath (WebSocket.pendingRequest pendingConnection)

  connection <- WebSocket.acceptRequest pendingConnection
  startWebSocketLoop defaultConfiguration { devMode=True } (root path) connection

httpHandler component request respond =
  let
    path = Text.unpack . Text.concat $ Wai.pathInfo request
  in
    respond
      $ Wai.responseBuilder
          status200
          [("Content-Type", "text/html")]
          (renderFullPage defaultConfiguration (root $ "/" <> path))
