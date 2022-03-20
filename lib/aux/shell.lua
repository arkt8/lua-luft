local shell = {}

-- Call os.execute using a formatted string
---@param command string
---@vararg string
---@return boolean success, integer exitcode
function shell.execute(command, ...)
   return os.execute(command:format(...))
end

-- Execute shell command capturing output
---@param mode string
---@param command string
---@vararg string
---@return string out, boolean ok, number exitcode
-- valid modes are same of file.read
function shell.capture(mode,command,...)
   local p = io.popen(command:format(...))
   local out = p:read(mode)
   local ok, exitcode = p:close()
   return out, ok, exitcode
end

-- Show message and exit program. If environment DEBUG
-- environment variable is set, then shows trace error
---@param msg string
---@vararg string
function shell.error(msg,...)
   if os.getenv('DEBUG') then error(msg:format(...)) end
   io.stderr:write(msg:format(...).."\n")
   os.exit(1)
end


return shell
