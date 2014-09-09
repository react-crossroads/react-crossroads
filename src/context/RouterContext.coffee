RoutingDispatcher = require '../dispatcher/RoutingDispatcher'

LocationStore = require '../stores/LocationStore'
RouteStore = require '../stores/RouteStore'

RouterActions = require '../actions/RouterActions'

class RouterContext
  constructor: (dispatcher) ->
    @dispatcher = new RoutingDispatcher(dispatcher)

    @stores =
      location: new LocationStore @dispatcher, @

    @stores.route = new RouteStore @dispatcher, @stores.location

    @actions = new RouterActions @dispatcher, @stores.location

module.exports = RouterContext
