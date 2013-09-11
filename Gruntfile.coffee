fs           = require "fs"
path         = require "path"
proxySnippet = require("grunt-connect-proxy/lib/utils").proxyRequest

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-connect-proxy"
  grunt.loadNpmTasks "grunt-karma"

  grunt.initConfig
    package: grunt.file.readJSON "package.json"

    coffee:
      compile:
        files:
          "build/js/app.js": [
            "app/scripts/app.coffee"
            "app/scripts/**/*.coffee"
          ]
    copy:
      assets:
        expand: true
        src: "app/assets/*"
        dest: "build/assets/"
        flatten: true
      flat_ui_fonts:
        expand: true
        src: ["vendor/bower/flat-ui-official/fonts/*"]
        dest: "build/fonts/"
        flatten: true
    concat:
      js:
        dest: "build/js/vendor.js"
        src: [
          "vendor/bower/jquery/jquery.js"
          "vendor/bower/underscore/underscore.js"
          "vendor/bower/angular/angular.js"
          # Flat UI JS
          "vendor/bower/flat-ui-official/js/jquery-ui-1.10.3.custom.min.js"
          "vendor/bower/flat-ui-official/js/jquery.ui.touch-punch.min.js"
          "vendor/bower/flat-ui-official/js/bootstrap.min.js"
          "vendor/bower/flat-ui-official/js/bootstrap-select.js"
          "vendor/bower/flat-ui-official/js/bootstrap-switch.js"
          "vendor/bower/flat-ui-official/js/flatui-checkbox.js"
          "vendor/bower/flat-ui-official/js/flatui-radio.js"
          "vendor/bower/flat-ui-official/js/jquery.tagsinput.js"
          "vendor/bower/flat-ui-official/js/jquery.placeholder.js"
          "vendor/bower/flat-ui-official/js/jquery.stacktable.js"
          "vendor/bower/flat-ui-official/js/application.js"
        ]
      css:
        dest: "build/css/app.css"
        src: [
          "tmp/import.css"
          "vendor/bower/flat-ui-official/bootstrap/css/bootstrap.css"
        ]
      flat_ui_css:
        dest: "build/css/flat-ui.css"
        src: ["vendor/bower/flat-ui-official/css/flat-ui.css"]
    stylus:
      compile:
        options:
          use: [require "nib"]
        files:
          "tmp/import.css": ["app/styles/import.styl"]
    jade:
      options:
        data:
          version: "<%= package.version %>"
      files:
        expand: true
        cwd: "app"
        src: ["**/*.jade"]
        ext: ".html"
        dest: "build"
    clean: ["tmp"]
    connect:
      server:
        options:
          port: 8090
          keepalive: true
          middleware: (connect) ->
            [
              proxySnippet
              connect.static path.resolve("build")
            ]
      proxies: [
        context: "/api"
        host: "localhost"
        port: 4040
      ]
    watch:
      js:
        files: ["app/**/*.coffee"]
        tasks: ["coffee"]
        options: interrupt: true
      css:
        files: ["app/**/*.styl", "app/**/**/*.styl"]
        tasks: ["stylus", "concat:css", "clean"]
        options: interrupt: true
      jade:
        files: ["app/**/*.jade"]
        tasks: ["jade"]
        options: interrupt: true
    karma:
      unit:
        configFile: "test/karma.conf.js"
        autoWatch: true

  # Helper Functions

  spawn = (options, done = ->) ->
    options.opts ?= stdio: "inherit"
    grunt.util.spawn options, done

  # Helper Routines

  runDevelopment = (tests = false) ->
    @async()

    spawn
      grunt: true
      args: ["compile"]
    , ->
      spawn
        grunt: true
        args: ["watch"]

      spawn
        grunt: true
        args: ["configureProxies", "connect"]
        
      if tests
        spawn
          grunt: true
          args: ["karma"]

  # Custom Tasks

  grunt.registerTask "embed:html", "Embeds angular partials into directives", ->
    fromFile         = "build/js/app.js"
    writeFile        = "build/js/app.js"
    templateUrlRegex = /templateUrl: "([^"]+)"/g
    done             = @async()

    fs.readFile fromFile, "utf8", (err, data) ->
      throw err if err?

      updatedCode = data

      while match = templateUrlRegex.exec data
        toReplace    = match[0]
        filePath     = path.join "build", match[1]
        compiledHtml = fs.readFileSync filePath, "utf8"
        compiledHtml = compiledHtml.replace /"/g, "\\\""
        compiledHtml = compiledHtml.replace /\n/g, ""
        updatedCode  = updatedCode.replace toReplace, "template: \"#{compiledHtml}\""

      fs.writeFile writeFile, updatedCode, "utf8", (err, data) ->
        grunt.log.writeln "Embeded html successfully"
        done()

  grunt.registerTask "compile", "Compile all source code", [
    "coffee"
    "stylus"
    "jade"
    "copy"
    "concat"
    "clean"
  ]

  grunt.registerTask "lite", "Build, Watch and Connect", ->
    runDevelopment.call this

  grunt.registerTask "default", "Build, Watch, Connect, and Karma", ->
    runDevelopment.call this, true
