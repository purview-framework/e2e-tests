module Cases.NestedStates where

import Prelude hiding (div)

import Purview hiding (render)
import Purview.Server


countHandler = handler' [] (0 :: Int) reducer
  where
    reducer "increment" state = (state + 1, [])
    reducer "decrement" state = (state - 1, [])


childComponent count = div
  [ class' "counter-display-child" $ div [ text (show count) ]
  , div [ onClick "increment" $ id' "increment-child" $ button [ text "increment" ]
        , onClick "decrement" $ id' "decrement-child" $ button [ text "decrement" ]
        ]
  ]

component count = div
  [ class' "counter-display" $ div [ text (show count) ]
  , div [ onClick "increment" $ id' "increment" $ button [ text "increment" ]
        , onClick "decrement" $ id' "decrement" $ button [ text "decrement" ]
        ]
  , countHandler childComponent
  ]

render = countHandler component

getTest = (defaultConfiguration, render)
