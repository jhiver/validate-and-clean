_        = require 'lodash'

uuid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c == 'x' then r else r & 0x3 | 0x8
    v.toString 16

IS_CHECK = uuid()

# taken from https://github.com/manishsaraan/email-validator/blob/master/index.js
EMAIL_RE = /^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+$/;

# taken from - https://gist.github.com/dperini/729294
RE_URL = new RegExp(
  "^" +
    # protocol identifier (optional)
    # short syntax # still required
    "(?:(?:(?:https?|ftp):)?\\/\\/)" +
    # user:pass BasicAuth (optional)
    "(?:\\S+(?::\\S*)?@)?" +
    "(?:" +
      # IP address dotted notation octets
      # excludes loopback network 0.0.0.0
      # excludes reserved space >= 224.0.0.0
      # excludes network & broacast addresses
      # (first & last IP address of each class)
      "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" +
      "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" +
      "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" +
    "|" +
      # host & domain names, may end with dot
      # can be replaced by a shortest alternative
      # (?![-_])(?:[-\\w\\u00a1-\\uffff]{0,63}[^-_]\\.)+
      "(?:" +
        "(?:" +
          "[a-z0-9\\u00a1-\\uffff]" +
          "[a-z0-9\\u00a1-\\uffff_-]{0,62}" +
        ")?" +
        "[a-z0-9\\u00a1-\\uffff]\\." +
      ")+" +
      # TLD identifier name, may end with dot
      "(?:[a-z\\u00a1-\\uffff]{2,}\\.?)" +
    ")" +
    # port number (optional)
    "(?::\\d{2,5})?" +
    # resource path (optional)
    "(?:[/?#]\\S*)?" +
  "$", "i"
);


CHECKS =

  sip: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match(/^\+?(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))(:\d+)?$/)
        return Promise.resolve()
      else
        return Promise.resolve('sip')

  url: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match(RE_URL)
        return Promise.resolve()
      else
        return Promise.resolve('url')

  phone: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match /^\+?\d{4,15}$/ then return Promise.resolve()
      return Promise.resolve('phone')

  enum: (values...) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      for allowed in values
        if obj[att] is allowed then return Promise.resolve()
      return Promise.resolve('enum')

  filter: (attributes...) ->
    (att, obj, args...) ->
      allowed = {}
      _.each attributes, (k) -> allowed[k] = true
      _.each obj, (v, k) -> delete obj[k] unless allowed[k]
      return Promise.resolve()

  boolean: ->
    (att, obj, args...) ->
      obj[att] = Boolean obj[att]
      return Promise.resolve()

  default: (val) ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        obj[att] = val
      return Promise.resolve()

  email: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'

      email = String obj[att]
      if email.length > 254 then return Promise.resolve('email')
      unless EMAIL_RE.test(email) then return Promise.resolve('email')

      parts = email.split("@")
      if(parts[0].length>64) then return Promise.resolve('email')

      domainParts = parts[1].split(".");
      if domainParts.some (part) -> part.length>63
        return Promise.resolve('email')

      return Promise.resolve()


  equals: (val) ->
    (att, obj, args...) ->
      if obj[att] is val
        return Promise.resolve()
      else
        return Promise.resolve 'equals'


  notEquals: (val) ->
    (att, obj, args...) ->
      if obj[att] isnt val
        return Promise.resolve()
      else
        return Promise.resolve 'notEquals'


  hasDigit: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[0-9]/
        return Promise.resolve()
      else
        return Promise.resolve 'hasDigit'

  hasLowerCase: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[a-z]/
        return Promise.resolve()
      else
        return Promise.resolve 'hasLowerCase'

  hasSpecial: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[^A-Za-z0-9]/
        return Promise.resolve()
      else
        return Promise.resolve 'hasSpecial'

  hasUpperCase: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].match /[A-Z]/
        return Promise.resolve()
      else
        return Promise.resolve 'hasUpperCase'

  integer: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('integer')
      if Math.floor(Number(obj[att])) is Number(obj[att])
        return Promise.resolve()
      else
        return Promise.resolve 'integer'

  like: (re) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match(re)
        return Promise.resolve()
      else
        return Promise.resolve 'like'

  notLike: (re) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match(re)
        return Promise.resolve 'notLike'
      else
        return Promise.resolve()

  maxLen: (len) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].length <= len then return Promise.resolve()
      return Promise.resolve 'maxLen'

  maxVal: (val) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(obj[att])) is 'NaN' then return Promise.resolve 'maxVal'
      if Number(obj[att]) <= val then return Promise.resolve()
      return Promise.resolve 'maxVal'

  minLen: (len) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if obj[att].length >= len then return Promise.resolve()
      return Promise.resolve 'minLen'

  minVal: (val) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(obj[att])) is 'NaN' then return Promise.resolve 'minVal'
      if Number(obj[att]) >= val then return Promise.resolve()
      return Promise.resolve 'minVal'

  number: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('number')
      obj[att] = Number obj[att]
      return Promise.resolve()

  required: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      return Promise.resolve()

  optional: ->
    (att, obj, args...) ->
      if obj[att] is null or obj[att] is undefined
        obj[att] = null
        return Promise.resolve null
      else
        return Promise.resolve()

  overwrite: (val) ->
    (att, obj, args...) ->
      obj[att] = val
      return Promise.resolve()

  pick: (attributes...) ->
    (att, obj, args...) ->
      allowed = {}
      _.each attributes, (att) -> allowed[att] = true
      _.each obj, (v, k) -> delete obj[k] unless allowed[k]
      return Promise.resolve()

  round: (decimals) ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(Number(String(obj[att]))) is 'NaN' then return Promise.resolve('integer')
      decimals or= 0
      obj[att] = Number(Math.round(obj[att]+'e'+decimals)+'e-'+decimals);
      return Promise.resolve()

  string: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      obj[att] = String obj[att]
      return Promise.resolve()

  trim: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      obj[att] = String(obj[att]).replace(/^\s+/, '').replace(/\s+$/, '')
      return Promise.resolve()

  uuid: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if String(obj[att]).match /........-....-....-....-............/ then return Promise.resolve()
      return Promise.resolve 'uuid'

  array: ->
    (att, obj, args...) ->
      if obj[att] is null then return Promise.resolve 'required'
      if obj[att] is undefined then return Promise.resolve 'required'
      if _.isArray(obj[att]) then return Promise.resolve(undefined)
      return Promise.resolve('array')


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