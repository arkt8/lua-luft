local lists = {}

-- Check if a list has a value
---@param list table
---@param val any
---@return boolean
function lists.contains( list, val )
   for _,v in ipairs( list ) do
      if v == val then return true end
   end
   return false
end

-- Add subsequent lists values to the first list
---@param list table
---@vararg table
---@return table list
function lists.merge( list, ... )
   for _,l in ipairs{...} do
      table.move( l, 1, #l, #list+1, list )
   end
   return list
end

-- Get first (n) items from (list)
---@param list table
---@param n    integer
---@return table
function lists.head( list, n )
   return table.pack( table.unpack( list, 1, n ) )
end

-- Get last (n) items from (list)
---@param list table
---@param n    integer
---@return table
function lists.tail( list, n )
   return table.pack( table.unpack( list, #list - ( n - 1) ) )
end

-- Split (list) at position (n)
---@param list table
---@param n    integer
---@return table,table
function lists.split( list, n )
   return table.pack( table.unpack( list, 1, n ) ),
          table.pack( table.unpack( list, n + 1 ) )
end

return lists
