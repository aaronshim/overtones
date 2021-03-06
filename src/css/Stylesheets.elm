port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Css exposing (Stylesheet, stylesheet)
import Css.Namespace
import CssSelectors exposing (namespace)
import NavbarCss exposing (navbarRules, navbarNotMobileRules, navbarMobileRules, mainContentRules)
import ButtonCss exposing (buttonRules)
import ToneCss exposing (toneRules, toneSizeRules, toneInputRowRules, toneButtonRowRules, toneInputRules)
import ToneCollectionCss exposing (toneCollectionRules, toneCollectionButtonRowRules)


-- main stylesheet definition (to be exported for compilation in Stylesheets.elm)
-- This is wher we collect all of the different modules' styles rules into the top-level
-- structure before passing it off to the compilation step in Stylesheets.elm


css : Stylesheet
css =
    (stylesheet << Css.Namespace.namespace namespace)
        [ navbarRules
        , navbarNotMobileRules
        , navbarMobileRules
        , mainContentRules
        , buttonRules
        , toneCollectionRules
        , toneCollectionButtonRowRules
        , toneRules
        , toneSizeRules
        , toneInputRowRules
        , toneButtonRowRules
        , toneInputRules
        ]



-- This is where we run the compilation to a .css file


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "styles.css", Css.File.compile [ css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
