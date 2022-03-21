# Luft - Lua Fold Tooling

## Starting a new Luft folder:

`luft start --lua-version 5.4 <YOURFOLDER>`

Inside `YOURFOLDER`:
* It creates a `run` shellscript file that will call your
  init.lua run function with environment set to use inner
  structure (Lua `package.path`)
* Creates a local tree for Luarocks under `.luarocks`
* Creates a `init.lua` file if not exists as a draft to start
  development.
* Create a deps.cfg template file used to get dependencies

In case you run start without specifying the Lua version, this
will try to discover and use the default Lua version of your
system.

## Running

Just call `<YOURFOLDER>/run` to run your project. Any arguments
will be passed to the returned `run()` function inside your init.lua.

All your functions returned by init.lua module can be used directly by ./run. Example, in case your init.lua returns a
`help()` function, then if you run `./run help` this will be
called.

The only exceptions are `./run lua` or `./run luarocks` that
can be called to run Lua interpreter or Luarocks using the
inner directory configuration. Just be aware that doing this,
Lua and Luarocks doesnt will know what you have in your deps.cfg.

## Installing dependencies

## Updating

`luft update <YOURFOLDER>`

It reads deps.lua, and update the used rockspec of inner Luarocks structure.

To add a rock into your project run:

`./run luarocks install <rockname>`

If it exits in success, it will automatically update your deps.cfg
file with the installed dependencies.

To remove a dependency, issue Luarocks via run again:

`./run luarocks remove <rockname>`

Again, it will also updates your deps.cfg file accordingly.


## Prunning it all

If you wanna strip your project from Luft/Luarocks structure,
the only created file that will remains is the deps.cfg.

This way you can pack your folder into a zip, tgz etc. Without
carry the installed dependencies. Even run file will be removed.

`luft clean <directory>`

To rehydrates your folder again, just run:

`luft update <directory>`
