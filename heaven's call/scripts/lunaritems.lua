local mod = HeavensCall
local rng = RNG()
local game = Game()
local sfx = SFXManager()

mod.Items = {

	Mercurius = Isaac.GetItemIdByName("Mercurius?"),
	Venus = Isaac.GetItemIdByName("Venus?"),
	Terra = Isaac.GetItemIdByName("Terra?"),
	Mars = Isaac.GetItemIdByName("Mars?"),
	Jupiter = Isaac.GetItemIdByName("Jupiter?"),
	Saturnus = Isaac.GetItemIdByName("Saturnus?"),
	Uranus = Isaac.GetItemIdByName("Uranus?"),
	Neptunus = Isaac.GetItemIdByName("Neptunus?"),

}
mod.PassiveItems = {
	
	Mercurius = Isaac.GetItemIdByName("Mercurius?"),
	Venus = Isaac.GetItemIdByName("Venus?"),
	Terra = Isaac.GetItemIdByName("Terra?"),
	Jupiter = Isaac.GetItemIdByName("Jupiter?"),
	Uranus = Isaac.GetItemIdByName("Uranus?"),
	Neptunus = Isaac.GetItemIdByName("Neptunus?"),
}
mod.Moons = {
	
	Luna = Isaac.GetItemIdByName("Lil Luna"),
	Jupiter = Isaac.GetItemIdByName("Lil Jupiter"),
	Saturn = Isaac.GetItemIdByName("Lil Saturn"),
	Uranus = Isaac.GetItemIdByName("Lil Uranus"),
	Neptune = Isaac.GetItemIdByName("Lil Neptune"),
	Mercury = Isaac.GetItemIdByName("Lil Mercury"),
	Venus = Isaac.GetItemIdByName("Lil Venus"),
	Terra = Isaac.GetItemIdByName("Lil Terra"),
	Mars = Isaac.GetItemIdByName("Lil Mars"),
	Errant = Isaac.GetItemIdByName("Lil Errant"),
	
	Ceres = Isaac.GetItemIdByName("Lil Ceres"),
	Io = Isaac.GetItemIdByName("Lil Io"),
	Europa = Isaac.GetItemIdByName("Lil Europa"),
	Ganymede = Isaac.GetItemIdByName("Lil Ganymede"),
	Callisto = Isaac.GetItemIdByName("Lil Callisto"),
	Titan = Isaac.GetItemIdByName("Lil Titan"),
	Titania = Isaac.GetItemIdByName("Lil Titania"),
	Oberon = Isaac.GetItemIdByName("Lil Oberon"),
	Triton = Isaac.GetItemIdByName("Lil Triton"),
	Pluto = Isaac.GetItemIdByName("Lil Pluto"),
	Charon = Isaac.GetItemIdByName("Lil Charon"),
	Eris = Isaac.GetItemIdByName("Lil Eris"),
	Makemake = Isaac.GetItemIdByName("Lil Makemake"),
	Haumea = Isaac.GetItemIdByName("Lil Haumea"),
	
	Iris = Isaac.GetItemIdByName("Lil Iris"),
	End = Isaac.GetItemIdByName("Lil End"),
}
mod.TotalMoons = 26


mod.ItemsVars = {
	jupiterSets = {},--This is goind to behave weird in Multiplayer, but I dont care
	nJupiterSets = 0,

	waxCount = 0,
	lastVenusFrame = 0,
	nLocusts = {},
	
	timeStops = {},

	activePoopEnts = {},
}
function mod:ResetItemVars()
	mod.ItemsVars = {
		jupiterSets = {},--This is goind to behave weird in Multiplayer, but I dont care
		nJupiterSets = 0,
	
		waxCount = 0,
		lastVenusFrame = 0,
		nLocusts = {},
		
		timeStops = {},

		activePoopEnts = {},
	}

	mod:scheduleForUpdate(function()
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i):ToPlayer()
			mod.ItemsVars.timeStops[i] = false
			mod:WilloCheck(player)
		end
	end,2)
end

--Your chances will cap at 'chanceCap' when your 'luck' is geq than 'luckCap'
function mod:LuckRoll(luck, luckCap, chanceCap)
	chanceCap = chanceCap or 1
	luckCap = luckCap + 1
	luck = math.max(1, luck+1)--No neg luck

	local chance = math.min(chanceCap, luck * chanceCap / luckCap)
	local random = rng:RandomFloat()
	return (random <=  chance)
end

function mod:PocketizeItem(player)
	if player:HasCollectible(mod.Items.Mars) or player:HasCollectible(mod.Items.Saturnus) then
		local slot
		if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == mod.Items.Mars or player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == mod.Items.Saturnus then
			slot = ActiveSlot.SLOT_PRIMARY
		elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == mod.Items.Mars or player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == mod.Items.Saturnus then
			slot = ActiveSlot.SLOT_SECONDARY 
		end

		if slot and player:GetActiveItem(ActiveSlot.SLOT_POCKET == 0) then
			player:SetPocketActiveItem(player:GetActiveItem(slot), ActiveSlot.SLOT_POCKET, false)
			player:RemoveCollectible(player:GetActiveItem(slot), false, slot, false)
		end

	end
end

------------------------------------------
function mod:OnPlayerUpdate(player)
	local data = player:GetData()
	local room = game:GetRoom()
	local aimDirection = Vector(player:GetAimDirection().X, player:GetAimDirection().Y)

	local shotDirection = aimDirection
	if aimDirection:Length() == 0 then
		local fireDirection = Vector.Zero
		if player:GetFireDirection() == Direction.LEFT then
			fireDirection = fireDirection + Vector(-1,0)
		end
		if player:GetFireDirection() == Direction.UP then
			fireDirection = fireDirection + Vector(0,-1)
		end
		if player:GetFireDirection() == Direction.RIGHT then
			fireDirection = fireDirection + Vector(1,0)
		end
		if player:GetFireDirection() == Direction.DOWN then
			fireDirection = fireDirection + Vector(0,1)
		end
		shotDirection = fireDirection
	end

	if player:HasCollectible(mod.Items.Venus) then

		if Input.GetActionValue(ButtonAction.ACTION_DROP, player.ControllerIndex) > 0 then

			mod.ItemsVars.waxCount = mod.ItemsVars.waxCount + 1
			if mod.ItemsVars.waxCount > 30*3 then
				mod.ItemsVars.waxCount = 0
	
				for _, entity in ipairs(Isaac.GetRoomEntities()) do
					if entity:GetData().IsTrueWax_HC then
						local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
						bloody:GetSprite().Color = mod.Colors.wax
						
						game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.wax)
						
						local chance = (1-entity.HitPoints/entity:GetData().OriginalHP)^5
						if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
							chance = chance + 0.1
						end

						if rng:RandomFloat() < chance then
							local heart = mod:SpawnEntity(mod.Entity.BlazeHeart, entity.Position, Vector.Zero, nil)
						end

						entity:Remove()
					end
				end
	
			end
		else
			mod.ItemsVars.waxCount = 0
		end
	end

	if player:HasCollectible(mod.Items.Terra) then
		if (game:GetFrameCount()) % 150 == 0 and not room:IsClear() and #mod:FindByTypeMod(mod.Entity.Apple)<mod:HowManyItems(mod.Items.Terra) then
			local position = Isaac.GetFreeNearPosition(room:GetRandomPosition(0), 10)
			local apple = mod:SpawnEntity(mod.Entity.Apple, position, Vector.Zero, player)
		end
	end

	if player:HasCollectible(mod.Items.Jupiter) then

		if Input.GetActionValue(ButtonAction.ACTION_BOMB, player.ControllerIndex) > 0 then
			mod.ModFlags.jupiterLocked = true
			mod:scheduleForUpdate(function()
				mod.ModFlags.jupiterLocked = false
				mod.ItemsVars.jupiterSets = {}
				mod.ItemsVars.nJupiterSets = 0
			end, 30)

			mod:JupiterContact(player, mod.ItemsVars.nJupiterSets, true)
		end
		
		mod:OnJupiterUpdate(player)
	end

	if player:HasCollectible(mod.Items.Saturnus) then
		if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == 0 then
			mod:PocketizeItem(player)
		end
	end

	if player:HasCollectible(mod.Items.Uranus) then
		if mod:LuckRoll(player.Luck+2, 25, 0.5) then
			local velocity
			if Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) > 0.9 then velocity = Vector(1,0) end
			if Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) > 0.9 then velocity = Vector(0,-1) end
			if Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) > 0.9 then velocity = Vector(-1,0) end
			if Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) > 0.9 then velocity = Vector(0,1) end

			if velocity then
				--player:FireTear(player.Position, velocity*player.ShotSpeed*10, true, true, false, player, 1) 

				velocity = -velocity*(10+rng:RandomFloat()*10)

				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, velocity, player):ToTear()
				tear:GetData().UranusPoopTear = true
				tear:SetColor(mod.Colors.poop2, 0, 99, true, true)


				tear.Height = tear.Height/4
				tear.FallingSpeed = -20;
				tear.FallingAcceleration = 1.5;
				tear.CollisionDamage = 1

				
			end
		end
	end

	--Moons
	local pressedDirection = shotDirection
	if not (pressedDirection.X == 0 or pressedDirection.Y == 0) then
		if pressedDirection.X > pressedDirection.Y then
			pressedDirection = Vector(pressedDirection.X, 0)
		else
			pressedDirection = Vector(0, pressedDirection.Y)
		end
	end

	local n = 1
	if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then n=n+player:GetTrinketMultiplier(TrinketType.TRINKET_FORGOTTEN_LULLABY) end
	if player:HasTrinket(mod.Trinkets.Flag) then n=n+player:GetTrinketMultiplier(mod.Trinkets.Flag) end

	data.PressedDirection_HC = pressedDirection
	data.MoonShootMultiplier_HC = n
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdate, 0)

