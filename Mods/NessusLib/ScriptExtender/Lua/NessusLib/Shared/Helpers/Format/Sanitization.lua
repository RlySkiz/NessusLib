---@class Sanitization: MetaClass
---@field SanitizeFileName fun(str:string):string
local Sanitization = _Class:Create("Sanitization", nil, {
})

-- Removes illegal characters from a filename, and replaces common non-English characters with English equivalents.
-- @param str Filename string to be sanitized.
-- @return Sanitized filename string.
function Sanitization.SanitizeFileName(str)
    -- Replace non-English characters with their English equivalents
    str = string.gsub(str, ".", function(c)
        return Definitions.NonEnglishCharMap[c] or c
    end)
    
    -- Remove control characters and basic illegal characters
    str = string.gsub(str, "[%c<>:\"/\\|%?%*]", "") -- Removes:     < > : " / \ | ? *

    -- Trim whitespace from the beginning and end of the string
    ---@diagnostic disable-next-line: param-type-mismatch
    str = str:trim()
    return str
end

return Sanitization