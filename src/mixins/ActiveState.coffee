React = require 'react'
RouteStore = require '../stores/RouteStore'

ActiveState =
  contextTypes:
    router: React.PropTypes.object.isRequired

  componentWillMount: ->
    @context.router.stores.route.addChangeListener @handleActiveStateChange

  componentDidMount: ->
    @updateActiveState() if @updateActiveState?

  componentWillUnmount: ->
    @context.router.stores.route.removeChangeListener @handleActiveStateChange

  isActive: (to, params) ->
    @context.router.stores.route.isActive(to, params)

  handleActiveStateChange: ->
    if @isMounted() and @updateActiveState?
      @updateActiveState()

module.exports = ActiveState
