module Fuzzer exposing (..)

import Fuzz exposing (char, list, int, intRange, string, maybe, Fuzzer, conditional, tuple, map, map3)
import Char
import Collection exposing (..)


allUppercaseString : Fuzzer String
allUppercaseString =
    allCaseString 'A' Char.isUpper


allLowercaseString : Fuzzer String
allLowercaseString =
    allCaseString 'a' Char.isLower



{- These fuzzers are to generate two subsets of strings that are mutually exclusive -}


allCaseString : Char -> (Char -> Bool) -> Fuzzer String
allCaseString defaultRightCaseChar isRightCase =
    conditional
        { retries = 10
        , fallback = (\xs -> String.fromList [ defaultRightCaseChar ])
        , condition = (\xs -> String.length xs > 0)
        }
        (map (String.filter isRightCase << String.fromList) <| notEmptyList defaultRightCaseChar char)


notEmptyList : a -> Fuzzer a -> Fuzzer (List a)
notEmptyList defaultValue fuzzer =
    conditional
        { retries = 10
        , fallback = (\xs -> defaultValue :: xs)
        , condition = (\xs -> List.length xs > 0)
        }
        (list fuzzer)



{- Fuzzers for our custom Collection type -}


collection : Fuzzer a -> Fuzzer (Collection a)
collection fuzzerA =
    collectionWithContext fuzzerA (Fuzz.constant NoContext)


collectionWithContext : Fuzzer a -> Fuzzer b -> Fuzzer (CollectionWithContext a b)
collectionWithContext fuzzerA fuzzerB =
    let
        fuzzerElemsToInsert =
            list fuzzerA

        -- or maybe some better way to get indices that are likely?
        fuzzerRemoveIndices =
            list <| intRange 0 10

        insertCollection elemsToInsert context =
            List.foldl (\elem accm -> insert elem accm) (emptyCollectionWithContext context) elemsToInsert

        makeCollection elemsToInsert context removeIndices =
            List.foldl (\i accm -> (translateRemoveIndex accm i) accm) (insertCollection elemsToInsert context) removeIndices
    in
        map3 makeCollection fuzzerElemsToInsert fuzzerB fuzzerRemoveIndices


type alias CollectionModificationFunction a b =
    CollectionWithContext a b -> CollectionWithContext a b


translateToInsertsAndRemoveLast : Maybe a -> CollectionModificationFunction a b
translateToInsertsAndRemoveLast n =
    case n of
        Just n_ ->
            insert n_

        Nothing ->
            removeLastInserted


translateToInsertsAndRemoveIndex : CollectionWithContext a b -> a -> Maybe Int -> CollectionModificationFunction a b
translateToInsertsAndRemoveIndex collectionSoFar elemToInsert index =
    case index of
        Just index_ ->
            translateRemoveIndex collectionSoFar index_

        Nothing ->
            insert elemToInsert


translateRemoveIndex : CollectionWithContext a b -> Int -> CollectionModificationFunction a b
translateRemoveIndex collectionSoFar index =
    if isValidIndex index collectionSoFar then
        remove index
    else
        removeLastInserted


isJust : Maybe a -> Bool
isJust x =
    case x of
        Just _ ->
            True

        Nothing ->
            False


numInsertsForInsertsAndRemoveLast : List (Maybe a) -> Int
numInsertsForInsertsAndRemoveLast =
    List.length << List.filter isJust


numInsertsForInsertsAndRemoveIndex : List ( a, Maybe Int ) -> Int
numInsertsForInsertsAndRemoveIndex =
    List.length << List.filter (\( _, indexToRemove ) -> not <| isJust indexToRemove)
