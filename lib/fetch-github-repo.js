var fs, request, unzip, fsextra, _;

fs = require('fs');

unzip = require('unzip');

request = require('request');

_ = require('underscore');

fsextra = require('fs-extra');

module.exports = {
  moveFilesFromZip: function(path, organization, callback) {
    var directory, files, receiveFiles;
    files = fs.readdirSync(path);
    directory = path + "/" + this.match(files, organization);
    receiveFiles = (function(_this) {
      return function(err, files) {
        var file, _i, _len;
        if (err) {
          callback(err);
        } else {
          for (_i = 0, _len = files.length; _i < _len; _i++) {
            file = files[_i];
            fs.renameSync(directory + "/" + file, path + "/" + file);
          }
        }
        return fsextra.remove(directory, callback);
      };
    })(this);
    return fs.readdir(directory, receiveFiles);
  },
  createRepoUrl: function(organization, repo) {
    return "https://github.com/" + organization + "/" + repo;
  },
  createZipUrl: function(organization, repo) {
    var url;
    url = this.createRepoUrl(organization, repo);
    return "" + url + "/zipball/master";
  },
  fetchAndUnzip: function(organization, repo, path, callback) {
    var unzipExtractor, zipUrl;
    unzipExtractor = unzip.Extract({
      path: path
    });
    unzipExtractor.on('error', callback);
    unzipExtractor.on('close', (function(_this) {
      return function() {
        return _this.moveFilesFromZip(path, organization, callback);
      };
    })(this));
    zipUrl = this.createZipUrl(organization, repo);
    return request(zipUrl).pipe(unzipExtractor);
  },
  validateRepoExists: function(organization, repo, callback) {
    var url;
    url = this.createRepoUrl(organization, repo);
    return request(url, (function(_this) {
      return function(error, response) {
        if (!error && (response.statusCode === 200)) {
          return callback();
        } else {
          return callback(new Error("Status code " + response.statusCode + " received from repo at " + url));
        }
      };
    })(this));
  },
  download: function(args, callback) {
    args = _.defaults(args, {
      path: '.',
      callback: function() {}
    });
    return this.validateRepoExists(args.organization, args.repo, (function(_this) {
      return function(err) {
        if (err) {
          return callback(err);
        } else {
          return _this.fetchAndUnzip(args.organization, args.repo, args.path, callback);
        }
      };
    })(this));
  },
  match: function(files, organization) {
    var file, _i, _len;
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      if (file.indexOf(organization) > -1) {
        return file;
      }
    }
    return new Error('Zip file not found after download');
  }
};
