module Collection exposing (..)

import Dict exposing (Dict)


-- Generic collections type that will take care of lookups and deletes by specific index
-- as well as auto-insert by caching the next available index
-- It also holds some extra context too, for some extra state or whatnot you need attached to the collection of items
-- (at the very least, it will let you inject some new record type into the collection for extra fields)


type alias Index =
    Int


type alias CollectionWithContext a b =
    { items : Dict Index a
    , nextIndex : Index
    , context : b
    }



-- But we also need a type to represent collections that don't have contexts attached


type alias Collection a =
    CollectionWithContext a NoContext


type NoContext
    = NoContext



-- constructing and de-structuring


emptyCollectionWithContext : b -> CollectionWithContext a b
emptyCollectionWithContext context =
    fromDict context Dict.empty


fromDict : b -> Dict Index a -> CollectionWithContext a b
fromDict context dict =
    { items = dict, nextIndex = Dict.size dict, context = context }


fromDictWithoutContext : Dict Index a -> Collection a
fromDictWithoutContext =
    fromDict NoContext


toDict : CollectionWithContext a b -> Dict Index a
toDict =
    .items


context : CollectionWithContext a b -> b
context =
    .context



-- Dictionary manipulation functions, with the difference that insert here is an auto-add (no need for a key/index)


insert : a -> CollectionWithContext a b -> CollectionWithContext a b
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


removeLastInserted : CollectionWithContext a b -> CollectionWithContext a b
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


remove : Index -> CollectionWithContext a b -> CollectionWithContext a b
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


update : Index -> (a -> a) -> CollectionWithContext a b -> CollectionWithContext a b
update i f collection =
    { collection | items = Dict.update i (Maybe.map f) collection.items }
