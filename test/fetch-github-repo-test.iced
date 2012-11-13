assert = require("assert")
fetchGithubRepo = require('../index.js')
fs = require('fs')
wrench = require('wrench')

describe('Fetch Github Repo', ()->
  baseDir = 'temp'

  before ()->
    try
      fs.mkdirSync(baseDir)
    catch e

  after ()->
    try
      wrench.rmdirSyncRecursive(baseDir)
    catch e

  it('Bad GitHub Organization', (done)->
    callback = (error)->
      if error.message.match(/404/)
        done()
      else
        done(new Error('Message not returned'))
    fetchGithubRepo.download(
      organization: 'RallyCozzzzzzzzmmunity'
      repo: 'ForwardLookingIterationBoard'
      callback
    )
  )

  it 'Bad directory in path', (done)->
    callback = (error)->
      if error.message.match(/Directory/)
        done()
      else
        console.error(error)
        done(new Error('Message not returned'))

    fetchGithubRepo.download
      organization: 'ferentchak'
      repo: 'ferentchak.github.com',
      path: "./#{baseDir}/zork"
      callback


  it 'Happy Path', (done)->
    fetchGithubRepo.download
      organization: 'ferentchak'
      repo: "ferentchak.github.com",
      path: "./#{baseDir}"
      done

  it 'Finds proper file to rename', ()->
    result = fetchGithubRepo.match([ 'ferentchak-ferentchak.github.com-435ca81', 'zork' ], 'ferentchak');
    assert.strictEqual(result, 'ferentchak-ferentchak.github.com-435ca81')
)