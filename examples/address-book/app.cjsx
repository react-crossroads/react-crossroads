React = require 'react'
Routes = require './routes'

# Enable Chrome Dev Tools
global.React = React

React.renderComponent <Routes />, document.body
