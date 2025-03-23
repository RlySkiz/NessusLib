---@class Helpers: MetaClass
---@field Format Format
---@field Math Math
Helpers = _Class:Create("Helpers", nil, {
    Format = require("NessusLib.Shared.Helpers.Format.Format"),
    Math = require("NessusLib.Shared.Helpers.Math.Math")
})

---@return Guid
function Helpers.CreateUUID()
    return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function (c)
        return string.format("%x", c == "x" and Ext.Math.Random(0, 0xf) or Ext.Math.Random(8, 0xb))
    end)
end

---Checks if a given string is a valid UUID (any UUID format, not just v4)
---@param uuid string
---@return boolean
function Helpers.IsValidUUID(uuid)
    local pattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$" --:deadge: lua
    local match = string.match(uuid, pattern)
    return type(match) == "string"
end

-- Function to clean the prefix and return only the ID
---@param uuid string
function Helpers.CleanPrefix(uuid)
    -- Use pattern matching to extract the ID part
    local id = uuid:match(".*_(.*)")

    if not id then
        return uuid
    end
    return id
end

--Credit: Yoinked from Morbyte (Norbyte?)
-- TODO: Description
---@param srcObject any
---@param dstObject any
function Helpers.TryToReserializeObject(srcObject, dstObject)
    local serializer = function()
        local serialized = Ext.Types.Serialize(srcObject)
        Ext.Types.Unserialize(dstObject, serialized)
    end
    local ok, err = xpcall(serializer, debug.traceback)
    if not ok then
        return err
    end
    return nil
end

--- Retrieves the value of a specified property from an object or returns a default value if the property doesn't exist.
-- @param obj           The object from which to retrieve the property value.
-- @param propertyName  The name of the property to retrieve.
-- @param defaultValue  The default value to return if the property is not found.
-- @return              The value of the property if found; otherwise, the default value.
function Helpers.GetPropertyOrDefault(obj, propertyName, defaultValue)
    local success, value = pcall(function() return obj[propertyName] end)
    if success then
        return value or defaultValue
    else
        return defaultValue
    end
end

-- Checks if a number is even
---@param n integer - The number to check
function Helpers.isEven(n)
    return n % 2 == 0
end

-- Checks if a number is odd
---@param n integer - The number to check
function Helpers.isOdd(n)
    return n % 2 ~= 0
end

-- Function to check if not all values are either true or false
---@param data table
---@param bool boolean
function Helpers.NotAllTrueOrFalse(data, bool)
    for _, value in pairs(data) do
        if value == bool then
            return true
        end
    end
    return false
end

