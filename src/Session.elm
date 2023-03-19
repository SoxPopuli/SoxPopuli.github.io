module Session exposing (Session, init)

import Browser.Navigation as Nav
import Url exposing (Url)

import Theme exposing (Theme)

type alias Session =
    { key : Nav.Key
    , url : Url
    , theme : Theme
    }

init : Nav.Key -> Url -> Session
init key url =
    { key = key
    , url = url
    , theme = Theme.default
    }