RouterConstants = require '../constants/RouterConstants'

class RoutingDispatcher
  constructor: (@dispatcher) ->

  handleRouteAction: (action) ->
    @dispatcher.dispatch
      source: RouterConstants.ROUTER_ACTION,
      action: action

  register: (handler) ->
    @dispatcher.register handler

module.exports = RoutingDispatcher
