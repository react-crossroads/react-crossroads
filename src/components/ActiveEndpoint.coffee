ActiveHandler = require './ActiveHandler'
_ = require 'lodash'

class ActiveEndpoint
  constructor: (@path, @endpoint, @params) ->

  render: ->
    rootHandler = new ActiveHandler @endpoint.chain, @params
    rootHandler.activeRouteHandler()

  isActive: (to, params) ->
    match = _.chain @endpoint.chain
      .filter (endpoint) -> endpoint.name == to
      .first()
      .value()

    return false unless match?

    @path.indexOf(match.makePath params) == 0

module.exports = ActiveEndpoint
