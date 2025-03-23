--- Splits a string into a table of substrings using a specified delimiter.
---@param self string
---@param delimiter string
---@return table<string>
function string:split(delimiter)
    local result = {}
    local from  = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert( result, string.sub(self, from , delim_from-1))
        from  = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert( result, string.sub(self, from))
    return result
end

--- Trims leading and trailing whitespace
---@return string
function string:trim()
    --jankawhat?
    local trimmed = tostring(self):gsub("^%s*(.-)%s*$", "%1")
    return trimmed
end

--- Replaces all occurrences of a pattern in the string with the given replacement.
--- @param pattern string The pattern to be replaced.
--- @param replacement string The string to replace the pattern with.
--- @return string The modified string with replacements.
function string:replace(pattern, replacement)
    return self:gsub(pattern, replacement)
end

--- Splits the string into lines based on newline characters.
--- @return table<string> A table containing the individual lines.
function string:splitLines()
    local lines = {}
    for line in self:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

--- Checks if the string starts with the specified prefix.
--- @param prefix string The prefix to check for.
--- @return boolean `true` if the string starts with the given prefix, otherwise `false`.
function string:startsWith(prefix)
    return self:sub(1, #prefix) == prefix
end

--- Checks if the string ends with the specified suffix.
--- @param suffix string The suffix to check for.
--- @return boolean `true` if the string ends with the given suffix, otherwise `false`.
function string:endsWith(suffix)
    return self:sub(-#suffix) == suffix
end

-- string.find but not case sensitive
--@param str1 string       - string 1 to compare
--@param str2 string       - string 2 to compare
function string:caseInsensitiveSearch(str2)
    local str1 = string.lower(self)
    str2 = string.lower(str2)
    local result = string.find(str1, str2, 1, true)
    return result ~= nil
end

-- Checks if the substring 'sub' is present within the string 'str'.
---@param sub string 	- The substring to look for.
---@return boolean		- Returns true if 'sub' is found within 'str', otherwise returns false.
function string:contains(sub)
    -- Make the comparison case-insensitive
    local str = self:lower()
    sub = sub:lower()
    return (string.find(str, sub, 1, true) ~= nil)
end


-- Checks if the string is empty or contains only whitespace characters.
---@return boolean		- Returns true if the string is empty or contains only whitespace characters, otherwise returns false.
function string:isUpperCase()
    return self == self:upper()
end