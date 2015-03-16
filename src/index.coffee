_ = require 'lodash'

indexify = (indexes) ->

  data = _.zipObject(
    _.map indexes, (index) -> [index.key, {}]
  )

  forall = (obj) ->
    obj = if _.isArray(obj) then _.uniq(obj) else [ obj ]
    (fn) -> _.each(obj, fn)

  add: (obj) ->
    _.each indexes, (index) ->
      forall(index.extract(obj)) (key) ->
        if index.unique
          data[index.key][key] = obj
        else
          data[index.key][key] = (data[index.key][key] || [])
          data[index.key][key].push(obj)

  remove: (obj) ->
    _.each indexes, (index) ->
      forall(index.extract(obj)) (key) ->
        if index.unique
          delete data[index.key][key]
        else
          _.remove (data[index.key][key] || []), (value) -> value == obj

  by: _.zipObject(
    _.map indexes, (index) -> [
      index.key, 
      (keys...) ->
        if index.unique
          if keys.length != 1 then throw new Error('Expecting only one key for unique indexes')
          data[index.key][keys[0]]
        else
          if keys.length == 0 then throw new Error('Expecting at least one key for non-unique indexes')
          start = data[index.key][keys[0]]
          _.reduce(
            _.tail(keys),
            (acc, key) ->
              _.filter acc, (obj) -> _.contains(index.extract(obj), key),
            start
          )
    ]
  )

module.exports = indexify

