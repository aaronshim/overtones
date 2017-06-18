module ToneCss exposing (..)

import Css exposing (..)
import Css.Colors
import CssSelectors exposing (CssClasses(..), CssIds(..))
import SharedCss exposing (..)


-- This is going back to the main CSS module


toneRules : Css.Snippet
toneRules =
    class Tone
        [ padding (Css.rem 1)
        , borderRadius (Css.px 5)
        , border3 (px 1) solid Css.Colors.black
        , margin (Css.rem 0.5)
        ]



-- divide this out because we only want this to be the case when responsively on a larger screen


toneSizeRules : Css.Snippet
toneSizeRules =
    onlyForNotMobile <|
        class Tone
            [ minWidth (Css.rem 9)
            , maxWidth (Css.rem 25)
            ]



-- These following rules are layout rules so we are going to defer to the CSS framework for really small screen sizes


toneButtonRowRules : Css.Snippet
toneButtonRowRules =
    onlyForNotMobile <|
        class ToneButtonRow
            [ displayFlex ]


toneInputRowRules : Css.Snippet
toneInputRowRules =
    onlyForNotMobile <|
        class ToneInputRow
            [ displayFlex, alignItems center, flexWrap wrap ]


toneInputRules : Css.Snippet
toneInputRules =
    onlyForNotMobile <|
        class ToneInput
            [ margin (px 5)
            , padding zero
            , flex (int 1)
            , withClass ToneInputWide [ flex (int 3) ]
            , withClass ToneInputSizeInitial [ flex initial ]
            , withClass ToneInputRightJustified [ marginLeft auto ]
            ]
