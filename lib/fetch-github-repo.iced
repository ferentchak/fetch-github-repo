fs = require('fs')
unzip = require('unzip')
request = require('request')
_ = require('underscore')
wrench = require('wrench')

module.exports =
  _match: (files,organization)->
    for file in files
      if file.indexOf(organization) > -1
        return file
    new Error 'Temp Zip File Not found'

  moveFilesFromZip:(path,organization,success,error)->
    try
      files = fs.readdirSync(path)
      directory = path+"/"+@_match(files,organization)
      repoContents = fs.readdirSync(directory)

      for file in repoContents
        fs.renameSync(directory+"/"+file, path+"/"+file)
      success()
    catch err
      error(err)

  download: (args)->
    args = _.defaults args,
      path: '.'
      error: ()->
      success: ()->

    url = "https://github.com/#{args.organization}/#{args.repo}"
    zipUrl = "#{url}/zipball/master"

    unzipExtractor = unzip.Extract({ path: args.path })
    unzipExtractor.on('error', (err)->
      args.error
        message: 'An Error occured unzipping the file.'
        inner: err
    )
    unzipExtractor.on 'close', ()=>
      @moveFilesFromZip(args.path,args.organization,args.success,args.error)

    request(url,
      (error, response, body)->
        if (!error && (response.statusCode == 200))
          request(zipUrl).pipe(unzipExtractor)
        else
          args.error
            message: "Status code #{response.statusCode} received"
      )

