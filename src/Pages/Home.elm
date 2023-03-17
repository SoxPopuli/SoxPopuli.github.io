module Pages.Home exposing (Model, Msg, init, update, view)

import Session exposing (Session)
import Html exposing (..)
import Html.Events as E
import Html.Attributes as A

type alias Model =
    { session : Session
    }

type Msg 
    = NoOp

init : Session -> Model
init session =
    { session = session }


update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

view : Model -> Html Msg
view model =
    div 
        [ A.style "display" "flex"
        , A.style "flex-direction" "column"
        ] 
        [ text "Home" 
        , button [ E.onClick NoOp ] [ text "Test" ]
        ]