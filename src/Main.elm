module Main exposing (..)

import Html
import Model exposing (emptyModel)
import Update exposing (update)
import View exposing (view)
import Rocket


main =
    Html.program
        { init = ( emptyModel, [ Cmd.none ] ) |> Rocket.batchInit
        , view = view
        , update = update >> Rocket.batchUpdate
        , subscriptions = \model -> Sub.none
        }
