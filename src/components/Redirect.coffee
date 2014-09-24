React = require 'react'
RouteDefinition = require './RouteDefinition'
Logger = require '../utils/logger'
RedirectChain = require './RedirectChain'
pattern = require('crossroads').patternLexer
merge = require 'react/lib/merge'
join = require('path').join
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

  resolveRoutePath: (name, path, prefix) ->
    if path?
      if path[0] == '/'
        return path
      else
        return join prefix, path

    route = @routeStore.getRoute name

    unless route?
      Logger.development.error "Redirect to/from `#{name}` could not be registered since there are no registered routes by that name."
      return

    route.endpoint.path

  register: (parents, routePrefix, @routeStore) ->
    @chain = [parents..., @]

    @path   = @resolveRoutePath @props.from, @props.fromPath, routePrefix
    @toPath = @resolveRoutePath @props.to, @props.path, routePrefix

    @routeStore.register @

  createActiveChain: (request, params) ->
    new RedirectChain @routeStore.routerActions, pattern.interpolate(@toPath, params), @routeStore.getCurrentChain()

factory = (props) ->
  throw new Error 'Redirect does not support children' if arguments.length > 1
  new Redirect props

factory.type = TYPE

module.exports = factory
