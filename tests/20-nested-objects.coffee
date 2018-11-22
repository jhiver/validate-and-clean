{ check, validate } = require '../lib/index'

describe 'nested object', ->

  it 'should check lots of stuff', (done) ->

    object =
      person:
        identity:
          name: "John"
          surname: null

    schema =
      person: check().optional().schema(
        identity: check().required().schema(
          name: check().required().string()
          surname: check().required().string()
        )
      )

    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done("should have errors")
        unless errors.person.identity.surname is 'required' then return done("person.identity.surname should be required")
        return done()

    return null