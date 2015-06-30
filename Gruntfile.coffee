exec = require('child_process').exec
module.exports = (grunt) ->

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerInitTask 'resources', 'Copy resources in the build folder', ->
        exec "cp -r web/resources web/build", (error, stdout, stderr) ->
            grunt.log.writeln 'stdout: ' + stdout
            grunt.log.writeln 'stderr: ' + stderr
            if error
                grunt.log.writeln error


    grunt.initConfig
        # COFFEE COMPILATION
        coffee: compile:
            options: join: true
            files: 'web/build/js/app.js': ['web/coffee/**/*.coffee']

        # SASS COMPILATION
        sass: compile:
            options: style: 'compressed'
            files: [
                cwd: 'web/sass'
                src: ['**/*.sass', '**/*.scss']
                dest: 'web/build/css'
                expand: true
                ext: '.min.css'
            ]

        # JADE COMPILATION
        jade: compile:
            options:
                client: false
                pretty: false
            files: [
                cwd: 'web/jade'
                src: '**/*.jade'
                dest: 'web/build'
                expand: true
                ext: '.html'
            ]

        # WATCH FILES AND COMPILE ON CHANGE
        # Posix: `grunt watch &`
        # Windows: `START /B grunt watch`
        watch:
            coffee:
                files: ['web/coffee/**/*.coffee']
                tasks: ['coffee']
            jade:
                files: ['web/jade/**/*.jade']
                tasks: ['jade']
            sass:
                files: ['web/sass/**/*.sass', 'web/sass/**/*.scss']
                tasks: ['sass']

    # Basic tasks calling other tasks
    # -------------------------------

    grunt.registerTask 'default', ['jade', 'sass', 'coffee', 'resources']


    # More complex tasks
    # ------------------

    # empty
