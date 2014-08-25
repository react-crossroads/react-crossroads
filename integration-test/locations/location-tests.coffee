{sendText, assertUrl, getCurrentUrlAndPath, checkHistory, forward, push, replace, goback} = require '../location-helpers'

describe 'hash location', ->
  hashRoot = "#{root}hash-location-app"
  hashUrlPrefix = "#{root}hash-location-app#"

  beforeEach ->
    driver.get hashRoot

  it 'the default path is /', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.getCurrentUrl()
      .then (url) -> url.should.equal "#{hashUrlPrefix}/"

  it 'push to /test', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> push '/test', hashUrlPrefix

  it 'replace to /test', ->
    @timeout(3000)
    expect('.current-path').dom.to.have.text '/'
      .then -> replace '/test', hashUrlPrefix

  it 'go back to /', ->
    path = '/test'
    url = "#{hashUrlPrefix}#{path}"

    expect('.current-path').dom.to.have.text '/'
      .then -> driver.get url
      .then -> assertUrl path, url
      .then -> goback '/', "#{hashUrlPrefix}/"

describe 'history location', ->
  historyRoot = "#{root}history-location-app"
  windowId = 0

  beforeEach ->
    driver.get historyRoot

  it 'the default path is /', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.getCurrentUrl()
      .then (url) -> url.should.equal historyRoot

  it 'push to /test', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> push '/test', historyRoot

  it 'replace to /test', ->
    @timeout(3000)
    expect('.current-path').dom.to.have.text '/'
      .then -> replace '/test', historyRoot

  it 'go back to /', ->
    path = '/test'
    url = "#{historyRoot}#{path}"

    expect('.current-path').dom.to.have.text '/'
      .then -> driver.get url
      .then -> assertUrl path, url
      .then -> goback '/', historyRoot

describe 'refresh location', ->
  refreshRoot = "#{root}refresh-location-app"
  windowId = 0

  beforeEach ->
    driver.get refreshRoot

  it 'the default path is /', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.getCurrentUrl()
      .then (url) -> url.should.equal refreshRoot

  it 'push to /test', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> push '/test', refreshRoot

  it 'replace to /test', ->
    @timeout(3000)
    expect('.current-path').dom.to.have.text '/'
      .then -> replace '/test', refreshRoot

  it 'go back to /', ->
    path = '/test'
    url = "#{refreshRoot}#{path}"

    expect('.current-path').dom.to.have.text '/'
      .then -> driver.get url
      .then -> assertUrl path, url
      .then -> goback '/', refreshRoot
