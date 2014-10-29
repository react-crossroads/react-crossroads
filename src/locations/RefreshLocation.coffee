invariant = require 'react/lib/invariant'
getWindowPath = require './getWindowPath'
ExecutionEnvironment = require 'react/lib/ExecutionEnvironment'
join = require('path').join

_rootPath = null
_rootPathRgx = null

# Location handler that uses full page refreshes. This is
# used as the fallback for HistoryLocation in browsers that
# do not support the HTML5 history API.
RefreshLocation =
  setup: (onChange, rootPath) ->
    invariant(
      ExecutionEnvironment.canUseDOM,
      'You cannot use RefreshLocation in an environment with no DOM'
    )

    _rootPath = rootPath || ''
    _rootPathRgx = new RegExp "^#{rootPath || ''}"

  push: (path) ->
    path = join _rootPath, path
    window.location = path

  replace: (path) ->
    path = join _rootPath, path
    window.location.replace(path)

  pop: ->
    window.history.back()

  getCurrentPath: ->
    path = getWindowPath()
    path = path.replace _rootPathRgx, ''

    if path == '' then '/' else path

  isSupportedOrFallback: ->
    if ExecutionEnvironment.canUseDOM then true else 'memory'

  pathToHref: (path) -> join _rootPath, path

  toString: -> '<RefreshLocation>'

module.exports = RefreshLocation
