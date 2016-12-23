module Utils exposing (..)

import Char


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


serverDateToBrazilianDate : String -> String
serverDateToBrazilianDate srvDate =
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
                day ++ "/"
            else
                day

        mStr =
            if mLen == 2 then
                month ++ "/"
            else
                month
    in
        dStr ++ mStr ++ year
