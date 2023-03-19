module Theme exposing (Theme(..), toString, default)

type Theme 
    = Dark
    | Light

toString : Theme -> String
toString theme =
    case theme of
        Dark -> "dark"
        Light -> "light"

default : Theme
default =
    Dark