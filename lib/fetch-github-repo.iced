fs = require('fs');
unzip = require('unzip')
request = require('request')
_ = require('underscore')
module.exports = {
    download : (args)-> 
        args = _.defaults args, 
                path:'.'
                error: ()-> 
                success:()->
        url = 'https://github.com/'+args.organization+'/'+args.repo+'/zipball/master'
        request url, 
            (error,response)-> 
                if (!error && response.statusCode == 200) 
                    console.log 'win'
                    args.success()
                else
                    args.error()
                
        
}
