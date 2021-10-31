module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { draft : String
    , messages : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { draft = "", messages = [] }
    , Cmd.none
    )


type Msg
    = DraftChanged String
    | Send


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DraftChanged draft ->
            ( { model | draft = draft }
            , Cmd.none
            )

        Send ->
            ( { model | draft = "", messages = model.draft :: model.messages }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1
            [ class "text-3xl bg-blue-300 px-5 py-10" ]
            [ text "Echo Chat" ]
        , div
            [ class "mx-10 my-10" ]
            [ input
                [ type_ "text"
                , placeholder "Draft"
                , onInput DraftChanged
                , value model.draft
                , class "mx-2"
                ]
                []
            , button
                [ onClick Send
                , class "bg-purple-200 px-2 py-1 rounded-md"
                ]
                [ text "Send" ]
            , ul
                [ class "mx-2 my-1" ]
                (List.map (\msg -> li [] [ text msg ]) model.messages)
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
