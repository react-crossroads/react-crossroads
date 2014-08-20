invariant = require 'react/lib/invariant'
getWindowPath = require './getWindowPath'
ExecutionEnvironment = require 'react/lib/ExecutionEnvironment'

# Location handler that uses full page refreshes. This is
# used as the fallback for HistoryLocation in browsers that
# do not support the HTML5 history API.
RefreshLocation =
  setup: ->
    invariant(
      ExecutionEnvironment.canUseDOM,
      'You cannot use RefreshLocation in an environment with no DOM'
    )

  push: (path) ->
    window.location = path

  replace: (path) ->
    window.location.replace(path)

  pop: ->
    window.history.back()

  getCurrentPath: ->
    getWindowPath()

  toString: -> '<RefreshLocation>'

module.exports = RefreshLocation
