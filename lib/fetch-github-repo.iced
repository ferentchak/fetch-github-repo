fs = require('fs');
unzip = require('unzip')
request = require('request')

request('https://github.com/ferentchak/IterationInTime/zipball/master').pipe(fs.createWriteStream('doodle.zip'))




###
var readStream = fs.createReadStream('path/to/archive.zip');
var writeStream = fstream.Writer('output/path');

fs.createReadStream('path/to/archive.zip')
  .pipe(unzip.Parse())
  .on('entry', function (entry) {
    var fileName = entry.path;
    var type = entry.type; // 'Directory' or 'File'
    var size = entry.size;
###