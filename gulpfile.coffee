gulp = require 'gulp'
util = require 'gulp-util'

path = require 'path'

mocha = require 'gulp-mocha'
exit = require 'gulp-exit'

webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'

webDevServerIntegrationTestPort = 3002

addressForPort = (port) ->
  "http://localhost:#{port}"

gulp.task 'integration-test', ['integration-test-server'], ->
  gulp.src './integration-test/integration-test.coffee', {read: false}
    .pipe mocha()
    .pipe exit()

gulp.task 'integration-test-server', (done) ->
  integrationTestAddress = addressForPort webDevServerIntegrationTestPort
  config = require './webpack.integration.test'

  server = new WebpackDevServer webpack(config),
    contentBase: path.join __dirname, 'integration-test'
    stats:
      colors: true
    hot: true

  server.listen webDevServerIntegrationTestPort, "localhost", (err) ->
    throw new util.PluginError "integration-test", err if err
    util.log "[integration-test-server]", "#{integrationTestAddress}/webpack-dev-server"
    done()
