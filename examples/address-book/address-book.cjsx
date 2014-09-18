React = require 'react'
AddressStore = require './store'
{Link} = require '../../src'

AddressBook = React.createClass
  displayName: 'AddressBook'

  contextTypes:
    store: React.PropTypes.object

  getInitialState: ->
    entries: @context.store.getEntries()

  render: ->
    entries = @state.entries.map (item, entryId) ->
      <li className='address-entry-item' key={entryId}>
        <Link className='address-entry-link' to='address-entry' params={ {entryId} } >{item.name}</Link>
      </li>

    <div>
      <h2>Address Book Example</h2>
      <ul className='address-entry-list'>
        {entries}
      </ul>
      <@props.activeRouteHandler />
    </div>

module.exports = AddressBook
