React = require 'react'
RouteDefinition = require './RouteDefinition'
merge = require 'react/lib/merge'

TYPE = 'DefaultRoute'

class DefaultRoute extends RouteDefinition
  type: TYPE

  constructor: (props) ->
    defaultProps =
      handlerProps: {}
      path: ''

    @props = merge defaultProps, props
    super()

  propTypes:
    handler: RouteDefinition.PropTypes.componentClass.isRequired
    name: React.PropTypes.string
    path: React.PropTypes.string
    handlerProps: React.PropTypes.object.isRequired

factory = (props) ->
  throw new Error 'DefaultRoute does not support children, use <Routes /> instead' if arguments.length > 1
  new DefaultRoute props

factory.type = TYPE

module.exports = factory
