path = require 'path'
webpack = require 'webpack'

module.exports =
  cache: true
  entry:
    'address-book': './examples/address-book/app.cjsx'
  output:
    path: path.join __dirname, 'examples-build'
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
