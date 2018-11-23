{ check, validate } = require '../lib/index'

describe 'nested array objects', ->

  it 'should check lots of stuff', (done) ->

    object =
      persons: [
        { "name": "John", "surname": "Doe", "age": 12 }
        { "name": "John", "surname": "Doe", "age": null }
        { "name": "John", "surname": "Doe", "age": 7 }
        { "name": "John", "surname": null, "age": 12 }
      ]

    schema =
      persons: check().isArray().each(
        name: check().string()
        surname: check().string()
        age: check().number().minVal(10)
      )

    validate(object)
      .with(schema)
      .then (errors) ->
        unless errors then return done("should have errors")
        unless errors.persons[3].surname is 'required' then return done("persons.3.surname should be required")
        unless errors.persons[1].age is 'required' then return done("persons.1.age should be required")
        unless errors.persons[2].age is 'minVal' then return done("persons.2.age should be required")
        return done()

    return null