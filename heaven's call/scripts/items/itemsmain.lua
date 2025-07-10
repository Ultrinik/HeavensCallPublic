local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

--REFERENCES--------------------------
mod.Items = {

	Mercurius = Isaac.GetItemIdByName("Retrograde Mercurius"),
	Venus = Isaac.GetItemIdByName("Retrograde Venus"),
	Terra = Isaac.GetItemIdByName("Retrograde Terra"),
	Mars = Isaac.GetItemIdByName("Retrograde Mars"),
	Jupiter = Isaac.GetItemIdByName("Retrograde Jupiter"),
	Saturnus = Isaac.GetItemIdByName("Retrograde Saturnus"),
	Uranus = Isaac.GetItemIdByName("Retrograde Uranus"),
	Neptunus = Isaac.GetItemIdByName("Retrograde Neptunus"),

	Luna = Isaac.GetItemIdByName("Tainted Luna"),
	Sol = Isaac.GetItemIdByName("Tainted Sol"),
}
mod.TelescopeItems = {
	Mercurius = mod.Items.Mercurius,
	Venus = mod.Items.Venus,
	Terra = mod.Items.Terra,
	Mars = mod.Items.Mars,
	Jupiter = mod.Items.Jupiter,
	Saturnus = mod.Items.Saturnus,
	Uranus = mod.Items.Uranus,
	Neptunus = mod.Items.Neptunus,
}

mod.SolarItems = {

	HyperDice = Isaac.GetItemIdByName("The Hyperdice"),
	RedShovel = Isaac.GetItemIdByName("Red Shovel"),
	Mothership_01 = Isaac.GetItemIdByName("Mothership-01"),
	Mothership_02 = Isaac.GetItemIdByName("Mothership-02"),
	Mothership_03 = Isaac.GetItemIdByName("Mothership-03"),
	Mothership_04 = Isaac.GetItemIdByName("Mothership-04"),
	Stallion = Isaac.GetItemIdByName("Herald's Stallion"),
	Scepter = Isaac.GetItemIdByName("The Scepter"),
	Engine = Isaac.GetItemIdByName("Rocket Engine"),
	Battery = Isaac.GetItemIdByName("Stellar Battery"),
	AdInfinitum = Isaac.GetItemIdByName("Ad Infinitum"),
	Picatrix = Isaac.GetItemIdByName("Picatrix"),
	Wormhole = Isaac.GetItemIdByName("Cosmic Tapeworm"),
	Theia = Isaac.GetItemIdByName("Theia"),
	Telescope = Isaac.GetItemIdByName("Golden Telescope"),
	SpaceJam = Isaac.GetItemIdByName("​​​Space Jam"),
	AsteroidBelt = Isaac.GetItemIdByName("​​​Asteroid Belt"),
	SunGlasses = Isaac.GetItemIdByName("​​​Sun Glasses"),
	Jupiter = Isaac.GetItemIdByName("​​​Wait What!?"),
	LilSol = Isaac.GetItemIdByName("​​​Lil Sol"),
	Dial = Isaac.GetItemIdByName("Eye of the Universe"),
	Mochi = Isaac.GetItemIdByName("​​​Mochi"),
	Panspermia = Isaac.GetItemIdByName("Panspermia"),
	Friend = Isaac.GetItemIdByName("​Friend"),
	CursedHead = Isaac.GetItemIdByName("​Cursed Head"),
	CursedBody = Isaac.GetItemIdByName("​Cursed Body"),
	CursedSoul = Isaac.GetItemIdByName("​Cursed Soul"),
	Quasar = Isaac.GetItemIdByName("​​​Quasar"),
	Whistle = Isaac.GetItemIdByName("Death Whistle"),
}
for i=0, 8 do
	local j = i+1
	local text = "Eye of the Universe"
	for k=1, j do
		text = "​"..text
	end
	mod.SolarItems["Dial"..tostring(i)] = Isaac.GetItemIdByName(text)
end


mod.OtherItems = {
	CatFish = Isaac.GetItemIdByName("Cat Fish"),
	Apple = Isaac.GetItemIdByName("​Apple"),
	Carrot = Isaac.GetItemIdByName("​Carrot"),
	Egg = Isaac.GetItemIdByName("​Egg"),
}

--VARIABLES---------------------
mod.ItemsVars = {}
mod.SolarItemsVars = {}

