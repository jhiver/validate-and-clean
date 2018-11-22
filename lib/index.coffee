_     = require 'lodash'
email = require 'email-validator'


CHECKS =

  default: (val) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        obj[att] = val
      return Promise.resolve 'next'

  email: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined then return Promise.resolve 'email'
      if email.validate String(obj[att])
        return Promise.resolve 'next'
      else
        return Promise.resolve 'email'

  equals: (val) ->
    (att, obj, args...) ->
      if obj[att] is val
        return Promise.resolve 'next'
      else
        return Promise.resolve 'equals'

  notEquals: (val) ->
    (att, obj, args...) ->
      if obj[att] isnt val
        return Promise.resolve 'next'
      else
        return Promise.resolve 'notEquals'

  hasDigit: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'hasDigit'
      if obj[att].match /[0-9]/
        return Promise.resolve 'next'
      else
        return Promise.resolve 'hasDigit'

  hasLowerCase: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'hasLowerCase'
      if obj[att].match /[a-z]/
        return Promise.resolve 'next'
      else
        return Promise.resolve 'hasLowerCase'

  hasSpecial: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'hasSpecial'
      if obj[att].match /[^A-Za-z0-9]/
        return Promise.resolve 'next'
      else
        return Promise.resolve 'hasSpecial'

  hasUpperCase: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'hasUpperCase'
      if obj[att].match /[A-Z]/
        return Promise.resolve 'next'
      else
        return Promise.resolve 'hasUpperCase'

  maxLen: (len) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'maxLen'
      if obj[att].length <= len then return Promise.resolve 'next'
      return Promise.resolve 'maxLen'

  maxVal: (val) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'maxVal'
      if String(Number(obj[att])) is 'NaN' then return Promise.resolve 'maxVal'
      if Number(obj[att]) <= val then return Promise.resolve 'next'
      return Promise.resolve 'maxVal'

  minLen: (len) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'minLen'
      if obj[att].length >= len then return Promise.resolve 'next'
      return Promise.resolve 'minLen'

  minVal: (val) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'minVal'
      if String(Number(obj[att])) is 'NaN' then return Promise.resolve 'minVal'
      if Number(obj[att]) >= val then return Promise.resolve 'next'
      return Promise.resolve 'minVal'

  number: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'number'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('number')
      obj[att] = Number obj[att]
      return Promise.resolve 'next'

  optional: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        obj[att] = null
        return Promise.resolve 'pass'
      else
        return Promise.resolve 'next'

  required: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'required'
      else
        return Promise.resolve 'next'

  set: (val) ->
    (att, obj, args...) ->
      obj[att] = val
      return Promise.resolve 'next'

  string: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        return Promise.resolve 'string'
      obj[att] = String obj[att]
      return Promise.resolve 'next'

  trim: ->
    (att, obj, args...) ->
      if obj[att] == null then obj[att] = ''
      return Promise.resolve 'next'

  uuid: ->
    (att, obj, args...) ->
      if String(obj[att]).match /........-....-....-....-............/ then return Promise.resolve 'next'
      return Promise.resolve 'uuid'



CreateCheck = (args...) ->
  self = todo: []

  self.add = (args...) -> self.todo.push args

  _.each CHECKS, (check_generator, check_name) ->
    self[check_name] = (args...) ->
      self.add check_name, check_generator args...
      return self

  self._run = (index, att, model) ->
    index or= 0
    if self.todo.length is index then return Promise.resolve 'pass'
    return new Promise (resolve, reject) ->
      self.todo[index][1] att, model, args...
        .then (status) ->
          if status isnt 'next' then return resolve status
          self._run(index + 1, att, model).then(resolve)

  self.run = (att, model) ->
    return self._run 0, att, model

  return self



validate = (model, constraints, errors) ->
  constraints = _.clone constraints
  constraint_names = _.keys constraints
  if constraint_names.length is 0
    if _.isEmpty(errors) then return Promise.resolve null
    return Promise.resolve errors

  constraint_name = constraint_names.shift()
  constraint = constraints[constraint_name]
  delete constraints[constraint_name]

  return new Promise (resolve) ->
    constraint.run constraint_name, model
      .then (error) ->
        if error isnt 'pass'
          errors[constraint_name] = error
          resolve(errors)
        else
          validate(model, constraints, errors).then(resolve)



module.exports.check    = CreateCheck
module.exports.register = (checkname, check) -> CHECKS[checkname] = check
module.exports.validate = (model) ->
  with: (constraints) ->
    validate model, constraints, {}