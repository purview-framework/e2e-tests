module Cases.BubblingEvents where

import Prelude hiding (div)

import Purview


component count = div
  [ class' "counter-display" $ div [ text (show count) ]

  -- here the event location is bound to the div, while the click event is being
  -- triggered from the button below.

  -- if the enrichment works, as the event bubbles it should have the correct
  -- location added to it
  , onClick "increment" $ div [ id' "increment" $ button [ text "increment" ] ]
  ]

countHandler = handler [] (0 :: Int) reducer
  where
    reducer "increment" state = (state + 1, [])

render = countHandler component
