{ check, validate } = require '../lib/index'

describe 'email', ->
  schema = email: check().email()

  it 'should fail when null', (done) ->
    object = email: null
    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done('errors should not be null')
        if errors['email'] is 'email' then return done()
        return done("unexpected errors object #{JSON.stringify(errors)}")
    return null

  it 'should fail when undefined', (done) ->
    object = email: {}
    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done('errors should not be null')
        if errors['email'] is 'email' then return done()
        return done("unexpected errors object #{JSON.stringify(errors)}")
    return null

  it 'should fail when 0', (done) ->
    object = email: 0
    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done('errors should not be null')
        if errors['email'] is 'email' then return done()
        return done("unexpected errors object #{JSON.stringify(errors)}")
    return null

  it 'should fail when random garbage', (done) ->
    object = email: "sdfsdfsdfsd"
    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done('errors should not be null')
        if errors['email'] is 'email' then return done()
        return done("unexpected errors object #{JSON.stringify(errors)}")
    return null

  it 'should pass when looks like an email', (done) ->
    object = email: 'example@example.blue'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        return done()
    return null
