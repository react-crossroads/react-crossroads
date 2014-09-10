React = require 'react'
RouteDefinition = require './RouteDefinition'
Logger = require '../utils/logger'
RedirectChain = require './RedirectChain'
pattern = require('crossroads').patternLexer
merge = require 'react/lib/merge'
_ = require 'lodash'

TYPE = 'Redirect'

_onlyOne = (restrictedPropNames) ->
  message = do ->
    [list..., last] = restrictedPropNames
    propNamesString = list.join ', '
    propNamesString += ", or #{last}" if last?
    "Must provide either #{propNamesString} but only one of them"

  (props, propName) ->
    assigned = restrictedPropNames
      .map (n) => if props[n]? then 1 else 0
      .reduce (x, y) -> x + y

    return new Error message unless assigned == 1

    React.PropTypes.string.apply(null, arguments)

class Redirect extends RouteDefinition
  type: TYPE

  # Forces Redirects to apply before all other routes
  priority: 1

  constructor: (props) ->
    @props = props
    super()
    @name = "Redirect-FROM[#{@props.from || @props.fromPath}]TO[#{@props.to || @props.path}]"

  propTypes:
    from: _onlyOne ['from', 'fromPath']
    fromPath: _onlyOne ['from', 'fromPath']
    to: _onlyOne ['to', 'path']
    path: _onlyOne ['to', 'path']

  register: (parents, routePrefix, @routeStore) ->
    @chain = [parents..., @]
    fromPath = @buildPath
      name: @props.from
      path: @props.fromPath
      , routePrefix

    @toPath = @buildPath
      name: @props.to
      path: @props.path
      , routePrefix

    if @props.from?
      fromRoute = @routeStore.getRoute @props.from

      unless fromRoute?
        Logger.development.error "Redirect from `#{@props.from}` could not be registered since there are no registered routes by that name."
        return

      fromPath = fromRoute.path

    @path = fromPath

    @routeStore.register @

  createActiveChain: (request, params) ->
    new RedirectChain @routeStore.routerActions, pattern.interpolate(@toPath, params), @routeStore.getCurrentChain()

factory = (props) ->
  throw new Error 'Redirect does not support children' if arguments.length > 1
  new Redirect props

factory.type = TYPE

module.exports = factory
