{-# LANGUAGE QuasiQuotes #-}
module Cases.JavascriptEventReceiver where

import           Prelude hiding (div)
import           Text.RawString.QQ (r)

import           Purview hiding (render)

component count = div
  [ class' "counter-display" $ div [ text (show count) ]
  , div [ onClick "increment" $ id' "increment" $ button [ text "increment" ] ]
  , id' "messages" $ div []
  ]

countHandler = handler' [] (0 :: Int) reducer
  where
    reducer "increment" state =
      let newState = state + 1
      in (newState, [Browser "addMessage" (show newState)])

render = countHandler component

jsMessageAdder = [r|
  const addMessage = (value) => {
    const messagesBlock = document.querySelector("#messages");
    messagesBlock.innerHTML = value;
  }
  window.addMessage = addMessage;
|]

getTest = (defaultConfiguration { eventListeners=[jsMessageAdder] }, render)
