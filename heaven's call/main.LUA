HeavensCall = RegisterMod("Heaven's call", 1)
local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()
local json = require("json")

--Some callbacks can't execute certain functions at the time they are execute, so we delay them
function mod:runUpdates(delayedFuncs) --This is from Fiend Folio
    for i = #delayedFuncs, 1, -1 do
        local f = delayedFuncs[i]
        f.Delay = f.Delay - 1
        if f.Delay <= 0 then
            f.Func()
            table.remove(delayedFuncs, i)
        end
    end
end
mod.delayedFuncs = {}
function mod:scheduleForUpdate(foo, delay, callback)
    callback = callback or ModCallbacks.MC_POST_UPDATE
    if not mod.delayedFuncs[callback] then
        mod.delayedFuncs[callback] = {}
        mod:AddCallback(callback, function()
            mod:runUpdates(mod.delayedFuncs[callback])
        end)
    end

    table.insert(mod.delayedFuncs[callback], { Func = foo, Delay = delay })
end

function mod:SaturnUpdateReset()
	
	mod.ModFlags.playerTimestuck = false
	mod.ModFlags.playerTimestuckFlick = false
	mod.ModFlags.playerTimestuckRoomIdx = -1
	mod.ModFlags.playerTimestuckStartFrame = 0
	mod.ModFlags.playerTimestuckEndFrame = 0

end

local isCorrupted = true

mod:scheduleForUpdate(function()
	if isCorrupted then
		print("Heaven's Call Save File Corrupted, trying to fix...")
		mod.savedata = {}
		mod:SaveData(json.encode(mod.savedata))
		
		Isaac.ExecuteCommand("luamod heaven's call")
		Isaac.ExecuteCommand("luamod heaven's call_2839972756")

	else
		print("Heaven's Call Save File Working Properly!")
	end
end, 30)

if mod:HasData() then
	mod.savedata = json.decode(mod:LoadData())
else
	mod.savedata = {}
end
mod.savedataOld = {}

mod:scheduleForUpdate(function()
	isCorrupted = false
end, 15)

include("scripts.roomgen")
include("scripts.roomsdata")


--GLOBAL STUFF----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Colors
mod.Colors = {
	boom = Color(1,1,1,1),
	boom2 = Color(1,1,1,1),
	jupiterShot = Color(2,2,2,1),
	jupiterLaser1 = Color(0.5,0.5,0.5,1),
	jupiterLaser2 = Color(1,1,1,0.95),
	hail = Color(1,1,1,0.9),
	poop = Color(1,1,1,1),
	poop2 = Color(0.5,0.5,0.5,1),
	pee = Color(1,1,1,1),
	ice = Color(1,1,1,0.7),
	frozen = Color(1,1,1,1),
	timeChanged = Color(1,1,1,1),
	timeChanged2 = Color(1,1,1,1),
	fire = Color(1,1,1,1),
	superFire = Color(0.75,0.75,0.75,1),
	buttFire = Color(1,1,1,1),
	mercury = Color(0.3,0.3,0.3,1),
	tar = Color(0.5,0.5,0.5, 1, 0,0,0),
	black = Color(0,0,0,1,0,0,0),
	maw = Color(0.1,0.1,0.1,1,0,0,0),
	ghost = Color(1,1,1,0.6,1,1,1),
	greenEden = Color(0.5,1,0.5,0.6,0.4,1,0.4),
	wax = Color(1,1,1,1,1,0.85,0.8),
	booger = Color(1,1,1,1),
	white = Color(1,1,1,1),
	red = Color(10,0.5,0.5,1),
	red2 = Color(0.8,0,0,1),
	whiteish = Color(1,1,1,1,0.1,0.1,0.1),
	redlight = Color(3,0.75,0.75,1),
	parasite = Color(0.9, 0.3, 0.08, 1, 0, 0, 0),
	parasite2 = Color(0.45, 0.15, 0.04, 1, 0, 0, 0),
	hot = Color(1,0.6,0,1),
	giant = Color(0.6,1.6,0.4,1),
	ember = Color(0.6,0.1,0,1),
	sand = Color(1,0.4,0.2,1),
	revelation = Color(2,2,2,1),
	glitch = Color(1,1,1,1),
	wax2 = Color(1,1,1,1),
	pitchBlack = Color(0,0,0,1,1,1,1)
}
function mod:ColorizeColors()
	mod.Colors.boom:SetColorize(1.3,2,0.7,1)
	mod.Colors.boom2:SetColorize(1.9,2.5,1.4,1)
	mod.Colors.jupiterShot:SetColorize(1.9,2.5,1.4,1)
	mod.Colors.jupiterLaser1:SetColorize(1.9,2.5,1.4,1)
	mod.Colors.jupiterLaser2:SetColorize(3.75,3.75,6.5,1)
	mod.Colors.hail:SetColorize(1,1.5,2.5,1)
	mod.Colors.poop:SetColorize(1.2,0.7,0.6,1)
	mod.Colors.poop2:SetColorize(1.2,0.7,0.6,1)
	mod.Colors.pee:SetColorize(3,2.7,0.1,1)
	mod.Colors.ice:SetColorize(5,7,10,1)
	mod.Colors.frozen:SetColorize(1.5,2,3,1)
	mod.Colors.timeChanged:SetColorize(1,0.2,0.2,1)
	mod.Colors.timeChanged2:SetColorize(0.25,0.25,0.75,1)
	mod.Colors.fire:SetColorize(5,2.5,0,1)
	mod.Colors.superFire:SetColorize(20,7,0,1)
	mod.Colors.buttFire:SetColorize(2,1,0,1)
	mod.Colors.mercury:SetColorize(7,5,7,1)
	mod.Colors.tar:SetColorize(1, 1, 1, 1)
	mod.Colors.booger:SetColorize(0.3, 2, 0.2, 1)
	mod.Colors.red:SetColorize(5, 0, 0, 1)
	mod.Colors.white:SetColorize(10, 10, 10, 1)
	mod.Colors.whiteish:SetColorize(5, 5, 5, 1)
	mod.Colors.redlight:SetColorize(4, 1, 1, 1)
	mod.Colors.hot:SetColorize(4, 1, 0, 1)
	mod.Colors.sand:SetColorize(4, 2.5, 1, 1)
	mod.Colors.revelation:SetColorize(1, 1, 1, 0.4)
	mod.Colors.glitch:SetColorize(1, 1, 1, 1)
	mod.Colors.wax2:SetColorize(0.85, 0.8, 0, 1)
	mod.Colors.pitchBlack:SetColorize(1,1,1, 2)
end
mod:ColorizeColors()

--Collectibles that can spawn
mod.AstralChallengePoolExtras = {
	[1] = CollectibleType.COLLECTIBLE_ARIES,
	[2] = CollectibleType.COLLECTIBLE_TAURUS,
	[3] = CollectibleType.COLLECTIBLE_GEMINI,
	[4] = CollectibleType.COLLECTIBLE_LEO,
	[5] = CollectibleType.COLLECTIBLE_CANCER,
	[6] = CollectibleType.COLLECTIBLE_VIRGO,
	[7] = CollectibleType.COLLECTIBLE_LIBRA,
	[8] = CollectibleType.COLLECTIBLE_SCORPIO,
	[9] = CollectibleType.COLLECTIBLE_SAGITTARIUS,
	[10] = CollectibleType.COLLECTIBLE_CAPRICORN,
	[11] = CollectibleType.COLLECTIBLE_AQUARIUS,
	[12] = CollectibleType.COLLECTIBLE_PISCES,
	[13] = CollectibleType.COLLECTIBLE_ZODIAC
}

--Flags and things that are not flags lol
mod.ModFlags = {
	globalTimestuck = false,
	playerTimestuck = false,
	playerTimestuckFlick = false,
	playerTimestuckRoomIdx = -1,
	playerTimestuckStartFrame = 0,
	playerTimestuckEndFrame = 0,

	glowingHourglass = 0,
	currentMusic = nil,
	noPool = false,
	forceSpawn = false,

	ErrorRoom = false,
	ErrorRoomSource = -2,
	ErrorRoomSlot = -1,

	venusCounter = 0,
	venusPosition = Vector.Zero,
	venusHeat = false,

	marsEnabled = false,
	marsCharge = 0,

	pitchBlack = false,
	SpikeHits = 0,
	
	LunaTriggered = false,
	ErrantTriggered = false,
	ErrantRoomSpawned = false,

	IsThereTelescope = false,

	LunarPactInStage = {},

	jupiterLocked = false,
}
mod.ModConfigs = {
	noRain = false,
	noSnow = false,
	roomSpawnChance = 9,
	roomSpawnChance2 = 30,
	lunarRoomSpawnChance = 5,
	altUranus = false,
	ultraSkin = true,
	victoryChest = true,
}
mod.ModConstants = {
	burningFrames = 300
}

include("scripts.findentities")
include("scripts.lunaritems")

include("scripts.newrooms")

--Room and planet
mod.RoomsPlanet = {
	[8500] = mod.Entity.Jupiter,
	[8501] = mod.Entity.Saturn,
	[8502] = mod.Entity.Uranus,
	[8503] = mod.Entity.Neptune,
	[8504] = mod.Entity.Pluto,

	[8505] = mod.Entity.Mercury,
	[8506] = mod.Entity.Venus,
	[8507] = mod.Entity.Terra1,
	[8508] = mod.Entity.Mars,
	[8509] = mod.Entity.Luna,
	
	[8510] = mod.Entity.Errant,
}

--SILLY FUCTIONS--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

-- Random int between Min and Max, both inclusive
function mod:RandomInt(Min, Max)
    if Min > Max then 
        print("El minimo ta' ma grande")
    else
        return Min + rng:RandomInt(Max + 1 - Min)
    end
end

--Return the nearest integer from n in a list
function mod:Takeclosest(list, n)
    local difference = math.abs(list[1]-n)
	local current = list[1]
	for i=2, #list do
		if (math.abs(list[i]-n) < difference) then
			difference = math.abs(list[i]-n)
			current = list[i]
		end
	end
	return current
end

--Somebody as X item?
function mod:SomebodyHasItem(item)
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player:HasCollectible (item,true) then 
			return true
		end
	end
	return false
end
--How many X items are
function mod:HowManyItems(item)
	local n = 0
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		n = n + player:GetCollectibleNum(item)
	end
	return n
end
--Somebody as X trinket?
function mod:SomebodyHasTrinket(trinket)
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player:HasTrinket(trinket,false) then 
			return true
		end
	end
	return false
end

-- Move to a specific position
function mod:MoveTowards(entity, data, objective, velocity)
	if entity.Position:Distance(objective) < 45 then
		entity.Velocity = Vector.Zero
		--entity.Position = objective
		data.MoveTowards = false
	else
		data.targetvelocity = (objective - entity.Position):Normalized()*2
		--Do the actual movement
		entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * velocity
	end
