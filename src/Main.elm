module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


searchQueryUrl : String
searchQueryUrl =
    "https://api.github.com/search/issues?q=author:lusingander+is:pr+-user:lusingander&sort=created&order=desc&per_page=100"


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel
    , Http.get
        { url = searchQueryUrl
        , expect = Http.expectJson GotPullRequests pullRequestsDecoder
        }
    )


type alias Model =
    { status : Status
    }


initModel : Model
initModel =
    { status = Loading
    }


type Status
    = Loading
    | Failure
    | Success PullRequests


type alias PullRequests =
    { totalCount : Int
    , items : List PullRequest
    }


type alias PullRequest =
    { title : String
    , url : String
    }


pullRequestsDecoder : JD.Decoder PullRequests
pullRequestsDecoder =
    JD.succeed PullRequests
        |> JDP.required "total_count" JD.int
        |> JDP.required "items" (JD.list pullRequestDecoder)


pullRequestDecoder : JD.Decoder PullRequest
pullRequestDecoder =
    JD.succeed PullRequest
        |> JDP.required "title" JD.string
        |> JDP.required "html_url" JD.string


type Msg
    = GotPullRequests (Result Http.Error PullRequests)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPullRequests (Ok pullRequests) ->
            ( { model
                | status = Success pullRequests
              }
            , Cmd.none
            )

        GotPullRequests (Err err) ->
            ( { model
                | status = Failure
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ viewHeader
        , viewContent model
        ]


viewHeader : Html msg
viewHeader =
    h1
        [ class "text-2xl bg-blue-300 px-5 py-5" ]
        [ text "Pull Requests" ]


viewContent : Model -> Html msg
viewContent model =
    case model.status of
        Loading ->
            text ""

        Failure ->
            text ""

        Success prs ->
            div
                [ class "mx-10 my-10" ]
                [ div [] [ text ("Total: " ++ String.fromInt prs.totalCount) ]
                , viewPullRequestsList prs
                ]


viewPullRequestsList : PullRequests -> Html msg
viewPullRequestsList prs =
    div []
        [ ul
            [ class "mx-2 my-1" ]
            (List.map viewPullRequest prs.items)
        ]


viewPullRequest : PullRequest -> Html msg
viewPullRequest pr =
    li [] [ text pr.title ]
