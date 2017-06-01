-- Straight from the rtfeldman/elm-css repo to make elm-css compilation work


port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import MainCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "styles.css", Css.File.compile [ MainCss.css ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
