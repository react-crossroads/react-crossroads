path = require 'path'
webpack = require 'webpack'
config = require './webpack.examples'

config.entry["hash-location-app"] = './integration-test/locations/HashLocation/hash-location-app.cjsx'
config.entry["history-location-app"] = './integration-test/locations/HistoryLocation/history-location-app.cjsx'
config.entry["refresh-location-app"] = './integration-test/locations/RefreshLocation/refresh-location-app.cjsx'
config.entry["history-location-store-app"] = './integration-test/location-store/history-location-store-app.cjsx'
config.entry["hash-location-store-app"] = './integration-test/location-store/hash-location-store-app.cjsx'

module.exports = config
