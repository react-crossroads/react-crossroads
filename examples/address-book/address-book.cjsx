React = require 'react'
AddressStore = require './store'

AddressBook = React.createClass
  displayName: 'AddressBook'
  getInitialState: ->
    entries: AddressStore.getEntries()
  render: ->
    entries = @state.entries.map (item, index) ->
      <li key={index}><a href="#/#{index}">{item.name}</a></li>

    <div>
      <h2>Address Book Example</h2>
      <ul>
        {entries}
      </ul>
      <this.props.activeRouteHandler />
    </div>

module.exports = AddressBook
