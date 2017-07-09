module Tests exposing (..)

import Test exposing (..)
import CollectionTest exposing (collectionTests)


suite : Test
suite =
    describe "Overtones"
        [ collectionTests
        ]
