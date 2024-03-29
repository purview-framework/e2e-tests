module Cases.Counter where

import Prelude hiding (div)

import Purview hiding (render)
import Purview.Server


component count = div
  [ class' "counter-display" $ div [ text (show count) ]
  , div [ onClick "increment" $ id' "increment" $ button [ text "increment" ]
        , onClick "decrement" $ id' "decrement" $ button [ text "decrement" ]
        ]
  ]

countHandler = handler' [] (0 :: Int) reducer
  where
    reducer "increment" state = (state + 1, [])
    reducer "decrement" state = (state - 1, [])

render = countHandler component

getTest = (defaultConfiguration, render)
