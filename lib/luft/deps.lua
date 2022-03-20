-- Manages dependencies on luft start and when
-- using ./run luarocks [install|remove]

local deps = {}
local path = require "aux.path"
local sh = require "aux.shell"
local str = require "aux.string"
local luft = require "luft"




function ConfigHandler:dependencies()
   local cfg = {}
   local fn,err = loadfile(self.config_file,'t',cfg)
   if fn then
      fn()
      return cfg.dependencies
   else
      sh.error(err)
   end
end

function deps.get_lua_version()
--   for _,v in ipairs(list) do
--      v = str.split(v:lower(),' +')
--      if v[1] == 'lua' then
--         local op = v[3] and v[2] or '=='
--         local ver = v[3] and v[3] or v[2]
--
--         if op ~= '~=' or op ~= '==' or op ~= '~>' then
--            sh.error(("Use a pinned Lua version instead of %q"):format(table.concat(v,' ')))
--         end
--         if not luft.validate_lua_version(ver) then
--            sh.error(("Invalid Lua version: %q"):format(ver))
--         end
--      end
--   end
end

return deps
