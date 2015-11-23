var React = require('react')

module.exports = React.createClass({
  displayName: 'Layout',

  render: function () {
    var children = this.props.children

    return (
      <div className='layout container'>

        <header>
          <h1 className='page-header'>
            {this.props.pageTitle}
          </h1>
        </header>

        {children}

      </div>
    )
  }
})
