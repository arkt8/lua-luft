local ktypes = {
   string = {"%s%s = ","%s[%q] = "},
   number = "%s%s"
}
local vtypes = {
   string  = "%q",
   boolean = "%s",
   number  = "%s",
   table   = {"{%s%s%s}", table.concat{"{\n%s%s\n%s}"} }
}

-- Local Functions
local stringify


---@param tbl    table
---@param lvl    number|nil
---@param pretty string|nil
---@return string
function stringify(tbl,lvl,pretty)
   lvl = lvl or 0
   local res, tkey, rkey, tval, rval = {}, nil, nil, nil, nil
   local indent = ( pretty or '' ):rep( lvl )

   for key,val in pairs(tbl) do
      tkey, tval = type(key), type(val)
      if not ktypes[tkey] or not vtypes[tval] then goto next_dict_item end

      if tkey == "number" then
         if lvl < 1 then goto next_dict_item end
         rkey = ktypes.number:format(indent,'')
      elseif key:match("^[%l_]+$") then
         rkey = ktypes.string[1]:format(indent,key)
      else
         if lvl == 0 then goto next_dict_item end
         rkey = ktypes.string[2]:format(indent,key)
      end
      if tval == "table" then
         rval = stringify(val, lvl+1, pretty)
         if tkey == "string" then
            rval = (pretty and vtypes.table[2] or vtypes.table[1]):format(indent,rval,indent)
         end
      else
         rval = vtypes[tval]:format(val)
      end
      table.insert(res, rkey..rval)
      :: next_dict_item ::
   end
   return table.concat(res,pretty and ";\n" or ";")
end


---@class aux.luon
-- Handle Lua object/variable notation consisting in
-- tables, numbes, string and booleans.
-- Other datatypes are discarded as well as misformed
-- first level variables (accepts only words)
local luon = {}

---@param filename string
---@return table
function luon.read (filename)
   local res, fn = {}, nil
   fn = loadfile(filename,"t",res)
   if fn then fn() end
   return res
end

---@param filename string
---@return boolean
function luon.write (filename, data, pretty)
   data = stringify(data,0,pretty and "   " or false)
   local f = io.open(filename,"w+")
   f:write(data)
   return f:close()
end

---@param chunk function|string
---@return table
function luon.unserialize(chunk)
   local res = {}
   local fn = load(chunk,'',"t",res)
   if fn then fn() end
   return res
end

---@param data table
---@param pretty boolean
---@return string
function luon.serialize(data,pretty)
   pretty = pretty and '   ' or ''
   return stringify(data,0,pretty and "   " or false)
end

return luon
