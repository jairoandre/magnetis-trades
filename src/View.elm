module View exposing (..)

import Html
    exposing
        ( Html
        , section
        , div
        , h1
        , h2
        , text
        , span
        , nav
        , ul
        , li
        , a
        , i
        , footer
        , strong
        , p
        , table
        , tfoot
        , tbody
        , thead
        , tr
        , th
        , td
        , input
        , select
        , option
        , progress
        , label
        , button
        )
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, keyCode, targetValue)
import Types exposing (..)
import Json.Decode as JD
import Utils
import Animation
import Validation


icon : String -> Html Msg
icon val =
    span [ class "icon" ] [ i [ class <| "fa fa-" ++ val ] [] ]


heroFoot : Html Msg
heroFoot =
    div [ class "hero-foot" ]
        [ div [ class "container" ]
            [ nav [ class "tabs is-boxed is-medium" ]
                [ ul []
                    [ li [ class "is-active" ]
                        [ a []
                            [ icon "list"
                            , span []
                                [ text "Portfolio" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


tradeToRow : Int -> Float -> Int -> Trade -> List (Html Msg)
tradeToRow lastKey shareValue idx trade =
    let
        ( tColor, tIcon ) =
            case trade.kind of
                0 ->
                    ( "#70C800", icon "arrow-right" )

                1 ->
                    ( "#00B1DA", icon "arrow-left" )

                _ ->
                    ( "#000000", text "" )

        onlyRead =
            trade.index /= -1

        tDate =
            Utils.serverDateToBrazilianDate trade.date lastKey

        total =
            trade.shares * shareValue

        totalStr =
            Utils.formatCurrency "R$ " <| toString total

        trClass =
            if trade.index == -1 then
                "new-trade"
            else
                ""

        validClass =
            if trade.valid then
                ""
            else
                " warn-trade"

        warnMessage =
            if trade.showMsg then
                [ tr [ class "warn-trade" ]
                    [ td [ colspan 7 ]
                        [ p []
                            [ icon "warning"
                            , text "Seu saldo está negativo."
                            ]
                        ]
                    ]
                ]
            else
                []
    in
        [ tr [ class <| trClass ++ validClass ]
            [ td [ style [ ( "color", tColor ) ] ] [ tIcon ]
            , td []
                [ p [ class "control has-icon has-icon-right" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "Data"
                        , value tDate
                        , readonly onlyRead
                        , onInput (TypeDate idx)
                        , on "keydown" (JD.map KeyPressed keyCode)
                        ]
                        []
                    , i [ class "fa fa-calendar" ] []
                    ]
                ]
            , td []
                [ span [ class "select" ]
                    [ select [ class "select", readonly onlyRead, disabled onlyRead, on "change" (JD.map (ChangeKind idx) targetValue) ]
                        [ option [] [ text "Movimentação" ]
                        , option [ value "0", selected <| trade.kind == 0 ] [ text "Aplicação" ]
                        , option [ value "1", selected <| trade.kind == 1 ] [ text "Retirada" ]
                        ]
                    ]
                ]
            , td [] [ input [ class "input right-align", type_ "text", placeholder "Quantidade de cotas", value (toString trade.shares), onInput (TypeShares idx) ] [] ]
            , td [] [ input [ class "input right-align", type_ "text", placeholder "Valor por cota", readonly True, value <| Utils.formatCurrency "R$ " <| toString shareValue ] [] ]
            , td [] [ input [ class "input right-align", type_ "text", placeholder "Valor total", disabled True, value totalStr ] [] ]
            , td []
                [ a [ onClick (RemoveTrade idx) ] [ icon "times" ] ]
            ]
        ]
            ++ warnMessage


tradesTable : Model -> Html Msg
tradesTable model =
    let
        trades =
            List.concat <| List.indexedMap (tradeToRow model.lastKey model.shareValue) <| Validation.validateTrades 0 [] model.trades
    in
        table [ class "table" ]
            [ thead []
                [ tr []
                    [ th [] []
                    , th [] [ text "DATA" ]
                    , th [] [ text "TIPO" ]
                    , th [] [ text "QUANTIDADE DE COTAS" ]
                    , th [] [ text "VALOR POR COTA (R$)" ]
                    , th [] [ text "VALOR TOTAL (R$)" ]
                    , th [] []
                    ]
                ]
            , tbody [] trades
            , tfoot []
                [ tr []
                    [ td [ colspan 7 ]
                        [ div [ class "has-text-centered" ]
                            [ a [ onClick AddTrade ] [ text "INSERIR NOVA MOVIMENTAÇÃO" ] ]
                        ]
                    ]
                ]
            ]


shareValueInput : Model -> Html Msg
shareValueInput model =
    div [ class "content" ]
        [ p [ class "control" ]
            [ label [ class "label" ] [ text "Valor da Cota" ]
            , input [ class "input right-align", value <| Utils.formatCurrency "R$ " (toString model.shareValue), onInput TypeShareValue ] []
            ]
        ]


buttons : Model -> Html Msg
buttons model =
    div [ class "content" ]
        [ p [ class "control" ]
            [ button [ class "button is-primary", onClick SaveTrades ] [ text "Salvar Movimentações" ]
            , button [ class "button is-link", onClick FetchTrades ] [ text "Cancelar" ]
            ]
        ]


appHeader : Model -> Html Msg
appHeader model =
    section [ class "hero is-info" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ] [ text "Magnetis Trades" ]
                , h2 [ class "subtitle" ] [ text "A sample application coded with Elm and Bulma." ]
                ]
            ]
        ]


loadingDiv : Model -> Html Msg
loadingDiv model =
    div
        (Animation.render model.loadingStyle ++ [ class "loading-div" ])
        [ div [ class "spinner" ]
            [ div [ class "rect1" ] []
            , div [ class "rect2" ] []
            , div [ class "rect3" ] []
            , div [ class "rect4" ] []
            , div [ class "rect5" ] []
            , p [] [ text "Carregando..." ]
            ]
        ]


appBody : Model -> Html Msg
appBody model =
    let
        messageDiv =
            case model.message of
                Nothing ->
                    []

                Just msg ->
                    [ div [ class "notification is-danger" ]
                        [ button [ class "delete", onClick ClearMessage ] []
                        , text msg
                        ]
                    ]
    in
        section [ class "section" ]
            [ div [ class "container" ] <|
                messageDiv
                    ++ [ shareValueInput model
                       , tradesTable model
                       , buttons model
                       ]
            ]


appFooter : Html Msg
appFooter =
    footer [ class "footer" ]
        [ div [ class "container" ]
            [ div [ class "content has-text-centered" ]
                [ p []
                    [ strong [] [ icon "code" ]
                    , text " with "
                    , strong [] [ icon "heart" ]
                    , text " by "
                    , strong [] [ span [] [ text "jairoandre" ] ]
                    , text ". Built with "
                    , a [ href "http://elm-lang.org" ] [ text "Elm" ]
                    , text " and "
                    , a [ href "http://bulma.io" ] [ text "Bulma" ]
                    , text "."
                    ]
                , p []
                    [ a [ href "http://github.com/jairoandre/magnetis-trades" ] [ icon "github" ] ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ loadingDiv model
        , appBody model
        , appFooter
        ]
