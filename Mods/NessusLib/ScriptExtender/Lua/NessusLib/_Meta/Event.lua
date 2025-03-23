---@class Event
---@field private _logging boolean
---@field private New fun(name: string)
Event = {
    _logging = false,
}

function Event.ToggleLogging()
    Event._logging = not Event._logging
end

--- Creates a new event channel and adds a default logging handler.
--- @param name string The name of the new event channel.
function Event:GetOrCreate(name)
    if self[name] then
        __Warn("Event channel '" .. name .. "' already exists.")
        return self[name]
    end

    local channel = Ext.Net.CreateChannel(ModuleUUID, name)
    self[name] = channel

    -- Set default handler for logging
    channel:SetHandler(function(...)
        local args = { ... }
        local event = args[1]
        if Event._logging then
            __P(name .. " received:", event)
        end
    end)
end

return Event