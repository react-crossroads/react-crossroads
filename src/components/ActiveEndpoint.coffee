ActiveHandler = require './ActiveHandler'

class ActiveEndpoint
  constructor: (@path, @endpoint, @params) ->

  render: ->
    rootHandler = new ActiveHandler @endpoint.chain, @params
    rootHandler.activeRouteHandler()

module.exports = ActiveEndpoint
