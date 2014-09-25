BlockRouting = require '../../src/mixins/BlockRouting'
merge = require 'react/lib/merge'
_ = require 'lodash'

buildTestComponent = (routerContext) ->
  component =
    context:
      router: routerContext
    state: BlockRouting.getInitialState()
    setState: (newState) ->
      @state = merge @state, newState
    isMounted: -> true

  sinon.spy component, 'setState'

  component = _.extend component, BlockRouting

  originalToggle = component.toggleBlock

  component.toggleBlock = ->
    originalToggle.bind(component)()
    component.handleLocationStateChange.bind(component)()

  component

describe 'Block Routing mixin', ->
  component1 = null
  component2 = null
  blockedIds = null
  routerContext = null

  beforeEach ->
    blockedIds = {}

    routerContext =
      stores:
        location:
          addChangeListener: sinon.stub()
          removeChangeListener: sinon.stub()
          isBlocked: -> _.any _.values(blockedIds)
      actions:
        block: (id) -> blockedIds[id] = true
        unblock: (id) -> blockedIds[id] = false

    sinon.spy routerContext.actions, 'block'
    sinon.spy routerContext.actions, 'unblock'

    component1 = buildTestComponent routerContext
    component2 = buildTestComponent routerContext

  it 'not blocked by default', ->
    should.not.exist component1.state.BlockRouting.blockId
    component1.state.BlockRouting.blocked.should.be.false

  it 'registers change listener on the location store', ->
    component1.componentWillMount()
    routerContext.stores.location.addChangeListener.should.have.been.calledWith component1.handleLocationStateChange
    routerContext.stores.location.removeChangeListener.should.not.have.been.called

  it 'unregisters change listener on the location store', ->
    component1.componentWillUnmount()
    routerContext.stores.location.addChangeListener.should.not.have.been.called
    routerContext.stores.location.removeChangeListener.should.have.been.calledWith component1.handleLocationStateChange

  it 'toggles blocked state', ->
    component1.toggleBlock()
    blockId = component1.state.BlockRouting.blockId
    blockId.should.be.greaterThan 0
    component1.state.BlockRouting.blocked.should.be.true
    routerContext.actions.block.should.have.been.calledWith blockId

    component1.toggleBlock()
    should.not.exist component1.state.BlockRouting.blockId
    component1.state.BlockRouting.blocked.should.be.false
    routerContext.actions.unblock.should.have.been.calledWith blockId

  it 'increments block id with each toggle', ->
    component1.toggleBlock()
    firstId = component1.state.BlockRouting.blockId
    component1.toggleBlock()
    component1.toggleBlock()
    component1.state.BlockRouting.blockId.should.equal firstId + 1

  it 'block toggles share in blockId increment', ->
    component1.toggleBlock()
    component1Id = component1.state.BlockRouting.blockId
    component2.toggleBlock()
    component2Id = component2.state.BlockRouting.blockId

    component1Id.should.equal component2Id - 1

  it 'does not set state if not mounted', ->
    component1.isMounted = -> false
    component1.toggleBlock()
    component1.setState.should.have.been.calledOnce # Is only called in toggleBlock not in handleLocationStateChange
