module SharedCss exposing (..)

import Css exposing (..)


-- our default purple


defaultColor : Color
defaultColor =
    hex "9b4dca"



-- These are to wrap around rules that we do not want to use for responsive layouts
-- (It means we will just defer to the CSS framework-- so this should be only for layout rules)


onlyForNotMobile : Snippet -> Snippet
onlyForNotMobile rules =
    mediaQuery "(min-width: 40.0rem)" [ rules ]
