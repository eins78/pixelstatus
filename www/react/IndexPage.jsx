var React = require('react')
var Header = require('./Header')
var SectionPanel = require('./SectionPanel')

var SECTIONS = [
  { name: 'npm_web', color: 'lightgreen' },
  { name: 'npm_reg', color: 'lightsalmon' }
]

var SectionsList = React.createClass({
  render: function () {
    var panels = this.props.sections.map(function (s) {
      return <SectionPanel section={s} key={s.name}/>
    })

    return <section id="sections">
      <h2>
        sections
      </h2>
      <div className='row'>
        {panels}
      </div>
    </section>
  }
})

module.exports = React.createClass({
  displayName: 'IndexPage',
  render: function () {
    return <div className='container'>
      <Header name='statuspixel'/>
      <SectionsList sections={SECTIONS}/>
    </div>
  }
})
