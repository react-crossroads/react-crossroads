React = require 'react/addons'
ActiveState = require '../mixins/ActiveState'
RouteTo = require '../mixins/RouteTo'
cx = React.addons.classSet

isLeftClick = (event) -> event.button == 0
isModifiedEvent = (event) -> !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey)

Link = React.createClass
  displayName: 'Link'

  mixins: [
    ActiveState
    RouteTo
  ]

  propTypes:
    activeClassName: React.PropTypes.string

  getDefaultProps: ->
    activeClassName: 'active'

  getInitialState: ->
    isActive: false

  updateActiveState: ->
    @setState
      isActive: @isActive @props.to, @props.params

  render: ->
    classes = {}
    classes[@props.activeClassName] = @state.isActive
    classes[@props.className] = true

    <a className={cx classes} href={@getHref()} onClick={@handleRouteTo}>
      {@props.children}
    </a>

module.exports = Link
