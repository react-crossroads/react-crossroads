Logger = require '../utils/logger'
merge = require 'react/lib/merge'

class ActiveHandler
  constructor: ([@endpoint, @chain...], @params) ->

  activeRouteHandler: (addedProps) =>
    throw new Error 'Cannot pass children to the active route handler' if arguments[1]?

    if @chain.length > 0
      childHandler = new ActiveHandler @chain, @params
      childFunc = childHandler.activeRouteHandler
    else
      childFunc = ->
        Logger.development.warn "Attempted to render active route child when one did not exist"
        null

    props = merge @endpoint.props.handlerProps, addedProps
    props.params = @params
    props.activeRouteHandler = childFunc
    props.ref = 'activeRouteHandler'

    if @endpoint.props.handler?
      @endpoint.props.handler(props)
    else # This case should only occur when the <Routes /> container does not have a handler
      props.activeRouteHandler(addedProps)

module.exports = ActiveHandler
