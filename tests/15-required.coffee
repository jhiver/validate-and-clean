{ check, validate } = require '../lib/index'

describe 'required', ->

  it 'should not pass undefined', (done) ->
    schema = title: check().required()
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        done("should not pass")
    return null

  it 'should not pass null', (done) ->
    schema = title: check().required()
    object = title: null
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done()
        done("should not pass")
    return null

  it 'should pass 0', (done) ->
    schema = title: check().required()
    object = title: 'dfgsdfjklgb'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null

  it 'should pass random garbage', (done) ->
    schema = title: check().required()
    object = title: 'dfgsdfjklgb'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null