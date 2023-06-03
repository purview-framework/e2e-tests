module Cases.TextInput where

import Prelude hiding (div)

import Purview hiding (render)

typeAttr = Attribute . Generic "type"
nameAttr = Attribute . Generic "name"

textField = nameAttr "text" $ typeAttr "text" $ input []

submitButton = typeAttr "submit" $ button [ text "submit" ]

component state = div
  [ div [ id' "text-display" $ div [ text state ] ]
  , onSubmit id $ form
    [ id' "text-field" textField
    , id' "text-submit" submitButton
    ]
  ]

countHandler = handler' [] "" reducer
  where
    reducer (Just text) state = (text, [])
    reducer Nothing     state = ("no text", [])

render = countHandler component

getTest = (defaultConfiguration, render)
