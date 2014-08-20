RoutingDispatcher = require '../dispatcher/RoutingDispatcher'
{EventEmitter} = require 'events'

class RouteStore extends EventEmitter
  constructor: ->
    @dispatchToken = RoutingDispatcher.register(@handler)
  handler: (payload) =>
    null

module.exports = new RouteStore
