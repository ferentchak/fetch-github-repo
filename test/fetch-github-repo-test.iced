assert = require("assert")
fetchGithubRepo = require('../index.js')
describe('Fetch Github Repo', ()->
  describe('Make sure non-existant orgs fail gracefully', ()->
    it('Bad Organization', (done)->
        onSuccess = (message)->
                done("False positive")
        onError = (message)->
                if message.match(/404/)
                    done()
                else
                    done(new Error('Message not returned'))
        fetchGithubRepo.download(
            organization:'RallyCozzzzzzzzmmunity'
            repo : 'ForwardLookingIterationBoard'
            success:onSuccess,
            error:onError
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