end

function mod:IsOutsideRoom(point, room)
	local marginX = 50
	local marginY = 50

	local varX = room:GetCenterPos(0).X - point.X
	local varY = room:GetCenterPos(0).Y - point.Y
	if varX > 0 then --p left
		if varY > 0 then--p up
			point = Vector(point.X - 1.65*marginX , point.Y - 1.65*marginY)
		else--p down
			point = Vector(point.X - 1.65*marginX , point.Y + marginY)
		end
	else --p right
		if varY > 0 then--p up
			point = Vector(point.X + 0.95*marginX , point.Y - 1.65*marginY)
		else--p down
			point = Vector(point.X + 0.95*marginX , point.Y + marginY)
		end
	end

	if room:GetGridIndex(point) == -1 then 
		return true 
	else
		return false
	end
end

--Check unlocks (not really, but close)
function mod:CheckVoidUnlock()
	local itemsFromVoid = {}
	itemsFromVoid[1] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DELIRIOUS)
	itemsFromVoid[2] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_D_INFINITY)
	itemsFromVoid[3] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_EUCHARIST)
	itemsFromVoid[4] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SHADE)
	itemsFromVoid[5] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_KING_BABY)
	itemsFromVoid[6] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DULL_RAZOR)
	itemsFromVoid[7] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE)
	itemsFromVoid[8] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_EDENS_SOUL)
	itemsFromVoid[9] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_EUTHANASIA)
	itemsFromVoid[10] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_CROOKED_PENNY)
	itemsFromVoid[11] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_VOID)
	itemsFromVoid[12] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD)
	itemsFromVoid[13] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM)
	itemsFromVoid[14] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SUPLEX)
	itemsFromVoid[15] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SPINDOWN_DICE)
	itemsFromVoid[16] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HYPERCOAGULATION)
	itemsFromVoid[17] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)
	itemsFromVoid[18] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DARK_ARTS)
	itemsFromVoid[19] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_IBS)
	itemsFromVoid[20] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM)
	itemsFromVoid[21] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BERSERK)
	itemsFromVoid[22] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HEMOPTYSIS)
	itemsFromVoid[23] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_FLIP)
	itemsFromVoid[24] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS)
	itemsFromVoid[25] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_GELLO)
	itemsFromVoid[26] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_KEEPERS_KIN)
	itemsFromVoid[27] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ABYSS)
	itemsFromVoid[28] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DECAP_ATTACK)
	itemsFromVoid[29] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LEMEGETON)
	itemsFromVoid[30] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ANIMA_SOLA)
	
	for i=1, #itemsFromVoid do
		if itemsFromVoid[i]:IsAvailable() then
			return true
		end
	end
	return false
end

function mod:CheckChestUnlock()

	polaroid = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_POLAROID)
	negative = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NEGATIVE)
	
	local level = game:GetLevel()
	
	if level:GetStage() == LevelStage.STAGE5 then
		if level:GetStageType() == StageType.STAGETYPE_ORIGINAL and negative:IsAvailable() then--Sheol
			return true
		elseif level:GetStageType() == StageType.STAGETYPE_WOTL and polaroid:IsAvailable() then--Cathedral
			return true
		end
		
	end
	return false
end

--ded
function mod:NormalDeath(entity, notExplosion, mamaMega)
	mod.ModFlags.SpikeHits = 0

	local data = entity:GetData()

	if mod.ModFlags.currentMusic and not (entity.Type == mod.EntityInf[mod.Entity.Luna].ID) then
		music:Crossfade (mod.ModFlags.currentMusic, 0.1)
		mod.ModFlags.currentMusic = nil
	end

	if mamaMega then
		if not notExplosion then
			game:GetRoom():MamaMegaExplosion(entity.Position)
		end

		if mod.savedata.planetAlive then
			local center = game:GetRoom():GetCenterPos()

			mod:PausePool()
			if mod.savedata.planetNum == mod.Entity.Luna then
				for i=-1, 1, 2 do
					local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false), entity.Position + Vector(25,0)*i, Vector.Zero, nil)
				end
				local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, entity.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)
			else
				local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, entity.Position, Vector.Zero, nil)
			end

			if mod.ModConfigs.victoryChest and game:GetLevel():GetStage() == LevelStage.STAGE5 then
			
				if mod:CheckChestUnlock() then
					local winChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 0, center, Vector.Zero, nil)
				end
				
				if rng:RandomFloat() <= 0.5 and mod:CheckVoidUnlock() then
					
					local voidPortal = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, center + Vector(0,75), true)
					voidPortal.VarData = 1
					
					-- Replace the spritesheet to make it look like a Void Portal
					local sprite = voidPortal:GetSprite()
					sprite:Load("gfx/grid/voidtrapdoor.anm2", true)
				end
			end

		end
	else
		if not notExplosion then
			game:BombExplosionEffects ( entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
		end
	end
	if not notExplosion then
		mod:SpawnGlassFracture(entity, 1.5)
		sfx:Play(Isaac.GetSoundIdByName("SuperExplosion"),0.6)
		game:ShakeScreen(60)
	end

	if mod.savedata.planetAlive then
		mod:RemoveCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.Dyings)
		if mamaMega then
			mod.savedata.planetKilled2 = true
		else
			mod.savedata.planetKilled1 = true
		end
	end
	mod.savedata.planetAlive = false
end
--deding
function mod:Dyings(entity)
	if entity:GetData().HeavensCall then
		if entity.Type == mod.EntityInf[mod.Entity.Jupiter].ID and entity.Variant == mod.EntityInf[mod.Entity.Jupiter].VAR then
			mod:JupiterDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Saturn].ID and entity.Variant == mod.EntityInf[mod.Entity.Saturn].VAR then
			mod:SaturnDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Uranus].ID and entity.Variant == mod.EntityInf[mod.Entity.Uranus].VAR then
			mod:UranusDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Neptune].ID and entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR then
			mod:NeptuneDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Mercury].ID and entity.Variant == mod.EntityInf[mod.Entity.Mercury].VAR then
			mod:MercuryDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Venus].ID and entity.Variant == mod.EntityInf[mod.Entity.Venus].VAR then
			mod:VenusDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Terra1].ID then
			mod:TerraDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Mars].ID and entity.Variant == mod.EntityInf[mod.Entity.Mars].VAR then
			mod:MarsDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Luna].ID and entity.Variant == mod.EntityInf[mod.Entity.Luna].VAR then
			mod:LunaDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Pluto].ID and entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR then
			mod:PlutoDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Eris].ID and entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR then
			mod:ErisDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Makemake].ID and entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR then
			mod:MakemakeDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Haumea].ID and entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR then
			mod:HaumeaDying(entity)
		elseif entity.Type == mod.EntityInf[mod.Entity.Errant].ID and entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR then
			mod:ErrantDying(entity)
		end
	end
end

--U know this thing
function mod:MarkovTransition(state, chain)
	local roll = math.random()
	for i = 1, #chain+1 do
		roll = roll - chain[state][i]
		if roll <= 0 then
			return i - 1
		end
	end
	return "lol lmao"
end

--Shuffles a list, from Tainted Treasure
function mod:Shuffle(list)
	for i = #list, 2, -1 do
		local j = mod:RandomInt(1, i)
		list[i], list[j] = list[j], list[i]
	end
	return list
end

--Look at the correct direction
function mod:FaceTarget(entity, target)
	if entity.Position.X < target.Position.X then
		entity:GetSprite().FlipX = true
	else
		entity:GetSprite().FlipX = false
	end

	if entity:GetData().Ass == false then 
		entity:GetSprite().FlipX = not entity:GetSprite().FlipX
	end
end

