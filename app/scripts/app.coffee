do ->
  MODULES =
    APP: []

  for name, requires of MODULES
    window[name] = angular.module name, requires
