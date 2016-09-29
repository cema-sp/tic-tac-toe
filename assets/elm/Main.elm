module Main exposing (..)

import Html exposing (Html, div, text, table, tr, td, form, label, input, button)
import Html.Attributes exposing (class, placeholder, type')
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.App as App
import Array exposing (Array)

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


type alias Row =
  Array Symbol


type alias Board =
  Array Row


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
    |> Array.repeat 3
    |> Array.repeat 3


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


applyTic : Board -> Turn -> TicPoint -> Result String Board
applyTic board turn (x, y) =
  case Array.get y board of
    Nothing ->
      Err "Invalid Y"

    Just row ->
      case Array.get x row of
        Nothing ->
          Err "Invalid X"

        Just sym ->
          if sym == Empty then
            board
              |> Array.set y (Array.set x (turnSymbol turn) row)
              |> Ok
          else
            Err "Already engaged"


nextTurn : Turn -> Turn
nextTurn turn =
  if turn == Noughts then
    Crosses
  else
    Noughts


turnSymbol : Turn -> Symbol
turnSymbol turn =
  if turn == Noughts then
    Nought
  else
    Cross

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
      let
        result =
          applyTic model.board model.turn point
            |> Result.formatError (Debug.log "Error")

        board =
          result
            |> Result.withDefault model.board

        turn =
          result
            |> Result.map (\_ -> nextTurn model.turn)
            |> Result.withDefault model.turn
      in
        { model | board = board
                , turn = turn
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

boardCellView : TicPoint -> Symbol -> Html Msg
boardCellView point symbol =
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
    td [ onClick(Tic point) ] [ text sym ]


boardRowView : Int -> Row -> Html Msg
boardRowView y row =
  Array.indexedMap (\x sym -> boardCellView (x, y) sym) row
    |> Array.toList
    |> tr []


boardView : Board -> Html Msg
boardView board =
  div [ class "board" ]
    [ Array.indexedMap boardRowView board
        |> Array.toList
        |> table []
    ]


view : Model -> Html Msg
view model =
  div []
    [ if model.authed /= True then
        authFormView model
      else
        boardView model.board
    ]

