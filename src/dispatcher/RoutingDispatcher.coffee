RouterConstants = require '../constants/RouterConstants'
Logger = require '../utils/logger'

class RoutingDispatcher
  constructor: (@dispatcher) ->

  handleRouteAction: (action) ->
    Logger.debug.log "Router Dispatching: #{action?.actionType}"

    @dispatcher.dispatch
      source: RouterConstants.ROUTER_ACTION,
      action: action

  register: (handler) ->
    @dispatcher.register handler

  unregister: (id) ->
    @dispatcher.unregister id

  waitFor: (ids) ->
    @dispatcher.waitFor ids

module.exports = RoutingDispatcher
