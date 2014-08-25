React = require 'react'
LocationStoreComponent = require './location-store-component'
HistoryLocation = require '../../src/locations/HistoryLocation'
LocationStore = require '../../src/stores/LocationStore'

LocationStore.setup HistoryLocation, '/history-location-store-app'

React.renderComponent(
  <LocationStoreComponent>
    History Location Store Test
  </LocationStoreComponent>
  , document.body
)
