// Karma configuration

// base path, that will be used to resolve files and exclude
basePath = '../build';


// list of files / patterns to load in the browser
files = [
  JASMINE,
  JASMINE_ADAPTER,

  '../vendor/bower/jquery/jquery.js',
  '../vendor/bower/underscore/underscore.js',
  '../vendor/bower/angular/angular.js',
  '../vendor/bower/angular-mocks/angular-mocks.js',

  'partials/*.html',

  '../app/scripts/app.coffee',
  '../app/scripts/**/*.coffee',

  '../test/unit/**/*.spec.coffee'
];

preprocessors = {
  '../app/scripts/app.coffee':      'coffee',
  '../app/scripts/**/*.coffee':     'coffee',
  '../test/unit/**/*.spec.coffee':  'coffee',
  'partials/*.html':                'html2js'
};

// list of files to exclude
exclude = [

];


// test results reporter to use
// possible values: 'dots', 'progress', 'junit'
reporters = ['progress'];


// web server port
port = 9876;


// cli runner port
runnerPort = 9100;


// enable / disable colors in the output (reporters and logs)
colors = true;


// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;


// enable / disable watching file and executing tests whenever any file changes
autoWatch = true;


// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari (only Mac)
// - PhantomJS
// - IE (only Windows)
browsers = ['Chrome'];


// If browser does not capture in given timeout [ms], kill it
captureTimeout = 60000;


// Continuous Integration mode
// if true, it capture browsers, run tests and exit
singleRun = false;
