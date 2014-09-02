React = require 'react'
RouteDefinition = require './RouteDefinition'
merge = require 'react/lib/merge'
join = require('path').join

TYPE = 'NotFoundRoute'

class NotFoundRoute extends RouteDefinition
  type: TYPE

  constructor: (props) ->
    path = ':path*:'

    defaultProps =
      handlerProps: {}
      path: path

    propsPathIsString = props? and props.path? and typeof props.path == 'string'

    if propsPathIsString
      path = join(props.path, path)

    @props = merge defaultProps, props

    # If user provides a non-string prop.path let it fall through to validation and fail there.
    if propsPathIsString
      @props.path = path

    super()

  propTypes:
    handler: RouteDefinition.PropTypes.componentClass.isRequired
    path: React.PropTypes.string.isRequired

factory = (props) ->
  throw new Error 'NotFoundRoute does not support children' if arguments.length > 1
  new NotFoundRoute props

factory.type = TYPE

module.exports = factory
