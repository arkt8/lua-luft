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
---@returns string, boolean
function stripoption(str)
   local s,m = str:gsub('^%-%-*([^%-])','%1')
   return s, m > 0
end


---@param spec table
---@param arglist table|nil
---@return table
-- Parse and get command line options
--
-- Schema example for cli.args usage
-- spec = { flag    = false     -- no value
--        , option  = true      -- has value
--        , choice  = {"a","b"} -- value must be one a or b
--        , list    = {}        -- can occur more than once
--        }
-- Characteristics:
-- * Note that the specs enforce which arguments can be used
--   avoiding user to put inexistent arguments
-- * It limits alternatives when used `{choices}` or if
--   they can occurr twice of more when used `{}`
-- * It doesn't check the combination between arguments
--   neither enforce the presence of arguments so you must
--   do it if needed inside your logic
function cli.getopt( spec, arglist )
   arglist = arglist or arg
   local hang, endoptions
   local res = { ["--"] = {} }

   for _,item in ipairs(arglist) do
      item, isoption = stripoption(item)
      if endoptions     then goto value  end
      if isoption then goto option end

   :: value :: --------------------------------------------
      if hang then -- Pending option waiting for a value
         if type(spec[hang]) == "table" then
            if #spec[hang] > 0 then -- only spec={a,b,c}
               if list.contains(spec[ hang ], item) then
                  res[hang] = item
               else
                  shell.error( e_invalid:format( hang ) )
               end
            else -- Only spec={}
               table.insert(res[hang], item)
            end
         else
            res[hang]=item
         end
         hang = nil
      else -- Values that doesn't belong to any option
         table.insert(res["--"], item)
      end
      goto nextarg

   :: option :: -------------------------------------------

      if hang then shell.error( e_needval:format( hang ) ) end
      if item == "--" then
         endoptions = true
         goto nextarg
      end
      if spec[item] == nil then shell.error( e_unknown:format( item )) end

      if spec[item] then
         hang = item
         if type(spec[item]) == "table" and #spec[item] == 0 then
            res[item] = res[item] or {}
         else
            res[item] = false
         end
      else
         res[item] = true
      end

   :: nextarg ::
   end
   return setmetatable(res,{__call=cli.getval})
end

-- Get the values of the call, that doens't are options
---@returns table
function cli.getval(self)
   return self['--']
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
