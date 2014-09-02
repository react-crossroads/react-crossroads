React = require 'react'
AddressStore = require './store'
{Link} = require '../../src'

AddressBook = React.createClass
  displayName: 'AddressBook'
  getInitialState: ->
    entries: AddressStore.getEntries()
  render: ->
    entries = @state.entries.map (item, entryId) ->
      <li key={entryId}>
        <Link to='address-entry' params={ {entryId} } >{item.name}</Link>
      </li>

    <div>
      <h2>Address Book Example</h2>
      <ul>
        {entries}
      </ul>
      <this.props.activeRouteHandler />
    </div>

module.exports = AddressBook
