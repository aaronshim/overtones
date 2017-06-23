module Example exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string, maybe, Fuzzer, conditional)
import Dict
import Collection exposing (..)


-- Custom Fuzzer


notEmptyList : Fuzzer a -> Fuzzer (List a)
notEmptyList fuzzer =
    conditional
        { retries = 10
        , fallback = identity -- not the greatest, but what choice do we have?
        , condition = (\xs -> List.length xs > 0)
        }
        (list fuzzer)



-- Dealing with fuzzing a stream of manipulations on the Collection


translateToAction : Maybe a -> (CollectionWithContext a b -> CollectionWithContext a b)
translateToAction n =
    case n of
        Just n_ ->
            insert n_

        Nothing ->
            removeLastInserted


isJust : Maybe a -> Bool
isJust x =
    case x of
        Just _ ->
            True

        Nothing ->
            False


numInserts : List (Maybe a) -> Int
numInserts =
    List.length << List.filter isJust


numRemoves : List (Maybe a) -> Int
numRemoves =
    List.length << List.filter (not << isJust)



-- For dealing with our custom Collection type


contains : a -> CollectionWithContext a b -> Bool
contains x collection =
    toDict collection |> Dict.values |> List.member x


suite : Test
suite =
    describe "Collection module"
        [ describe "Multiple inserts on collection"
            [ fuzz (list int) "Correct size after multiple inserts" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\x accm -> insert x accm) (emptyCollectionWithContext NoContext) xs
                    in
                        Expect.equal (List.length xs) (Dict.size <| toDict collectionAfterInsert)
            , fuzz (notEmptyList string) "Correct inclusion after multiple inserts" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\x accm -> insert x accm) (emptyCollectionWithContext NoContext) xs
                    in
                        Expect.all (List.map (\x collection -> Expect.true "The collection contains the item" <| contains x collection) xs) <| collectionAfterInsert
            ]
        , describe "Multiple inserts with RemoveLast"
            [ fuzz (list (maybe int)) "Correct size after multiple inserts and removeLast" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\f accm -> (translateToAction f) accm) (emptyCollectionWithContext NoContext) xs
                    in
                        Expect.atMost (numInserts xs) (Dict.size <| toDict collectionAfterInsert)
            , fuzz (list (maybe int)) "Correct next index after multiple inserts and removeLast" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\f accm -> (translateToAction f) accm) (emptyCollectionWithContext NoContext) xs
                    in
                        -- nextIndex should not be present in the dict currently
                        Expect.equal Nothing (Dict.get collectionAfterInsert.nextIndex (toDict collectionAfterInsert))
            ]
        ]
