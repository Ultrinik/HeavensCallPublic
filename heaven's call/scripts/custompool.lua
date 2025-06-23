local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

--Add item to the Astral Challenge extra pool
function mod:AddItemToPool(item, weigth, pool)
	if true then
		if item ~= Isaac.GetItemIdByName("​Ophiuchus") then
			print("Warning: HeavensCall:AddItemToPool is deprecated, use itempools.xml")
		end
		return
	end
    item = item or 0
	weigth = weigth or 1
	pool = pool or mod.AstralChallengePoolExtras
    if (tonumber(item) and item > 0) and (tonumber(weigth) and weigth > 0) and (type(pool) == "table") then

		local isThere = false
		for _, entry in ipairs(pool) do
			if item==entry[1] then 
				isThere = true
				break
			end
		end
	
		if not isThere then
			table.insert(pool, {item, weigth})
		end

	else
	end

end

local astralPlanetChance = 0.65
--Item pool in room
function mod:GetAstralCollectible()
	if rng:RandomFloat() <= astralPlanetChance then
		return game:GetItemPool():GetCollectible(ItemPoolType.POOL_PLANETARIUM, false)
	else
		return game:GetItemPool():GetCollectible(Isaac.GetPoolIdByName("astral HC"), false)
	end
end
function mod:RerollAstralPool()
	local room = game:GetRoom()
	if rng:RandomFloat() <= astralPlanetChance then
		room:SetItemPool(ItemPoolType.POOL_PLANETARIUM)
	else
		room:SetItemPool(Isaac.GetPoolIdByName("astral HC"))
	end
end

function mod:OnPreGetCollectible(poolType, decrese, seed)
	--things
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	if mod:IsRoomDescAstralChallenge(roomdesc) then mod:RerollAstralPool()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.OnPreGetCollectible)

function mod:OnPostGetCollectible(item, poolType, decrese, seed)
	if mod.SolarItemsVars.MothershipNeeded then
		if (rng:RandomFloat() < mod.MothershipOverwriteChance) and not (game:GetLevel():GetDimension() == Dimension.DEATH_CERTIFICATE) then
			return mod:GetSomeMissingMothership()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, mod.OnPostGetCollectible)

--table
function mod:GetCustomTableCollectible(pool)
	if not (mod.ModFlags.noPool or mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_CHAOS)) then
		local itemPool = game:GetItemPool()
		--If cant find a collectible that a player doesnt have in 100 tries, just spawn a regular one, the pool is empty
		local newItem = 0
		local rerollFlags = {}
		for i=1, 100 do

			local newItemEntry = pool[mod:RandomInt(1,#pool)]
			local tryCounter = 0
			while (tryCounter < 100) and ( (newItemEntry[2] < rng:RandomFloat()) and not rerollFlags[newItemEntry[1]]) do
				rerollFlags[newItemEntry[1]] = true

				tryCounter = tryCounter + 1
				newItemEntry = pool[mod:RandomInt(1,#pool)]
			end

			newItem = newItemEntry[1]
			local aPLayerHasIt = (mod:SomebodyHasItem(newItem)  or (not itemPool:HasCollectible(newItem) ))
			if not aPLayerHasIt then
				break
			end
			newItem = 0
		end
		return newItem
	end
	return 0
end

--trinekts
function mod:PickTrinketFromTable(pool, _rng)
	_rng = _rng or rng
	local itemPool = game:GetItemPool()

	local trinket = pool[mod:RandomInt(1, #pool, _rng)]
	local counter = 0
	while counter < 100 and (mod:SomebodyHasTrinket(trinket) or (not itemPool:HasTrinket(trinket) )) do
		counter = counter + 1
		trinket = pool[mod:RandomInt(1, #pool, _rng)]
	end
	return trinket
end
