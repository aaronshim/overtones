port module WebAudioPorts exposing (..)

import Dict
import Model exposing (Tone, WaveType(..), PlayingContext(..), ToneCollection, Model)
import Collection


-- Our JSON representation type


type alias ToneRep =
    { waveType : String
    , frequency : Float
    , volume : Float
    }



-- Translation layers between our Model types and the JSON representation types


waveTypeToStr : WaveType -> String
waveTypeToStr waveType =
    case waveType of
        SineWave ->
            "sine"

        SawtoothWave ->
            "sawtooth"


toToneRep : Tone -> ToneRep
toToneRep { freq, waveType, volume, playing } =
    { waveType = waveTypeToStr waveType
    , frequency = freq
    , volume = volume
    }


toneCollectionToRep : ToneCollection -> List ToneRep
toneCollectionToRep collection =
    Dict.foldl
        (\_ tone accm ->
            if tone.playing == Playing then
                (toToneRep tone) :: accm
            else
                accm
        )
        []
    <|
        Collection.toDict collection


modelToRep : Model -> List ToneRep
modelToRep model =
    Dict.foldl
        (\_ collection accmList ->
            accmList
                ++ toneCollectionToRep collection
        )
        []
    <|
        Collection.toDict model



-- and our actual FFI layer to JavaScript!


port controlAudioApi : List ToneRep -> Cmd a