--Random Element from table
function mod:random_elem(tb)
    local keys = {}
    for k in pairs(tb) do table.insert(keys, k) end
    return tb[keys[math.random(#keys)]]
end

--Save
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, shouldSave)
	if shouldSave then
		if mod.savedata.planetAlive and mod.savedata.planetNum then
			local planet = mod:FindByTypeMod(mod.savedata.planetNum)
			if planet~=nil and #planet>0 and planet[1]~=nil then
				mod.savedata.planetHP = planet[1].HitPoints --There should not be more than 1 planet at the same time so... (we dont talk about meat cleaver)

				if mod.savedata.planetNum == mod.Entity.Pluto then
					local eris = mod:FindByTypeMod(mod.Entity.Eris)[1]
					if eris then
						mod.savedata.planetHP2 = eris.HitPoints
					end
					local makemake = mod:FindByTypeMod(mod.Entity.Makemake)[1]
					if makemake then
						mod.savedata.planetHP3 = makemake.HitPoints
					end
					local haumea = mod:FindByTypeMod(mod.Entity.Haumea)[1]
					if haumea then
						mod.savedata.planetHP4 = haumea.HitPoints
					end
					local errant = mod:FindByTypeMod(mod.Entity.Errant)[1]
					if errant then
						mod.savedata.errantHP = errant.HitPoints
					end
				end
			end
		end
		if mod.savedata.errantAlive then
			local errant = mod:FindByTypeMod(mod.Entity.Errant)[1]
			if errant then
				mod.savedata.errantHP = errant.HitPoints
			end
		end

		mod:SaveData(json.encode(mod.savedata))
	end
end)

--Equals two saves
function mod:EqualSaves(save1, save2)
	if save2.planetNum ~= nil then save1.planetNum = save2.planetNum end
	if save2.planetAlive ~= nil then save1.planetAlive = save2.planetAlive end
	if save2.planetKilled1 ~= nil then save1.planetKilled1 = save2.planetKilled1 end
	if save2.planetKilled2 ~= nil then save1.planetKilled2 = save2.planetKilled2 end
	if save2.planetHP ~= nil then save1.planetHP = save2.planetHP end
	if save2.spawnchancemultiplier1 ~= nil then save1.spawnchancemultiplier1 = save2.spawnchancemultiplier1 end
	if save2.spawnchancemultiplier2 ~= nil then save1.spawnchancemultiplier2 = save2.spawnchancemultiplier2 end
	
	if save2.planetHP2 ~= nil then save1.planetHP2 = save2.planetHP2 end
	if save2.planetHP3 ~= nil then save1.planetHP3 = save2.planetHP3 end
	if save2.planetHP4 ~= nil then save1.planetHP4 = save2.planetHP4 end
	if save2.planetAlive1 ~= nil then save1.planetAlive1 = save2.planetAlive1 end
	if save2.planetAlive2 ~= nil then save1.planetAlive2 = save2.planetAlive2 end
	if save2.planetAlive3 ~= nil then save1.planetAlive3 = save2.planetAlive3 end
	if save2.planetAlive4 ~= nil then save1.planetAlive4 = save2.planetAlive4 end
	if save2.planetKilled11 ~= nil then save1.planetKilled11 = save2.planetKilled11 end
	if save2.planetKilled12 ~= nil then save1.planetKilled12 = save2.planetKilled12 end
	if save2.planetKilled13 ~= nil then save1.planetKilled13 = save2.planetKilled13 end
	if save2.planetKilled14 ~= nil then save1.planetKilled14 = save2.planetKilled14 end
	
	if save2.errantAlive ~= nil then save1.errantAlive = save2.errantAlive end
	if save2.errantKilled ~= nil then save1.errantKilled = save2.errantKilled end
	if save2.errantHP ~= nil then save1.errantHP = save2.errantHP end
	
	if save2.nLocusts ~= nil then save1.nLocusts = save2.nLocusts end
end

--Reset data on new run
function mod:ResetDataOnNewRun()
	mod.savedata.planetNum = 0
	mod.savedata.planetAlive = false
	mod.savedata.planetKilled1 = false
	mod.savedata.planetKilled2 = false
	mod.savedata.planetHP = 1
	mod.savedata.spawnchancemultiplier1 = 1
	mod.savedata.spawnchancemultiplier2 = 1
	
	mod.savedata.planetHP2 = 1
	mod.savedata.planetHP3 = 1
	mod.savedata.planetHP4 = 1
	mod.savedata.planetAlive1 = false
	mod.savedata.planetAlive2 = false
	mod.savedata.planetAlive3 = false
	mod.savedata.planetAlive4 = false
	mod.savedata.planetKilled11 = false
	mod.savedata.planetKilled12 = false
	mod.savedata.planetKilled13 = false
	mod.savedata.planetKilled14 = false
	
	mod.savedata.errantHP = 1
	mod.savedata.errantAlive = false
	mod.savedata.errantKilled = false

	mod.savedata.nLocusts = {[0]=0, ["0"] = 0}
	
	mod.savedata.redShovelUsed = 0
	
	mod.ModFlags.LunaTriggered = false
	mod.ModFlags.ErrantTriggered = false
	mod.ModFlags.ErrantRoomSpawned = false
end

--Spawn entity from mod
function mod:SpawnEntity(entityNum, position, velocity, origin)
	local entity = Isaac.Spawn(mod.EntityInf[entityNum].ID, mod.EntityInf[entityNum].VAR, mod.EntityInf[entityNum].SUB, position, velocity, origin)
	entity:GetData().HeavensCall = true
	return entity
end

--Find mod entity
function mod:FindByTypeMod(entityNum)
	return Isaac.FindByType(mod.EntityInf[entityNum].ID, mod.EntityInf[entityNum].VAR, mod.EntityInf[entityNum].SUB)
end

--Spawn astellide
function mod:AppearSatellite(room, entityNum)

	local spritePath
	if entityNum == mod.Entity.Mercury then
		spritePath = "gfx/backdrop/b_mercury.png"
	elseif entityNum == mod.Entity.Venus then
		spritePath = "gfx/backdrop/b_venus.png"
	elseif entityNum == mod.Entity.Terra1 then
		spritePath = "gfx/backdrop/b_earth.png"
	elseif entityNum == mod.Entity.Mars then
		spritePath = "gfx/backdrop/b_mars.png"
	elseif entityNum == mod.Entity.Jupiter then
		spritePath = "gfx/backdrop/b_jupiter.png"
	elseif entityNum == mod.Entity.Saturn then
		spritePath = "gfx/backdrop/b_saturn.png"
	elseif entityNum == mod.Entity.Uranus then
		spritePath = "gfx/backdrop/b_uranus.png"
	elseif entityNum == mod.Entity.Neptune then
		spritePath = "gfx/backdrop/b_neptune.png"
	elseif entityNum == mod.Entity.Pluto then
		spritePath = "gfx/backdrop/b_kuiper.png"
	else
		return
	end

	local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
	local sprite = effect:GetSprite()
	sprite.Color = Color.Default
	sprite:Load("gfx/backdrop/lunaroommoon.anm2")
	sprite:ReplaceSpritesheet(0, spritePath)
	sprite:LoadGraphics()
	sprite:Play("idle", true)
end
--Spawn
function mod:AppearPlanet(entity, noMusic)
	if not entity.Visible then return end

	local sprite = entity:GetSprite()
	local data = entity:GetData()
	if data.SlowSpawn then
		sprite:Play("AppearSlow",true)

		mod:scheduleForUpdate(function()
			local game = Game()
			local hud = game:GetHUD()

			if entity.Type == mod.EntityInf[mod.Entity.Luna].ID then
				local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position, Vector.Zero, entity)
				trapdoor:GetSprite():Play("BigIdle", true)
			end
			
			local planetName = mod.PlanetName[mod.savedata.planetNum]
			
			if entity.Type == mod.EntityInf[mod.Entity.Errant].ID then
				planetName = mod.PlanetName[mod.Entity.Errant]
			end

			if planetName then
				hud:ShowItemText(planetName.." has awakened","")
			end
			--mod:AppearSatellite(game:GetRoom(), mod.savedata.planetNum)
		end, 95)
	else
		sprite:Play("Appear",true)
		local trapdoor

		if not entity:GetData().NoTrapdoor then
			trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position, Vector.Zero, entity)
		end

		if trapdoor and entity.Type == mod.EntityInf[mod.Entity.Luna].ID then
			trapdoor:GetSprite():Play("BigIdle", true)
		elseif entity.Type == mod.EntityInf[mod.Entity.Pluto].ID or entity.Type == mod.EntityInf[mod.Entity.Eris].ID or entity.Type == mod.EntityInf[mod.Entity.Haumea].ID or entity.Type == mod.EntityInf[mod.Entity.Makemake].ID then
			data.IsKuiper = true
		end

		if mod.ModFlags.glowingHourglass > 0 then
			local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, entity.Position, Vector.Zero, entity)
			timestuck:GetSprite().Scale = Vector(1,1)*0.5
			sfx:Play(Isaac.GetSoundIdByName("TimeResume"),2)
		end
	end
	mod.ModFlags.glowingHourglass = 0


	entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

	mod:scheduleForUpdate(function()
		--Pedestals
		for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)) do
				pedestal:Remove()
		end

		--Music
		if not noMusic then
			if (mod.savedata.planetAlive or mod.savedata.errantAlive) and not entity:GetData().NoTrapdoor then
				if data.SlowSpawn then
					mod.ModFlags.currentMusic = music:GetCurrentMusicID ()
		
					local customMusic
	
					if mod.savedata.planetNum == mod.Entity.Luna then
						customMusic = Isaac.GetMusicIdByName("Luna_Intro")
						music:Crossfade (customMusic, 2)
						music:Queue(Isaac.GetMusicIdByName("Waning_Blood"))
	
					elseif mod.savedata.errantAlive then
						customMusic = Isaac.GetMusicIdByName("Doing_some_Errants_Intro")
						music:Crossfade (customMusic, 2)
						music:Queue(Isaac.GetMusicIdByName("Doing_some_Errants"))
	
					else
						customMusic = Isaac.GetMusicIdByName("Supernova")
						music:Crossfade (customMusic, 2)
						music:Queue(Isaac.GetMusicIdByName("Supernova_loop"))
					end
				else
					if mod.savedata.planetNum == mod.Entity.Luna then
						customMusic = Isaac.GetMusicIdByName("Waning_Blood")
						music:Crossfade (customMusic, 2)
	
					elseif mod.savedata.errantAlive then
						customMusic = Isaac.GetMusicIdByName("Doing_some_Errants")
						music:Crossfade (customMusic, 2)
	
					else
						customMusic = Isaac.GetMusicIdByName("Supernova_loop")
						music:Crossfade (customMusic, 2)
					end
				end
			end
		end

	end,5)


end

--Is an enemy
function mod:IsAnEnemy(entity)
	local r = entity:IsActiveEnemy() and not (entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or entity:HasEntityFlags(EntityFlag.FLAG_CHARM))
	return r
end

include("scripts.otherentities")
include("scripts.outerplanets")
include("scripts.innerplanets")
include("scripts.specialplanets")

include("scripts.lunarpact")

--SPECIAL ROOM THINGS---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Minimapi magic
if MinimapAPI then
	local ac_sprite = Sprite()
	ac_sprite:Load("gfx/ui/minimapapi/astralchallengeicon.anm2", true)
	ac_sprite:SetFrame("IconAstralChallenge", 0)
	MinimapAPI:AddIcon("AstralChallenge", ac_sprite)
	
	local lr_sprite = Sprite()
	lr_sprite:Load("gfx/ui/minimapapi/lunarroomicon.anm2", true)
	lr_sprite:SetFrame("IconLunarRoom", 0)
	MinimapAPI:AddIcon("LunarRoom", lr_sprite)
end
mod.minimaprooms = {} --Stores rooms that need to be updated on MinimapAPI

function mod:InitializeRoomsData()

	local vivitatedCase = VitiatedCharacters and game:GetLevel():GetStage() == LevelStage.STAGE8
	if vivitatedCase then return end

	mod.roomdata = {}
	mod:InitializeRoomData("dice", mod.minvariant1, mod.maxvariant2+1, mod.roomdata)

	mod.pactroomdata = {}
	mod:InitializeRoomData("devil", mod.minlunarvariant, mod.maxlunarvariant, mod.pactroomdata)

	mod.diceroomdata = {}
	mod:InitializeDiceRoomData(mod.diceroomdata)
end

--Load (or reset) things when the run is started or continued
function mod:OnGameStartMain(iscontinued)
	mod.ModFlags.SpikeHits = 0

	if not iscontinued then
		rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)

		mod:ResetDataOnNewRun()

		mod:EqualSaves(mod.savedataOld, mod.savedata)

		mod:SaveData(json.encode(mod.savedata))
		
		mod.ModFlags.forceSpawn = false
	else
		local room = game:GetRoom()
		local level = game:GetLevel()
		local roomdesc = level:GetCurrentRoomDesc()
		if mod.savedata.planetAlive and mod:IsRoomDescAstralChallenge(roomdesc) then
			mod:scheduleForUpdate(function()
				--Close door
				for i = 0, DoorSlot.NUM_DOOR_SLOTS do
					local door = room:GetDoor(i)
					if door then
						door:Close()
					end
				end
				sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS,1)
				--Make room uncleared
				room:SetClear( false )
			end, 0)
		end
	end

	if mod:HasData() then
		mod.savedata = json.decode(mod:LoadData())
	else
		mod.savedata = {}
	end

	if iscontinued and not BasementRenovator and not mod.roomdata then
		if StageAPI then
			mod:scheduleForUpdate(function()
				mod:InitializeRoomsData()
			end, 3, ModCallbacks.MC_POSTR)
		else
			mod:scheduleForUpdate(function()
				mod:InitializeRoomsData()
			end, 0, ModCallbacks.MC_POST_RENDER)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnGameStartMain)

