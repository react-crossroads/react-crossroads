React = require 'react'
componentClassPropValidator = require '../utils/componentClassPropValidator'

Routes = React.createClass
  displayName: 'Routes'

  propTypes:
    handler: componentClassPropValidator
    path: React.PropTypes.string
    name: React.PropTypes.string
    handlerProps: React.PropTypes.object
    children: React.PropTypes.oneOfType([
      React.PropTypes.component,
      React.PropTypes.arrayOf React.PropTypes.component
    ]).isRequired

  getDefaultProps: ->
    handlerProps: {}

  render: ->
    throw new Error 'The <Routes> component should not be rendered directly.'

module.exports = Routes
