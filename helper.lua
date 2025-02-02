local M = {}



function bad_length(o)
    local n = 0
    for _, _ in pairs(o) do
        n = n + 1
    end
    return n
end


function spaces(n, sep)
    sep = sep or "  "
    local buffer = ""
    for _ = 1, n do
        buffer = buffer .. "  "
    end
    return buffer
end


-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function M.dump(o, ident)
   ident = indent or 1
   if type(o) == 'table' then
      local s = '{\n'
      local i = 1
      local lo = bad_length(o)
      local sp = spaces(ident)
      for k, v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. sp ..  k.. ': ' .. M.dump(v, ident + 1)
         if i < lo then s = s .. ', ' end
         i = i + 1
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

return M
