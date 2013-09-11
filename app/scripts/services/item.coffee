APP.factory "Item", ->
  class Item
    constructor: (@id, @itemProp, @text) ->
      @children = []

    appendItemProp: (id, itemProp, value) ->
      @children.push new Item id, itemProp, value
