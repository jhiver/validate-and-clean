{ check, validate } = require '../lib/index'

describe 'uuid', ->

  it 'should error undefined', (done) ->
    schema = title: check().uuid()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().uuid()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error things that are not uuid', (done) ->
    schema = title: check().uuid()
    object = title: "foo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string which are uuid', (done) ->
    schema = title: check().uuid()
    object = title: "c7ca1b64-ee42-11e8-9537-e0d55e417770"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
