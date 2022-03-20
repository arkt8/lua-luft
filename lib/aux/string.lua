local M = {}

-- Split an string in a list using Lua patterns
---@param str string
---@param pattern string
---@return table
function M.split(str, pattern)
   local pieces={}
   if pattern == "" then
      for i=1, #str, 1 do pieces[i] = str:sub(i, i) end
      return pieces
   end

   local idx,p0,p1,p2 = 1,1,nil,nil
   repeat
      p1,p2 = str:find(pattern, p0)
      pieces[idx] = str:sub(p0, (p1 and p1-1))
      idx, p0 = idx + 1, p2 and p2 + 1
   until not p1 or p1 > p2
   return pieces
end

return M
