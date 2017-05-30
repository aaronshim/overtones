module Update exposing (..)

import Model exposing (..)


type Msg
    = AddTone
    | RemoveTone
    | PlayAll
    | PauseAll
    | Modify Index ToneMsg


type ToneMsg
    = SetFreq Float
    | SetWaveType WaveType
    | Play
    | Pause


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updatedModel =
            case msg of
                AddTone ->
                    { model | tones = addToneToCollection model.tones }

                RemoveTone ->
                    { model | tones = removeToneInCollection model.tones }

                PlayAll ->
                    { model | playing = True }

                PauseAll ->
                    { model | playing = False }

                Modify i toneMsg ->
                    { model | tones = updateToneInCollection i (updateTone toneMsg) model.tones }
    in
        ( updatedModel, Cmd.none )


updateTone : ToneMsg -> Tone -> Tone
updateTone msg tone =
    case msg of
        SetFreq f ->
            { tone | freq = f }

        SetWaveType wt ->
            { tone | waveType = wt }

        Play ->
            { tone | playing = True }

        Pause ->
            { tone | playing = False }
