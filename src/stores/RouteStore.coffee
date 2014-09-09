RouterConstants = require '../constants/RouterConstants'
{EventEmitter} = require 'events'
Crossroads = require 'crossroads'
Logger = require '../utils/logger'

# TODO: Minimize this dependency
_ = require 'lodash'

class RouteChain
  constructor: (@path, @chain, @route) ->

  makePath: (params) ->
    @route.interpolate params

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

  isActive: (to, params) =>
    return false unless @_currentChain?
    path = @pathTo to, params
    path == @_currentChain.path

  pathTo: (to, params) =>
    chain = @_routes[to]
    throw new Error "No route defined for `#{to}`" unless chain?
    chain.makePath params

  hrefTo: (to, params) =>
    path = @pathTo to, params
    @locationStore.pathToHref path

  start: =>
    @locationStore.addChangeListener @_locationChanged
    @_locationChanged()

  _locationChanged: =>
    Logger.debug.log "Location store update: #{@locationStore.getCurrentPath()}"
    @router.parse @locationStore.getCurrentPath()

  _route: (request, data) =>
    endpoint = data.route.endpoint
    params = _.zipObject data.route._paramsIds, data.params
    chain = @_routes[endpoint.name]
    @_currentChain = endpoint.createActiveChain request, chain, params
    @_emitChange()

  _routeNotFound: (request) ->
    console.error "404 - Not Found #{request}"

  register: (path, chain) =>
    [..., endpoint] = chain
    throw new Error "Route with duplicate name `#{endpoint.name}`" if @_routes[endpoint.name]?
    route = @router.addRoute path
    route.endpoint  = endpoint

    @_routes[endpoint.name] = new RouteChain path, chain, route

  _emitChange: => @emit RouterConstants.CHANGE_EVENT

  addChangeListener: (listener) =>
    @on RouterConstants.CHANGE_EVENT, listener

  removeChangeListener: (listener) =>
    @removeListener RouterConstants.CHANGE_EVENT, listener

module.exports = RouteStore
