_ = require 'lodash'

indexify = (indexes) ->

  data = _.zipObject(
    _.map indexes, (index) -> [index.key, {}]
  )

  add: (obj) ->
    _.each indexes, (index) ->
      key = index.extract(obj)
      if index.unique 
        data[index.key][key] = obj 
      else
        data[index.key][key] = (data[index.key][key] || [])
        data[index.key][key].push(obj)

  remove: (obj) ->
    _.each indexes, (index) ->
      key = index.extract(obj)
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

