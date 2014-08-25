React = require 'react'
LocationStoreComponent = require './location-store-component'
HashLocation = require '../../src/locations/HashLocation'
LocationStore = require '../../src/stores/LocationStore'

LocationStore.setup HashLocation

React.renderComponent(
  <LocationStoreComponent>
    Hash Location Store Test
  </LocationStoreComponent>
  , document.body
)
