{ check, validate } = require '../lib/index'

describe 'boolean', ->

  it 'should be false', (done) ->
    schema = title: check().boolean()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if object.title is false
          return done()
        else
          return done("not true")
    return null

  it 'should be true', (done) ->
    schema = title: check().boolean()
    object = title: 1
    validate(object)
      .with(schema)
      .then (errors) ->
        if object.title is true
          return done()
        else
          return done("not true")
    return null
