React = require 'react'
{Router, Routes, Route} = require '../../src'

ApplicationRoutes = ->
  <Router location='history' initialPath='/address-book'>
    <Routes handler={require '../shell'}>
      <Routes name='address-book' path='/' handler={require './address-book'}>
        <Route name='address-entry' path='{entryId}' handler={require './address-entry'} />
      </Routes>
    </Routes>
  </Router>

module.exports = ApplicationRoutes
