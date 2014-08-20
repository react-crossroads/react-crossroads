RoutingDispatcher = require '../dispatcher/RoutingDispatcher'
{EventEmitter} = require 'events'

class PathStore extends EventEmitter
  constructor: ->
    @dispatchToken = RoutingDispatcher.register(@handler)
  handler: (payload) =>
    null

module.exports = new PathStore
