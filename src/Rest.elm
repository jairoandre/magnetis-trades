module Rest exposing (..)

import Http
import Json.Decode as JD
import Json.Encode as JE
import Types exposing (..)


fetchTrades : Cmd Msg
fetchTrades =
    let
        url =
            "https://magnetis-trades.herokuapp.com/trades.json"
    in
        Http.send ReceiveTrades (Http.get url decodeTrades)


tradeToJson : Trade -> JE.Value
tradeToJson trade =
    JE.object
        [ ( "date", JE.string trade.date )
        , ( "kind", JE.int trade.kind )
        , ( "shares", JE.float trade.shares )
        ]


tradeValue : List Trade -> JE.Value
tradeValue trades =
    let
        tradesJson =
            List.map tradeToJson trades
    in
        JE.object
            [ ( "investment"
              , JE.object
                    [ ( "trades_attributes", JE.list tradesJson ) ]
              )
            ]


saveNewTrades : List Trade -> Cmd Msg
saveNewTrades trades =
    let
        url =
            "https://magnetis-trades.herokuapp.com/investments.json"
    in
        Http.send SaveNewTrades (customRequest "POST" url [] (Http.jsonBody <| tradeValue trades))


decodeTrades : JD.Decoder (List Trade)
decodeTrades =
    JD.list decodeTrade


deleteTrade : Int -> Cmd Msg
deleteTrade id =
    let
        url =
            "https://magnetis-trades.herokuapp.com/trades/" ++ (toString id) ++ ".json"
    in
        Http.send TradeRemoved (customRequest "DELETE" url [] Http.emptyBody)


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
    JD.map5 (Trade True False)
        (JD.field "date" JD.string)
        (JD.field "fund_id" (JD.oneOf [ JD.int, JD.null -1 ]))
        (JD.field "id" JD.int)
        (JD.field "kind" JD.int)
        (JD.field "shares" (JD.map stringToFloat JD.string))