function mod:OnUpdate()
	local room = game:GetRoom()
	
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		local data = player:GetData()

		
	
		if player:HasCollectible(mod.Items.Mars) then
			if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == 0 then
				mod:PocketizeItem(player)
			end

			if not player:GetData().marsOverhaulTime then player:GetData().marsOverhaulTime = -1 end

			player:GetData().marsOverhaulTime = math.max(-1, player:GetData().marsOverhaulTime - 1)
			local time = player:GetData().marsOverhaulTime

			if time > 0 then

				if time%2==0 and (true or not player:HasWeaponType(WeaponType.WEAPON_TEARS)) then
					local velocity
					if Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) > 0.9 then velocity = Vector(1,0) end
					if Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) > 0.9 then velocity = Vector(0,-1) end
					if Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) > 0.9 then velocity = Vector(-1,0) end
					if Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) > 0.9 then velocity = Vector(0,1) end

					if velocity then
						local tear = player:FireTear(player.Position, velocity*player.ShotSpeed*10, true, true, false, player, 1)
						tear:ChangeVariant(TearVariant.TECH_SWORD_BEAM)
					end
				end

				mod.ModFlags.marsEnabled = true
				mod.ModFlags.marsCharge = time/mod.MaxMarsCharge
			else
				mod.ModFlags.marsEnabled = false
				mod.ModFlags.marsCharge = 0
			end

			if time > 45 then
				sfx:Stop(Isaac.GetSoundIdByName("MarsDischarge"))
			elseif time == 45 then
				sfx:Play(Isaac.GetSoundIdByName("MarsDischarge"), 7.5)

			elseif time == 0 then
				sfx:Play(SoundEffect.SOUND_BERSERK_END)
				player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.Items.Mars))

				player:AddCacheFlags(CacheFlag.CACHE_ALL)
				player:EvaluateItems()
			end
			
			if player:GetData().marsOverhaulTime == 60 then
				sfx:Play(Isaac.GetSoundIdByName("OverhaulTicks"))
			end
		else
			player:GetData().marsOverhaulTime = -1
		end
		
		if player:HasCollectible(mod.Items.Saturnus) then
			local slot
			if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == mod.Items.Saturnus then slot = ActiveSlot.SLOT_PRIMARY
			elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == mod.Items.Saturnus then slot = ActiveSlot.SLOT_SECONDARY
			elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == mod.Items.Saturnus then slot = ActiveSlot.SLOT_POCKET end
			if slot then
				player:SetActiveCharge( math.floor(player:GetActiveCharge(slot) + 1), slot)
			end

			if mod.ModFlags.playerTimestuck then
				mod:SaturnStopTime(true)
		
				if game:GetFrameCount() == mod.ModFlags.playerTimestuckEndFrame then
		
					if mod.ModFlags.playerTimestuckRoomIdx == Game():GetLevel():GetCurrentRoomIndex() then
						mod:SaturnResumeTime(player)
						mod.ItemsVars.timeStops[player.ControllerIndex] = false
					
						player:AddCacheFlags(CacheFlag.CACHE_ALL)
						player:EvaluateItems()
		
						mod.ModFlags.playerTimestuck = false
						mod.ModFlags.playerTimestuckFlick = false
					end
				end

				local n = game:GetFrameCount() - mod.ModFlags.playerTimestuckStartFrame
				local m = mod.ModFlags.playerTimestuckEndFrame - mod.ModFlags.playerTimestuckStartFrame
		
				for i = 1, 7 do
					if n == m - i*5 then
						mod.ModFlags.playerTimestuckFlick = not mod.ModFlags.playerTimestuckFlick
					end
				end

			end
		end

		
		if player:HasCollectible(mod.Items.Neptunus) then

			local aimDirection = Vector(player:GetAimDirection().X, player:GetAimDirection().Y)
			local shotDirection = aimDirection

			if aimDirection:Length() == 0 then
				local fireDirection = Vector.Zero
				if player:GetFireDirection() == Direction.LEFT then
					fireDirection = fireDirection + Vector(-1,0)
				end
				if player:GetFireDirection() == Direction.UP then
					fireDirection = fireDirection + Vector(0,-1)
				end
				if player:GetFireDirection() == Direction.RIGHT then
					fireDirection = fireDirection + Vector(1,0)
				end
				if player:GetFireDirection() == Direction.DOWN then
					fireDirection = fireDirection + Vector(0,1)
				end
				shotDirection = fireDirection
			end

			if not data.AttackVector_HC then data.AttackVector_HC = Vector(0,1) end
			if not data.TridentCharge_HC then data.TridentCharge_HC = 0 end

			if shotDirection:Length() ~= 0 then
				data.AttackVector_HC = shotDirection
				data.TridentForce_HC = 0
				data.TridentCharge_HC = math.min(90, data.TridentCharge_HC + 1*10/player.MaxFireDelay)

			else
				data.TridentForce_HC = data.TridentCharge_HC
				data.TridentCharge_HC = 0
			end
		end
	end

end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)

function mod:OnTearSpawn(tear)
	if not tear.SpawnerEntity then return end

	local player = tear.SpawnerEntity:ToPlayer()

	if player and player:HasCollectible(mod.Items.Mercurius) then
		mod:MercuriusOnTearShot(player, tear)
	elseif tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and tear.SpawnerEntity.Variant == FamiliarVariant.MINISAAC and tear.SpawnerEntity:GetData().MercuriusColor then
        tear:GetData().MercuriusTearFlag = true
	end


end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.OnTearSpawn)

function mod:OnTearUpdate(tear)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

	if not data.Init then
		data.Init = true

		if data.MercuriusTearFlag then
			local anim = sprite:GetAnimation()
			local valid = string.sub(anim,1,11)=="RegularTear" or string.sub(anim,1,11)=="BloodTear"
			if valid then
				tear:ChangeVariant(Isaac.GetEntityVariantByName("Mercurius Tear (HC)"))
				sprite:Load("gfx/tear_Mercurius.anm2", true)
				sprite:Play(anim, true)
			elseif string.sub(anim,1,5)=="Stone" then
				tear:ChangeVariant(Isaac.GetEntityVariantByName("Mercurius Tear (HC)"))
				sprite:Load("gfx/tear_Mercurius_stone.anm2", true)
				sprite:Play(anim, true)
			elseif string.sub(anim,1,6)=="Rotate" and sprite:GetDefaultAnimation()=="Rotate0" then
				tear:ChangeVariant(Isaac.GetEntityVariantByName("Mercurius Tear (HC)"))
				sprite:Load("gfx/tear_Mercurius_rotate.anm2", true)
				sprite:Play(anim, true)
			end
		end
	else
		
		if data.MercuriusTearFlag then
			if tear:IsDead() then
				local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, tear.Position, Vector.Zero, nil)
				game:SpawnParticles (tear.Position, EffectVariant.DIAMOND_PARTICLE, 5, 3, mod.Colors.mercury)
				splat:GetSprite().Color = mod.Colors.mercury
				sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 1, 2, false, 1)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.OnTearUpdate)

function mod:OnNewRoom()
	local room = game:GetRoom()

	if not mod.savedata.nLocusts then
		mod.savedata.nLocusts = {[0] = 0, ["0"] = 0}
	end

	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i):ToPlayer()

		if not mod.savedata.nLocusts[tostring(player.ControllerIndex)] then
			mod.savedata.nLocusts[tostring(player.ControllerIndex)] = 0
		end
		mod:WilloCheck(player)

		if player:HasCollectible(mod.Items.Mercurius) then
			if rng:RandomFloat() <= 0.05 and room:IsFirstVisit() then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN)
			end
		end

		if player:HasCollectible(mod.Items.Jupiter) then
			mod.ItemsVars.jupiterPoints = {}
			mod.ItemsVars.nJupiterPoints = 0
		end

		if player:HasCollectible(mod.Items.Saturnus) then
			mod.ItemsVars.timeStops[player.ControllerIndex] = false
			mod.ModFlags.playerTimestuck = false
			mod.ModFlags.playerTimestuckFlick = false
			
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end

		if player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime > 0 then
			player:AddCostume (Isaac.GetItemConfig():GetCollectible(mod.Items.Mars), false)
		end
		
	end

	--Bismuth knife
	for _, k in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE, 0, 0)) do
		local player = k.SpawnerEntity:ToPlayer() or k.SpawnerEntity:ToFamiliar().Player:ToPlayer()
		if player and player:HasCollectible(mod.Items.Mercurius) then
			k:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bismuth_knife.png")
			k:GetSprite():LoadGraphics()
		end
	end
	for _, k in ipairs(mod:FindByTypeMod(mod.Entity.Trident)) do
		local player = k.SpawnerEntity:ToPlayer() or k.SpawnerEntity:ToFamiliar().Player:ToPlayer()
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) then
			k:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_trident_feferi.png")
			k:GetSprite():LoadGraphics()
		end
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) then
			k:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_trident_nihil.png")
			k:GetSprite():LoadGraphics()
		end
	end

	--QuantumShard
	for _, shard in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.Trinkets.Shard)) do
		shard.Position = room:GetRandomPosition(0)
	end


	--Errant Moons
	for _, errant in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR, 9)) do
		local moons = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR)
		local random = mod:RandomInt(1, #moons)
		local i = 1
		for _, moon in ipairs(moons) do
			if moon.SubType ~= 9 and i==random then
				errant = errant:ToFamiliar()
				errant.Parent = moon
				errant:AddToOrbit(mod.MoonOrbits[moon.SubType])
				break
			end
			i=i+1
		end
	end


end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)

function mod:OnCache(player, cacheFlag)

    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		--Venus
		local numItem = player:GetCollectibleNum(mod.Items.Venus)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		
		player:CheckFamiliar(mod.EntityInf[mod.Entity.FamiliarCandle].VAR, numFamiliars, player:GetCollectibleRNG(mod.Items.Venus), Isaac.GetItemConfig():GetCollectible(mod.Items.Venus))

		
		--Neptune
		local numItem = player:GetCollectibleNum(mod.Items.Neptunus)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Trident].VAR, numFamiliars, player:GetCollectibleRNG(mod.Items.Neptunus), Isaac.GetItemConfig():GetCollectible(mod.Items.Neptunus))


		--Mini moon
		local numItem = player:GetCollectibleNum(mod.Moons.Luna)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Luna), Isaac.GetItemConfig():GetCollectible(mod.Moons.Luna), 0)
		local numItem = player:GetCollectibleNum(mod.Moons.Mercury)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Mercury), Isaac.GetItemConfig():GetCollectible(mod.Moons.Mercury), 1)
		local numItem = player:GetCollectibleNum(mod.Moons.Venus)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Venus), Isaac.GetItemConfig():GetCollectible(mod.Moons.Venus), 2)
		local numItem = player:GetCollectibleNum(mod.Moons.Terra)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Terra), Isaac.GetItemConfig():GetCollectible(mod.Moons.Terra), 3)
		local numItem = player:GetCollectibleNum(mod.Moons.Mars)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Mars), Isaac.GetItemConfig():GetCollectible(mod.Moons.Mars), 4)
		local numItem = player:GetCollectibleNum(mod.Moons.Jupiter)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Jupiter), Isaac.GetItemConfig():GetCollectible(mod.Moons.Jupiter), 5)
		local numItem = player:GetCollectibleNum(mod.Moons.Saturn)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Saturn), Isaac.GetItemConfig():GetCollectible(mod.Moons.Saturn), 6)
		local numItem = player:GetCollectibleNum(mod.Moons.Uranus)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Uranus), Isaac.GetItemConfig():GetCollectible(mod.Moons.Uranus), 7)
		local numItem = player:GetCollectibleNum(mod.Moons.Neptune)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Neptune), Isaac.GetItemConfig():GetCollectible(mod.Moons.Neptune), 8)
		local numItem = player:GetCollectibleNum(mod.Moons.Errant)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Errant), Isaac.GetItemConfig():GetCollectible(mod.Moons.Errant), 9)
		local numItem = player:GetCollectibleNum(mod.Moons.Ceres)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Ceres), Isaac.GetItemConfig():GetCollectible(mod.Moons.Ceres), 10)
		local numItem = player:GetCollectibleNum(mod.Moons.Io)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Io), Isaac.GetItemConfig():GetCollectible(mod.Moons.Io), 11)
		local numItem = player:GetCollectibleNum(mod.Moons.Europa)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Europa), Isaac.GetItemConfig():GetCollectible(mod.Moons.Europa), 12)
		local numItem = player:GetCollectibleNum(mod.Moons.Ganymede)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Ganymede), Isaac.GetItemConfig():GetCollectible(mod.Moons.Ganymede), 13)
		local numItem = player:GetCollectibleNum(mod.Moons.Callisto)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Callisto), Isaac.GetItemConfig():GetCollectible(mod.Moons.Callisto), 14)
		local numItem = player:GetCollectibleNum(mod.Moons.Titan)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Titan), Isaac.GetItemConfig():GetCollectible(mod.Moons.Titan), 15)
		local numItem = player:GetCollectibleNum(mod.Moons.Titania)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Titania), Isaac.GetItemConfig():GetCollectible(mod.Moons.Titania), 16)
		local numItem = player:GetCollectibleNum(mod.Moons.Oberon)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Oberon), Isaac.GetItemConfig():GetCollectible(mod.Moons.Oberon), 17)
		local numItem = player:GetCollectibleNum(mod.Moons.Triton)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Triton), Isaac.GetItemConfig():GetCollectible(mod.Moons.Triton), 18)
		local numItem = player:GetCollectibleNum(mod.Moons.Pluto)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Pluto), Isaac.GetItemConfig():GetCollectible(mod.Moons.Pluto), 19)
		local numItem = player:GetCollectibleNum(mod.Moons.Charon)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Charon), Isaac.GetItemConfig():GetCollectible(mod.Moons.Charon), 20)
		local numItem = player:GetCollectibleNum(mod.Moons.Eris)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Eris), Isaac.GetItemConfig():GetCollectible(mod.Moons.Eris), 21)
		local numItem = player:GetCollectibleNum(mod.Moons.Makemake)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Makemake), Isaac.GetItemConfig():GetCollectible(mod.Moons.Makemake), 22)
		local numItem = player:GetCollectibleNum(mod.Moons.Haumea)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Haumea), Isaac.GetItemConfig():GetCollectible(mod.Moons.Haumea), 23)
		local numFamiliars = 0
		if player:HasTrinket(mod.Trinkets.Sputnik) then numFamiliars = 1 end
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetTrinketRNG(mod.Trinkets.Sputnik), Isaac.GetItemConfig():GetTrinket(mod.Trinkets.Sputnik), 24)
		local numItem = player:GetCollectibleNum(mod.Moons.Iris)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.Iris), Isaac.GetItemConfig():GetCollectible(mod.Moons.Iris), 25)
		local numItem = player:GetCollectibleNum(mod.Moons.End)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(mod.Moons.End), Isaac.GetItemConfig():GetCollectible(mod.Moons.End), 26)
		
	end

	if player:HasCollectible(mod.Items.Mercurius) then
		if cacheFlag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		elseif cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.23
		end

	end

	if player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime > 0 and player:HasCollectible(mod.Items.Mars) then
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 1.2

		elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay/15

		elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed*3

		elseif cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 75
				
		elseif cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = mod.Colors.red
				
		elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage*2.5

		elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_PERSISTENT |  TearFlags.TEAR_EXPLOSIVE |  TearFlags.TEAR_PULSE | TearFlags.TEAR_HOMING
		end

	end

	if mod.ItemsVars.timeStops[player.ControllerIndex] then
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = 10
		elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay/3
		elseif cacheFlag == CacheFlag.CACHE_TEARCOLOR then
				player.TearColor = mod.Colors.timeChanged
		end

	end

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCache)


