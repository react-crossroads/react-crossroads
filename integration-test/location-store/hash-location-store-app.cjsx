React = require 'react'
LocationStoreComponent = require './location-store-component'

Router = require '../../src/components/Router'
Route = require '../../src/components/Route'

App = React.createClass
  displayName: 'App'
  render: ->
    <LocationStoreComponent>
      Hash Location Store Test
    </LocationStoreComponent>

React.renderComponent(
  <Router location='hash'>
    <Route path='/:path*:' handler={App} />
  </Router>
  , document.body
)
