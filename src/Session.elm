module Session exposing (Session, init)

import Browser.Navigation as Nav
import Url exposing (Url)

type alias Session =
    { key : Nav.Key
    , url : Url
    }

init : Nav.Key -> Url -> Session
init key url =
    { key = key
    , url = url
    }