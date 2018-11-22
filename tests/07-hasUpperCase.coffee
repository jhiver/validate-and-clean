{ check, validate } = require '../lib/index'

describe 'hasUpperCase', ->

  it 'should error undefined', (done) ->
    schema = title: check().hasUpperCase()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().hasUpperCase()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error string without uppercase', (done) ->
    schema = title: check().hasUpperCase()
    object = title: "foo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string with uppercase', (done) ->
    schema = title: check().hasUpperCase()
    object = title: "fOo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