--#region Creit: FallenStar  https://github.com/FallenStar08/SharedCode
-- Slightly modified version
---@return table  - Table of all summons, avatars and Origins
function Helpers.GetEveryoneThatIsRelevant()
    local goodies = {}
    local avatarsDB = Osi.DB_Avatars:Get(nil)
    local originsDB = Osi.DB_Origins:Get(nil)
    local summonsDB = Osi.DB_PlayerSummons:Get(nil)

    for _, avatar in pairs(avatarsDB) do
        goodies[#goodies + 1] = avatar[1]
    end

    for _, origin in pairs(originsDB) do
        goodies[#goodies + 1] = origin[1]
    end

    for _, summon in pairs(summonsDB) do
        goodies[#goodies + 1] = summon[1]
    end

    return goodies
end

--#endregion

--- @param e EntityHandle
function Helpers.GetEntityName(e)
    if e == nil then return nil end
    if Ext.Types.GetValueType(e) ~= "Entity" then return nil end

    if e.CustomName ~= nil then
        return e.CustomName.Name
    elseif e.DisplayName ~= nil then
        return Ext.Loca.GetTranslatedString(e.DisplayName.NameKey.Handle.Handle)
    elseif e:HasRawComponent("ls::TerrainObject") then
        return "Terrain"
    elseif e.GameObjectVisual ~= nil then
        return Ext.Template.GetTemplate(e.GameObjectVisual.RootTemplateId).Name
    elseif e.TLPreviewDummy ~= nil then
        return ("TLPreviewDummy:%s"):format(e.TLPreviewDummy.Name == "DUM_" and e.Uuid and e.TLPreviewDummy.Name..e.Uuid.EntityUuid or e.TLPreviewDummy.Name)
    elseif e.Visual ~= nil and e.Visual.Visual ~= nil and e.Visual.Visual.VisualResource ~= nil then
        local name = ""
        if e:HasRawComponent("ecl::Scenery") then
            name = name .. "(Scenery)"
        end
        local visName = "Unknown"
        -- Jank to get last part
        for part in string.gmatch(e.Visual.Visual.VisualResource.Template, "[a-zA-Z0-9_.]+") do
            visName = part
        end
        return name..visName
    elseif e.SpellCastState ~= nil then
        return "Spell Cast " .. e.SpellCastState.SpellId.Prototype
    elseif e.ProgressionMeta ~= nil then
        --- @type ResourceProgression
        local progression = Ext.StaticData.Get(e.ProgressionMeta.Progression, "Progression")
        return "Progression " .. progression.Name
    elseif e.BoostInfo ~= nil then
        return "Boost " .. e.BoostInfo.Params.Boost
    elseif e.StatusID ~= nil then
        return "Status " .. e.StatusID.ID
    elseif e.Passive ~= nil then
        return "Passive " .. e.Passive.PassiveId
    elseif e.InterruptData ~= nil then
        return "Interrupt " .. e.InterruptData.Interrupt
    elseif e.InventoryIsOwned ~= nil then
        return "Inventory of " .. Helpers.GetEntityName(e.InventoryIsOwned.Owner)
    elseif e.Uuid ~= nil then
        return e.Uuid.EntityUuid
    else
        return NameGen:GenerateOrGet(e)
    end
end

-- Returns a table of all summons/followers
---@return table
function Helpers.GetPlayerSummons()
    return Osi.DB_PlayerSummons:Get(nil)
end

---@return EntityHandle|nil
function Helpers.GetLocalControlledEntity()
    __DS(Ext.Entity.GetAllEntitiesWithComponent("ClientControl"))
    for _, entity in pairs(Ext.Entity.GetAllEntitiesWithComponent("ClientControl")) do
        __P(entity.UserReservedFor.UserID)
        if entity.UserReservedFor.UserID == 1 or entity.UserReservedFor.UserID == "1" then
            return entity
        end
    end
end

--#region Credit: Aahz  https://next.nexusmods.com/profile/Aahz07?gameId=3474 - https://i.imgur.com/zfwND3b.gif

---NetMessage user is actually peerid, convert using this
---@param p integer peerid
---@return integer userid
function Helpers.PeerToUserID(p)
    -- all this for userid+1 usually smh
    return (p & 0xffff0000) | 0x0001
end

---Probably unreliable/unnecessary
---@param u integer userid
---@return integer peerid
function Helpers.UserToPeerID(u)
    return (u & 0xffff0000)
end

---Gets a table of entity uuid's for current party
---@return table<string>|nil
function Helpers.GetCurrentParty()
    if Ext.IsServer() then
        local party = Osi.DB_PartyMembers:Get(nil)
        local partymembers = {}
        for k, v in pairs(party) do
            local g = Helper.Object:GetGuid(v[1])
            if g ~= nil then
                table.insert(partymembers, g)
            else
                -- don't count summons...?
                -- Debug.Print("Unable to get party member (%s), remember to delay slightly after party changes.", v[1])
            end
        end
        return partymembers
    else
        local party = Ext.Entity.GetAllEntitiesWithComponent("PartyMember")
        local partyMembers = {}
        for k,v in pairs(party) do
            local g = Helper.Object:GetGuid(v)
            if g ~= nil then
                table.insert(partyMembers, g)
            else
                Debug.Print("Can't get UUID for party member: %s", v)
            end
        end
        return partyMembers
    end
end

--#endregion

function Helpers.GetAllClients()
    local clients = {}
    local partymembers = Ext.Entity.GetAllEntitiesWithComponent("PartyMember")

    for _, partymember in pairs(partymembers) do
        if Ext.Entity.Get(partymember).ClientControl then
            table.insert(clients, partymember)
        end
    end
    return clients
end

function Helpers.Dump(obj, requestedName)
    local data = ""
    local path = ""
    local context = Ext.IsServer() and "S" or "C"
    local objType = Ext.Types.GetObjectType(obj)
    if objType then
        local typeInfo = Ext.Types.GetTypeInfo(objType)
        if objType == "Entity" then
            data = Ext.DumpExport(obj:GetAllComponents())
            local name = Helpers.GetEntityName(obj)
            if not name then
                name = string.format("UnknownEntity%s", Ext.Utils.HandleToInteger(obj))
            end
            path = path..(requestedName or name)
        else
            data = Ext.DumpExport(obj)
            local name = typeInfo and typeInfo.TypeName or "UnknownObj"
            path = path..(requestedName or name)
        end
    else
        if type(obj) == "table" then
            path = path..(requestedName or "Table")
        else path = path..(requestedName or "Unknown")
        end
        data = Ext.DumpExport(obj)
    end
    path = string.format("Scribe/_Dumps/[%s]%s", context, Helpers.Format.SanitizeFileName(path))

    -- Path and data finalized, handle filename taken and overwriting
    local warn = false
    if Ext.IO.LoadFile(path.."_0.json") ~= nil then -- already have file named this
        for i = 1, 9, 1 do
            local test = string.format("%s_%d", path, i)
            if Ext.IO.LoadFile(test..".json") == nil then -- good to go
                __P(string.format("Dumping: %s.json", test))
                return Ext.IO.SaveFile(test..".json", data or "No dumpable data available.")
            end
        end
        warn = true
    end
    if warn then
        __P(string.format("Info: Overwriting previous dump: %s_0.json (10 same-name dumps max)", path))
    end
    __P(string.format("Dumping: %s_0.json", path))
    return Ext.IO.SaveFile(path.."_0.json", data or "No dumpable data available.")
end

---@param func function
---@param delay number|nil
function Helpers.OptionalDelay(func, delay)
    if not delay then
        func()
    else
        Ext.Timer.WaitFor(delay, function() 
            func()
        end)
    end
end

function Helpers.GetModInfo(moduleUUID)
    return Ext.Mod.GetMod(moduleUUID).Info
end
function Helpers.GetModName(moduleUUID)
    return Ext.Mod.GetMod(moduleUUID).Info.Name
end
function Helpers.GetModAuthor(moduleUUID)
    return Ext.Mod.GetMod(moduleUUID).Info.Author
end

return Helpers