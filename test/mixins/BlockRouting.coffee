rewire = require 'rewire'
BlockRouting = rewire '../../src/mixins/BlockRouting'
_ = require 'lodash'

buildTestComponent = () ->
  component =
    state: null
    setState: (newState) ->
      @state = newState

  sinon.spy component, 'setState'

  component = _.extend component, BlockRouting
  component.setState BlockRouting.getInitialState()
  component

mockLocationStore = ->
  store =
    addChangeListener: sinon.stub()
    removeChangeListener: sinon.stub()

  reset = BlockRouting.__set__('LocationStore', store)
  [reset, store]

mockRouterActions = ->
  actions =
    block: sinon.stub()
    unblock: sinon.stub()

  reset = BlockRouting.__set__('RouterActions', actions)
  [reset, actions]

describe 'Block Routing mixin', ->
  component1 = null
  component2 = null
  locationStoreReset = null
  routerActionsReset = null
  locationStore = null
  routerActions = null

  beforeEach ->
    [locationStoreReset, locationStore] = mockLocationStore()
    [routerActionsReset, routerActions] = mockRouterActions()

    component1 = buildTestComponent()
    component2 = buildTestComponent()

  afterEach ->
    locationStoreReset?()
    routerActionsReset?()

  it 'not blocked by default', ->
    should.not.exist component1.state.BlockRouting.blockId
    component1.state.BlockRouting.blocked.should.be.false

  it 'registers change listener on the location store', ->
    component1.componentWillMount()
    locationStore.addChangeListener.should.have.been.calledWith component1.handleLocationStateChange
    locationStore.removeChangeListener.should.not.have.been.called

  it 'unregisters change listener on the location store', ->
    component1.componentWillUnmount()
    locationStore.addChangeListener.should.not.have.been.called
    locationStore.removeChangeListener.should.have.been.calledWith component1.handleLocationStateChange

  it 'toggles blocked state', ->
    component1.toggleBlock()
    blockId = component1.state.BlockRouting.blockId
    blockId.should.be.greaterThan 0
    component1.state.BlockRouting.blocked.should.be.true
    routerActions.block.should.have.been.calledWith blockId

    component1.toggleBlock()
    should.not.exist component1.state.BlockRouting.blockId
    component1.state.BlockRouting.blocked.should.be.false
    routerActions.unblock.should.have.been.calledWith blockId

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
