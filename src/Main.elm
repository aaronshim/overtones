module Main exposing (..)

import Html exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- model


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- update


type Msg
    = NoOp
    | Message2
    | Message3


update : Msg -> Model -> ( Model, Cmd Msg )
update _ _ =
    ( 0, Cmd.none )



-- view


view : Model -> Html Msg
view _ =
    text "Hello, world!"



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
