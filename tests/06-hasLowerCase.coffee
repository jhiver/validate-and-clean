{ check, validate } = require '../lib/index'

describe 'hasLowerCase', ->

  it 'should error undefined', (done) ->
    schema = title: check().hasLowerCase()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().hasLowerCase()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error string without lowercase', (done) ->
    schema = title: check().hasLowerCase()
    object = title: "FOO"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string with lowercase', (done) ->
    schema = title: check().hasLowerCase()
    object = title: "FoO"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
