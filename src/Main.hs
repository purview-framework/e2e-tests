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
import qualified Cases.BubblingEvents as BubblingEvents
import qualified Cases.JavascriptEventProducer as JavascriptEventProducer

type Path = String

root :: Path -> (Configuration IO, Purview () IO)
root location = case location of
  "/renders-a-button"          -> RendersAButton.getTest
  "/basics-and-attributes"     -> BasicsAndAttributes.getTest
  "/counter"                   -> Counter.getTest
  "/text-input"                -> TextInput.getTest
  "/weather"                   -> Weather.getTest
  "/blur-and-change"           -> BlurAndChange.getTest
  "/nested-states"             -> NestedStates.getTest
  "/bubbling-events"           -> BubblingEvents.getTest
  "/javascript-event-producer" -> JavascriptEventProducer.getTest
  _ -> (defaultConfiguration, div [ text "Unknown test" ])

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
    (config, render) = root path

  connection <- WebSocket.acceptRequest pendingConnection
  startWebSocketLoop config { devMode=True } render connection

httpHandler component request respond =
  let
    path = Text.unpack . Text.concat $ Wai.pathInfo request
    (config, render) = root $ "/" <> path
  in
    respond
      $ Wai.responseBuilder
          status200
          [("Content-Type", "text/html")]
          (renderFullPage config render)
