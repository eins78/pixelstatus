var React = require('react')
var ColorPicker = require('./ColorPicker')

var SectionData = React.createClass({
  render: function () {
    return <table className='table'>
      <tr className='status'>
        <td className='text-right'>status:</td>
        <td>OK</td>
      </tr>
      <tr>
        <td className='text-right'>output:</td>
        <td>
          <pre>{JSON.stringify({ LOL: "OMG" }, 0, 2)}</pre>
        </td>
      </tr>
      <tr>
        <td className='text-right'>last check:</td>
        <td>{(new Date()).toJSON()}</td>
      </tr>
    </table>
  }
})


var SectionPanel = React.createClass({
  render: function () {
    var section = this.props.section
    return (
      <div className='col-sm-6' key={section.name}>
        <div className='panel panel-default'>
          <div className='panel-heading'>
            {section.name}
          </div>
          <ColorPicker color={section.color}/>
          <SectionData/>
        </div>
      </div>
    )
  }
})

module.exports = SectionPanel
