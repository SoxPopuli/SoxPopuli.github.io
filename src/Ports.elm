port module Ports exposing (setTheme)
import Theme exposing (Theme(..))

setTheme : Theme -> Cmd msg
setTheme theme =
    case theme of
        Theme.Dark -> setTheme_ "dark"
        Theme.Light -> setTheme_ "light"

port setTheme_ : String -> Cmd msg