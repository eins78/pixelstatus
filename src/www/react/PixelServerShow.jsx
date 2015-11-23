var React = require('react')
var SectionPanel = require('./SectionPanel')

var ampersandReactMixin = require('ampersand-react-mixin')

module.exports = React.createClass({
  displayName: 'PixelServerShow',
  mixins: [ampersandReactMixin],

  render: function () {
    var sections = this.props.sections

    return <section id="sections">
      <h3> sections </h3>
      <div className='row'>
        {sections.map(function (s) {
          return (
            <SectionPanel section={s} key={s.name}/>
          )
        })}
      </div>
    </section>
  }
})
