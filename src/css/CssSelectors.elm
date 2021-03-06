module CssSelectors exposing (CssClasses(..), CssIds(..), namespace)

-- namespace string (to be exported)


namespace : String
namespace =
    "mainPage"



-- classes and id selectors (to be exported)


type CssClasses
    = Navbar
    | NavbarTitle
    | PlayButton
    | PauseButton
    | UnstickyButton
    | SmallButton
    | ToneCollection
    | ToneCollectionButtonRow
    | Tone
    | ToneButtonRow
    | ToneInputRow
    | ToneInput
    | ToneInputWide
    | ToneInputRightJustified
    | ToneInputSizeInitial


type CssIds
    = MainContent
