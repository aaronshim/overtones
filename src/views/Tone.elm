module Tone exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (..)
import Update exposing (..)
import CssSelectors
import Helpers exposing (id, class, classList, selectPicker)
import Collection exposing (Index)


-- most atomic composable unit of the view that is responsible for each wave


viewTone : Index -> Tone -> Html ToneMsg
viewTone i tone =
    let
        isPlaying =
            tone.playing == Playing
    in
        div [ Html.Attributes.class "column" ]
            [ div [ class [ CssSelectors.Tone ] ]
                [ button
                    [ onClick
                        (if isPlaying then
                            Pause
                         else
                            Play
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
                    [ onClick Remove
                    , Html.Attributes.class "button"
                    , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                    ]
                    [ text "Remove" ]
                , selectPicker
                    (\s ->
                        case s of
                            "Sawtooth" ->
                                SetWaveType SawtoothWave

                            _ ->
                                SetWaveType SineWave
                    )
                    [ ( "Sine", tone.waveType == SineWave )
                    , ( "Sawtooth", tone.waveType == SawtoothWave )
                    ]
                , label []
                    [ input
                        [ type_ "range"
                        , Html.Attributes.min "220"
                        , Html.Attributes.max "880"
                        , onInput SetFreq
                        , tone.freq |> toString |> value
                        ]
                        []
                    , text ("Frequency: " ++ (toString tone.freq))
                    ]
                , label []
                    [ input
                        [ type_ "range"
                        , Html.Attributes.min "0.0"
                        , Html.Attributes.max "1.0"
                        , Html.Attributes.step "0.01"
                        , onInput SetVolume
                        , tone.volume |> toString |> value
                        ]
                        []
                    , text ("Volume: " ++ (toString tone.volume))
                    ]
                ]
            ]
