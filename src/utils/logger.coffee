module.exports =
  log: (message) ->
    console.log message if DEBUG_ROUTING? and DEBUG_ROUTING

  warn: (message) ->
    console.warn message if DEBUG_ROUTING? and DEBUG_ROUTING

  error: (message) ->
    console.error message if DEBUG_ROUTING? and DEBUG_ROUTING
