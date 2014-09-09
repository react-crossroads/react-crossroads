{sendText, assertUrl, getCurrentUrlAndPath, checkHistory, forward, push, replace, goback} = require '../location-helpers'

expectBlock = (value) ->
  expect('.store-blocked').dom.to.have.text value
    .then -> expect('.expected-id-blocked').dom.to.have.text value

describe 'block routing', ->
  historyRoot = "#{root}history-location-store-app"

  beforeEach ->
    driver.get historyRoot

  it 'is not blocked by default', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'

  it 'can toggle blocked state', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'false'

  it 'cannot navigate while blocked', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> expectBlock 'true'
      .then -> expect('.current-path').dom.to.have.text '/'

  it 'can navigate after clearing block', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> expect('.current-path').dom.to.have.text '/quick1'

  it 'dismissing attempt clears options and does nothing', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('dismissAttempt')).click()
      .then -> expectBlock 'true'
      .then -> expect('.current-path').dom.to.have.text '/'
      .then -> expect('#dismissAttempt').dom.to.have.count 0

  it 'dismissing attempt after clearing block clears options and does nothing', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('dismissAttempt')).click()
      .then -> expectBlock 'false'
      .then -> expect('.current-path').dom.to.have.text '/'
      .then -> expect('#dismissAttempt').dom.to.have.count 0

  it 'continuing attempt while blocked does not clear options and does not continue', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('continueAttempt')).click()
      .then -> expectBlock 'true'
      .then -> expect('.current-path').dom.to.have.text '/'
      .then -> expect('#continueAttempt').dom.to.have.count 1

  it 'continuing attempt after clearing block clears options and continues', ->
    expect('.current-path').dom.to.have.text '/'
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'true'
      .then -> driver.findElement(webdriver.By.id('quick1')).click()
      .then -> driver.findElement(webdriver.By.id('toggleBlock')).click()
      .then -> expectBlock 'false'
      .then -> driver.findElement(webdriver.By.id('continueAttempt')).click()
      .then -> expect('.current-path').dom.to.have.text '/quick1'
      .then -> expect('#continueAttempt').dom.to.have.count 0
