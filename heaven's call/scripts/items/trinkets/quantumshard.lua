local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&%####%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%###%%&&&&&&&&&&@@@@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@&#((#%%&&&&&@@@@@@@@@@&&&&&&&&@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#(((#%&&&@@@@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#(((#%&@@@@@@@@@@@@&&%#%%&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%####%&%%%&@@@@@@@@@@@@&&%#%%&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%#(((((#&&&&&&@@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&##(((((####%%&&&@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%###%%&&&&@@&##((%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@@@@@@@&#(#&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&@@@@@&%#%&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%###%%&&&&&&&&@@@@@@&&%#%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%#%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%###%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
mod.SHARD_CHANCE = 0.1333

function mod:QuantumRoll(player)
	local roll = rng:RandomFloat()

	if player:HasTrinket(mod.Trinkets.Shard) then
		return roll < 1-(1-mod.SHARD_CHANCE)^player:GetTrinketMultiplier(mod.Trinkets.Shard)
	else
		return false
	end
end

function mod:QuantumTeleport(player)
	sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1)

	local room = game:GetRoom()

	local position = room:GetRandomPosition(0)
	local i = 0

	local function InvalidTeleport(grid)
		if grid and grid:ToRock() and (grid.State ~= 2) and not player.CanFly then return true end
		if grid and grid:ToPoop() and (grid.State ~= 2) and not player.CanFly then return true end
		if grid and grid:ToPit() and not player.CanFly then return true end
	end

	while InvalidTeleport(room:GetGridEntityFromPos(position)) do
		i=i+1
		position = room:GetRandomPosition(0)
		if i>=100 then break end
	end

	player.Position = position
	player:AnimateTeleport(false)
end

function mod:OnShardNewRoom()
	for _, shard in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.Trinkets.Shard)) do
		shard.Position = game:GetRoom():GetRandomPosition(0)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnShardNewRoom)