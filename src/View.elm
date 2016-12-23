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
        )
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Types exposing (..)
import Utils


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


tradeToRow : Trade -> Html Msg
tradeToRow trade =
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
            trade.id /= -1

        tDate =
            Utils.serverDateToBrazilianDate trade.date
    in
        tr []
            [ td [ style [ ( "color", tColor ) ] ] [ tIcon ]
            , td []
                [ p [ class "control has-icon has-icon-right" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , placeholder "Data"
                        , value tDate
                        , readonly onlyRead
                        , onInput TypeDate
                        ]
                        []
                    , i [ class "fa fa-calendar" ] []
                    ]
                ]
            , td []
                [ span [ class "select" ]
                    [ select [ class "select", readonly onlyRead, disabled onlyRead ]
                        [ option [] [ text "Movimentação" ]
                        , option [ value "0", selected <| trade.kind == 0 ] [ text "Aplicação" ]
                        , option [ value "1", selected <| trade.kind == 1 ] [ text "Retirada" ]
                        ]
                    ]
                ]
            , td [] [ input [ class "input", type_ "text", placeholder "Quantidade de cotas", value trade.shares, readonly onlyRead ] [] ]
            , td [] [ input [ class "input", type_ "text", placeholder "Valor por cota", readonly True, value "R$ 1.000,00" ] [] ]
            , td [] [ input [ class "input", type_ "text", placeholder "Valor total", disabled True ] [] ]
            , td [] [ a [] [ icon "times" ] ]
            ]


tradesTable : Model -> Html Msg
tradesTable model =
    let
        trades =
            case model.trades of
                Nothing ->
                    []

                Just ts ->
                    List.reverse ts |> List.map tradeToRow

        ( tradeToAdd, addLink ) =
            case model.tradeToAdd of
                Nothing ->
                    ( [], a [ href "#", onClick PrepareNewTrade ] [ text "INSERIR NOVA MOVIMENTAÇÃO" ] )

                Just t ->
                    ( [ tradeToRow t ], text "" )
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
            , tbody [] <| trades ++ tradeToAdd
            , tfoot []
                [ tr []
                    [ td [ colspan 6 ]
                        [ div [ class "has-text-centered" ]
                            [ addLink ]
                        ]
                    ]
                ]
            ]


appBody : Model -> Html Msg
appBody model =
    let
        content =
            if model.loading then
                div [ class "container" ]
                    [ div [ class "content has-text-centered" ]
                        [ a [ class "button is-primary is-loading loading-with" ] [] ]
                    ]
            else
                div [ class "container" ]
                    [ tradesTable model ]
    in
        section [ class "section" ]
            [ content ]


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
        [ appHeader model
        , appBody model
        , appFooter
        ]
