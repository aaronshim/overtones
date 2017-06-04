module Model exposing (..)

import Dict exposing (Dict)
import Collection exposing (Collection, CollectionWithContext, Index)


type WaveType
    = SineWave
    | SawtoothWave
    | SquareWave


type alias Frequency =
    Float


type alias Volume =
    Float


type PlayingContext
    = Playing
    | Paused



-- our fundamental atomic unit for every wave


type alias Tone =
    { freq : Frequency, waveType : WaveType, volume : Volume, playing : PlayingContext }


emptyTone : Tone
emptyTone =
    { freq = 440.0, waveType = SineWave, volume = 1.0, playing = Playing }



-- wrap up the internal collection of tones with the next available index cached


type alias ToneCollection =
    CollectionWithContext Tone PlayingContext


emptyToneCollection : ToneCollection
emptyToneCollection =
    Collection.emptyCollectionWithContext Playing


addToneToCollection : ToneCollection -> ToneCollection
addToneToCollection =
    Collection.insert emptyTone


removeToneInCollection : ToneCollection -> ToneCollection
removeToneInCollection =
    Collection.removeLastInserted


removeSpecificToneInCollection : Index -> ToneCollection -> ToneCollection
removeSpecificToneInCollection =
    Collection.remove


updateToneInCollection : Index -> (Tone -> Tone) -> ToneCollection -> ToneCollection
updateToneInCollection =
    Collection.update


numTones : ToneCollection -> Int
numTones =
    Collection.toDict >> Dict.size



-- our top-level model must have a condition for global playing


type alias Model =
    CollectionWithContext ToneCollection PlayingContext


emptyModel : Model
emptyModel =
    Collection.emptyCollectionWithContext Playing


addToneCollection : Model -> Model
addToneCollection =
    Collection.insert emptyToneCollection


removeToneCollection : Model -> Model
removeToneCollection =
    Collection.removeLastInserted


removeSpecificToneCollection : Index -> Model -> Model
removeSpecificToneCollection =
    Collection.remove


updateToneCollectionInModel : Index -> (ToneCollection -> ToneCollection) -> Model -> Model
updateToneCollectionInModel =
    Collection.update


numToneCollections : Model -> Int
numToneCollections =
    Collection.toDict >> Dict.size


numTotalTones : Model -> Int
numTotalTones =
    Collection.toDict
        >> Dict.foldl (\_ toneCollection accm -> accm + numTones toneCollection) 0
