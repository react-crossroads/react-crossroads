invariant = require 'react/lib/invariant'
RoutingDispatcher = require '../dispatcher/RoutingDispatcher'
RouterConstants = require '../constants/RouterConstants'
LocationStore = require './LocationStore'
{EventEmitter} = require 'events'
Crossroads = require 'crossroads'
merge = require 'react/lib/merge'

# TODO: Minimize this dependency
_ = require 'lodash'

class RouteChain
  constructor: (@path, @chain, @route) ->

  makePath: (params) ->
    @route.interpolate params

class ActiveChain
  constructor: (@routeChain, @params) ->

  render: ->
    handler = new ActiveHandler @routeChain.chain, @params
    handler.activeRouteHandler()

class ActiveHandler
  constructor: ([@handler, @chain...], @params) ->

  activeRouteHandler: (addedProps) =>
    throw new Error 'Cannot pass children to the active route handler' if arguments[1]?

    if @chain.length > 0
      childHandler = new ActiveHandler @chain, @params
      childFunc = childHandler.activeRouteHandler
    else
      childFunc = ->
        console.warn "Attempted to render active route child when one did not exist"
        null

    props = merge @handler.props.handlerProps, addedProps
    props.params = @params
    props.activeRouteHandler = childFunc
    @handler.props.handler(props)

class RouteStore extends EventEmitter
  constructor: ->
    @dispatchToken = RoutingDispatcher.register(@handler)
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

  pathTo: (to, params) =>
    chain = @_routes[to]
    throw new Error "No route defined for `#{to}`" unless chain?
    chain.makePath params

  hrefTo: (to, params) =>
    path = @pathTo to, params
    LocationStore.pathToHref path

  start: =>
    LocationStore.addChangeListener @_locationChanged
    @_locationChanged()

  _locationChanged: =>
    console.log "Location store update: #{LocationStore.getCurrentPath()}"
    @router.parse LocationStore.getCurrentPath()

  _route: (request, data) =>
    params = _.zipObject data.route._paramsIds, data.params
    chain = @_routes[data.route.__name__]
    @_currentChain = new ActiveChain chain, params
    @_emitChange()

  _routeNotFound: (request) ->
    console.error "404 - Not Found #{request}"

  register: (path, chain) =>
    endHandler = chain[chain.length-1]
    name = endHandler.props.name || endHandler.props.path
    throw new Error "Route with duplicate name `#{name}`" if @_routes[name]?
    route = @router.addRoute path
    route.__name__ = name

    @_routes[name] = new RouteChain path, chain, route

  _emitChange: => @emit RouterConstants.CHANGE_EVENT

  addChangeListener: (listener) =>
    @on RouterConstants.CHANGE_EVENT, listener

  removeChangeListener: (listener) =>
    @removeListener RouterConstants.CHANGE_EVENT, listener

module.exports = new RouteStore
