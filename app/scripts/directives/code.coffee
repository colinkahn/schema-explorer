APP.directive "mdHtmlElement", ($filter) ->

  transclude:  "element"
  scope:       true
  replace:     true

  compile: (element, attrs, linker) ->

    ($scope, $element, $attrs) ->
      currentElement = null

      $scope.$watch ->
        htmlElement = $scope.$eval $attrs.mdHtmlElement
        return unless htmlElement

        if currentElement
          currentElement.remove()

        currentElement = linker $scope, (clone) ->
          clone.text $filter("prettifyHtml") htmlElement
          $element.after clone
          prettyPrint()

        return false