--Will the room spawn??? 👀
function mod:OnNewLevelMain()
	--Flag things--------
	mod.ModFlags.SpikeHits = 0
	mod.ModFlags.ErrorRoom = false
	mod.ModFlags.ErrorRoomSource = -2
	mod.ModFlags.LunarPactInStage = {}
	
	mod:ResetItemVars()

	if not mod.savedata.errantAlive then
		mod.ModFlags.ErrantRoomSpawned = false
		mod.savedata.errantAlive = false
		mod.savedata.errantHP = 1
		mod.savedata.errantKilled = false
	end

	--Try to generate the Astral Challenge Room.
	if StageAPI then
		mod:scheduleForUpdate(function()
			mod:AstralRoomGenerator()
		end, 3, ModCallbacks.MC_POST_UPDATE)
	else
		mod:AstralRoomGenerator()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevelMain)

function mod:OnNewRoomMain()
	--Things~------------------------------------------------------------
	mod:EqualSaves(mod.savedataOld, mod.savedata)
	mod:CheckSpawnNewRoom()
	mod.ModFlags.globalTimestuck = false
	mod.ModFlags.venusHeat = false
	mod.ModFlags.pitchBlack = false
	mod.ModFlags.blackHole = false
	mod.ModFlags.glowingHourglass = mod.ModFlags.glowingHourglass - 1
	mod.ModFlags.jupiterLocked = false

	mod:SaturnUpdateReset()

	mod.ItemsVars.jupiterSets = {}
	mod.ItemsVars.nJupiterSets = 0
	
	--things------------------------------------------------------------
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	--Door(s)
	mod:DoorFunctionOutside(room, level, roomdesc)
	
	--Rooms------------------------------------------------------------
	if mod:IsRoomDescAstralChallenge(roomdesc) then

		local dice = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR)
		--This only executes the first time you enter
		if #dice > 0 then
			--Remove dice floor
			for i = 1, #dice do
				dice[i]:Remove()
			end

			--The little wisps
			for i=1,15 do
				local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
				wisp:GetSprite().Color = Color.Default
			end

		end
		mod:CleanDiceRoom()


        mod:scheduleForUpdate(function()
            music:Crossfade(Music.MUSIC_PLANETARIUM, 1)
        end, 1)

		--things
		local itemPool = game:GetItemPool()
		local room = game:GetRoom()

		--Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
		game:ShowHallucination (0,BackdropType.PLANETARIUM)
		sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx

		--Now the actual background and walls
		--SPACEEE
		local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
		if roomdata.Variant < 8509 then
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.DepthOffset = 1
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,1,1,1)
			sprite:Load("gfx/backdrop/astralchallengecosmos.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
		end

		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
		effect.DepthOffset = 2
		local sprite = effect:GetSprite()
		sprite.Color = Color(1,1,1,1)
		sprite:Load("gfx/backdrop/astralchallengestars1.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("idle", true)
		
		--Walls
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORMWOOD_HOLE, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
		effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		local sprite = effect:GetSprite()
		sprite.Color = Color(1,1,1,1)
		sprite:Load("gfx/backdrop/astralchallengewalls.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("1x1_room", true)

		--What planet should spawn
		if mod.RoomsPlanet[roomdata.Variant] ~= nil and not (mod.savedata.planetNum == mod.Entity.Terra2 and mod.RoomsPlanet[roomdata.Variant] == mod.Entity.Terra1) then
			mod.savedata.planetNum = mod.RoomsPlanet[roomdesc.Data.Variant]
		end

		--Door again, but opened
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				local doorSprite = door:GetSprite()
				doorSprite:Load("gfx/grid/astralchallengeroor.anm2", true)
				doorSprite:ReplaceSpritesheet(0, "gfx/grid/astralchallengedoor.png")
				doorSprite:Play("Opened")
			end
		end

		--Do not appear again >:(
		if roomdata.Variant > mod.maxvariant1 then
			mod.savedata.spawnchancemultiplier2 = 0
		else
			mod.savedata.spawnchancemultiplier1 = 0
		end

		if mod.ModFlags.LunaTriggered then
			for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0)) do
				e:Remove()
			end
			mod:UltraRedSetup(room, true)
		end

	elseif mod:IsRoomDescLunarPact(roomdesc) then

		mod:CleanDiceRoom()
        --Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
        game:ShowHallucination (0,BackdropType.PLANETARIUM)
        sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx
        --Redify
        mod:UltraRedSetup(room, false)

        mod:scheduleForUpdate(function()
            music:Crossfade(Music.MUSIC_SECRET_ROOM_ALT_ALT, 1)
        end, 1)

        --Mark pedestals
        for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            mod:MakeLunarPact(pedestal, not room:IsFirstVisit())
        end
	elseif mod:IsRoomDescUltraSecret(roomdesc) then
		mod:CleanDiceRoom()
		--things
		local room = game:GetRoom()

		--Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
		game:ShowHallucination (0,BackdropType.PLANETARIUM)
		sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx

		--Now the actual background and walls
		mod:UltraRedSetup(room)
	elseif mod:IsRoomDescSolarBoss(roomdesc, 1) or mod:IsRoomDescSolarBoss(roomdesc, 2) then
		
		mod:CleanDiceRoom()

		--Walls
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		local sprite = effect:GetSprite()
		sprite.Color = Color(0,0,0,1)
		sprite:Load("gfx/backdrop/astralchallengecosmos.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("idle", true)
		sprite.Scale = sprite.Scale*1.25

		if mod:IsRoomDescSolarBoss(roomdesc, 1) then
			--Walls
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,1,1,1)
			sprite:Load("gfx/backdrop/solarfloor.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("Idle", true)
			sprite.Scale = Vector(0.87, 0.78)



		elseif mod:IsRoomDescSolarBoss(roomdesc, 2)  then
		end

	elseif mod:IsRoomErrant(roomdesc) then

		mod:CleanDiceRoom()
		local dice = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR)
		--This only executes the first time you enter
		if #dice > 0 then
			--Remove dice floor
			for i = 1, #dice do
				dice[i]:Remove()
			end

			--The little wisps
			for i=1,15 do
				local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
				wisp:GetSprite().Color = Color(0.5,0,2,0.3)
			end

			for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				pedestal:AddEntityFlags(EntityFlag.FLAG_GLITCH)
			end
		end

		--things
		local room = game:GetRoom()

		if roomdata.Type == RoomType.ROOM_DICE then
			--Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
			game:ShowHallucination (0,BackdropType.PLANETARIUM)
			sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx

		elseif roomdata.Type == RoomType.ROOM_ERROR then
			if (mod.savedata.errantAlive == false and mod.savedata.errantKilled == true) then
				local trapdoor = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, game:GetRoom():GetCenterPos(), true)
			end
		end

		--Door again, but opened
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				local doorSprite = door:GetSprite()
				doorSprite:Load("gfx/grid/astralchallengeroor.anm2", true)
				doorSprite:ReplaceSpritesheet(0, "gfx/grid/astralchallengedoor.png")
				doorSprite:Play("Opened")
			end
		end

		if mod.ModFlags.ErrantTriggered then
			for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0)) do
				e:Remove()
			end
			mod:QuantumSetup(room)
		end
	end
	
	--Astral Statue------------------------------------------------------------
	mod:OnNewRoomStatue()

	--Luna crawler------------------------------------------------------------
	if mod:IsRedRoom(roomdesc) and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 and not mod:IsGlassRoom(roomdesc) and not (mod.savedata.planetAlive and mod.savedata.planetNum == mod.Entity.Luna) then
		local position = nil
		local extra = 110
		if mod:RandomInt(0,1) == 0 then
			local random = mod:RandomInt(63, 577)
			if mod:RandomInt(0,1) == 0 then
				position = Vector(random, 142-extra)
			else
				position = Vector(random, 417+extra)
			end
		else
			local random = mod:RandomInt(142, 417)
			if mod:RandomInt(0,1) == 0 then
				position = Vector(63-extra, random)
			else
				position = Vector(577+extra, random)
			end
		end

		mod:SpawnEntity(mod.Entity.ICUP, position, Vector.Zero, nil)
	end

	--Minimapi things------------------------------------------------------------
	if MinimapAPI and #mod.minimaprooms > 0 then
		for i, roomidx in pairs(mod.minimaprooms) do
			local minimaproom = MinimapAPI:GetRoomByIdx(roomidx)
			mod:scheduleForUpdate(function()
				if minimaproom then
					minimaproom.Color = Color(MinimapAPI.Config.DefaultRoomColorR, MinimapAPI.Config.DefaultRoomColorG, MinimapAPI.Config.DefaultRoomColorB, 1, 0, 0, 0)
					if mod:IsRoomDescAstralChallenge(minimaproom.Descriptor) or mod:IsRoomErrant(minimaproom.Descriptor) then
						minimaproom.PermanentIcons = {"AstralChallenge"}
					elseif mod:IsRoomDescLunarPact(minimaproom.Descriptor) then
						minimaproom.PermanentIcons = {"LunarRoom"}
					end
					mod.minimaprooms[i] = nil
				end
			end, 0)
		end
	else
		mod.minimaprooms = {}
	end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomMain)

--FUNNY INTERACTIONS----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Reset chances if glowing hourglass was used
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	if item == CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS and mod.savedata.planetNum ~= mod.Entity.Saturn then
		mod:EqualSaves(mod.savedata, mod.savedataOld)
	elseif item == CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS and mod.savedata.planetNum == mod.Entity.Saturn then
		mod.ModFlags.glowingHourglass = 2--You are not going to scape
	end
end)
--Trying to steal the item
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	if item == CollectibleType.COLLECTIBLE_MOVING_BOX or item == CollectibleType.COLLECTIBLE_VOID or item == CollectibleType.COLLECTIBLE_ABYSS then
		local statues = mod:FindByTypeMod(mod.Entity.Statue)
		if #statues > 0 then
			local statue = statues[1]
			mod:StatueDie(statue)
			statue:GetSprite():Play("Death")
		end
	end
end)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_,card, player)
	if card == Card.RUNE_BLACK or card == Card.CARD_REVERSE_HERMIT then
		local statues = mod:FindByTypeMod(mod.Entity.Statue)
		if #statues > 0 then
			local statue = statues[1]
			mod:StatueDie(statue)
			statue:GetSprite():Play("Death")
		end

		if mod:IsRoomDescLunarPact(game:GetLevel():GetCurrentRoomDesc()) then
			--Mark pedestals
			for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				if pedestal:GetData().LunarPact then
					pedestal = pedestal:ToPickup()
					local oldSubType = pedestal.SubType

					pedestal:Remove()
				end
			end
		end
	end
