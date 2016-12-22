module Rest exposing (..)

import Http
import Json.Decode as JD
import Types exposing (..)


fetchTrades : Cmd Msg
fetchTrades =
    let
        url =
            "https://magnetis-trades.herokuapp.com/trades.json"
    in
        Http.send ReceiveTrades (Http.get url decodeTrades)


decodeTrades : JD.Decoder (List Trade)
decodeTrades =
    JD.list decodeTrade


decodeTrade : JD.Decoder Trade
decodeTrade =
    JD.map8 Trade
        (JD.field "created_at" JD.string)
        (JD.field "date" JD.string)
        (JD.field "fund_id" JD.int)
        (JD.field "id" JD.int)
        (JD.field "investment_id" <| JD.oneOf [ JD.int, JD.null 0 ])
        (JD.field "kind" JD.int)
        (JD.field "shares" JD.string)
        (JD.field "updated_at" JD.string)
