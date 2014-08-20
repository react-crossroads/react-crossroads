invariant = require('react/lib/invariant')

_lastPath = null
_currentPath = '/'

# Location handler that does not require a DOM.
MemoryLocation = {

  setup: (onChange) ->

  push: (path) ->
    _lastPath = _currentPath
    _currentPath = path

  replace: (path) ->
    _currentPath = path

  pop: ->
    invariant(
      _lastPath != null,
      'You cannot use MemoryLocation to go back more than once'
    )

    _currentPath = _lastPath
    _lastPath = null

  getCurrentPath: ->
    _currentPath

  toString: ->
    '<MemoryLocation>'

}

module.exports = MemoryLocation
