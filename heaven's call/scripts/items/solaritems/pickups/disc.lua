local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local kZeroVector = Vector.Zero

local kDiscDuration = 30 * 60 -- 1 minute

local kMinItemsPerDisc = 3
local kMaxItemsPerDisc = 4

local kMaxItemPickAttempts = 50

local kItemIconsBaseArc = 70
local kItemIconsStartDuration = 100
local kItemIconsDisappearDuration = 60

local wispCache = {}
local itemIcons = {}

local DiscBlacklist = {
	[mod.Items.Saturnus] = true,
	[mod.Items.Mars] = true,
}


local kWhite = Color(1,1,1,0.5,1,1,1)
local kNormal = Color(1,1,1,0.8)
local kInvisible = Color(1,1,1,0)
-- Renders the visuals of items appearing/disappearing.
function mod:discPostRender()
	for k, tab in pairs(itemIcons) do
		if not game:IsPaused() then
			if tab.IsRemoval then
				tab.Vel = mod:Lerp(tab.Vel, kZeroVector, 0.075)
				tab.Sprite.Color = Color.Lerp(kNormal, kInvisible, tab.FrameCount / kItemIconsDisappearDuration)
			elseif tab.FrameCount < kItemIconsStartDuration then
				tab.Vel = mod:Lerp(tab.Vel, kZeroVector, 0.075)
				tab.Sprite.Color = Color.Lerp(kWhite, kNormal, math.min(tab.FrameCount / kItemIconsStartDuration*5, 1))
			else
				tab.Vel = mod:Lerp(tab.Vel, ((tab.Player.Position + tab.Player.Velocity) - tab.Pos):Resized(15), 0.1)
				local t = tab.Player.Position:Distance(tab.Pos) / 100
				t = math.min(math.max(t, 0), 1)
				local targetColor = Color.Lerp(kWhite, kNormal, t)
				tab.Sprite.Color = Color.Lerp(tab.Sprite.Color, targetColor, 0.2)
			end
			tab.Pos = tab.Pos + tab.Vel
			tab.FrameCount = tab.FrameCount + 1
		end
		
		tab.Sprite:Render(Isaac.WorldToScreen(tab.Pos), kZeroVector, kZeroVector)
		
		if tab.FrameCount >= 120*2 or (tab.IsRemoval and tab.FrameCount >= kItemIconsDisappearDuration)
				or (tab.FrameCount >= kItemIconsStartDuration and tab.Player.Position:Distance(tab.Pos) < 10) then
			itemIcons[k] = nil
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.discPostRender)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() itemIcons = {} end)

local function InitializeDiscItemWisp(wisp)
	wisp:AddEntityFlags(EntityFlag.FLAG_NO_QUERY | EntityFlag.FLAG_NO_REWARD)
	wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	wisp.Visible = false
	wisp:RemoveFromOrbit()
	wisp:GetData().isFfDiscWisp = true
	wispCache[wisp.InitSeed] = wisp
end

-- Starts a visual of an item appearing/disappearing.
local function ShowItemIcon(player, itemGfx, angle, isRemoval)
	local sprite = Sprite()
	sprite:Load("gfx/005.100_collectible.anm2", false)
	sprite:Play("ShopIdle")
	sprite:ReplaceSpritesheet(1, itemGfx)
	sprite:LoadGraphics()

	local pos = player.Position
	if not isRemoval then
		pos = pos - Vector(0, 35)
	end
	local vel = Vector.FromAngle(angle + 180) * 5

	table.insert(itemIcons, {
		Sprite = sprite,
		Pos = pos,
		Vel = vel,
		Player = player,
		FrameCount = 0,
		IsRemoval = isRemoval,
	})
end

-- Savedata for which discs are currently active.
local function GetDiscData(player)
	local data = player:GetData().ffsavedata
	if not data.DiscData then
		data.DiscData = {}
	end
	return data.DiscData
end

local function isValidDiscItem(player, itemConfigEntry)
	return itemConfigEntry and itemConfigEntry.ID > 0
			and not DiscBlacklist[itemConfigEntry.ID]
			and itemConfigEntry.Type ~= ItemType.ITEM_ACTIVE
			and (itemConfigEntry.Tags & ItemConfig.TAG_SUMMONABLE ~= 0)
			and (not player:HasCollectible(itemConfigEntry.ID, true))
end

local function pickItemFromPool(player, pool, rng, disc)

	local itemPool = game:GetItemPool()
	local itemConfig = Isaac.GetItemConfig()

	local itemID
	local itemConfigEntry

	local attempts = 0

	while not isValidDiscItem(player, itemConfigEntry) and attempts < kMaxItemPickAttempts do
		local poolType = pool

		itemID = itemPool:GetCollectible(poolType, false, rng:Next())

		itemConfigEntry = itemConfig:GetCollectible(itemID)

		attempts = attempts + 1
	end

	return itemConfigEntry
