module Model exposing (..)

import Dict exposing (..)


type WaveType
    = SineWave
    | SawtoothWave


type alias Index =
    Int



-- our fundamental atomic unit for every wave


type alias Tone =
    { freq : Float, waveType : WaveType, strength : Float, playing : Bool }


emptyTone : Tone
emptyTone =
    { freq = 440.0, waveType = SineWave, strength = 1.0, playing = True }



-- I saw this pattern on https://github.com/Olical/elm-guide/blob/master/src/CounterList.elm


type alias IndexedTone =
    { index : Index, tone : Tone }


emptyToneWithIndex : Index -> IndexedTone
emptyToneWithIndex i =
    IndexedTone i emptyTone



-- wrap up the internal collection of tones with the next available index cached


type alias ToneCollection =
    { tones : Dict Index IndexedTone, nextIndex : Index }


addToneToCollection : ToneCollection -> ToneCollection
addToneToCollection collection =
    let
        newToneIndex =
            collection.nextIndex

        dictWithNewTone =
            Dict.insert newToneIndex (emptyToneWithIndex newToneIndex) collection.tones
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
    let
        indexedToneUpdateFunction =
            (Maybe.map (\it -> { it | tone = f it.tone }))

        updatedDict =
            Dict.update i indexedToneUpdateFunction collection.tones
    in
        { collection | tones = updatedDict }



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
