React = require 'react/addons'
RouteStore = require '../stores/RouteStore'
RouterActions = require '../actions/RouterActions'
ActiveState = require '../mixins/ActiveState'
cx = React.addons.classSet

isLeftClick = (event) -> event.button == 0
isModifiedEvent = (event) -> !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey)

Link = React.createClass
  displayName: 'Link'

  mixins: [ ActiveState ]

  propTypes:
    to: React.PropTypes.string.isRequired
    params: React.PropTypes.object
    activeClassName: React.PropTypes.string

  getDefaultProps: ->
    activeClassName: 'active'

  getInitialState: ->
    isActive: false

  updateActiveState: ->
    @setState
      isActive: Link.isActive @props.to, @props.params

  handleClick: (event) ->
    if isModifiedEvent(event) or !isLeftClick(event)
      return

    event.preventDefault()
    RouterActions.transition RouteStore.pathTo(@props.to, @props.params)

  render: ->
    classes = {}
    classes[@props.activeClassName] = @state.isActive

    <a className={cx classes} href={RouteStore.hrefTo @props.to, @props.params} onClick={@handleClick}>
      {@props.children}
    </a>

module.exports = Link
