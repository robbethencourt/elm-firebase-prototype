port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


-- model


type alias Model =
    { doodleInput : String
    , fontInput : String
    , textColorInput : String
    , textShadowLightInput : String
    , textShadowDarkInput : String
    , backgroundInput : String
    , doodles : List Doodle
    , error : Maybe String
    }


type alias Doodle =
    { doodleId : String
    , doodle : String
    , font : String
    , textColor : String
    , textShadowLight : String
    , textShadowDark : String
    , background : String
    , likes : Int
    }


tempDoodles : List Doodle
tempDoodles =
    [ Doodle "1" "something really crazy" "Helvetica" "#A1AAB5" "#ff0000" "#000000" "#ffffff" 1
    , Doodle "2" "anoher" "georgia" "#A1AAB5" "#ff0000" "#000000" "#333333" 0
    , Doodle "3" "keep 'em coming'" "Helvetica" "#ff0000" "#ff0000" "#000000" "#ffffff" 3
    , Doodle "4" "xzp" "Permanent Marker" "#A1AAB5" "#ff0000" "#000000" "#ffffff" 5
    , Doodle "5" "haha" "Helvetica" "#ffffff" "#ff0000" "#000000" "#aaaaaa" 2
    , Doodle "6" "nnefvsoi" "Permanent Marker" "#A1AAB5" "#ff0000" "#000000" "#ffffff" 1
    , Doodle "7" "testing" "Helvetica" "#A1AAB5" "#ff0000" "#000000" "#555555" 10
    , Doodle "8" "...more testing" "Helvetica" "#ffffff" "#ff0000" "#000000" "#555555" 275
    ]


