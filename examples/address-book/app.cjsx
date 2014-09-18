require '../style.css'

React = require 'react'
Routes = require './routes'

AddressBookStore = require './store'

context =
  store: new AddressBookStore

# Enable Chrome Dev Tools
global.React = React

React.renderComponent React.withContext(context, -> <Routes />), document.body
