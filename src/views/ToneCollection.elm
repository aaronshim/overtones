module ToneCollection exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)
import CssSelectors
import Tone exposing (viewTone)
import Helpers exposing (id, class, classList)
import Collection exposing (Index)


viewToneCollection : ToneCollection -> Html ToneCollectionMsg
viewToneCollection model =
    let
        isPlaying =
            model.context == Playing
    in
        div []
            [ button
                [ onClick
                    (if isPlaying then
                        ToneCollectionLevel PauseAll
                     else
                        ToneCollectionLevel PlayAll
                    )
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
                [ onClick (ToneCollectionLevel Add)
                , Html.Attributes.class "button"
                , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                ]
                [ text "Add Tone" ]
            , button
                [ onClick (ToneCollectionLevel RemoveLast)
                , disabled (numTones model < 1)
                , Html.Attributes.class "button"
                , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                ]
                [ text "Remove Tone" ]
            , button
                [ onClick RemoveToneCollection
                , Html.Attributes.class "button"
                , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                ]
                [ text "Remove" ]
            , div []
                (model
                    |> Collection.toDict
                    |> Dict.map viewToneWithIndex
                    |> Dict.values
                )
            ]



-- pattern to make sure each of our tones are sending off messages that contain the right index


viewToneWithIndex : Index -> Tone -> Html ToneCollectionMsg
viewToneWithIndex i tone =
    Html.map (ModifyTone i) <| viewTone i tone
