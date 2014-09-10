React = require 'react'
Logger = require '../utils/logger'
ActiveEndpoint = require './ActiveEndpoint'
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

  buildPath: ({name, path}, prefix) ->
    if path?
      if path[0] == '/'
        path
      else
        join prefix, path
    else if name?
      join prefix, name
    else
      prefix

  # Default registration logic
  register: (parents, routePrefix, routeStore) ->
    @path = @buildPath @props, routePrefix
    @chain = [parents..., @]
    routeStore.register @ # This will set @route

  makePath: (params) -> @route.interpolate params

  createActiveChain: (path, params) ->
    new ActiveEndpoint path, @, params

RouteDefinition.PropTypes =
  componentClass: componentClass
  createChainableTypeChecker: createChainableTypeChecker

module.exports = RouteDefinition
