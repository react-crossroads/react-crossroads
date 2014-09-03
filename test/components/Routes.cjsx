Routes = require '../../src/components/Routes'
Route = require '../../src/components/Route'
DefaultRoute = require '../../src/components/DefaultRoute'
NotFoundRoute = require '../../src/components/NotFoundRoute'
React = require 'react'

describe 'Routes', ->
  Handler = React.createClass
    render: -> <div className='test-handler'></div>

  beforeEach ->
    sinon.stub console, 'error'

  afterEach ->
    console.error.restore() if console.error.restore

  it 'factory type is Routes', ->
    Routes.type.should.equal 'Routes'

  it 'Creates route definition with Routes type', ->
    routes =
      <Routes handler={Handler}>
        <Route name='test' handler={Handler} />
      </Routes>

    routes.type.should.equal 'Routes'
    console.error.should.not.have.been.called

  it 'handler prop is not required', ->
    routes =
      <Routes>
        <Route name='test' handler={Handler} />
      </Routes>

    console.error.calledOnce.should.equal false

  it 'handler prop must be a component class', ->
    routes =
      <Routes handler=5>
        <Route name='test' handler={Handler} />
      </Routes>

    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain '`handler`'
    console.error.firstCall.args[0].message.should.contain 'expected a valid React class'

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
    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain '`handlerProps`'
    console.error.firstCall.args[0].message.should.contain 'expected `object`'

  it 'name prop must be a string', ->
    routes =
      <Routes name='some-random-name'>
        <Route name='test' handler={Handler} />
      </Routes>
    console.error.calledOnce.should.equal false

    routes =
      <Routes name=5>
        <Route name='test' handler={Handler} />
      </Routes>
    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain '`name`'
    console.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'path prop must be a string', ->
    routes =
      <Routes path='some-random-path'>
        <Route name='test' handler={Handler} />
      </Routes>
    console.error.calledOnce.should.equal false

    routes =
      <Routes path=5>
        <Route name='test' handler={Handler} />
      </Routes>
    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain '`path`'
    console.error.firstCall.args[0].message.should.contain 'expected `string`'

  it 'must provide at least one child', ->
    routes = <Routes />
    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain 'Must provide at least one child'

  it 'children can be proper types', ->
    routes =
      <Routes>
        <Route name='test' handler={Handler} />
        <DefaultRoute name='defualt-test' handler={Handler} />
        <NotFoundRoute name='defualt-test' handler={Handler} />
        <Routes>
          <Route name='sub-test' handler={Handler} />
        </Routes>
      </Routes>
    console.error.calledOnce.should.equal false

  it 'children cannot be improper types', ->
    routes =
      <Routes>
        <Handler />
      </Routes>
    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain 'All children must be a proper type'
    console.error.firstCall.args[0].message.should.contain '"Route"'
    console.error.firstCall.args[0].message.should.contain '"Routes"'
    console.error.firstCall.args[0].message.should.contain '"DefaultRoute"'
    console.error.firstCall.args[0].message.should.contain '"NotFoundRoute"'

  it 'only one default route allowed', ->
    routes =
      <Routes>
        <DefaultRoute name='defualt-test1' handler={Handler} />
        <DefaultRoute name='defualt-test2' handler={Handler} />
      </Routes>
    console.error.calledOnce.should.equal true
    console.error.firstCall.args[0].message.should.contain 'Only one <DefaultRoute /> is allowed'

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

    store.register.should.have.been.calledWith expPath, [parents..., routes]

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
    console.error.called.should.equal false


