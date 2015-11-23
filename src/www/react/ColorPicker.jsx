var React = require('react')
var ampersandReactMixin = require('ampersand-react-mixin')
var Color = require('color')
var f = require('lodash')

// TODO: fold into main export component
// (not needed since the preview is not wrapped anymore)
var EditForm = React.createClass({
  displayName: 'ColorPickerEditor',
  mixins: [ampersandReactMixin],
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

    // build controls from config
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
      <div className='editor form-horizontal'>
        {controls}
      </div>
    )
  }
})

var ValueControl = React.createClass({
  render: function () {
    var name = this.props.name
    var range = this.props.range
    var value = this.props.value
    var handler = this.props.handleChange

    return (
      <div>
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
      </div>
    )
  }
})

module.exports = React.createClass({
  displayName: 'ColorPicker',
  getInitialState: function() {
    return { color: Color(this.props.color) }
  },
  updateColor: function(color) {
    // parse into `color` object
    var color = Color(color)
    // set state internal to this component (plain object):
    this.setState({ color: color })
    // callback the handler of the "super/parent" component
    //  **with a valid CSS color**!
    if (typeof this.props.onChange === 'function') {
      this.props.onChange(color.hslString())
    }
  },
  render: function () {
    var color = this.state.color
    return (
      <div>
        <EditForm color={color}
          handleChange={this.updateColor}/>
      </div>
    )
  }
})
