gulp = require 'gulp'
util = require 'gulp-util'

path = require 'path'

mocha = require 'gulp-mocha'
exit = require 'gulp-exit'
cjsx = require 'gulp-cjsx'
plumber = require 'gulp-plumber'
rimraf = require 'gulp-rimraf'

webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'

Ports =
  examples: 3000
  examplesWebPack: 3001
  integration: 3002
  integrationWebPack: 3003

addressForPort = (port) ->
  "http://localhost:#{port}"

runServer = (config, contentFolder, startServer, appPort, webPackPort, done) ->
  webpackServerAddress = addressForPort webPackPort

  webpackServer = new WebpackDevServer webpack(config),
    contentBase: path.join __dirname, contentFolder
    stats:
      colors: true
    hot: true

  server = startServer
    server:
      port: appPort
    webpackServerAddress: webpackServerAddress

  webpackServer.listen webPackPort, "localhost", (err) ->
    throw new util.PluginError "WebPack Server Startup", err if err
    util.log "[WebPack Server Startup]", "#{webpackServerAddress}/webpack-dev-server"
    done()

gulp.task 'build', ['clean'], ->
  gulp.src './src/**/*'
    .pipe plumber()
    .pipe cjsx({ bare: true })
    .pipe gulp.dest('./lib')

gulp.task 'clean', ->
  gulp.src('./lib', {read: false})
    .pipe plumber()
    .pipe rimraf()

gulp.task 'test-ci', ['test'] #, 'integration-test'] # TODO: Punting on integration tests on travis for now

gulp.task 'test', ->
  require 'coffee-react/register'
  gulp.src './test/main.coffee', {read: false}
    .pipe mocha()

gulp.task 'integration-test-ci', ->
  runSequence = require 'run-sequence'
  runSequence 'integration-test-server', 'integration-test'

gulp.task 'integration-test', ->
  gulp.src './integration-test/integration-test.coffee', {read: false}
    .pipe mocha()

gulp.task 'integration-test-server', (done) ->
  config = require './webpack.integration.test'
  startServer = require('./integration-test/server').startServer

  runServer config, 'integration-test', startServer, Ports.integration, Ports.integrationWebPack, done

gulp.task 'examples', (done) ->
  config = require './webpack.examples'
  startServer = require('./examples/server').startServer

  runServer config, 'examples-build', startServer, Ports.examples, Ports.examplesWebPack, done

gulp.task 'test-watch', ->
  gulp.watch ['src/**', 'test/**'], ['test']

gulp.task 'integration-test-watch', ['integration-test-server'], ->
  gulp.watch ['src/**', 'integration-test/**'], ['integration-test']

