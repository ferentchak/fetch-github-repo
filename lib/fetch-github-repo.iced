fs = require('fs');
unzip = require('unzip')
request = require('request')

request('https://github.com/ferentchak/IterationInTime/zipball/master')
    .pipe(unzip.Extract({ path: 'lib' }))
