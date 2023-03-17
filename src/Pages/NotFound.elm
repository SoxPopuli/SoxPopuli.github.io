module Pages.NotFound exposing (Model, Msg, init, update, view)

import Session exposing (Session)
import Html exposing (..)

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
    div [] [ text "Page Not Found" ]
