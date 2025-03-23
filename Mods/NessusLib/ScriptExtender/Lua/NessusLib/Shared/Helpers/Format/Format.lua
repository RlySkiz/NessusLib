---@class Format: MetaClass
---@field public NonEnglishCharMap table<string, string>
---@field public SanitizeFileName fun(str:string):string
---@field public StringsContainOne fun(str1:string, str2:string):boolean
---@field public StringToTable fun(str:string):table
local Format = _Class:Create("Format", nil, {
    NameGen = require("NessusLib.Shared.Helpers.Format.NameGen"),
    Sanitization = require("NessusLib.Shared.Helpers.Format.Sanitization"),
})

function Format.StringsContainOne(str1, str2)
    return str1:contains(str2) or str2:contains(str1)
end

-- Takes a comma separated string and returns a table of the single entries
-- Example:  "Apple, Orange, Banana, Pear" returns
-- {"Apple","Orange","Banana","Pear"}
---@param str string
---@return table
function Format.StringToTable(str)
    return str:split(",")
end

-- Takes a comma separated string and returns a table of the single entries
-- Example:  "Straight, Lesbian, Vaginal, Anal" returns
-- {"Straight","Lesbian","Vaginal","Anal"}
---@param str string
---@return table
function Format.StringToTable_OLD(str)
    -- Create an empty table to store the results
    local result = {}

    -- Use a pattern to match each value between commas
    for entry in string.gmatch(str, "([^,]+)") do
        -- Trim leading and trailing spaces and insert into the result table
        table.insert(result, entry:match("^%s*(.-)%s*$"))
    end

    return result
end

return Format