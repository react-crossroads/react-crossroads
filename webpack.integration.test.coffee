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
    new webpack.DefinePlugin
      PRODUCTION: false
      DEVELOPMENT: true
      'process.env.NODE_ENV': '"development"'
      DEBUG_ROUTING: true
  ]
