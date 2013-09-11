APP.controller "HomeController", ($scope, $http, Schema) ->
  $scope.msg = "MicroData Api Editor"

  $http.get("/assets/all.json", resposeType: "json").then (response) ->
    console.log schemas = response.data
    $scope.schemas = schemas

  $scope.editors = [
    name: "Debugger"
    launch: (item) ->
      console.log item
  ]

  toHTML = (children, parentEl = $("<div />")) ->
    for item in children
      type =
        if item.id of $scope.schemas.datatypes
          $scope.schemas.datatypes[item.id].url
        else
          $scope.schemas.types[item.id].url

      tag = item.tag or "div"

      itemEl = $("<#{tag} itemtype='#{type}' />")
      parentEl.append itemEl

      if item.id of $scope.schemas.types
        itemEl.attr "itemscope", ""

      if item.itemProp
        itemEl.attr "itemprop", item.itemProp

      if item.text
        itemEl.text item.text

      toHTML(item.children, itemEl)

    return parentEl

  $scope.$watch ->
    return unless $scope.schemas and $scope.root?
    $scope.editorOutput = toHTML($scope.root.children).html()
