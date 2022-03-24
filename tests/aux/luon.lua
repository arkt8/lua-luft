local luon = require "aux.luon"

local function assert_structure(o1, o2, path)
   path = path or ''
   local tval
   local subpath
   for k,v in pairs(o1) do
      subpath = path..'/'..k
      local o1type = type(v)
      local o2type = type(o2[k])

      assert(
         o1type == o2type,
         ("DifferentValueTypes at %q: %q != %q"):format(
            subpath, o1type, o2type
         )
      )
      if o1type == "table" then
         assert_structure(v,o2[k],subpath)
      else
         assert(v == o2[k], ("DifferentValues at %q"):format(subpath))
      end
   end
end

do -- Test 1
   -- This test contains all valid values of both, keys and values
   local object = {
      str = "mystring",
      some_table = {
         ststr = "mytext",
         num = 48,
         boo = true,
         list = { 'a','b','c'},
         dict = { lala = 'i', lele=10 },
         sub = { sub = { sub = "x" }},
         ['complex key'] = false,
      }
   }
   local processed = luon.unserialize( luon.serialize(object) )
   assert_structure(object, processed)
end

do
   -- Test 2
   -- This test checks if string creation is ignoring the not accepted
   -- types of values and number indexed values at top of data.
   local object = {
      "number indexed value", -- as 1st level, should be ignored
      fu = function() return 10 end,
      x = "valid"
   }
   local processed = luon.unserialize( luon.serialize( object ) )

   for k,v in pairs(object) do
      local tk, tvo,tvp = type(k), type(v), type(processed[k])
      if tk ~= "string" then
         assert(tvp == "nil", ("Processing1stLevelKeyNotString: %q"):format(k))
      elseif tvo ~= "boolean" and tvo ~= "string" and tvo ~= "number" and tvo ~= "table" then
         assert(tvp == "nil", ("ProcessedValuesOfInvalidType: %q"):format(tvo))
      else
         assert(tvp == tvo, ("DifferentValueTypes at %q:%q != %q"):format(k,tvo,tvp))
      end
   end
end
