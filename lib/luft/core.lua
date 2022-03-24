-- Core handler of Luft CLI
local luft = {}
local config = {}
local select_dir, select_lua, validate_lua_version

local cli  = require "aux.cli"
local path = require "aux.path"
local sh   = require "aux.shell"

---@param  target string
---@return string target_path
function select_dir(target)
   if not target then
      return sh.error("target directory not specified")
   end
   if not path.isdir(target) then
      return sh.error(("target desn't exists: %q"):format(target))
   end
   return path.realpath(target)
end

---@param ver string
---@return string interpreter, string version
function luft.lua(ver)
   local cmd, res
   if ver and not validate_lua_version(ver) then
      sh.error(("Invalid Lua version: %q"):format(ver))
   end
   cmd = sh.capture("l","which lua%s",ver and ver or "")
   if cmd then
      res = sh.capture("l","%q -e 'print(_VERSION)'",cmd)
      res = res and res:gsub('^Lua (%d%.%d).*','%1')
   end
   if ver then
      return cmd, res
   end
   return luft.lua(res)
end

---@param luaver string
---@return string|nil
function validate_lua_version(luaver)
   return luaver:match("^%d%.%d$")
end

---@return boolean
function config:has_dependencies()
   return path.isfile(self.depsfile)
end

local tpl_deps = [[
-- Don't edit this file manually, it is regenerated by Luft.
-- Add dependency with:    ./run luarocks install <package>
-- Remove dependency with: ./run luarocks remove <package>
luacmd = %q
luaver = %q
dependencies = {
%s
}]]

local tpl_rockspec = [[
package = "luftfolder"
version = "pinned-0"
source  = { url = "" }
build   = { type = "builtin", modules = {} }
dependencies = { %s }
]]


-- TODO
local function write_deps(deplist)
   local deps = {}
   for _,v in deplist do
         ---
   end
end

-- TODO
function config:getdeps()
   self.deps={}
   local fn,err = loadfile(self.depsfile,'t',self.deps)
   if not fn or type(fn) ~= "function" then
      sh.error('Error loading dependencies from %q',self.depsfile)
   end
   fn()
   return self.deps()
end

-- TODO
function config:setdeps()
   local fn,err = loadfile(self.spec)
end


---@param luacmd string
---@param luaver string
---@return nil
-- This should be called only by luft.setup.
-- It creates luarocks rockspec and deps.cfg.
-- If some error occurs it exits the program.
function config:create(luacmd,luaver)
   local depsh, spech
   local e_text="Error writing %q"
   local luadep = '"lua '..luaver..'"'

   depsh = io.open(self.depsfile,'w')
   spech = io.open(self.spec,'w')

   if not depsh  then sh.error(e_text,self.depsfile) end
   if not spech then sh.error(e_text,self.specfile) end

   depsh:write( tpl_deps:format(luacmd,luaver,luadep) )
   spech:write( tpl_rockspec:format(luadep) )
end

function luft.configure(target)
   target = select_dir(target)
   config.target = target
   config.depsfile = target..'/deps.cfg'
   config.envdir = target..'/.env'
   config.spec = config.envdir..'/luftfolder-pinned-0.rockspec'
   return config
end

return luft



