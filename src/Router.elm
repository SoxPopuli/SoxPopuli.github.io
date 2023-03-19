module Router exposing (Route(..), route)

import Url
import Url.Parser as Parser exposing (Parser, map, oneOf, (</>), (<?>), s, string)
import Url.Parser.Query as Query


type Route 
    = Home
    | About
    | Tools
    | NotFound

fromQuery : Maybe String -> Route
fromQuery query =
    case query of
        Just "home" -> Home
        Just "about" -> About
        Just "tools" -> Tools

        _ -> NotFound

parser : Parser.Parser (Route -> a) a
parser =
    oneOf
        [ map fromQuery (Parser.top <?> Query.string "page")
        , map Home Parser.top
        ]

route : Url.Url -> Route
route url =
    Parser.parse parser url
    |> Maybe.withDefault NotFound