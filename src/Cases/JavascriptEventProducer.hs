{-# LANGUAGE QuasiQuotes #-}
module Cases.JavascriptEventProducer where

import           Prelude hiding (div)
import           Text.RawString.QQ (r)

import           Purview hiding (render)
import           Purview.Server

component count = div
  [ class' "counter-display" $ div [ text (show count) ]
  ]

countHandler = handler' [] (0 :: Int) reducer
  where
    reducer "increment" state = (state + 1, [])
    reducer "decrement" state = (state - 1, [])

countReceiver = receiver "incrementReceiver" (const "increment")

render = countHandler . countReceiver $ component
  -- receiver "incrementReceiver" (const "increment")
  -- component

jsCounter = [r|
  const startCount = () => {
    window.setInterval(() => {
      sendEvent("incrementReceiver", "increment")
    }, 1000)
  }
  startCount()
|]

getTest = (defaultConfiguration { javascript=jsCounter }, render)
