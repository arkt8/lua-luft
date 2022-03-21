local lcli = require 'aux.cli'

local spec = { ['f']   = false
             , ['flag']= false
             , ['o']    = true
             , ['opt'] = true
             , ['opte']= true
             , ['s']    = {'a','b','c'}
             , ['set'] = {'a','b','c'}
             , ['list']= {}
             , ['l']    = {}
             }

do
   local res = lcli.getopt( spec, {
      '-f',
      '--flag',
      '-o','oval',
      '--opt','optval',
      '--opte','opt1', '--opte','opt2',
      '-s','b',
      '--set','a',
      '-l','first', '-l','second',
      '--list','1st', '--list','2nd'
   })
   assert(res.f       == true,     'Short flag')
   assert(res.flag    == true,     'Long flag')
   assert(res.o       == 'oval',   'Short opt')
   assert(res.opt     == 'optval', 'Long opt')
   assert(res.opte    == 'opt2',   'Long opt twice')
   assert(res.s       == 'b',      'Short choice')
   assert(res.set     == 'a',      'Long choice')

   assert(
      res.l[1] == 'first' and res.l[2] == 'second',
      'Short list'
   )
   assert(
      res.list[1] == '1st' and res.list[2] == '2nd',
      'Long list'
   )
end

do
   local args = {'-o','any','text','values'}
   local res = lcli.getopt(spec, args)
   assert(res.o == 'any',    'Short opt')
   assert(res['--'][1] == 'text',   'Fst value')
   assert(res['--'][2] == 'values', 'Snd value')
   assert(res['--'] == res(),'Values as call return')
   assert(res()[1] == 'text','Fst value by call return')
   assert(res()[2] == 'values','Snd value by call return')
end

print('Passed', arg[0])
