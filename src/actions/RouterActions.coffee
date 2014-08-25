RoutingDispatcher = require '../dispatcher/RoutingDispatcher'
LocationStore = require '../stores/LocationStore'
RouterConstants = require '../constants/RouterConstants'

_dispatch = (action) ->
  if LocationStore.isBlocked()
    action =
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction: action

  RoutingDispatcher.handleRouteAction action

RouterActions =
  # TODO: Build path with to, params, query
  transition: (path) ->
    console.log "RouterActions.transition(#{path})"
    _dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: false

  # TODO: Build path with to, params, query
  replace: (path) ->
    console.log "RouterActions.replace(#{path})"
    _dispatch
      actionType: RouterConstants.LOCATION_REPLACE
      path: path

  back: ->
    console.log "RouterActions.back()"
    _dispatch
      actionType: RouterConstants.LOCATION_GOBACK

  block: ->
    RoutingDispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_BLOCK

  unblock: ->
    RoutingDispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_UNBLOCK

  updateLocation: (path) ->
    console.log "RouterActions.updateLocation(#{path})"
    _dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: true

module.exports = RouterActions
