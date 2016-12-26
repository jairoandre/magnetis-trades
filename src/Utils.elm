module Utils exposing (..)

import Char
import Date exposing (Date)


repeatSpaces : Int -> String
repeatSpaces ammount =
    String.repeat ammount " "


brazilianDateToServerDate : String -> String
brazilianDateToServerDate brDate =
    let
        day =
            String.slice 0 2 brDate

        month =
            String.slice 3 5 brDate

        year =
            String.slice 6 10 brDate

        dLen =
            String.length day

        mLen =
            String.length month

        yLen =
            String.length year
    in
        year ++ (repeatSpaces <| 4 - yLen) ++ "-" ++ month ++ (repeatSpaces <| 2 - mLen) ++ "-" ++ day ++ (repeatSpaces <| 2 - dLen)


serverDateToBrazilianDate : String -> Int -> String
serverDateToBrazilianDate srvDate lastKey =
    let
        year =
            String.filter Char.isDigit <| String.slice 0 4 srvDate

        month =
            String.filter Char.isDigit <| String.slice 5 7 srvDate

        day =
            String.filter Char.isDigit <| String.slice 8 10 srvDate

        dLen =
            String.length day

        mLen =
            String.length month

        yLen =
            String.length year

        dStr =
            if dLen == 2 then
                if lastKey == 8 && mLen == 0 then
                    day
                else
                    day ++ "/"
            else
                day

        mStr =
            if mLen == 2 then
                if lastKey == 8 && yLen == 0 then
                    month
                else
                    month ++ "/"
            else
                month
    in
        dStr ++ mStr ++ year


addSeparator : Int -> String -> String
addSeparator c input =
    let
        lPart =
            String.dropRight 3 input

        separator =
            if String.length lPart > 0 then
                "."
            else
                ""
    in
        if c == 0 then
            input
        else
            addSeparator (c - 1) lPart ++ separator ++ (String.right 3 input)


decimalSeparator : String -> String
decimalSeparator input =
    addSeparator (String.length input // 3) input


currencyToFloat : String -> Float
currencyToFloat input =
    let
        onlyDigits =
            String.filter Char.isDigit input

        dLen =
            2

        result =
            if dLen == 0 then
                onlyDigits
            else
                let
                    len =
                        String.length onlyDigits
                in
                    (String.dropRight dLen onlyDigits) ++ "." ++ (String.dropLeft (len - dLen) onlyDigits)
    in
        Result.withDefault 0 (String.toFloat result)


formatCurrency : String -> String -> String
formatCurrency prefix input =
    let
        parts =
            String.split "." input

        iPart =
            case List.head parts of
                Nothing ->
                    ""

                Just p ->
                    p

        fPart =
            case List.tail parts of
                Nothing ->
                    "00"

                Just t ->
                    case List.head t of
                        Nothing ->
                            "00"

                        Just p ->
                            p ++ String.repeat (2 - String.length p) "0"
    in
        prefix ++ decimalSeparator iPart ++ "," ++ fPart


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
