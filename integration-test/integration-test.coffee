_ = require 'lodash'
webdriver = require 'selenium-webdriver'
Key = webdriver.Key
driver = new webdriver.Builder()
  .withCapabilities webdriver.Capabilities.chrome()
  .build()

chai = require 'chai'
{expect} = chai
chaiWebdriver = require 'chai-webdriver'
chai.use chaiWebdriver(driver)
should = chai.should()

root = 'http://localhost:3002/'

_.extend global, {_, expect, should, webdriver, driver, chai, Key, root}

require './locations/location-tests'
require './location-store'

after ->
  driver.quit()
