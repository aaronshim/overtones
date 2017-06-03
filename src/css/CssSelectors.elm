module CssSelectors exposing (CssClasses(..), CssIds(..), namespace)

-- namespace string (to be exported)


namespace : String
namespace =
    "mainPage"



-- classes and id selectors (to be exported)


type CssClasses
    = PlayButton
    | PauseButton
    | UnstickyButton
    | SmallButton


type CssIds
    = Page
