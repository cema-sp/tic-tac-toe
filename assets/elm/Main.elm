module Main exposing (..)

import Html exposing (Html, div, text, table, tr, td)
import Html.App as App


main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }


-- MODEL


type Symbol
  = Empty
  | Nought
  | Cross


type alias Board =
  List (List Symbol)


type alias Model =
  { board : Board
  }


emptyBoard : Board
emptyBoard =
  Empty
    |> List.repeat 3
    |> List.repeat 3


init : ( Model, Cmd msg )
init =
  { board = emptyBoard } ! []


-- UPDATE


update : msg -> Model -> ( Model, Cmd msg )
update msg model =
  case msg of
    _ ->
      model ! []


-- VIEW


boardCellView : Symbol -> Html msg
boardCellView symbol =
  let
    sym =
      case symbol of
        Empty ->
          "-"

        Nought ->
          "◯"

        Cross ->
          "✕"
  in
    td [] [ text sym ]


boardRowView : List Symbol -> Html msg
boardRowView symbols =
  tr [] (List.map boardCellView symbols)


boardView : Board -> Html msg
boardView board =
  table [] (List.map boardRowView board)


view : Model -> Html msg
view model =
  div []
    [ boardView model.board
    ]
