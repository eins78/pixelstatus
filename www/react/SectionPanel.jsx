var React = require('react')
var ampersandReactMixin = require('ampersand-react-mixin')
var ColorPicker = require('./ColorPicker')

var SectionData = React.createClass({
  render: function () {
    return (
      <table className='table'>
        <tr className='status'>
          <td className='text-right'>status:</td>
          <td>OK</td>
        </tr>
        <tr>
          <td className='text-right'>output:</td>
          <td>
            <pre>{JSON.stringify(this.props.section,0,2)}</pre>
          </td>
        </tr>
        <tr>
          <td className='text-right'>last check:</td>
          <td>{(new Date()).toJSON()}</td>
        </tr>
      </table>
    )
  }
})

var ColorPreview = React.createClass({
  render: function () {
    var color = this.props.color
    return (
      <div className='preview' style={{background: color}}>
        <div className='color-name'>{color}</div>
      </div>
    )
  }
})

var SectionPanel = React.createClass({
  // NOTE: section.color on model vs. state.color in editing mode

  // react methods:
  mixins: [ampersandReactMixin],
  getInitialState: function () {
    return {
      editing: false,
      color: null
    }
  },

  // component methods:
  onEditClick: function () {
    this.setState({
      editing: true,
      color: this.props.color
    })
  },
  onCancelClick: function () {
    this.setState(this.getInitialState())
  },
  onSaveClick: function () {
    this.props.section.updateColor(this.state.color)
    this.setState(this.getInitialState())
  },
  onColorChange: function (color) {
    this.setState({color: color})
  },

  render: function () {
    // TODO: edit for all color props ('ok' and 'fail')
    // instead of current section color
    // (needs server implementation)
    var section = this.props.section
    var color = this.state.color || this.props.section.color

    var editOrNot = null // show Edit button or Editor depending on state.editing
    var editWarning = null // show a label if state.editing

    if (this.state.editing) {
      editOrNot = (<div>
        <ColorPicker color={color} onChange={this.onColorChange}/>
        <button onClick={this.onSaveClick}>Save</button>
        <button onClick={this.onCancelClick}>Cancel</button>
      </div>)
      editWarning = (
        <span className="label label-warning pull-right">
          EDITING!
        </span>
      )
    } else {
      editOrNot = (<button onClick={this.onEditClick}>Edit</button>)
    }

    return (
      <div className='col-sm-6' key={section.name}>
        <div className='panel panel-default'>
          <div className='panel-heading'>
            <h4>
            {section.id}
            {editWarning}
            </h4>
          </div>
          <ColorPreview color={color} onClick={this.startEditing}/>
          {editOrNot}
          <SectionData section={section}/>
        </div>
      </div>
    )
  }
})

module.exports = SectionPanel
