assert = require("assert")
fetchGithubRepo = require('../index.js')
describe('Fetch Github Repo', ()->
  describe('Make sure non-existant orgs fail gracefully', ()->
    it('Bad Organization', (done)->
        fail = (message)->
                done("False positive")
        fetchGithubRepo.download(
            organization:'RallyCozzzzzzzzmmunity'
            repo : 'ForwardLookingIterationBoard'
            success:fail,
            error:done
        )
    )
  )

  describe('Happy Path', ()->
    it('Happy Path', (done)->
        fetchGithubRepo.download(
            organization:'RallyCommunity'
            repo : 'ForwardLookingIterationBoard'
            success:done
        )
    )
  )

)