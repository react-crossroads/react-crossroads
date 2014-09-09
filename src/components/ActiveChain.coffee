ActiveHandler = require './ActiveHandler'

class ActiveChain
  constructor: (@path, @routeChain, @params) ->

  render: ->
    rootHandler = new ActiveHandler @routeChain.chain, @params
    rootHandler.activeRouteHandler()

module.exports = ActiveChain
