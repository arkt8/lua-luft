local str = require "aux.string"

do -- luft.string.split
   -- Separator as space should result in 3 items
   local s1 = "testA testB testC"
   local r1 = str.split(s1,' ')
   assert(r1[1] == "testA")
   assert(r1[2] == "testB")
   assert(r1[3] == "testC")
   assert(#r1 == 3)

   -- Separator as pattern "." should create an entry
   -- for every no char, i.e. between chars+before+end
   local r2 = str.split(s1,'.')
   for i=#r2,1,-1 do
      assert(r2[i] == "")
   end
   assert(#r2 == #s1 + 1)

   -- Separator as pattern "s." should create pieces
   -- from any non "st" parts
   local r3 = str.split(s1,'st')
   assert(r3[1] == "te")
   assert(r3[2] == "A te")
   assert(r3[3] == "B te")
   assert(r3[4] == "C")
   assert(#r3 == 4)
end
