module Types exposing (..)

import Http
import Animation
import Json.Decode as JD


type alias Model =
    { trades : List Trade
    , lastKey : Int
    , shareValue : Float
    , loadingStyle : Animation.State
    , message : Maybe String
    }


initModel : Model
initModel =
    Model [] -1 100 (Animation.style [ Animation.opacity 1 ]) Nothing


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
    | ClearMessage


type alias Trade =
    { valid : Bool
    , showMsg : Bool
    , index : Int
    , date : String
    , kind : Int
    , shares : Float
    , deleted : Bool
    }


newTrade : Trade
newTrade =
    Trade True False -1 "" -1 0 False
