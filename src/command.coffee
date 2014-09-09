program = require 'commander'
put = require './'

program
    .version '0.1.0'
    .usage '<source> <destination> [options]'
    .option '-l, --link'
    .option '-m, --move'
    .option '-e, --extension <extensions>'
    .option '-t, --type <types>'
    .option '-v, --verbose'
    .option '-s, --strict'
    .option '-f, --force'
    .parse process.argv


if program.extension or program.type or program.force
    throw new Error "--extension, --type and --force are not yet implemented"

if program.link and program.move
    console.log "Cannot move and symlink a file at the same time. Pick either --move or --link, not both."
else if program.link
    operation = 'link'
else if program.move
    operation = 'move'
else
    operation = 'copy'

[sourcePattern, destinationPattern] = program.args
options =
    verbose: program.verbose
put[operation] sourcePattern, destinationPattern, options
