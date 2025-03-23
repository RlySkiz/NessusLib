--- Checks if a table contains the specified element.
---@param table table
---@param element any
---@return boolean
function table.contains(table, element)
    if type(table) ~= "table" then
        return false
    end

    if table == nil or element == nil then
        return false
    end

    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

--- Finds the key of the first occurrence of the specified value in the table.
--- @param value any The value to search for.
--- @return any|nil The key of the found value, or `nil` if not found.
function table:findKey(value)
    for k, v in pairs(self) do
        if v == value then
            return k
        end
    end
    return nil
end

--- Finds the index of the specified element in a table.
---@param table table
---@param element any
---@return integer|nil index
function table.indexOf(table, element)
    for index, value in ipairs(table) do
        if value == element then
            return index
        end
    end
    return nil
end

---Checks if table is empty (using next())
---@param tbl table
---@return boolean
function table.isEmpty(tbl)
    if not tbl then return true end
    return next(tbl) == nil
end

---Returns count of associative table's kv pairs
---@param tbl table
---@return integer
function table.count(tbl)
    if not tbl then return 0 end
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

---Shallow copy of table, optionally copies metatable
---@param t table
---@param copyMetatable boolean?
---@return table
function table.shallowCopy(t, copyMetatable)
    local tbl = {}
    for k, v in pairs(t) do
        tbl[k] = v
    end
    if copyMetatable then
        setmetatable(tbl, getmetatable(t))
    end
    return tbl
end

---Deep copy, recursive and updates new metatable to original metatable
---@param t table
---@return table
function table.deepCopy(t)
    if type(t) ~= "table" then return t end

    local mt = getmetatable(t)
    local tbl = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            v = table.deepCopy(v)
        end
        tbl[k] = v
    end

    setmetatable(tbl, mt)
    return tbl
end

---Associative table pairs iterator, returns values sorted based on keys; optional boolean to specify descending order
---Eg. for key, v in table.pairsByKeys(someTable) do
---@param t table
---@param f boolean|function|nil optional descendingOrder boolean OR sorting function
---@return function iterator 
function table.pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    if type(f) == "boolean" then
        if f then
            table.sort(a, function(b,c) return b > c end)
        else
            table.sort(a)
        end
    else
        table.sort(a, f)
    end
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

-- Attempt at alphanumeric sorting, based on https://stackoverflow.com/a/27911647
function table.pairsByKeysNumerically(t, desc) -- FIXME this even work?
    return table.pairsByKeys(t, function(a,b)
        a = tostring(a.N)
        b = tostring(b.N)
        local patt = '^(.-)%s*(%d+)$' -- :thonkers:
        local _,_, col1, num1 = a:find(patt)
        local _,_, col2, num2 = b:find(patt)
        if (col1 and col2) and col1 == col2 then
            return tonumber(num1) < tonumber(num2)
        end
        return desc and a < b or a > b
    end)
end

--- Removes the first occurrence of the specified element from the table.
--- @param element any The element to remove.
--- @return boolean `true` if the element was removed, otherwise `false`.
function table:removeValue(element)
    for i, v in ipairs(self) do
        if v == element then
            table.remove(self, i)
            return true
        end
    end
    return false
end

--- Merges another table into the current table.
--- @param otherTable table The table to merge.
function table:merge(otherTable)
    for _, v in ipairs(otherTable) do
        table.insert(self, v)
    end
end

--- Removes duplicate values from the table in place.
function table:unique()
    local seen = {}
    local i = 1
    while i <= #self do
        if seen[self[i]] then
            table.remove(self, i)
        else
            seen[self[i]] = true
            i = i + 1
        end
    end
end

--- Shuffles the elements of the table randomly.
function table:shuffle()
    for i = #self, 2, -1 do
        local j = math.random(i)
        self[i], self[j] = self[j], self[i]
    end
end

--- Flattens a nested table into a single table.
--- @return table A new table with all nested values flattened.
function table:flatten()
    local result = {}
    local function flattenHelper(t)
        for _, v in ipairs(t) do
            if type(v) == "table" then
                flattenHelper(v)
            else
                table.insert(result, v)
            end
        end
    end
    flattenHelper(self)
    return result
end