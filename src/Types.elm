module Types exposing (..)

import Http


type alias Model =
    { trades : Maybe (List Trade)
    , loading : Bool
    }


type Msg
    = FetchTrades
    | ReceiveTrades (Result Http.Error (List Trade))


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
