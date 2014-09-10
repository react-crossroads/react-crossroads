{assertUrl} = require './helpers'
addressStore = require '../../examples/address-book/store'

describe 'Address Book Example', ->
  expEntries = addressStore.getEntries().map (entry, i) ->
    name: entry.name
    twitter: entry.twitter
    link: "/address-book/#{i}"

  linkSelectorForEntry = (entry) -> ".address-entry-item:nth-child(#{entry + 1}) .address-entry-link"

  verifyDetails = (entry) ->
    assertUrl expEntries[entry].link
      .then -> driver.findElement(webdriver.By.css(linkSelectorForEntry entry)).getAttribute('class')
      .then (classAttr) -> classAttr.should.contain 'active'
      .then -> expect('.address-entry-link.active').dom.to.have.count 1
      .then -> driver.findElement(webdriver.By.css('.address-entry-name')).getText()
      .then (name) -> name.should.equal expEntries[entry].name
      .then -> driver.findElement(webdriver.By.css('.address-entry-twitter')).getText()
      .then (twitter) -> twitter.should.equal expEntries[entry].twitter

  it 'loads the address list', ->
    driver.get "#{root}address-book"
      .then -> driver.findElements(webdriver.By.css('.address-entry-link'))
      .then (elements) -> webdriver.promise.map elements, (element) ->
        webdriver.promise.all [element.getText(), element.getAttribute('href')]
          .then ([text, href]) -> {text, href}
      .then (entries) ->
        entries.forEach (entry, i) ->
          entry.text.should.equal expEntries[i].name
          entry.href.should.contain expEntries[i].link

  it 'opens an entry when clicking link', ->
    click = (entry) ->
      driver.findElement(webdriver.By.css(linkSelectorForEntry entry)).click()
        .then -> verifyDetails entry

    driver.get "#{root}address-book"
      .then -> click 1
      .then -> click 3
      .then -> click 0
      .then -> click 2

  it 'open to a specific entry', ->
    entry = 2
    driver.get "#{root}address-book/#{entry}"
      .then -> verifyDetails entry
