React = require 'react'
RouteStore = require '../stores/RouteStore'
RouterActions = require '../actions/RouterActions'

isLeftClick = (event) -> event.button == 0
isModifiedEvent = (event) -> !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey)

RouteToMixin =
  propTypes:
    to: React.PropTypes.string.isRequired
    params: React.PropTypes.object

  # Returns the value of the "href" attribute to use on the DOM element.
  getHref: ->
    RouteStore.hrefTo @props.to, @props.params

  handleRouteTo: (event) ->
    if isModifiedEvent(event) or !isLeftClick(event)
      return

    event.preventDefault()
    RouterActions.transition RouteStore.pathTo(@props.to, @props.params)

module.exports = RouteToMixin
