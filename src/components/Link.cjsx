React = require 'react'
RouteStore = require '../stores/RouteStore'
RouterActions = require '../actions/RouterActions'

isLeftClick = (event) -> event.button == 0
isModifiedEvent = (event) -> !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey)

Link = React.createClass
  displayName: 'Link'

  propTypes:
    to: React.PropTypes.string.isRequired
    params: React.PropTypes.object

  handleClick: (event) ->
    if isModifiedEvent(event) or !isLeftClick(event)
      return

    RouterActions.transition RouteStore.pathTo(@props.to, @props.params)

  render: ->
    <a href={RouteStore.hrefTo @props.to, @props.params} onClick={@handleClick}>
      {@props.children}
    </a>

module.exports = Link
