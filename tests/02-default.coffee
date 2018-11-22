{ check, validate } = require '../lib/index'


describe 'default', ->
  schema = title: check().default('test')
  it 'should assign when null', (done) ->
    object = title: null
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done('errors should be null')
        if object.title is 'test' then return done()
        return done("object.title isnt test")
    return null

  it 'should assign when undefined', (done) ->
    object = {}
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done('errors should be null')
        if object.title is 'test' then return done()
        return done("object.title isnt test")
    return null

  it 'should not assign when 0', (done) ->
    object = { title: 0 }
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done('errors should be null')
        if object.title is 0 then return done()
        return done("object.title isnt 0")
    return null