end)
--Uranus shitting
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	if not mod.ModConfigs.altUranus then
		for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Uranus)) do
			e:GetData().State = mod.UMSState.SPIN
			e:GetData().StateFrame = 0
			mod:UranusThank(e, e:GetData(), e:GetSprite())
		end
	end
end,  CollectibleType.COLLECTIBLE_FLUSH)
--Can spawn after R key
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	if not mod.savedata.planetAlive then
		mod.savedata.spawnchancemultiplier1 = 1
		mod.savedata.spawnchancemultiplier2 = 1
		mod.savedata.planetKilled1 = false
		mod.savedata.planetKilled2 = false
	end
end,  CollectibleType.COLLECTIBLE_R_KEY)
--Not Death Certificate or Genesis
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item)
	if mod.savedata.planetAlive and ( item == CollectibleType.COLLECTIBLE_GENESIS or item == CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE or item == CollectibleType.COLLECTIBLE_MEAT_CLEAVER ) then
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1)
		return true
	end
end)
--Eternal D6
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	mod:RemoveCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.StatueRenderUpdate)
	mod:scheduleForUpdate(function()
		mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.StatueRenderUpdate, mod.EntityInf[mod.Entity.Statue].ID)
		for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)) do
			pedestal:GetData().WasDeleted = true
		end
	end,1)
end, CollectibleType.COLLECTIBLE_ETERNAL_D6)
--Dont f up lunar pacts
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item)
	if mod:IsRoomDescLunarPact(game:GetLevel():GetCurrentRoomDesc()) then
		if item==CollectibleType.COLLECTIBLE_D6 or item==CollectibleType.COLLECTIBLE_ETERNAL_D6 then
			--Mark pedestals
			for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				if pedestal:GetData().LunarPact then
					mod:scheduleForUpdate(function()
						mod:MakeLunarPact(pedestal)
					end, 1)
				end
			end

		end
	end
end)
--Errant Generator
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item, rng, player)
	if rng:RandomFloat() < (1/10)*(1/17) and not mod.ModFlags.ErrantRoomSpawned then
		local room = game:GetRoom()

		local closestFrame
		for _, frame in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE)) do
			if not closestFrame or closestFrame.Position:Distance(player.Position) > frame.Position:Distance(player.Position) then
				closestFrame = frame
			end
		end
		if not closestFrame then return end
		local chosenSlot
		for i = 0, DoorSlot.NUM_DOOR_SLOTS-1 do
			if room:GetDoorSlotPosition(i).X == closestFrame.Position.X and room:GetDoorSlotPosition(i).Y == closestFrame.Position.Y then
				chosenSlot = i
				break
			end
		end

		mod:GenerateErrantRoom(chosenSlot)
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_RED_KEY, "UseItem")
		return true
	end
end,  CollectibleType.COLLECTIBLE_RED_KEY)
function mod:GenerateErrantRoom(slot)
	local level = game:GetLevel()
	local room = game:GetRoom()
	local roomdesc = level:GetCurrentRoomDesc()
	local deadends = mod:GetDeadEnds(roomdesc)

	local roomidx = level:GetCurrentRoomIndex()

	local shape = roomdesc.Data.Shape
	local adjindex = mod.adjindexes[shape]
	local deadends = {}
	for i, entry in pairs(adjindex) do
		if level:GetRoomByIdx(roomidx).Data then
			local oob = false
			for j, idx in pairs(mod.borderrooms[i]) do
				if idx == roomidx then
					oob = true
				end
			end

			if roomdesc.Data.Doors & (1 << i) > 0 and i == slot and level:GetRoomByIdx(roomidx+adjindex[i]).GridIndex == -1 and not oob then
				deadend =  {Slot = i, GridIndex = roomidx+adjindex[i]}
				break
			end
		end
	end
	if not deadend then return end

	local deadendslot = deadend.Slot
	local deadendidx = deadend.GridIndex

	if level:MakeRedRoomDoor(roomidx, slot) then
		local newroomdesc = level:GetRoomByIdx(deadendidx, 0)

		--Initialize mod.roomdata if nil
		if not mod.roomdata then
			mod:InitializeRoomsData()
		end
		data = mod.roomdata[mod.maxvariant2+1]
		newroomdesc.Data = data
		newroomdesc.Flags = 0

		mod:UpdateRoomDisplayFlags(newroomdesc)
		level:UpdateVisibility()
		table.insert(mod.minimaprooms, newroomdesc.GridIndex)

		mod:scheduleForUpdate(function()
			local door = room:GetDoor(slot) 
			if not door then return end
			mod:TransformDoor2Astral(door, room, level)
			door:Open()
		end,1)
		mod.ModFlags.ErrantRoomSpawned = true
	end
end

--PLANET RESPAWN--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Check Spawn Planet in new room
function mod:CheckSpawnNewRoom()
	if mod.savedata and mod.savedata.planetAlive then
		mod:scheduleForUpdate(function()
			mod:SpawnPlanet(mod.savedata.planetNum)
		end, 0, ModCallbacks.MC_POST_RENDER)
	end
	if mod.savedata and mod.savedata.errantAlive then
		mod:scheduleForUpdate(function()
			mod:SpawnPlanet(mod.Entity.Errant)
		end, 0, ModCallbacks.MC_POST_RENDER)
	end
end
--SpawnPlanet if room changed or continued
function mod:SpawnPlanet(entityNum)
	local validType = entityNum==mod.Entity.Jupiter or entityNum==mod.Entity.Saturn or entityNum==mod.Entity.Uranus or entityNum==mod.Entity.Neptune
	or entityNum==mod.Entity.Mercury or entityNum==mod.Entity.Venus or entityNum==mod.Entity.Terra1 or entityNum==mod.Entity.Terra2 or entityNum==mod.Entity.Mars
	or entityNum==mod.Entity.Luna
	if validType and #(mod:FindByTypeMod(entityNum))==0 then
		
		local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)

		local planet = mod:SpawnEntity(entityNum, position, Vector.Zero, nil)
		planet.HitPoints = mod.savedata.planetHP

	elseif entityNum==mod.Entity.Pluto then
		if mod.savedata.planetAlive1 and not mod.savedata.planetKilled11 then
			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Pluto, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedata.planetHP

			mod:scheduleForUpdate(function()
				if (#mod:FindByTypeMod(mod.Entity.Charon1)+#mod:FindByTypeMod(mod.Entity.Charon2))==0 then
					local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
					local planet = mod:SpawnEntity(mod.Entity.Charon1, position, Vector.Zero, nil)
				end
			end, 30)
		end
		if mod.savedata.planetAlive2 and not mod.savedata.planetKilled12 then

			mod:scheduleForUpdate(function()
				local pluto = mod:FindByTypeMod(mod.Entity.Pluto)[1]
				if pluto then
					pluto:GetData().FlagEris = true
				end
			end,2)

			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Eris, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedata.planetHP2

		end
		if mod.savedata.planetAlive3 and not mod.savedata.planetKilled13 then

			mod:scheduleForUpdate(function()
				local pluto = mod:FindByTypeMod(mod.Entity.Pluto)[1]
				if pluto then
					pluto:GetData().FlagMakemake = true
				end
			end,2)

			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Makemake, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedata.planetHP3
		end
		if mod.savedata.planetAlive4 and not mod.savedata.planetKilled14 then
			
			mod:scheduleForUpdate(function()
				local pluto = mod:FindByTypeMod(mod.Entity.Pluto)[1]
				if pluto then
					pluto:GetData().FlagHaumea = true
				end
			end,2)

			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Haumea, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedata.planetHP4
		end
	end

	if entityNum==mod.Entity.Errant then
		if mod.savedata.errantAlive and not mod.savedata.errantKilled and #mod:FindByTypeMod(mod.Entity.Errant)==0 then
			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Errant, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedata.errantHP
			planet:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end
	end
end

--Statue things (why onether call instead of using the one above? idk) I changed the function order, so I think this doesnt makes sense
function mod:OnNewRoomStatue()
	--things
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	
	local isAstralChallenge = mod:IsRoomDescAstralChallenge(roomdesc)
	if isAstralChallenge then
		mod:scheduleForUpdate(function()
			if (not mod.savedata.planetAlive) then
				if ((not mod.savedata.planetKilled1) and mod.minvariant1 <= roomdata.Variant and roomdata.Variant <= mod.maxvariant1) or
				 ((not mod.savedata.planetKilled2) and mod.minvariant2 <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.maxvariant2) 
				then
					local statue = mod:SpawnEntity(mod.Entity.Statue, game:GetRoom():GetCenterPos()+Vector(0,-20),Vector.Zero, Isaac.GetPlayer(0))
				end
			end
		end, 0, ModCallbacks.MC_POST_RENDER)
	elseif mod:IsRoomErrant(roomdesc) then
		mod:scheduleForUpdate(function()
			if not mod.savedata.errantAlive then
				if not mod.savedata.errantKilled and mod:IsRoomErrant(roomdesc) then
					local statue = mod:SpawnEntity(mod.Entity.Statue, game:GetRoom():GetCenterPos()+Vector(0,-20),Vector.Zero, Isaac.GetPlayer(0))
				end
			end
		end, 0, ModCallbacks.MC_POST_RENDER)
	elseif mod:IsRoomDescLunarPact(roomdesc) then
		local statue = Isaac.Spawn(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR+1, mod.EntityInf[mod.Entity.Statue].SUB, game:GetRoom():GetCenterPos()+Vector(0,-20),Vector.Zero, Isaac.GetPlayer(0))
	end

	local isPlanetarium = roomdesc and roomdata and roomdata.Type == RoomType.ROOM_PLANETARIUM
	if isAstralChallenge or isPlanetarium then
		for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 0)) do
			e:Remove()
		end
	end

end

