---@class Entity
local Entity = require("NessusLib.Shared.Classes.Entity._Meta")

if Ext.IsServer() then

    -- Gets a table of equipped items
    ---@return table        - Collection of every equipped items
    function Entity:GetEquipment()
        local currentEquipment = {}
        for _,slotName in ipairs(Definitions.EquipmentSlots) do
            local gearPiece = Osi.GetEquippedItem(self:UUID(), slotName)
            if gearPiece then
                currentEquipment[#currentEquipment+1] = gearPiece
            end
        end
        return currentEquipment
    end

    -- Check if an entity has any equipment equipped
    ---@param uuid      string  - The entity UUID to check
    ---@return boolean    - Returns either true or false
    function Entity:HasEquipment(uuid)
        if self:GetEquipment() then
            return true
        end
        return false
    end

    -- Unequips all equipment from an entity
    ---@return table   - Collection of every previously equipped item
    function Entity:UnequipAll()
        --Osi.SetArmourSet(uuid, 0)

        local oldEquipment = {}
        for _, slotName in ipairs(Definitions.EquipmentSlots) do
            local gearPiece = Osi.GetEquippedItem(self:UUID(), slotName)
            if gearPiece then
                Osi.LockUnequip(gearPiece, 0)
                Osi.Unequip(self:UUID(), gearPiece)
                oldEquipment[#oldEquipment+1] = gearPiece
            end
        end
        return oldEquipment
    end

    -- Re-equips all equipment of an entity
    ---@param entity      string    - The entity UUID to equip
    ---@param armorset  ArmorSet    - The entities prior armorset
    ---@paran slots table -  Format: {uuid = entry.VisualResource, index = i}
    function Entity:Redress(oldArmourSet, oldEquipment, slots)
        if oldArmourSet and (type(oldArmourSet) == "number") then
            Osi.SetArmourSet(self:UUID(), oldArmourSet)
        end

        if oldEquipment then
            for _, item in ipairs(oldEquipment) do
                Osi.Equip(self:UUID(), item)
            end
        end

        oldArmourSet = nil
        oldEquipment = nil

        if slots then 
            local actualEntity = self._entity
            if not actualEntity then
                print("is not an entity ", self:UUID())
            end

            Entity:RedressNPC(slots) 
        end
    end

elseif Ext.IsClient() then

end