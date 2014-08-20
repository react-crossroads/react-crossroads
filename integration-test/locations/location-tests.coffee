root = 'http://localhost:3002/'

sendText = (text) ->
  driver.findElement webdriver.By.tagName('input')
    .then (input) ->
      input.clear()
        .then -> input.sendKeys text

assertUrl = (path, url) ->
  expect('.current-path').dom.to.have.text path
    .then -> driver.getCurrentUrl()
    .then (currentUrl) -> currentUrl.should.equal url

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

goback = (prevPath, prevUrl) ->
  startUrl = null
  startPath = null

  getCurrentUrlAndPath()
    .then (current) -> {startUrl, startPath} = current
    .then -> driver.findElement(webdriver.By.id('goback')).click()
    .then -> assertUrl prevPath, prevUrl
    .then -> driver.navigate().forward()
    .then -> assertUrl startPath, startUrl
    .then -> driver.navigate().back()
    .then -> assertUrl prevPath, prevUrl

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
    url = "#{hashUrlPrefix}/test"

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
