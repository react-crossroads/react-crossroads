React = require 'react'
LocationStoreComponent = require './location-store-component'

Router = require '../../src/components/Router'
Route = require '../../src/components/Route'

App = React.createClass
  displayName: 'App'
  render: ->
    <LocationStoreComponent>
      History Location Store Test
    </LocationStoreComponent>

React.renderComponent(
  <Router location='history' initialPath='/history-location-store-app'>
    <Route path='/:path*:' handler={App} />
  </Router>
  , document.body
)
