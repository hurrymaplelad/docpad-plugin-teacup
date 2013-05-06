---
tag: test
---
{renderable, article, h1, input} = require 'teacup'
{line} = require '../partials/helpers'

module.exports = ->
  article ->
    h1 '.greeting', 'Hello'
    input name: 'name'
    line()