fs = require('fs');
unzip = require('unzip')
request = require('request')

module.exports = {
    download : (organization,repo,_path)->    
        path = _path || '.'
        request('https://github.com/'+organization+'/'+repo+'/zipball/master')
        .pipe(unzip.Extract({ path: path }))
}
