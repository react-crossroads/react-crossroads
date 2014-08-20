root = 'http://localhost:3002/'

sendText = (text) ->
  driver.findElement webdriver.By.tagName('input')
    .then (input) ->
      input.clear()
        .then -> input.sendKeys text

assertUrl = (path, url) ->
  driver.getCurrentUrl()
    .then (currentUrl) -> currentUrl.should.equal url
    .then -> chai.expect('.current-path').dom.to.have.text path

getCurrentUrlAndPath = ->
  startUrl = null

  driver.getCurrentUrl()
    .then (url) -> startUrl = url
    .then -> driver.findElement webdriver.By.css('.current-path')
    .then (currentPath) -> currentPath.getText()
    .then (startPath) -> {startUrl, startPath}

checkHistory = (currentPath, currentUrl, lastPath, lastUrl) ->
  assertUrl currentPath, currentUrl
    .then -> driver.navigate().back()
    .then -> assertUrl lastPath, lastUrl
    .then -> driver.navigate().forward()
    .then -> assertUrl currentPath, currentUrl

forward = (path, expectUrlPrefix, thorough, op) ->
  startUrl = null
  startPath = null

  promise = getCurrentUrlAndPath()
    .then (current) -> {startUrl, startPath} = current
    .then -> op()

  if thorough
    promise = promise
      .then -> checkHistory path, "#{expectUrlPrefix}#{path}", startPath, startUrl

  promise

push = (path, expectUrlPrefix, thorough=true) ->
  forward path, expectUrlPrefix, thorough, ->
    sendText path
      .then -> driver.findElement(webdriver.By.id('push')).click()

replace = (path, expectUrlPrefix, thorough=true) ->
  forward path, expectUrlPrefix, thorough, ->
    push '/some/obscure/path/that/should/not/matter', expectUrlPrefix, false
      .then -> sendText path
      .then -> driver.findElement(webdriver.By.id('replace')).click()

describe 'hash location', ->
  hashRoot = "#{root}hash-location-app"
  hashUrlPrefix = "#{root}hash-location-app#"

  beforeEach ->
    driver.get hashRoot

  it 'the default path is /', ->
    chai.expect('.current-path').dom.to.have.text '/'
      .then -> driver.getCurrentUrl()
      .then (url) -> url.should.equal "#{hashUrlPrefix}/"

  it 'push to /test', ->
    chai.expect('.current-path').dom.to.have.text '/'
      .then -> push '/test', hashUrlPrefix

  it 'replace to /test', ->
    @timeout(3000)
    chai.expect('.current-path').dom.to.have.text '/'
      .then -> replace '/test', hashUrlPrefix

describe 'history location', ->
  historyRoot = "#{root}history-location-app"
  windowId = 0

  beforeEach ->
    driver.get historyRoot

  it 'the default path is /', ->
    chai.expect('.current-path').dom.to.have.text '/'
      .then -> driver.getCurrentUrl()
      .then (url) -> url.should.equal historyRoot

  it 'push to /test', ->
    chai.expect('.current-path').dom.to.have.text '/'
      .then -> push '/test', historyRoot

  it 'replace to /test', ->
    @timeout(3000)
    chai.expect('.current-path').dom.to.have.text '/'
      .then -> replace '/test', historyRoot
