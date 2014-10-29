React = require 'react'
NamedLocations = require '../locations/NamedLocations'
Routes = require './Routes'
RouterContext = require '../context/RouterContext'
Logger = require '../utils/logger'
{Dispatcher} = require 'flux'

Router = React.createClass
  displayName: 'Router'

  getDefaultProps: ->
    location: 'hash'
    rootPath: ''

  childContextTypes:
    router: React.PropTypes.object.isRequired

  contextTypes:
    dispatcher: React.PropTypes.object

  getChildContext: ->
    router: @state.routerContext

  getInitialState: ->
    dispatcher = @props.dispatcher || @context.dispatcher || new Dispatcher()
    routerContext = new RouterContext dispatcher
    <Routes path='/'>{@props.children}</Routes>.register [], '', routerContext.stores.route

    routesRegistered: true
    routerContext: routerContext

  propTypes:
    location: React.PropTypes.string.isRequired
    rootPath: React.PropTypes.string.isRequired

  componentWillMount: ->
    location = NamedLocations.locationFor @props.location
    @state.routerContext.stores.location.setup location, @props.rootPath, @props.initialPath

    @state.routerContext.stores.route.addChangeListener @routeChanged
    @state.routerContext.stores.route.start()

  routeChanged: ->
    @setState
      currentChain: @state.routerContext.stores.route.getCurrentChain()

  render: ->
    Logger.debug.log 'Rendering active chain'
    return null unless @state.currentChain?
    <@state.currentChain.render />

module.exports = Router
