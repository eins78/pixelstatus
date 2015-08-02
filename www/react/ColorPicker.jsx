var React = require('react')
var Color = require('color')
var f = require('lodash')

var Preview = React.createClass({
  render: function () {
    var color = Color(this.props.color)
    var hsl = color.hslString()

    return (
      <div className='preview' style={{background: hsl}}>
        <div className='color-name'>{hsl}</div>
      </div>
    )
  }
})

var Editor = React.createClass({
  render: function () {
    var color = Color(this.props.color)
    var updateColor = this.props.handleChange

    var controlsConf = [
      {
        displayName: 'Hue',
        keyName: 'hue',
        range: '359'
      },
      {
        displayName: 'Saturation',
        keyName: 'saturation',
        range: '100'
      },
      {
        displayName: 'Lightness',
        keyName: 'lightness',
        range: '100'
      }
    ]

    var controls = controlsConf.map(function (c) {
      var currentValue = color[c.keyName]()

      var handleChange = function (event) {
        updateColor(color[c.keyName](event.target.value))
      }

      return (<ValueControl key={c.keyName}
                name={c.displayName}
                value={currentValue}
                range={c.range}
                handleChange={handleChange}/>)
    })

    return (
      <form className='editor form-horizontal'>
        {controls}
      </form>
    )
  }
})

var ValueControl = React.createClass({
  render: function () {
    var name = this.props.name
    var range = this.props.range
    var value = this.props.value
    var handler = this.props.handleChange

    return (<div>
      <div className='col-xs-2'>
        <label title={name} className='text-center control-label'>
          {f(name).first}
        </label>
      </div>

      <div className='col-xs-7'>
        <input type='range' min='0' max={range}
              value={value} onChange={handler}
              className='form-control' />
      </div>

      <div className='col-xs-3'>
        <input type='text' value={value} onChange={handler}
              className='form-control text-right'/>
      </div>
    </div>)
  }
})

var ColorPicker = React.createClass({
  getInitialState: function() {
    return { color: Color(this.props.color) }
  },
  updateColor: function(color) {
    this.setState({ color: Color(color) })
  },
  render: function () {
    var color = this.state.color
    return (
      <div>
        <Preview color={color}/>
        <Editor color={color} handleChange={this.updateColor}/>
      </div>
    )
  }
})

module.exports = ColorPicker
