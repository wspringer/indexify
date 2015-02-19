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
      (key) -> data[index.key][key]
    ]
  )

module.exports = indexify

