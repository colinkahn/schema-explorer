APP.directive "mdEditor", ($parse, Item, schemas) ->
  restrict: "E"
  replace: true
  template: """ 
    <section class="editor row-fluid">
      <ul class="editor-tree span5">
        <li ng-include="'/partials/microdata-item.html'">
      </ul>
      <div class="span5" ng-include="'/partials/microdata-editor.html'"></div>
    </section>
  """
  scope:
    editors: "=mdEditorEditors"

  link: ($scope, $element, $attrs) ->
    $scope.schemas = schemas
    $scope.root    = new Item "root"

    rootGetter = $parse $attrs.mdEditorRoot
    rootSetter = rootGetter.assign

    $scope.edit = (item) ->
      $scope.editing = item

    $scope.isEditing = (item) ->
      $scope.editing is item

    $scope.$watch ->
      rootSetter $scope, $scope.root
