module View exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)
import CssSelectors
import ToneCollection exposing (viewToneCollection)
import Helpers exposing (id, class, classList)
import Collection exposing (Index)


view : Model -> Html Msg
view model =
    main_ []
        [ viewNavBar model
        , viewMainContent model
        ]


viewNavBar : Model -> Html Msg
viewNavBar model =
    let
        isPlaying =
            model.context == Playing
    in
        nav [ class [ CssSelectors.Navbar ] ]
            [ h3 [ class [ CssSelectors.NavbarTitle ] ]
                [ text "Overtones" ]
            , div
                [ Html.Attributes.class "row" ]
                [ button
                    [ onClick
                        (if isPlaying then
                            TopLevel PauseAll
                         else
                            TopLevel PlayAll
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
                    [ onClick (TopLevel Add)
                    , Html.Attributes.class "button"
                    , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                    ]
                    [ text "Add Collection" ]
                , button
                    [ onClick (TopLevel RemoveLast)
                    , disabled (numToneCollections model < 1)
                    , Html.Attributes.class "button"
                    , class [ CssSelectors.UnstickyButton, CssSelectors.SmallButton ]
                    ]
                    [ text "Remove Collection" ]
                ]
            ]


viewMainContent : Model -> Html Msg
viewMainContent model =
    div [ Html.Attributes.class "container", id CssSelectors.MainContent ] <|
        Dict.foldl (\i collection list -> (viewToneCollectionWithIndex i collection) :: list) [] <|
            Collection.toDict model



-- wrap up the messages with the right index for the ToneCollectionLevel to TopLevel message conversion


viewToneCollectionWithIndex : Index -> ToneCollection -> Html Msg
viewToneCollectionWithIndex i collection =
    Html.map (ModifyToneCollection i) <| viewToneCollection collection
