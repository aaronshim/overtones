module DebugUtils exposing (traceMe)

import Debug


-- old habit from Haskell projects


traceMe : String -> a -> a
traceMe str x =
    Debug.log (str ++ " " ++ (toString x)) x
