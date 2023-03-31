module Cases.BasicsAndAttributes where

import Prelude hiding (div)

import Purview

nameAttr = Attribute . Generic "name"
typeAttr = Attribute . Generic "type"

render = div
  [ id' "identifierAttr"      $ div [ text "id test" ]
  , nameAttr "namedAttr"      $ div [ text "name test" ]
  , typeAttr "typeAttr"       $ div [ text "type test" ]
  ]
