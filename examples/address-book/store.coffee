{EventEmitter} = require 'events'

class AddressStore extends EventEmitter
  constructor: ->
    @addresses = [
      name: 'Matt Smith'
      twitter: '@mtscout6'
     ,
      name: 'Corey Kaylor'
      twitter: '@katokay'
     ,
      name: 'Jeremy Miller'
      twitter: '@jeremydmiller'
     ,
      name: 'Bob Pace'
      twitter: '@bob_pace'
    ]

  getEntries: => @addresses

  getEntry: (id) => @addresses[id]

module.exports = AddressStore
