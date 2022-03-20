-- Command line action for start Luft directory
local start = {}
local options = {
   ['--lua-version'] = true,
   ['--help']        = false
}

local luft = require "luft"
local sh   = require "aux.shell"

function start.run(args)
   local cfg = luft.configure(options,args)
   local luacmd, luaver = luft.lua(cfg.opt["--lua-version"] and cfg.opt['--lua-version'][1])

   if cfg:has_dependencies() then
      sh.error("A configuration already exists, try to run 'luft update "..cfg.dir.."'")
   end

   if not sh.execute('mkdir -p %q',cfg.envdir) then
      sh.error("Couldn't create %q",cfg.envdir)
   end

   local luarockscmd = table.concat{
      'cd %q',
      '&& luarocks init --lua-version %q',
      '&& rm -rf *rockspec .*rockspec',
   }
   if not sh.execute(luarockscmd,cfg.envdir,luaver) then
      sh.error("Couldn't initialize luarocks for Lua %q under %q",luaver,cfg.envdir)
   end

   cfg:create(luacmd,luaver)
end

return start
