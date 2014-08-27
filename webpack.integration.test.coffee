path = require 'path'
webpack = require 'webpack'

module.exports =
  cache: true
  entry:
    "hash-location-app": './integration-test/locations/HashLocation/hash-location-app.cjsx'
    "history-location-app": './integration-test/locations/HistoryLocation/history-location-app.cjsx'
    "refresh-location-app": './integration-test/locations/RefreshLocation/refresh-location-app.cjsx'
    "history-location-store-app": './integration-test/location-store/history-location-store-app.cjsx'
    "hash-location-store-app": './integration-test/location-store/hash-location-store-app.cjsx'
    "router": './integration-test/router/router.cjsx'
  output:
    path: path.join __dirname, 'integration-test'
    filename: '[name].js'
  module:
    loaders: [
      {test: /\.cjsx$/, loader: "coffee!cjsx"}
      {test: /\.coffee$/, loader: "coffee"}
    ]
  resolve:
    extensions: ['', '.coffee', '.cjsx', '.js']
  plugins: [
  ]