initModel : Model
initModel =
    { doodleInput = ""
    , fontInput = "Helvetica"
    , textColorInput = "#A1AAB5"
    , textShadowLightInput = "ccc"
    , textShadowDarkInput = "555"
    , backgroundInput = "fff"
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
    | FontChange String
    | TextColorChange String
    | TextShadowColorChange String
    | TextShadowDarkColorChange String
    | BackgroundColorChange String
    | Submit
    | AddLike String
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleInput doodleInput ->
            ( { model | doodleInput = doodleInput }, Cmd.none )

        FontChange newFont ->
            ( { model | fontInput = newFont }, Cmd.none )

        TextColorChange newColor ->
            ( { model | textColorInput = newColor }, Cmd.none )

        TextShadowColorChange newColor ->
            ( { model | textShadowLightInput = newColor }, sendHexToJs newColor )

        TextShadowDarkColorChange newColor ->
            ( { model | textShadowDarkInput = newColor }, Cmd.none )

        BackgroundColorChange newColor ->
            ( { model | backgroundInput = newColor }, Cmd.none )

        Submit ->
            ( initModel, Cmd.none )

        AddLike like ->
            ( { model | error = Just like }, Cmd.none )

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
            [ div [ class "col-md-3 col-md-offset-4" ]
                [ div
                    [ class "graffiti-text-container"
                    , style
                        [ ( "background", model.backgroundInput )
                        , ( "font-family", model.fontInput )
                        ]
                    ]
                    [ ul
                        [ class "graffiti-text" ]
                        [ li
                            [ style
                                [ ( "color", model.textColorInput )
                                , ( "text-shadow", "-1px -1px 0 #fff, 0px 3px 0 " ++ model.textShadowDarkInput ++ ", 0px -3px 0 " ++ model.textShadowDarkInput ++ ", 3px 0px 0 " ++ model.textShadowDarkInput ++ ", -3px 0px 0 " ++ model.textShadowDarkInput ++ ", 3px 3px 0 " ++ model.textShadowDarkInput ++ ", 0 1px " ++ model.textShadowDarkInput ++ ", 1px 0 " ++ model.textShadowLightInput ++ ", 1px 2px " ++ model.textShadowDarkInput ++ ", 2px 1px " ++ model.textShadowLightInput ++ ", 2px 3px " ++ model.textShadowDarkInput ++ ", 3px 2px " ++ model.textShadowLightInput ++ ", 3px 4px " ++ model.textShadowDarkInput ++ ", 4px 3px " ++ model.textShadowLightInput ++ ", 4px 5px " ++ model.textShadowDarkInput ++ ", 5px 4px " ++ model.textShadowLightInput ++ ", 5px 6px " ++ model.textShadowDarkInput ++ ", 6px 5px " ++ model.textShadowLightInput ++ ", 6px 7px " ++ model.textShadowDarkInput ++ ", 7px 6px " ++ model.textShadowLightInput ++ ", 7px 8px " ++ model.textShadowDarkInput ++ ", 8px 7px " ++ model.textShadowLightInput ++ ", 8px 9px " ++ model.textShadowDarkInput ++ ", 9px 8px " ++ model.textShadowLightInput ++ ", 9px 10px " ++ model.textShadowDarkInput ++ ", 10px 9px " ++ model.textShadowLightInput ++ ", 10px 11px " ++ model.textShadowDarkInput ++ ", 11px 10px " ++ model.textShadowLightInput ++ ", 11px 12px " ++ model.textShadowDarkInput ++ ", 12px 11px " ++ model.textShadowLightInput ++ ", 12px 13px " ++ model.textShadowDarkInput ++ ", 13px 12px " ++ model.textShadowLightInput ++ ", 13px 14px " ++ model.textShadowDarkInput ++ ", 14px 13px " ++ model.textShadowDarkInput ++ ", 14px 15px " ++ model.textShadowDarkInput ++ ", 15px 14px " ++ model.textShadowDarkInput ++ ", 16px 16px 15px rgba(0, 0, 0, .5)" )
                                ]
                            ]
                            [ text model.doodleInput ]
                        ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-md-12" ]
                [ Html.form [ class "doodle-form", onSubmit Submit ]
                    [ div [ class "form-group" ]
                        [ input
                            [ type_ "text"
                            , class "form-control"
                            , placeholder "add some elm view doodle"
                            , value model.doodleInput
                            , onInput TitleInput
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label [] [ text "Typeface" ]
                        , select
                            [ defaultValue "Helvetica"
                            , class "form-control"
                            , onInput FontChange
                            ]
                            [ option [] [ text "Helvetica" ]
                            , option [] [ text "Kanit" ]
                            , option [] [ text "Permanent Marker" ]
                            ]
                        ]
                    , div [ class "form-group" ]
                        [ label [] [ text "Text Color" ]
                        , input
                            [ type_ "color"
                            , defaultValue "#ffffff"
                            , class "form-control"
                            , onInput TextColorChange
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label [] [ text "Text Shadow Color" ]
                        , input
                            [ type_ "color"
                            , defaultValue "#ffffff"
                            , class "form-control"
                            , onInput TextShadowColorChange
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label [] [ text "Background Color" ]
                        , input
                            [ type_ "color"
                            , defaultValue "#ffffff"
                            , class "form-control"
                            , onInput BackgroundColorChange
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
        [ div
            [ class "graffiti-text-container"
            , style
                [ ( "background", doodle.background )
                , ( "font-family", doodle.font )
                ]
            ]
            [ ul
                [ class "graffiti-text"
                , style
                    [ ( "color", doodle.textColor )
                    , ( "text-shadow", "-1px -1px 0 #fff, 0px 3px 0 " ++ doodle.textShadowDark ++ ", 0px -3px 0 " ++ doodle.textShadowDark ++ ", 3px 0px 0 " ++ doodle.textShadowDark ++ ", -3px 0px 0 " ++ doodle.textShadowDark ++ ", 3px 3px 0 " ++ doodle.textShadowDark ++ ", 0 1px " ++ doodle.textShadowDark ++ ", 1px 0 " ++ doodle.textShadowLight ++ ", 1px 2px " ++ doodle.textShadowDark ++ ", 2px 1px " ++ doodle.textShadowLight ++ ", 2px 3px " ++ doodle.textShadowDark ++ ", 3px 2px " ++ doodle.textShadowLight ++ ", 3px 4px " ++ doodle.textShadowDark ++ ", 4px 3px " ++ doodle.textShadowLight ++ ", 4px 5px " ++ doodle.textShadowDark ++ ", 5px 4px " ++ doodle.textShadowLight ++ ", 5px 6px " ++ doodle.textShadowDark ++ ", 6px 5px " ++ doodle.textShadowLight ++ ", 6px 7px " ++ doodle.textShadowDark ++ ", 7px 6px " ++ doodle.textShadowLight ++ ", 7px 8px " ++ doodle.textShadowDark ++ ", 8px 7px " ++ doodle.textShadowLight ++ ", 8px 9px " ++ doodle.textShadowDark ++ ", 9px 8px " ++ doodle.textShadowLight ++ ", 9px 10px " ++ doodle.textShadowDark ++ ", 10px 9px " ++ doodle.textShadowLight ++ ", 10px 11px " ++ doodle.textShadowDark ++ ", 11px 10px " ++ doodle.textShadowLight ++ ", 11px 12px " ++ doodle.textShadowDark ++ ", 12px 11px " ++ doodle.textShadowLight ++ ", 12px 13px " ++ doodle.textShadowDark ++ ", 13px 12px " ++ doodle.textShadowLight ++ ", 13px 14px " ++ doodle.textShadowDark ++ ", 14px 13px " ++ doodle.textShadowDark ++ ", 14px 15px " ++ doodle.textShadowDark ++ ", 15px 14px " ++ doodle.textShadowDark ++ ", 16px 16px 15px rgba(0, 0, 0, .5)" )
                    ]
                ]
                [ li [] [ text doodle.doodle ] ]
            ]
        , p [ id doodle.doodleId, class "likes", onClick (AddLike (toString doodle.likes)) ] [ text (toString doodle.likes) ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ sendLighterHexToElm TextShadowDarkColorChange ]


port sendHexToJs : String -> Cmd msg


port sendLighterHexToElm : (String -> msg) -> Sub msg


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