table.insert(mod.PostLoadInits, {"savedatarun", "currentStatUps", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.currentStatUps", {})

--UPDATES------------------------------------------------
function mod:OnSolarItemsUpdateMain(player)
	--mod:OnDialUpdate(player)

	mod:RunesUpdate(player)

	mod:TemporalStatsUpdate(player)
end
function mod:OnItemsUpdateMain()

	--mod:OnUpdateCheckRadioactivity()

    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		local data = player:GetData()

		local shotDirection
		shotDirection = Vector(Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) - Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex), Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) - Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex))
		if (game:GetLevel():GetDimension() == Dimension.MIRROR) then
			shotDirection.X = -shotDirection.X
		end
		data.CurrentAttackDirection_DIG_HC = shotDirection:Normalized()
		
		if shotDirection:LengthSquared() > 0.01 then
			data.CurrentAttackDirection_HC = player:GetLastDirection()
		else
			data.CurrentAttackDirection_HC = nil
		end

        mod:OnSolarItemsUpdateMain(player)
	end

end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnItemsUpdateMain)

--NEW ROOM-----------------------------------
function mod:LunarOnNewRoomItems()
	for i=0, game:GetNumPlayers ()-1 do
		local player = Isaac.GetPlayer(i)

		mod:OnMercuriusNewRoom(player)

		mod:OnMarsNewRoom(player)

		mod:OnSaturnusNewRoom(player)
		
	end
end
function mod:SolarOnNewRoomItems()

end
function mod:OnNewRoomItems()
    
    mod:LunarOnNewRoomItems()
    mod:SolarOnNewRoomItems()

	mod:FamiliarReskins()

	mod:ChangeLilErrantOrbit()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomItems)

--CACHE----------------------------------------------------------------------
function mod:SolarOnCache(player, cacheFlag)
	--Noise
	--mod:OnBackgroundNoiseCache(player, cacheFlag)

	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		--Friend
		--local numItem = player:GetCollectibleNum(mod.SolarItems.Friend)
		--local numFamiliars = numItem

		--player:CheckFamiliar(mod.EntityInf[mod.Entity.Friend].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Friend), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Friend), mod.EntityInf[mod.Entity.Friend].SUB)
	end

	--if player:GetData().DialTransformed then
	--	if cacheFlag == CacheFlag.CACHE_FLYING then
	--		player.CanFly = true
	--	end
	--end

	mod:TemporalStatsCache(player, cacheFlag)

	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		local extra_dmg = (mod.SaveManager.GetRunSave(player).voidHeartDamageUp or 0)
		extra_dmg = extra_dmg * ((mod.SaveManager.GetRunSave(player).currentVoidHearts or 0)+1)
		extra_dmg = extra_dmg*2
		player.Damage = player.Damage + extra_dmg
	end

	--mochi cache
	if player:HasCollectible(mod.SolarItems.Mochi) then
		local n = player:GetCollectibleNum(mod.SolarItems.Mochi)

		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 0.25*n
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			local tps = mod:toTearsPerSecond(player.MaxFireDelay)
			local new = mod:toMaxFireDelay(tps + 0.25*n)
			player.MaxFireDelay = new
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 1*n
		end
	end

	--cursed
	if player:HasCollectible(mod.SolarItems.CursedSoul) then
		local factor = 0.75
		mod:scheduleForUpdate(function()
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage*factor
			end
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
				local tps = mod:toTearsPerSecond(player.MaxFireDelay)
				local new = mod:toMaxFireDelay(tps - (1-factor)*tps)
				player.MaxFireDelay = new
			end
			if cacheFlag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed*factor
			end
			if cacheFlag == CacheFlag.CACHE_RANGE then
				player.TearRange = player.TearRange*factor
			end
			if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed*factor
			end
			if cacheFlag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck*factor
			end
		end, 1)
	end
	if player:HasCollectible(mod.SolarItems.CursedBody) then
		if cacheFlag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		end
	end
end

function mod:StatsOnCache(player, cacheFlag)
    if not mod.savedatarun().currentStatUps then mod.savedatarun().currentStatUps = {} end
    local playerKey = tostring(mod:PlayerId(player))
    if not mod.savedatarun().currentStatUps[playerKey] then mod.savedatarun().currentStatUps[playerKey] = {DAMAGE = 0, SPEED = 0, TEARS = 0, RANGE = 0, SSPEED = 0, LUCK = 0} end

	if cacheFlag==CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage + mod.savedatarun().currentStatUps[playerKey].DAMAGE
	end
	if cacheFlag==CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + mod.savedatarun().currentStatUps[playerKey].SPEED
	end
	if cacheFlag==CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay + mod.savedatarun().currentStatUps[playerKey].TEARS
	end
	if cacheFlag==CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + mod.savedatarun().currentStatUps[playerKey].RANGE
	end
	if cacheFlag==CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + mod.savedatarun().currentStatUps[playerKey].SSPEED
	end
	if cacheFlag==CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + mod.savedatarun().currentStatUps[playerKey].LUCK
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.StatsOnCache)

