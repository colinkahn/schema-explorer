APP.factory "Item", ["schemas", (schemas) ->

  uid    = 0
  getUID = -> uid++

  class Item
    constructor: (@id, @itemProp, @text) ->
      @elementId = @id.toLowerCase() + getUID()
      @children  = []

    appendItemProp: (id, itemProp, value) ->
      @children.push new Item id, itemProp, value

    isDataType: ->
      @id of schemas.datatypes

    getItemType: ->
      if @isDataType()
        schemas.datatypes[@id].url
      else
        schemas.types[@id].url

    getTag: ->
      @tag or if @isDataType() then "span" else "div"

    toJSON: ->
      id:       @id
      url:      @getItemType()
      tag:      @getTag()
      itemProp: @itemProp
      text:     @text
      children: @children

    toHTML: ->
      if @id is "root"
        element = $("<div/>")
      else
        json   = @toJSON()
        if @linkedResource
          element = $("<a href='#{@url or "#"}'/>")
        else
          element = $("<#{json.tag} itemtype='#{json.url}' id='#{@elementId}'/>")

        element.attr "itemscope", "" unless @isDataType() or @linkedResource
        element.attr "itemprop", json.itemProp if json.itemProp
        element.text json.text if json.text

      for child in @children
        element.append child.toHTML()

      return element
]
