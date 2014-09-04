RouterConstants = require '../constants/RouterConstants'

class RouterActions
  constructor: (@dispatcher, @locationStore) ->

  _dispatch: (action) ->
    if @locationStore.isBlocked()
      action =
        actionType: RouterConstants.LOCATION_ATTEMPT
        originalAction: action

    @dispatcher.handleRouteAction action

  # TODO: Build path with to, params, query
  transition: (path) ->
    console.log "RouterActions.transition(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: false

  # TODO: Build path with to, params, query
  replace: (path) ->
    console.log "RouterActions.replace(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_REPLACE
      path: path

  back: ->
    console.log "RouterActions.back()"
    @_dispatch
      actionType: RouterConstants.LOCATION_GOBACK

  block: ->
    @dispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_BLOCK

  unblock: ->
    @dispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_UNBLOCK

  updateLocation: (path) ->
    console.log "RouterActions.updateLocation(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: true

module.exports = RouterActions
