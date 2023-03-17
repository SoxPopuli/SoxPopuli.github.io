module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Html.Lazy as Lazy
import Url

import Router
import Session exposing (Session)

import Pages.About as About
import Pages.Home as Home
import Pages.NotFound as NotFound

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }

-- MODEL

type Model 
    = Home Home.Model
    | About About.Model
    | NotFound NotFound.Model

fromRoute : Router.Route -> Session -> Model
fromRoute route session =
    case route of
        Router.Home -> Home <| Home.init session
        Router.About -> About <| About.init session
        Router.NotFound -> NotFound <| NotFound.init session

toSession : Model -> Session
toSession model =
    case model of
        Home m -> m.session
        About m -> m.session
        NotFound m -> m.session

updateSession : Model -> (Session -> Session) -> Model
updateSession model fn =
    let 
        update_ m s = { m | session = s }
    in
    case model of
        Home m -> Home (update_ m <| fn m.session)
        About m -> About (update_ m <| fn m.session)
        NotFound m -> NotFound (update_ m <| fn m.session)

-- INIT

init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        session = Session.init key url
        route = (Router.route url)

    in
    ( fromRoute route session, Cmd.none )

-- MSG

type Msg
    = GotHomeMsg Home.Msg
    | GotAboutMsg About.Msg
    | GotNotFoundMsg NotFound.Msg
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (model, msg) of
        (Home subModel, GotHomeMsg subMsg) ->
            Tuple.mapBoth
                Home
                (Cmd.map GotHomeMsg)
                (Home.update subMsg subModel)

        (About subModel, GotAboutMsg subMsg) ->
            Tuple.mapBoth
                About
                (Cmd.map GotAboutMsg)
                (About.update subMsg subModel)

        (NotFound subModel, GotNotFoundMsg subMsg) ->
            Tuple.mapBoth
                NotFound
                (Cmd.map GotNotFoundMsg)
                (NotFound.update subMsg subModel)
        
        (_, UrlRequested urlRequest) ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        session = toSession model
                    in
                    ( model, Nav.pushUrl session.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        (_, UrlChanged url) ->
            let
                session = toSession model
                route =
                    fromRoute
                        (Router.route url)
                        { session | url = url }
            in
            ( route
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


header : Html Msg
header =
    let
        links = 
            [ "Home"
            , "About"
            ]

        -- Convert redirected url to query to 
        -- allow client side routing
        buttons = 
            links |>
            List.map 
                (\name ->
                    a 
                        [ A.href ("?/" ++ String.toLower name) 
                        , A.class "nav-button"
                        ] 
                        [ text name 
                        ]
                )
    in
    div 
        [ A.id "header" 
        ] 
        [ nav [ A.class "nav-list" ] buttons
        ]

-- VIEW

viewPage : Model -> Html Msg
viewPage model = 
    case model of
        Home m -> 
            Html.map GotHomeMsg <|
                Home.view m
        About m -> 
            Html.map GotAboutMsg <|
                About.view m
        NotFound m -> 
            Html.map GotNotFoundMsg <|
                NotFound.view m

view : Model -> Browser.Document Msg
view model =
    { title = "Application Title"
    , body =
        [ main_ []
            [ Lazy.lazy (\_ -> header) ()
            , div 
                [ A.id "content" ]
                [ viewPage model ]
            ]
        ]
    }
