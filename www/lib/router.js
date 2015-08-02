var Router = require('ampersand-router')
var React = require('react')
var app = require('ampersand-app')

var Layout = require('../react/Layout')
var IndexPage = require('../react/IndexPage')

module.exports = Router.extend({
  renderPage: function (page) {
    page = (
      <Layout pageTitle='pixelstatus'>
        {page}
      </Layout>
    )
    React.render(page, document.body)
  },
  routes: { '': 'index' },
  index: function () {
    this.renderPage(<IndexPage me={app.me}/>)
  }
})
