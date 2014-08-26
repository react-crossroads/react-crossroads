invariant = require 'react/lib/invariant'
getWindowPath = require './getWindowPath'
ExecutionEnvironment = require 'react/lib/ExecutionEnvironment'
join = require('path').join

_initialPath = null
_initialPathRgx = null

# Location handler that uses full page refreshes. This is
# used as the fallback for HistoryLocation in browsers that
# do not support the HTML5 history API.
RefreshLocation =
  setup: (onChange, initialPath) ->
    invariant(
      ExecutionEnvironment.canUseDOM,
      'You cannot use RefreshLocation in an environment with no DOM'
    )

    _initialPath = initialPath || ''
    _initialPathRgx = new RegExp "^#{initialPath || ''}"

  push: (path) ->
    path = join _initialPath, path
    window.location = path

  replace: (path) ->
    path = join _initialPath, path
    window.location.replace(path)

  pop: ->
    window.history.back()

  getCurrentPath: ->
    path = getWindowPath()
    path = path.replace _initialPathRgx, ''

    if path == '' then '/' else path

  isSupportedOrFallback: ->
    if ExecutionEnvironment.canUseDOM then true else 'memory'

  toString: -> '<RefreshLocation>'

module.exports = RefreshLocation
