APP.controller "HomeController", ($scope) ->
  $scope.msg = "MicroData Api Editor"
  $scope.schemas = [
      name:    "/Map"
      types:   ["/Map/Overworld", "/Map/Dungeon"]
      props:   ["a:map-link"]
      children: []
      schemas: [
          name:    "/Tile"
          types:   ["/Tile/Rock", "/Tile/Tree", "/Tile/Water", "/Tile/Cave"]
          props:   ["img:tile-piece", "a:map-link", "coords"]
          children: []
          schemas: []
      ]
    ]

  $scope.root =
    name: "Root"
    children: []
    schemas:  $scope.schemas

  $scope.addSchema = (schema, parent = $scope.root) ->
    parent.children.push angular.copy schema

  extractPropertyTagAndName = (propertyName) ->
    [tag, name] = propertyName.split ":"
    if not name
      name = tag
      tag  = "span"

    return [tag, name]

  $scope.parseProperty = (propertyName) ->
    [tag, name] = extractPropertyTagAndName propertyName

    switch tag
      when "a"
        ["href", "rel", "text"]
      when "img"
        ["src", "alt"]
      when "span"
        ["text"]

  $scope.removeFromList = (item, list) ->
    index = list.indexOf item
    list.splice index, 1 if angular.isNumber index

  $scope.addItemProp = (item, prop, itemprop) ->
    item[prop] ?= []
    item[prop].push angular.copy itemprop

  toHTML = (root, element = $("<div />")) ->
    type = root.type or root.name
    rootEl = $("<div itemscope itemtype='#{type}' />")
    element.append rootEl

    if root.props

      for propName in root.props
        [tag, name]   = extractPropertyTagAndName propName
        propertyAttrs = $scope.parseProperty propName

        if not root[propName]?.length
          continue
        else
          propsEl = $("<ul />")
          rootEl.append propsEl

          for itemprop in root[propName]
            listEl = $("<li />")
            propEl = $("<#{tag} itemprop='#{name}' />")
            listEl.append propEl
            for attr in propertyAttrs
              if attr is "text"
                propEl.text itemprop[attr]
              else
                propEl.attr attr, itemprop[attr]

            propsEl.append listEl

    for child in root.children
      toHTML(child, rootEl)

    return rootEl

  $scope.$watch ->
    $scope.editorOutput = toHTML($scope.root).html()
