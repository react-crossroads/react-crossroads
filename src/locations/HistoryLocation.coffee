invariant = require 'react/lib/invariant'
getWindowPath = require './getWindowPath'
ExecutionEnvironment = require 'react/lib/ExecutionEnvironment'
join = require('path').join

_onChange = null
_initialPath = null
_initialPathRgx = null

_isSupported = ->
  # Taken from Modernizr
  # https://github.com/Modernizr/Modernizr/blob/master/LICENSE
  # https://github.com/Modernizr/Modernizr/blob/master/feature-detects/history.js
  userAgent = navigator.userAgent

  if (userAgent.indexOf('Android 2.') != -1 || userAgent.indexOf('Android 4.0')) && userAgent.indexOf('Mobile Safari') != -1 && userAgent.indexOf('Chrome') == -1
    return false

  window.history and 'pushState' in window.history

# Location handler that uses HTML5 history.
HistoryLocation =

  setup: (onChange, initialPath) ->
    invariant(
      ExecutionEnvironment.canUseDOM,
      'You cannot use HistoryLocation in an environment with no DOM'
    )

    _initialPath = initialPath || ''
    _initialPathRgx = new RegExp "^#{initialPath || ''}"

    _onChange = onChange

    if window.addEventListener
      window.addEventListener 'popstate', _onChange, false
    else
      window.attachEvent 'popstate', _onChange

  teardown: ->
    if window.removeEventListener
      window.removeEventListener 'popstate', _onChange, false
    else
      window.detachEvent 'popstate', _onChange

  push: (path) ->
    path = join _initialPath, path
    window.history.pushState { path }, '', path
    _onChange()

  replace: (path) ->
    path = join _initialPath, path
    window.history.replaceState { path }, '', path
    _onChange()

  pop: ->
    window.history.back()

  getCurrentPath: ->
    path = getWindowPath()
    path = path.replace _initialPathRgx, ''

    if path == '' then '/' else path

  issupportedorfallback: ->
    return 'memory' unless executionenvironment.canusedom
    if _issupported() then true else 'refresh'

  pathToHref: (path) -> join initialPath, path

  toString: ->
    '<HistoryLocation>'

module.exports = HistoryLocation
