module View exposing (..)

import Html exposing (Html, section, div, h1, h2, text, span, nav, ul, li, a, i, footer, strong, p)
import Html.Attributes exposing (..)
import Types exposing (..)


icon : String -> Html Msg
icon val =
    span [ class "icon" ] [ i [ class <| "fa fa-" ++ val ] [] ]


view : Model -> Html Msg
view model =
    div
        []
        [ section
            [ class "hero is-info" ]
            [ div
                [ class "hero-head" ]
                [ div
                    [ class "container" ]
                    [ div
                        [ class "nav" ]
                        [ div
                            [ class "nav-left" ]
                            [ span
                                [ class "nav-item is-brand" ]
                                [ text "Magnetis Trades" ]
                            ]
                        ]
                    ]
                ]
            , div
                [ class "hero-body" ]
                [ div
                    [ class "container" ]
                    [ h1 [ class "title" ] [ text "Magnetis Trades" ]
                    , h2 [ class "subtitle" ] [ text "A sample application coded with Elm and Bulma." ]
                    ]
                ]
            , div
                [ class "hero-foot" ]
                [ div
                    [ class "container" ]
                    [ nav
                        [ class "tabs is-boxed is-medium" ]
                        [ ul
                            []
                            [ li
                                [ class "is-active" ]
                                [ a
                                    []
                                    [ icon "list"
                                    , span
                                        []
                                        [ text "Trades" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , footer
            [ class "footer" ]
            [ div
                [ class "container" ]
                [ div
                    [ class "content has-text-centered" ]
                    [ p
                        []
                        [ strong [] [ icon "code" ]
                        , text " with "
                        , strong [] [ icon "heart" ]
                        , text " by "
                        , strong [] [ span [] [ text "jairoandre" ] ]
                        ]
                    , p
                        []
                        [ a [ href "http://github.com/jairoandre" ] [ icon "github" ] ]
                    ]
                ]
            ]
        ]
