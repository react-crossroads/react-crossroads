React = require 'react'
{Router, Routes, Route, NotFoundRoute} = require '../../src'

ApplicationRoutes = ->
  <Router location='history' rootPath='/address-book'>
    <Routes path='/' handler={require '../shell'}>
      <Routes name='address-book' path='' handler={require './address-book'}>
        <Route name='address-entry' path='{entryId}' handler={require './address-entry'} />
      </Routes>
      <NotFoundRoute handler={require './not-found'} />
    </Routes>
  </Router>

module.exports = ApplicationRoutes
