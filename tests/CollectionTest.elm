module CollectionTest exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string, maybe, Fuzzer, conditional, tuple)
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


translateToInsertsAndRemoveLast : Maybe a -> (CollectionWithContext a b -> CollectionWithContext a b)
translateToInsertsAndRemoveLast n =
    case n of
        Just n_ ->
            insert n_

        Nothing ->
            removeLastInserted


translateToInsertsAndRemoveIndex : CollectionWithContext a b -> a -> Maybe Int -> (CollectionWithContext a b -> CollectionWithContext a b)
translateToInsertsAndRemoveIndex collectionSoFar elemToInsert index =
    case index of
        Just index_ ->
            if isValidIndex index_ collectionSoFar then
                remove index_
            else
                removeLastInserted

        Nothing ->
            insert elemToInsert


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



-- For dealing with our custom Collection type


contains : a -> CollectionWithContext a b -> Bool
contains x collection =
    toDict collection |> Dict.values |> List.member x


isValidIndex : Int -> CollectionWithContext a b -> Bool
isValidIndex i collection =
    toDict collection |> Dict.keys |> List.member i


collectionTests : Test
collectionTests =
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
                            List.foldl (\f accm -> (translateToInsertsAndRemoveLast f) accm) (emptyCollectionWithContext NoContext) xs
                    in
                        Expect.atMost (numInsertsForInsertsAndRemoveLast xs) (Dict.size <| toDict collectionAfterInsert)
            , fuzz (list (maybe int)) "Correct next index after multiple inserts and removeLast" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\f accm -> (translateToInsertsAndRemoveLast f) accm) (emptyCollectionWithContext NoContext) xs
                    in
                        -- nextIndex should not be present in the dict currently
                        Expect.equal Nothing (Dict.get collectionAfterInsert.nextIndex (toDict collectionAfterInsert))
            ]
        , describe "Multiple inserts with Remove (index) and RemoveLast"
            {- we are going to use a tuple fuzzer here because we need things in the shape [(a, Maybe Int)] because there should be
               as many of the a as there are Maybe Int's since two of them combined together form a correct input to the fuzzing test.
               (a is what gets inserted and Maybe Int is an index to remove or a Nothing to signify an insert)
               (to clean it up, I guess we can write our own fuzzer? It's harder for this one that has a dependence on the current
               state of the collection to make a valid command, though...)
            -}
            [ fuzz (list (tuple ( int, maybe int ))) "Correct size after multiple inserts and removeLast and remove (by index)" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\( toInsert, f ) accm -> (translateToInsertsAndRemoveIndex accm toInsert f) accm)
                                (emptyCollectionWithContext NoContext)
                                xs
                    in
                        Expect.atMost (numInsertsForInsertsAndRemoveIndex xs) (Dict.size <| toDict collectionAfterInsert)
            , fuzz (list (tuple ( int, maybe int ))) "Correct next index after multiple inserts and removeLast and remove (by index)" <|
                \xs ->
                    let
                        collectionAfterInsert =
                            List.foldl (\( toInsert, f ) accm -> (translateToInsertsAndRemoveIndex accm toInsert f) accm)
                                (emptyCollectionWithContext NoContext)
                                xs
                    in
                        -- nextIndex should not be present in the dict currently
                        Expect.equal Nothing (Dict.get collectionAfterInsert.nextIndex (toDict collectionAfterInsert))
            ]
        ]
