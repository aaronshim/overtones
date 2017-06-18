module NavbarCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (div, button)
import CssSelectors exposing (CssClasses(..), CssIds(..))
import SharedCss exposing (..)


navbarRules : Css.Snippet
navbarRules =
    class Navbar
        [ width (pct 100)
        , backgroundColor defaultSoftWhite
        , borderBottom3 (px 1) solid defaultBorderGray
        , alignItems center
        , children
            [ div
                [ margin2 zero (px 5)
                , children [ button [ margin2 zero (px 5) ] ]
                ]
            , class NavbarTitle
                [ marginLeft (px 5)
                , marginRight (px 10)
                , marginTop zero
                , marginBottom zero
                ]
            ]
        ]


navbarNotMobileRules : Css.Snippet
navbarNotMobileRules =
    onlyForNotMobile <|
        class Navbar
            [ position fixed
            , top zero
            , height (px 50)
            , displayFlex
            , zIndex (int 99999) -- opaque
            ]


navbarMobileRules : Css.Snippet
navbarMobileRules =
    onlyForMobile <|
        class Navbar
            [ paddingBottom (px 10)
            , paddingRight (px 10)
            , children
                [ div
                    [ children [ button [ margin2 (px 5) zero ] ]
                    ]
                ]
            ]



-- push it down out of the navbar's way


mainContentRules : Css.Snippet
mainContentRules =
    onlyForNotMobile <|
        id MainContent
            [ marginTop (px 60)
            , maxWidth (pct 95)
            , marginLeft (pct 1)
            ]
