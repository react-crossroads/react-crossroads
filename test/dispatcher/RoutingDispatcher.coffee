RouterConstants = require '../../src/constants/RouterConstants'
RoutingDispatcher = require '../../src/dispatcher/RoutingDispatcher'

describe 'the routing dispatcher', ->
  dispatchedEvents = null
  _currentDispatcher = null

  beforeEach ->
    dispatchedEvents = []
    _currentDispatcher = RoutingDispatcher.getDispatcher()
    RoutingDispatcher.initialize
      dispatch: (action) ->
        dispatchedEvents.push action

  afterEach ->
    RoutingDispatcher.initialize _currentDispatcher

  it 'dispatches one action per handleRouteAction call', ->
    RoutingDispatcher.handleRouteAction()
    dispatchedEvents.length.should.equal 1

  it 'wraps the payload and applies a source property', ->
    payload =
      blah: true
    RoutingDispatcher.handleRouteAction payload
    dispatchedEvents[0].source.should.equal RouterConstants.ROUTER_ACTION
    dispatchedEvents[0].action.should.equal payload
