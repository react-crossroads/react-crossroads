RouterConstants = require '../constants/RouterConstants'
Logger = require '../utils/logger'
pattern = require('crossroads').patternLexer

isAbsoluteUrl = (url) -> typeof url == 'string' and /^https?:\/\//.test url

class RouterActions
  constructor: (@dispatcher, @stores) ->

  _dispatch: (action) ->
    if @stores.location.isBlocked()
      action =
        actionType: RouterConstants.LOCATION_ATTEMPT
        originalAction: action

    @dispatcher.handleRouteAction action

  _resolvePath: (to, params) ->
    switch
      when isAbsoluteUrl to
        to
      when @stores.route.hasRoute to
        @stores.route.pathTo to, params
      else
        pattern.interpolate to, params

  transition: (to, params) ->
    path = @_resolvePath to, params

    Logger.debug.log "RouterActions.transition(#{path})"
    @_dispatch
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: false

  replace: (to, params) ->
    path = @_resolvePath to, params
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
