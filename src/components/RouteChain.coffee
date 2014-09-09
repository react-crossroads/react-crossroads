class RouteChain
  constructor: (@path, @chain, @route) ->

  makePath: (params) ->
    @route.interpolate params

module.exports = RouteChain
