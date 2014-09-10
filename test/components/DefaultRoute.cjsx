DefaultRoute = require '../../src/components/DefaultRoute'
Logger = require '../../src/utils/logger'
React = require 'react'

describe 'Default Route', ->
  Handler = React.createClass
    render: -> <div className='test-handler'></div>

  beforeEach ->
    sinon.stub Logger.development, 'error'

  afterEach ->
    Logger.development.error.restore() if Logger.development.error.restore

  it 'factory type is DefaultRoute', ->
    DefaultRoute.type.should.equal 'DefaultRoute'

  it 'Creates route definition with DefaultRoute type', ->
    route = DefaultRoute handler: Handler
    route.type.should.equal 'DefaultRoute'
    Logger.development.error.should.not.have.been.called

  it 'handler prop is required', ->
    route = DefaultRoute()
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'Required prop `handler` was not specified'

  it 'handler prop must be a component class', ->
    route = DefaultRoute handler: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handler`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected a valid React class'

  it 'handlerProps prop defaults to empty object', ->
    route = DefaultRoute handler: Handler
    route.props.handlerProps.should.be.empty

  it 'handlerProps prop must be an object', ->
    route = DefaultRoute handler: Handler, handlerProps: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handlerProps`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `object`'

  it 'name prop must be a string', ->
    route = DefaultRoute
      handler: Handler
      name: 'some-random-name'
    Logger.development.error.calledOnce.should.equal false

    route = DefaultRoute
      handler: Handler
      name: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'does not support children', ->
    expect ->
      route = DefaultRoute
        handler: Handler
        , <Handler />
    .to.throw /does not support children/

  expectedRegister = (route) ->
    store =
      register: sinon.spy()
    parents = [
      name: 'home'
      ,
      name: 'layer-one'
    ]
    path = '/home/layer-one'

    route.register parents, path, store

    store.register.should.have.been.calledWith route
    route.path.should.equal path
    route.chain.should.have.members [parents..., route]

  it 'registers with parent route prefix', ->
    expectedRegister DefaultRoute(handler: Handler)

  it 'registers with parent route prefix ignores path', ->
    expectedRegister DefaultRoute(handler: Handler, path: '/should/ignore')