function mod:SpawnTainted()
	local subtype = 733
	local playerCount = 0

	for i=1, 7 do
		Isaac.ExecuteCommand("addplayer "..tostring(i))
	end

	for i=-1, 1, 2 do
		local yOffset = i*50

		for j=-2, 1 do
			local xOffset = (j+0.5)*100

			local position = game:GetRoom():GetCenterPos() + Vector(xOffset, yOffset)

			if subtype <= 740 then
				local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, subtype, position, Vector.Zero, nil)

				local player = Isaac.FindByType(EntityType.ENTITY_PLAYER, 0, playerCount)[1]:ToPlayer()
				if player then
					player.Position = position + Vector(0,35)
					player:AddCollectible(subtype)

					playerCount = playerCount + 1

					
					local candle = Isaac.FindByType(Isaac.GetEntityTypeByName("Candle (HC)"))[1]
					if candle then
					candle.Position = candle.Position - Vector(0,20)
					end
				end
			end
			subtype = subtype+ 1
		end
	end
end
--MERCURIUS
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%&@@@@&%%%%%@@@@@%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@&%%%%%%%%%%%&@@@@&%%%%%%%%%%%%&@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@@%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@@%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
function mod:MercuriusOnTearShot(player, tear)
    if mod:LuckRoll(player.Luck, 6, 0.5) then
        tear:GetData().MercuriusTear = true
        tear:GetData().MercuriusTearFlag = true
    end
end

function mod:SpawnMiniIsaacMercury(player, position)

	if #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC) >= 25 then return end

	sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 1, 2, false, 1)
	local miniIsaac = player:AddMinisaac(position)
	miniIsaac:GetData().MercuriusColor = true
	miniIsaac:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_minisaac_mercury.png")
	miniIsaac:GetSprite():ReplaceSpritesheet(1, "gfx/familiar/familiar_minisaac_mercury.png")
	miniIsaac:GetSprite():LoadGraphics()
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, entity)
	if entity:GetData().MercuriusColor then
		entity:GetSprite().Color = mod.Colors.mercury

	end
end, FamiliarVariant.MINISAAC)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount)
	if entity.Variant == FamiliarVariant.MINISAAC and entity:GetData().MercuriusColor then
		if entity.HitPoints <= amount then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, Vector.Zero, entity.Player)
			creep.SpriteScale = Vector.One * 0.01
			creep:GetSprite().Color = mod.Colors.mercury
		end
	end
end, EntityType.ENTITY_FAMILIAR)

function mod:MercuriusTearCollision(tear, collider)
	if tear:GetData().MercuriusTear and collider and collider:IsActiveEnemy() then
		
		local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, tear.Position, Vector.Zero, nil)
		game:SpawnParticles (tear.Position, EffectVariant.DIAMOND_PARTICLE, 5, 3, mod.Colors.mercury)
		splat:GetSprite().Color = mod.Colors.mercury
		sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 1, 2, false, 1)


		local player = tear.SpawnerEntity
		if player then
			player = player:ToPlayer() or player:ToFamiliar().Player:ToPlayer()
			local letal = player.Damage >= collider.HitPoints
			if letal then
				mod:SpawnMiniIsaacMercury(player, collider.Position)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.MercuriusTearCollision)
function mod:MercuriusKnifeCollision(knife, collider)
	if collider and collider:IsActiveEnemy() then
		local player = knife.SpawnerEntity
		if player and (player:ToPlayer() or (player:ToFamiliar() and player:ToFamiliar().Player:ToPlayer())) then
			player = player:ToPlayer() or player:ToFamiliar().Player:ToPlayer()
			local letal = player.Damage >= collider.HitPoints
			if player:HasCollectible(mod.Items.Mercurius) and letal and mod:LuckRoll(player.Luck, 6, 0.45) then
				mod:SpawnMiniIsaacMercury(player, collider.Position)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, mod.MercuriusKnifeCollision)
function mod:MercuriusLaserHit(enemy, amount, flags, sourceRef)

	local letal = (amount >= enemy.HitPoints)

	if enemy and enemy:IsActiveEnemy() and letal and (flags&DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER) then
		local player = sourceRef.Entity
		if player and (player:ToPlayer() or (player:ToFamiliar() and player:ToFamiliar().Player:ToPlayer())) then
			player = player:ToPlayer() or player:ToFamiliar().Player:ToPlayer()
			if player:HasCollectible(mod.Items.Mercurius) and mod:LuckRoll(player.Luck, 6, 0.5) then
				mod:SpawnMiniIsaacMercury(player, enemy.Position)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.MercuriusLaserHit)
function mod:MercuriusBombHit(enemy, amount, flags, sourceRef)

	local letal = (amount >= enemy.HitPoints)

	if enemy and enemy:IsActiveEnemy() and letal and (flags&DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION) then
		local bomb = sourceRef.Entity

		if bomb and bomb.SpawnerEntity and (bomb.SpawnerEntity:ToPlayer() or (bomb.SpawnerEntity:ToFamiliar() and bomb.SpawnerEntity:ToFamiliar().Player)) then
			local player = bomb.SpawnerEntity:ToPlayer() or bomb.SpawnerEntity:ToFamiliar().Player:ToPlayer()
			if player:HasCollectible(mod.Items.Mercurius) and mod:LuckRoll(player.Luck, 6, 0.5) then
				mod:SpawnMiniIsaacMercury(player, enemy.Position)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.MercuriusBombHit)

--VENUS
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%@@&%%%%%%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%&@@@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@&%%%%&@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@&%%%%%%%&@@@@@@&%%&@@@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%%@@&%%%%%%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%%%%@@@@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%%%%%%&@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
function mod:OnCanldeInit(familiar)
    familiar.IsFollower = true
	familiar:AddToFollowers()

	local sprite = familiar:GetSprite()
	sprite:Play("Idle0")
end

function mod:WaxifyEnemy(enemy)
	local id = enemy.Type
	local variant = enemy.Variant

	local sprite = enemy:GetSprite()

	if id == EntityType.ENTITY_CLOTTY then
		if variant == 0 then--Normal clotty
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/clotty_wax.png")
		elseif variant == 1 then--Tar clot
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/clot_wax.png")
		elseif variant == 2 then--I blob
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/lblob_wax.png")
		elseif variant == 3 then--Grilled clotty
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/grilledclotty_wax.png")
		end

	elseif id == EntityType.ENTITY_VIS then
		if variant == 0 then--Normal vis
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/vis_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/vis_wax.png")
		elseif variant == 1 then--Doble vis
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/doublevis_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/doublevis_wax.png")
		elseif variant == 2 then--Chubber
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/chubber_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/chubber_wax.png")
		end

	elseif id == EntityType.ENTITY_DANNY then
		if variant == 0 then--Danny
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/danny_body_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/danny_wax.png")
		elseif variant == 1 then--Coal boy
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/coalboy_body_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/coalboy_wax.png")
		end
		
	elseif id == EntityType.ENTITY_GURGLE then
		if variant == 0 then--Gurgle
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/gurgle_body_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/gurgle_wax.png")
		end

	elseif id == EntityType.ENTITY_HIVE then
		if variant == 0 then--Hive
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/hive_wax.png")
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/generic_body2_wax.png")
		elseif variant == 1 then--DHive
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/drownedhive_wax.png")
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/generic_body2_wax.png")
		elseif variant == 2 then--Holy
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/holy_mulligan_wax.png")
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/generic_body_wax.png")
		end
		
	elseif id == EntityType.ENTITY_NEST then
		if variant == 0 then--Nest
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/nest_wax.png")
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/generic_body2_wax.png")
		end

	elseif id == EntityType.ENTITY_BONY then
		if variant == 0 then--Bony
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/bonye_body_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/boney_wax.png")
		elseif variant == 1 then--HBony
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/holy_bony_body_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/holy_bony_wax.png")
		end
	elseif id == EntityType.ENTITY_BLACK_BONY then
		if variant == 0 then--BBony
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/blackboney_wax.png")
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/bonye_body_wax.png")
		end
		
	elseif id == EntityType.ENTITY_BLASTER then
		if variant == 0 then--Blaster
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/blaster_wax.png")
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/blaser_body_wax.png")
		end

	elseif id == EntityType.ENTITY_DOPLE then
		if variant == 0 then--Dople
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/generic_body2_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/doble_wax.png")
		elseif variant == 1 then--Evil twin
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/eviltwin_wax.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/wax_friends/eviltwin_wax.png")
			sprite:ReplaceSpritesheet(2, "gfx/monsters/wax_friends/eviltwin_wax.png")
		end
		
	elseif id == EntityType.ENTITY_MAW then
		if variant == 0 then--Maw
			sprite:ReplaceSpritesheet(0, "gfx/monsters/wax_friends/maw_wax.png")
		end

	end

	enemy:GetData().OriginalHP = enemy.HitPoints
	sprite:LoadGraphics()
	sprite.Color = Color.Default
