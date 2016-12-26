module Types exposing (..)

import Http
import Animation
import Json.Decode as JD


type alias Model =
    { trades : List Trade
    , lastKey : Int
    , shareValue : Float
    , loadingStyle : Animation.State
    }


initModel : Model
initModel =
    Model [] -1 100 (Animation.style [ Animation.opacity 1 ])


type Msg
    = FetchTrades
    | ReceiveTrades (Result Http.Error (List Trade))
    | TypeShareValue String
    | SaveTrades
    | SaveNewTrades (Result Http.Error JD.Value)
    | AddTrade
    | RemoveTrade Int
    | TradeRemoved (Result Http.Error JD.Value)
    | TypeDate Int String
    | TypeShares Int String
    | ChangeKind Int String
    | KeyPressed Int
    | Animate Animation.Msg


type alias Trade =
    { valid : Bool
    , showMsg : Bool
    , date : String
    , fund_id : Int
    , id : Int
    , kind : Int
    , shares : Float
    }


newTrade : Trade
newTrade =
    Trade True False "" -1 -1 -1 0
