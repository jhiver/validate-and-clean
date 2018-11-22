{ check, validate } = require '../lib/index'

describe 'numbers list', ->

  it 'should check numbers', (done) ->
    object = numbers: [12, 22, 7, 36]
    schema = numbers: check().required().isArray().each(
      check().required().number()
    )
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        return done()

  it 'should fail not numbers', (done) ->
    object = numbers: [12, "foo", 7, "36", null]
    schema = numbers: check().required().isArray().each(
      check().number()
    )
    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done("should have errors")
        unless errors.numbers[1] then return done("should have an error for index 1 item")
        unless errors.numbers[4] then return done("should have an error for index 4 item")
        return done()

    return null