end

function mod:OnCandleUpdate(familiar)
	familiar:FollowParent()

    local sprite = familiar:GetSprite()
    local room = game:GetRoom()
	local data = familiar:GetData()

	if not data.Init then
		data.Init = true
		
		data.Souls = 0
	end

	if sprite:IsFinished("Idle3") then
		sprite:Play("Summon", true)

	elseif sprite:IsFinished("Summon") then
		if familiar.Player and familiar.Player:HasCollectible(mod.Items.Venus) then
			for _, entity in ipairs(Isaac.GetRoomEntities()) do
				entity:GetData().Flagged_HC = true
			end

			familiar.Player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, false, false, true, false)
			mod:scheduleForUpdate(function()
				for _, entity in ipairs(Isaac.GetRoomEntities()) do
					if not entity:GetData().Flagged_HC and (entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or entity:HasEntityFlags(EntityFlag.FLAG_CHARM)) then
						entity:GetData().IsWax_HC = true
						entity:GetData().IsTrueWax_HC = true
						--Wax skin
						mod:WaxifyEnemy(entity)
						entity.Position = familiar.Position
					end
				end
			end, 3)

			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, familiar.Position + Vector(5,0), Vector.Zero, nil)
			poof:GetSprite().Color = mod.Colors.fire
		end
		
		sprite:Play("Idle0", true)
		data.Souls = 0
	end

end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnCanldeInit, mod.EntityInf[mod.Entity.FamiliarCandle].VAR)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnCandleUpdate, mod.EntityInf[mod.Entity.FamiliarCandle].VAR)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, entity)
	local valid = entity:IsEnemy() 
				and entity.MaxHitPoints > 7 
				and mod:SomebodyHasItem(mod.Items.Venus)
				and not entity.Parent
				and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
	if valid then
		for _, candle in ipairs(mod:FindByTypeMod(mod.Entity.FamiliarCandle)) do
			local data = candle:GetData()
			local sprite = candle:GetSprite()

			data.Souls = data.Souls + 1

			local a=5
			local b=10
			local c=15

			if candle.Player and candle.Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
				a=3
				b=8
				c=11
			end

			if data.Souls > c and sprite:IsPlaying("Idle2") then
				local frame = sprite:GetFrame()
				sprite:Play("Idle3", true)
				sprite:SetFrame(frame)
			elseif data.Souls > b and sprite:IsPlaying("Idle1") then
				local frame = sprite:GetFrame()
				sprite:Play("Idle2", true)
				sprite:SetFrame(frame)
			elseif data.Souls > a and sprite:IsPlaying("Idle0") then
				local frame = sprite:GetFrame()
				sprite:Play("Idle1", true)
				sprite:SetFrame(frame)
			end
		end
	end
end)

function mod:WaxSummon(entity)
	if entity.SpawnerEntity and entity.SpawnerEntity:GetData().IsWax_HC then
		mod:scheduleForUpdate(function()
			entity:GetData().IsWax_HC = true
			entity:GetSprite().Color = mod.Colors.fire
		end,1)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.WaxSummon)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.WaxSummon)
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.WaxSummon)
--[[
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	mod:scheduleForUpdate(function()
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if not entity:GetData().Flagged_HC and (entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or entity:HasEntityFlags(EntityFlag.FLAG_CHARM)) then
				entity:GetData().IsWax_HC = true
				--Wax skin
				mod:WaxifyEnemy(entity)
			end
		end
	end, 3)
end, CollectibleType.COLLECTIBLE_FRIEND_FINDER)
]]

function mod:WilloCheck(player)

	local function IsLocustOfPlayer(willo, player)
		local r = player and (willo:GetData().playerId == player.ControllerIndex or (willo.Player and willo.Player.ControllerIndex == player.ControllerIndex))
		if not r then
			willo:Remove()
		end
		return r
	end

	local willos = mod:FindByTypeMod(mod.Entity.Willo)

	local nWillosReal = mod.savedata.nLocusts[tostring(player.ControllerIndex)] --How many willos should be
	if not nWillosReal then return end
	local nWillos = 0 --How many willos are in room
	for _, willo in ipairs(willos) do
		if IsLocustOfPlayer(willo, player) then
			nWillos = nWillos + 1
		end
	end

	if nWillos > nWillosReal then --If there are more than there should be
		local i = 1
		for _, willo in ipairs(willos) do
			if IsLocustOfPlayer(willo, player) then
				if i>nWillosReal then
					willo:Remove()
				end
				i=i+1
			end
		end
	elseif nWillos < nWillosReal then --If there are less that there should be
		for i = nWillos, nWillosReal-1 do
			local willo = mod:SpawnEntity(mod.Entity.Willo, player.Position, Vector.Zero, player):ToFamiliar()
			willo.Player = player
			willo:GetData().playerId = player.ControllerIndex

			mod:scheduleForUpdate(function()
				if willo then
					willo:GetSprite():Load("gfx/familiar_BlazingLocust.anm2")
					willo:GetSprite():LoadGraphics()
					willo:GetSprite():Play("Fly", true)
				end
			end, 2)
		end
	end

end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup:GetSprite():IsFinished("Collect") then pickup:Remove() end
end, mod.EntityInf[mod.Entity.BlazeHeart].VAR)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
	local player = collider:ToPlayer()
	if not player then return end

	if player and player.ControllerIndex and mod.savedata.nLocusts and mod.savedata.nLocusts[tostring(player.ControllerIndex)] and mod.savedata.nLocusts[tostring(player.ControllerIndex)] < 4 then

		mod.savedata.nLocusts[tostring(player.ControllerIndex)] = mod.savedata.nLocusts[tostring(player.ControllerIndex)] + 1
		
		pickup.Velocity = Vector.Zero
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		pickup:GetSprite():Play("Collect")

		mod:WilloCheck(player)

		sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
		--[[
		player:GetData().Invulnerable_HC = true
		mod:scheduleForUpdate(function()
			player:GetData().Invulnerable_HC = false
		end, 30)

		if player:GetData().Invulnerable_HC then
			local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, player.Position, Vector.Zero, player):ToEffect()
		end]]
	end

end, mod.EntityInf[mod.Entity.BlazeHeart].VAR)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, damageFlags)
	if entity:GetData().IsWax_HC then
		local invalid = (damageFlags&DamageFlag.DAMAGE_FIRE==DamageFlag.DAMAGE_FIRE)
		or (damageFlags&DamageFlag.DAMAGE_SPIKES==DamageFlag.DAMAGE_SPIKES)
		if invalid then return false end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, willo, entity)
	entity = entity:ToNPC()

	if (willo.SubType ~= mod.EntityInf[mod.Entity.Willo].SUB) or (not(entity and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY))) then
		return
	end

	if entity then
		if not entity:HasEntityFlags(EntityFlag.FLAG_BURN) then
			entity:AddEntityFlags(EntityFlag.FLAG_BURN)
			mod:scheduleForUpdate(function()
				if entity then
					entity:ClearEntityFlags(EntityFlag.FLAG_BURN)
				end
			end, 30*5)
		end
	end
end, mod.EntityInf[mod.Entity.Willo].VAR)

--TERRA
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%&@@@@&%&@@@@@%%&@@@@&%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%&@@@@@%%&@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%&@@@@@%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%&@@@@@%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%&@@@@@%%&@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%&@@@@&%&@@@@@%%&@@@@&%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
function mod:AppleUpdate(pickup)
	local data = pickup:GetData()
	local sprite = pickup:GetSprite()
	local room = game:GetRoom()

	if room:IsClear() then
		sprite:Play("Collect"..tostring(string.sub(sprite:GetAnimation(),#sprite:GetAnimation())))
	end

	if not data.Init then
		data.Init = true

		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end

	if sprite:IsFinished("Appear") then
		sprite:Play("Idle1", true)
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	elseif sprite:IsFinished("Grow1") then
		sprite:Play("Idle2", true)
	elseif sprite:IsFinished("Grow2") then
		sprite:Play("Idle3", true)
	elseif sprite:IsFinished("Collect1") or sprite:IsFinished("Collect2") or sprite:IsFinished("Collect3") then
		pickup:Remove()

	elseif pickup.FrameCount == 250 and not data.Picked then
		sprite:Play("Grow1", true)
	elseif pickup.FrameCount == 750 and not data.Picked then
		sprite:Play("Grow2", true)

	end

end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.AppleUpdate, mod.EntityInf[mod.Entity.Apple].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
	local player = collider:ToPlayer()
	local sprite = pickup:GetSprite()

	if player and player:HasCollectible(mod.Items.Terra) and (sprite:IsPlaying("Idle1") or sprite:IsPlaying("Idle2") or sprite:IsPlaying("Idle3")) then
		pickup:GetData().Picked = true
		pickup.Velocity = Vector.Zero
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

		local size = tostring(string.sub(pickup:GetSprite():GetAnimation(),#pickup:GetSprite():GetAnimation()))
		pickup:GetSprite():Play("Collect"..size)

		local victim
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if (victim == nil or entity.HitPoints > victim.HitPoints) and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				victim = entity
			end
		end
		if not victim then victim = player end
		local variant = 0
		if size == "1" then 
			variant = mod.EntityInf[mod.Entity.Snake3].VAR 
		elseif size == "2" then 
			variant = mod.EntityInf[mod.Entity.Snake2].VAR 
		elseif size == "3" then 
			variant = mod.EntityInf[mod.Entity.Snake1].VAR 
		end

		local position, rotation = mod:RandomUpDown()
		local posY = position.Y
		if game:GetRoom():GetCenterPos().Y > posY then
			posY = posY - 250
		else
			posY = posY + 250
		end

		local position = Vector(victim.Position.X, posY)
		local snake = Isaac.Spawn(mod.EntityInf[mod.Entity.Snake1].ID, variant, 0, position, Vector.Zero, player)
		snake:GetData().Target = victim
	end

end, mod.EntityInf[mod.Entity.Apple].VAR)

function mod:SnakeUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Snake1].VAR or
		entity.Variant == mod.EntityInf[mod.Entity.Snake2].VAR or
		entity.Variant == mod.EntityInf[mod.Entity.Snake3].VAR then
		
		entity.Velocity = Vector.Zero

		local data = entity:GetData()
		local room = game:GetRoom()

		local n = (1 + (entity.Variant - mod.EntityInf[mod.Entity.Snake3].VAR))
		local m = 0.125*n + 0.625
		
		if not data.Init then
			data.Init = true

			data.Direcion = -1 --Up
			if entity.Position.Y < room:GetCenterPos().Y then
				data.Direcion = 1 --Down
				entity:GetSprite().FlipY = true
			end

			if not data.PosX then data.PosX = entity.Position.X end
			if not data.Offset then data.Offset = 0 end

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			entity.CollisionDamage = 7*n
			entity:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:GetSprite().Color = Color.Default

			
			if entity.SubType == 0 then
				local parent = entity

				for i=1, 13*n do
					local position = entity.Position - Vector(0, -data.Direcion*50*m)
					local tail = Isaac.Spawn(mod.EntityInf[mod.Entity.Snake1].ID, entity.Variant, 1, position, Vector.Zero, entity)
					tail.Parent = parent

					if data.Direcion > 0 then
						tail.DepthOffset = parent.DepthOffset + data.Direcion*51*m
					end

					tail:GetData().PosX = data.PosX
					tail:GetData().Offset = i*86
					
					tail:GetData().Target = entity:GetData().Target

					parent = tail
				end


			elseif entity.SubType == 1 then
				entity:GetSprite():Play("Tail", true)
			end
		end

		if data.Target then
			data.PosX = data.PosX*0.975 + data.Target.Position.X*0.025
		end

		local posX = data.PosX + 20*math.sin((entity.FrameCount + data.Offset)/1.75)

		local posY
		if entity.SubType == 0 then
			if math.abs(entity.Position.Y) > 4000 then entity:Remove() end
			posY = entity.Position.Y + data.Direcion*25

		elseif entity.SubType == 1 then
			if not entity.Parent then 
				entity:Remove() 
				return 
			end
			posY = entity.Parent.Position.Y - data.Direcion*75*m
		end

		entity.Position = Vector(posX, posY)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SnakeUpdate, mod.EntityInf[mod.Entity.Snake1].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
	if source and source.Type == mod.EntityInf[mod.Entity.Snake1].ID and 
		(entity.Variant == mod.EntityInf[mod.Entity.Snake1].VAR or
		entity.Variant == mod.EntityInf[mod.Entity.Snake2].VAR or
		entity.Variant == mod.EntityInf[mod.Entity.Snake3].VAR) and
		source.Entity and (flags&DamageFlag.DAMAGE_CLONES==0) then
		entity:TakeDamage(source.Entity.CollisionDamage+2, flags | DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR | DamageFlag.DAMAGE_CLONES, source, frames)
		entity.Velocity = Vector.Zero
		entity.Position = mod:Lerp(entity.Position, source.Entity.Position, 0.1)
		return false
	end
end)

--MARS
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@&%&@@@@&%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
function mod:MarsTearInit(tear)
	if not tear.SpawnerEntity then return end
	local player = tear.SpawnerEntity:ToPlayer()

	if player and player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime > 0 then

		tear.HomingFriction = 10

		game:ShakeScreen(20)
		tear.Velocity = tear.Velocity:Rotated(mod:RandomInt(-5,5))*(0.8 + rng:RandomFloat()*0.6)
		
		local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, tear.Position, tear.Velocity, nil):ToEffect()
		energy.LifeSpan = 1000
		energy.Parent = tear
		energy.DepthOffset = 5
		energy:GetData().HeavensCall = true
		energy:GetData().MarsShot_HC = true
		energy:FollowParent(tear)

		player.Velocity = player.Velocity - tear.Velocity*0.15

		--Laser
		local succes = mod:LuckRoll(player.Luck, 5, 0.85) or mod:LuckRoll(player.Luck, 5, 0.85)
		if succes then
			local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, player.Position, tear.Velocity:GetAngleDegrees(), 3, Vector(0, -20), player)
			laser:AddTearFlags(TearFlags.TEAR_HOMING)
		end
	end

