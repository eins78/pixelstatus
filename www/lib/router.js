var Router = require('ampersand-router')
var React = require('react')

var IndexPage = require('../react/IndexPage')

module.exports = Router.extend({
  routes: {
    '': 'public',
    'test': 'test'
  },
  public: function () {
    React.render(<IndexPage/>, document.body)
  },
  test: function () {
    console.log('test');
    React.render(<IndexPage/>, document.body)
  }
})
