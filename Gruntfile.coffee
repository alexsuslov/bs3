module.exports = (grunt)->
  require('load-grunt-tasks')(grunt)
  grunt.initConfig
    pkg: grunt.file.readJSON("bower.json")
    coffeelint:
      app: ['Gruntfile.coffee','coffee/*.coffee']
    coffee:
      compile:
        options:
          # bare: true
          sourceMap: true
        files:
          'js/<%= pkg.name %>-<%= pkg.version %>.js':[
            'coffee/*.coffee'
            '!coffee/99*.coffee'
          ]
      tests:
        options:
          # bare: true
          sourceMap: true
        files:
          'js/<%= pkg.name %>-tests.js':[
            'coffee/*.coffee'
            'coffee/99*.coffee'
          ]
    codo: options:
      title: '<%= pkg.name %>-<%= pkg.version %>'
      output: "docs"
      inputs: [
        "coffee/"
      ]
    concat:
      options:
        separator: '\n// <%= pkg.name %>-<%= pkg.version %>\n'
      dist:
        src:[
          'js/<%= pkg.name %>-<%= pkg.version %>.js'
        ]
        dest:'js/<%= pkg.name %>-last.js'
    uglify:
      last:
        options:
          sourceMap: true
          sourceMapName: 'js/<%= pkg.name %>-last.min.map'
        files:
          'js/<%= pkg.name %>-last.min.js':[
            'js/<%= pkg.name %>-last.js'
          ]
    connect:
      server:
        options:
          hostname:'0.0.0.0'
          port: 9001
          # base: 'www-root'
          livereload: true
    watch:
      config:
        files: ['Gruntfile.coffee']
        tasks: ['coffeelint']
      tests:
        files: ['test/*.coffee']
        tasks: ['coffeelint']
      app:
        files: ['coffee/*.coffee']
        tasks: [
          'coffeelint'
          'coffee'
          'codo'
          'concat'
          'uglify'
        ]

  grunt.registerTask('default', [
    'coffeelint'
    'coffee'
    'codo'
    'concat'
    'uglify'
    'connect'
    'watch'
    ])
