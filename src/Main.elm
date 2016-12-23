module Main exposing (..)

import Html exposing (Html)
import Types exposing (..)
import View exposing (view)
import Rest exposing (..)
import Date exposing (Date)
import Utils
import Task


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
    ( Model Nothing True Nothing, fetchTrades )


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        FetchTrades ->
            ( { model | loading = True }, fetchTrades )

        ReceiveTrades (Ok trades) ->
            ( { model | trades = Just trades, loading = False }, Cmd.none )

        ReceiveTrades (Err _) ->
            ( { model | loading = False }, Cmd.none )

        PrepareNewTrade ->
            ( model, Task.perform AddTrade Date.now )

        AddTrade now ->
            ( { model | tradeToAdd = Just <| newTrade now }, Cmd.none )

        AddTradeToList ->
            ( { model | tradeToAdd = Nothing }, Cmd.none )

        TypeDate newInput ->
            case model.tradeToAdd of
                Nothing ->
                    ( model, Cmd.none )

                Just t ->
                    let
                        newTradeToAdd =
                            { t | date = Utils.brazilianDateToServerDate newInput }
                    in
                        ( { model | tradeToAdd = Just newTradeToAdd }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
