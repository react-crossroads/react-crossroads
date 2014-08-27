React = require 'react'
componentClassPropValidator = require '../utils/componentClassPropValidator'

DefaultRoute = React.createClass
  displayName: 'DefaultRoute'
  propTypes:
    handler: React.PropTypes.component.isRequired
    name: React.PropTypes.string
  render: ->
    throw new Error 'The <DefaultRoute> component should not be rendered directly.'

module.exports = DefaultRoute
