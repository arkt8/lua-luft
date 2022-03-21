-- Functions related to path handling
local path = {}
local shell = require "aux.shell"

---@param dir string
---@param recursive boolean
---@return boolean success, integer exitcode
function path.mkdir(dir,recursive)
   return shell.execute(
      "mkdir %s %q",
      recursive and "-p" or "",
      dir
   )
end

---@param name string
---@return string basename
function path.basename(name)
   return name:gsub("^.*/","")
end

---@param name string
---@return string dirname
function path.dirname(name)
   return name:gsub("/[^/]*$","")
end

---@param name string
---@return string name, boolean success, number exitcode
function path.realpath(name)
   return shell.capture("l", "realpath %q",name)
end

---@param name string
---@return boolean
-- check if the path exists and/or is accessible. If path
-- exists but can't be accessed due to permissions the
-- expected return is false
function path.exists(name) return (os.rename(name,name)) end

---@param name string
---@return boolean
function path.isdir(name) return path.exists(name.."/") end

---@param name string
---@return boolean
function path.isfile(name) return (io.open(name,"r")) end

return path
