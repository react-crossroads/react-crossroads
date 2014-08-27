React = require 'react'
Router = require '../../src/components/Router'
Route = require '../../src/components/Route'
Routes = require '../../src/components/Routes'
DefaultRoute = require '../../src/components/DefaultRoute'

global.React = React

buildPlaceholder = ->
  Placeholder = React.createClass
    displayName: 'Placeholder'
    componentWillMount: ->
      console.log "Will Mount Placeholder: #{@props.name}"
    componentWillUnmount: ->
      console.log "Will Unmount Placeholder: #{@props.name}"
    componentWillReceiveProps: (nextProps) ->
      console.log "Will Receive Props Placeholder: #{@props.name}"
    render: ->
      <div>
        Placeholder {@props.name} Params: {JSON.stringify @props.params}
        <div style={'margin-left': 10}>
          <this.props.activeRouteHandler />
        </div>
      </div>

HomePlaceholder = buildPlaceholder()
TestPlaceholder = buildPlaceholder()
BlahParentPlaceholder = buildPlaceholder()
BlahDefaultPlaceholder = buildPlaceholder()
BlahActionPlaceholder = buildPlaceholder()

React.renderComponent(
  <Router>
    <Routes path='/' handler={HomePlaceholder} handlerProps={name: 'home'}>
      <Route name='test' handler={TestPlaceholder} handlerProps={name: 'test'} />
      <Routes path='blah' handler={BlahParentPlaceholder} handlerProps={name: 'blah'} >
        <DefaultRoute name='blahtest' handler={BlahDefaultPlaceholder} handlerProps={name: 'blah default'} />
        <Route name='blahchild' path="{id}/{action}:?other:" handler={BlahActionPlaceholder} handlerProps={name: 'blah id/action'} />
      </Routes>
      <Routes path='hehe' />
    </Routes>
  </Router>
  , document.body
)
