APP.directive "mdEditor", ($parse, Item, schemas) ->
  restrict: "E"
  replace: true
  template: """ 
    <section class="editor">
      <ul class="editor-tree">
        <li ng-include="'/partials/microdata-item.html'">
      </ul>
      <div class="editor-controls" ng-include="'/partials/microdata-editor.html'"></div>
    </section>
  """
  scope:
    editors: "=mdEditorEditors"

  link: ($scope, $element, $attrs) ->
    $scope.schemas     = schemas
    $scope.root        = new Item "root"
    $scope.root.isRoot = true

    rootGetter = $parse $attrs.mdEditorRoot
    rootSetter = rootGetter.assign

    $scope.edit = (item) ->
      $scope.editing = item

    $scope.isEditing = (item) ->
      $scope.editing is item

    $scope.$watch ->
      rootSetter $scope, $scope.root
