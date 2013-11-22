'use strict'

module.exports = (grunt) ->
	require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

	grunt.initConfig
		buildDir: '../public'
		srcDir: './'
		tmpDir: './.tmp'
		pkg: grunt.file.readJSON 'package.json'
		src:
			coffee: '<%= srcDir %>/coffee/*.coffee'
			less: '<%= srcDir %>/less'
		clean:
			tmp: [ '<%= tmpDir %>' ]
		recess:
			build:
				files:
					'<%= tmpDir %>/css/<%= pkg.name %>.css': ['<%= src.less %>/main.less']
				options:
					compile: true
					compress: true

		autoprefixer:
			multiple_files:
				flatten: true
				expand: true					
				src:  '<%= tmpDir %>/css/*.css'
				dest: '<%= buildDir %>/css/'

		coffee:
			build:
				options:
					bare: true
				files: [
					expand: true,
					cmd: 'coffee',
					src: [ '<%= src.coffee %>' ],
					dest: '.tmp/js/',
					ext: '.js'
				]

		concat:
			build:
				src: [
					'module.prefix'
					'.tmp/js/**/*.js'
					'module.suffix'
				]
				dest: '<%= tmpDir %>/js/<%= pkg.name %>.js'

		# Annotate angular sources
		ngmin:
			build:
				src: [ '<%= tmpDir %>/js/<%= pkg.name %>.js' ]
				dest: '<%= buildDir %>/js/<%= pkg.name %>.annotated.js'

		# Minify the sources!
		uglify:
			build:
				files:
					'<%= buildDir %>/js/<%= pkg.name %>.min.js': [ '<%= buildDir %>/js/<%= pkg.name %>.annotated.js' ]


		delta:
			coffee:
				files: [ '<%= src.coffee %>' ]
				tasks: [
					'clean:tmp'
					'coffee'
					'concat'
					'ngmin'
					'uglify'
				]
			less:
				files: [ '<%= src.less %>/*.less' ]
				tasks: [ 'recess', 'autoprefixer' ]



	grunt.renameTask 'watch', 'delta'
	grunt.registerTask 'watch', [
		'build'
		'delta'
	]

	# The default task is to build.
	grunt.registerTask 'default', [ 'build' ]
	grunt.registerTask 'build', [
		'clean:tmp'
		'recess'
		'autoprefixer'
		'coffee'
		'concat'
		'ngmin'
		'uglify'
	]
