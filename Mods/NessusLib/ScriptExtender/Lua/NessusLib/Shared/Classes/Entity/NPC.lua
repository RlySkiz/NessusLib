---@class Entity
local Entity = require("NessusLib.Shared.Classes.Entity._Meta")
local Visual = require("NessusLib.Shared.Classes.Entity.Visual")

function Entity:StripNPC()
    if self:IsNPC() then
        __P("striping ", self:UUID())
        local removed = {}
    
        for type,_ in pairs(Definitions.NPCEquipmentVisualSlots) do
            
            local removedEntry = Visual.removeVisualSetBySlot(entity, type)
            table.insert(removed, removedEntry)
            print("removing ", type)
        end
        Visual.Replicate(entity)

        local payload = {uuid = entity.Uuid.EntityUuid}
        Ext.Net.BroadcastMessage("BG3SX_NPCStrip",Ext.Json.Stringify(payload))
        return removed
    end
end


function Entity:RedressNPC(toBeRestored)
    if Ext.IsServer() then
        for _,entry in pairs(toBeRestored) do
            Visual.addVisualSetSlot(entity, entry)
        end

        Visual.Replicate(entity)

        Event:GetOrCreate("SendNPCDress"):Broadcast(self:UUID())
    elseif Ext.IsClient() then
        Event:GetOrCreate("RequestNPCDress"):SendToServer(self:UUID())
    end
end
Event:GetOrCreate("RequestNPCDress"):SetHandler(function()
    Entity:RedressNPC()
end)

----------------------------------------------------------------------------------------------------
-- 
--                        NPC Stripping/Redressing and Genital Application/Removal
-- 
----------------------------------------------------------------------------------------------------

-- USE Entity:IsPlayable TO CHECK IF PLAYABLE


NPC = {}



----------------------------------------------------------------------------------------------------
-- 
-- 								    	Stripping
-- 
----------------------------------------------------------------------------------------------------


---@param entity EntityHandle
---@return table
function NPC.StripNPC(entity)

    print("striping ", entity.Uuid.EntityUuid)

    local removed = {}

    for type,_ in pairs(SLOTS_TO_BE_REMOVED_FOR_SEX) do
        
        local removedEntry = Visual.removeVisualSetBySlot(entity, type)
        table.insert(removed, removedEntry)
        print("removing ", type)
    end

    Visual.Replicate(entity)

    local payload = {uuid = entity.Uuid.EntityUuid}

    Ext.Net.BroadcastMessage("BG3SX_NPCStrip",Ext.Json.Stringify(payload))

    return removed

end

---@param entity EntityHandle
---@param toBeRestored table
function NPC.Redress(entity, toBeRestored)


    for _, entry in pairs(toBeRestored) do
        Visual.addVisualSetSlot(entity, entry)
    end

    Visual.Replicate(entity)

    local payload = {uuid = entity.Uuid.EntityUuid}
    Ext.Net.BroadcastMessage("BG3SX_NPCDress",Ext.Json.Stringify(payload))

end


----------------------------------------------------------------------------------------------------
--  
-- 								    	Genitals
-- 
----------------------------------------------------------------------------------------------------


---@param entity EntityHandle
function NPC.GiveGenitals(entity)

    -- Create Slot for genitals
    Visual.GiveVisualComponentIfHasNone(entity)
    Genital.AddGenitalIfHasNone(entity)

end


-- Remove the genital
---@param  entity EntityHandle 
function NPC.RemoveGenitals(entity)
    local genital = Genital.GetCurrentGenital(entity)
    if genital then
        Visual.BetterRemoveVisualOvirride(entity, genital)
        Visual.Replicate(entity)
    end
end


-- TODO: function giveHair for helmet havers
-- When removing helmer slots, NPCs don't have hair anymore
-- @param           - uuid of the NPC
local function addHairIfNecessary(uuid)
end


-- on closing the game, template changes are yeeted.
-- To restore them, grab the uservars and strip all stripped NPCs
function NPC.RestoreNudity()

    local allNPCs = {}
    local allEntities = Ext.Entity.GetAllEntitiesWithComponent("ServerCharacter")
    for _,entity in pairs(allEntities) do
        if Entity:IsNPC(entity.Uuid.EntityUuid) then
        table.insert(allNPCs, entity)
        end
    end

    for _, npc in pairs (allNPCs) do
        local clothes = SexUserVars.GetNPCClothes(npc)
        --print("checking npc ", npc.Uuid.EntityUuid)
        if clothes then
            print("Stripping ", npc.Uuid.EntityUuid)
            NPC.StripNPC(npc)
            NPC.GiveGenitals(npc)
        end
    end
end


UIEvents.RequestStripNPC:SetHandler(function (payload)
    local entity = Ext.Entity.Get(payload.uuid)
    if not entity then
        Debug.Print(payload.uuid .. " is not an entity")
    end

    local clothes = NPC.StripNPC(entity)
    -- safeguarding against overwriting the saved things with an empty table
    -- in case users strip twice

    local hasEmpty = false
    -- _D(clothes)
    for _,entry in pairs(clothes[1])do
        if (entry.uuid == "") then
            hasEmpty = true
        end
    end

    if hasEmpty == false then
        SexUserVars.SetNPCClothes(clothes, entity)
    end


end)



UIEvents.RequestDressNPC:SetHandler(function (payload)
    local entity = Ext.Entity.Get(payload.uuid)
    if not entity then
        Debug.Print(payload.uuid .. " is not an entity")
    end

    local clothes = SexUserVars.GetNPCClothes(entity)

    if not clothes then
        print("no clothes saved for ", entity.Uuid.EntityUuid)
        return
    end

    NPC.Redress(entity, clothes)
    SexUserVars.SetNPCClothes(nil, entity)
end)


UIEvents.RequestGiveGenitalsNPC:SetHandler(function(payload)
    local uuid = payload.uuid
    local entity = Ext.Entity.Get(uuid)
    NPC.GiveGenitals(entity)
end) 
    
UIEvents.RequestRemoveGenitalsNPC:SetHandler(function(payload)
    local uuid = payload.uuid
    local entity = Ext.Entity.Get(uuid)
    NPC.RemoveGenitals(entity)
end)
