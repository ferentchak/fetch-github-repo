
Install with `npm install fetch-github-repo`

## API

JavaScript
```
var fetchGitHubRepo;

fetchGitHubRepo = require("fetch-github-repo");

fetchGithubRepo.download({
  organization: 'ferentchak',
  repo: "ferentchak.github.com",
  path: ".",
  success: function() {},
  error: function() {}
});

```


Coffee
```fetchGithubRepo.download
  organization:'ferentchak'
  repo : "ferentchak.github.com",
  path: "."
  success:()->
  error:()->
```


## Run Tests

To run the tests:
mocha --compilers iced:iced-coffee-script