module Main exposing (..)

import Html exposing (Html, div, text, table, tr, td, form, label, input, button)
import Html.Attributes exposing (class, placeholder, type')
import Html.Events exposing (onClick, onInput, onSubmit)
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


type Turn
  = Noughts
  | Crosses


type Symbol
  = Empty
  | Nought
  | Cross


type alias Board =
  List (List Symbol)

type alias TicPoint =
  (Int, Int)

type alias Model =
  { account : String
  , gameHash : String
  , authed : Bool
  , turn : Turn
  , board : Board
  }


emptyBoard : Board
emptyBoard =
  Empty
    |> List.repeat 3
    |> List.repeat 3


init : ( Model, Cmd msg )
init =
  { account = ""
  , gameHash = ""
  , authed = False
  , turn = Noughts
  , board = emptyBoard
  } ! []


-- UPDATE

type Msg
  = Account String
  | GameHash String
  | Auth
  | Tic TicPoint


applyTic : Board -> Symbol -> TicPoint -> Board
applyTic board symbol (x, y) =
  let
    applyTicRow row =
      List.map (\(x', sym) -> if x' == x then symbol else sym)
        <| List.indexedMap (,) row
  in
    List.map (\(y', row) -> if y' == y then (applyTicRow row) else row)
      <| List.indexedMap (,) board


nextTurn : Turn -> Turn
nextTurn turn =
  if turn == Noughts then Crosses else Noughts


turnSymbol : Turn -> Symbol
turnSymbol turn =
  if turn == Noughts then Nought else Cross

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Account newAccount ->
      { model | account = newAccount } ! []

    GameHash newGameHash ->
      { model | gameHash = newGameHash } ! []

    Auth ->
      { model | authed = True } ! []

    Tic point ->
      { model | board = applyTic model.board (turnSymbol model.turn) point
              , turn = nextTurn model.turn
              } ! []


-- VIEW

authFormView : Model -> Html Msg
authFormView model =
  div [ class "auth" ]
    [ form [ onSubmit Auth ]
      [ div [ class "form-group" ]
        [ label [] [ text "Account" ]
        , input [ onInput Account, placeholder "0x012345" ] []
        ]
      , div [ class "form-group" ]
        [ label [] [ text "Game #" ]
        , input [ onInput GameHash, placeholder "0x012345" ] []
        ]
      , button [ type' "submit" ] [ text "Start" ]
      ]
    ]

boardCellView : Int -> (Int, Symbol) -> Html Msg
boardCellView y (x, symbol) =
  let
    sym =
      case symbol of
        Empty ->
          ""

        Nought ->
          "◯"

        Cross ->
          "✕"
  in
    td [ onClick <| Tic (x, y) ] [ text sym ]


boardRowView : (Int, List Symbol) -> Html Msg
boardRowView (y, row) =
  let
    cells = 
      List.map (boardCellView y) <| List.indexedMap (,) row
  in
    tr [] cells


boardView : Board -> Html Msg
boardView board =
  let
    rows = 
      List.map boardRowView <| List.indexedMap (,) board
  in
    div [ class "board" ]
      [ table [] rows
      ]


view : Model -> Html Msg
view model =
  div []
    [ if model.authed /= True then
        authFormView model
      else
        boardView model.board
    ]

