APP.controller "HomeController", ($scope, schemas) ->
  $scope.msg = "MicroData Api Editor"

  $scope.editors = [
    name: "Debugger"
    launch: (item) ->
      console.log item
  ]

  $scope.$watch ->
    return unless schemas.loaded and $scope.root?
    $scope.editorOutput = $scope.root.toHTML().html()
