// styles
require("!style!css!less!./styles.less");
var Router = require('./lib/router.js')

window.app = {
  init: function () {
    this.router = new Router()
    this.router.history.start()
  }
}

window.app.init()
