{ check, validate } = require '../lib/index'

describe 'hasSpecial', ->

  it 'should error undefined', (done) ->
    schema = title: check().hasSpecial()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().hasSpecial()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error string without special', (done) ->
    schema = title: check().hasSpecial()
    object = title: "foo123"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string with special', (done) ->
    schema = title: check().hasSpecial()
    object = title: "foo*123"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
