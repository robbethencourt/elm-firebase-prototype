module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


-- model


type alias Model =
    { titleInput : String
    , doodles : List Doodle
    , error : Maybe String
    }


type alias Doodle =
    { title : String
    , doodle : String
    }


tempDoodles : List Doodle
tempDoodles =
    [ Doodle "title number 1" "doodle number 1"
    , Doodle "22222" "another doodle"
    , Doodle "title number 1" "doodle number 1"
    , Doodle "22222" "another doodle"
    , Doodle "title number 1" "doodle number 1"
    , Doodle "22222" "another doodle"
    , Doodle "title number 1" "doodle number 1"
    , Doodle "22222" "another doodle"
    , Doodle "title number 1" "doodle number 1"
    , Doodle "22222" "another doodle"
    ]


initModel : Model
initModel =
    { titleInput = ""
    , doodles = tempDoodles
    , error = Nothing
    }


type alias Flags =
    { error : Maybe String }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel, Cmd.none )



-- update


type Msg
    = TitleInput String
    | Submit
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleInput titleInput ->
            ( { model | titleInput = titleInput }, Cmd.none )

        Submit ->
            ( initModel, Cmd.none )

        Error error ->
            ( { model | error = Just error }, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div []
        [ navBar
        , addDoodle model
        , div [ class "container-fluid" ]
            [ displayDoodles model.doodles ]
        , div [ class "container" ] [ text (toString model) ]
        ]


navBar : Html Msg
navBar =
    header []
        [ nav [ class "navbar" ]
            [ div [ class "container-fluid" ]
                [ div [ class "navbar-header" ]
                    [ a [ class "navbar-brand", href "#" ] [ text "Doodles" ] ]
                ]
            ]
        ]


addDoodle : Model -> Html Msg
addDoodle model =
    div [ class "container-fluid" ]
        [ div [ class "row" ]
            [ div [ class "col-md-6 col-md-offset-3" ]
                [ h2 [] [ text "Get Doodling" ]
                , Html.form [ onSubmit Submit ]
                    [ label [] [ text "Name Your Doodle" ]
                    , div [ class "form-group" ]
                        [ input
                            [ type_ "text"
                            , class "form-control"
                            , value model.titleInput
                            , onInput TitleInput
                            ]
                            []
                        ]
                    ]
                ]
            ]
        ]


displayDoodles : List Doodle -> Html Msg
displayDoodles doodles =
    doodles
        |> List.map doodleContainer
        |> div [ class "row" ]


doodleContainer : Doodle -> Html Msg
doodleContainer doodle =
    div [ class "col-md-3" ]
        [ h3 [] [ text doodle.title ]
        , p [] [ text doodle.doodle ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
