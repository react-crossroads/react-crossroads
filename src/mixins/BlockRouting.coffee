LocationStore = require '../stores/LocationStore'
RouterActions = require '../actions/RouterActions'

_getNextBlockId = do ->
  _nextBlockId = 1
  -> _nextBlockId++

BlockRouting =
  getInitialState: ->
    BlockRouting:
      blockId: null
      blocked: false

  componentWillMount: ->
    LocationStore.addChangeListener @handleLocationStateChange

  componentWillUnmount: ->
    LocationStore.removeChangeListener @handleLocationStateChange

  handleLocationStateChange: ->
    console.warn 'TODO: Block Routing Mixin location state change listener'

  toggleBlock: ->
    if @state.BlockRouting.blocked
      RouterActions.unblock @state.BlockRouting.blockId
      @_setBlock null
    else
      @_setBlock _getNextBlockId()
      RouterActions.block @state.BlockRouting.blockId

  _setBlock: (value) ->
    @setState
      BlockRouting:
        blockId: value
        blocked: value?

module.exports = BlockRouting
