local v = require("validator")
local h = require("helper")

-- print(v.parse_file(arg[1]))
local res, offset = v.read_whitespace("  3", 1)
-- print(dump(res), offset)


local res, offset = v.read_number("1234", 1)
-- print(dump(res), offset)


print("ta1")
local res, offset = v.read_array("[1123]", 1)
print(h.dump(res), offset)

print("ta2")
local res, offset = v.read_array("[1,2]", 1)
print(h.dump(res), offset)

