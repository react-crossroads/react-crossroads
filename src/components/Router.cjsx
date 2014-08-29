React = require 'react'
NamedLocations = require '../locations/NamedLocations'
LocationStore = require '../stores/LocationStore'
RouteStore = require '../stores/RouteStore'
Routes = require './Routes'
Route = require './Route'
DefaultRoute = require './DefaultRoute'
NotFoundRoute = require './NotFoundRoute'
_ = require 'lodash'

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
      children = [children] unless _.isArray children

      children.forEach (child) ->
        path = Router.buildPath child, routePrefix
        chain = [parents..., child]

        switch child.type
          when Routes.type
            hadDefault = Router.registerChildren child.children, chain, path

            unless hadDefault
              RouteStore.register path, chain

          when DefaultRoute.type
            throw new Error 'Cannot register more than one default root per <Routes /> container' if defaultRegistered
            defaultRegistered = true
            RouteStore.register path, chain

          when Route.type
            RouteStore.register path, chain

          when NotFoundRoute.type
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
    return null unless @state.currentChain?
    <this.state.currentChain.render />


module.exports = Router
