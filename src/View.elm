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
        )
import Html.Attributes exposing (..)
import Types exposing (..)


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


newTrade : Html Msg
newTrade =
    tr []
        [ td [] [ input [ class "input", type_ "text", placeholder "Data" ] [] ]
        , td []
            [ span [ class "select" ]
                [ select [ class "select" ]
                    [ option [] [ text "Movimentação" ]
                    , option [ value "0" ] [ text "Aplicação" ]
                    , option [ value "1" ] [ text "Retirada" ]
                    ]
                ]
            ]
        , td [] [ input [ class "input", type_ "text", placeholder "Quantidade de cotas" ] [] ]
        , td [] [ input [ class "input", type_ "text", placeholder "Valor por cota" ] [] ]
        , td [] [ input [ class "input", type_ "text", placeholder "Valor total", disabled True ] [] ]
        , td [] [ a [] [ icon "times" ] ]
        ]


tradeToRow : Trade -> Html Msg
tradeToRow trade =
    tr []
        [ td [] [ input [ class "input", type_ "text", placeholder "Data", value <| trade.date ] [] ]
        , td []
            [ span [ class "select" ]
                [ select [ class "select" ]
                    [ option [] [ text "Movimentação" ]
                    , option [ value "0", selected <| trade.kind == 0 ] [ text "Aplicação" ]
                    , option [ value "1", selected <| trade.kind == 1 ] [ text "Retirada" ]
                    ]
                ]
            ]
        , td [] [ input [ class "input", type_ "text", placeholder "Quantidade de cotas" ] [ text trade.shares ] ]
        , td [] [ input [ class "input", type_ "text", placeholder "Valor por cota" ] [] ]
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
                    List.map tradeToRow ts
    in
        table [ class "table" ]
            [ thead []
                [ tr []
                    [ th [] [ text "DATA" ]
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
                    [ td [ colspan 6 ]
                        [ div [ class "has-text-centered" ]
                            [ a [ href "#" ] [ text "INSERIR NOVA MOVIMENTAÇÃO" ] ]
                        ]
                    ]
                ]
            ]


appBody : Model -> Html Msg
appBody model =
    section [ class "section" ]
        [ div [ class "container" ]
            [ tradesTable model ]
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
        [ appHeader model
        , appBody model
        , appFooter
        ]
