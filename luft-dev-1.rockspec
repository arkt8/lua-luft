rockspec_format = "1.1"
package = "luft"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   summary = "Turn folders into Lua ecosystems using Luarocks",
   detailed = [[
      Use diretories (folders) to create semi-isolated Lua environments.
      Almost all dependencies are installed into the folder.
   ]],
   homepage = "*** please enter a project homepage ***",
   license = "MIT"
}
dependencies = {
   "lua 5.4",
}
build = {
   type = "builtin",
   modules = {
      ["aux.cli"]    = "lib/aux/cli.lua",
      ["aux.lists"]   = "lib/aux/lists.lua",
      ["aux.string"] = "lib/aux/string.lua",
      ["aux.shell"]  = "lib/aux/shell.lua",
      ["aux.path"]   = "lib/aux/path.lua",
      ["luft"]       = "lib/luft/init.lua",
      ["luft.start"] = "lib/luft/start.lua",
      -- ["luft.core"]  = "lib/luft/core.lua",
      -- ["luft.rocks"] = "lib/luft/rocks.lua",
      -- ["luft.install"] = "lib/luft-action/install.lua",
      -- ["luft.update"]  = "lib/luft-action/update.lua",
      -- ["luft.clean"]   = "lib/luft-action/clean.lua",
   },
   install = {
      bin = {
         luft = "bin/luft.lua"
      }
   },
   copy_directories = { }
}
