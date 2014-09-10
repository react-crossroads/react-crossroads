express = require 'express'
request = require 'request'
exampleServer = require '../examples/server'

exports.startServer = (config, callback) ->
  config.modifyApp = (app) ->
    app.get '/history-location-app*', (req, res) ->
      url = "#{config.webpackServerAddress}/history-location-app"
      request(url).pipe(res)

    app.get '/refresh-location-app*', (req, res) ->
      url = "#{config.webpackServerAddress}/refresh-location-app"
      request(url).pipe(res)

    app.get '/history-location-store-app*', (req, res) ->
      url = "#{config.webpackServerAddress}/history-location-store-app"
      request(url).pipe(res)

  exampleServer.startServer config, callback

