---@class Entity: MetaClass
---@field _entity EntityHandle
local Entity = _Class:Create("Entity", nil, {
})

local EntityMeta = {
    __index = function(self, key)
        return rawget(self, key) or rawget(self._entity, key)
    end,
}

--- Gets an entity and wraps it in a custom metatable
---@param uuidOrHandle string|EntityHandle - The entity UUID to get and wrap
---@return Entity - The wrapped entity with custom methods
function Entity.Get(uuidOrHandle)
    local entity

    -- Check if input is a valid UUID
    if type(uuidOrHandle) == "string" and Helpers.IsValidUUID(uuidOrHandle) then
        entity = Ext.Entity.Get(uuidOrHandle)
    else
        -- If it's not a valid UUID, assume it's an EntityHandle
        entity = uuidOrHandle
    end
    
    -- Create a new table to wrap the entity
    local wrappedEntity = {
        _entity = entity,  -- Store the original entity in a field
    }

    setmetatable(wrappedEntity, EntityMeta)
    return wrappedEntity
end

function Entity:UUID()
    if self._entity and self._entity.Uuid and self._entity.Uuid.EntityUuid then
        return self._entity.Uuid.EntityUuid
    end
end

-- To ensure the wrapped entity is up-to-date:
function Entity:Refresh()
    self._entity = Ext.Entity.Get(self:UUID())  -- Re-fetch and re-wrap
end

-- Tries to get the value of an entities component
---@param previousComponent any|nil       - component of previous iteration
---@param components        table       - Sorted list of component path
---@return any                        - Returns the value of a field within a component
---@example
-- Entity:TryGetEntityValue("UUID", nil, {"ServerCharacter, "PlayerData", "HelmetOption"})
-- nil as previousComponent on first call because it iterates over this parameter during recursion
function Entity:TryGetEntityValue(previousComponent, components)
    if #components == 1 then -- End of recursion
        if not previousComponent then
            local value = Helpers.GetPropertyOrDefault(self._entity, components[1], nil)
            return value
        else
            local value = Helpers.GetPropertyOrDefault(previousComponent, components[1], nil)
            return value
        end
    end

    local currentComponent
    if not previousComponent then -- Recursion
        currentComponent = Helpers.GetPropertyOrDefault(self._entity, components[1], nil)
        -- obscure cases
        if not currentComponent then
            return nil
        end
    else
        currentComponent = Helpers.GetPropertyOrDefault(previousComponent, components[1], nil)
    end

    table.remove(components, 1)

    -- Return the result of the recursive call
    return self:TryGetEntityValue(currentComponent, components)
end

---@param entityArg any
local function resolveEntityArg(entityArg)
    if entityArg and type(entityArg) == "string" then
        local e = Ext.Entity.Get(entityArg)
        if not e then
            -- _P("[BG3SX][Entity.lua] resolveEntityArg: failed resolve entity from string '" .. entityArg .. "'")
        end
        return e
    end
    return entityArg
end

--- Tries to copy an entities component to another entity
---@param uuid_1    string          - Source Entities UUID
---@param uuid_2    string          - Target Entities UUID
---@param componentName string      - Component to copy
function Entity.TryCopyEntityComponent(uuid_1, uuid_2, componentName)
    local srcEntity = Ext.Entity.Get(uuid_1)
    local trgEntity = Ext.Entity.Get(uuid_2)

    -- Find source component
    srcEntity = resolveEntityArg(srcEntity)
    if not srcEntity then
        return false
    end
    local srcComponent = srcEntity[componentName]
    if not srcComponent then
        return false
    end

    -- Find dest component or create if not existing
    trgEntity = resolveEntityArg(trgEntity)
    if not trgEntity then
        return false
    end
    local dstComponent = trgEntity[componentName]
    if not dstComponent then
        trgEntity:CreateComponent(componentName)
        dstComponent = trgEntity[componentName]
    end

    -- Copy stuff
    if componentName == "ServerItem" then
        for k, v in pairs(srcComponent) do
            if k ~= "Template" and k ~= "OriginalTemplate" then
                Helpers.TryToReserializeObject(dstComponent[k], v)
            end
        end
    else
        local serializeResult = Helpers.TryToReserializeObject(srcComponent, dstComponent)
        if serializeResult then
            __P("TryCopyEntityComponent, with component: " .. componentName)
            __P("Serialization fail")
            __P("Result: " .. serializeResult)
            return false
        end
    end

    if componentName ~= "ServerIconList" and componentName ~= "ServerDisplayNameList" and componentName ~= "ServerItem" then
        trgEntity:Replicate(componentName)
    end
    return true
end

if Ext.IsServer() then    
    --- Checks if entity is playable (PC or companion)
    ---@return boolean - Returns either 1 or 0
    function Entity:IsPlayable()
        return Osi.IsTagged(self:UUID(), "PLAYABLE_25bf5042-5bf6-4360-8df8-ab107ccb0d37") == 1
    end

    -- NPCs don't have CharacterCreationStats
    function Entity:IsNPC()
        local E = Helpers.GetPropertyOrDefault(self._entity,"CharacterCreationStats", nil)
        if E then
            return false
        else
            return true
        end
    end

    -- Toggles Movement
    function Entity:ToggleMovement()
        if Osi.HasAppliedStatus(self:UUID(), "ActionResourceBlock(Movement)") == 1 then
            Osi.RemoveBoosts(self:UUID(), "ActionResourceBlock(Movement)", 0, "", "")
        else
            Osi.AddBoosts(self:UUID(), "ActionResourceBlock(Movement)", "", "")
        end
    end

    -- Toggles WalkTrough
    function Entity:ToggleWalkThrough()
        if Osi.HasAppliedStatus(self:UUID(), "CanWalkThrough(true)") then
            Osi.AddBoosts(self:UUID(), "CanWalkThrough(false)", "", "")
        else
            Osi.AddBoosts(self:UUID(), "CanWalkThrough(true)", "", "")
        end
    end

elseif Ext.IsClient() then

end

return Entity