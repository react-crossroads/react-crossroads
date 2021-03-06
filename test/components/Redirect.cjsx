Redirect = require '../../src/components/Redirect'
Logger = require '../../src/utils/logger'
React = require 'react'

describe 'Redirect', ->
  Handler = React.createClass
    render: -> <div className='test-handler'></div>

  beforeEach ->
    sinon.stub Logger.development, 'error'

  afterEach ->
    Logger.development.error.restore() if Logger.development.error.restore

  it 'factory type is Redirect', ->
    Redirect.type.should.equal 'Redirect'

  it 'Creates route definition with Redirect type', ->
    redirect = Redirect from: 'somewhere', to: 'someplace'
    redirect.type.should.equal 'Redirect'
    Logger.development.error.should.not.have.been.called

  it 'either from or fromPath props are required', ->
    redirect = Redirect to: 'someplace'
    Logger.development.error.callCount.should.equal 2

    [0..1].forEach (i) ->
      Logger.development.error.getCall(i).args[0].message.should.contain 'Must provide either from, or fromPath but only one of them'

  it 'from prop must be a string', ->
    redirect = Redirect
      from: 'somewhere'
      to: 'someplace'
    Logger.development.error.calledOnce.should.equal false

    redirect = Redirect
      from: 5
      to: 'someplace'
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`from`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'


  it 'fromPath prop must be a string', ->
    redirect = Redirect
      fromPath: 'somewhere'
      to: 'someplace'
    Logger.development.error.calledOnce.should.equal false

    redirect = Redirect
      fromPath: 5
      to: 'someplace'
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`fromPath`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'either to or path props are required', ->
    redirect = Redirect from: 'someplace'
    Logger.development.error.callCount.should.equal 2

    [0..1].forEach (i) ->
      Logger.development.error.getCall(i).args[0].message.should.contain 'Must provide either to, or path but only one of them'

  it 'to prop must be a string', ->
    redirect = Redirect
      from: 'somewhere'
      to: 'someplace'
    Logger.development.error.calledOnce.should.equal false

    redirect = Redirect
      from: 'somewhere'
      to: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`to`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'


  it 'path prop must be a string', ->
    redirect = Redirect
      from: 'somewhere'
      path: 'someplace'
    Logger.development.error.calledOnce.should.equal false

    redirect = Redirect
      from: 'somewhere'
      path: 5
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`path`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'does not support children', ->
    expect ->
      redirect = Redirect
        handler: Handler
        name: 'test'
        , <Handler />
    .to.throw /does not support children/

  expectedRegister = (redirect, expPath, routes) ->
    routes = routes || {}
    store =
      register: sinon.spy()

    store.getRoute = (name) -> routes[name]
    sinon.spy store, 'getRoute'

    parents = [
      name: 'home'
     ,
      name: 'layer-one'
    ]
    path = '/home/layer-one'

    redirect.register parents, path, store

    store.register.should.have.been.calledOnce.and.calledWith redirect
    redirect.path.should.equal expPath
    redirect.chain.should.have.members [parents..., redirect]
    Logger.development.error.called.should.equal false

    ['to', 'from'].forEach (type) ->
      if redirect.props[type]?
        store.getRoute.should.have.been.calledWith redirect.props[type]

  it "registers with from route's registered path", ->
    from = 'somewhere'
    routes =
      somewhere:
        endpoint:
          path: '/home/somewhere'
      someplace:
        endpoint:
          path: '/home/someplace'

    redirect = Redirect from: from, to: 'someplace'
    expectedRegister redirect, routes[from].endpoint.path, routes

  it 'registers with relative fromPath prop', ->
    routes =
      someplace:
        endpoint:
          path: '/home/someplace'

    path = '/home/layer-one/somewhere'
    redirect = Redirect fromPath: 'somewhere', to: 'someplace'
    expectedRegister redirect, path, routes

  it 'registers with absolute fromPath prop', ->
    routes =
      someplace:
        endpoint:
          path: '/home/someplace'

    path = '/home/somewhere'
    redirect = Redirect fromPath: path, to: 'someplace'
    expectedRegister redirect, path, routes
