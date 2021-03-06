module ButtonCss exposing (buttonRules)

import Css exposing (..)
import Css.Elements exposing (button)
import Css.Colors
import CssSelectors exposing (CssClasses(..), CssIds(..))
import SharedCss exposing (..)


-- This is going back to the main CSS module


buttonRules : Css.Snippet
buttonRules =
    button [ playButtonRules, pauseButtonRules, unstickyRules, smallButtonRules ]



-- Here we define our own overrides on Milligram.css' button styles,
-- namely adding different color buttons (a la Bootstrap) and
-- making them not continue to be focused if we lose hover


unstuck : List Css.Mixin -> Css.Mixin
unstuck =
    -- our own pseudoclass (turns out that buttons on milligram.css are "sticky")
    pseudoClass "focus:not(:hover)"


defaultMiligramButtonColor : Color
defaultMiligramButtonColor =
    -- it's that purple
    defaultColor


unstickyRules : Css.Mixin
unstickyRules =
    unstickyMilligramButton UnstickyButton defaultMiligramButtonColor


playButtonRules : Css.Mixin
playButtonRules =
    unstickyMilligramButton PlayButton Css.Colors.green


pauseButtonRules : Css.Mixin
pauseButtonRules =
    unstickyMilligramButton PauseButton Css.Colors.red


unstickyMilligramButton : a -> Color -> Css.Mixin
unstickyMilligramButton classSelector color =
    let
        colorReset =
            [ backgroundColor color, borderColor color ]
    in
        (unstuck colorReset) :: colorReset |> withClass classSelector



-- our custom size button (lifted from the Milligram.io examples page)


smallButtonRules : Css.Mixin
smallButtonRules =
    withClass SmallButton
        [ fontSize (Css.rem 0.8)
        , height (Css.rem 2.8)
        , lineHeight (Css.rem 2.8)
        , padding2 zero (Css.rem 1.5)
        ]
