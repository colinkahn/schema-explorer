
APP.service "schemas", ($http) ->
  schemas = loaded: false 

  $http.get("/assets/all.json", resposeType: "json").then (response) ->
    console.log response.data
    for key, value of response.data
      schemas[key] = value

    schemas.loaded = true

  schemas
