Routes = require '../../src/components/Routes'
Route = require '../../src/components/Route'
DefaultRoute = require '../../src/components/DefaultRoute'
NotFoundRoute = require '../../src/components/NotFoundRoute'
Redirect = require '../../src/components/Redirect'
Logger = require '../../src/utils/logger'
React = require 'react'

describe 'Routes', ->
  Handler = React.createClass
    render: -> <div className='test-handler'></div>

  beforeEach ->
    sinon.stub Logger.development, 'error'

  afterEach ->
    Logger.development.error.restore() if Logger.development.error.restore

  it 'factory type is Routes', ->
    Routes.type.should.equal 'Routes'

  it 'Creates route definition with Routes type', ->
    routes =
      <Routes handler={Handler}>
        <Route name='test' handler={Handler} />
      </Routes>

    routes.type.should.equal 'Routes'
    Logger.development.error.should.not.have.been.called

  it 'handler prop is not required', ->
    routes =
      <Routes>
        <Route name='test' handler={Handler} />
      </Routes>

    Logger.development.error.calledOnce.should.equal false

  it 'handler prop must be a component class', ->
    routes =
      <Routes handler=5>
        <Route name='test' handler={Handler} />
      </Routes>

    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handler`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected a valid React class'

  it 'handlerProps prop defaults to empty object', ->
    routes =
      <Routes>
        <Route name='test' handler={Handler} />
      </Routes>
    routes.props.handlerProps.should.be.empty

  it 'handlerProps prop must be an object', ->
    routes =
      <Routes handler={Handler} handlerProps=5>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`handlerProps`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `object`'

  it 'name prop must be a string', ->
    routes =
      <Routes name='some-random-name'>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal false

    routes =
      <Routes name=5>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`name`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'path prop must be a string', ->
    routes =
      <Routes path='some-random-path'>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal false

    routes =
      <Routes path=5>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`path`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'exclude prop must be a bool', ->
    routes =
      <Routes exclude=true>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal false

    routes =
      <Routes exclude=false>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal false

    routes =
      <Routes exclude=5>
        <Route name='test' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain '`exclude`'
    Logger.development.error.firstCall.args[0].message.should.contain 'expected `boolean`'

  it 'must provide at least one child', ->
    routes = <Routes />
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'Must provide at least one child'

  it 'children can be proper types', ->
    routes =
      <Routes>
        <Route name='test' handler={Handler} />
        <DefaultRoute name='defualt-test' handler={Handler} />
        <NotFoundRoute name='defualt-test' handler={Handler} />
        <Routes>
          <Route name='sub-test' handler={Handler} />
        </Routes>
        <Redirect fromPath='/somewhere' toPath='/someplace' />
      </Routes>
    Logger.development.error.calledOnce.should.equal false

  it 'children cannot be improper types', ->
    routes =
      <Routes>
        <Handler />
      </Routes>
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'All children must be a proper type'
    Logger.development.error.firstCall.args[0].message.should.contain '"Route"'
    Logger.development.error.firstCall.args[0].message.should.contain '"Routes"'
    Logger.development.error.firstCall.args[0].message.should.contain '"DefaultRoute"'
    Logger.development.error.firstCall.args[0].message.should.contain '"NotFoundRoute"'

  it 'only one default route allowed', ->
    routes =
      <Routes>
        <DefaultRoute name='defualt-test1' handler={Handler} />
        <DefaultRoute name='defualt-test2' handler={Handler} />
      </Routes>
    Logger.development.error.calledOnce.should.equal true
    Logger.development.error.firstCall.args[0].message.should.contain 'Only one <DefaultRoute /> is allowed'

  expectedRegister = (routes, expPath) ->
    store =
      register: sinon.spy()
    parents = [
      name: 'home'
      ,
      name: 'layer-one'
    ]
    path = '/home/layer-one'

    routes.register parents, path, store

    store.register.should.have.been.calledWith routes
    routes.path.should.equal expPath
    routes.chain.should.have.members [parents..., routes]

  it 'registers with parent routes prefix and routes name', ->
    path = '/home/layer-one/test'
    routes =
      <Routes handler={Handler} name='test'>
        <Route name='test' handler={Handler} />
      </Routes>
    expectedRegister routes, path

  it 'registers with parent routes prefix and routes path', ->
    path = '/home/layer-one/test-path'
    routes =
      <Routes handler={Handler} path='test-path'>
        <Route name='test' handler={Handler} />
      </Routes>
    expectedRegister routes, path

    routes =
      <Routes handler={Handler} path='test-path' name='test-name'>
        <Route name='test' handler={Handler} />
      </Routes>
    expectedRegister routes, path

  it 'registers with absolute path', ->
    routes =
      <Routes handler={Handler} path='/should/override'>
        <Route name='test' handler={Handler} />
      </Routes>
    expectedRegister routes, routes.props.path

    routes =
      <Routes handler={Handler} path='/should/override' name='test-name'>
        <Route name='test' handler={Handler} />
      </Routes>
    expectedRegister routes, routes.props.path

  it 'children can be provided as an array', ->
    children = [
      Route(name: 'test', handler: Handler)
      Route(name: 'test2', handler: Handler)
    ]
    routes = Routes(null, children)
    Logger.development.error.called.should.equal false

  containerDoesNotRegister = (routes, expPath) ->
    store =
      register: sinon.spy()
    parents = []
    path = '/'

    routes.register parents, path, store

    store.register.callCount.should.equal 1
    store.register.should.have.been.calledWith routes.children[0]
    routes.children[0].path.should.equal expPath
    routes.children[0].chain.should.have.members [routes, routes.children[0]]

  it 'does not register container when container does not have a name or path', ->
    routes =
      <Routes handler={Handler}>
        <Route name='test' handler={Handler} />
      </Routes>
    containerDoesNotRegister routes, '/test'

  it 'does not register container when container does not have a handler or path', ->
    routes =
      <Routes name='container'>
        <Route name='test' handler={Handler} />
      </Routes>
    containerDoesNotRegister routes, '/container/test'

  it 'does not register container when container does not have a handler or name', ->
    routes =
      <Routes path='container'>
        <Route name='test' handler={Handler} />
      </Routes>
    containerDoesNotRegister routes, '/container/test'

  it 'does not register container when container does not have a handler, name, or path', ->
    routes =
      <Routes>
        <Route name='test' handler={Handler} />
      </Routes>
    containerDoesNotRegister routes, '/test'

  it 'does not register container when container has a handler, name, or path but is explicitly excluded', ->
    routes =
      <Routes handler={Handler} path='/should/override' name='test-name' exclude>
        <Route name='test' handler={Handler} />
      </Routes>
    containerDoesNotRegister routes, '/should/override/test'

  it 'registers a redirect to the default when the default has a path and a route has not been registered against against the container\'s name yet', ->
    defaultRoute = <DefaultRoute name='default-route' path='default-route' handler={Handler} />
    routes =
      <Routes name='route-container' path='/' handler={Handler}>
        {defaultRoute}
      </Routes>

    store =
      register: sinon.spy()
      hasRoute: -> false
      getRoute: (name) ->
        if routes.name == name
          endpoint: routes
        else if defaultRoute.name == name
          endpoint: defaultRoute
        else
          throw 'Unexpected route requested'

    parents = [
      name: 'home'
      ,
      name: 'layer-one'
    ]
    path = '/home/layer-one'

    routes.register parents, path, store

    store.register.should.have.been.calledTwice

    store.register.getCall(0).should.have.been.calledWith defaultRoute

    redirect = store.register.getCall(1).args[0]
    redirect.type.should.equal 'Redirect'
    redirect.name.should.equal 'route-container'
    redirect.props.fromPath.should.equal '/'
    redirect.props.to.should.equal 'default-route'

  it 'registers an alias to the default when the default has the same path', ->
    defaultRoute = <DefaultRoute name='default-route' handler={Handler} />
    routes =
      <Routes name='route-container' path='/' handler={Handler}>
        {defaultRoute}
      </Routes>

    store =
      register: sinon.spy()
      registerAlias: sinon.spy()
      hasRoute: -> false

    parents = [
      name: 'home'
      ,
      name: 'layer-one'
    ]
    path = '/home/layer-one'

    routes.register parents, path, store

    store.register.should.have.been.calledOnce.and.calledWith defaultRoute

    store.registerAlias.should.have.been.calledOnce.and.calledWith routes, defaultRoute
