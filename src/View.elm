module View exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (checked, disabled, name, selected, type_, value)
import Html.Events exposing (onClick, onInput, on, targetValue)
import Json.Decode
import Model exposing (..)
import Update exposing (..)


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
                ]
                [ text
                    (if isPlaying then
                        "Pause"
                     else
                        "Play"
                    )
                ]
            , button
                [ onClick AddTone ]
                [ text "Add Tone" ]
            , button
                [ onClick RemoveTone, disabled (numTones model < 1) ]
                [ text "Remove Tone" ]
            , div []
                (model.tones
                    |> toneCollectionToDict
                    |> Dict.map viewToneWithIndex
                    |> Dict.values
                )
            ]



-- pattern to make sure each of our tones are sending off messages that contain the right index


viewToneWithIndex : Index -> Tone -> Html Msg
viewToneWithIndex i tone =
    Html.map (ModifyTone i) (viewTone i tone)



-- most atomic composable unit of the view that is responsible for each wave


viewTone : Index -> Tone -> Html ToneMsg
viewTone i tone =
    let
        isPlaying =
            tone.playing
    in
        div []
            [ button
                [ onClick
                    (if isPlaying then
                        Pause
                     else
                        Play
                    )
                ]
                [ text
                    (if isPlaying then
                        "Pause"
                     else
                        "Play"
                    )
                ]
            , button [ onClick Remove ] [ text "Remove" ]
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



-- helpers


selectPicker : (String -> a) -> List ( String, Bool ) -> Html a
selectPicker msgMatcher options =
    let
        onInputFun =
            Json.Decode.map msgMatcher targetValue
    in
        select
            [ on "change" onInputFun ]
            (List.map selectPickerOption options)


selectPickerOption : ( String, Bool ) -> Html a
selectPickerOption ( textValue, isSelected ) =
    let
        defaultSelect =
            if isSelected then
                [ selected True ]
            else
                []
    in
        option ((value textValue) :: defaultSelect) [ text textValue ]
