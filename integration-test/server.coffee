express = require 'express'
request = require 'request'

exports.startServer = (config, callback) ->
  callback = callback || (->)
  port = process.env.PORT or config.server.port

  app = express()
  server = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  app.set 'port', port

  forwardToWebpackServer = (req, res) ->
    url = "#{config.webpackServerAddress}#{req.url}"
    request(url).pipe(res)

  app.get '/*.js', forwardToWebpackServer

  app.get '/history-location-app*', (req, res) ->
    url = "#{config.webpackServerAddress}/history-location-app"
    request(url).pipe(res)

  app.get '/refresh-location-app*', (req, res) ->
    url = "#{config.webpackServerAddress}/refresh-location-app"
    request(url).pipe(res)

  app.get '*', forwardToWebpackServer

  callback(server, app)
