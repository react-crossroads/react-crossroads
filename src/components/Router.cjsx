React = require 'react'
NamedLocations = require '../locations/NamedLocations'
LocationStore = require '../stores/LocationStore'
RouteStore = require '../stores/RouteStore'
Routes = require './Routes'
Route = require './Route'
DefaultRoute = require './DefaultRoute'

Router = React.createClass
  displayName: 'Router'

  statics:
    buildPath: (child, prefix) ->
      path = child.props.path
      name = child.props.name unless child instanceof DefaultRoute
      join = (prefix, suffix) ->
        if prefix[prefix.length-1] == '/'
          "#{prefix}#{suffix}"
        else
          "#{prefix}/#{suffix}"

      if path?
        if path[0] == '/'
          path
        else
          join prefix, path
      else if name?
        join prefix, name
      else
        prefix

    registerChildren: (children, parents, routePrefix) ->
      defaultRegistered = false

      React.Children.forEach children, (child) ->
        path = Router.buildPath child, routePrefix
        chain = [parents..., child]

        switch
          when child instanceof Routes
            hadDefault = Router.registerChildren child.props.children, chain, path

            unless hadDefault
              RouteStore.register path, chain

          when child instanceof DefaultRoute
            throw new Error 'Cannot register more than one default root per <Routes /> container' if defaultRegistered
            defaultRegistered = true
            RouteStore.register path, chain

          when child instanceof Route
            RouteStore.register path, chain

      defaultRegistered

  getDefaultProps: ->
    location: 'hash'
    initialPath: ''

  getInitialState: ->
    Router.registerChildren @props.children, [], ''
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
    <div>
      Router
      <this.state.currentChain.render />
    </div>


module.exports = Router
