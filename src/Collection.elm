module Collection exposing (..)

import Dict exposing (Dict)


-- Generic collections type that will take care of lookups and deletes by specific index as well as auto-insert by caching the next available index


type alias Index =
    Int


type alias Collection a =
    { items : Dict Index a
    , nextIndex : Index
    }


fromDict : Dict Index a -> Collection a
fromDict dict =
    { items = dict, nextIndex = Dict.size dict }


toDict : Collection a -> Dict Index a
toDict =
    .items


insert : a -> Collection a -> Collection a
insert item collection =
    let
        newIndex =
            collection.nextIndex

        dictWithNewItem =
            Dict.insert newIndex item collection.items
    in
        { collection | items = dictWithNewItem, nextIndex = newIndex + 1 }



-- This used to be written with the elm-guards package, but that is dangerous in cases like this
-- when the last (default) branch is a recursive loop because Elm is not lazy so it will stack overflow


removeLastInserted : Collection a -> Collection a
removeLastInserted collection =
    let
        lastInsertedIndex =
            collection.nextIndex - 1
    in
        if lastInsertedIndex < 0 then
            collection
        else if Dict.member lastInsertedIndex collection.items then
            remove lastInsertedIndex collection
            -- keep looking if the "last inserted" tone was already removed
        else
            removeLastInserted { collection | nextIndex = lastInsertedIndex }


remove : Index -> Collection a -> Collection a
remove i collection =
    let
        correctedNextIndex =
            if i == collection.nextIndex - 1 then
                collection.nextIndex - 1
            else
                collection.nextIndex
    in
        { collection | items = Dict.remove i collection.items, nextIndex = correctedNextIndex }



-- we can think about moving the type signature of (a -> a) to (Maybe a -> Maybe a) if the need arises


update : Index -> (a -> a) -> Collection a -> Collection a
update i f collection =
    { collection | items = Dict.update i (Maybe.map f) collection.items }
