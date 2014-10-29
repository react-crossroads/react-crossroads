React = require 'react'

LocationApp = React.createClass
  displayName: 'LocationApp'
  getInitialState: ->
    @props.location.setup @urlChange, @props.rootPath

    url: @props.location.getCurrentPath()
  getDesiredPath: ->
    path = @refs.path.getDOMNode().value
  handlePush: ->
    @props.location.push(@getDesiredPath())
  handleReplace: ->
    @props.location.replace(@getDesiredPath())
  handleGoBack: ->
    @props.location.pop()
  urlChange: ->
    @setState
      url: @props.location.getCurrentPath()
  render: ->
    <div>
      {@props.children}
      <br />
      <input ref='path' />
      <br />
      <button id='push' onClick={@handlePush}>Push</button>
      <button id='replace' onClick={@handleReplace}>Replace</button>
      <button id='goback' onClick={@handleGoBack}>Go Back</button>
      <br />
      <div className='current-path'>{@state.url}</div>
    </div>

module.exports = LocationApp
