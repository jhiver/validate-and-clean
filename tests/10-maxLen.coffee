{ check, validate } = require '../lib/index'

describe 'maxLen', ->

  it 'should error undefined', (done) ->
    schema = title: check().maxLen(3)
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().maxLen(3)
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error things that do not have a length', (done) ->
    schema = title: check().maxLen(3)
    object = title: 12
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error string too long', (done) ->
    schema = title: check().maxLen(3)
    object = title: "fooo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string not too long', (done) ->
    schema = title: check().maxLen(3)
    object = title: "foo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
