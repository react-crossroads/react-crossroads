React = require 'react'
RouteStore = require '../stores/RouteStore'
RouterActions = require '../actions/RouterActions'

isLeftClick = (event) -> event.button == 0
isModifiedEvent = (event) -> !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey)

RouteTo =
  propTypes:
    to: React.PropTypes.string.isRequired
    params: React.PropTypes.object

  # Returns the value of the "href" attribute to use on the DOM element.
  getHref: ->
    try
      RouteStore.hrefTo @props.to, @props.params
    catch err
      throw new Error "Failed to acquire href to `#{@props.to} with parameters #{JSON.stringify @props.params} [#{err.message}]"

  handleRouteTo: (event) ->
    if isModifiedEvent(event) or !isLeftClick(event)
      return

    event.preventDefault()
    RouterActions.transition RouteStore.pathTo(@props.to, @props.params)

module.exports = RouteTo
