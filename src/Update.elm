module Update exposing (..)

import Model exposing (..)


type Msg
    = AddTone
    | RemoveTone
    | PlayAll
    | PauseAll
    | ModifyTone Index ToneMsg


type ToneMsg
    = SetFreq String
    | SetWaveType WaveType
    | SetVolume String
    | Play
    | Pause
    | Remove


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

                ModifyTone i Remove ->
                    -- sorry but we have to special case this
                    { model | tones = removeSpecificToneInCollection i model.tones }

                ModifyTone i toneMsg ->
                    { model | tones = updateToneInCollection i (updateTone toneMsg) model.tones }
    in
        ( updatedModel, Cmd.none )


updateTone : ToneMsg -> Tone -> Tone
updateTone msg tone =
    case msg of
        SetFreq freqStr ->
            case String.toFloat freqStr of
                Ok f ->
                    { tone | freq = f }

                _ ->
                    tone

        SetWaveType wt ->
            { tone | waveType = wt }

        SetVolume volStr ->
            case String.toFloat volStr of
                Ok v ->
                    { tone | volume = v }

                _ ->
                    tone

        Play ->
            { tone | playing = True }

        Pause ->
            { tone | playing = False }

        _ ->
            -- Remove and possibly other NoOp cases
            tone
