do ->
  MODULES =
    APP: ["fui"]

  for name, requires of MODULES
    window[name] = angular.module name, requires
