module SharedCss exposing (..)

import Css exposing (..)


-- our default purple


defaultColor : Color
defaultColor =
    hex "9b4dca"


defaultGray : Color
defaultGray =
    hex "606c76"


defaultBorderGray : Color
defaultBorderGray =
    hex "d1d1d1"


defaultSoftWhite : Color
defaultSoftWhite =
    hex "f4f5f6"



-- These are to wrap around rules that we do not want to use for responsive layouts
-- (It means we will just defer to the CSS framework-- so this should be only for layout rules)


onlyForNotMobile : Snippet -> Snippet
onlyForNotMobile rules =
    mediaQuery "(min-width: 40.0rem)" [ rules ]



-- and the counterpart


onlyForMobile : Snippet -> Snippet
onlyForMobile rules =
    mediaQuery "(max-width: 40.0rem)" [ rules ]
