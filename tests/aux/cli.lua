local lcli = require 'aux.cli'
local spl = (require 'aux.string').split

local spec = { ['-f']    = false
             , ['--flag']= false
             , ['-o']    = true
             , ['--opt'] = true
             , ['-s']    = {'a','b','c'}
             , ['--set'] = {'a','b','c'}
             }

do
   local res = lcli.getopt( spec, {
      '-f','--flag',
      '-o','oval', '--opt','optval',
      '-s','b','--set','a'
   })
   assert(res['-f']       == true,     'Short flag')
   assert(res['--flag']   == true,     'Long flag')
   assert(res['-o'][1]    == 'oval',   'Short opt')
   assert(res['--opt'][1] == 'optval', 'Long opt')
   assert(res['-s'][1]    == 'b',      'Short choice')
   assert(res['--set'][1] == 'a',      'Long choice')
end

do
   local args = {'-o','any','text','values'}
   local res = lcli.getopt(spec, args)
   assert(res['-o'][1] == 'any',    'Short opt')
   assert(res['--'][1] == 'text',   'Fst value')
   assert(res['--'][2] == 'values', 'Snd value')
end

print('Passed', arg[0])
