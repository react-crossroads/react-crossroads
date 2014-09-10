ActiveHandler = require './ActiveHandler'

class ActiveEndpoint
  constructor: (@endpoint, @params) ->

  render: ->
    rootHandler = new ActiveHandler @endpoint.chain, @params
    rootHandler.activeRouteHandler()

module.exports = ActiveEndpoint
