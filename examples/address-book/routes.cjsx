React = require 'react'
{Router, Routes, Route} = require '../../src'

ApplicationRoutes = ->
  <Router location='hash'>
    <Routes handler={require '../shell'}>
      <Routes path='/' handler={require './address-book'}>
        <Route path='{entryId}' handler={require './address-entry'} />
      </Routes>
    </Routes>
  </Router>

module.exports = ApplicationRoutes
