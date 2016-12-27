module Main exposing (..)

import Html exposing (Html)
import Types exposing (..)
import View exposing (view)
import Rest exposing (..)
import Char
import Utils
import Animation


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
    ( Types.initModel, fetchTrades )


changeTrade : Int -> Trade -> List Trade -> List Trade
changeTrade idx trade trades =
    List.take idx trades ++ [ trade ] ++ List.drop (idx + 1) trades


showLoading : Model -> Animation.State
showLoading model =
    Animation.interrupt [ Animation.set [ Animation.display Animation.block ], Animation.to [ Animation.opacity 1 ] ] model.loadingStyle


hideLoading : Model -> Animation.State
hideLoading model =
    Animation.interrupt [ Animation.to [ Animation.opacity 0 ], Animation.set [ Animation.display Animation.none ] ] model.loadingStyle


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        FetchTrades ->
            ( { model | loadingStyle = showLoading model }, fetchTrades )

        SaveTrades ->
            let
                trades =
                    List.filter (\t -> t.index == -1) model.trades
            in
                if List.length trades == 0 then
                    ( model, Cmd.none )
                else
                    ( { model | loadingStyle = showLoading model }, saveNewTrades trades )

        ReceiveTrades (Ok trades) ->
            ( { model
                | trades = List.sortBy .date trades
                , loadingStyle = hideLoading model
              }
            , Cmd.none
            )

        ReceiveTrades (Err m) ->
            ( { model | loadingStyle = hideLoading model, message = Just (toString m) }, Cmd.none )

        SaveNewTrades (Ok jsonValue) ->
            ( model, fetchTrades )

        SaveNewTrades (Err m) ->
            ( { model | loadingStyle = hideLoading model, message = Just (toString m) }, Cmd.none )

        TypeShareValue newInput ->
            ( { model | shareValue = Utils.currencyToFloat newInput }, Cmd.none )

        AddTrade ->
            let
                trades =
                    List.append model.trades [ Types.newTrade ]
            in
                ( { model | trades = trades }, Cmd.none )

        RemoveTrade idx ->
            let
                trades =
                    List.take idx model.trades ++ List.drop (idx + 1) model.trades

                tradeToRemove =
                    List.head <| List.drop idx model.trades
            in
                case tradeToRemove of
                    Nothing ->
                        ( model, Cmd.none )

                    Just t ->
                        if t.index == -1 then
                            ( { model | trades = trades }, Cmd.none )
                        else
                            ( { model | trades = trades, loadingStyle = showLoading model }, deleteTrade t.index )

        TradeRemoved (Ok jsonValue) ->
            let
                l =
                    Debug.log "json value: " jsonValue
            in
                ( { model
                    | loadingStyle = hideLoading model
                  }
                , Cmd.none
                )

        TradeRemoved (Err m) ->
            ( { model | loadingStyle = hideLoading model, message = Just (toString m) }, Cmd.none )

        ClearMessage ->
            ( { model | message = Nothing }, Cmd.none )

        KeyPressed newKey ->
            ( { model | lastKey = newKey }, Cmd.none )

        ChangeKind idx newValue ->
            case List.head <| List.drop idx model.trades of
                Nothing ->
                    ( model, Cmd.none )

                Just trade ->
                    let
                        newTrade =
                            { trade | kind = Result.withDefault -1 (String.toInt newValue) }
                    in
                        ( { model | trades = changeTrade idx newTrade model.trades }, Cmd.none )

        TypeShares idx newInput ->
            case List.head <| List.drop idx model.trades of
                Nothing ->
                    ( model, Cmd.none )

                Just trade ->
                    let
                        newTrade =
                            { trade | shares = Result.withDefault 0 (String.toFloat (String.filter Char.isDigit newInput)) }
                    in
                        ( { model | trades = changeTrade idx newTrade model.trades }, Cmd.none )

        TypeDate idx newInput ->
            case List.head <| List.drop idx model.trades of
                Nothing ->
                    ( model, Cmd.none )

                Just trade ->
                    let
                        newTrade =
                            { trade | date = Utils.brazilianDateToServerDate newInput }
                    in
                        ( { model | trades = changeTrade idx newTrade model.trades }, Cmd.none )

        Animate aniMsg ->
            ( { model | loadingStyle = Animation.update aniMsg model.loadingStyle }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.loadingStyle ]
