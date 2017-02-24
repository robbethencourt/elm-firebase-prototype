require('./styles/main.scss')
var firebaseHelper = require('./utils/firebaseHelper')

var Elm = require('../elm/Main')
var app = Elm.Main.embed(document.getElementById('main'), {fbLoggedIn: 'ok to go'}) // null allows elm to pass error to user

// Ports

// fetch doodles from firebase
app.ports.fetchingDoodles.subscribe(function () {
  fetchDoodles()
})

// hex conversion to lighter color
app.ports.sendHexToJs.subscribe(function (elmHex) {
  var hexArray =
    elmHex
      .substring(1)
      .split('')

  var hexArrays = [hexArray[0] + hexArray[1], hexArray[2] + hexArray[3], hexArray[4] + hexArray[5]]

  var hexToLighterRgb =
    hexArrays
      .map(function (hex) {
        Math.round(parseInt(hex, 16) * 0.8).toString(16)
      })

  var rgbToHexArray =
    hexToLighterRgb
      .map(function (rgb) {
        rgb.length === 1 ? rgb + rgb : rgb
      })

  var newHexArray =
    rgbToHexArray
      .join('')

  app.ports.sendDarkerHexToElm.send('#' + newHexArray)
})

// save doodle to firebase, then retrieve all doodles to send back to elm
app.ports.saveDoodle.subscribe(function (elmDoodle) {
  var jpElmDoodle = JSON.parse(elmDoodle)
  var doodleToSave = {
    doodle: jpElmDoodle.doodle,
    typeface: jpElmDoodle.typeface,
    textColor: jpElmDoodle.textColor,
    textShadowLight: jpElmDoodle.textShadowLight,
    textShadowDark: jpElmDoodle.textShadowDark,
    background: jpElmDoodle.background,
    likes: 0,
    date: Date.now()
  }

  firebaseHelper.saveDoodleToFirebase(doodleToSave)
    .then(function (fbRes) {
      fetchDoodles()
    })
})

// save like to firebase
app.ports.addLikeToFirebase.subscribe(function (elmDoodleIdAndLikes) {
  var jpElmDoodleIdAndLikes = JSON.parse(elmDoodleIdAndLikes)
  firebaseHelper.addLikeToDoodleInFirebase(jpElmDoodleIdAndLikes)
})

function fetchDoodles () {
  firebaseHelper.fetchingDoodlesFromFirebase()
    .then(function (fbDoodlesRes) {
      var fbDoodleObject = fbDoodlesRes.val()
      var arrayOfDoodleIds =
        Object.keys(fbDoodleObject)

      var arrayOfDoodleObjects =
        Object.values(fbDoodleObject)

      var doodleObjectsForElm =
        arrayOfDoodleObjects
          .map(function (obj, i) {
            return {
              doodleId: arrayOfDoodleIds[i],
              doodle: obj.doodle,
              typeface: obj.typeface,
              textColor: obj.textColor,
              textShadowLight: obj.textShadowLight,
              textShadowDark: obj.textShadowDark,
              background: obj.background,
              likes: obj.likes.toString()
            }
          })

      doodleObjectsForElm
        .forEach(function (doodle) {
          app.ports.doodlesFromFirebase.send(JSON.stringify(doodle))
        })
    })
}
