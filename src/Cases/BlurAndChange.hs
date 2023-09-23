module Cases.BlurAndChange where

import Prelude hiding (div)

import Purview hiding (render)
import Purview.Server

typeAttr = Attribute . Generic "type"
nameAttr = Attribute . Generic "name"

textField = nameAttr "text" $ typeAttr "text" $ input []

submitButton = typeAttr "submit" $ button [ text "submit" ]

component state = div
  [ div [ id' "text-display" $ div [ text state ] ]
  , onBlur id $ id' "text-field-blur" textField
  , onChange id $ id' "text-field-change" textField
  ]

countHandler = handler' [] "" reducer
  where
    reducer (Just text) state = (text, [])
    reducer Nothing     state = ("no text", [])

render = countHandler component

getTest = (defaultConfiguration, render)
