React = require 'react'
RouteDefinition = require './RouteDefinition'
merge = require 'react/lib/merge'

TYPE = 'Route'

_atLeastOneUnlessDefault = (props, propName) ->
  return new Error 'Must provide either a name, a path or both' unless props.name? or props.path?
  React.PropTypes.string.apply(null, arguments)

class Route extends RouteDefinition
  type: TYPE

  constructor: (props) ->
    defaultProps =
      handlerProps: {}

    @props = merge defaultProps, props
    super()

  propTypes:
    handler: RouteDefinition.PropTypes.componentClass.isRequired
    path: _atLeastOneUnlessDefault
    name: _atLeastOneUnlessDefault
    handlerProps: React.PropTypes.object.isRequired

factory = (props) ->
  throw new Error 'Route does not support children, use <Routes /> instead' if arguments.length > 1
  new Route props

factory.type = TYPE

module.exports = factory
