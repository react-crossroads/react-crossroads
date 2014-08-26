NamedLocations =
  locations:
    hash: require './HashLocation'
    history: require './HistoryLocation'
    refresh: require './RefreshLocation'
    memory: require './MemoryLocation'   # Primarily for Testing
  locationFor: (name) =>
    throw new Error 'Location type is not supported' unless name in Object.keys(NamedLocations.locations)

    location = NamedLocations.locations[name]
    isSupported = location.isSupportedOrFallback()

    unless isSupported == true
      location = NamedLocations.locations[isSupported]

    location

module.exports = NamedLocations
