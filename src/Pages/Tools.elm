module Pages.Tools exposing (Model, Msg, init, update, view)

import Session exposing (Session)
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E

-- Model

type SidebarItem
    = Calculator
    | Cryptography

sidebarItems : List SidebarItem 
sidebarItems =
    [ Calculator
    , Cryptography
    ]

itemToString : SidebarItem -> String
itemToString item = 
    case item of
        Calculator -> "Calculator"
        Cryptography -> "Cryptography"

type alias Model =
    { session : Session
    , item : SidebarItem
    }


init : Session -> Model
init s =
    { session = s
    , item = Calculator
    }

-- Update

type Msg
    = NoMsg
    | SidebarItemClicked SidebarItem

update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        NoMsg ->
            ( model, Cmd.none )

        SidebarItemClicked item ->
            ( { model | item = item }, Cmd.none )


-- View

sidebar : Model -> Html Msg
sidebar model =
    let
        items = 
            sidebarItems |>
            List.map
                (\item -> 
                    button 
                        [ E.onClick (SidebarItemClicked item) ] 
                        [ text <| itemToString item ]
                )
    in
    div 
        [ A.class "tools-sidebar"
        ]
        items

view : Model -> Html Msg
view model =
    div 
        [ A.class "tools-container"
        ] 
        [ sidebar model
        , div 
            [ A.style "flex-grow" "1", A.style "padding" "1em" ] 
            [ text (itemToString model.item) ]
        ]