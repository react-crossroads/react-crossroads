React = require 'react'
LocationApp = require '../location'
HistoryLocation = require '../../../src/locations/HistoryLocation'

React.renderComponent(
  <LocationApp location={HistoryLocation} initialPath='/history-location-app'>
    History Location Test
  </LocationApp>
  , document.body
)
