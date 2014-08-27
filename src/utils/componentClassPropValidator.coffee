React = require 'react'

ANONYMOUS = '<<anonymous>>'

# Create chain-able isRequired validator
#
# Largely copied directly from:
# https://github.com/facebook/react/blob/0.11-stable/src/core/ReactPropTypes.js#L94
createChainableTypeChecker = (validate) ->
  checkType = (isRequired, props, propName, componentName) ->
    componentName = componentName || ANONYMOUS

    if props[propName] == null
      if isRequired
        new Error "Required prop `#{propName}` was not specified in `#{componentName}`."
    else
      return validate props, propName, componentName

  chainedCheckType = checkType.bind null, false
  chainedCheckType.isRequired = checkType.bind null, true

  chainedCheckType

module.exports = ->
  validate = (props, propName, componentName) ->
    if !React.isValidClass props[propName]
      new Error "Invalid prop #{propName} supplied to #{componentName}, expected a valid React class."

  createChainableTypeChecker validate
