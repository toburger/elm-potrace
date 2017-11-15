port module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button, hr, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, property, style)
import Json.Encode


type alias Svg =
    String



---- PORTS ----


port sendSvgUrl : String -> Cmd msg


port receiveSvg : (Svg -> msg) -> Sub msg



---- MODEL ----


type alias Model =
    { svg : Maybe Svg }


init : ( Model, Cmd Msg )
init =
    ( { svg = Nothing }, Cmd.none )



---- UPDATE ----


type Msg
    = SendSvgUrl String
    | ReceiveSvg String
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendSvgUrl url ->
            ( model, sendSvgUrl url )

        ReceiveSvg data ->
            ( { model | svg = Just data }, Cmd.none )

        Reset ->
            ( { model | svg = Nothing }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (SendSvgUrl "./buddy.jpg") ] [ text "send url" ]
        , button [ onClick Reset ] [ text "reset" ]
        , hr [] []
        , img
            [ style
                [ ( "width", "500px" )
                , ( "height", "500px" )
                ]
            , src "./buddy.jpg"
            ]
            []
        , case model.svg of
            Just svg ->
                div
                    [ style
                        [ ( "width", "500px" )
                        , ( "height", "500px" )
                        , ( "display", "inline-block" )
                        ]
                    , property "innerHTML" (Json.Encode.string svg)
                    ]
                    []

            Nothing ->
                text ""
        ]



---- SUBSCRIPTIONS ---


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveSvg ReceiveSvg



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
