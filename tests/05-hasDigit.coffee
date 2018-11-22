{ check, validate } = require '../lib/index'

describe 'hasDigit', ->

  it 'should error undefined', (done) ->
    schema = title: check().hasDigit()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().hasDigit()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error string without digits', (done) ->
    schema = title: check().hasDigit()
    object = title: "foo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string with digits', (done) ->
    schema = title: check().hasDigit()
    object = title: "foo12"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
