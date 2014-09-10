class RedirectChain
  constructor: (@actions, @toPath, @currentChain) ->

  render: ->
    # TODO: Figure out something better than a set timeout
    setTimeout => @actions.replace @toPath

    if @currentChain?
      return null

    if @currentChain instanceof RedirectChain
      return null

    @currentChain

module.exports = RedirectChain
