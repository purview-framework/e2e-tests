module Cases.RendersAButton where

import Prelude hiding (div)

import Purview

render = div [ button [ text "click me" ] ]
