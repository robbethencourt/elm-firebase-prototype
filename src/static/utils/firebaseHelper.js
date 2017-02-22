/* global firebase */

var config = require('../../../keys')
var fbApp = firebase.initializeApp(config)
var database = fbApp.database()

var firebaseHelper = {
  saveDoodleToFirebase: function (doodleToSave) {
    return fbApp.database()
      .ref('doodles')
      .push(doodleToSave)
  }, // end saveDoodleToFirebase()
  fetchingDoodlesFromFirebase: function () {
    return database.ref('/doodles').once('value')
  }, // end fetchingDoodlesFromFirebase()
  addLikeToDoodleInFirebase: function (idandLikes) {
    return database.ref('/doodles/' + idandLikes.doodleId).update({'likes': idandLikes.likes})
  }
} // end firebaseHelper

module.exports = firebaseHelper
