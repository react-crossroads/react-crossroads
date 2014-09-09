React = require 'react'

isLeftClick = (event) -> event.button == 0
isModifiedEvent = (event) -> !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey)

RouteTo =
  propTypes:
    to: React.PropTypes.string.isRequired
    params: React.PropTypes.object

  contextTypes:
    router: React.PropTypes.object.isRequired

  # Returns the value of the "href" attribute to use on the DOM element.
  getHref: ->
    try
      @context.router.stores.route.hrefTo @props.to, @props.params
    catch err
      consle.error new Error "Failed to acquire href to `#{@props.to}` with parameters #{JSON.stringify @props.params} [#{err.message}]"
      '#' # Safe fallback...

  handleRouteTo: (event) ->
    if isModifiedEvent(event) or !isLeftClick(event)
      return

    event.preventDefault()
    @context.router.actions.transition @context.router.stores.route.pathTo(@props.to, @props.params)

module.exports = RouteTo
