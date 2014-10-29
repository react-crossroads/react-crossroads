React = require 'react'
{Router, Route, Link, DefaultRoute} = require '../../src'

NestedHandler = React.createClass
  render: ->
    <div>
      <Link to="blah" params={blah: 1}>1</Link>
      <Link to="blah" params={blah: 2}>2</Link>
    </div>

Home = React.createClass
  render: ->
    <div>
      home
      <Router location="memory" initialPath="/1">
        <DefaultRoute handler={NestedHandler} />
        <Route name="blah" path="{blah}" handler={NestedHandler} />
      </Router>
    </div>

module.exports = Home
