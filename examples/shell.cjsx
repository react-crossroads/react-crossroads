React = require 'react'

Shell = React.createClass
  displayName: 'Shell'
  render: ->
    <div>
      <header>
        <h1>
          React-Crossroads Examples <small><a href="/">Go to index</a></small>
        </h1>
      </header>
      <this.props.activeRouteHandler />
    </div>

module.exports = Shell
