module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Color exposing (..)
import Css exposing (..)


-- model


type alias Model =
    { doodleInput : String
    , backgroundInput : String
    , textColorInput : String
    , textShadowLightInput : String
    , textShadowDarkInput : String
    , doodles : List Doodle
    , error : Maybe String
    }


type alias Doodle =
    { doodleId : String
    , doodle : String
    , background : String
    , textColor : String
    , textShadowLight : String
    , textShadowDark : String
    , likes : Int
    }


tempDoodles : List Doodle
tempDoodles =
    [ Doodle "1" "something really crazy" "fff" "A1AAB5" "ff0000" "000" 1
    , Doodle "2 " "anoher" "333" "A1AAB5" "ff0000" "000" 0
    , Doodle "3" "keep 'em coming'" "fff" "ff0000" "ff0000" "000" 3
    , Doodle "4" "xzp" "fff" "A1AAB5" "ff0000" "000" 5
    , Doodle "5" "haha" "aaa" "fff" "ff0000" "000" 2
    , Doodle "6" "nnefvsoi" "fff" "A1AAB5" "ff0000" "000" 1
    , Doodle "7" "testing" "999" "A1AAB5" "ff0000" "000" 10
    , Doodle "8" "...more testing" "555" "fff" "ff0000" "000" 275
    ]


initModel : Model
initModel =
    { doodleInput = ""
    , backgroundInput = "fff"
    , textColorInput = "A1AAB5"
    , textShadowLightInput = "ccc"
    , textShadowDarkInput = "555"
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
    | AddLike String
    | Submit
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleInput doodleInput ->
            ( { model | doodleInput = doodleInput }, Cmd.none )

        AddLike like ->
            ( { model | error = Just like }, Cmd.none )

        Submit ->
            ( initModel, Cmd.none )

        Error error ->
            ( { model | error = Just error }, Cmd.none )



-- view


styles =
    Css.asPairs >> Html.Attributes.style


view : Model -> Html Msg
view model =
    div []
        [ navBar
        , addDoodle model
        , div [ Html.Attributes.class "container-fluid" ]
            [ displayDoodles model.doodles ]
        , div [ Html.Attributes.class "container" ] [ Html.text (toString model) ]
        ]


navBar : Html Msg
navBar =
    header []
        [ nav [ Html.Attributes.class "navbar" ]
            [ div [ Html.Attributes.class "container-fluid" ]
                [ div [ Html.Attributes.class "navbar-header" ]
                    [ a [ Html.Attributes.class "navbar-brand", href "#" ] [ Html.text "toString" ] ]
                ]
            ]
        ]


addDoodle : Model -> Html Msg
addDoodle model =
    div [ Html.Attributes.class "container-fluid" ]
        [ div
            [ Html.Attributes.class "graffiti-text-container"
            , styles
                [ backgroundColor (hex model.backgroundInput) ]
            ]
            [ ul
                [ Html.Attributes.class "graffiti-text"
                  -- , styles
                  --     [ color (hex model.textColorInput) ]
                ]
                [ li
                    [ style
                        [ ( "text-shadow", "-1px -1px 0 #fff, 0px 3px 0 #6a2689, 0px -3px 0 #6a2689, 3px 0px 0 #6a2689, -3px 0px 0 #6a2689, 3px 3px 0 #6a2689, 0 1px #6a2689, 1px 0 #c957fe, 1px 2px #6a2689, 2px 1px #c957fe, 2px 3px #6a2689, 3px 2px #c957fe, 3px 4px #6a2689, 4px 3px #c957fe, 4px 5px #6a2689, 5px 4px #c957fe, 5px 6px #6a2689, 6px 5px #c957fe, 6px 7px #6a2689, 7px 6px #c957fe, 7px 8px #6a2689, 8px 7px #c957fe, 8px 9px #6a2689, 9px 8px #c957fe, 9px 10px #6a2689, 10px 9px #c957fe, 10px 11px #6a2689, 11px 10px #c957fe, 11px 12px #6a2689, 12px 11px #c957fe, 12px 13px #6a2689, 13px 12px #c957fe, 13px 14px #6a2689, 14px 13px #6a2689, 14px 15px #6a2689, 15px 14px #6a2689, 16px 16px 15px rgba(0, 0, 0, .5)" )
                        ]
                    ]
                    [ Html.text model.doodleInput ]
                ]
            ]
        , div [ Html.Attributes.class "row" ]
            [ div [ Html.Attributes.class "col-md-12" ]
                [ Html.form [ onSubmit Submit ]
                    [ div [ Html.Attributes.class "form-group", placeholder "joke" ]
                        [ input
                            [ type_ "text"
                            , Html.Attributes.class "form-control"
                            , placeholder "add some elm view doodle"
                            , value model.doodleInput
                            , onInput TitleInput
                            ]
                            []
                        , label [] [ Html.text "Background Color" ]
                        , input
                            [ type_ "color"
                            , style
                                [ ( "border", "none" )
                                , ( "width", "20px" )
                                , ( "background", model.backgroundInput )
                                , ( "padding", "0" )
                                , ( "margin", "0" )
                                , ( "outline", "none" )
                                ]
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
        |> div [ Html.Attributes.class "row" ]


doodleContainer : Doodle -> Html Msg
doodleContainer doodle =
    div [ Html.Attributes.class "col-md-3" ]
        [ div
            [ Html.Attributes.class "graffiti-text-container"
            , style
                [ ( "background", "#" ++ doodle.background ) ]
            ]
            [ ul
                [ Html.Attributes.class "graffiti-text"
                , style
                    [ ( "color", doodle.textColor )
                    , ( "text-shadow", "-1px -1px 0 #fff, 0px 3px 0 #6a2689, 0px -3px 0 #6a2689, 3px 0px 0 #6a2689, -3px 0px 0 #6a2689, 3px 3px 0 #6a2689, 0 1px #6a2689, 1px 0 #c957fe, 1px 2px #6a2689, 2px 1px #c957fe, 2px 3px #6a2689, 3px 2px #c957fe, 3px 4px #6a2689, 4px 3px #c957fe, 4px 5px #6a2689, 5px 4px #c957fe, 5px 6px #6a2689, 6px 5px #c957fe, 6px 7px #6a2689, 7px 6px #c957fe, 7px 8px #6a2689, 8px 7px #c957fe, 8px 9px #6a2689, 9px 8px #c957fe, 9px 10px #6a2689, 10px 9px #c957fe, 10px 11px #6a2689, 11px 10px #c957fe, 11px 12px #6a2689, 12px 11px #c957fe, 12px 13px #6a2689, 13px 12px #c957fe, 13px 14px #6a2689, 14px 13px #6a2689, 14px 15px #6a2689, 15px 14px #6a2689, 16px 16px 15px rgba(0, 0, 0, .5)" )
                    ]
                ]
                [ li [] [ Html.text doodle.doodle ] ]
            ]
        , p [ Html.Attributes.id doodle.doodleId, Html.Attributes.class "likes", onClick (AddLike (toString doodle.likes)) ] [ Html.text (toString doodle.likes) ]
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
