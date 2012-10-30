assert = require("assert")
fetchGithubRepo = require('../index.js')
fs = require('fs')
describe('Fetch Github Repo', ()->
    baseDir = 'temp'
    
    before ()->
        fs.mkdirSync(baseDir)
    
    after ()->
        fs.rmdirSync(baseDir)

    it('Bad GitHub Organization', (done)->
        onSuccess = ()->
                done("False positive")
        onError = (error)->
                if error.message.match(/404/)
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
  
    it 'Bad directory in path', (done)->
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
            path: './#{baseDir}/zork'
            success:onSuccess,
            error:onError
        
    
    
    it 'Happy Path', (done)->
        fetchGithubRepo.download
            organization:'ferentchak'
            repo : 'fetch-github-repo',
            path: './#{baseDir}'
            success:done,
            error:done
        
    
)