end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.MarsTearInit)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectibleType, rng, player, flags, slot)

	if math.floor(4 * player:GetActiveCharge(slot) / 1000) ~= 1000 then
		if player:GetPlayerType() == PlayerType.PLAYER_BETHANY then
			local ogCurrentCharges = player:GetActiveCharge(slot)
			local currentCharges = math.floor(4 * player:GetActiveCharge(slot) / 1000)
			local soulCharges = player:GetEffectiveSoulCharge()

			if currentCharges ~= 1000 and soulCharges < (4 - currentCharges) then
				player:SetSoulCharge(soulCharges + 1)
				mod:scheduleForUpdate(function()
					player:SetActiveCharge(ogCurrentCharges, slot)
					player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.Items.Mars))
				end,2)
				return false
			else
				player:SetSoulCharge(soulCharges + 1 - (4 - currentCharges))
			end

		elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
			local ogCurrentCharges = player:GetActiveCharge(slot)
			local currentCharges = math.floor(4 * player:GetActiveCharge(slot) / 1000)
			local bloodCharges = player:GetEffectiveBloodCharge()

			if currentCharges ~= 1000 and bloodCharges < (4-currentCharges) then
				player:SetBloodCharge(bloodCharges + 1)
				mod:scheduleForUpdate(function()
					player:SetActiveCharge(ogCurrentCharges, slot)
				end,2)
				return false
			else
				player:SetBloodCharge(bloodCharges + 1 - (4-currentCharges))
			end
		end
	end

	local n = 7.5
	player:GetData().marsOverhaulTime = player:GetData().marsOverhaulTime + n*30

	sfx:Play(SoundEffect.SOUND_BERSERK_START)

	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()

end, mod.Items.Mars)

mod.MaxMarsCharge = 300

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
	if (not source or not source.Entity) then return end
	source = source.Entity

	local letal = entity.HitPoints <= amount
	local player = source:ToPlayer()
	if not player then
		if source.SpawnerEntity then
			player = source.SpawnerEntity:ToPlayer()
		end
	end

	if player and player:GetData().marsOverhaulTime>0 and entity:IsEnemy() and not entity:GetData().MarsFlag and letal then
		entity:GetData().MarsFlag = true
		if player:HasCollectible(mod.Items.Mars) then
			player:GetData().marsOverhaulTime = math.min(player:GetData().marsOverhaulTime + 20, mod.MaxMarsCharge)
		end
	end

	if player and player:HasCollectible(mod.Items.Mars) then
		local slot
		if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == mod.Items.Mars then slot = ActiveSlot.SLOT_PRIMARY
		elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == mod.Items.Mars then slot = ActiveSlot.SLOT_SECONDARY
		elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == mod.Items.Mars then slot = ActiveSlot.SLOT_POCKET end
		if slot then
			if player and player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime>0 then
				player:SetActiveCharge( math.floor(player:GetActiveCharge(slot) + amount/3), slot)
			else
				player:SetActiveCharge( math.floor(player:GetActiveCharge(slot) + amount), slot)
			end
		end
	end

end)

--JUPITER
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%&@@@@@@@&%%%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
function mod:ElectrifyEntity(entity, player)
	local function SpawnThunder(position)
		position = position or entity.Position
		local thunder = mod:SpawnEntity(mod.Entity.Thunder, position, Vector.Zero, player)
		thunder:GetSprite().PlaybackSpeed = 2
		thunder.CollisionDamage = 100

		return thunder
	end

	if mod:IsAnEnemy(entity) then
		SpawnThunder()
		for i=1, 5 do
			local position = entity.Position + Vector(rng:RandomFloat()*100, 0):Rotated(rng:RandomFloat() * 360)
			SpawnThunder(position)
		end

	elseif entity.Type == EntityType.ENTITY_SLOT then
		local valid = entity.Variant == 1 or entity.Variant == 2 or entity.Variant == 3 or entity.Variant == 8 or entity.Variant == 10 or entity.Variant == 11 or
		entity.Variant == 1020 or entity.Variant == 1032 or entity.Variant == 542 or entity.Variant == 16 or entity.Variant == 735 or entity.Variant == 1100 or entity.Variant == 1101 or entity.Variant == 1040 or entity.Variant == mod.EntityInf[mod.Entity.Telescope].VAR
		if valid then
			SpawnThunder():GetSprite().PlaybackSpeed = 4

			if rng:RandomFloat() < 0.25 then
				entity.Velocity = Vector(rng:RandomFloat()*10, 0):Rotated(rng:RandomFloat() * 360)
				game:BombExplosionEffects (entity.Position, 0, TearFlags.TEAR_NORMAL, mod.Colors.jupiterLaser2, nil, 1, true, false, DamageFlag.DAMAGE_EXPLOSION )
			else
				mod:TriggerSlotMachine(entity, player)
			end
		end

	elseif entity.Type == EntityType.ENTITY_SHOPKEEPER then
		SpawnThunder():GetSprite().PlaybackSpeed = 4

		mod:scheduleForUpdate(function()
			if not entity then return end
			local keeper
			if rng:RandomFloat() < 0.5 then
				keeper = Isaac.Spawn(EntityType.ENTITY_KEEPER, 0, 0, entity.Position, Vector.Zero, player)
				keeper:AddCharmed(EntityRef(player), -1)
			else
				keeper = Isaac.Spawn(EntityType.ENTITY_HANGER, 0, 0, entity.Position, Vector.Zero, player)
				keeper:AddCharmed(EntityRef(player), -1)

			end

			mod:scheduleForUpdate(function()
				if not keeper then return end
				for _, f in ipairs(Isaac.FindByType(EntityType.ENTITY_ETERNALFLY)) do
					if f.Parent == keeper then
						f:Die()
					end
				end
			end, 2)

			entity:Die()
		end, 5)

		
	elseif entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_LIL_BATTERY then
		SpawnThunder():GetSprite().PlaybackSpeed = 4

		mod:scheduleForUpdate(function()
			if not entity then return end
			local random = rng:RandomFloat()
			entity = entity:ToPickup()

			if entity.SubType == BatterySubType.BATTERY_MICRO and random < 0.80 then
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL)
			elseif entity.SubType == BatterySubType.BATTERY_NORMAL and random < 0.40 then
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MEGA)
			elseif entity.SubType == BatterySubType.BATTERY_MEGA and random < 0.20 then
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_GOLDEN)
			elseif entity.SubType == BatterySubType.BATTERY_GOLDEN and random < 0.10 then
				local r = mod:RandomInt(1,6)
				local position = entity.Position
				if r == 1 then
					entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_9_VOLT)
				elseif r == 2 then
					entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_CAR_BATTERY)
				elseif r == 3 then
					entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BATTERY)
				elseif r == 4 then
					entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BATTERY_PACK)
				elseif r == 5 then
					entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_4_5_VOLT)
				else
					entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_CHARGED_BABY)
				end
				entity.Position = position
			else
				entity:Remove()
				game:BombExplosionEffects (entity.Position, 0, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.6, true, false, DamageFlag.DAMAGE_EXPLOSION)
			end
		end, 5)
	end
end

--jupiterSets = {},
--nJupiterSets = 0,

function mod:DistanceFromLastVolt(playerPos)
	if mod.ItemsVars.nJupiterSets == 0 then return 999 end

	local lastVoltPos = mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets].POSITION

	return lastVoltPos:Distance(playerPos)
end

mod.ZapMinDistance = 30

function mod:CreateNewJupiterLaser(player)
	local playerPos = player.Position

	if mod:DistanceFromLastVolt(playerPos) > mod.ZapMinDistance then

		mod.ItemsVars.nJupiterSets = mod.ItemsVars.nJupiterSets + 1
		mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets] = {POSITION = playerPos, LASER = nil}

		if mod.ItemsVars.nJupiterSets > 1 or lastActivePos then
			local laserPos = mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets - 1].POSITION
			local laserAngle = (laserPos - playerPos):GetAngleDegrees()
			local laser = EntityLaser.ShootAngle(mod.EntityInf[mod.Entity.JupiterLaser].VAR, playerPos, laserAngle, 120, Vector.Zero, player)
			laser.MaxDistance = playerPos:Distance(laserPos)
			laser.DisableFollowParent = true
			laser.CollisionDamage = 0.1
			laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets].LASER = laser
		end
	end
