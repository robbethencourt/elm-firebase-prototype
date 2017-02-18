module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Canvas exposing (Canvas, Position, Size)
import Color exposing (Color)


-- model


type alias Model =
    { titleInput : String
    , move : Maybe Position
    , click : Maybe Position
    , canvas : Canvas
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
    , move = Nothing
    , click = Nothing
    , canvas =
        Size 500 400
            |> Canvas.initialize
            |> Canvas.fill Color.black
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
    | MouseDown Position
    | MouseMove Position
    | Submit
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleInput titleInput ->
            ( { model | titleInput = titleInput }, Cmd.none )

        MouseDown position0 ->
            case model.click of
                Just position1 ->
                    ( draw position0 position1 model, Cmd.none )

                Nothing ->
                    ( { model | click = Just position0 }, Cmd.none )

        MouseMove position ->
            ( { model | move = Just position }, Cmd.none )

        Submit ->
            ( initModel, Cmd.none )

        Error error ->
            ( { model | error = Just error }, Cmd.none )


draw : Position -> Position -> Model -> Model
draw p0 p1 model =
    { model
        | click = Nothing
        , canvas =
            Canvas.drawLine p0 p1 Color.blue model.canvas
    }



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
                    , Canvas.toHtml
                        [ Canvas.onMouseDown MouseDown
                        , Canvas.onMouseMove MouseMove
                        , style
                            [ ( "cursor", "crosshair" ) ]
                        ]
                        (renderCanvas model)
                    ]
                ]
            ]
        ]


renderCanvas : Model -> Canvas
renderCanvas model =
    case model.move of
        Nothing ->
            model.canvas

        Just position0 ->
            case model.click of
                Nothing ->
                    model.canvas

                Just position1 ->
                    Canvas.drawLine
                        position0
                        position1
                        (Color.hsl 0 0.5 0.5)
                        model.canvas


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
        , subscriptions = always Sub.none
        }
