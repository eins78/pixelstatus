var React = require('react')
var ampersandReactMixin = require('ampersand-react-mixin')

var PixelServerShow = require('./PixelServerShow')

var SECTIONS = [
  { name: 'npm_web', color: 'lightgreen' },
  { name: 'npm_reg', color: 'lightsalmon' }
]

var TestPre= React.createClass({
  render: function () {
    return (
      <pre>{JSON.stringify(this.props.servers,0,2)}</pre>
    )
  }
})

module.exports = React.createClass({
  displayName: 'IndexPage',
  mixins: [ampersandReactMixin],

  render: function () {
    var me = this.props.me

    console.log('RENDER IndexPage', me);

    return (
      <div>

        <h3>{me.title}</h3>

        <PixelServerShow sections={me.sections}/>

      </div>
    )
  }
})
