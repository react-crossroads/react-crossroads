React = require 'react'
AddressStore = require './store'

Entry = React.createClass
  displayName: 'Entry'

  getInitialState: ->
    entry: AddressStore.getEntry @props.params.entryId

  componentWillReceiveProps: (props) ->
    @setState
      entry: AddressStore.getEntry props.params.entryId

  render: ->
    <div>
      <h3>Details for: {@state.entry.name} [{@props.params.entryId}]</h3>
      <dl>
        <dt>Twitter</dt>
        <dd>{@state.entry.twitter}</dd>
      </dl>
    </div>

module.exports = Entry
