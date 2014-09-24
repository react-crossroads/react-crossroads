RouterConstants = require '../constants/RouterConstants'
{EventEmitter} = require 'events'
Crossroads = require 'crossroads'
Logger = require '../utils/logger'

# TODO: Minimize this dependency
_ = require 'lodash'

class RouteStore extends EventEmitter
  constructor: (dispatcher, @locationStore, @routerActions) ->
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
    return false unless @_currentChain? and @_currentChain.isActive?
    @_currentChain.isActive to, params

  getRoute: (name) ->
    if name? then @_routes[name].route else undefined

  hasRoute: (name) ->
    if name? then @_routes[name]? else false

  pathTo: (to, params) ->
    throw new Error "No route defined for `#{to}`" unless @hasRoute to
    route = @getRoute to
    endpoint = @getRoute(to).endpoint
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
    Logger.debug.log "Route matched `#{request}` to #{endpoint.name}"
    params = _.zipObject data.route._paramsIds, data.params
    @_currentChain = endpoint.createActiveChain request, params
    @_emitChange()

  _routeNotFound: (request) ->
    console.error "404 - Not Found #{request}"

  register: (endpoint) ->
    throw new Error "Route with duplicate name `#{endpoint.name}`" if @hasRoute endpoint.name
    throw new Error "No path provided for `#{endpoint.name}`" unless endpoint.path?
    route = @router.addRoute endpoint.path, undefined, endpoint.priority || undefined
    route.endpoint = endpoint
    endpoint.route = route

    @_routes[endpoint.name] = endpoint
    return

  registerAlias: (aliasEndpoint, destinationEndpoint) ->
    throw new Error "Route with duplicate name `#{aliasEndpoint.name}`" if @hasRoute aliasEndpoint.name
    throw new Error "Endpoint `#{destinationEndpoint.name}` has not been registered, cannot create alias" unless destinationEndpoint.route?
    aliasEndpoint.route = destinationEndpoint.route
    @_routes[aliasEndpoint.name] = aliasEndpoint
    return

  _emitChange: -> @emit RouterConstants.CHANGE_EVENT

  addChangeListener: (listener) ->
    @on RouterConstants.CHANGE_EVENT, listener

  removeChangeListener: (listener) ->
    @removeListener RouterConstants.CHANGE_EVENT, listener

module.exports = RouteStore
