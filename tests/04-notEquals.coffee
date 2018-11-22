{ check, validate } = require '../lib/index'

describe 'equals', ->

  it 'should not compare undefined = undefined', (done) ->
    schema = title: check().notEquals(undefined)
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done()
    return null

  it 'should not compare null != undefined', (done) ->
    schema = title: check().notEquals(undefined)
    object = title: null
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        return done()
    return null

  it 'should not compare foo = foo', (done) ->
    schema = title: check().notEquals('foo')
    object = title: 'foo'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
    return null

  it 'should not compare foo != bar', (done) ->
    schema = title: check().notEquals('foo')
    object = title: 'bar'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null