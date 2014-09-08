logger = (condition) ->
  log: (message) ->
    console.log message if condition

  warn: (message) ->
    console.warn message if condition

  error: (message) ->
    console.error message if condition

module.exports =
  debug: logger DEBUG_ROUTING? and DEBUG_ROUTING
  development: logger process.env.NODE_ENV == 'production'
