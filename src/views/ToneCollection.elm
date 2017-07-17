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


viewToneCollection : Model -> ToneCollection -> Html ToneCollectionMsg
viewToneCollection parentModel model =
    div [ class [ CssSelectors.ToneCollection ], Html.Attributes.class "row" ]
        [ div [ class [ CssSelectors.ToneCollectionButtonRow ], Html.Attributes.class "row" ]
            [ button
                [ onClick
                    (if isPlaying model then
                        ToneCollectionLevel PauseAll
                     else
                        ToneCollectionLevel PlayAll
                    )
                , Html.Attributes.disabled (not (isPlaying parentModel))
                , Html.Attributes.class "button"
                , class
                    [ (if isPlaying model then
                        CssSelectors.PauseButton
                       else
                        CssSelectors.PlayButton
                      )
                    , CssSelectors.SmallButton
                    ]
                ]
                [ text
                    (if isPlaying model then
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
            ]
        , div [ Html.Attributes.class "row" ]
            (model
                |> Collection.toDict
                |> Dict.map (viewToneWithIndex parentModel model)
                |> Dict.values
            )
        ]



-- pattern to make sure each of our tones are sending off messages that contain the right index


viewToneWithIndex : Model -> ToneCollection -> Index -> Tone -> Html ToneCollectionMsg
viewToneWithIndex pageModel parentModel i tone =
    Html.map (ModifyTone i) <| viewTone pageModel parentModel i tone
