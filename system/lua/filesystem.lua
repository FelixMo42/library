function filesystem:str(v)
    if type(v) == "string" then
        return "\""..tostring(v):gsub("\n","\\n"):gsub("\"","\\\"").."\""
    end
    return tostring(v)
end

function filesystem:format(t,b,tables)
    local s = (b or "return")
    s = s.." {"
    local tables = tables or {}
    for k , v in pairs(t) do
        if type(v) == "table" then
            if not tables[v] then
                tables[v] = #tables + 1
                tables[#tables + 1] = v
                s = self:format( v , "local T"..tables[v].." =" , tables).."\n"..s
            end
            s = s.."["..self:str(k).."] = ".."T"..tables[v]..", "
        elseif type(v) ~= "function" then
            s = s.."["..self:str(k).."] = "..self:str(v)..", "
        end
    end
    return s.."}"
end