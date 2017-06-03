module ToneCss exposing (..)

import Css exposing (..)
import CssSelectors exposing (CssClasses(..), CssIds(..))


-- This is going back to the main CSS module


toneRules : Css.Snippet
toneRules =
    class Tone
        [ padding (Css.rem 1)
        , borderRadius (Css.px 5)
        , margin (Css.rem 0.5)
        , backgroundColor (hex "BF9ACA")
        , minWidth (Css.rem 15)
        ]
