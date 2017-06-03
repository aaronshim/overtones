module ToneCollectionCss exposing (..)

import Css exposing (..)
import CssSelectors exposing (CssClasses(..), CssIds(..))


-- This is going back to the main CSS module


toneCollectionRules : Css.Snippet
toneCollectionRules =
    class ToneCollection
        [ padding (Css.px 5)
        , borderRadius (Css.px 5)
        , margin (Css.px 5)
        , backgroundColor (hex "C7E8F3")
        , display inlineBlock
        ]
