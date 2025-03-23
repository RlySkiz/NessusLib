
---@class ConsoleCommand: MetaClass
---@field private _prefix string
---@field private _consoleCommands table<string, string>
---@field SetPrefix fun(prefix:string)
---@field New fun(name:string, fn:function, info:string)
---@field GetAll fun():table<string, string>
ConsoleCommand = _Class:Create("ConsoleCommand", nil, {
    _prefix = "NessusLib",
    _consoleCommands = {}
})

function ConsoleCommand.SetPrefix(prefix)
    ConsoleCommand._prefix = prefix
end

-- Would like to use this to get the function name, but it's not always available
local function getFunctionName()
    local info = debug.getinfo(3, "n")
    if info and info.name then
        return info.name
    end
    return "anonymous"
end

function ConsoleCommand:New(name, fn, info)
    if not name then
        __Warn("Must include name to register a new ConsoleCommand")
        return
    end
    if not fn then
        __Warn("Must include function to register a new ConsoleCommand")
        return
    end

    local prefix = "!" .. tostring(self._prefix) .. "."
    local cmdName = prefix .. name
    if self._consoleCommands[cmdName] then
        __Warn("Console command already exists: " .. cmdName)
        return
    end
    Ext.RegisterConsoleCommand(cmdName, fn)
    if info then
        self._consoleCommands[cmdName] = info
    else
        self._consoleCommands[cmdName] = "No description provided"
    end
    -- __P("Created new console function: " .. cmdName .. "\n- " .. (info or "No description provided"))
end

function ConsoleCommand.GetAll()
    __D(ConsoleCommand._consoleCommands)
    return ConsoleCommand._consoleCommands
end

ConsoleCommand:New("Help", ConsoleCommand.GetAll, "Dumps every available console command")

return ConsoleCommand