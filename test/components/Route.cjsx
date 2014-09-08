Route = require '../../src/components/Route'
Logger = require '../../src/utils/logger'
React = require 'react'

describe 'Route', ->
  Handler = React.createClass
    render: -> <div className='test-handler'></div>

  beforeEach ->
    sinon.stub Logger.development, 'error'

  afterEach ->
    Logger.development.error.restore() if Logger.development.error.restore

  it 'factory type is Route', ->
    Route.type.should.equal 'Route'

  it 'Creates route definition with Route type', ->
    route = Route handler: Handler, name: 'test'
    route.type.should.equal 'Route'
    Logger.development.error.should.not.have.been.called

  it 'handler prop is required', ->
    route = Route name: 'test'
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'Required prop `handler` was not specified'

  it 'handler prop must be a component class', ->
    route = Route handler: 5, name: 'test'
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handler`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected a valid React class'

  it 'handlerProps prop defaults to empty object', ->
    route = Route handler: Handler, name: 'test'
    route.props.handlerProps.should.be.empty

  it 'handlerProps prop must be an object', ->
    route = Route handler: Handler, name: 'test', handlerProps: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handlerProps`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `object`'

  it 'name prop must be a string', ->
    route = Route
      handler: Handler
      name: 'some-random-name'
    Logger.development.error.calledOnce.should.equal false

    route = Route
      handler: Handler
      name: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`name`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'path prop must be a string', ->
    route = Route
      handler: Handler
      path: 'some-random-path'
    Logger.development.error.calledOnce.should.equal false

    route = Route
      handler: Handler
      path: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`path`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'path or name or both is required', ->
    route = Route
      handler: Handler
      name: 'some-random-name'
      path: 'some-random-path'
    Logger.development.error.calledOnce.should.equal false

    route = Route
      handler: Handler
    Logger.development.error.calledTwice.should.equal true

    _.chain [0, 1]
      .map (i) -> Logger.development.error.getCall(i)
      .each (call) -> call.args[0].message.should.contain 'Must provide either a name, a path or both'

  it 'does not support children', ->
    expect ->
      route = Route
        handler: Handler
        name: 'test'
        , <Handler />
    .to.throw /does not support children/

  expectedRegister = (route, expPath) ->
    store =
      register: sinon.spy()
    parents = [
      name: 'home'
      ,
      name: 'layer-one'
    ]
    path = '/home/layer-one'

    route.register parents, path, store

    store.register.should.have.been.calledWith expPath, [parents..., route]

  it 'registers with parent route prefix and route name', ->
    path = '/home/layer-one/test'
    route = Route handler: Handler, name: 'test'
    expectedRegister route, path

  it 'registers with parent route prefix and route path', ->
    path = '/home/layer-one/test-path'
    route = Route handler: Handler, path: 'test-path'
    expectedRegister route, path

    route = Route handler: Handler, path: 'test-path', name: 'test-name'
    expectedRegister route, path

  it 'registers with absolute path', ->
    route = Route handler: Handler, path: '/should/override'
    expectedRegister route, route.props.path

    route = Route handler: Handler, path: '/should/override', name: 'test-name'
    expectedRegister route, route.props.path


