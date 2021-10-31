module Pr exposing (PullRequest, decoder)

import Json.Decode as JD
import Json.Decode.Extra as JDE
import Json.Decode.Pipeline as JDP
import Time


type alias PullRequest =
    { number : Int
    , title : String
    , url : String
    , state : String
    , createdAt : Time.Posix
    , updatedAt : Time.Posix
    , closedAt : Maybe Time.Posix
    }


decoder : JD.Decoder PullRequest
decoder =
    JD.succeed PullRequest
        |> JDP.required "number" JD.int
        |> JDP.required "title" JD.string
        |> JDP.required "html_url" JD.string
        |> JDP.required "state" JD.string
        |> JDP.required "created_at" JDE.datetime
        |> JDP.required "updated_at" JDE.datetime
        |> JDP.optional "closed_at" (JD.nullable JDE.datetime) Nothing
