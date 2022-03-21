-- Command line action for start Luft directory
local start = {}
local options = {
   ['lua-version'] = true,
   ['help'] = false
}

local luft = require "luft"
local cli =  require "aux.cli"
local sh   = require "aux.shell"
local path = require "aux.path"

local tpl_init = [[
-- This file is the entrypoint for your Lua program.
-- It works exactly like a module.
local init={}

-- This function will be called when you run
-- `./run` or `./run run`
function init.run(args)
   for i,v in ipairs(args) do print(i,v) end
end

-- This function will be called when you run
-- `./run help`
function init.help()
   print"fill here with some  useful help"
end

return init
]]

function start.run(args)
   local opt = cli.getopt(options,args)
   local cfg = luft.configure(opt()[1])
   local luacmd, luaver = luft.lua(opt['lua-version'])

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

   local customprogram = cfg.target..'/init.lua'
   if not path.isfile(customprogram) then
      io.open(customprogram,"w"):write(tpl_init)
   end
end

return start
