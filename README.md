# validate-nosuck
An async-friendly nodejs object validation library which doesn't suck


# sorry...

The samples below are written in coffeescript, cause it's what i like to write.
You don't need coffeescript to use this module though.


# the simple stuff

first say you have a structure like this:

    person =
      name: "John"
      surname: "Doe"
      age: 23


You'd write a schema as follows to validate it:

    nosuck = require 'validate-nosuck'
    check = nosuck.check
    schema =
      name: check().string().minLen(3).maxLen(50)
      surname: check().string().minLen(3).maxLen(50)
      age: check().optional().number()


You'd then validate your object like so:

    nosuck.validate(person).against(schema).then(errors) ->
      if (errors)
        console.log "validation failed!"
        console.log errors
      else
        console.log "person looks ok."
        console.log errors


Up until then, you're probably saying to yourself. Meh. Yet another validation
library that I will waste my time on.

# but wait, you can write your own checks!

Say we want to write a piece of code that capitalises an attribute:

    nosuck = require './lib/index'
    nosuck.register 'allcaps', ->
      (attribute, object) ->
        if object[attribute] is null or object[attribute] is undefined then return Promise.resolve(nosuck.FAIL)
        object[attribute] = String(object[attribute]).toUpperCase()
        return Promise.resolve(nosuck.PASS)

A few important things to note here.

* Your check can alter the model / object which you validate!
* If your check resolves `undefined`, the check will pass and go to the next check in the chain
* If your check resolves `null`, the check will pass unconditionnally (stop the chain for this attribute)
* If your check resolves anything else, it will be considered an error
* It's using Promises so we can transparently do some cool async stuff (keep reading...)

Our schema becomes:

    schema =
      name: check().string().minLen(3).maxLen(50)
      surname: check().string().minLen(3).maxLen(50).allcaps()
      age: check().optional().number()


# but wait, the checks can be asynchronous!

Say our object comes with an id, and we wanna make sure it exists in the database.

Because we're using promises, we could write a custom check like so:

    nosuck.register 'isValidUser', ->
      (attribute, object) ->
        user_id = object[attribute]
        if user_id is null or user_id is undefined then return Promise.resolve(nosuck.FAIL)
        return new Promise (resolve, reject) ->
          storage.getUserById user_id, (err, res) ->
            if err then return reject(res)
            if res then return resolve(nosuck.PASS)
            return resolve(nosuck.FAIL)

And then our schema becomes:

    schema =
      id: check().integer().minVal(1).isValidUser()
      name: check().string().minLen(3).maxLen(50)
      surname: check().string().minLen(3).maxLen(50)
      age: check().optional().number()

