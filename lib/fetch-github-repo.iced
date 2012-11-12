fs = require('fs')
unzip = require('unzip')
request = require('request')
_ = require('underscore')
wrench = require('wrench')


match = (files, organization)->
  for file in files
    if file.indexOf(organization) > -1
      return file
  new Error 'Temp Zip File Not found'

class FetchGitHubRepo
  config:undefined

  constructor:(config)->
    @config = _.defaults config,
      path: '.'
      error: ()->
      success: ()->

  moveFilesFromZip: (path, organization)->
    try
      files = fs.readdirSync(path)
      directory = path + "/" + match(files, organization)
      repoContents = fs.readdirSync(directory)

      for file in repoContents
        fs.renameSync(directory + "/" + file, path + "/" + file)

      wrench.rmdirRecursive(directory,@config.success)
    catch err
      @config.error(
        message : "Error moving files from the Zip"
        inner : err
      )

  download: ()->
    url = "https://github.com/#{@config.organization}/#{@config.repo}"
    zipUrl = "#{url}/zipball/master"

    unzipExtractor = unzip.Extract({ path: @config.path })
    unzipExtractor.on('error', (err)=>
      @config.error
        message: 'An Error occured unzipping the file.'
        inner: err
    )
    unzipExtractor.on 'close', ()=>
      @moveFilesFromZip(@config.path, @config.organization, @config.success, @config.error)

    request(url,
    (error, response, body)=>
      if (!error && (response.statusCode == 200))
        request(zipUrl).pipe(unzipExtractor)
      else
        @config.error
          message: "Status code #{response.statusCode} received"
    )


module.exports =
  download: (args)->
    new FetchGitHubRepo(args).download()
  _match: match