APP.directive "mdEditor", ($parse, Item, schemas) ->
  restrict: "E"
  replace: true
  template: """ 
    <ul>
      <li ng-include="'/partials/microdata-item.html'">
    </ul>
  """
  scope:
    editors: "=mdEditorEditors"

  link: ($scope, $element, $attrs) ->
    $scope.schemas = schemas
    $scope.root    = new Item "root"

    rootGetter = $parse $attrs.mdEditorRoot
    rootSetter = rootGetter.assign

    $scope.$watch ->
      rootSetter $scope, $scope.root
