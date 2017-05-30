module Model exposing (..)

import Dict exposing (..)


type WaveType
    = SineWave
    | SawtoothWave


type alias Index =
    Int


type alias Frequency =
    Float


type alias Volume =
    Float



-- our fundamental atomic unit for every wave


type alias Tone =
    { freq : Frequency, waveType : WaveType, volume : Volume, playing : Bool }


emptyTone : Tone
emptyTone =
    { freq = 440.0, waveType = SineWave, volume = 1.0, playing = True }



-- wrap up the internal collection of tones with the next available index cached


type alias ToneCollection =
    { tones : Dict Index Tone, nextIndex : Index }


addToneToCollection : ToneCollection -> ToneCollection
addToneToCollection collection =
    let
        newToneIndex =
            collection.nextIndex

        dictWithNewTone =
            Dict.insert newToneIndex emptyTone collection.tones
    in
        { collection | tones = dictWithNewTone, nextIndex = newToneIndex + 1 }


removeToneInCollection : ToneCollection -> ToneCollection
removeToneInCollection collection =
    let
        lastToneIndex =
            collection.nextIndex - 1

        dictWithoutLastTone =
            Dict.remove lastToneIndex collection.tones
    in
        { collection | tones = dictWithoutLastTone, nextIndex = lastToneIndex }


updateToneInCollection : Index -> (Tone -> Tone) -> ToneCollection -> ToneCollection
updateToneInCollection i f collection =
    { collection | tones = Dict.update i (Maybe.map f) collection.tones }



-- our top-level model must have a condition for global playing


type alias Model =
    { tones : ToneCollection, playing : Bool }


emptyModel : Model
emptyModel =
    { tones =
        { tones = Dict.empty
        , nextIndex = 0
        }
    , playing = False
    }
