RouteStore = require '../stores/RouteStore'

ActiveState =
  statics:
    isActive: RouteStore.isActive

  componentWillMount: ->
    RouteStore.addChangeListener @handleActiveStateChange

  componentDidMount: ->
    @updateActiveState() if @updateActiveState?

  componentWillUnmount: ->
    RouteStore.removeChangeListener @handleActiveStateChange

  handleActiveStateChange: ->
    if @isMounted() and @updateActiveState?
      @updateActiveState()

module.exports = ActiveState
