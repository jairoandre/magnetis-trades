module Validation exposing (..)

import Types exposing (..)


validateTrades : Float -> List Trade -> List Trade -> List Trade
validateTrades shares lTrades rTrades =
    case List.head rTrades of
        Nothing ->
            lTrades

        Just t ->
            let
                newShares =
                    if t.kind == 0 then
                        shares + t.shares
                    else
                        shares - t.shares
            in
                if newShares < 0 then
                    (List.map (\i -> { i | valid = False, showMsg = False }) lTrades) ++ [ { t | valid = False, showMsg = True } ] ++ (List.drop 1 rTrades)
                else
                    validateTrades newShares (lTrades ++ [ t ]) (List.drop 1 rTrades)
