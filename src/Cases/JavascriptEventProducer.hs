{-# LANGUAGE QuasiQuotes #-}
module Cases.JavascriptEventProducer where

import           Prelude hiding (div)
import           Text.RawString.QQ (r)

import           Purview hiding (render)

component count = div
  [ receiver "incrementReceiver" (const "increment")
  , class' "counter-display" $ div [ text (show count) ]
  ]

countHandler = handler' [] (0 :: Int) reducer
  where
    reducer "increment" state = (state + 1, [])
    reducer "decrement" state = (state - 1, [])

render = countHandler component

jsCounter = [r|
  const startCount = () => {
    window.setInterval(() => {
      sendEvent("incrementReceiver", "increment")
    }, 1000)
  }
  startCount()
|]

getTest = (defaultConfiguration { eventProducers=[jsCounter] }, render)
