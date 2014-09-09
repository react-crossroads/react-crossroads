React = require 'react'
Logger = require '../utils/logger'
ActiveChain = require './ActiveChain'
RouteChain = require './RouteChain'
join = require('path').join

ANONYMOUS = '<<anonymous>>'

# Create chain-able isRequired validator
#
# Largely copied directly from:
# https://github.com/facebook/react/blob/0.11-stable/src/core/ReactPropTypes.js#L94
createChainableTypeChecker = (validate) ->
  checkType = (isRequired, props, propName, componentName) ->
    componentName = componentName || ANONYMOUS

    if !props[propName]?
      if isRequired
        new Error "Required prop `#{propName}` was not specified in `#{componentName}`."
    else
      return validate props, propName, componentName

  chainedCheckType = checkType.bind null, false
  chainedCheckType.isRequired = checkType.bind null, true

  chainedCheckType

componentClass = do ->
  validate = (props, propName, componentName) ->
    if !React.isValidClass props[propName]
      new Error "Invalid prop `#{propName}` supplied to #{componentName}, expected a valid React class."

  createChainableTypeChecker validate

buildPath = (route, prefix) ->
  path = route.props.path
  name = route.props.name

  if path?
    if path[0] == '/'
      path
    else
      join prefix, path
  else if name?
    join prefix, name
  else
    prefix

class RouteDefinition
  constructor: ->
    @validate()
    @name = @props.name || @props.path

  validate: ->
    return unless @propTypes?

    for propName of @propTypes
      try
        error = @propTypes[propName](@props, propName, @type)
      catch err
        error = err

      Logger.development.error error if error?
      null

  registrationParts: (parents, routePrefix) ->
    path: buildPath(@, routePrefix)
    chain: [parents..., @]

  # Default registration logic
  register: (parents, routePrefix, routeStore) ->
    {path, chain} = @registrationParts(parents, routePrefix)
    routeStore.register path, chain

  createActiveChain: (request, chain, params) ->
    new ActiveChain request, chain, params

  createRouteChain: (path, chain, route) ->
    new RouteChain path, chain, route

RouteDefinition.PropTypes =
  componentClass: componentClass
  createChainableTypeChecker: createChainableTypeChecker

module.exports = RouteDefinition
