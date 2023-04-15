module Cases.BasicsAndAttributes where

import Prelude hiding (div)

import Purview

nameAttr = Attribute . Generic "name"
typeAttr = Attribute . Generic "type"
idAttr   = Attribute . Generic "id"

render = div
  [ idAttr "identifierAttr"   $ div [ text "id test" ]
  , nameAttr "namedAttr"      $ div [ text "name test" ]
  , typeAttr "typeAttr"       $ div [ text "type test" ]
  ]
