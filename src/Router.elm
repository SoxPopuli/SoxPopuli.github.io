module Router exposing (Route(..), route)

import Url
import Url.Parser as Parser exposing (Parser, map, oneOf, (</>), (<?>), s, string)
import Url.Parser.Query as Query


type Route 
    = Home
    | About
    | NotFound


route : Url.Url -> Route
route url =
    if url.path /= "/" then
        NotFound
    else
    case url.query of
        Nothing -> Home
        Just "/home" -> Home
        Just "/about" -> About
        
        _ -> NotFound