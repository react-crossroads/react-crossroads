class RedirectChain
  constructor: (@actions, @toPath, @currentChain) ->

  render: =>
    # TODO: Figure out something better than a set timeout
    setTimeout => @actions.replace @toPath

    unless @currentChain?
      return null

    if @currentChain instanceof RedirectChain
      return @currentChain.currentChain.render()

    @currentChain.render()

module.exports = RedirectChain
