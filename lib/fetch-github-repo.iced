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

        url = "https://github.com/#{args.organization}/#{args.repo}"
        zipUrl = "#{url}/zipball/master"

            
        unzipExtractor = unzip.Extract({ path: args.path });
        unzipExtractor.on('error', (err)->
            args.error
                message:'An Error occured unzipping the file.'
                inner:err
        )
        unzipExtractor.on('end', args.success)
        request(url, 
            (error,response,body)-> 
                if (!error && (response.statusCode == 200)) 
                    request(zipUrl).pipe(unzipExtractor)                    
                else
                    args.error("Status code #{response.statusCode} received")
        )
                    
}
