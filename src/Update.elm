module Update exposing (..)

import Rocket exposing ((=>))
import Model exposing (..)
import Collection exposing (Index)
import WebAudioPorts exposing (modelToRep, controlAudioApi)


-- This is the shared commands that any collection or collection of collection of tones should respond to (for reuse)


type CollectionMsg
    = Add
    | RemoveLast
    | PlayAll
    | PauseAll



-- Top-level model messages (collection of collections of tones)


type Msg
    = TopLevel CollectionMsg
    | ModifyToneCollection Index ToneCollectionMsg



-- ToneCollection model messages (collection of tones)


type ToneCollectionMsg
    = ToneCollectionLevel CollectionMsg
    | RemoveToneCollection
    | ModifyTone Index ToneMsg



-- Tone model messages (individual tone)


type ToneMsg
    = SetFreq String
    | SetWaveType WaveType
    | SetVolume String
    | Play
    | Pause
    | Remove



-- Update functions for each of our three levels


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    -- switch this back to Rocket syntax if we ever need more specific Cmd chained
    let
        newModel =
            case msg of
                TopLevel Add ->
                    addToneCollection model

                TopLevel RemoveLast ->
                    removeToneCollection model

                TopLevel PlayAll ->
                    { model | context = Playing }

                TopLevel PauseAll ->
                    { model | context = Paused }

                ModifyToneCollection i RemoveToneCollection ->
                    removeSpecificToneCollection i model

                ModifyToneCollection i collectionMsg ->
                    updateToneCollectionInModel i (updateToneCollection collectionMsg) model
    in
        newModel => [ controlAudioApi <| modelToRep newModel ]


updateToneCollection : ToneCollectionMsg -> ToneCollection -> ToneCollection
updateToneCollection msg model =
    case msg of
        ToneCollectionLevel Add ->
            addToneToCollection model

        ToneCollectionLevel RemoveLast ->
            removeToneInCollection model

        ToneCollectionLevel PlayAll ->
            { model | context = Playing }

        ToneCollectionLevel PauseAll ->
            { model | context = Paused }

        ModifyTone i Remove ->
            -- replace with better parent-child communications for refactoring
            removeSpecificToneInCollection i model

        ModifyTone i toneMsg ->
            updateToneInCollection i (updateTone toneMsg) model

        RemoveToneCollection ->
            -- replace with better parent-child communications for refactoring
            model


updateTone : ToneMsg -> Tone -> Tone
updateTone msg model =
    case msg of
        SetFreq freqStr ->
            case String.toFloat freqStr of
                Ok f ->
                    { model | freq = f }

                _ ->
                    model

        SetWaveType wt ->
            { model | waveType = wt }

        SetVolume volStr ->
            case String.toFloat volStr of
                Ok v ->
                    { model | volume = v }

                _ ->
                    model

        Play ->
            { model | playing = Playing }

        Pause ->
            { model | playing = Paused }

        Remove ->
            -- replace with better parent-child communications for refactoring
            model
