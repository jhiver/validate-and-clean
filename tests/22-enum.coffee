{ check, validate } = require '../lib/index'

describe 'enum', ->

  it 'should be false', (done) ->
    schema = fruit: check().enum('apple', 'mango', 'banana')
    object = fruit: 'apple'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors
          return done("not true")
        else
          return done()
    return null

  it 'should be true', (done) ->
    schema = fruit: check().enum('apple', 'mango', 'banana')
    object = fruit: 'kiwi'
    validate(object)
      .with(schema)
      .then (errors) ->
        if errors
          return done()
        else
          return done("not true")
    return null
