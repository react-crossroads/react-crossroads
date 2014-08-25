React = require 'react'
RouterActions = require '../../src/actions/RouterActions'
LocationStore = require '../../src/stores/LocationStore'

LocationStoreComponent = React.createClass
  displayName: 'LocationStoreComponent'
  getInitialState: ->
    path: LocationStore.getCurrentPath()
  getDesiredPath: ->
    path = @refs.path.getDOMNode().value
  handlePush: ->
    RouterActions.transition @getDesiredPath()
  handleReplace: ->
    RouterActions.replace @getDesiredPath()
  handleGoBack: ->
    RouterActions.back()
  toggleBlocked: ->
    if LocationStore.isBlocked()
      RouterActions.unblock()
    else
      RouterActions.block()
  componentDidMount: ->
    LocationStore.addChangeListener @pathChanged
  componentWillUnmount: ->
    LocationStore.removeChangeListener @pathChanged
  pathChanged: ->
    @setState
      path: LocationStore.getCurrentPath()
      blocked: LocationStore.isBlocked()
  push: (path) ->
    RouterActions.transition path
  render: ->
    <div>
      {@props.children}
      <br />
      <input ref='path' />
      <br />
      <button id='push' onClick={@handlePush}>Push</button>
      <button id='replace' onClick={@handleReplace}>Replace</button>
      <button id='goback' onClick={@handleGoBack}>Go Back</button>
      <button id='toggleBlocked' onClick={@toggleBlocked}>{if @state.blocked then 'Unblock' else 'Block'}</button>
      <br />
      <button id='quick1' onClick={=> @push '/quick1'}>Quick 1</button>
      <button id='quick2' onClick={=> @push '/quick2'}>Quick 2</button>
      <button id='quick3' onClick={=> @push '/quick3'}>Quick 3</button>
      <button id='quick4' onClick={=> @push '/quick4'}>Quick 4</button>
      <button id='quick5' onClick={=> @push '/quick5'}>Quick 5</button>
      <br />
      <div className='current-path'>{@state.path}</div>
    </div>

module.exports = LocationStoreComponent
