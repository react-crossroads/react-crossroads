RouterConstants = require '../../src/constants/RouterConstants'
RoutingDispatcher = require '../../src/dispatcher/RoutingDispatcher'

describe 'the routing dispatcher', ->
  dispatcher = null
  routingDispatcher = null

  beforeEach ->
    dispatcher =
      dispatch: sinon.spy()

    routingDispatcher = new RoutingDispatcher dispatcher

    #dispatchedEvents = []
    #_currentDispatcher = RoutingDispatcher.getDispatcher()
    #RoutingDispatcher.initialize
      #dispatch: (action) ->
        #dispatchedEvents.push action

  it 'dispatches one action per handleRouteAction call', ->
    routingDispatcher.handleRouteAction()
    dispatcher.dispatch.should.have.been.calledOnce

  it 'wraps the payload and applies a source property', ->
    action =
      actionType: 'test action'
      payload: 5

    routingDispatcher.handleRouteAction action

    dispatcher.dispatch.should.have.been.calledOnce
    dispatcher.dispatch.should.have.been.calledWith
      source: RouterConstants.ROUTER_ACTION
      action: action
