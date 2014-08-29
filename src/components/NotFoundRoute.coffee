React = require 'react'
RouteDefinition = require './RouteDefinition'
merge = require 'react/lib/merge'

TYPE = 'NotFoundRoute'

class NotFoundRoute extends RouteDefinition
  type: TYPE

  constructor: (props) ->
    defaultProps =
      path: ':path*:'
      handlerProps: {}

    @props = merge defaultProps, props
    super()

  propTypes:
    handler: RouteDefinition.PropTypes.componentClass.isRequired
    path: React.PropTypes.string

factory = (props) ->
  throw new Error 'NotFoundRoute does not support children' if arguments.length > 1
  new NotFoundRoute props

factory.type = TYPE

module.exports = factory
