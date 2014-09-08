RouterConstants = require '../constants/RouterConstants'
Logger = require '../utils/logger'

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
    Logger.debug.log "RouterActions.transition(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: false

  # TODO: Build path with to, params, query
  replace: (path) ->
    Logger.debug.log "RouterActions.replace(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_REPLACE
      path: path

  back: ->
    Logger.debug.log "RouterActions.back()"
    @_dispatch
      actionType: RouterConstants.LOCATION_GOBACK

  block: (id) ->
    @dispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_BLOCK
      blockId: id

  unblock: (id) ->
    @dispatcher.handleRouteAction
      actionType: RouterConstants.LOCATION_UNBLOCK
      blockId: id

  updateLocation: (path) ->
    Logger.debug.log "RouterActions.updateLocation(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: true

module.exports = RouterActions
