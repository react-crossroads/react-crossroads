path = require 'path'
webpack = require 'webpack'

module.exports =
  cache: true
  entry:
    'address-book': './examples/address-book/app.cjsx'
    'nested-routers': './examples/nested-routers/app.cjsx'
  output:
    path: path.join __dirname, 'examples-build'
    filename: '[name].js'
  module:
    loaders: [
      { test: /\.cjsx$/, loader: "coffee!cjsx" }
      { test: /\.coffee$/, loader: "coffee" }
      { test: /\.css$/, loader: "style-loader!css-loader" }
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
