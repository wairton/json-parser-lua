local v = require("validator")

-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


-- print(v.parse_file(arg[1]))
local res, offset = v.read_whitespace("  3", 1)
-- print(dump(res), offset)


local res, offset = v.read_number("1234", 1)
-- print(dump(res), offset)


print("ta1")
local res, offset = v.read_array("[1123]", 1)
print(dump(res), offset)

print("ta2")
local res, offset = v.read_array("[1,2]", 1)
print(dump(res), offset)

