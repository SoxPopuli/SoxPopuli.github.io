module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Html.Lazy as Lazy
import Url
import Json.Encode as Enc

import Router
import Session exposing (Session)
import Ports
import Theme exposing (Theme(..))


import Pages.About as About
import Pages.Home as Home
import Pages.NotFound as NotFound
import Pages.Tools as Tools


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
    | Tools Tools.Model
    | NotFound NotFound.Model

fromRoute : Router.Route -> Session -> Model
fromRoute route session =
    case route of
        Router.Home -> Home <| Home.init session
        Router.About -> About <| About.init session
        Router.NotFound -> NotFound <| NotFound.init session
        Router.Tools -> Tools <| Tools.init session

toSession : Model -> Session
toSession model =
    case model of
        Home m -> m.session
        About m -> m.session
        Tools m -> m.session
        NotFound m -> m.session

updateSession : Model -> (Session -> Session) -> Model
updateSession model fn =
    let 
        update_ m s = { m | session = s }
    in
    case model of
        Home m -> Home (update_ m <| fn m.session)
        About m -> About (update_ m <| fn m.session)
        Tools m -> Tools (update_ m <| fn m.session)
        NotFound m -> NotFound (update_ m <| fn m.session)

viewPage : Model -> Html Msg
viewPage model = 
    let
        map msg viewFn mod =
            Html.map msg <|
                viewFn mod
    in
    case model of
        Home m -> map GotHomeMsg Home.view m
        About m -> map GotAboutMsg About.view m
        NotFound m -> map GotNotFoundMsg NotFound.view m
        Tools m -> map GotToolsMsg Tools.view m

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
    | GotToolsMsg Tools.Msg
    | SwitchTheme 
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
        
        (Tools subModel, GotToolsMsg subMsg) ->
            Tuple.mapBoth
                Tools
                (Cmd.map GotToolsMsg)
                (Tools.update subMsg subModel)
        
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

        (_, SwitchTheme) ->
            let
                session = toSession model
                theme = session.theme
                (cmd, newTheme) = 
                    case theme of
                        Theme.Dark -> 
                            ( Ports.setTheme Theme.Light
                            , Theme.Light
                            )
                        Theme.Light -> 
                            ( Ports.setTheme Theme.Dark
                            , Theme.Dark
                            )

            in
            ( updateSession model (\s -> { s | theme = newTheme }), 
              cmd
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
            , "Tools"
            ]

        -- Convert redirected url to query to 
        -- allow client side routing
        buttons = 
            links |>
            List.map 
                (\name ->
                    a 
                        [ A.href ("?page=" ++ String.toLower name) 
                        , A.class "nav-button"
                        , A.id ("nav-" ++ String.toLower name)
                        ] 
                        [ text name 
                        ]
                )
    in
    div 
        [ A.id "header" 
        ] 
        [ nav [ A.class "nav-list" ] buttons
        -- , div [ A.class "spacer" ] []
        , button [ A.id "theme-button", E.onClick SwitchTheme ] [ text "Switch Theme" ]
        ]

-- VIEW



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
