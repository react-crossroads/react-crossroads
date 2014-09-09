React = require 'react'

getNextBlockId = do ->
  nextBlockId = 1
  -> nextBlockId++

BlockRouting =
  contextTypes:
    router: React.PropTypes.object.isRequired

  getInitialState: ->
    BlockRouting:
      blockId: null
      blocked: false

  componentWillMount: ->
    @context.router.stores.location.addChangeListener @handleLocationStateChange

  componentWillUnmount: ->
    @context.router.stores.location.removeChangeListener @handleLocationStateChange

  handleLocationStateChange: ->
    @setState
      BlockRouting:
        # TODO: Why do I need to set this?
        blockId: @state.BlockRouting.blockId
        blocked: @context.router.stores.location.isBlocked()

  toggleBlock: ->
    if @state.BlockRouting.blocked
      @context.router.actions.unblock @state.BlockRouting.blockId
      @setState
        BlockRouting:
          blockId: null
    else
      @setState
        BlockRouting:
          blockId: getNextBlockId()
      @context.router.actions.block @state.BlockRouting.blockId

module.exports = BlockRouting
