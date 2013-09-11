###
  Expects to be constructed with an array of properties
  and an array of instantiated bases
###
APP.factory "Schema", ->
  class Schema
    constructor: ->

    # Traverses up the prototype chain, getting all properties
    getInheritedProperties: (properties = []) ->
      properties = @properties?.slice 0
      super properties
