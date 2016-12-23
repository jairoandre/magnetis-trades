module Types exposing (..)

import Http
import Date exposing (Date)


type alias Model =
    { trades : Maybe (List Trade)
    , loading : Bool
    , tradeToAdd : Maybe Trade
    }


type Msg
    = FetchTrades
    | ReceiveTrades (Result Http.Error (List Trade))
    | PrepareNewTrade
    | AddTrade Date
    | AddTradeToList


type alias Fund =
    { created_at : String
    , id : Int
    , name : String
    , updated_at : String
    }


type alias Trade =
    { created_at : String
    , date : String
    , fund_id : Int
    , id : Int
    , investment_id : Int
    , kind : Int
    , shares : String
    , updated_at : String
    }


dateToString : Date -> String
dateToString date =
    let
        year =
            toString <| Date.year date

        month =
            case Date.month date of
                Date.Jan ->
                    "01"

                Date.Feb ->
                    "02"

                Date.Mar ->
                    "03"

                Date.Apr ->
                    "04"

                Date.May ->
                    "05"

                Date.Jun ->
                    "06"

                Date.Jul ->
                    "07"

                Date.Aug ->
                    "08"

                Date.Sep ->
                    "09"

                Date.Oct ->
                    "10"

                Date.Nov ->
                    "11"

                Date.Dec ->
                    "12"

        day =
            toString <| Date.day date

        hour =
            toString <| Date.hour date
    in
        year ++ "-" ++ month ++ "-" ++ day ++ "T" ++ hour


newTrade : Date -> Trade
newTrade dateNow =
    let
        dateStr =
            dateToString dateNow
    in
        Trade dateStr "" 1 -1 20 -1 "" dateStr
