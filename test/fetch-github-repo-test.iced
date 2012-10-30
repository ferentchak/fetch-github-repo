assert = require("assert")
fetchGithubRepo = require('../index.js')
fs = require('fs')
describe('Fetch Github Repo', ()->

    it('Bad GitHub Organization', (done)->
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
  
    it 'Bad directory', (done)->
        onSuccess = (message)->
            done("False positive")
        onError = (error)->
            if error.message.match(/unzipping/)
                done()
            else
                done(new Error('Message not returned'))
            
        fetchGithubRepo.download
            organization:'ferentchak'
            repo : 'fetch-github-repo',
            path: './temp/zork'
            success:onSuccess,
            error:onError
        
    
    
    it 'Happy Path', (done)->
        fetchGithubRepo.download
            organization:'ferentchak'
            repo : 'fetch-github-repo',
            path: './temp'
            success:done,
            error:done
        
    
)