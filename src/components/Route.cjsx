React = require 'react'
componentClassPropValidator = require '../utils/componentClassPropValidator'

_atLeastOneUnlessDefault = (props, propName) ->
  return new Error 'Must provide either a name, a path or both' unless props.name or props.path
  React.PropTypes.string.apply(null, arguments)

Route = React.createClass
  displayName: 'Route'
  propTypes:
    handler: React.PropTypes.component.isRequired
    path: _atLeastOneUnlessDefault
    name: _atLeastOneUnlessDefault
    handlerProps: React.PropTypes.object
  getDefaultProps: ->
    default: false
    handlerProps: {}
  render: ->
    throw new Error 'The <Route> component should not be rendered directly.'

module.exports = Route
