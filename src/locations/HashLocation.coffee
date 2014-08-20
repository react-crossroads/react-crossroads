invariant = require 'react/lib/invariant'
getWindowPath = require './getWindowPath'
ExecutionEnvironment = require 'react/lib/ExecutionEnvironment'

_onChange = null

# Location handler that uses `window.location.hash`.
HashLocation =
  setup: (onChange) ->
    invariant(
      ExecutionEnvironment.canUseDOM,
      'You cannot use HashLocation in an environment with no DOM'
    )

    _onChange = onChange

    # Make sure the hash is at least / to begin with.
    if window.location.hash == ''
      window.location.replace "#{getWindowPath()}#/"

    if window.addEventListener
      window.addEventListener 'hashchange', _onChange, false
    else
      window.attachEvent 'onhashchange', _onChange

  teardown: ->
    if window.removeEventListener
      window.removeEventListener 'hashchange', _onChange, false
    else
      window.detachEvent 'onhashchange', _onChange

  push: (path) ->
    window.location.hash = path

  replace: (path) ->
    window.location.replace "#{getWindowPath()}##{path}"

  pop: ->
    window.history.back()

  getCurrentPath: ->
    window.location.hash.substr 1

  toString: ->
    '<HashLocation>'

module.exports = HashLocation
