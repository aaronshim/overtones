module Tone exposing (viewTone)

import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput, onBlur)
import Model exposing (..)
import Update exposing (..)
import CssSelectors
import Helpers exposing (id, class, classList, selectPicker, onBlurWithTargetValue)
import Collection exposing (Index)


-- most atomic composable unit of the view that is responsible for each wave


viewTone : Model -> ToneCollection -> Index -> Tone -> Html ToneMsg
viewTone pageModel parentModel i tone =
    div [ class [ CssSelectors.Tone ] ]
        [ viewToneButtonRow pageModel parentModel tone
        , viewFrequencyRow tone
        , viewWaveTypeRow tone
        , viewVolumeRow tone
        ]



-- The first row with the "Play" and "Remove" buttons


viewToneButtonRow : Model -> ToneCollection -> Tone -> Html ToneMsg
viewToneButtonRow pageModel parentModel tone =
    let
        isPlaying =
            tone.playing == Playing
    in
        div [ class [ CssSelectors.ToneButtonRow ], Html.Attributes.class "row" ]
            [ button
                [ class
                    [ CssSelectors.ToneInput
                    , CssSelectors.ToneInputSizeInitial
                    ]
                , onClick
                    (if isPlaying then
                        Pause
                     else
                        Play
                    )
                , Html.Attributes.disabled
                    (not (Model.isPlaying pageModel && Model.isPlaying parentModel))
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
                [ class
                    [ CssSelectors.ToneInput
                    , CssSelectors.ToneInputRightJustified
                    , CssSelectors.ToneInputSizeInitial
                    ]
                , onClick Remove
                , Html.Attributes.class "button"
                , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                ]
                [ text "Remove" ]
            ]



-- Input collection for setting the frequency


viewFrequencyRow : Tone -> Html ToneMsg
viewFrequencyRow tone =
    label []
        [ text "Frequency"
        , div [ class [ CssSelectors.ToneInputRow ], Html.Attributes.class "row" ]
            [ input
                [ class [ CssSelectors.ToneInput, CssSelectors.ToneInputWide ]
                , type_ "number"
                , onBlurWithTargetValue SetFreq
                , tone.freq |> toString |> value
                ]
                []
            , button
                [ class
                    [ CssSelectors.ToneInput
                    , CssSelectors.SmallButton
                    , CssSelectors.UnstickyButton
                    ]
                ]
                [ text "+" ]
            , button
                [ class
                    [ CssSelectors.ToneInput
                    , CssSelectors.SmallButton
                    , CssSelectors.UnstickyButton
                    ]
                ]
                [ text "-" ]
            ]
        ]



-- Input collection for setting the volume


viewVolumeRow : Tone -> Html ToneMsg
viewVolumeRow tone =
    label []
        [ text "Volume"
        , div [ class [ CssSelectors.ToneInputRow ], Html.Attributes.class "row" ]
            [ input
                [ class [ CssSelectors.ToneInput ]
                , type_ "number"
                , onBlurWithTargetValue SetVolume
                , tone.volume |> toString |> value
                ]
                []
            , input
                [ class [ CssSelectors.ToneInput, CssSelectors.ToneInputWide ]
                , type_ "range"
                , Html.Attributes.min "0.0"
                , Html.Attributes.max "1.0"
                , Html.Attributes.step "0.01"
                , onInput SetVolume
                , tone.volume |> toString |> value
                ]
                []
            ]
        ]



-- Input collection for setting the wave type


viewWaveTypeRow : Tone -> Html ToneMsg
viewWaveTypeRow tone =
    label []
        [ text "Wave Type"
        , selectPicker
            (\s ->
                case s of
                    "Sawtooth" ->
                        SetWaveType SawtoothWave

                    "Square" ->
                        SetWaveType SquareWave

                    _ ->
                        SetWaveType SineWave
            )
            [ ( "Sine", tone.waveType == SineWave )
            , ( "Sawtooth", tone.waveType == SawtoothWave )
            , ( "Square", tone.waveType == SquareWave )
            ]
        ]
