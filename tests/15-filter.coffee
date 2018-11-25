{ check, validate } = require '../lib/index'

describe 'filter', ->

  object = title: "extra", extra: "bar"

  it 'should validate', (done) ->
    schema =
      _: check().filter('title', 'description', 'body')
      title: check().optional()

    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not have errors")
        done()
    return null

  it 'should have title', (done) ->
    if object.title?
      return done()
    else
      return done('no title?')

  it 'should not have extra', (done) ->
    if object.extra?
      return done("should not be here")
    else
      return done('')

    return null
