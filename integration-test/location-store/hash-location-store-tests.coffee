{sendText, assertUrl, getCurrentUrlAndPath, checkHistory, forward, push, replace, goback} = require '../location-helpers'

describe 'hash location store', ->
  hashRoot = "#{root}hash-location-store-app"
  hashUrlPrefix = "#{hashRoot}#"

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

  it 'quick navigation', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('quick2')).click()
      .then -> driver.findElement(webdriver.By.id('quick3')).click()
      .then -> driver.findElement(webdriver.By.id('goback')).click()
      .then -> driver.findElement(webdriver.By.id('quick4')).click()
      .then -> driver.findElement(webdriver.By.id('quick5')).click()
      .then -> driver.findElement(webdriver.By.id('goback')).click()
      .then -> driver.findElement(webdriver.By.id('goback')).click()
      .then -> assertUrl '/quick2', "#{hashUrlPrefix}/quick2"
