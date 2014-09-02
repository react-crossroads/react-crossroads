require 'mocha'
chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
_ = require 'lodash'

{expect} = chai
should = chai.should()
chai.use(sinonChai)

_.extend global, {_, expect, should, sinon}

require './components'
require './dispatcher/RoutingDispatcher'
require './locations/NamedLocations'
