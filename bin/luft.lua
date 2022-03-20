#!/bin/env lua-any

local command = arg[1]
local commands = {
   ['start']     = 'Prepare directory to be used',
   ['update']    = 'Update directory according to config',
   ['clean']     = 'Clear set up files from directory'
}

local function help()
   print"Usage: luft command [directory]\n"
   print"Where command is one of the these:\n"
   for i,v in pairs(commands) do
      print((" %s - %s"):format(i,v))
   end
   print""
   os.exit(1)
end


if not commands[command] then help() end

require(
   ("luft.%s"):format(command)
).run(table.pack(table.unpack(arg,2)))
