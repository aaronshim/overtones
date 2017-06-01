module MainCss exposing (namespace, css)

import Css exposing (Stylesheet, stylesheet)
import Css.Namespace
import ButtonCss exposing (buttonRules)


-- namespace string (to be exported)


namespace : String
namespace =
    "mainPage"



-- main stylesheet definition (to be exported for compilation in Stylesheets.elm)


css : Stylesheet
css =
    (stylesheet << Css.Namespace.namespace namespace)
        [ buttonRules ]
