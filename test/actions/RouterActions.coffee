RouterConstants = require '../../src/constants/RouterConstants'
RouterActions = require '../../src/actions/RouterActions'

describe 'Router Actions', ->
  actions = null
  dispatcher = null
  locationStore = null

  beforeEach ->
    dispatcher =
      handleRouteAction: sinon.stub()
    locationStore =
      isBlocked: sinon.stub()

    actions = new RouterActions dispatcher, locationStore

  it 'Dispatches transition event', ->
    path = '/to/some/path'
    actions.transition path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: false

  it 'Dispatches transition attempt event', ->
    path = '/to/some/path'
    locationStore.isBlocked.returns true
    actions.transition path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction:
        actionType: RouterConstants.LOCATION_CHANGE
        path: path
        fromLocationEvent: false

  it 'Dispatches replace event', ->
    path = '/to/some/path'
    actions.replace path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_REPLACE
      path: path

  it 'Dispatches replace attempt event', ->
    path = '/to/some/path'
    locationStore.isBlocked.returns true
    actions.replace path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction:
        actionType: RouterConstants.LOCATION_REPLACE
        path: path

  it 'Dispatches go back event', ->
    actions.back()
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_GOBACK

  it 'Dispatches go back attempt event', ->
    locationStore.isBlocked.returns true
    actions.back()
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction:
        actionType: RouterConstants.LOCATION_GOBACK

  it 'Dispatches block event', ->
    blockId = 5
    actions.block blockId
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_BLOCK
      blockId: blockId

  it 'Dispatches block event', ->
    blockId = 8
    actions.unblock blockId
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_UNBLOCK
      blockId: blockId

  it 'Dispatches updated location event', ->
    path = '/to/some/path'
    actions.updateLocation path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_CHANGE
      path: path
      fromLocationEvent: true

  it 'Dispatches updated location attempt event', ->
    path = '/to/some/path'
    locationStore.isBlocked.returns true
    actions.updateLocation path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction:
        actionType: RouterConstants.LOCATION_CHANGE
        path: path
        fromLocationEvent: true
