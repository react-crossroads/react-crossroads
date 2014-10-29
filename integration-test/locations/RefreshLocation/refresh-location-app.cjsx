React = require 'react'
LocationApp = require '../location'
RefreshLocation = require '../../../src/locations/RefreshLocation'

React.renderComponent(
  <LocationApp location={RefreshLocation} rootPath='/refresh-location-app'>
    Refresh Location Test
  </LocationApp>
  , document.body
)
