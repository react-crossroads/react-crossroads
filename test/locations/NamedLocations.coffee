NamedLocations  = require '../../src/locations/NamedLocations'

HashLocation    = require '../../src/locations/HashLocation'
HistoryLocation = require '../../src/locations/HistoryLocation'
RefreshLocation = require '../../src/locations/RefreshLocation'
MemoryLocation  = require '../../src/locations/MemoryLocation'

describe 'Named Locations', ->
  it 'locationFor returns service if supported', ->
    result = NamedLocations.locationFor 'memory'
    result.should.equal MemoryLocation

  it 'locationFor returns fallback service if not supported', ->
    result = NamedLocations.locationFor 'hash'
    result.should.equal MemoryLocation