--Update health of boss, may be delayed by one damage
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_,entity,amount,_,_,_)
	
	if entity:GetData().HeavensCall then
		if mod.savedata.planetAlive then
			if entity.Type == mod.EntityInf[mod.Entity.Jupiter].ID and entity.Variant == mod.EntityInf[mod.Entity.Jupiter].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Saturn].ID and entity.Variant == mod.EntityInf[mod.Entity.Saturn].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Uranus].ID and entity.Variant == mod.EntityInf[mod.Entity.Uranus].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Neptune].ID and entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR
			or 
			entity.Type == mod.EntityInf[mod.Entity.Mercury].ID and entity.Variant == mod.EntityInf[mod.Entity.Mercury].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Venus].ID and entity.Variant == mod.EntityInf[mod.Entity.Venus].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Terra1].ID and entity.Variant == mod.EntityInf[mod.Entity.Terra1].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Terra3].ID and entity.Variant == mod.EntityInf[mod.Entity.Terra3].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Mars].ID and entity.Variant == mod.EntityInf[mod.Entity.Mars].VAR 
			or 
			entity.Type == mod.EntityInf[mod.Entity.Luna].ID and entity.Variant == mod.EntityInf[mod.Entity.Luna].VAR or 
			entity.Type == mod.EntityInf[mod.Entity.Pluto].ID and entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR
			then
				mod.savedata.planetHP = entity.HitPoints
			elseif entity.Type == mod.EntityInf[mod.Entity.Eris].ID and entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR then
				mod.savedata.planetHP2 = entity.HitPoints
			elseif entity.Type == mod.EntityInf[mod.Entity.Makemake].ID and entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR then
				mod.savedata.planetHP3 = entity.HitPoints
			elseif entity.Type == mod.EntityInf[mod.Entity.Haumea].ID and entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR then
				mod.savedata.planetHP4 = entity.HitPoints
			end
		elseif mod.savedata.errantAlive then
			if entity.Type == mod.EntityInf[mod.Entity.Errant].ID and entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR then
				mod.savedata.errantHP = entity.HitPoints
			end
		end
	end
end)


--POOL------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Add item to the Astral Challenge extra pool
function mod:AddItemToPool(item)

	local isThere = false
	for _, i in ipairs(mod.AstralChallengePoolExtras) do
		if i==item then 
			isThere = true
			break
		end
	end

	if not isThere then
		mod.AstralChallengePoolExtras[#(mod.AstralChallengePoolExtras)+1] = item
	end

end

--Item pool in room
function mod:GetAstralCollectible()
	--If cant find a collectible that a player doesnt have in 100 tries, just spawn a regular one, the pool is empty
	local randomChance = rng:RandomFloat()
				
	if randomChance <= 0.65 then
		return game:GetItemPool():GetCollectible(ItemPoolType.POOL_PLANETARIUM, false)
		
	else
		local newItem = nil
		for i=1, 100 do
			local pool = mod.AstralChallengePoolExtras

			local randomNum = mod:RandomInt(1,#pool)
			newItem = pool[randomNum]

			local aPLayerHasIt = mod:SomebodyHasItem(newItem)
			if not aPLayerHasIt then
				break
			end
			newItem = nil
		end
		return newItem
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, function(_)
	--things
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	
	if not mod.ModFlags.noPool then
		--New pool
		mod:PausePool()
		local haschaos = mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_CHAOS)
		if not haschaos then
			if mod:IsRoomDescAstralChallenge(roomdesc) then
				return mod:GetAstralCollectible()
			elseif mod:IsRoomDescLunarPact(roomdesc) then
				return game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false)
			end
		end
	end
end)
--Deactivating the pool
function mod:PausePool()
	mod.ModFlags.noPool = true
	mod:scheduleForUpdate(function()
		mod.ModFlags.noPool = false
	end, 2, ModCallbacks.MC_POST_UPDATE)
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_,entity)--Dont reroll TEden items into astral challenge items
	if entity.Type == EntityType.ENTITY_PLAYER then
		entity = entity:ToPlayer()
		if entity:GetPlayerType() == PlayerType.PLAYER_EDEN_B then
			mod:PausePool()
		end
	end
end)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item)--Dont reroll player items intro astral challenge items if d4 or d100
	if item == CollectibleType.COLLECTIBLE_D4 or item == CollectibleType.COLLECTIBLE_D100 then
		mod:PausePool()
	end
end)


--SHADERS---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
function mod:ShadersRender(shaderName)
	if shaderName == "Timestuck" then
		if mod.ModFlags.globalTimestuck or (mod.ModFlags.playerTimestuck and mod.ModFlags.playerTimestuckFlick) then
			local params = {Enabled = 1}
			return params
		else
			local params = {Enabled = 0}
			return params
		end

	elseif shaderName == "VenusHeat" then
		if mod.ModFlags.venusHeat then
			local room = game:GetRoom()
			local position1 = mod.ModFlags.venusPosition
			position1 = room:WorldToScreenPosition (position1)
		
			local position2 = room:GetCenterPos()
			position2 = room:WorldToScreenPosition (position2)
		
			local params = { 
				PlayerPos = { position1.X,  position1.Y},
				CenterPos = { position2.X,  position2.Y},
				Time = Isaac.GetFrameCount(),
				VenusTime = mod.ModFlags.venusCounter
			}
			return params
		else
			local params = { 
				PlayerPos = { 2000, 2000 },
				CenterPos = { 2000, 2000 },
				Time = 0,
				VenusTime = 0
			}
			return params
		end

	elseif shaderName == "PitchBlack" then
		if mod.ModFlags.pitchBlack or mod.ModFlags.forcedPitchBlack then
			local params = {Enabled = 1}
			return params
		else
			local params = {Enabled = 0}
			return params
		end
		
	elseif shaderName == "BlackHole" then --Only the black circle!!!!! the distortion is just a shockwave
		if mod.ModFlags.blackHole then
			local room = game:GetRoom()
			local position = room:WorldToScreenPosition(mod.ModFlags.blackHolePosition + Vector(0,-3))
			local radius = room:WorldToScreenPosition(mod.ModFlags.blackHolePosition + Vector(20,-3))
			local time = mod.ModFlags.blackHoleTime

			local params = {
				Enabled = 1,
				BlackPosition = {position.X,  position.Y, radius.X},
				Time = time,
				}
			return params
		else
			local params = {
				Enabled = 0,
				BlackPosition = {0,  0,  0},
				Time = 0,
				}
			return params
		end
	
	elseif shaderName == "Mars" then
		if mod.ModFlags.marsEnabled then
			game:GetHUD():Render()
			local params = {
				Enabled = 1,
				Charge = mod.ModFlags.marsCharge,
				Time = Isaac.GetFrameCount(),
				}
			return params
		else
			local params = {
				Enabled = 0,
				Charge = 0,
				Time = 0,
				}
			return params
		end
	
	end

end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.ShadersRender)

-- not sure if this shader crash fix by agentcucco is still necessary, but i'll put it in anyway
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	Isaac.ExecuteCommand("reloadshaders")
end)
--OTHER MODS------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--ENHANCED BOSS BARS----------------------------------------------------------------------------------------------------------------
if HPBars then
	--Creating a better planetarium bar
	HPBars.BarStyles["PlanetariumHC"] = {
		sprite ="gfx/ui/bosshp_bars/bossbar_design_planetariumHC.png",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble the Planetarium but Darker"
	}
	HPBars.BarStyles["LunarHC"] = {
		sprite ="gfx/ui/bosshp_bars/bossbar_design_lunarHC.png",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble the Darker Planetarium but Reder"
	}
	HPBars.BarStyles["QuantumHC"] = {
		sprite ="gfx/ui/bosshp_bars/bossbar_design_quantumHC.png",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble the quantum shard"
	}

	HPBars.Conditions["isFliped"] = 
		(function(entity)
			return game:GetRoom():GetBackdropType() == BackdropType.DOGMA
		end)	

	local truFunc = function(entity)
		return entity:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	end
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Statue].ID).."."..tostring(mod.EntityInf[mod.Entity.Statue].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Statue].ID).."."..tostring(mod.EntityInf[mod.Entity.Statue].VAR+1)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.MercuryBird].ID).."."..tostring(mod.EntityInf[mod.Entity.MercuryBird].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Terra2].ID).."."..tostring(mod.EntityInf[mod.Entity.Terra2].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Horsemen].ID).."."..tostring(mod.EntityInf[mod.Entity.Horsemen].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Horsemen].ID).."."..tostring(mod.EntityInf[mod.Entity.Horsemen].VAR+1)] = {truFunc}
	HPBars.BossIgnoreList[tostring(EntityType.ENTITY_DOGMA)..".10"] = {truFunc}
	HPBars.BossIgnoreList[tostring(EntityType.ENTITY_ADVERSARY)..".0"] = {function(entity) if entity:GetData().HeavensCall then return true end end}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Attlerock].ID).."."..tostring(mod.EntityInf[mod.Entity.Attlerock].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.HollowsLantern].ID).."."..tostring(mod.EntityInf[mod.Entity.HollowsLantern].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.WhiteHole].ID).."."..tostring(mod.EntityInf[mod.Entity.WhiteHole].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.AshTwin].ID).."."..tostring(mod.EntityInf[mod.Entity.AshTwin].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Charon1].ID).."."..tostring(mod.EntityInf[mod.Entity.Charon1].VAR)] = {truFunc}
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Charon2].ID).."."..tostring(mod.EntityInf[mod.Entity.Charon2].VAR)] = {truFunc}

	--Adding the bars
	Jid = tostring(mod.EntityInf[mod.Entity.Jupiter].ID).."."..tostring(mod.EntityInf[mod.Entity.Jupiter].VAR)
	Sid = tostring(mod.EntityInf[mod.Entity.Saturn].ID).."."..tostring(mod.EntityInf[mod.Entity.Saturn].VAR)
	Uid = tostring(mod.EntityInf[mod.Entity.Uranus].ID).."."..tostring(mod.EntityInf[mod.Entity.Uranus].VAR)
	Nid = tostring(mod.EntityInf[mod.Entity.Neptune].ID).."."..tostring(mod.EntityInf[mod.Entity.Neptune].VAR)

	MRid = tostring(mod.EntityInf[mod.Entity.Mercury].ID).."."..tostring(mod.EntityInf[mod.Entity.Mercury].VAR)
	Vid = tostring(mod.EntityInf[mod.Entity.Venus].ID).."."..tostring(mod.EntityInf[mod.Entity.Venus].VAR)
	T1id = tostring(mod.EntityInf[mod.Entity.Terra1].ID).."."..tostring(mod.EntityInf[mod.Entity.Terra1].VAR)
	T3id = tostring(mod.EntityInf[mod.Entity.Terra3].ID).."."..tostring(mod.EntityInf[mod.Entity.Terra3].VAR)
	Mid = tostring(mod.EntityInf[mod.Entity.Mars].ID).."."..tostring(mod.EntityInf[mod.Entity.Mars].VAR)
	
	Lid = tostring(mod.EntityInf[mod.Entity.Luna].ID).."."..tostring(mod.EntityInf[mod.Entity.Luna].VAR)
	Pid = tostring(mod.EntityInf[mod.Entity.Pluto].ID).."."..tostring(mod.EntityInf[mod.Entity.Pluto].VAR)
	Eid = tostring(mod.EntityInf[mod.Entity.Eris].ID).."."..tostring(mod.EntityInf[mod.Entity.Eris].VAR)
	MKid = tostring(mod.EntityInf[mod.Entity.Makemake].ID).."."..tostring(mod.EntityInf[mod.Entity.Makemake].VAR)
	Hid = tostring(mod.EntityInf[mod.Entity.Haumea].ID).."."..tostring(mod.EntityInf[mod.Entity.Haumea].VAR)
	Qid = tostring(mod.EntityInf[mod.Entity.Errant].ID).."."..tostring(mod.EntityInf[mod.Entity.Errant].VAR)

    HPBars.BossDefinitions[Jid] = {
        sprite = "gfx/bosses/icon_jupiter.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Sid] = {
        sprite = "gfx/bosses/icon_saturn.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Uid] = {
        sprite = "gfx/bosses/icon_uranus.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Nid] = {
        sprite = "gfx/bosses/icon_neptune.png",
		conditionalSprites = {
			{"isAbsoluteStage","gfx/bosses/icon_neptune_shiny.png", {LevelStage.STAGE4_1}},
			{"isAbsoluteStage","gfx/bosses/icon_neptune_shiny.png", {LevelStage.STAGE4_2}}
		},
		barStyle = "PlanetariumHC"
    }

	HPBars.BossDefinitions[MRid] = {
        sprite = "gfx/bosses/icon_mercury.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Vid] = {
        sprite = "gfx/bosses/icon_venus.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[T1id] = {
        sprite = "gfx/bosses/icon_terra1.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[T3id] = {
        sprite = "gfx/bosses/icon_terra3.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Mid] = {
        sprite = "gfx/bosses/icon_mars.png",
		barStyle = "PlanetariumHC"
    }

	HPBars.BossDefinitions[Lid] = {
        sprite = "gfx/bosses/icon_luna.png",
		conditionalSprites = {
			{"isFliped","gfx/bosses/icon_lunaflip.png"}
		},
		barStyle = "LunarHC"
    }
	HPBars.BossDefinitions[Pid] = {
        sprite = "gfx/bosses/icon_pluto.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Eid] = {
        sprite = "gfx/bosses/icon_eris.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[MKid] = {
        sprite = "gfx/bosses/icon_makemake.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Hid] = {
        sprite = "gfx/bosses/icon_haumea.png",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Qid] = {
        sprite = "gfx/bosses/icon_errant.png",
		barStyle = "QuantumHC"
    }
