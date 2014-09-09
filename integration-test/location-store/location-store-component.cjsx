React = require 'react'
BlockRouting = require '../../src/mixins/BlockRouting'
LocationAttempt = require '../../src/mixins/LocationAttempt'

LocationStoreComponent = React.createClass
  displayName: 'LocationStoreComponent'

  mixins: [
    BlockRouting
    LocationAttempt
  ]

  contextTypes:
    router: React.PropTypes.object.isRequired

  getInitialState: ->
    path: @context.router.stores.location.getCurrentPath()
    blocked: false
    blockedId: false

  getDesiredPath: ->
    path = @refs.path.getDOMNode().value

  handlePush: ->
    @context.router.actions.transition @getDesiredPath()

  handleReplace: ->
    @context.router.actions.replace @getDesiredPath()

  handleGoBack: ->
    @context.router.actions.back()

  componentDidMount: ->
    @context.router.stores.location.addChangeListener @pathChanged

  componentWillUnmount: ->
    @context.router.stores.location.removeChangeListener @pathChanged

  pathChanged: ->
    @setState
      path: @context.router.stores.location.getCurrentPath()
      blocked: @context.router.stores.location.isBlocked()
      blockedId: @context.router.stores.location.isIdBlocked(@state.BlockRouting.blockId)

  push: (path) ->
    @context.router.actions.transition path

  asyncTransitions: ->
    @context.router.actions.transition '/asyncTransitions1'
    @context.router.actions.transition '/asyncTransitions2'
    setTimeout =>
      @context.router.actions.transition '/asyncTransitions4'
      @context.router.actions.transition '/asyncTransitions5'
    @context.router.actions.transition '/asyncTransitions3'
    setTimeout =>
      @context.router.actions.transition '/asyncTransitions6'

  render: ->
    attempt = null

    if @state.LocationAttempt.lastAttempt
      attempt =
        <div>
          Location Attempt
          <button id='continueAttempt' onClick={@continueLocationAttempt}>Continue?</button>
          <button id='dismissAttempt' onClick={@dismissLocationAttempt}>Dismiss?</button>
        </div>

    <div>
      {@props.children}
      <br />
      <input ref='path' />
      <br />
      <button id='push' onClick={@handlePush}>Push</button>
      <button id='replace' onClick={@handleReplace}>Replace</button>
      <button id='goback' onClick={@handleGoBack}>Go Back</button>
      <button id='toggleBlock' onClick={@toggleBlock}>{if @state.BlockRouting.blocked then 'Unblock' else 'Block'}</button>
      <br />
      <button id='quick1' onClick={=> @push '/quick1'}>Quick 1</button>
      <button id='quick2' onClick={=> @push '/quick2'}>Quick 2</button>
      <button id='quick3' onClick={=> @push '/quick3'}>Quick 3</button>
      <button id='quick4' onClick={=> @push '/quick4'}>Quick 4</button>
      <button id='quick5' onClick={=> @push '/quick5'}>Quick 5</button>
      <br />
      <button id='asyncTransitions' onClick={@asyncTransitions}>Async Transitions</button>
      <div>Current path: <span className='current-path'>{@state.path}</span></div>
      <div>
        Store blocked: <span className='store-blocked'>{@state.blocked.toString()}</span>&nbsp;
        [Expected id blocked: <span className='expected-id-blocked'>{@state.blockedId.toString()}</span>]
      </div>
      {attempt}
    </div>

module.exports = LocationStoreComponent
