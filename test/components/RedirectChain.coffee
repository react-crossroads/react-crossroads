RedirectChain = require '../../src/components/RedirectChain'

describe 'Redirect Chain', ->
  actions = null

  beforeEach ->
    actions =
      replace: sinon.stub()

  it 'renders the null when currentChain is null', ->
    redirectChain = new RedirectChain actions, '/test/path'
    should.not.exist redirectChain.render()

  it 'renders the currentChain\'s render result', ->
    expResult = 'chain-result'
    currentChain =
      render: -> expResult

    redirectChain = new RedirectChain actions, '/test/path', currentChain
    redirectChain.render().should.equal expResult

  it 'renders the wrapped redirectChain\'s currentChain\'s render result', ->
    expResult = 'chain-result'
    currentChain =
      render: -> expResult

    innerRedirect = new RedirectChain actions, '/some/other/path', currentChain

    redirectChain = new RedirectChain actions, '/test/path', innerRedirect
    redirectChain.render().should.equal expResult

  it 'issues replace action when rendered', (done) ->
    expPath = '/test/path'

    actions =
      replace: (path) ->
        path.should.equal '/test/path'
        done()

    redirectChain = new RedirectChain actions, '/test/path'
    should.not.exist redirectChain.render()
