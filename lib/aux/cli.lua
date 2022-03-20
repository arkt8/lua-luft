local list = require "aux.lists"
local shell = require "aux.shell"

local cli = {}

local e_needval      = "missing value: %q"
local e_unknown      = "unknown option: %q"
local e_invalid      = "invalid value: %q"
local e_invalidscope = "invalid scope: %q"

-- functions
local isoption

---@param str string
---@returns boolean
function isoption(str)
   local _,stop = str:find("^%-*")
   print(_,stop,str)
   if stop < 1 or stop > 2 then return false end
   return true
end


---@param spec table
---@param arglist table|nil
---@return table
-- Parse and get command line options
--
-- Schema example for cli.args usage
-- spec = { flag    = false
--        , option  = true
--        , choice  = {"a","b"} }
function cli.getopt( spec, arglist )
   arglist = arglist or arg
   local hang, endoptions
   local res = { ["--"] = {} }

   for _,v in ipairs( arglist ) do
      if endoptions     then goto value  end
      if isoption( v ) then goto option end

   :: value :: --------------------------------------------
      if hang then
         if type( spec[hang] ) == "table" then
            if list.contains( spec[ hang ], v ) then
               table.insert( res[hang], v )
            else
               shell.error( e_invalid:format( hang ) )
            end
         else
            table.insert( res[hang], v )
         end
         hang = nil
      else
         table.insert( res["--"], v )
      end
      goto nextarg

   :: option :: -------------------------------------------

      if hang then shell.error( e_needval:format( hang ) ) end
      if v == "--" then
         endoptions = true
         goto nextarg
      end
      if spec[v] == nil then shell.error( e_unknown:format( v )) end

      if spec[v] then
         hang = v
         res[v] = {}
      else
         res[v] = true
      end

   :: nextarg ::
   end
   return res
end

-- Gets the first scope that should preceed arguments
---@param spec table
---@param args table
---@return table
function cli.getscope( spec, args )
   args = args or arg
   if list.contains( spec, args[1] ) then
      return args[1]
   else
      shell.error( e_invalidscope:format(args[1]) )
   end
end

return cli
