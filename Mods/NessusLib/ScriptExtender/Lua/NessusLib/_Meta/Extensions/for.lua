--- Iterates over the keys of a table in sorted (ascending) order.
--- This function sorts the table keys and returns them in the order specified by the `table.sort` function.
--- @param t table The table to iterate over.
--- @return fun():string|number, any A function that returns the next key-value pair in sorted order.
function sortedPairs(t)
    local keys = {}
    for key in pairs(t) do
        table.insert(keys, key)
    end
    table.sort(keys)  -- Sort the keys in ascending order
    local i = 0
    return function()
        i = i + 1
        local key = keys[i]
        if key then
            return key, t[key]
        end
    end
end

--- Iterates over the keys of a table in reverse order.
--- This function collects the table keys and iterates them in reverse order.
--- @param t table The table to iterate over.
--- @return fun():string|number, any A function that returns the next key-value pair in reverse order.
function reversePairs(t)
    local keys = {}
    for key in pairs(t) do
        table.insert(keys, key)
    end
    local i = #keys + 1
    return function()
        i = i - 1
        local key = keys[i]
        if key then
            return key, t[key]
        end
    end
end

--- Iterates over a table (array) with an explicit index.
--- This function returns both the index and the value of each element in the array.
--- @param t table The array to iterate over.
--- @return fun():integer, any A function that returns the index and value of each element in the array.
function ipairsWithIndex(t)
    local i = 0
    return function()
        i = i + 1
        if t[i] then
            return i, t[i]
        end
    end
end

--- Iterates over the key-value pairs of a table, filtering by the type of the value.
--- This function only returns pairs where the value matches the specified type.
--- @param t table The table to iterate over.
--- @param typeFilter string The type to filter by (e.g., "string", "number").
--- @return fun():string|number, any A function that returns the next key-value pair where the value matches the specified type.
function pairsByType(t, typeFilter)
    return function()
        for key, value in pairs(t) do
            if type(value) == typeFilter then
                return key, value
            end
        end
    end
end

--- Iterates over the key-value pairs of a table, filtering based on a custom condition.
--- This function only returns pairs where the key-value pair meets the condition defined by the provided function.
--- @param t table The table to iterate over.
--- @param condition fun(key:any, value:any):boolean The function to test each key-value pair.
--- @return fun():string|number, any A function that returns the next key-value pair that satisfies the condition.
function filterPairs(t, condition)
    return function()
        for key, value in pairs(t) do
            if condition(key, value) then
                return key, value
            end
        end
    end
end

--- Iterates over a table in chunks of a specified size.
--- This function splits the table into sub-tables (chunks) of the specified size and yields each chunk.
--- @param t table The table to iterate over.
--- @param size number The size of each chunk.
--- @return fun():table A function that returns the next chunk of the table.
function chunk(t, size)
    local i = 0
    return function()
        i = i + 1
        local startIndex = (i - 1) * size + 1
        local endIndex = i * size
        local chunk = {}
        for j = startIndex, endIndex do
            if t[j] then
                table.insert(chunk, t[j])
            end
        end
        return #chunk > 0 and chunk or nil
    end
end


--- Generates a sequence of numbers from `start` to `stop` with an optional `step`.
--- This function can be used to iterate over a range of numbers, similar to the `for` loop range in other languages.
--- @param start number The starting number of the range.
--- @param stop number The end number of the range.
--- @param step? number The step between each number (defaults to 1 if not provided).
--- @return fun():number|nil A function that returns the next number in the range.
function range(start, stop, step)
    step = step or 1
    local current = start - step
    return function()
        current = current + step
        if current <= stop then
            return current
        end
    end
end

--- Iterates over the key-value pairs of a table, filtering by the value.
--- This function returns pairs where the value matches the specified filter.
--- @param t table The table to iterate over.
--- @param valueFilter any The value to filter by.
--- @return fun():string|number, any A function that returns the next key-value pair where the value matches the filter.
function pairsByValue(t, valueFilter)
    return function()
        for key, value in pairs(t) do
            if value == valueFilter then
                return key, value
            end
        end
    end
end

--- Iterates over the values of a table and applies a function to each value.
--- This function is useful for performing operations on each element in the table without needing to return anything.
--- @param t table The table to iterate over.
--- @param func fun(value:any):void The function to apply to each value.
--- @return fun():void A function that applies the specified function to each value in the table.
function each(t, func)
    local i = 0
    return function()
        i = i + 1
        if t[i] then
            func(t[i])
        end
    end
end

--- Iterates over the key-value pairs of a table, sorted by key in descending order.
--- This function sorts the key-value pairs by key and iterates them in descending order.
--- @param t table The table to iterate over.
--- @return fun():string|number, any A function that returns the next key-value pair sorted by key in descending order.
function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

--- Iterates over the key-value pairs of a table, sorted by value in descending order.
--- This function sorts the key-value pairs by value and iterates them in descending order.
--- @param t table The table to iterate over.
--- @return fun():string|number, any A function that returns the next key-value pair sorted by value in descending order.
function pairsByValueDescending(t)
    local pairsList = {}
    for key, value in pairs(t) do
        table.insert(pairsList, {key, value})
    end
    table.sort(pairsList, function(a, b) return a[2] > b[2] end)
    local i = 0
    return function()
        i = i + 1
        if pairsList[i] then
            return pairsList[i][1], pairsList[i][2]
        end
    end
end