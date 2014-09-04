React = require 'react'
NamedLocations = require '../locations/NamedLocations'
Routes = require './Routes'
RouterContext = require '../context/RouterContext'
{Dispatcher} = require 'flux'

Router = React.createClass
  displayName: 'Router'

  getDefaultProps: ->
    location: 'hash'
    initialPath: ''

  childContextTypes:
    router: React.PropTypes.object.isRequired

  getChildContext: ->
    router: @state.routerContext

  getInitialState: ->
    # TODO: pull dispatcher from props first?
    routerContext = new RouterContext( new Dispatcher() )
    Routes(null, @props.children).register [], '', routerContext.stores.route

    routesRegistered: true
    routerContext: routerContext

  propTypes:
    location: React.PropTypes.string.isRequired
    initialPath: React.PropTypes.string.isRequired

  componentWillMount: ->
    location = NamedLocations.locationFor @props.location
    @state.routerContext.stores.location.setup location, @props.initialPath

    @state.routerContext.stores.route.addChangeListener @routeChanged
    @state.routerContext.stores.route.start()

  routeChanged: ->
    @setState
      currentChain: @state.routerContext.stores.route.getCurrentChain()

  render: ->
    return null unless @state.currentChain?
    <@state.currentChain.render />

module.exports = Router
