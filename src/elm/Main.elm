port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as JE
import Json.Decode as JD
import Json.Decode.Pipeline as JDP


-- model


type alias Model =
    { doodleInput : String
    , typefaceInput : String
    , textColorInput : String
    , textShadowLightInput : String
    , textShadowDarkInput : String
    , backgroundInput : String
    , doodles : List Doodle
    , uid : Maybe String
    , loggedIn : Bool
    , marginLeft : String
    , error : Maybe String
    }


type alias Doodle =
    { doodleId : String
    , doodle : String
    , typeface : String
    , textColor : String
    , textShadowLight : String
    , textShadowDark : String
    , background : String
    , likes : String
    }


type alias Flags =
    { fbLoggedIn : Maybe String }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        loggedIn =
            flags.fbLoggedIn /= Nothing

        initModel =
            { doodleInput = ""
            , typefaceInput = "Helvetica"
            , textColorInput = "#A1AAB5"
            , textShadowLightInput = "ccc"
            , textShadowDarkInput = "555"
            , backgroundInput = "#ffffff"
            , doodles = []
            , uid = flags.fbLoggedIn
            , loggedIn = False
            , marginLeft = "-100%"
            , error = Nothing
            }

        cmd =
            if loggedIn then
                fetchingDoodles "yes"
            else
                Cmd.none
    in
        ( initModel, cmd )



-- update


type Msg
    = TitleInput String
    | TypefaceChange String
    | TextColorChange String
    | TextShadowColorChange String
    | TextShadowDarkColorChange String
    | BackgroundColorChange String
    | Submit
    | DoodlesFromFirebase String
    | AddLike String String
    | ShowForm
    | HideForm
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleInput doodleInput ->
            ( { model | doodleInput = doodleInput }, Cmd.none )

        TypefaceChange newTypeface ->
            ( { model | typefaceInput = newTypeface }, Cmd.none )

        TextColorChange newColor ->
            ( { model | textColorInput = newColor }, Cmd.none )

        TextShadowColorChange newColor ->
            ( { model | textShadowLightInput = newColor }, sendHexToJs newColor )

        TextShadowDarkColorChange newColor ->
            ( { model | textShadowDarkInput = newColor }, Cmd.none )

        BackgroundColorChange newColor ->
            ( { model | backgroundInput = newColor }, Cmd.none )

        Submit ->
            let
                body =
                    JE.object
                        [ ( "doodle", JE.string model.doodleInput )
                        , ( "typeface", JE.string model.typefaceInput )
                        , ( "textColor", JE.string model.textColorInput )
                        , ( "textShadowLight", JE.string model.textShadowLightInput )
                        , ( "textShadowDark", JE.string model.textShadowDarkInput )
                        , ( "background", JE.string model.backgroundInput )
                        ]
                        |> JE.encode 4
            in
                ( { model
                    | doodleInput = ""
                    , typefaceInput = "Helvetica"
                    , textColorInput = "#A1AAB5"
                    , textShadowLightInput = "ccc"
                    , textShadowDarkInput = "555"
                    , backgroundInput = "#ffffff"
                    , doodles = []
                    , marginLeft = "-100%"
                  }
                , saveDoodle body
                )

        DoodlesFromFirebase jsonDoodles ->
            decodeJson jsonDoodles model

        AddLike like doodleId ->
            let
                updatedDoodle =
                    addLikeToDoodle (findDoodle doodleId model)

                addedDoodleToDoodles =
                    List.map
                        (\d ->
                            if d.doodleId == doodleId then
                                updatedDoodle
                            else
                                d
                        )
                        model.doodles

                body =
                    JE.object
                        [ ( "doodleId", JE.string doodleId )
                        , ( "likes", JE.string updatedDoodle.likes )
                        ]
                        |> JE.encode 4
            in
                ( { model | doodles = addedDoodleToDoodles }, addLikeToFirebase body )

        ShowForm ->
            ( { model | marginLeft = "0px" }, Cmd.none )

        HideForm ->
            ( { model | marginLeft = "-100%" }, Cmd.none )

        Error error ->
            ( { model | error = Just error }, Cmd.none )


addLikeToDoodle : Doodle -> Doodle
addLikeToDoodle doodle =
    let
        likesInt =
            Result.withDefault 0 (String.toInt doodle.likes)
    in
        { doodle | likes = toString (likesInt + 1) }


findDoodle : String -> Model -> Doodle
findDoodle doodleId model =
    List.head
        (List.filter
            (\d -> d.doodleId == doodleId)
            model.doodles
        )
        |> Maybe.withDefault
            { doodleId = ""
            , doodle = ""
            , typeface = ""
            , textColor = ""
            , textShadowLight = ""
            , textShadowDark = ""
            , background = ""
            , likes = ""
            }


decodeJson : String -> Model -> ( Model, Cmd Msg )
decodeJson jsonDoodles model =
    case JD.decodeString decodeDoodleItem jsonDoodles of
        Ok doodle ->
            ( { model | doodles = doodle :: model.doodles }, Cmd.none )

        Err err ->
            ( { model | error = Just err }, Cmd.none )


decodeDoodleItem : JD.Decoder Doodle
decodeDoodleItem =
    JDP.decode Doodle
        |> JDP.required "doodleId" JD.string
        |> JDP.required "doodle" JD.string
        |> JDP.required "typeface" JD.string
        |> JDP.required "textColor" JD.string
        |> JDP.required "textShadowLight" JD.string
        |> JDP.required "textShadowDark" JD.string
        |> JDP.required "background" JD.string
        |> JDP.required "likes" JD.string



-- view


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ div [ class "doodle-form-container", style [ ( "margin-left", model.marginLeft ) ] ]
            [ addDoodle model ]
        , div [ id "main" ]
            [ navBar
            , div [ class "container-fluid" ]
                [ displayDoodles model.doodles ]
            , div [ class "container" ] [ text (toString model) ]
            ]
        ]


navBar : Html Msg
navBar =
    header []
        [ nav [ class "navbar" ]
            [ div [ class "container-fluid" ]
                [ div [ class "navbar-header" ]
                    [ a [ class "navbar-brand", onClick ShowForm ] [ text "Add Doodle" ] ]
                ]
            ]
        ]


addDoodle : Model -> Html Msg
addDoodle model =
    div [ class "container-fluid" ]
        [ div [ class "row" ]
            [ div [ class "hide-form", onClick HideForm ] [ text "close" ]
            , div [ class "col-md-3 col-md-offset-4" ]
                [ div
                    [ class "graffiti-text-container"
                    , style
                        [ ( "background", model.backgroundInput )
                        , ( "font-family", model.typefaceInput )
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
                            , onInput TypefaceChange
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
                    , div [ class "form-group text-center" ]
                        [ button
                            [ type_ "submit"
                            , class "btn btn-custom"
                            ]
                            [ text "Save Doodle" ]
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
                , ( "font-family", doodle.typeface )
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
        , p [ id doodle.doodleId, class "likes", onClick (AddLike (toString doodle.likes) doodle.doodleId) ] [ text doodle.likes ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ sendLighterHexToElm TextShadowDarkColorChange
        , doodlesFromFirebase DoodlesFromFirebase
        ]


port fetchingDoodles : String -> Cmd msg


port sendHexToJs : String -> Cmd msg


port sendLighterHexToElm : (String -> msg) -> Sub msg


port saveDoodle : String -> Cmd msg


port doodlesFromFirebase : (String -> msg) -> Sub msg


port addLikeToFirebase : String -> Cmd msg


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
