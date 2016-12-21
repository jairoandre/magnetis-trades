module Main exposing (..)

import Html exposing (Html, div, h1, text, img)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( Model 0, Cmd.none )


type alias Model =
    { count : Int
    }


type Msg
    = Home


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    h1 [] [ text <| toString <| model.count ]
