module Example exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string)


suite : Test
suite =
    describe "Sample module"
        [ describe "Addition group laws"
            [ fuzz2 int int "Commutation" <|
                \x y -> Expect.equal (x + y) (y + x)
            , fuzz int "Identity" <|
                \x -> Expect.equal (x + 0) x
            , fuzz3 int int int "Associativity" <|
                \x y z -> Expect.equal (x + (y + z)) ((x + y) + z)
            ]
        ]
