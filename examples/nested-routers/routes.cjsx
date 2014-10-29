React = require 'react'
{Router, Routes, Route, NotFoundRoute, DefaultRoute} = require '../../src'

Home = require './home'

ApplicationRoutes = ->
  <Router location='history' rootPath='/nested-routers'>
    <Routes path='/' handler={require '../shell'}>
      <DefaultRoute handler={Home}/>
    </Routes>
  </Router>

module.exports = ApplicationRoutes