end

function mod:JupiterContact(player, contactedVoltN, fromBomb)
	sfx:Play(SoundEffect.SOUND_LASERRING_STRONG)

	for _, laser in ipairs(mod:FindByTypeMod(mod.Entity.JupiterLaser)) do
		laser:Remove()
	end

	for i=2, mod.ItemsVars.nJupiterSets-1 do
		local point1 = mod.ItemsVars.jupiterSets[i].POSITION
		local point2 = mod.ItemsVars.jupiterSets[i%mod.ItemsVars.nJupiterSets+1].POSITION

		local angle = (point1 - point2):GetAngleDegrees()
		local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, point2, angle, 10, Vector.Zero, player)
		laser.MaxDistance = (point1 - point2):Length()
		laser.DisableFollowParent = true
		laser:GetSprite().Color = mod.Colors.jupiterLaser2

	end

	if not fromBomb then
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			
			local isInside = mod:PointInPoly(mod.ItemsVars.nJupiterSets, mod.ItemsVars.jupiterSets, entity.Position, contactedVoltN)
			if isInside then 
				mod:ElectrifyEntity(entity, player)
			end
		end

		local p1 = mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets-1].POSITION
		local p2 = mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets-2].POSITION
		mod.ItemsVars.jupiterSets = {[1] = {POSITION = p2}, [2] = {POSITION = p1 + Vector(0.1,0)}}
		mod.ItemsVars.nJupiterSets = 2
	end
end

function mod:OnJupiterUpdate(player)
	if game:GetFrameCount() % 6 == 0 then

		if mod.ModFlags.jupiterLocked then return end

		local playerPos = player.Position

		--Crate new laser
		mod:CreateNewJupiterLaser(player)

		if mod.ItemsVars.nJupiterSets > 3 then

			local contactFlag = false
			local contactedVoltN
			
			local segment1A = mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets - 1].POSITION
			local segment1B = mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets - 0].POSITION
			for i = 2, mod.ItemsVars.nJupiterSets - 2 do

				local segment2A = mod.ItemsVars.jupiterSets[i - 0].POSITION
				local segment2B = mod.ItemsVars.jupiterSets[i - 1].POSITION

				contactFlag = mod:intersect(segment1A, segment1B, segment2A, segment2B)
				if contactFlag then 
					contactedVoltN = i-1
					break 
				end
			end
			
			if contactFlag then
				mod:JupiterContact(player, contactedVoltN)
			end
		end
	end
end

function mod:ccw(A,B,C)
    return (C.Y-A.Y) * (B.X-A.X) > (B.Y-A.Y) * (C.X-A.X)
end

-- Return true if line segments AB and CD intersect
function mod:intersect(A,B,C,D)
    return mod:ccw(A,C,D) ~= mod:ccw(B,C,D) and mod:ccw(A,B,C) ~= mod:ccw(A,B,D)
end

function mod:PointInPoly(nPoints, _polygon, p, nStart)

	local polygon = {}
	for index, t in ipairs(_polygon) do
		polygon[index] = _polygon[index].POSITION
	end

	nStart = nStart - 1

	local isInside = false;
    local minX = polygon[nStart+1].X
	local maxX = polygon[nStart+1].X
    local minY = polygon[nStart+1].Y
	local maxY = polygon[nStart+1].Y
    for n = nStart+2, nPoints-1 do
        local q = polygon[n]
        minX = math.min(q.X, minX)
        maxX = math.max(q.X, maxX)
        minY = math.min(q.Y, minY)
        maxY = math.max(q.Y, maxY)
	end

    if (p.X < minX or p.X > maxX or p.Y < minY or p.Y > maxY) then
        return false;
	end

	local j = nPoints - 2

    for i=nStart, nPoints-1, 1 do

        if ( (polygon[i+1].Y > p.Y) ~= (polygon[j+1].Y > p.Y) and
                p.X < (polygon[j+1].X - polygon[i+1].X) * (p.Y - polygon[i+1].X) / (polygon[j+1].Y - polygon[i+1].Y) + polygon[i+1].X )
		then
            isInside = not isInside
		end

		j = i
    end

    return isInside
end

function mod:JupiterLaserUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.JupiterLaser].SUB and entity.Timeout == 1 then
		entity.Timeout = 0
		entity:Remove()
		for i=2, mod.ItemsVars.nJupiterSets do
			mod.ItemsVars.jupiterSets[i-1] = mod.ItemsVars.jupiterSets[i]
		end
		mod.ItemsVars.jupiterSets[mod.ItemsVars.nJupiterSets] = nil
		mod.ItemsVars.nJupiterSets = mod.ItemsVars.nJupiterSets - 1
	end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.JupiterLaserUpdate, mod.EntityInf[mod.Entity.JupiterLaser].VAR)

function mod:TriggerSlotMachine(slot, mainPlayer)

	mod.ModFlags.jupiterLocked = true
	mod:scheduleForUpdate(function()
		mod.ModFlags.jupiterLocked = false
		mod.ItemsVars.jupiterSets = {}
		mod.ItemsVars.nJupiterSets = 0
	end, 5)


	local coins = mainPlayer:GetNumCoins()
	mainPlayer:AddCoins(5)

	local oldPos = mainPlayer.Position
	mainPlayer:GetData().Invulnerable_HC = true

	mainPlayer.Position = slot.Position

	mod:scheduleForUpdate(function()
		mainPlayer.Position = oldPos
		mainPlayer:AddCoins(-999)
		mainPlayer:AddCoins(coins)
		mainPlayer:GetData().Invulnerable_HC = false
	end, 2)

end
function mod:AddPlayer(player)--Unused
	local id = game:GetNumPlayers() - 1
	local playerType = player:GetPlayerType()

	Isaac.ExecuteCommand('addplayer 15 '..player.ControllerIndex)
	local newPlayer = Isaac.GetPlayer(id + 1)

	newPlayer.Parent = player
	game:GetHUD():AssignPlayerHUDs()

	return newPlayer
end

--[[
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, function(_, pickup, variant, subtype)
	if pickup:GetSprite():IsPlaying("Appear") and variant == PickupVariant.PICKUP_KEY and subtype == KeySubType.KEY_NORMAL and rng:RandomFloat() < 0.0392 and mod:SomebodyHasItem(mod.Items.Jupiter) then
		return {PickupVariant.PICKUP_KEY, KeySubType.KEY_CHARGED}
	end
end)]]

--SATURN
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@%%%%%@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%&@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%&@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%%%%%%%@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%&@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectibleType, rng, player, flags, slot)

	if player:NeedsCharge(slot) then
		if player:GetPlayerType() == PlayerType.PLAYER_BETHANY then
			local ogCurrentCharges = player:GetActiveCharge(slot)
			local currentCharges = math.floor(4 * player:GetActiveCharge(slot) / 1800)
			local soulCharges = player:GetEffectiveSoulCharge()

			if currentCharges ~= 1800 and soulCharges < (4 - currentCharges) then
				player:SetSoulCharge(soulCharges + 1)
				mod:scheduleForUpdate(function()
					player:SetActiveCharge(ogCurrentCharges, slot)
				end,2)
				return false
			else
				player:SetSoulCharge(soulCharges + 1 - (4 - currentCharges))
			end

		elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
			local ogCurrentCharges = player:GetActiveCharge(slot)
			local currentCharges = math.floor(4 * player:GetActiveCharge(slot) / 1800)
			local bloodCharges = player:GetEffectiveBloodCharge()

			if currentCharges ~= 1800 and bloodCharges < (4-currentCharges) then
				player:SetBloodCharge(bloodCharges + 1)
				mod:scheduleForUpdate(function()
					player:SetActiveCharge(ogCurrentCharges, slot)
				end,2)
				return false
			else
				player:SetBloodCharge(bloodCharges + 1 - (4-currentCharges))
			end
		end
	end

	if mod.ModFlags.playerTimestuck then return end

	mod:SaturnUpdateReset()

	mod.ItemsVars.timeStops[player.ControllerIndex] = true
	mod.ModFlags.playerTimestuck = true
	mod.ModFlags.playerTimestuckFlick = true
	mod.ModFlags.playerTimestuckRoomIdx = game:GetLevel():GetCurrentRoomIndex()
	mod.ModFlags.playerTimestuckStartFrame = game:GetFrameCount()
	
	sfx:Play(Isaac.GetSoundIdByName("TimeStop"), 2)

	local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, player.Position + Vector(0,-10), Vector.Zero, player):ToEffect()
	timestuck:FollowParent(player)
	timestuck:GetSprite().PlaybackSpeed = 0.5
	timestuck:GetSprite().Scale = Vector.One*0.5
	timestuck.DepthOffset = -50

	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()

	local n = 5
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then n = 10 end
	mod.ModFlags.playerTimestuckEndFrame = mod.ModFlags.playerTimestuckStartFrame + n*31

end, mod.Items.Saturnus)


--URANUS
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@&%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@&%&@@@@@%%&@@@@@@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@&%&@@@@@%%&@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@&%%%%%@@@@@@@&%%%%&@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%&@@&%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%%%%%%&@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@&%%&@@@@@@@@@&%%%%&@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
mod.UEnts = {
	[1] = 1, -- Gold
	[2] = 12, -- Corn
	[3] = 13, -- Fire
	[4] = 16, -- Holy
	[5] = 11, -- Rock
	[6] = 15, -- Black
	[7] = 14, -- Poison
}

function mod:OnUranusShot(tear)--Unused
    local player = tear.SpawnerEntity
	if player then player = player:ToPlayer() end
	if not player and player:ToFamiliar() then player = player:ToFamiliar().Player end

    if player and player:HasCollectible(mod.Items.Uranus) and mod:LuckRoll(player.Luck+2, 20, 0.6) then
        tear:GetData().UranusPoopTear = true
        tear:SetColor(mod.Colors.poop2, 0, 99, true, true)
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,  mod.OnUranusShot)

function mod:OnUranusHit(entity, _, _, source, _)
    if source.Entity and source.Entity:GetData().UranusPoopTear and entity:ToNPC() and entity:ToNPC().CanShutDoors then

		local time = 30*5
		if source.Entity:ToTear() and source.Entity:ToTear().SpawnerEntity and source.Entity:ToTear().SpawnerEntity:ToPlayer() then
			local player = source.Entity:ToTear().SpawnerEntity:ToPlayer()
			if player:HasTrinket(TrinketType.TRINKET_SECOND_HAND) then
				time = time*2
			end
		end

        mod.ItemsVars.activePoopEnts[entity.InitSeed] = { ent = entity, t = time }
        entity:SetColor(mod.Colors.poop, time, 99, true, true)
		entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnUranusHit)

