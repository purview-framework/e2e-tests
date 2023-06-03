module Cases.RendersAButton where

import Prelude hiding (div)

import Purview hiding (render)

render = div [ button [ text "click me" ] ]

getTest = (defaultConfiguration, render)
