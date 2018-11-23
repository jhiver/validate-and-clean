_     = require 'lodash'
email = require 'email-validator'
uuid  = require 'uuid'
IS_CHECK = uuid()


CHECKS =

  default: (val) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        obj[att] = val
      return Promise.resolve undefined

  email: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if email.validate String(obj[att])
        return Promise.resolve()
      else
        return Promise.resolve 'email'

  equals: (val) ->
    (att, obj, args...) ->
      if obj[att] is val
        return Promise.resolve undefined
      else
        return Promise.resolve 'equals'

  notEquals: (val) ->
    (att, obj, args...) ->
      if obj[att] isnt val
        return Promise.resolve undefined
      else
        return Promise.resolve 'notEquals'

  hasDigit: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[0-9]/
        return Promise.resolve undefined
      else
        return Promise.resolve 'hasDigit'

  hasLowerCase: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[a-z]/
        return Promise.resolve undefined
      else
        return Promise.resolve 'hasLowerCase'

  hasSpecial: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[^A-Za-z0-9]/
        return Promise.resolve undefined
      else
        return Promise.resolve 'hasSpecial'

  hasUpperCase: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[A-Z]/
        return Promise.resolve undefined
      else
        return Promise.resolve 'hasUpperCase'

  integer: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('integer')
      if Math.floor(Number(obj[att])) is Number(obj[att])
        return Promise.resolve undefined
      else
        return Promise.resolve 'integer'

  maxLen: (len) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].length <= len then return Promise.resolve undefined
      return Promise.resolve 'maxLen'

  maxVal: (val) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(obj[att])) is 'NaN' then return Promise.resolve 'maxVal'
      if Number(obj[att]) <= val then return Promise.resolve undefined
      return Promise.resolve 'maxVal'

  minLen: (len) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].length >= len then return Promise.resolve undefined
      return Promise.resolve 'minLen'

  minVal: (val) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(obj[att])) is 'NaN' then return Promise.resolve 'minVal'
      if Number(obj[att]) >= val then return Promise.resolve undefined
      return Promise.resolve 'minVal'

  number: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('number')
      obj[att] = Number obj[att]
      return Promise.resolve undefined

  optional: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        obj[att] = null
        return Promise.resolve null
      else
        return Promise.resolve undefined

  overwrite: (val) ->
    (att, obj, args...) ->
      obj[att] = val
      return Promise.resolve undefined

  pick: (attributes...) ->
    (att, obj, args...) ->
      allowed = {}
      _.each attributes, (att) -> allowed[att] = true
      _.each obj, (v, k) -> delete obj[k] unless allowed[k]
      return Promise.resolve undefined

  round: (decimals) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('integer')
      decimals or= 0
      obj[att] = Number(Math.round(obj[att]+'e'+decimals)+'e-'+decimals);
      return Promise.resolve undefined

  string: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      obj[att] = String obj[att]
      return Promise.resolve undefined

  trim: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      obj[att] = String(obj[att]).replace(/^\s+/, '').replace(/\s+$/, '')
      return Promise.resolve undefined

  uuid: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match /........-....-....-....-............/ then return Promise.resolve undefined
      return Promise.resolve 'uuid'

  isArray: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if _.isArray(obj[att]) then return Promise.resolve(undefined)
      return Promise.resolve('isArray')


  schema: (schema) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      unless _.isObject obj[att] then return Promise.resolve('schema')

      model = obj[att]
      return new Promise (resolve) ->
        validate model, schema, {}
          .then (err) ->
            unless err then return resolve undefined
            return resolve err


  each: (check) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      unless _.isObject obj[att] then return Promise.resolve('each')
      if _.size(obj[att]) is 0 then return Promise.resolve(undefined)

      unless check[IS_CHECK] then check = CreateCheck().schema(check)

      return new Promise (resolve) ->
        if _.isArray(obj[att])
          errors = []
        else
          errors = {}

        todo = _.size(obj[att])
        _.each obj[att], (item, item_name) ->
          model  = _: item
          schema = _: check
          validate model, schema, {}
            .then (err) ->
              if err then errors[item_name] = err._
              todo--
              if todo is 0
                if _.size(errors) then return resolve(errors)
                resolve(undefined)


CreateCheck = (args...) ->
  self = todo: []

  self[IS_CHECK] = true

  self.add = (args...) -> self.todo.push args

  _.each CHECKS, (check_generator, check_name) ->
    self[check_name] = (args...) ->
      self.add check_name, check_generator args...
      return self

  self._run = (index, att, model) ->
    index or= 0
    if self.todo.length is index then return Promise.resolve null
    return new Promise (resolve, reject) ->
      self.todo[index][1] att, model, args...
        .then (status) ->
          if status isnt undefined then return resolve status
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
        if error isnt null then errors[constraint_name] = error
        return validate(model, constraints, errors).then(resolve)


module.exports = CreateCheck
module.exports.check    = CreateCheck
module.exports.register = (checkname, check) -> CHECKS[checkname] = check
module.exports.validate = (model) ->
  with: (schema) ->
    unless schema[IS_CHECK] then schema = CreateCheck().schema(schema)
    schema.run '_', '_': model