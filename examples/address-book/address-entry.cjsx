React = require 'react'
AddressStore = require './store'

Entry = React.createClass
  displayName: 'Entry'

  contextTypes:
    store: React.PropTypes.object

  getInitialState: ->
    entry: @context.store.getEntry @props.params.entryId

  componentWillReceiveProps: (props) ->
    @setState
      entry: @context.store.getEntry props.params.entryId

  render: ->
    <div className='address-entry-details'>
      <h3>Details for: <span className='address-entry-name'>{@state.entry.name}</span> [{@props.params.entryId}]</h3>
      <dl>
        <dt>Twitter</dt>
        <dd className='address-entry-twitter'>{@state.entry.twitter}</dd>
      </dl>
    </div>

module.exports = Entry
