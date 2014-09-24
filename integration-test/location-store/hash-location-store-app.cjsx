React = require 'react/addons'
global.React = React
LocationStoreComponent = require './location-store-component'

Router = require '../../src/components/Router'
Route = require '../../src/components/Route'
Redirect = require '../../src/components/Redirect'

App = React.createClass
  displayName: 'App'
  render: ->
    <LocationStoreComponent>
      Hash Location Store Test
    </LocationStoreComponent>

React.renderComponent(
  <Router location='hash'>
    <Route path='/:path*:' handler={App} />
    <Redirect fromPath='/redirect' path='/redirected' />
  </Router>
  , document.body
)
