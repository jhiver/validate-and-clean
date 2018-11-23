{ check, validate } = require '../lib/index'

describe 'optional', ->

  it 'should pass undefined', (done) ->
    schema = title: check().optional()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null

  it 'should pass null', (done) ->
    schema = title: check().optional()
    object = title: null
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null

  it 'should pass random garbage', (done) ->
    schema = title: check().optional()
    object = title: 'dfgsdfjklgb'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null


  it 'should still pass undefined', (done) ->
    schema = title: check().optional()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null

  it 'should still pass null', (done) ->
    schema = title: check().optional()
    object = title: null
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null

  it 'should still pass random garbage', (done) ->
    schema = title: check().optional()
    object = title: 'dfgsdfjklgb'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null
