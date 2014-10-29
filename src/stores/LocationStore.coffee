RouterConstants = require '../constants/RouterConstants'
Logger = require '../utils/logger'
{EventEmitter} = require 'events'
_ = require 'lodash'

BLOCKED=true
UNBLOCKED=false

_isExpectedEvent = (action, path) ->
  if action.actionType == RouterConstants.LOCATION_GOBACK
    # TODO: Figure out something better here, potential for incredibly RARE race condition
    true
  else
    path == action.path

class LocationStore extends EventEmitter

  constructor: (dispatcher, @context) ->
    @dispatchToken = dispatcher.register(@handler)
    @_become UNBLOCKED
    @_currentLocationChanged = @_locationChangedDefault
    @_queue = []
    @_changing = false
    @_blockedIds = {}

  isBlocked: -> _.any _.values(@_blockedIds)

  isIdBlocked: (id) -> @_blockedIds[id] || false

  getCurrentPath: -> @_location.getCurrentPath()

  pathToHref: (path) -> @_location.pathToHref path

  handler: (payload) =>
    return unless payload.source == RouterConstants.ROUTER_ACTION
    action = payload.action
    @_queue.push action
    @_processQueue() unless @_changing

  _blockedHandler: (action) ->
    switch action.actionType
      when RouterConstants.LOCATION_BLOCK
        Logger.development.warn 'Location store is already blocked'
      when RouterConstants.LOCATION_UNBLOCK
        delete @_blockedIds[action.blockId] if @_blockedIds[action.blockId]?
        @_become UNBLOCKED unless @isBlocked()
        @_emitChange()
      when RouterConstants.LOCATION_CHANGE, RouterConstants.LOCATION_REPLACE, RouterConstants.LOCATION_GOBACK
        Logger.development.warn "Location store is blocked: #{JSON.stringify action}"
    true

  _unblockedHandler: (action) ->
    switch action.actionType
      when RouterConstants.LOCATION_BLOCK
        if @_blockedIds[action.blockId]
          console.error "Router has already been blocked for id `#{action.blockId}`"

        @_blockedIds[action.blockId] = true
        @_become BLOCKED
        @_emitChange()
        true
      when RouterConstants.LOCATION_UNBLOCK
        Logger.development.warn 'Location store is already unblocked'
        true
      when RouterConstants.LOCATION_CHANGE
        if action.fromLocationEvent
          @_emitChange()
          true
        else
          @_changeLocation => @_location.push action.path
          false
      when RouterConstants.LOCATION_REPLACE
        @_changeLocation => @_location.replace action.path
        false
      when RouterConstants.LOCATION_GOBACK
        @_changeLocation => @_location.pop()
        false
      when RouterConstants.LOCATION_ATTEMPT
        throw new Error 'Location store is not blocked!'

  _processQueue: ->
    [action, queueTail...] = @_queue
    if action and @_currentHandler(action)
      @_queue = queueTail
      @_processQueue()

  _changeLocation: (func) ->
    @_changing = true
    @_currentLocationChanged = @_locationChangedExpected
    func()

  _become: (blocked) ->
    @_currentHandler = if blocked then @_blockedHandler else @_unblockedHandler

  _emitChange: -> @emit RouterConstants.CHANGE_EVENT

  ###################### Listening to Location ######################

  _locationChanged: =>
    @_currentLocationChanged @_location.getCurrentPath()

  _locationChangedExpected: (path) ->
    if !_isExpectedEvent(@_queue[0], path)
      @_locationChangedDefault(path)
    else
      Logger.debug.log "Location changed by react-crossroads [path: #{path}]"
      @_changing = false
      @_emitChange()
      @_queue.shift()
      @_currentLocationChanged = @_locationChangedDefault
      @_processQueue()

  _locationChangedDefault: (path) ->
    # TODO: if blocked goback, but still send transition attempt event
    Logger.debug.log "Location changed by user [path: #{path}]"
    @context.actions.updateLocation path

  setup: (location, rootPath, initialPath) ->
    Location.development.warn 'Location has already been setup' if @_location?
    @_location = location
    @_location.setup @_locationChanged, rootPath, initialPath

  ###################### End Listening to Location ######################

  addChangeListener: (listener) ->
    @on RouterConstants.CHANGE_EVENT, listener

  removeChangeListener: (listener) ->
    @removeListener RouterConstants.CHANGE_EVENT, listener

module.exports = LocationStore
