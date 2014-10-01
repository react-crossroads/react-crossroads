RouterConstants = require '../../src/constants/RouterConstants'
RouterActions = require '../../src/actions/RouterActions'

describe 'Router Actions', ->
  actions = null
  dispatcher = null
  stores = null

  beforeEach ->
    dispatcher =
      handleRouteAction: sinon.stub()
    stores =
      location:
        isBlocked: sinon.stub()
      route:
        hasRoute: sinon.stub()
        pathTo: sinon.stub()

    actions = new RouterActions dispatcher, stores

  transitionTest = ({to, params, expPath, mockRoute}) ->
    ->
      if mockRoute
        stores.route.hasRoute.returns true
        stores.route.pathTo.returns expPath

      actions.transition to, params
      dispatcher.handleRouteAction.should.have.been.calledOnce
      dispatcher.handleRouteAction.should.have.been.calledWith
        actionType: RouterConstants.LOCATION_CHANGE
        path: expPath
        fromLocationEvent: false

      if mockRoute
        stores.route.pathTo.should.have.been.calledOnce.and.calledWith to, params

  it 'Dispatches transition event (absolute path)',
    transitionTest(to: 'http://example.com/to/some/path', expPath: 'http://example.com/to/some/path')

  it 'Dispatches transition event (absolute path [https])',
    transitionTest(to: 'https://example.com/to/some/path', expPath: 'https://example.com/to/some/path')

  it 'Dispatches transition event (specific path)',
    transitionTest(to: '/to/some/path', expPath: '/to/some/path')

  it 'Dispatches transition event (path with interpolation)',
    transitionTest(to: '/to/{dynamic}/path', params: {dynamic: 'some'}, expPath: '/to/some/path')

  it 'Dispatches transition event (named route)',
    transitionTest(to: 'some-route', params: {dynamic: 'some'}, expPath: '/to/some/path', mockRoute: true)

  it 'Dispatches transition attempt event', ->
    path = '/to/some/path'
    stores.location.isBlocked.returns true
    actions.transition path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction:
        actionType: RouterConstants.LOCATION_CHANGE
        path: path
        fromLocationEvent: false

  replaceTest = ({to, params, expPath, mockRoute}) ->
    ->
      if mockRoute
        stores.route.hasRoute.returns true
        stores.route.pathTo.returns expPath

      actions.replace to, params
      dispatcher.handleRouteAction.should.have.been.calledOnce
      dispatcher.handleRouteAction.should.have.been.calledWith
        actionType: RouterConstants.LOCATION_REPLACE
        path: expPath

      if mockRoute
        stores.route.pathTo.should.have.been.calledOnce.and.calledWith to, params

  it 'Dispatches replace event (absolute path)',
    replaceTest(to: 'http://example.com/to/some/path', expPath: 'http://example.com/to/some/path')

  it 'Dispatches replace event (absolute path [https])',
    replaceTest(to: 'https://example.com/to/some/path', expPath: 'https://example.com/to/some/path')

  it 'Dispatches replace event (specific path)',
    replaceTest(to: '/to/some/path', expPath: '/to/some/path')

  it 'Dispatches replace event (path with interpolation)',
    replaceTest(to: '/to/{dynamic}/path', params: {dynamic: 'some'}, expPath: '/to/some/path')

  it 'Dispatches replace event (named route)',
    replaceTest(to: 'some-route', params: {dynamic: 'some'}, expPath: '/to/some/path', mockRoute: true)

  it 'Dispatches replace attempt event', ->
    path = '/to/some/path'
    stores.location.isBlocked.returns true
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
    stores.location.isBlocked.returns true
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
    stores.location.isBlocked.returns true
    actions.updateLocation path
    dispatcher.handleRouteAction.should.have.been.calledOnce
    dispatcher.handleRouteAction.should.have.been.calledWith
      actionType: RouterConstants.LOCATION_ATTEMPT
      originalAction:
        actionType: RouterConstants.LOCATION_CHANGE
        path: path
        fromLocationEvent: true
