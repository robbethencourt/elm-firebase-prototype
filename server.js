var express = require('express')
var bodyParser = require('body-parser')
var logger = require('morgan')

// Create Instance of Express
var app = express()
var PORT = process.env.PORT || 3000 // Sets an initial port. We'll use this later in our listener

// Run Morgan for Logging
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.text())
app.use(bodyParser.json({type: 'application/vnd.api+json'}))

app.use(express.static('./dist'))

// Routes

// Main Route. This route will redirect to our rendered React application
app.get('/', function (req, res) {
  res.sendFile(__dirname + './index.html')
}) // end app.get()

// this is the listener setup for integrating socket.io
app.listen(PORT, function () {
  console.log('App listening on PORT: ' + PORT)
})
