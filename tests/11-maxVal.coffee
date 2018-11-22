{ check, validate } = require '../lib/index'

describe 'maxVal', ->

  it 'should error undefined', (done) ->
    schema = title: check().maxVal(3)
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error null', (done) ->
    schema = title: check().maxVal(3)
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error things that are not numeric', (done) ->
    schema = title: check().maxVal(3)
    object = title: "foo"
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should error string too big', (done) ->
    schema = title: check().maxVal(3)
    object = title: 4
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should pass string not too big', (done) ->
    schema = title: check().maxVal(3)
    object = title: 3
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should have passed")
        return done()
    return null
