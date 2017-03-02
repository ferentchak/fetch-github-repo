var assert, fetchGithubRepo, fs, fsextra;

assert = require("assert");

fetchGithubRepo = require('../index.js');

fs = require('fs');

fsextra = require('fs-extra');

describe('Fetch Github Repo', function() {
  var baseDir;
  baseDir = 'temp';
  before(function() {
    var e;
    try {
      return fs.mkdirSync(baseDir);
    } catch (_error) {
      e = _error;
    }
  });
  after(function() {
    var e;
    try {
      return fxextra.removeSync(baseDir);
    } catch (_error) {
      e = _error;
    }
  });
  it('Bad GitHub Organization', function(done) {
    var callback;
    callback = function(error) {
      if (error.message.match(/404/)) {
        return done();
      } else {
        return done(new Error('Message not returned'));
      }
    };
    return fetchGithubRepo.download({
      organization: 'RallyCozzzzzzzzmmunity',
      repo: 'ForwardLookingIterationBoard'
    }, callback);
  });
  it('Bad directory in path', function(done) {
    var callback;
    callback = function(error) {
      if (error.message.match(/Directory/)) {
        return done();
      } else {
        return done(new Error("Message not returned. Call returned: " + error));
      }
    };
    return fetchGithubRepo.download({
      organization: 'ferentchak',
      repo: 'fetch-github-repo',
      path: "./" + baseDir + "/zork"
    }, callback);
  });
  it('Happy Path', function(done) {
    return fetchGithubRepo.download({
      organization: 'ferentchak',
      repo: "fetch-github-repo",
      path: "./" + baseDir
    }, done);
  });
  return it('Finds proper file to rename', function() {
    var result;
    result = fetchGithubRepo.match(['ferentchak-ferentchak.github.com-435ca81', 'zork'], 'ferentchak');
    return assert.strictEqual(result, 'ferentchak-ferentchak.github.com-435ca81');
  });
});
