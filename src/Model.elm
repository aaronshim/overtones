module Model exposing (..)

import Dict exposing (Dict)
import Collection exposing (Collection, Index)


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
    Collection Tone


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



-- our top-level model must have a condition for global playing


type alias Model =
    { tones : ToneCollection, playing : Bool }


numTones : Model -> Int
numTones model =
    model.tones |> Collection.toDict |> Dict.size


emptyModel : Model
emptyModel =
    { tones = Collection.fromDict Dict.empty
    , playing = True
    }
