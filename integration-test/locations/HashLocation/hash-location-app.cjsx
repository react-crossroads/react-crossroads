React = require 'react'
LocationApp = require '../location'
HashLocation = require '../../../src/locations/HashLocation'

React.renderComponent(
  <LocationApp location={HashLocation}>
    Hash Location Test
  </LocationApp>
  , document.body
)
