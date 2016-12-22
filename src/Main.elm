module Main exposing (..)

import Html exposing (Html)
import Types exposing (..)
import View exposing (view)
import Rest exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing True, fetchTrades )


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        FetchTrades ->
            ( { model | loading = True }, fetchTrades )

        ReceiveTrades (Ok trades) ->
            ( { model | trades = Just trades, loading = False }, Cmd.none )

        ReceiveTrades (Err _) ->
            ( { model | loading = False }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
