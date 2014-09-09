// Generated by CoffeeScript 1.8.0
(function() {
  var PathExp, finish, fs, noop, rejigger, types, _;

  fs = require('fs');

  fs.path = require('path');

  fs.find = require('findit');

  fs.mkdirp = require('mkdirp');

  PathExp = require('simple-path-expressions').PathExp;

  _ = require('underscore');

  types = {
    images: ['png', 'gif', 'psd', 'jpg', 'jp2', 'tiff', 'tif', 'raw', 'bmp', 'webp'],
    documents: ['txt', 'doc', 'docx', 'odt', 'markdown', 'md', 'textile'],
    data: ['csv', 'json', 'xml', 'yaml', 'yml', 'hdf', 'log']
  };

  noop = function() {};

  finish = function(err) {
    if (err) {
      if (program.strict) {
        throw err;
      } else {
        return console.log(err);
      }
    }
  };

  rejigger = function(operation, sourcePattern, destinationPattern, options, callback) {
    var destinationTemplate, finder, head, sourceTemplate;
    if (options == null) {
      options = {};
    }
    if (callback == null) {
      callback = noop;
    }
    sourceTemplate = new PathExp(fs.path.resolve(sourcePattern + '.<extension>'));
    destinationTemplate = new PathExp(fs.path.resolve(destinationPattern + '.<extension>'));
    head = fs.path.resolve(sourceTemplate.head);
    finder = fs.find(head);
    finder.on('file', function(source, stats) {
      var destination, directory, match;
      if (match = sourceTemplate.match(source)) {
        destination = destinationTemplate.fill(match);
        directory = fs.path.dirname(destination);
        return fs.exists(destination, function(exists) {
          if (!exists) {
            return fs.mkdirp(directory, function(err) {
              var stream;
              if (err) {
                throw err;
              }
              switch (operation) {
                case 'copy':
                  stream = fs.createReadStream(source);
                  stream.pipe(fs.createWriteStream(destination));
                  stream.on('finish', finish);
                  break;
                case 'move':
                  fs.rename(source, destination, finish);
                  break;
                case 'link':
                  fs.symlink(source, destination, finish);
                  break;
                default:
                  throw new Error("Invalid operation. Got " + operation + ". Expected: copy, move or link.");
              }
              if (options.verbose) {
                return console.log("" + operation + " " + source + " -> " + destination);
              }
            });
          }
        });
      }
    });
    return finder.on('end', callback);
  };

  exports.copy = _.partial(rejigger, 'copy');

  exports.move = _.partial(rejigger, 'move');

  exports.link = _.partial(rejigger, 'link');

}).call(this);