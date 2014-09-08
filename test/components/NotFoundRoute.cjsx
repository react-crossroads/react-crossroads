NotFoundRoute = require '../../src/components/NotFoundRoute'
Logger = require '../../src/utils/logger'
React = require 'react'

describe 'Not Found Route', ->
  Handler = React.createClass
    render: -> <div className='test-handler'></div>

  beforeEach ->
    sinon.stub Logger.development, 'error'

  afterEach ->
    Logger.development.error.restore() if Logger.development.error.restore

  it 'factory type is NotFoundRoute', ->
    NotFoundRoute.type.should.equal 'NotFoundRoute'

  it 'Creates route definition with NotFoundRoute type', ->
    route = NotFoundRoute handler: Handler
    route.type.should.equal 'NotFoundRoute'
    Logger.development.error.should.not.have.been.called

  it 'handler prop is required', ->
    route = NotFoundRoute()
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'Required prop `handler` was not specified'

  it 'handler prop must be a component class', ->
    route = NotFoundRoute handler: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handler`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected a valid React class'

  it 'handlerProps prop defaults to empty object', ->
    route = NotFoundRoute handler: Handler
    route.props.handlerProps.should.be.empty

  it 'handlerProps prop must be an object', ->
    route = NotFoundRoute handler: Handler, handlerProps: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handlerProps`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `object`'

  it 'default path prop is wildcard', ->
    route = NotFoundRoute
      handler: Handler

    route.props.path.should.equal ':path*:'

  it 'path prop must be a string', ->
    route = NotFoundRoute
      handler: Handler
      path: 'some-random-path'
    Logger.development.error.calledOnce.should.equal false

    route = NotFoundRoute
      handler: Handler
      path: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'does not support children', ->
    expect ->
      route = NotFoundRoute
        handler: Handler
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

  it 'registers with parent route prefix', ->
    path = '/home/layer-one/:path*:'
    route = NotFoundRoute handler: Handler
    expectedRegister route, path

  it 'registers with parent route prefix absolute path', ->
    path = '/:path*:'
    route = NotFoundRoute
      handler: Handler
      path: '/'

    expectedRegister route, path
