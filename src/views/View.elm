module View exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)
import CssSelectors
import Tone exposing (viewTone)
import Helpers exposing (id, class, classList)
import Collection


view : Model -> Html Msg
view model =
    let
        isPlaying =
            model.playing
    in
        div []
            [ button
                [ onClick
                    (if isPlaying then
                        PauseAll
                     else
                        PlayAll
                    )
                , Html.Attributes.class "button"
                , class
                    [ (if isPlaying then
                        CssSelectors.PauseButton
                       else
                        CssSelectors.PlayButton
                      )
                    , CssSelectors.SmallButton
                    ]
                ]
                [ text
                    (if isPlaying then
                        "Pause"
                     else
                        "Play"
                    )
                ]
            , button
                [ onClick AddTone
                , Html.Attributes.class "button"
                , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                ]
                [ text "Add Tone" ]
            , button
                [ onClick RemoveTone
                , disabled (numTones model < 1)
                , Html.Attributes.class "button"
                , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                ]
                [ text "Remove Tone" ]
            , div []
                (model.tones
                    |> Collection.toDict
                    |> Dict.map viewToneWithIndex
                    |> Dict.values
                )
            ]



-- pattern to make sure each of our tones are sending off messages that contain the right index


viewToneWithIndex : Index -> Tone -> Html Msg
viewToneWithIndex i tone =
    Html.map (ModifyTone i) (viewTone i tone)
