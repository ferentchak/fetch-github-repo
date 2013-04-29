## Install 

[![Build Status](https://travis-ci.org/ferentchak/fetch-github-repo.png?branch=master)](https://travis-ci.org/ferentchak/fetch-github-repo)

`npm install fetch-github-repo`

## API

JavaScript
```
var FetchGithubRepo, callback;

FetchGithubRepo = require("fetch-github-repo");

callback = function(err) {};

FetchGithubRepo.download({
  organization: 'ferentchak',
  repo: "ferentchak.github.com",
  path: "."
}, callback);

```


Coffee
```
FetchGithubRepo = require "fetch-github-repo"
callback = (err)->
FetchGithubRepo.download
  organization:'ferentchak'
  repo : "ferentchak.github.com",
  path: "."
  callback
```


## Run Tests

To run the tests:
npm test