function mod:OnCacheMain(player, cacheFlag)
	mod:SolarOnCache(player, cacheFlag)
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCacheMain)

--UTILS--------------------------------------
--Your chances will cap at 'chanceCap' when your 'luck' is geq than 'luckCap'
function mod:LuckRoll(luck, luckCap, chanceCap)
	chanceCap = chanceCap or 1
	luckCap = luckCap + 1
	luck = math.max(1, luck+1)--No neg luck

	local chance = math.min(chanceCap, luck * chanceCap / luckCap)
	local random = rng:RandomFloat()
	return (random <=  chance)
end

function mod:PocketizeItem(player, item)
	if player:HasCollectible(item) then
		local slot
		if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == item then
			slot = ActiveSlot.SLOT_PRIMARY
		elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == item then
			slot = ActiveSlot.SLOT_SECONDARY
		end

		if (slot and slot~=-1) and player:GetActiveItem(ActiveSlot.SLOT_POCKET) == 0 then
			player:SetPocketActiveItem(player:GetActiveItem(slot), ActiveSlot.SLOT_POCKET, false)
			player:RemoveCollectible(player:GetActiveItem(slot), false, slot, false)
		end

	end
end

--OTHERS-------------------------
function mod:FamiliarReskins()
	for _, k in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE, 0, 0)) do
		local player = k and k.SpawnerEntity and (k.SpawnerEntity:ToPlayer() or k.SpawnerEntity:ToFamiliar() and k.SpawnerEntity:ToFamiliar().Player:ToPlayer())
		if player and player:HasCollectible(mod.Items.Mercurius) then
            mod:OnMercuryKnifeInit(k)
		end
	end

	for _, k in ipairs(mod:FindByTypeMod(mod.Entity.Trident)) do
		local player = k and k.SpawnerEntity and (k.SpawnerEntity:ToPlayer() or k.SpawnerEntity:ToFamiliar() and k.SpawnerEntity:ToFamiliar().Player:ToPlayer())
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) then
			k:GetSprite():ReplaceSpritesheet(0, "hc/gfx/familiar/familiar_trident_feferi.png")
			k:GetSprite():LoadGraphics()
		end
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) then
			k:GetSprite():ReplaceSpritesheet(0, "hc/gfx/familiar/familiar_trident_nihil.png")
			k:GetSprite():LoadGraphics()
		end
	end
end

function mod:BigCollectibleInit(pickup)
	if mod.Items.Mercurius <= pickup.SubType and pickup.SubType <= mod.Items.Luna or pickup.SubType == mod.Items.Sol then
		if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND == 0 then
			local sprite = pickup:GetSprite()

			local animation = sprite:GetAnimation()
			local overlay = sprite:GetOverlayAnimation()

			local pngFilename = sprite:GetLayer(1):GetSpritesheetPath()

			local frame = sprite:GetFrame()
			local oframe = sprite:GetOverlayFrame()

			pickup:Update()

			sprite:Load("hc/gfx/pickup_BigCollectible.anm2", true)
			sprite:ReplaceSpritesheet(1, pngFilename, true)

			sprite:Play(animation, true)
			sprite:PlayOverlay(overlay, true)

			sprite:SetFrame(frame)
			sprite:SetOverlayFrame(oframe)

			sprite:StopOverlay()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.BigCollectibleInit, PickupVariant.PICKUP_COLLECTIBLE)


--Dont lose pocket retrogrades on character change
function mod:PostPosibleCharacterChange(player)
    local item = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
    if item == mod.Items.Mars or item == mod.Items.Saturnus then
        mod:scheduleForUpdate(function ()
            if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == 0 then
                player:SetPocketActiveItem(item, ActiveSlot.SLOT_POCKET, false)
            end
        end, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, mod.PostPosibleCharacterChange)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function (_, item, rng, player)
    mod:PostPosibleCharacterChange(player)
end, CollectibleType.COLLECTIBLE_CLICKER)


--SCRIPTS
include("scripts.items.lunaritems.tmercurius")
include("scripts.items.lunaritems.tvenus")
include("scripts.items.lunaritems.tterra")
include("scripts.items.lunaritems.tmars")
include("scripts.items.lunaritems.tjupiter")
include("scripts.items.lunaritems.tsaturnus")
include("scripts.items.lunaritems.turanus")
include("scripts.items.lunaritems.tneptunus")

