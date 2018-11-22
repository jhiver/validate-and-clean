{ check, validate } = require '../lib/index'

describe 'equals', ->

  it 'should compare undefined = undefined', (done) ->
    schema = title: check().equals(undefined)
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done "should not have errors"
        return done()

  it 'should compare null != undefined', (done) ->
    schema = title: check().equals(undefined)
    object = title: null
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")

  it 'should compare foo = foo', (done) ->
    schema = title: check().equals('foo')
    object = title: 'foo'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done "should not have errors"
        return done()

  it 'should compare foo != bar', (done) ->
    schema = title: check().equals('foo')
    object = title: 'bar'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        return done("should have errors")
