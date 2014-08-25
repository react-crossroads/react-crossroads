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

module.exports = {sendText, assertUrl, getCurrentUrlAndPath, checkHistory, forward, push, replace, goback}
