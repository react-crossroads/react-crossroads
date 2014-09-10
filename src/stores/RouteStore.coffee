RouterConstants = require '../constants/RouterConstants'
{EventEmitter} = require 'events'
Crossroads = require 'crossroads'
Logger = require '../utils/logger'

# TODO: Minimize this dependency
_ = require 'lodash'

class RouteStore extends EventEmitter
  constructor: (dispatcher, @locationStore) ->
    @setMaxListeners(0) # Don't limit number of listeners
    @dispatchToken = dispatcher.register(@handler)
    @router = Crossroads.create()
    @router.routed.add @_route
    @router.bypassed.add @_routeNotFound
    @router.ignoreState = true
    @router.shouldTypecast = true
    @_routes = {}
    @_currentChain = null

  handler: (payload) =>
    null

  getCurrentChain: => @_currentChain

  isActive: (to, params) ->
    return false unless @_currentChain?
    path = @pathTo to, params
    path == @_currentChain.path

  getRoute: (name) -> @_routes[name].route

  pathTo: (to, params) ->
    endpoint = @getRoute(to).endpoint
    throw new Error "No route defined for `#{to}`" unless endpoint?
    endpoint.makePath params

  hrefTo: (to, params) ->
    path = @pathTo to, params
    @locationStore.pathToHref path

  start: ->
    @locationStore.addChangeListener @_locationChanged
    @_locationChanged()

  _locationChanged: =>
    Logger.debug.log "Location store update: #{@locationStore.getCurrentPath()}"
    @router.parse @locationStore.getCurrentPath()

  _route: (request, data) =>
    endpoint = data.route.endpoint
    params = _.zipObject data.route._paramsIds, data.params
    @_currentChain = endpoint.createActiveChain params
    @_emitChange()

  _routeNotFound: (request) ->
    console.error "404 - Not Found #{request}"

  register: (endpoint) ->
    throw new Error "Route with duplicate name `#{endpoint.name}`" if @_routes[endpoint.name]?
    route = @router.addRoute endpoint.path
    route.endpoint = endpoint
    endpoint.route = route

    @_routes[endpoint.name] = endpoint
    return

  _emitChange: -> @emit RouterConstants.CHANGE_EVENT

  addChangeListener: (listener) ->
    @on RouterConstants.CHANGE_EVENT, listener

  removeChangeListener: (listener) ->
    @removeListener RouterConstants.CHANGE_EVENT, listener

module.exports = RouteStore
