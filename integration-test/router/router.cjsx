React = require 'react'
Router = require '../../src/components/Router'
Route = require '../../src/components/Route'
Routes = require '../../src/components/Routes'
DefaultRoute = require '../../src/components/DefaultRoute'

Placeholder = React.createClass
  displayName: 'Placeholder'
  render: ->
    <div>
      Placeholder {@props.name}
      <div style={'margin-left': 10}>
        <this.props.activeRouteHandler />
      </div>
    </div>

React.renderComponent(
  <Router>
    <Routes path='/' handler={Placeholder} handlerProps={name: 'home'}>
      <Route name='test' handler={Placeholder} handlerProps={name: 'test'} />
      <Routes path='blah' handler={Placeholder} handlerProps={name: 'blah'} >
        <DefaultRoute name='blahtest' handler={Placeholder} handlerProps={name: 'blah default'} />
        <Route name='blahchild' path="{id}/{action}:?other:" handler={Placeholder} handlerProps={name: 'blah id/action'} />
      </Routes>
    </Routes>
  </Router>
  , document.body
)
