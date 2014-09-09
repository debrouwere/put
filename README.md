`put` is an [ISC-licensed](http://en.wikipedia.org/wiki/ISC_license) command-line utility to move, rename, copy and symlink files. `put` uses a simple placeholder syntax to transform input filenames to output filenames. Think of it as an easier-to-use but perhaps less powerful Linux `rename`.

### Usage

```sh
# copy files
put 'app/config/nginx/{type}' '/etc/nginx/{type}.conf'

# move or rename files
put --move 'music/{title} - {album} ({artist})' 'music/{artist} - {title}'

# symlink files
put --link 'posts/{year}/images/{slug}' 'build/images/{year}-{slug}'
```

Any intermediate directories that don't yet exist will be created for you. It acts like `mkdir -p` and `rename` glued together, if you will.

See `put --help` for more details.

Install using `npm install put-cli -g`. You'll need to have node.js installed for this to work.

### Status

Works for me, but needs unit tests before it can be declared safe for public consumption.

### Limitations and roadmap

* `put` has no way to limit which file types it operates on, though the ability to specify either a list of extensions or a file type (image, data, document) is planned.
* `put` can symlink or move directories, but it can't copy a directory (yet).
* `put` will never overwrite a file. There is no command-line flag or other option to force this or decide interactively. This is a precaution, as this utility currently lacks any sort of tests and I don't want to destroy anybody's filesystem. As tests are added, this restriction will be removed.
* `put` requires the NPM package installer and a working [Node.js](http://nodejs.org/) setup. It needs OS packages.

### Use from node.js

The `put-cli` library exposes `copy`, `move` and `link` functions. They all have the same interface:

    fn(source, destination, options, callback)

Options and callback are optional.

For example: 

```javascript
var put = require('put');
var source = 'images/{year}-{description}-{width}x{height}';
var destination = 'images/{year}/{description}';
var options = {verbose: true};
put.move(source, destination, options, function(err) {
    console.log('done!');
});
```