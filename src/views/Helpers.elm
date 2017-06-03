module Helpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (selected, value)
import Html.CssHelpers
import Html.Events exposing (on, targetValue)
import Json.Decode
import CssSelectors


-- to make our CSS work in the view code


{ id, class, classList } =
    Html.CssHelpers.withNamespace CssSelectors.namespace



-- reusable drop-down select components?


selectPicker : (String -> a) -> List ( String, Bool ) -> Html a
selectPicker msgMatcher options =
    let
        onInputFun =
            Json.Decode.map msgMatcher targetValue
    in
        select
            [ on "change" onInputFun ]
            (List.map selectPickerOption options)


selectPickerOption : ( String, Bool ) -> Html a
selectPickerOption ( textValue, isSelected ) =
    let
        defaultSelect =
            if isSelected then
                [ selected True ]
            else
                []
    in
        option ((value textValue) :: defaultSelect) [ text textValue ]
