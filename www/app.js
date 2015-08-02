// styles
require("!style!css!less!./styles.less");

var app = require('ampersand-app')
var Router = require('./lib/router.js')
var Me = require('coffee!./models/me.coffee');

// expose to browser console for development
window.app = app

app.extend({
  init: function () {

    this.me = new Me()
    // TODO: this.servers = new PixelServer({
    //   url: 'http://localhost:7892/api/'
    // })
    this.me.fetchInitialData()

    this.router = new Router()
    this.router.history.start()
  }
})

app.init()
