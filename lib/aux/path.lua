-- Functions related to path handling
local M = {}
local shell = require "aux.shell"

---@param dir string
---@param recursive boolean
---@return boolean success, integer exitcode
function M.mkdir(dir,recursive)
   return shell.execute(
      "mkdir %s %q",
      recursive and "-p" or "",
      dir
   )
end

---@param name string
---@return string basename
function M.basename(name)
   return name:gsub("^.*/","")
end

---@param name string
---@return string dirname
function M.dirname(name)
   return name:gsub("/[^/]*$","")
end

---@param path string
---@return string name, boolean success, number exitcode
function M.realpath(name)
   return shell.capture("l", "realpath %q",name)
end

---@param path string
---@return boolean
-- check if the path exists and/or is accessible. If path
-- exists but can't be accessed due to permissions the
-- expected return is false
function M.exists(path) return (os.rename(path,path)) end

---@param path string
---@return boolean
function M.isdir(path) return M.exists(path.."/") end

---@param path string
---@return boolean
function M.isfile(path) return (io.open(path,"r")) end

return M
