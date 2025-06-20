local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local REPLACE_CHANCE = 0.1

local getPoopVariant = function ()
    --                   		NORMAL  RED     CORN    GOLDEN  RAINBOW     BLACK   HOLY
    local poopChain     = 		{32,  	6,		4,		0.5,		0.5,		    4,		1}
    if Isaac.GetPersistentGameData():Unlocked(Achievement.CHARMING_POOP) then
        table.insert(poopChain, 2)
    end
    poopChain = mod:NormalizeList(poopChain)

    local poop
	local sum = 0
	local roll = rng:RandomFloat()
	for index, chance in ipairs(poopChain) do
		sum = sum + chance
		if roll <= sum then
			poop = index
			break
		end
	end

    if poop == 1 then
        return GridPoopVariant.NORMAL
    elseif poop == 2 then
        return GridPoopVariant.RED
    elseif poop == 3 then
        return GridPoopVariant.CORN
    elseif poop == 4 then
        return GridPoopVariant.GOLDEN
    elseif poop == 5 then
        return GridPoopVariant.RAINBOW
    elseif poop == 6 then
        return GridPoopVariant.BLACK
    elseif poop == 7 then
        return GridPoopVariant.HOLY
    elseif poop == 8 then
        return GridPoopVariant.CHARMING
    end

end

function mod:OnClayBrickNewRoom()
    if mod:SomebodyHasTrinket(mod.Trinkets.ClayBrick) then
        mod:scheduleForUpdate(function ()
            local room = game:GetRoom()
            local chance = 1 - (1 - REPLACE_CHANCE)^mod:HowManyTrinkets(mod.Trinkets.ClayBrick)

            if room:IsFirstVisit() then
                local gridSize = room:GetGridSize()
                for index = 0, gridSize do
                    local grid = room:GetGridEntity(index)
                    if grid and (grid:GetType() == GridEntityType.GRID_ROCK or grid:GetType() == GridEntityType.GRID_ROCKB or grid:GetType() == GridEntityType.GRID_LOCK or grid:GetType() == GridEntityType.GRID_PILLAR or grid:GetType() == GridEntityType.GRID_ROCK_SPIKED) then
                        if rng:RandomFloat() < chance then
                            room:RemoveGridEntity(index, 0, false)
                            mod:scheduleForUpdate(function ()
                                room:SpawnGridEntity(index, GridEntityType.GRID_POOP, getPoopVariant(), grid:GetRNG():GetSeed(), 0)
                            end, 1)
                            sfx:Stop(SoundEffect.SOUND_ROCK_CRUMBLE)
                        end
                    end
                end
            end
        end, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnClayBrickNewRoom)