end

--MOD CONFIG MENU-------------------------------------------------------------------------------------------------------------------
--This is a Copy paste, standard modconfig stuff; this is mostly just copy/paste by this point
local function SaveConfig()
    if ModConfigMenu then
		if mod.ModConfigs.noRain ~= nil then
			mod.savedata.noNeptuneRain = mod.ModConfigs.noRain
		else
			mod.savedata.noNeptuneRain = false
		end

		if mod.ModConfigs.noSnow ~= nil then
			mod.savedata.noUranusSnowfall = mod.ModConfigs.noSnow
		else
			mod.savedata.noUranusSnowfall = false
		end

		if mod.ModConfigs.roomSpawnChance ~= nil then
			mod.savedata.spawnChance = mod.ModConfigs.roomSpawnChance
		else
			mod.savedata.spawnChance = 9
		end
		if mod.ModConfigs.roomSpawnChance2 ~= nil then
			mod.savedata.spawnChance2 = mod.ModConfigs.roomSpawnChance2
		else
			mod.savedata.spawnChance2 = 30
		end
		if mod.ModConfigs.lunarRoomSpawnChance ~= nil then
			mod.savedata.lunarRoomSpawnChance = mod.ModConfigs.lunarRoomSpawnChance
		else
			mod.savedata.lunarRoomSpawnChance = 5
		end

		if mod.ModConfigs.altUranus ~= nil then
			mod.savedata.altUranus = mod.ModConfigs.altUranus
		else
			mod.savedata.altUranus = false
		end
		
		if mod.ModConfigs.ultraSkin ~= nil then
			mod.savedata.ultraSkin = mod.ModConfigs.ultraSkin
		else
			mod.savedata.ultraSkin = true
		end

		if mod.ModConfigs.victoryChest ~= nil then
			mod.savedata.victoryChest = mod.ModConfigs.victoryChest
		else
			mod.savedata.victoryChest = true
		end

        mod:SaveData(json.encode(mod.savedata))
    end
end

if ModConfigMenu then
	
	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.NUMBER,
		Default = 9,
		CurrentSetting = function()
			return mod.ModConfigs.roomSpawnChance
		end,
		Minimum = 0,
		Maximum = 100,
		Display = function()
			return "First room spawn chance: " .. tostring(mod.ModConfigs.roomSpawnChance) .. "%"
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.roomSpawnChance = newvalue
			else
				mod.ModConfigs.roomSpawnChance = 9
			end
			SaveConfig()
		end,
		Info = "Default = 9%"
	})

	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.NUMBER,
		Default = 30,
		CurrentSetting = function()
			return mod.ModConfigs.roomSpawnChance2
		end,
		Minimum = 0,
		Maximum = 100,
		Display = function()
			return "Second room spawn chance: " .. tostring(mod.ModConfigs.roomSpawnChance2) .. "%"
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.roomSpawnChance2 = newvalue
			else
				mod.ModConfigs.roomSpawnChance2 = 30
			end
			SaveConfig()
		end,
		Info = "Default = 30%"
	})

	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.NUMBER,
		Default = 5,
		CurrentSetting = function()
			return mod.ModConfigs.lunarRoomSpawnChance
		end,
		Minimum = 0,
		Maximum = 100,
		Display = function()
			return "Lunar pact room spawn chance: " .. tostring(mod.ModConfigs.lunarRoomSpawnChance) .. "%"
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.lunarRoomSpawnChance = newvalue
			else
				mod.ModConfigs.lunarRoomSpawnChance = 5
			end
			SaveConfig()
		end,
		Info = "Default = 5%"
	})

	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.BOOLEAN,
		--Default = false,
		CurrentSetting = function()
			return mod.ModConfigs.noRain
		end,
		Display = function()
			return "Deactivate Neptune's rain: " .. tostring(mod.ModConfigs.noRain)
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.noRain = newvalue
			else
				mod.ModConfigs.noRain = false
			end
			SaveConfig()
		end,
		Info = "Default = false"
	})
	
	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.BOOLEAN,
		Default = false,
		CurrentSetting = function()
			return mod.ModConfigs.noSnow
		end,
		Display = function()
			return "Deactivate Uranus's snowfall: " .. tostring(mod.ModConfigs.noSnow)
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.noSnow = newvalue 
			else
				mod.ModConfigs.noSnow = false 
			end
			SaveConfig()
		end,
		Info = "Default = false"
	})
	
	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.BOOLEAN,
		Default = false,
		CurrentSetting = function()
			return mod.ModConfigs.altUranus
		end,
		Display = function()
			return "Alternative Uranus sprite: " .. tostring(mod.ModConfigs.altUranus)
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.altUranus = newvalue 
			else
				mod.ModConfigs.altUranus = false 
			end
			SaveConfig()
		end,
		Info = "Default = false"
	})

	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.BOOLEAN,
		Default = true,
		CurrentSetting = function()
			return mod.ModConfigs.ultraSkin
		end,
		Display = function()
			return "Alternative UltraSecretRoom skin: " .. tostring(mod.ModConfigs.ultraSkin)
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.ultraSkin = newvalue 
			else
				mod.ModConfigs.ultraSkin = true 
			end
			SaveConfig()
		end,
		Info = "Default = true"
	})
	
	ModConfigMenu.AddSetting("Heaven's Call", "Config", {
		Type = ModConfigMenu.OptionType.BOOLEAN,
		Default = true,
		CurrentSetting = function()
			return mod.ModConfigs.victoryChest
		end,
		Display = function()
			return "Spawn victory chest: " .. tostring(mod.ModConfigs.victoryChest)
		end,
		OnChange = function(newvalue)
			if newvalue ~= nil then 
				mod.ModConfigs.victoryChest = newvalue 
			else
				mod.ModConfigs.victoryChest = true 
			end
			SaveConfig()
		end,
		Info = "Default = true"
	})
end

function mod:onStarted(fromSave)
	if ModConfigMenu and mod:HasData() then
		mod.savedata = json.decode(mod:LoadData())

		if mod.savedata.noNeptuneRain ~= nil then
			mod.ModConfigs.noRain = mod.savedata.noNeptuneRain
		else
			mod.ModConfigs.noRain = false
		end

		if mod.savedata.noUranusSnowfall ~= nil then
			mod.ModConfigs.noSnow = mod.savedata.noUranusSnowfall
		else
			mod.ModConfigs.noSnow = false
		end

		if mod.savedata.spawnChance ~= nil then
			mod.ModConfigs.roomSpawnChance = mod.savedata.spawnChance
		else
			mod.ModConfigs.roomSpawnChance = 9
		end
		
		if mod.savedata.spawnChance2 ~= nil then
			mod.ModConfigs.roomSpawnChance2 = mod.savedata.spawnChance2
		else
			mod.ModConfigs.roomSpawnChance2 = 30
		end

		if mod.savedata.lunarRoomSpawnChance ~= nil then
			mod.ModConfigs.lunarRoomSpawnChance = mod.savedata.lunarRoomSpawnChance
		else
			mod.ModConfigs.lunarRoomSpawnChance = 5
		end

		if mod.savedata.altUranus ~= nil then
			mod.ModConfigs.altUranus = mod.savedata.altUranus
		else
			mod.ModConfigs.altUranus = false
		end

		if mod.savedata.ultraSkin ~= nil then
			mod.ModConfigs.ultraSkin = mod.savedata.ultraSkin
		else
			mod.ModConfigs.ultraSkin = true
		end
		
		if mod.savedata.victoryChest ~= nil then
			mod.ModConfigs.victoryChest = mod.savedata.victoryChest
		else
			mod.ModConfigs.victoryChest = true
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onStarted)


--REVELATIONS------------------------------------------------------------------
if REVEL then
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.RevelationsDoorsUpdate, EffectVariant.DOOR_OUTLINE)
	mod.RevelationDoor = nil
end

