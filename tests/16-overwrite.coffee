{ check, validate } = require '../lib/index'

describe 'overwrite', ->

  it 'should overwrite', (done) ->
    schema = title: check().overwrite('foo')
    object = title: undefined
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors then return done("should not error")
        if object.title isnt "foo" then return ("should have overwritten")
        done()
    return null