var React = require('react')
module.exports = React.createClass({
  displayName: 'Header',
  render: function () {
    return <header>
      <h1 className='page-header'>
        {this.props.name}
      </h1>
    </header>
  }
})
