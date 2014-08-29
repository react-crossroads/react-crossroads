React = require 'react'
RouteDefinition = require './RouteDefinition'
merge = require 'react/lib/merge'
_ = require 'lodash'

TYPE = 'Routes'

_childrenValid = (->
  VALID_TYPES = [
    'Route'
    'Routes'
    'DefaultRoute'
    'NotFoundRoute'
  ]

  validate = (props, propName, componentName) ->
    validChild = (child) ->
      unless child.type in VALID_TYPES
        return new Error "All children must be the proper type [Proper types: #{JSON.stringify VALID_TYPES}]"

    if _.isArray props[propName]
      return new Error 'Must provide at least one child' if props[propName].length == 0
      for child in props[propName]
        unless child?
          return new Error 'All child elements must be defined'

        err = validChild child
        return err if err?
    else
      err = validChild props[propName]
      return err if err?

  RouteDefinition.PropTypes.createChainableTypeChecker validate
)()


class Routes extends RouteDefinition
  type: TYPE

  constructor: (props, @children) ->
    defaultProps =
      handlerProps: {}
      # TODO: Primarily hear to participate in validation.... Do something better!
      children: @children

    @props = merge defaultProps, props
    super()

  propTypes:
    handler: RouteDefinition.PropTypes.componentClass
    path: React.PropTypes.string
    name: React.PropTypes.string
    handlerProps: React.PropTypes.object
    children: _childrenValid.isRequired

factory = (props, children...) -> new Routes props, children
factory.type = 'Routes'

module.exports = factory
