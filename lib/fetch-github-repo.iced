fs = require('fs')
unzip = require('unzip')
request = require('request')
_ = require('underscore')
wrench = require('wrench')

module.exports =
  moveFilesFromZip: (path, organization,callback)->
    files = fs.readdirSync(path)
    directory = path + "/" + @match(files, organization)
    receiveFiles = (err, files)=>
      if err
        callback err
      else
        await
          for file in files
            fs.rename(directory + "/" + file, path + "/" + file,defer())
        wrench.rmdirRecursive(directory, callback)

    fs.readdir(directory, receiveFiles)

  createRepoUrl:(organization,repo)->
    return "https://github.com/#{organization}/#{repo}"

  createZipUrl:(organization,repo)->
    url = @createRepoUrl(organization,repo)
    return "#{url}/zipball/master"

  fetchAndUnzip:(organization,repo,path,callback)->
    unzipExtractor = unzip.Extract({ path: path })
    unzipExtractor.on('error', callback)
    unzipExtractor.on 'close', ()=>
      @moveFilesFromZip(path, organization,callback)

    zipUrl = @createZipUrl(organization,repo)

    request(zipUrl).pipe(unzipExtractor)

  validateRepoExists:(organization,repo,callback)->
    url = @createRepoUrl(organization,repo)
    request(
      url,
    (error, response)=>
      if (!error && (response.statusCode == 200))
        callback()
      else
        callback(new Error("Status code #{response.statusCode} received from repo at #{url}"))
    )

  download: (args,callback)->
    args = _.defaults args,
      path: '.'
      callback: ()->

    @validateRepoExists(
      args.organization
      args.repo
      (err)=>
        if err
          callback(err)
        else
          @fetchAndUnzip(args.organization,args.repo,args.path,callback)
    )

  match: (files, organization)->
    for file in files
      if file.indexOf(organization) > -1
        return file
    new Error 'Zip file not found after download'

