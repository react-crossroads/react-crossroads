React = require 'react'
RouteDefinition = require './RouteDefinition'
merge = require 'react/lib/merge'
_ = require 'lodash'

TYPE = 'Routes'

_childrenValid = do ->
  VALID_TYPES = [
    'Route'
    'Routes'
    'DefaultRoute'
    'NotFoundRoute'
  ]

  validate = (props, propName, componentName) ->
    validChild = (child) ->
      unless child.type in VALID_TYPES
        return new Error "All children must be a proper type [Proper types: #{JSON.stringify VALID_TYPES}]"

    if _.isArray props[propName]
      return new Error 'Must provide at least one child' if props[propName].length == 0
      defaultCount = 0

      for child in props[propName]
        unless child?
          return new Error 'All child elements must be defined'

        if child.type == 'DefaultRoute'
          defaultCount += 1

        err = validChild child
        return err if err?

      return new Error 'Only one <DefaultRoute /> is allowed per <Routes /> container' if defaultCount > 1
    else
      err = validChild props[propName]
      return err if err?

  RouteDefinition.PropTypes.createChainableTypeChecker validate

_hasDefault = (children) -> _.any children, (child) -> child.type is 'DefaultRoute'

class Routes extends RouteDefinition
  type: TYPE

  constructor: (props, @children) ->
    defaultProps =
      handlerProps: {}
      # TODO: Primarily here to participate in validation.... Do something better!
      children: @children

    @props = merge defaultProps, props
    @_hasDefault = _hasDefault(@children)
    @_hasPath = @props.path? || @props.name?

    super()

  propTypes:
    handler: RouteDefinition.PropTypes.componentClass
    path: React.PropTypes.string
    name: React.PropTypes.string
    handlerProps: React.PropTypes.object.isRequired
    children: _childrenValid.isRequired

  register: (parents, routePrefix, routeStore) ->
    {path, chain} = @registrationParts(parents, routePrefix)

    for child in @children
      child.register chain, path, routeStore

    shouldRegister = !@_hasDefault
    shouldRegister = shouldRegister and @_hasPath
    shouldRegister = shouldRegister and @props.handler?

    routeStore.register path, chain if shouldRegister

factory = (props, children...) -> new Routes props, _.flatten(children)
factory.type = 'Routes'

module.exports = factory
