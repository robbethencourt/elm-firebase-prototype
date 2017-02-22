// pull in desired CSS/SASS files
require('./styles/main.scss')

// inject bundled Elm app into div#main
var Elm = require('../elm/Main')

var app = Elm.Main.embed(document.getElementById('main'), {error: ''})

app.ports.sendHexToJs.subscribe(function (elmHex) {
  var hexArray =
    elmHex
      .substring(1)
      .split('')

  var hexArrays = [hexArray[0] + hexArray[1], hexArray[2] + hexArray[3], hexArray[4] + hexArray[5]]

  var hexToLighterRgb =
    hexArrays
      .map(hex => Math.round(parseInt(hex, 16) * 0.6).toString(16))

  var rgbToHexArray =
    hexToLighterRgb
      .map(rgb => rgb.length === 1 ? rgb + rgb : rgb)

  var newHexArray =
    rgbToHexArray
      .join('')

  console.log('#' + newHexArray)
  app.ports.sendLighterHexToElm.send('#' + newHexArray)
})
