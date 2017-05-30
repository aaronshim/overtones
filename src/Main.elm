module Main exposing (..)

import Html
import Model exposing (emptyModel)
import Update exposing (update)
import View exposing (view)


main =
    Html.program
        { init = ( emptyModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
