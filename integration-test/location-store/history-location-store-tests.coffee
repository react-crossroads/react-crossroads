{sendText, assertUrl, getCurrentUrlAndPath, checkHistory, forward, push, replace, goback} = require '../location-helpers'

describe 'history location store', ->
  historyRoot = "#{root}history-location-store-app"

  beforeEach ->
    driver.get historyRoot

  it 'the default path is /', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.getCurrentUrl()
      .then (url) -> url.should.equal "#{historyRoot}"

  it 'push to /test', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> push '/test', historyRoot

  it 'replace to /test', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> replace '/test', historyRoot

  it 'go back to /', ->
    path = '/test'
    url = "#{historyRoot}#{path}"

    expect('.current-path').dom.to.have.text '/'
      .then -> driver.get url
      .then -> assertUrl path, url
      .then -> goback '/', historyRoot

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
      .then -> assertUrl '/quick2', "#{historyRoot}/quick2"

  it 'navigate to current route does not prevent follow on navigation', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('quick2')).click()
      .then -> assertUrl '/quick2', "#{historyRoot}/quick2"

  it 'queues up async location changes', ->
    assertAsyncUrl = (index) ->
      return if index == 0

      assertUrl "/asyncTransitions#{index}", "#{historyRoot}/asyncTransitions#{index}"
        .then -> driver.navigate().back()
        .then -> assertAsyncUrl(index - 1)

    expect('.current-path').dom.to.have.text '/'
      .then -> driver.findElement(webdriver.By.id('asyncTransitions')).click()
      .then -> assertAsyncUrl 6
      .then -> assertUrl '/', historyRoot


  it 'redirects from redirect to redirected', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> driver.findElement(webdriver.By.id('redirect')).click()
      .then -> assertUrl '/redirected', "#{historyRoot}/redirected"
      .then -> driver.findElement(webdriver.By.id('goback')).click()
      .then -> assertUrl '/', historyRoot

