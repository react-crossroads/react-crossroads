RouterConstants = require '../constants/RouterConstants'

Dispatcher = require('flux').Dispatcher
_dispatcher = new Dispatcher()

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
