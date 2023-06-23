{-# LANGUAGE QuasiQuotes #-}
-- |

module Cases.ClassBasedCSS where

import Prelude hiding (div)

import Purview hiding (render)

fancyStyle = [style|
  height: 20px;
  width: 20px;
  color: green;
|]

simpleStyle = [style|
  height: 20px;
  width: 20px;
  color: red;
|]

component count = div
  [ class' "counter-display" $ div [ text (show count) ]
  , div [ onClick "increment" $ id' "increment" $ button [ text "increment" ]
        , onClick "decrement" $ id' "decrement" $ button [ text "decrement" ]
        ]
  , case count of
      1 -> fancyStyle $ id' "text" $ div [ text "should have a new style" ]
      _ -> simpleStyle $ id' "text" $ div [ text "the default style" ]
  ]

countHandler = handler' [] (0 :: Int) reducer
  where
    reducer "increment" state = (state + 1, [])
    reducer "decrement" state = (state - 1, [])

render = countHandler component

getTest = (defaultConfiguration, render)
