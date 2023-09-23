module Cases.RendersAButton where

import Prelude hiding (div)

import Purview hiding (render)
import Purview.Server

render = div [ button [ text "click me" ] ]

getTest = (defaultConfiguration, render)
