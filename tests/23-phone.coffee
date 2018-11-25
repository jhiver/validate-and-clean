{ check, validate } = require '../lib/index'

describe 'phone', ->

  it 'should be false', (done) ->
    schema = fruit: check().phone()
    object = fruit: '+123'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors
          return done()
        else
          return done("not true")
    return null

  it 'should be true', (done) ->
    schema = fruit: check().phone()
    object = fruit: '+123456789'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors
          return done("not true")
        else
          return done()
    return null
