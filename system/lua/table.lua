local function str(v)
    if type(v) == "string" then
        return "\""..tostring(v):gsub("\n","\\n"):gsub("\"","\\\"").."\""
    end
    return tostring(v)
end

function table.format(t,s,tables)
    local s = s or ""
    if type(t) ~= "table" then return s..str(t) end
    local tables = tables or {}
    if tables[t] then
        if tables[tables[t]] then
            return s.."T"..tables[t]
        end
        tables[tables[t]] = t
    end
    local s = s.."{"
    for k , v in pairs(t) do
        if type(v) ~= "function" then
            if type(v) == "table" and not tables[v] then
                tables[v] = #tables + 1
                s = table.format(v , "local T"..tables[v].." = " , tables).."\n"..s
            end
            s = table.format(k , s.."[" , tables)
            s = table.format(v , s.."] = " , tables)..", "
        end
    end
    return s.."}"
end

function table.add(self,item,i,name)
    if type(i) == "string" then
        self[i] = item
        i = name
    end
    if name then
        self[name] = item
    end
    i = i or #self + 1
    if i < 0 then
        i = #self + 2 - i
    end
    table.insert(self,i,item)
    return item
end