React = require 'react'
NamedLocations = require '../locations/NamedLocations'
LocationStore = require '../stores/LocationStore'
RouteStore = require '../stores/RouteStore'
Routes = require './Routes'
NotFoundRoute = require './NotFoundRoute'

Router = React.createClass
  displayName: 'Router'

  getDefaultProps: ->
    location: 'hash'
    initialPath: ''

  getInitialState: ->
    <Routes>{@props.children}</Routes>.register [], '', RouteStore
    routesRegistered: true

  propTypes:
    location: React.PropTypes.string
    initialPath: React.PropTypes.string

  componentWillMount: ->
    location = NamedLocations.locationFor @props.location
    LocationStore.setup location, @props.initialPath
    RouteStore.addChangeListener @routeChanged
    RouteStore.start()

  routeChanged: ->
    @setState
      currentChain: RouteStore.getCurrentChain()

  render: ->
    return null unless @state.currentChain?
    <this.state.currentChain.render />

module.exports = Router
