{renderable, article, h1, input} = require 'teacup'

module.exports = ->
  article ->
    h1 '.greeting', 'Hello'
    input name: 'name'