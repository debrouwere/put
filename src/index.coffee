fs = require 'fs'
fs.path = require 'path'
fs.find = require 'findit'
fs.mkdirp = require 'mkdirp'
{PathExp} = require 'simple-path-expressions'
_ = require 'underscore'

types =
    images: ['png', 'gif', 'psd', 'jpg', 'jp2', 'tiff', 'tif', 'raw', 'bmp', 'webp']
    documents: ['txt', 'doc', 'docx', 'odt', 'markdown', 'md', 'textile']
    data: ['csv', 'json', 'xml', 'yaml', 'yml', 'hdf', 'log']

noop = ->

finish = (err) ->
    if err
        if program.strict
            throw err
        else
            console.log err

# TODO: replace callback spaghetti with async.waterfall
rejigger = (operation, sourcePattern, destinationPattern, options={}, callback=noop) ->
    sourceTemplate = new PathExp fs.path.resolve sourcePattern + '.<extension>'
    destinationTemplate = new PathExp fs.path.resolve destinationPattern + '.<extension>'

    head = fs.path.resolve sourceTemplate.head
    finder = fs.find head

    finder.on 'file', (source, stats) ->
        if match = sourceTemplate.match source
            destination = destinationTemplate.fill match
            directory = fs.path.dirname destination

            fs.exists destination, (exists) ->
                unless exists
                    fs.mkdirp directory, (err) ->
                        if err then throw err
                        switch operation
                            when 'copy'
                                stream = fs.createReadStream source
                                stream.pipe fs.createWriteStream destination
                                stream.on 'finish', finish
                            when 'move'
                                fs.rename source, destination, finish
                            when 'link'
                                fs.symlink source, destination, finish
                            else
                                throw new Error "Invalid operation. Got #{operation}.
                                    Expected: copy, move or link."

                        if options.verbose
                            console.log "#{operation} #{source} -> #{destination}"

    finder.on 'end', callback


exports.copy = _.partial rejigger, 'copy'
exports.move = _.partial rejigger, 'move'
exports.link = _.partial rejigger, 'link'
