RouterConstants = require '../constants/RouterConstants'
{EventEmitter} = require 'events'

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

  isBlocked: => @_blocked

  getCurrentPath: => @_location.getCurrentPath()

  pathToHref: (path) => @_location.pathToHref path

  handler: (payload) =>
    return unless payload.source == RouterConstants.ROUTER_ACTION
    console.log "Enqueueing: #{JSON.stringify payload}"
    action = payload.action
    @_queue.push action
    @_processQueue() unless @_changing

  _blockedHandler: (action) =>
    console.log "Blocked Handler"
    switch action.actionType
      when RouterConstants.LOCATION_BLOCK
        console.warn 'Location store is already blocked'
      when RouterConstants.LOCATION_UNBLOCK
        @_become UNBLOCKED
        @_emitChange()
      when RouterConstants.LOCATION_CHANGE, RouterConstants.LOCATION_REPLACE, RouterConstants.LOCATION_GOBACK
        console.warn "Location store is blocked: #{JSON.stringify action}"
    true

  _unblockedHandler: (action) =>
    console.log "Unblocked Handler"
    switch action.actionType
      when RouterConstants.LOCATION_BLOCK
        @_become BLOCKED
        @_emitChange()
        true
      when RouterConstants.LOCATION_UNBLOCK
        console.warn 'Location store is already unblocked'
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

  _processQueue: =>
    [action, queueTail...] = @_queue
    console.log "Processing next queue item: #{JSON.stringify action} [Remaining: #{JSON.stringify queueTail}]"

    if action and @_currentHandler(action)
      @_queue = queueTail
      @_processQueue()

  _changeLocation: (func) =>
    @_changing = true
    @_currentLocationChanged = @_locationChangedExpected
    func()

  _become: (blocked) =>
    @_blocked = blocked
    @_currentHandler = if blocked then @_blockedHandler else @_unblockedHandler

  _emitChange: => @emit RouterConstants.CHANGE_EVENT

  _locationChanged: =>
    @_currentLocationChanged @_location.getCurrentPath()

  _locationChangedExpected: (path) =>
    console.log "Location change expected"
    if !_isExpectedEvent(@_queue[0], path)
      @_locationChangedDefault(path)
    else
      @_changing = false
      @_emitChange()
      @_queue.shift()
      @_currentLocationChanged = @_locationChangedDefault
      @_processQueue()

  _locationChangedDefault: (path) =>
    console.log "Location change unexpected"
    @context.actions.updateLocation path
  setup: (location, initialPath) =>
    console.warn 'Location has already been setup' if @_location?
    @_location = location
    @_location.setup @_locationChanged, initialPath

  addChangeListener: (listener) =>
    @on RouterConstants.CHANGE_EVENT, listener

  removeChangeListener: (listener) =>
    @removeListener RouterConstants.CHANGE_EVENT, listener

module.exports = LocationStore
