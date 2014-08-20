gulp = require 'gulp'
util = require 'gulp-util'

path = require 'path'

mocha = require 'gulp-mocha'
exit = require 'gulp-exit'

webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'

Ports =
  integration: 3002
  integrationWebPack: 3003

addressForPort = (port) ->
  "http://localhost:#{port}"

gulp.task 'test-ci', ['test'] #, 'integration-test'] # Punting on integration tests on travis for now

gulp.task 'test', ->
  gulp.src './test/main.coffee', {read: false}
    .pipe mocha()

gulp.task 'integration-test', ['integration-test-server'], ->
  gulp.src './integration-test/integration-test.coffee', {read: false}
    .pipe mocha()
    .pipe exit()

gulp.task 'integration-test-server', (done) ->
  webpackServerAddress = addressForPort Ports.integrationWebPack
  config = require './webpack.integration.test'

  webpackServer = new WebpackDevServer webpack(config),
    contentBase: path.join __dirname, 'integration-test'
    stats:
      colors: true
    hot: true

  server = require('./integration-test/server').startServer
    server:
      port: Ports.integration
    webpackServerAddress: webpackServerAddress

  webpackServer.listen Ports.integrationWebPack, "localhost", (err) ->
    throw new util.PluginError "integration-test", err if err
    util.log "[integration-test-server]", "#{webpackServerAddress}/webpack-dev-server"
    done()