local next = next
function mod:OnPoopedUpdate()
    if next(mod.ItemsVars.activePoopEnts) ~= nil then
        local cont = game:GetFrameCount() % 3 == 0

        for key, value in pairs(mod.ItemsVars.activePoopEnts) do
            if value.ent:IsDead() or value.t < 1 then
				
				value.ent:ClearEntityFlags(EntityFlag.FLAG_WEAKNESS)

				if value.ent:IsDead() then
					local selection = mod:RandomInt(1,2)
					local position = game:GetRoom():FindFreePickupSpawnPosition(value.ent.Position, 0, true, false)

					local poop
					local player = game:GetPlayer(0)
					if selection <= 1 then
						poop = Isaac.Spawn(EntityType.ENTITY_POOP, 0, 0, position, Vector.Zero, player)
					else
						poop = Isaac.Spawn(EntityType.ENTITY_POOP, mod.UEnts[mod:RandomInt(2,6)], 0, position, Vector.Zero, player)
					end
					poop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
					poop.TargetPosition = poop.Position -- Lock it into place
					poop.Mass = 999
					poop.Parent = player

				elseif value.t < 1 and #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, 0) < 12 then
					local n = mod:RandomInt(-1,3)
					for i=1, n do
						local dip = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, 0, value.ent.Position, Vector.Zero, nil)
					end
				end

                mod.ItemsVars.activePoopEnts[key] = nil
                goto loopend
            end

            mod.ItemsVars.activePoopEnts[key].t = value.t-1

            if not cont then goto loopend end

            if Isaac.CountEntities(nil, 1000, EffectVariant.CREEP_LIQUID_POOP) < 100 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_LIQUID_POOP, 0, value.ent.Position, Vector.Zero, value.ent):ToEffect()
				mod:scheduleForUpdate(function()
					if creep then
						creep:Remove()
					end
				end, 30*10)
            end

            ::loopend::
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnPoopedUpdate)

--NEPTUNE
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%&@@@@&%%%%%@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@%%%%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@&%&@@@@&%%&@&%%%%&@@@@&%%%%%@@&%%@@@@@%%&@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%&@@@@&%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
--Swordfish from TT was of big help

mod.TridentStates = {
	IDLE = 0,
	LAUNCHED = 1,
	ABYSS = 2,
}

function mod:TridentUpdate(familiar)
	local data = familiar:GetData()
    local sprite = familiar:GetSprite()
	local player = familiar.Player

    if not data.Init then
        data.Init = true
		data.State = mod.TridentStates.IDLE

        familiar:SetSize(10, Vector(4.5,1), 12)
        familiar.SpriteOffset = Vector(0,-12)
        data.Distance = 40
		data.Objective = data.Distance
        data.StabTimer = 0
    end

    if player then
		
        if data.State == mod.TridentStates.IDLE then

			familiar.CollisionDamage = player.Damage*2
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				familiar.CollisionDamage = familiar.CollisionDamage * 2
				familiar:SetSize(10, Vector(5,1), 12)
			end
            
			if sprite:IsFinished("Idle") then
				sprite:Play("Idle", true)
			end

			if player:GetData().TridentForce_HC and player:GetData().TridentForce_HC > 0 then

				familiar.CollisionDamage = player.Damage*(1 + math.min(3.5, 3.5*player:GetData().TridentForce_HC/30))
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					familiar.CollisionDamage = familiar.CollisionDamage * 2
					familiar:SetSize(10, Vector(5,1), 12)
				end

				data.State = mod.TridentStates.LAUNCHED

				local force = player:GetData().TridentForce_HC
				if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
					force = math.min(90, force*1.5)
				end
				data.Force = (force*2 + data.Distance + 30)/260*player.TearRange
					
				data.Objective = player.Position + Vector(data.Force, 0):Rotated(sprite.Rotation)
			elseif player:GetData().AttackVector_HC then
				sprite.Rotation = mod:AngleLerp(sprite.Rotation, player:GetData().AttackVector_HC:GetAngleDegrees(), 0.5)
				familiar.TargetPosition = player.Position + Vector(data.Distance,0):Rotated(sprite.Rotation)
				familiar.Velocity = (familiar.TargetPosition - familiar.Position)/2

			end

        elseif data.State == mod.TridentStates.LAUNCHED then

			local objective = data.Objective
			if not objective then objective = player.Position + Vector(data.Distance,0):Rotated(sprite.Rotation) end

			familiar.Velocity = (objective - familiar.Position)/2

			if familiar.Position:Distance(objective) < 15 then

				if not (data.Force == data.Distance)  then
					data.Force = data.Distance
					data.Objective = nil
	
				elseif data.Force == data.Distance then
					data.State = mod.TridentStates.IDLE
				end
			end

        end

    end
end

function mod:SpawnAbyssHole(familiar, victim)
	if familiar.Player and (mod:LuckRoll(familiar.Player.Luck + 5, 20, 0.15)) then
		local position = victim.Position
		mod:scheduleForUpdate(function()
			local blackhole = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, position, Vector.Zero, familiar.Player):ToEffect()
			blackhole:GetSprite():ReplaceSpritesheet(0, "gfx/effects/abyss_hole.png")
			blackhole:GetSprite():ReplaceSpritesheet(1, "")
			blackhole:GetSprite():LoadGraphics()
			blackhole:GetSprite().PlaybackSpeed = 10
		end, 10)

		local triton = mod:SpawnEntity(mod.Entity.TritonHole, position + Vector(0,25), Vector.Zero, nil)
		sfx:Play(Isaac.GetSoundIdByName("Triton"), 2.5)
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.TridentUpdate, mod.EntityInf[mod.Entity.Trident].VAR)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, familiar, collider)
    local data = familiar:GetData()
    if data.State and data.State == mod.TridentStates.LAUNCHED then
        if mod:IsAnEnemy(collider) and collider:IsVulnerableEnemy()
		and collider.HitPoints <= familiar.CollisionDamage and not collider:GetData().Flag_BH_HC then
			mod:SpawnAbyssHole(familiar, collider)
			collider:GetData().Flag_BH_HC = true
        end
    end
end, mod.EntityInf[mod.Entity.Trident].VAR)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, blackhole)
	if true then
		local data = blackhole:GetData()
		local sprite = blackhole:GetSprite()

		if not data.Init_HC and sprite:IsPlaying("Init") then
			data.Init_HC = true

			data.Position_HC = blackhole.Position
			mod.ModFlags.blackHolePosition = blackhole.Position
			mod.ModFlags.blackHoleTime = 0
			mod.ModFlags.blackHole = true
		end

		if data.Position_HC and mod.ModFlags.blackHoleTime then
			game:MakeShockwave(data.Position_HC, -0.1, 0.0025, 60)
			mod.ModFlags.blackHoleTime = math.min(1, mod.ModFlags.blackHoleTime + 10/100)
		end

		if not data.Stop_HC and sprite:IsPlaying("Death") then
			data.Stop_HC = true

			mod.ModFlags.blackHole = false
			mod.ModFlags.blackHoleTime = 0
		end

	end
end, EffectVariant.BLACK_HOLE)

--OTHERS--------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--MOONS

mod.MoonSpeeds = {
	[1] = 0.25,
	[2] = 0.1826722338, 
	[3] = 0.1555323591,
	[4] = 0.125782881,
	[10] = 0.09331941545,--Ceres
	[5] = 0.06837160752,
	[6] = 0.0506263048,
	[7] = 0.03549060543,
	[8] = 0.02818371608,

	[9] = 0.01,--Errant
	[25] = 0.026461377875,--Iris
	[26] = 0.0064,--End

	[19] = 0.02473903967,--Kuiper
	[21] = 0.01790187891,--Kuiper
	[22] = 0.02306889353,--Kuiper
	[23] = 0.02364300626,--Kuiper
	
	[0] = 0.005636743215,--Terra
	[24] = 0.04175365344,--Terra
	[11] = 0.09044885177,--Jupiter
	[12] = 0.07171189979,--Jupiter
	[13] = 0.05678496868,--Jupiter
	[14] = 0.04279749478,--Jupiter
	[15] = 0.02907098121,--Saturn
	[16] = 0.01899791232,--Uranus
	[17] = 0.01644050104,--Uranus
	[18] = 0.02291231733,--Neptune
	[20] = 0.001096033403,--Pluto
}

mod.MoonOrbits = {
	[1] = 8501,
	[2] = 8502,
	[3] = 8503,
	[4] = 8504,
	[10] = 8511,--Ceres
	[5] = 8505,
	[6] = 8506,
	[7] = 8507,
	[8] = 8508,

	[9] = 8509,
	[25] = 8518,
	[26] = 8519,

	[19] = 8516,--Kuiper
	[21] = 8516,--Kuiper
	[22] = 8516,--Kuiper
	[23] = 8516,--Kuiper
	
	[0] = 8510,--Terra
	[24] = 8510,--Terra
	[11] = 8512,--Jupiter
	[12] = 8512,--Jupiter
	[13] = 8512,--Jupiter
	[14] = 8512,--Jupiter
	[15] = 8513,--Saturn
	[16] = 8514,--Uranus
	[17] = 8514,--Uranus
	[18] = 8515,--Neptune
	[20] = 8517,--Pluto
}

mod.MoonOrbitsVanilla = {
	[1] = 8501,
	[2] = 8502,
	[3] = 8503,
	[4] = 8504,
	[10] = 8511,--Ceres
	[5] = 8505,
	[6] = 8506,
	[7] = 8507,
	[8] = 8508,

	[9] = 8509,
	[25] = 8518,
	[26] = 8519,

	[19] = 8516,--Kuiper
	[21] = 8516,--Kuiper
	[22] = 8516,--Kuiper
	[23] = 8516,--Kuiper
	
	[0] = 8503,--Terra
	[24] = 8503,--Terra
	[11] = 8505,--Jupiter
	[12] = 8505,--Jupiter
	[13] = 8505,--Jupiter
	[14] = 8505,--Jupiter
	[15] = 8506,--Saturn
	[16] = 8507,--Uranus
	[17] = 8507,--Uranus
	[18] = 8508,--Neptune
	[20] = 8516,--Pluto
}

mod.MoonParent = {
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[10] = 10,--Ceres
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,

	[9] = 9,
	[25] = 25,
	[26] = 26,

	[19] = 19,--Kuiper
	[21] = 21,--Kuiper
	[22] = 22,--Kuiper
	[23] = 23,--Kuiper

	[0] = 3,--Terra
	[24] = 3,--Terra
	[11] = 5,--Jupiter
	[12] = 5,--Jupiter
	[13] = 5,--Jupiter
	[14] = 5,--Jupiter
	[15] = 6,--Saturn
	[16] = 7,--Uranus
	[17] = 7,--Uranus
	[18] = 8,--Neptune
	[20] = 19,--Pluto
}

mod.MoonOrbitDistance = {
	[1] = 1*0.75,
	[2] = 2*0.75,
	[3] = 3*0.75,
	[4] = 4*0.75,
	[10] = 5*0.75,--Ceres
	[5] = 6*0.75,
	[6] = 7*0.75,
	[7] = 8*0.75,
	[8] = 9*0.75,

	[9] = 13*0.75,
	[25] = 10*0.75,
	[26] = 13*0.75,

	[19] = 11*0.75,--Kuiper Pluto
	[23] = 11.6*0.75,--Kuiper Haumea
	[22] = 12.2*0.75,--Kuiper Makemake
	[21] = 12.8*0.75,--Kuiper Eris

	[0] = 1*0.75,--Terra
	[24] = 1*0.75,--Terra
	[11] = 1.3*0.75,--Jupiter
	[12] = 1.4*0.75,--Jupiter
	[13] = 1.5*0.75,--Jupiter
	[14] = 1.6*0.75,--Jupiter
	[15] = 1*0.75,--Saturn
	[16] = 1.15*0.75,--Uranus
	[17] = 1.25*0.75,--Uranus
	[18] = 1*0.75,--Neptune
	[20] = 1*0.75,--Pluto

}

