module Rest exposing (..)

import Http
import Json.Decode as JD
import Json.Encode as JE
import Types exposing (..)


fetchTrades : Cmd Msg
fetchTrades =
    let
        url =
            "https://magnetis-b12d8.firebaseio.com/trades.json"
    in
        Http.send ReceiveTrades (Http.get url decodeTrades)


tradeToJson : Trade -> JE.Value
tradeToJson trade =
    JE.object
        [ ( "date", JE.string trade.date )
        , ( "kind", JE.int trade.kind )
        , ( "shares", JE.float trade.shares )
        , ( "deleted", JE.bool False )
        ]


tradeValue : List Trade -> JE.Value
tradeValue trades =
    JE.list <| List.map tradeToJson trades


saveNewTrades : List Trade -> Cmd Msg
saveNewTrades trades =
    let
        url =
            "https://magnetis-trades.herokuapp.com/trades.json"
    in
        Http.send SaveNewTrades (customRequest "PUT" url [] (Http.jsonBody <| tradeValue trades))


decodeTrades : JD.Decoder (List Trade)
decodeTrades =
    JD.list decodeTrade


deleteTrade : Int -> Cmd Msg
deleteTrade id =
    let
        url =
            "https://magnetis-b12d8.firebaseio.com/trades/" ++ (toString id) ++ "/.json"
    in
        Http.send TradeRemoved (customRequest "PATCH" url [] <| Http.jsonBody (JE.object [ ( "deleted", JE.bool True ) ]))


customRequest : String -> String -> List Http.Header -> Http.Body -> Http.Request JD.Value
customRequest method url headers body =
    Http.request
        { method = method
        , headers = headers
        , url = url
        , body = body
        , expect = Http.expectJson JD.value
        , timeout = Nothing
        , withCredentials = False
        }


stringToFloat : String -> Float
stringToFloat str =
    Result.withDefault 0 (String.toFloat str)


decodeTrade : JD.Decoder Trade
decodeTrade =
    JD.map4 (Trade True False -1)
        (JD.field "date" JD.string)
        (JD.field "kind" JD.int)
        (JD.field "shares" JD.float)
        (JD.field "deleted" <| JD.oneOf [ JD.null False, JD.bool ])
