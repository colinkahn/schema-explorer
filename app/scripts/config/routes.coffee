APP.config ($routeProvider) ->
  $routeProvider
  .when "/",
    controller: "HomeController"
    templateUrl: "views/home.html"
  .otherwise
    redirectTo: "/"
