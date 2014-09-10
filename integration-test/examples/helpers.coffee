join = require('path').join

assertUrl = (path) ->
  path = if path[0] == '/' then path.substring 1 else path
  url = root + path

  driver.getCurrentUrl()
    .then (currentUrl) -> currentUrl.should.equal url

module.exports = {assertUrl}
