---@class Entity
local Entity = require("NessusLib.Shared.Classes.Entity._Meta")

function Entity:HasCharacterCreationStats()
	if Helpers.GetPropertyOrDefault(self._entity,"CharacterCreationStats", nil) then return true else return false end
end

function Entity:HasCharacterCreationAppearance()
	if Helpers.GetPropertyOrDefault(self._entity,"CharacterCreationAppearance", nil) then return true else return false end
end