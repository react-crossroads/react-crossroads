invariant = require('react/lib/invariant')

_onChange = null

# Location handler that does not require a DOM.
MemoryLocation =
  setup: (onChange) ->
    _onChange = onChange

  push: (path) ->
    _lastPath = _currentPath
    _currentPath = path
    _onChange()

  replace: (path) ->
    _currentPath = path
    _onChange()

  pop: ->
    invariant(
      _lastPath != null,
      'You cannot use MemoryLocation to go back more than once'
    )

    _currentPath = _lastPath
    _lastPath = null
    _onChange()

  getCurrentPath: ->
    _currentPath

  isSupportedOrFallback: -> true

  toString: ->
    '<MemoryLocation>'

module.exports = MemoryLocation
