module Cases.BlurAndChange where

import Prelude hiding (div)

import Purview

typeAttr = Attribute . Generic "type"
nameAttr = Attribute . Generic "name"

textField = nameAttr "text" $ typeAttr "text" $ input []

submitButton = typeAttr "submit" $ button [ text "submit" ]

component state = div
  [ div [ id' "text-display" $ div [ text state ] ]
  , onBlur id $ id' "text-field" textField
  ]

countHandler = handler [] "" reducer
  where
    reducer (Just text) state = (const text, [])
    reducer Nothing     state = (const "no text", [])

render = countHandler component