function mod:OnMoonUpdate(familiar)
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local data = familiar:GetData()


	familiar.CollisionDamage = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		familiar.CollisionDamage = familiar.CollisionDamage * 2
	end

	if player:GetData().PressedDirection_HC and player:GetData().PressedDirection_HC:Length() > 0 then
		data.Direcion = player:GetData().PressedDirection_HC

		for i=1, player:GetData().MoonShootMultiplier_HC do
			if rng:RandomFloat() < 0.025 and not sprite:IsPlaying("Attack") then
				sprite:Play("Attack", true)
			end
		end
	end

	if sprite:IsFinished("Attack") then
		sprite:Play("Idle", true)
	elseif sprite:IsEventTriggered("Attack") and data.Direcion then
		local velocity = data.Direcion * 8
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, velocity, familiar):ToTear()
		tear.CollisionDamage = 4*familiar.CollisionDamage

		if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
		end
		if familiar.Player:HasTrinket(mod.Trinkets.Flag) then
			tear.CollisionDamage = 1.5*familiar.CollisionDamage*familiar.Player:GetTrinketMultiplier(mod.Trinkets.Flag)
		end

		local subtype = familiar.SubType

		if subtype == 9 then
			subtype = mod:RandomInt(0,mod.TotalMoons-1)
		end
		if subtype == 9 then
			subtype = mod:RandomInt(0,mod.TotalMoons-1)
		end
		if subtype == 9 then
			subtype = mod:RandomInt(0,mod.TotalMoons-1)
		end

		if subtype == 0 then
			tear:ChangeVariant(TearVariant.KEY_BLOOD)
			tear:GetSprite().Color = mod.Colors.red2

		elseif subtype == 1 then
			tear:GetData().MercuriusTear = true
        	tear:GetData().MercuriusTearFlag = true

		elseif subtype == 2 then
			tear:ChangeVariant(TearVariant.FIRE_MIND)
			tear:AddTearFlags(TearFlags.TEAR_CHARM)
			tear:AddTearFlags(TearFlags.TEAR_BURN)

		elseif subtype == 3 then
			tear:ChangeVariant(TearVariant.HUNGRY)
			tear:AddTearFlags(TearFlags.TEAR_POP)
			tear:AddTearFlags(TearFlags.TEAR_HYDROBOUNCE)
			tear.CollisionDamage = tear.CollisionDamage*1.5

		elseif subtype == 4 then
			tear:ChangeVariant(TearVariant.BLOOD)
			tear:AddTearFlags(TearFlags.TEAR_JACOBS)
			tear:GetSprite().Color = mod.Colors.red
					
			local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, tear.Position, Vector.Zero, nil):ToEffect()
			energy.LifeSpan = 1000
			energy.Parent = tear
			energy.DepthOffset = 5
			energy:GetData().HeavensCall = true
			energy:GetData().MarsShot_HC = true
			energy:GetSprite().Scale = Vector.One*0.8
			energy:FollowParent(tear)

		elseif subtype == 5 then
			tear:AddTearFlags(TearFlags.TEAR_POISON)
			tear:AddTearFlags(TearFlags.TEAR_KNOCKBACK)

		elseif subtype == 6 then
			tear:ChangeVariant(TearVariant.KEY)
			tear:AddTearFlags(TearFlags.TEAR_FREEZE)

		elseif subtype == 7 then
			tear:ChangeVariant(TearVariant.ICE)
			tear:AddTearFlags(TearFlags.TEAR_SLOW)
			tear:AddTearFlags(TearFlags.TEAR_ICE)

		elseif subtype == 8 then
			tear:ChangeVariant(TearVariant.DARK_MATTER)
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
			
		elseif subtype == 10 then
			tear:ChangeVariant(TearVariant.GLAUCOMA)
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
			
		elseif subtype == 11 then
			tear:AddTearFlags(TearFlags.TEAR_ACID)
		elseif subtype == 12 then
			tear:AddTearFlags(TearFlags.TEAR_GISH)
		elseif subtype == 13 then
			tear:AddTearFlags(TearFlags.TEAR_JACOBS)
		elseif subtype == 14 then
			tear:ChangeVariant(TearVariant.EYE)
			tear:AddTearFlags(TearFlags.TEAR_POP)
			
		elseif subtype == 15 then
			tear:ChangeVariant(TearVariant.COIN)
			
		elseif subtype == 16 or subtype == 17 then
			tear:GetData().UranusPoopTear = true
			tear:SetColor(mod.Colors.poop2, 0, 99, true, true)
			
		elseif subtype == 18 then
			tear:AddTearFlags(TearFlags.TEAR_BAIT)
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
			tear:GetSprite().Color = Color(1,0,0,1)
			
		elseif subtype == 19 then
			tear:ChangeVariant(TearVariant.BONE)
			tear:AddTearFlags(TearFlags.TEAR_PIERCING)
		elseif subtype == 21 then
			tear:ChangeVariant(TearVariant.SWORD_BEAM)
			tear:AddTearFlags(TearFlags.TEAR_PUNCH)
		elseif subtype == 22 then
			tear:ChangeVariant(TearVariant.ROCK)
			tear:AddTearFlags(TearFlags.TEAR_ROCK)
		elseif subtype == 23 then
			tear:ChangeVariant(TearVariant.LOST_CONTACT)
			tear:AddTearFlags(TearFlags.TEAR_SPLIT)
		elseif subtype == 25 then
			tear:ChangeVariant(TearVariant.PUPULA_BLOOD)
			tear:AddTearFlags(TearFlags.TEAR_BAIT)
		elseif subtype == 26 then
			tear:ChangeVariant(TearVariant.MULTIDIMENSIONAL)
			tear:AddTearFlags(TearFlags.TEAR_CONTINUUM)
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
		end
	end


	--Orbits
	local factor1 = 1
	local factor2 = 1* 0.5 
	if data.Factor_HC then
		factor1 = data.Factor_HC*0.85
		factor2 = 1/data.Factor_HC/2* 0.5 
	end

	if familiar.Parent then
		if familiar.SubType ~= 9 then
			familiar.Velocity = familiar:GetOrbitPosition(familiar.Parent.Position + familiar.Parent.Velocity) - familiar.Position
			familiar.OrbitSpeed = mod.MoonSpeeds[familiar.SubType] * factor2
			familiar.OrbitDistance = Vector(25, 25) * mod.MoonOrbitDistance[familiar.SubType] * factor1
		else
			familiar.Velocity = familiar:GetOrbitPosition(familiar.Parent.Position + familiar.Parent.Velocity) - familiar.Position
			familiar.OrbitSpeed = mod.MoonSpeeds[familiar.SubType] * factor2 * 10
			familiar.OrbitDistance = Vector(25, 25) * mod.MoonOrbitDistance[familiar.SubType] * factor1 / 10
		end
	else
		familiar.Velocity = familiar:GetOrbitPosition(player.Position + player.Velocity) - familiar.Position
		familiar.OrbitSpeed = mod.MoonSpeeds[mod.MoonParent[familiar.SubType]] * factor2
		familiar.OrbitDistance = Vector(25, 25) * mod.MoonOrbitDistance[mod.MoonParent[familiar.SubType]] * factor1
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnMoonUpdate, mod.EntityInf[mod.Entity.Moon].VAR)
function mod:OnMoonInit(familiar, flag)

	mod:scheduleForUpdate(function()
		if not flag then
			for _, moon in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR)) do
				
				mod:OnMoonInit(moon:ToFamiliar(), true)
			end
		end
	end, 1)

	local parent = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR, mod.MoonParent[familiar.SubType])[1]
	if parent and familiar.InitSeed ~= parent.InitSeed then
		familiar:AddToOrbit(mod.MoonOrbits[familiar.SubType])
		familiar.Parent = parent
	else
		familiar:AddToOrbit(mod.MoonOrbitsVanilla[familiar.SubType])
	end

	local sprite = familiar:GetSprite()
	sprite:Play("Idle")
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnMoonInit, mod.EntityInf[mod.Entity.Moon].VAR)

function mod:ChooseMiniMoon(player)
	local moonFlag = 0

	local options = {}

	local i=0
	for k in pairs(mod.Moons) do 
		i=i+1
		if not player:HasCollectible(mod.Moons[k]) then
			options[i] = mod.Moons[k]
		end
	end

	if #options > 0 then
		player:AddCollectible(mod:random_elem(options))
	else
		local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, player.Position + Vector(25,0):Rotated(rng:RandomFloat()*360), Vector.Zero, nil)
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, familiar, collider)
	if collider.Type == EntityType.ENTITY_PROJECTILE then 
		if collider:ToProjectile():HasProjectileFlags(ProjectileFlags.EXPLODE) or collider:GetData().LunaIpecac then
			collider:Remove()
		else
			collider:Die() 
		end
	end
end, mod.EntityInf[mod.Entity.Moon].VAR)

function mod:GiveAllMoons()
	local player = game:GetPlayer(0)

	for k in pairs(mod.Moons) do
		player:AddCollectible(mod.Moons[k])
	end
end

function mod:SpawnMoons()
	local subtype = 742
	for i=-1, 1 do
		local yOffset = i*75

		for j=-4, 4 do
			local xOffset = j*50

			local position = game:GetRoom():GetCenterPos() + Vector(xOffset, yOffset)

			if subtype <= 767 then
			local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, subtype, position, Vector.Zero, nil)
			end
			subtype = subtype+ 1
		end
	end
end

--TRINKETS
mod.Trinkets = {
	Shard = Isaac.GetTrinketIdByName("Quantum Shard"),
	Sputnik = Isaac.GetTrinketIdByName("Sputnik"),
	Flag = Isaac.GetTrinketIdByName("Faded flag"),
}

function mod:QuantumRoll(player)
	local roll = rng:RandomFloat()

	if player:HasTrinket(mod.Trinkets.Shard) then
		return roll < 0.1333*player:GetTrinketMultiplier(mod.Trinkets.Shard)
	else
		return false
	end
end

function mod:ExtraMoonRoll(player)
	local roll = rng:RandomFloat()
	
	if player:HasTrinket(mod.Trinkets.Flag) then
		return roll < (0.06*player:GetTrinketMultiplier(mod.Trinkets.Flag))
	else
		return false
	end
end

function mod:TelescopeChance()
	if mod:SomebodyHasTrinket(mod.Trinkets.Flag) then
		return 0.25 + 0.25*player:GetTrinketMultiplier(mod.Trinkets.Flag)
	end
	return 0.25
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

function mod:SputnikUpdate(familiar)
	if familiar.OrbitDistance and not (familiar.Variant == FamiliarVariant.WISP or familiar.Variant == FamiliarVariant.ITEM_WISP) then
		local data = familiar:GetData()
		local player = familiar.Player

		if player:HasTrinket(mod.Trinkets.Sputnik) then
			local factor = player:GetTrinketMultiplier(mod.Trinkets.Sputnik) + 1
			factor = factor*0.75
	
			if not data.OgDistance or not data.OgSpeed then
				data.OgDistance = familiar.OrbitDistance
				data.OgSpeed = familiar.OrbitSpeed
			end
			data.Factor_HC = factor
			familiar.OrbitDistance = data.OgDistance * factor * 1.75
			familiar.OrbitSpeed = data.OgSpeed / factor / 2

		elseif data.OgDistance and data.OgSpeed then
			familiar.OrbitDistance = data.OgDistance
			familiar.OrbitSpeed = data.OgSpeed
			data.Factor_HC = nil
		end
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.SputnikUpdate)