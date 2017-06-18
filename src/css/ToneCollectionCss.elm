module ToneCollectionCss exposing (..)

import Css exposing (..)
import Css.Colors
import CssSelectors exposing (CssClasses(..), CssIds(..))


-- This is going back to the main CSS module


toneCollectionRules : Css.Snippet
toneCollectionRules =
    class ToneCollection
        [ padding2 Css.zero (Css.rem 1)
        , borderRadius (Css.px 5)
        , margin (Css.px 5)
        , border3 (px 1) solid Css.Colors.black
        , display inlineBlock
        ]


toneCollectionButtonRowRules : Css.Snippet
toneCollectionButtonRowRules =
    class ToneCollectionButtonRow
        [ displayFlex
        , children
            [ class SmallButton
                [ margin (Css.px 5) ]
            ]
        ]
