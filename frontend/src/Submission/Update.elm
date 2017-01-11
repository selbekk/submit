module Submission.Update exposing (update)

import Submission.Model exposing (..)
import Submission.Messages exposing (..)
import Backend.Network exposing (RequestStatus(..))
import Nav.Requests exposing (saveSubmission)
import Time
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Message ->
            ( model, Cmd.none )

        Get (Err error) ->
            ( { model | submission = Error <| toString error }, Cmd.none )

        Get (Ok submission) ->
            ( { model | submission = Complete submission }, Cmd.none )

        Save ->
            case model.submission of
                Complete submission ->
                    ( model, saveSubmission submission )

                _ ->
                    ( model, Cmd.none )

        Saved (Err _) ->
            ( model, Cmd.none )

        Saved (Ok _) ->
            ( model, Task.perform TimeUpdated Time.now )

        TimeUpdated time ->
            ( { model | lastSaved = Just time }, Cmd.none )

        Title title ->
            updateField model <|
                \s -> { s | title = title }

        Abstract abstract ->
            updateField model <|
                \s -> { s | abstract = abstract }

        Equipment equipment ->
            updateField model <|
                \s -> { s | equipment = equipment }

        Format format ->
            updateField model <|
                \s -> { s | format = format }

        IntendedAudience intendedAudience ->
            updateField model <|
                \s -> { s | intendedAudience = intendedAudience }

        Language language ->
            updateField model <|
                \s -> { s | language = language }

        Outline outline ->
            updateField model <|
                \s -> { s | outline = outline }

        AddSpeaker ->
            updateField model <|
                \s -> { s | speakers = s.speakers ++ [ initSpeaker s.speakers ] }

        SpeakerName i name ->
            updateField model <|
                \s ->
                    let
                        updatedSpeakers =
                            List.map
                                (\speaker -> updateSpeaker i speaker (\sp -> { sp | name = name }))
                                s.speakers
                    in
                        { s | speakers = updatedSpeakers }

        SpeakerEmail i email ->
            updateField model <|
                \s ->
                    let
                        updatedSpeakers =
                            List.map
                                (\speaker -> updateSpeaker i speaker (\sp -> { sp | email = email }))
                                s.speakers
                    in
                        { s | speakers = updatedSpeakers }

        SpeakerBio i bio ->
            updateField model <|
                \s ->
                    let
                        updatedSpeakers =
                            List.map
                                (\speaker -> updateSpeaker i speaker (\sp -> { sp | bio = bio }))
                                s.speakers
                    in
                        { s | speakers = updatedSpeakers }

        RemoveSpeaker i ->
            updateField model <|
                \s ->
                    let
                        speakers =
                            List.filter
                                (\( j, _ ) -> j /= i)
                                s.speakers
                    in
                        { s | speakers = speakers }


updateField : Model -> (Submission -> Submission) -> ( Model, Cmd Msg )
updateField model updateFunction =
    case model.submission of
        Complete submission ->
            ( { model | submission = Complete <| updateFunction submission }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateSpeaker : Int -> ( Int, Speaker ) -> (Speaker -> Speaker) -> ( Int, Speaker )
updateSpeaker i ( j, speaker ) updateFunction =
    if i == j then
        ( j, updateFunction speaker )
    else
        ( j, speaker )