include("scripts.items.lunaritems.lunarpactitem")

include("scripts.items.moonfamiliars")

include("scripts.items.trinkets.trinketsmain")

include("scripts.items.solaritems.hyperdice")
include("scripts.items.solaritems.stallion")
--include("scripts.items.solaritems.scepter")
include("scripts.items.solaritems.mothership")
include("scripts.items.solaritems.redshovel")
include("scripts.items.solaritems.rocketengine")
include("scripts.items.solaritems.iridescentitems")
--include("scripts.items.solaritems.radioactiveitems")
include("scripts.items.solaritems.stellarbattery")
include("scripts.items.solaritems.picatrix")
--include("scripts.items.solaritems.wormhole")
include("scripts.items.solaritems.theia")
include("scripts.items.solaritems.gtelescope")
include("scripts.items.solaritems.spacejam")
include("scripts.items.solaritems.asteroidbelt")
--include("scripts.items.solaritems.jupiter")
include("scripts.items.solaritems.lilsol")
--include("scripts.items.solaritems.glassdial")
include("scripts.items.solaritems.quasar")
include("scripts.items.solaritems.panspermia")

include("scripts.items.solaritems.pickups.pickupsmain")

include("scripts.slots.slotmain")

function mod:GiveAllItems()
	local player = Isaac.GetPlayer(0)

	-- lunar Items
	player:AddCollectible(mod.Items.Mercurius)
	player:AddCollectible(mod.Items.Venus)
	player:AddCollectible(mod.Items.Terra)
	player:AddCollectible(mod.Items.Mars)
	player:AddCollectible(mod.Items.Jupiter)
	player:AddCollectible(mod.Items.Saturnus)
	player:AddCollectible(mod.Items.Uranus)
	player:AddCollectible(mod.Items.Neptunus)
	player:AddCollectible(mod.Items.Luna)
	player:AddCollectible(mod.Items.Sol)

	-- solar Items
	--player:AddCollectible(mod.SolarItems.HyperDice)
	--player:AddCollectible(mod.SolarItems.RedShovel)
	player:AddCollectible(mod.SolarItems.Mothership_01)
	player:AddCollectible(mod.SolarItems.Mothership_02)
	player:AddCollectible(mod.SolarItems.Mothership_03)
	player:AddCollectible(mod.SolarItems.Mothership_04)
	player:AddCollectible(mod.SolarItems.Stallion)
	player:AddCollectible(mod.SolarItems.Engine)
	player:AddCollectible(mod.SolarItems.Battery)
	--player:AddCollectible(mod.SolarItems.AdInfinitum)
	--player:AddCollectible(mod.SolarItems.Picatrix)
	--player:AddCollectible(mod.SolarItems.Wormhole)
	player:AddCollectible(mod.SolarItems.Theia)
	player:AddCollectible(mod.SolarItems.Telescope)
	player:AddCollectible(mod.SolarItems.SpaceJam)
	player:AddCollectible(mod.SolarItems.AsteroidBelt)
	player:AddCollectible(mod.SolarItems.LilSol)
	player:AddCollectible(mod.SolarItems.Mochi)
	player:AddCollectible(mod.SolarItems.Panspermia)
	--player:AddCollectible(mod.SolarItems.Quasar)

	--trinkets
	player:AddSmeltedTrinket(mod.Trinkets.Sputnik)
	player:AddSmeltedTrinket(mod.Trinkets.Flag)
	player:AddSmeltedTrinket(mod.Trinkets.Void)
	--player:AddSmeltedTrinket(mod.Trinkets.Noise)
	player:AddSmeltedTrinket(mod.Trinkets.BismuthPenny)
	player:AddSmeltedTrinket(mod.Trinkets.Incense)
	player:AddSmeltedTrinket(mod.Trinkets.BadApple)
	player:AddSmeltedTrinket(mod.Trinkets.Nanite)
	player:AddSmeltedTrinket(mod.Trinkets.Battery)
	player:AddSmeltedTrinket(mod.Trinkets.Gear)
	player:AddSmeltedTrinket(mod.Trinkets.ClayBrick)
	player:AddSmeltedTrinket(mod.Trinkets.Lure)
	player:AddSmeltedTrinket(mod.Trinkets.Effigy)
	player:AddSmeltedTrinket(mod.Trinkets.Crown)
	player:AddSmeltedTrinket(mod.Trinkets.Sol)
	player:AddSmeltedTrinket(mod.Trinkets.i)
	player:AddSmeltedTrinket(mod.Trinkets.Shard)
end