RouterConstants = require '../constants/RouterConstants'

_dispatcher = require 'react-dispatcher'

RoutingDispatcher =
  handleRouteAction: (action) ->
    _dispatcher.dispatch
      source: RouterConstants.ROUTER_ACTION,
      action: action
  initialize: (dispatcher) ->
    _dispatcher = dispatcher
  register: (handler) ->
    _dispatcher.register handler
  getDispatcher: ->
    _dispatcher

module.exports = RoutingDispatcher
