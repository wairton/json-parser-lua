local symbols = require("symbols")
local M = {}

function M.load(filename)
    local f = io.open(filename, "r")
    local content = f:read('*a')
    f:close()
    return content
end


whitespace_set = {
    [" "]=1,
    ["\n"]=1,
    ["\t"]=1,
    ["\r"]=1
}

function M.read_whitespace(content, start)
    local i = start
    local c = content:sub(i, i)
    while whitespace_set[c] do
        i = i + 1
        c = content:sub(i, i)
    end
    if i ~= start then
        return {t=symbols.WHITESPACE, v=content:sub(start, i - 1), c={}}, i - start
    end
    return nil, nil
end


function read_boolean(content, start)
    return nil
end


function read_null(content, start)
    return nil
end


function M.read_number(content, start)
    -- simplified version, have to improve it later
    match = content:match("^%d+", start)
    if match then
        return {t=symbols.NUMBER, v=match, c={}}, #match
    end
    return nil, nil
end


function M.read_string(content, start)
    local buffer = ""
    local i = start + 1
    local valid = true

    while i < #content do
        local c = content:sub(i, i)
        if c == '"' then
            break
        end
        buffer = buffer .. c
        i = i + 1
    end

    if valid then
        return {t=symbols.STRING, v=buffer, c={}},  #buffer
    end
    return nil, nil
end


function M.read_array(content, start)
    -- it only reads array of numbers for now
    local i = start + 1
    local node = {t=symbols.ARRAY, v=0, c={}}
    local open = false
    ::continue::
    while i <= #content do
        local cnode, offset = M.read_whitespace(content, i)
        if cnode then
            i = i + offset
            goto continue
        end

        cnode, offset = M.read_number(content, i)

        if cnode then
            table.insert(node.c, cnode)
            i = i + offset
            open = false
            goto continue
        end

        local char = content:sub(i, i)
        if char == "," then
            if open then
                return nil, nil
            end
            open = true
            i = i + 1
            goto continue
        elseif char == "]" then
            if not open then
                return node, i --offset is wrong
            else
                return nil, nil
            end
        else
            return nil, nil
        end
    end
    return nil, nil
end


function read_object(content, start)
    return nil
end



function M.parse_content(content, i)
    local ast = {}

    while i < #content do
        local c = content:sub(i, i)
        local node = nil
        local offset = nil
        if c == '{' then
            node, offset = read_object(content, c)
        elseif c == '[' then
            node, offset = M.read_array(content, i)
            ast = node
        elseif c == '"' then
            node, offset = M.read_string(content, c)
        end
        i = i + 1
    end
    return ast
end


function M.parse_file(filename)
    return M.parse_content(M.load(filename))
end


return M
