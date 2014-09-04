RoutingDispatcher = require '../dispatcher/RoutingDispatcher'

LocationStore = require '../stores/LocationStore'
RouteStore = require '../stores/RouteStore'

RouterActions = require '../actions/RouterActions'

class RouterContext
  constructor: (dispatcher) ->
    routingDispatcher = new RoutingDispatcher(dispatcher)

    @stores =
      location: new LocationStore routingDispatcher, @

    @stores.route = new RouteStore routingDispatcher, @stores.location

    @actions = new RouterActions(routingDispatcher, @stores.location)

module.exports = RouterContext