end

-- Savedata which stores the InitSeeds of item wisps spawned from discs are expected to still exist.
-- Helps take advantage of the fact that item wisps maintain their InitSeed after quit+continue.
local function GetDiscWispRefs()
	local data = FiendFolio.savedata.run
	if not data.DiscWisps then
		data.DiscWisps = {}
	end
	return data.DiscWisps
end

function mod:discItemWispUpdate(wisp)
	local data = wisp:GetData()
	
	if not data.isFfDiscWisp then return end
	
	wisp.Position = Vector(-100, -50)
	wisp.Velocity = kZeroVector
	
	if not GetDiscWispRefs()[""..wisp.InitSeed] then
		-- This disc wisp should no longer exist.
		if wisp.Player and wisp.SubType == CollectibleType.COLLECTIBLE_MARS then
			wisp.Player:TryRemoveNullCostume(NullItemID.ID_MARS)
		end
		wisp:Remove()
		wisp:Kill()
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.discItemWispUpdate, FamiliarVariant.ITEM_WISP)

function mod:OnRetroDiscUse(disc, player, useFlags)

	local discInfo = {
		Pool = Isaac.GetPoolIdByName('retrogradePlanetarium HC'),
		Fallbacks = { CollectibleType.COLLECTIBLE_SAD_ONION }
	}

	--FiendFolio:trySayAnnouncerLine(discLines[disc].Sound, useFlags, discLines[disc].Delay or 30)

	local rng = player:GetCardRNG(disc)

	local pool = discInfo.Pool

	local itemConfig = Isaac.GetItemConfig()
	local wispRefs = GetDiscWispRefs()

	local numItems = kMinItemsPerDisc + rng:RandomInt(kMaxItemsPerDisc - kMinItemsPerDisc + 1)
	local duration = kDiscDuration

	local pickedItems = {}
	local usedFallbacks = 0

	for i=1, numItems do
		local itemConfigEntry = pickItemFromPool(player, pool, rng, disc)

		if not itemConfigEntry then
			usedFallbacks = usedFallbacks + 1

			-- Use a fallback item for this disc.
			local fallbackItem = discInfo.Fallbacks[usedFallbacks] or discInfo.Fallbacks[1]

			if not fallbackItem then break end

			itemConfigEntry = itemConfig:GetCollectible(fallbackItem)
		end

		if itemConfigEntry then
			table.insert(pickedItems, itemConfigEntry)
		end

		if usedFallbacks >= 3 then
			break
		end
	end

	local newWisps = {}

	for i, itemConfigEntry in pairs(pickedItems) do
		-- Display the item that was obtained.
		local angle = 90
		if #pickedItems > 1 then
			local arc = kItemIconsBaseArc
			if #pickedItems > 3 then
				arc = mod:Lerp(kItemIconsBaseArc, 360 - (360 / #pickedItems), (#pickedItems - 3) / (kMaxItemsPerDisc * 2 - 3))
			end
			angle = angle - arc * 0.5 + arc * ((i-1) / (#pickedItems-1))
		end
		ShowItemIcon(player, itemConfigEntry.GfxFileName, angle)

		-- Add the hidden item wisp.
		local wisp = player:AddItemWisp(itemConfigEntry.ID, player.Position)
		InitializeDiscItemWisp(wisp)
		wispRefs[""..wisp.InitSeed] = true
		mod:discItemWispUpdate(wisp)
		newWisps[""..wisp.InitSeed] = itemConfigEntry.ID
	end

	table.insert(GetDiscData(player), {
		Duration = duration,
		Wisps = newWisps,
	})

	sfx:Play(SoundEffect.SOUND_THUMBSUP)

	-- Play the unique disc sound(s).
    local discSfx = FiendFolio.Sounds.BrokenDisc
    if discSfx then
        sfx:Play(discSfx)
    end
end
local RETROGRADE_DISC 		= Isaac.GetCardIdByName("Retrograde Disc")
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnRetroDiscUse, RETROGRADE_DISC)


function mod:OnRetroDiscSpawn(pickup, variant, subType)
	--print("disc", pickup.Variant, Isaac.GetCardIdByName("Treasure Disc"), pickup.SubType, Isaac.GetCardIdByName("Tainted Treasure Disc"))
	if not ((Isaac.GetCardIdByName("Treasure Disc") <= pickup.SubType) and (pickup.SubType <= Isaac.GetCardIdByName("Tainted Treasure Disc"))) then
		return
	end

    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RETROGRADE_DISC)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RETROGRADE_DISC}
end
local RETRO_DISC_CHANCE = 1/18
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Treasure Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Shop Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Boss Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Secret Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Devil Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Angel Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Planetarium Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Chaos Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Broken Disc"), RETROGRADE_DISC})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnRetroDiscSpawn, {nil, RETRO_DISC_CHANCE, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Tainted Treasure Disc"), RETROGRADE_DISC})