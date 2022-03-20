local list = require 'aux.lists'

local x = {'a','b','c','d','e','f','g','h'}
local xcount = #x

do
   assert(list.contains(x, "b") == true)
   assert(list.contains(x, "i") == false)
end

do
   local l = list.head(x,3)
   assert(#l == 3)
   assert(l[1] == 'a')
   assert(l[2] == 'b')
   assert(l[3] == 'c')
   assert(#x == xcount)
end

do
   local l = list.tail(x,3)
   assert(#l == 3)
   assert(l[1] == 'f')
   assert(l[2] == 'g')
   assert(l[3] == 'h')
   assert(#x == xcount)
end

do
   local unt,aft = list.split(x,4)
   assert(unt[1] == 'a')
   assert(unt[2] == 'b')
   assert(unt[3] == 'c')
   assert(unt[4] == 'd')
   assert(aft[1] == 'e')
   assert(aft[2] == 'f')
   assert(aft[3] == 'g')
   assert(aft[4] == 'h')
   assert(#x == xcount)
end