--EXTERNAL ITEMS DESCRIPTIONS--------------------------------------------------
if EID then
    EID:addCollectible(mod.Items.Mercurius, "#{{Throwable}} Gives flight. #{{LuckSmall}} Chance to shoot {{ColorTransform}}bismuth tears{{ColorText}}, bismuth tears will create a mini-Isaac when they kill an enemy. #{{LuckSmall}} Chance for My Little Unicorn effect to activate on new room. #{{ArrowUp}} +0.23 speed", "Mercurius?", "en_us")
    EID:addCollectible(mod.Items.Mercurius, "#{{Throwable}} Da vuelo. #{{LuckSmall}} Probabilidad de disparar {{ColorTransform}}lágrimas de bismuto{{ColorText}}, las lágrimas de bismuto crearán un mini-Isaac cuando maten a un enemigo. #{{LuckSmall}} Probabilidad del efecto de Mi Pequeño Unicornio se active en una nueva habitacion. #{{ArrowUp}} +0.23 velocidad", "Mercurio?", "spa")
	
    EID:addCollectible(mod.Items.Venus, "#{{Burning}} Gives a candle familiar, after 15 enemies killed, it will spawn a wax ally. #{{Burning}} Wax allies can be executed by holding CTRL, executed allies have a chance to drop Blazing Hearts, the less health, the more chances. #{{Burning}} Pickuing up a Blazing Heart will give you a Willo", "Venus?", "en_us")
    EID:addCollectible(mod.Items.Venus, "#{{Burning}} Da un familiar vela, después de matar a 15 enemigos, generará un aliado de cera. #{{Burning}} Los aliados de cera se pueden ejecutar manteniendo presionada la tecla CTRL, los aliados ejecutados tienen la posibilidad de soltar Corazones Llameantes, cuanto menos salud, más posibilidades. #{{Burning}} Recoger un Corazon Llameante te dará un Willo.", "Venus?", "spa")
	
    EID:addCollectible(mod.Items.Terra, "#Apples will start spawning on the floor. # On pickup, a giant snake will target the vulnerable enemy with the most health. # While the apple is on the floor, it will grow till stage 3, the higher the stage the stronger the snake. The snake doesn't hurt you.", "Terra?", "en_us")
    EID:addCollectible(mod.Items.Terra, "#Manzanas comenzarán a aparecer en el suelo. # Al recogerlas, una serpiente gigante apuntará al enemigo vulnerable con más vida. # Mientras la manzana está en el suelo, crecerá hasta la etapa 3, cuanto más alta sea la etapa, más fuerte será la serpiente. La serpiente no te hace daño.", "Terra?", "spa")
	
    EID:addCollectible(mod.Items.Mars, "#{{Bait}} On use, will give Isaac a laser gun for some seconds. #{{Blank}} #{{Blank}} While the effect is active: #{{ArrowUp}} damage up, tears up, shot speed up, range up. #{{ArrowDown}} Big speed down. #{{Blank}} # The laser gun timer can be increased by killing enemies. # Will go to your pocket active slot if available.", "Mars?", "en_us")
    EID:addCollectible(mod.Items.Mars, "#{{Bait}} Al usarlo, le dará a Isaac una ametralladora láser por unos segundos. #{{Blank}} #{{Blank}} Mientras el efecto esté activo. #{{ArrowUp}} más daño, más lágrimas, más velocidad de disparo, más alcance. #{{ArrowDown}} Gran reducción de velocidad. #{{Blank}} # El temporizador de la ametralladora láser puede ser aumentado matando enemigos. # Irá a tu ranura de activo de bolsillo si está disponible.", "Marte?", "spa")
	
    EID:addCollectible(mod.Items.Jupiter, "# Isaac will create an electrified laser as he walks. # If it loops in a circle, it will create a short circuit and electrocute enemies within it. # The short circuit will also activate some slots machines for free and upgrade batteries with a chance to make any of them explode and revive shopkeepers as allies.", "Jupiter?", "en_us")
    EID:addCollectible(mod.Items.Jupiter, "# Isaac creara un laser electrificado mientras camina. # Si se cierra en un círculo, creará un cortocircuito y electrocutará a los enemigos dentro de él. # El cortocircuito también activará algunas máquinas tragamonedas de forma gratuita y mejorara las baterías con la posibilidad de hacer que cualquiera de ellas explote y revivir tenderos como aliados.", "Jupiter?", "spa")
	
    EID:addCollectible(mod.Items.Saturnus, "#{{TimerSmall}} On use it will freeze time. # Tears will start moving when time resumes. # Lasers will have the anti-gravity effect. # Placed bombs will instantly explode after the effect ends. #{{ArrowUp}} speed up and tears up while the effect is active. # Will go to your pocket active slot if available.", "Saturnus?", "en_us")
    EID:addCollectible(mod.Items.Saturnus, "#{{TimerSmall}} Al usarlo, se congelará el tiempo. # Las lágrimas comenzarán a moverse cuando se resuma el tiempo. # Los láseres tendrán el efecto de antigravedad. # Las bombas colocadas explotarán instantáneamente después de que finalice el efecto. #{{ArrowUp}} más velocidad y más lagrimas mientras el efecto este activo. # Irá a tu ranura de activo de bolsillo si está disponible.", "Saturno?", "spa")
	
    EID:addCollectible(mod.Items.Uranus, "{{PoopPickup}} Isaac will poop in the opposite direction of his shots. #{{PoopPickup}} Poop tears will apply pooped debuff to enemies. #{{PoopPickup}} Pooped enemies will have weakness and spawn boosting brown creep. #{{PoopPickup}} Killing a pooped enemy will spawn a T??? poop. #{{PoopPickup}} If the enemy does not die and the poop effect wears off, friendly dips will spawn on the enemy.", "Uranus?", "en_us")
    EID:addCollectible(mod.Items.Uranus, "{{PoopPickup}} Isaac hará caca en la dirección opuesta a su disparo. #{{PoopPickup}} Las lágrimas de caca aplicarán el efecto de cadago a los enemigos. #{{PoopPickup}} Los enemigos cagados tendrán debilidad y generarán un suciedad marrón positiva. #{{PoopPickup}} Matar a un enemigo cagado generará una caca de T???. #{{PoopPickup}} Si el enemigo no muere y el efecto de caca desaparece, se generarán dips amistosos en el enemigo.", "Urano?", "spa")
	
    EID:addCollectible(mod.Items.Neptunus, "# Gives a trident familiar that behaves like a faster version of Mom's Knife. # The trident have a chance to open black holes on killed enemies while is being thrown.", "Neptunus?", "en_us")
    EID:addCollectible(mod.Items.Neptunus, "# Da un familiar tridente que se comporta como una versión más rápida de el Cuchillo de Mamá. # El tridente tiene la posibilidad de abrir agujeros negros en los enemigos asesinados mientras es lanzado.", "Neptuno?", "spa")

	
	
    EID:addTrinket(mod.Trinkets.Shard, "# On hit, theres a chance to nullify the damage. #{{Warning}} But Isaac will be teleport to a random position in the room, the teleport has no regards if the position is safe.", "Quantum Shard", "en_us")
    EID:addTrinket(mod.Trinkets.Shard, "# Al ser golpeado existe la posibilidad de anular el daño. #{{Warning}} Pero Isaac se teletransportará a una posición aleatoria en la habitación, el teletransporte no tiene en cuenta si la posición es segura.", "Fragmento Cuántico", "spa")
	
    EID:addTrinket(mod.Trinkets.Sputnik, "# Gives a satellite orbital. #{{Throwable}} Orbitals will move slower but be farther away from you.", "Sputnik", "en_us")
    EID:addTrinket(mod.Trinkets.Sputnik, "# Da un satélite orbital. #{{Throwable}} Los orbitales se moverán más lento pero estarán más lejos de ti.", "Sputnik", "spa")
	
    EID:addTrinket(mod.Trinkets.Flag, "#{{LuckSmall}} Increases chance to find Telescopes.#{{LuckSmall}} Telescopes will have a higher chance to give moons. #{{DamageSmall}} Moon familiars will do more damage and attack more.", "Faded Flag", "en_us")
    EID:addTrinket(mod.Trinkets.Flag, "#{{LuckSmall}} Aumenta la probabilidad de encontrar Telescopios.#{{LuckSmall}} Los Telescopios tendrán una mayor probabilidad de dar lunas. #{{DamageSmall}} Los familiares lunares harán más daño y atacarán más.", "Bandera Descolorida", "spa")

	EID:addEntity(mod.EntityInf[mod.Entity.Telescope].ID, mod.EntityInf[mod.Entity.Telescope].VAR, mod.EntityInf[mod.Entity.Telescope].SUB, "Telescope", "Can give as rewards:#{{Blank}} Wisps, Astral items wisps, Soul Hearts, Blazing Hearts and {{ColorCyan}}Moon {{ColorCyan}}Orbitals", "en_us")
	EID:addEntity(mod.EntityInf[mod.Entity.Telescope].ID, mod.EntityInf[mod.Entity.Telescope].VAR, mod.EntityInf[mod.Entity.Telescope].SUB, "Telescopio", "Puede dar como recompensas:#{{Blank}} Wisps, Wisps de objetos astrales, Corazones de alma, Corazones llameantes y {{ColorCyan}}Orbitales {{ColorCyan}}lunares.", "spa")
	
	EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB, "Astral Statue", "#{{Planetarium}} Take the item and fight a boss.#{{Bomb}} Bombing the statue will turn the item into pickups and spawn the boss.", "en_us")
	EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB, "Estatua Astral", "#{{Planetarium}}Toma el objeto y lucha contra un jefe.#{{Bomb}} Bombardear la estatua convertirá el objeto en recolectables y aparecerá al jefe.", "spa")

	EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR+1, mod.EntityInf[mod.Entity.Statue].SUB, "[Lunar Pact]", "#{{UltraSecretRoom}} Take an item in exchange for broken, red and soul hearts.#{{Warning}} Broken hearts will also subtract the same red life (not containers), but it can't kill you.#For example: picking up a deal of 3 broken hearts with only 3 full red hearts will leave you with half red heart, 3 red containers and 3 broken hearts.", "en_us")
	EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR+1, mod.EntityInf[mod.Entity.Statue].SUB, "[Pacto Lunar]", "#{{UltraSecretRoom}} Tome un item a cambio de corazones rotos, rojos y de alma.#{{Warning}} Los corazones rotos también restarán la misma vida roja (no los contenedores), pero no puede matarte.#Por ejemplo: recoger una pacto de 3 corazones rotos con solo 3 corazones rojos completos te dejará con medio corazón rojo, 3 contenedores rojos y 3 corazones rotos.", "spa")

end

--Weird stuff
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, parameters)

	if cmd == "NearEntities" then
		local room = game:GetRoom()

		local player = Isaac.GetPlayer(0)
		local entities = Isaac.GetRoomEntities()
		for index, entity in ipairs(entities) do
			if entity.Position:Distance(player.Position) < 30 then
				if entity.Type ~= 1 then
					print(entity.Type)
					print(entity.Variant)
				end
			end
		end

	elseif cmd == "HCDebug" then
		print(mod.ModConfigs.lunarRoomSpawnChance)
		print(mod.savedata.lunarRoomSpawnChance)
	end

end)

--[[mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	for i=1, 300 do
		if sfx:IsPlaying(i) then
			print(i)
		end
	end
end, CollectibleType.COLLECTIBLE_LEMON_MISHAP)]]