RoutingDispatcher = require '../dispatcher/RoutingDispatcher'
LocationStore = require '../stores/LocationStore'
RouterConstants = require '../constants/RouterConstants'

_transition = (path, fromLocationEvent) ->
  RoutingDispatcher.handleRouteAction
    actionType: RouterConstants.LOCATION_CHANGE
    path: path
    fromLocationEvent: fromLocationEvent

RouterActions =
  # TODO: Build path with to, params, query
  transition: (path) ->
    console.log "RouterActions.transition(#{path})"
    if LocationStore.isBlocked()
      throw new Error 'NOT IMPLEMENTED'
    else
      _transition path, false

  # TODO: Build path with to, params, query
  replace: (path) ->
    console.log "RouterActions.replace(#{path})"
    if LocationStore.isBlocked()
      throw new Error 'NOT IMPLEMENTED'
    else
      RoutingDispatcher.handleRouteAction
        actionType: RouterConstants.LOCATION_REPLACE
        path: path

  back: ->
    console.log "RouterActions.back()"
    if LocationStore.isBlocked()
      throw new Error 'NOT IMPLEMENTED'
    else
      RoutingDispatcher.handleRouteAction
        actionType: RouterConstants.LOCATION_GOBACK

  block: ->
    RoutingDispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_BLOCK

  unblock: ->
    RoutingDispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_UNBLOCK

  updateLocation: (path) ->
    console.log "RouterActions.updateLocation(#{path})"
    if LocationStore.isBlocked()
      throw new Error 'NOT IMPLEMENTED'
    else
      _transition path, true

module.exports = RouterActions
