local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()
local persistentGameData = Isaac.GetPersistentGameData()

local planet_map = {
	[700] = 4,
	[701] = 5,
	[702] = 6,
	[703] = 7,
	[704] = 0,
	[705] = 1,
	[706] = 2,
	[707] = 3,
	[708] = 9,
	[709] = 8,
	[710] = 8,
	[711] = 8,
	[712] = 8,
	[713] = 8,
	[717] = 8,
	[715] = 10,
	[718] = 11,
	[714] = 12,
}

--Check Spawn Planet in new room
function mod:CheckSpawnNewRoom()
	mod:scheduleForUpdate(function()
		if mod.savedatarun() then
			if mod.savedatarun().planetAlive then
				mod:SpawnPlanet(mod.savedatarun().planetNum)
			end
			if mod.savedatarun().errantAlive then
				mod:SpawnPlanet(mod.Entity.Errant)
			end
		end 
	end, 1)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.CheckSpawnNewRoom)

--SpawnPlanet if room changed or continued
function mod:SpawnPlanet(entityNum)
	local validType = entityNum==mod.Entity.Jupiter or entityNum==mod.Entity.Saturn or entityNum==mod.Entity.Uranus or entityNum==mod.Entity.Neptune
	or entityNum==mod.Entity.Mercury or entityNum==mod.Entity.Venus or entityNum==mod.Entity.Terra1 or entityNum==mod.Entity.Terra2 or entityNum==mod.Entity.Mars
	or entityNum==mod.Entity.Luna

	if validType and #(mod:FindByTypeMod(entityNum))==0 then
		
		local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)

		local planet = mod:SpawnEntity(entityNum, position, Vector.Zero, nil)
		planet.HitPoints = mod.savedatarun().planetHP

	elseif entityNum==mod.Entity.Pluto then
		if mod.savedatarun().planetAlive1 and not mod.savedatarun().planetKilled11 then
			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Pluto, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedatarun().planetHP

			mod:scheduleForUpdate(function()
				if (#mod:FindByTypeMod(mod.Entity.Charon1)+#mod:FindByTypeMod(mod.Entity.Charon2))==0 then
					local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
					local planet = mod:SpawnEntity(mod.Entity.Charon1, position, Vector.Zero, nil)
				end
			end, 30)
		end
		if mod.savedatarun().planetAlive2 and not mod.savedatarun().planetKilled12 then

			mod:scheduleForUpdate(function()
				local pluto = mod:FindByTypeMod(mod.Entity.Pluto)[1]
				if pluto then
					pluto:GetData().FlagEris = true
				end
			end,2)

			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Eris, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedatarun().planetHP2

		end
		if mod.savedatarun().planetAlive3 and not mod.savedatarun().planetKilled13 then

			mod:scheduleForUpdate(function()
				local pluto = mod:FindByTypeMod(mod.Entity.Pluto)[1]
				if pluto then
					pluto:GetData().FlagMakemake = true
				end
			end,2)

			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Makemake, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedatarun().planetHP3
		end
		if mod.savedatarun().planetAlive4 and not mod.savedatarun().planetKilled14 then
			
			mod:scheduleForUpdate(function()
				local pluto = mod:FindByTypeMod(mod.Entity.Pluto)[1]
				if pluto then
					pluto:GetData().FlagHaumea = true
				end
			end,2)

			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Haumea, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedatarun().planetHP4
		end
	end

	if entityNum==mod.Entity.Errant then
		if mod.savedatarun().errantAlive and not mod.savedatarun().errantKilled and #mod:FindByTypeMod(mod.Entity.Errant)==0 then
			local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
			local planet = mod:SpawnEntity(mod.Entity.Errant, position, Vector.Zero, nil)
			planet.HitPoints = mod.savedatarun().errantHP
			planet:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end
	end
end

--Update health of boss, delayed by one damage
function mod:DamageHeavenBoss(entity, amount)
	if entity:GetData().HeavensCall then
		if mod.savedatarun().planetAlive then
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
				mod.savedatarun().planetHP = entity.HitPoints
			elseif entity.Type == mod.EntityInf[mod.Entity.Eris].ID and entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR then
				mod.savedatarun().planetHP2 = entity.HitPoints
			elseif entity.Type == mod.EntityInf[mod.Entity.Makemake].ID and entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR then
				mod.savedatarun().planetHP3 = entity.HitPoints
			elseif entity.Type == mod.EntityInf[mod.Entity.Haumea].ID and entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR then
				mod.savedatarun().planetHP4 = entity.HitPoints
			end
		elseif mod.savedatarun().errantAlive then
			if entity.Type == mod.EntityInf[mod.Entity.Errant].ID and entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR then
				mod.savedatarun().errantHP = entity.HitPoints
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Jupiter].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Saturn].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Uranus].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Neptune].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Mercury].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Venus].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Terra1].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Terra3].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Mars].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Luna].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Pluto].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Eris].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Makemake].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Haumea].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageHeavenBoss, mod.EntityInf[mod.Entity.Errant].ID)

--Spawn astellide
function mod:AppearSatellite(room, entityNum, depthOffset)
	depthOffset = depthOffset or 0

	local spritePath
	if entityNum == mod.Entity.Mercury then
		spritePath = "hc/gfx/backdrop/b_mercury.png"
	elseif entityNum == mod.Entity.Venus then
		spritePath = "hc/gfx/backdrop/b_venus.png"
	elseif entityNum == mod.Entity.Terra1 then
		spritePath = "hc/gfx/backdrop/b_earth.png"
	elseif entityNum == mod.Entity.Mars then
		spritePath = "hc/gfx/backdrop/b_mars.png"
	elseif entityNum == mod.Entity.Jupiter then
		spritePath = "hc/gfx/backdrop/b_jupiter.png"
	elseif entityNum == mod.Entity.Saturn then
		spritePath = "hc/gfx/backdrop/b_saturn.png"
	elseif entityNum == mod.Entity.Uranus then
		spritePath = "hc/gfx/backdrop/b_uranus.png"
	elseif entityNum == mod.Entity.Neptune then
		spritePath = "hc/gfx/backdrop/b_neptune.png"
	elseif entityNum == mod.Entity.Pluto then
		spritePath = "hc/gfx/backdrop/b_kuiper.png"
	elseif entityNum == 8500 then
		spritePath = "hc/gfx/backdrop/b_eclipse.png"
	else
		return
	end

	local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
	local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
	effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
	effect.DepthOffset = depthOffset
	
	local sprite = effect:GetSprite()
	sprite.Color = Color.Default
	sprite:Load("hc/gfx/backdrop/lunaroommoon.anm2")
	sprite:ReplaceSpritesheet(0, spritePath)
	sprite:LoadGraphics()
	sprite:Play("idle", true)
end
--Spawn
function mod:AppearPlanet(entity, noMusic)
	if not entity.Visible then return end

	local sprite = entity:GetSprite()
	local data = entity:GetData()

	--challenge
	if mod:IsChallenge(mod.Challenges.BabelTower) then
		if not (entity.Type == mod.EntityInf[mod.Entity.Sol].ID or entity:GetData().LunaSummon) then
			data.SlowSpawn = true

			if not noMusic then
				mod:scheduleForUpdate(function ()
					mod.ModFlags.currentMusic = mod.Music.HEAVEN_FLOOR
					if entity.Type == mod.EntityInf[mod.Entity.Luna].ID then
						music:Crossfade (mod.Music.LUNA_INTRO, 2)
						music:Queue(mod.Music.LUNA)
					elseif entity.Type == mod.EntityInf[mod.Entity.Errant].ID then
						music:Crossfade (mod.Music.ERRANT_INTRO, 2)
						music:Queue(mod.Music.ERRANT)
					elseif entity.Type == mod.EntityInf[mod.Entity.RSaturn].ID then
						music:Crossfade (mod.Music.OUROBOROS, 2)
						music:Queue(mod.Music.OUROBOROS)
					else
						music:Crossfade (mod.Music.PLANET_INTRO, 2)
						music:Queue(mod.Music.PLANET)
					end
				end, 85)
			end
			
			if entity.Type == mod.EntityInf[mod.Entity.Pluto].ID or entity.Type == mod.EntityInf[mod.Entity.Eris].ID or entity.Type == mod.EntityInf[mod.Entity.Makemake].ID or entity.Type == mod.EntityInf[mod.Entity.Haumea].ID then
				local final_hp = mod:SetStageHpButbad(entity, 3, 0.75*0.62)
			elseif entity.Type == mod.EntityInf[mod.Entity.RSaturn].ID then
				local final_hp = mod:SetStageHpButbad(entity, 3, 0.75*0.85*0.85)
			else
				local final_hp = mod:SetStageHpButbad(entity, 3, 0.75*0.85)
			end
			

			--[[
			--bosses with stage hp adjusted to 
			if entity.Type == mod.EntityInf[mod.Entity.Jupiter].ID then
				entity.MaxHitPoints = 790
			elseif entity.Type == mod.EntityInf[mod.Entity.Saturn].ID then
				entity.MaxHitPoints = 615
			elseif entity.Type == mod.EntityInf[mod.Entity.Uranus].ID then
				entity.MaxHitPoints = 465
			elseif entity.Type == mod.EntityInf[mod.Entity.Neptune].ID then
				entity.MaxHitPoints = 540
			elseif entity.Type == mod.EntityInf[mod.Entity.Pluto].ID or entity.Type == mod.EntityInf[mod.Entity.Eris].ID or entity.Type == mod.EntityInf[mod.Entity.Makemake].ID or entity.Type == mod.EntityInf[mod.Entity.Haumea].ID then
				entity.MaxHitPoints = 156
			end
			entity.HitPoints = entity.MaxHitPoints
			]]
		end
	end
	mod:UpdateEncounter(entity)

	if (not TheFuture and entity.Type == mod.EntityInf[mod.Entity.RSaturn].ID) then noMusic = true end
	
	if data.SlowSpawn then
		sprite:Play("AppearSlow",true)

		mod:scheduleForUpdate(function()
			local hud = game:GetHUD()

			if entity.Type == mod.EntityInf[mod.Entity.Luna].ID then
				local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position, Vector.Zero, entity)
				trapdoor:GetSprite():Play("BigIdle", true)
				trapdoor.DepthOffset = -100
			end
			
			if not noMusic then
				local planetName = mod.PlanetName[mod.savedatarun().planetNum] or mod.PlanetName2[entity.Type]
				
				if entity.Type == mod.EntityInf[mod.Entity.Errant].ID then
					planetName = mod.PlanetName[mod.Entity.Errant]
				end
	
				if planetName then
					if Options.Language == "es" then
						hud:ShowItemText(planetName,"se ha despertado")
					else
						hud:ShowItemText(planetName,"has awakened")
					end
				end
				--mod:AppearSatellite(game:GetRoom(), mod.savedatarun().planetNum)
			end
		end, 95)
	else
		sprite:Play("Appear",true)
		local trapdoor

		if not entity:GetData().NoTrapdoor then
			trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position, Vector.Zero, entity)
			trapdoor.DepthOffset = -100
		end

		if trapdoor and entity.Type == mod.EntityInf[mod.Entity.Luna].ID then
			trapdoor:GetSprite():Play("BigIdle", true)
		elseif entity.Type == mod.EntityInf[mod.Entity.Pluto].ID or entity.Type == mod.EntityInf[mod.Entity.Eris].ID or entity.Type == mod.EntityInf[mod.Entity.Haumea].ID or entity.Type == mod.EntityInf[mod.Entity.Makemake].ID then
			data.IsKuiper = true
		end

		if mod.ModFlags.glowingHourglass > 0 then
			local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, entity.Position, Vector.Zero, entity)
			timestuck:GetSprite().Scale = Vector(1,1)*0.5
			timestuck:GetData().Timestop_inmune = 2
			sfx:Play(mod.SFX.TimeResume)
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
			if (mod.savedatarun().planetAlive or mod.savedatarun().errantAlive) and not entity:GetData().NoTrapdoor then
				if data.SlowSpawn then
					mod.ModFlags.currentMusic = music:GetCurrentMusicID ()
		
	
					if mod.savedatarun().planetNum == mod.Entity.Luna then
						music:Crossfade (mod.Music.LUNA_INTRO, 2)
						music:Queue(mod.Music.LUNA)
	
					elseif mod.savedatarun().errantAlive then
						music:Crossfade (mod.Music.ERRANT_INTRO, 2)
						music:Queue(mod.Music.ERRANT)
	
					else
						music:Crossfade (mod.Music.PLANET_INTRO, 2)
						music:Queue(mod.Music.PLANET)
					end
					if StageAPI then table.insert(StageAPI.NonOverrideMusic, music:GetCurrentMusicID()) end

				else
					if mod.savedatarun().planetNum == mod.Entity.Luna then
						music:Crossfade (mod.Music.LUNA, 2)
	
					elseif mod.savedatarun().errantAlive then
						music:Crossfade (mod.Music.ERRANT, 2)
	
					else
						music:Crossfade (mod.Music.PLANET, 2)
					end
					if StageAPI then table.insert(StageAPI.NonOverrideMusic, music:GetCurrentMusicID()) end
				end
			end
		end

	end,5)

	if game:IsGreedMode() then
		entity:SetShieldStrength(0)
	end

	mod.CriticalState = false
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.GetFps)
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.GetFps)

end
function mod:UpdateEncounter(entity)
	local id = planet_map[entity.Type]
	if id == 11 and not TheFuture then return end
	mod.savedatapersistent().AstralBossesEncountered = mod.savedatapersistent().AstralBossesEncountered or 0
	mod.savedatapersistent().AstralBossesEncountered = mod.savedatapersistent().AstralBossesEncountered | (1 << id)
end

--Unlock
function mod:TrySolUnlock(playerType)
	
	if false and ANDROMEDA then

		local AchievementDisplay = require("andromeda_src.achievement_display_api")
		local SaveData = require("andromeda_src.savedata")

		local paper = "gfx/ui/andromeda_achievements/andromepaper.png"

		if playerType == Isaac.GetPlayerTypeByName("Andromeda", false) then
			SaveData.UnlockData.Secrets.Starburst = true
			AchievementDisplay.playAchievement("gfx/ui/andromeda_achievements/achievement_starburst.png", 90, paper)
		elseif playerType == Isaac.GetPlayerTypeByName("AndromedaB", true) then
			SaveData.UnlockData.Secrets.EyeOfSpode = true
			AchievementDisplay.playAchievement("gfx/ui/andromeda_achievements/achievement_eyeofspode.png", 90, paper)
		end
	end
end

--ded
function mod:NormalDeath(entity, notExplosion, mamaMega, miniExplosion)
	if mod.savedatarun().planetAlive or entity.Type == mod.EntityInf[mod.Entity.RSaturn].ID then
		if mamaMega then
			mod.savedatarun().planetKilled2 = true
			mod.savedatarun().planetSol2 = true
		else
			mod.savedatarun().planetKilled1 = true
			mod.savedatarun().planetSol1 = true
		end
	end

	local data = entity:GetData()

	if mod:IsChallenge(mod.Challenges.BabelTower) then
		if (not mod.ModFlags.astral_boss) and (not (entity.Type == mod.EntityInf[mod.Entity.Sol].ID or data.SlowSpawn)) then
			mod.ModFlags.babelHeight = mod.ModFlags.babelHeight or 0

			if false and mod.savedatasettings().Difficulty == mod.Difficulties.ATTUNED then
				local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, mod:RandomVector(10), nil)
			elseif mod.savedatasettings().Difficulty == mod.Difficulties.ASCENDED and Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_THELOST_B then
				if (mod.ModFlags.babelHeight and (mod.ModFlags.babelHeight%2==0)) then
					local heart = mod:SpawnEntity(mod.Entity.GlassHeart, entity.Position, mod:RandomVector(10), nil)
				end
			else
				if entity.I2 and entity.I2 > 0 then --kuiper
					if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART) == 0 then
						local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, entity.Position, mod:RandomVector(10), nil)
						local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, mod:RandomVector(10), nil)

						local brother = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BROTHER_BOBBY, entity.Position, Vector.Zero, nil)
					end
				else
					local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, entity.Position, mod:RandomVector(10), nil)
					local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, mod:RandomVector(10), nil)
				end
			end

			mod.ModFlags.babelHeight = mod.ModFlags.babelHeight + 1
		end
	end

	if mod.ModFlags.currentMusic and not (entity.Type == mod.EntityInf[mod.Entity.Luna].ID) then
		music:Crossfade (mod.ModFlags.currentMusic, 0.1)
		mod.ModFlags.currentMusic = nil
	end

	if mamaMega then
		if not notExplosion then
			game:GetRoom():MamaMegaExplosion(entity.Position)
		end

		if mod.savedatarun().planetAlive then

			mod:SpawnChestAfterAstralBoss(entity)

		end
	else
		if not notExplosion then
			game:BombExplosionEffects ( entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
		end
	end

	if mod.savedatafloor().DoubleNothing ~= nil then
        local player0 = Isaac.GetPlayer(0)
        player0:AddCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)
		local position = game:GetRoom():FindFreePickupSpawnPosition(entity.Position)
		local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false), position, Vector.Zero, nil)
        player0:RemoveCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)
		mod.savedatafloor().DoubleNothing = nil
		
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player then
				player:AnimateTrapdoor()
				mod:scheduleForUpdate(function()
					player:GetSprite():Play("Happy", true)
				end, 0)
			end
		end
		sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 2, false, 1.2)
	end

	if not notExplosion then
        local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
		fracture.SpriteScale = Vector.One * 1.5

		sfx:Play(mod.SFX.SuperExplosion)
		game:ShakeScreen(60)

	elseif miniExplosion then
		game:BombExplosionEffects ( entity.Position, 5, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.67, true, false, DamageFlag.DAMAGE_EXPLOSION )
		
        local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
		fracture.SpriteScale = Vector.One * 0.67
	end

	mod.savedatarun().planetAlive = false
	
	mod.CriticalState = false
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.GetFps)

	if game:IsGreedMode() then
		persistentGameData:TryUnlock(Isaac.GetAchievementIdByName("titan (HC)"), false)

		mod:scheduleForUpdate(function ()
			mod:LunarPactDoomSpawn(nil,nil,true)
		end, 12)
	end


	--update defeat
	mod:UpdateDefeat(entity)
end
function mod:UpdateDefeat(entity)
	local n = planet_map[entity.Type]+1
	mod.savedatapersistent().AstralBossesDifficultyDefeat = mod.savedatapersistent().AstralBossesDifficultyDefeat or "0000000000000"
	local current_difficulty = mod.savedatasettings().Difficulty
	if current_difficulty == mod.Difficulties.ASCENDED and Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_THELOST_B and mod:IsChallenge(mod.Challenges.BabelTower) then
		current_difficulty = 3
	end
	current_difficulty = current_difficulty + 1
	local last_defeat = tonumber(mod:get_char(mod.savedatapersistent().AstralBossesDifficultyDefeat, n))
	if current_difficulty > last_defeat then
		mod.savedatapersistent().AstralBossesDifficultyDefeat = mod:set_char(mod.savedatapersistent().AstralBossesDifficultyDefeat, n, tostring(current_difficulty))
	end

	if mod:IsChallenge(mod.Challenges.BabelTower) then
		if mod.ModFlags.astral_boss then
			local flag = true
			if mod.ModFlags.astral_boss == 8 then--kuiper
				local c = 0
				for _, _entity in ipairs(Isaac.GetRoomEntities()) do
					if _entity:IsBoss() and (_entity.Type == mod.EntityInf[mod.Entity.Pluto].ID or _entity.Type == mod.EntityInf[mod.Entity.Eris].ID or _entity.Type == mod.EntityInf[mod.Entity.Haumea].ID or _entity.Type == mod.EntityInf[mod.Entity.Makemake].ID) then
						c = c + 1
					end
				end
				if c~=1 then flag = false end
			end

			if flag then
				if current_difficulty >= 4 then
					local achv
					local text
					if mod.ModFlags.astral_boss == 0 then
						achv = "mercury (HC)"
						text = "Achievement_Mercury"
					elseif mod.ModFlags.astral_boss == 1 then
						achv = "venus (HC)"
						text = "Achievement_Venus"
					elseif mod.ModFlags.astral_boss == 2 then
						achv = "terra (HC)"
						text = "Achievement_Terra"
					elseif mod.ModFlags.astral_boss == 3 then
						achv = "mars (HC)"
						text = "Achievement_Mars"
					elseif mod.ModFlags.astral_boss == 4 then
						achv = "jupiter (HC)"
						text = "Achievement_Jupiter"
					elseif mod.ModFlags.astral_boss == 5 then
						achv = "saturn (HC)"
						text = "Achievement_Saturn"
					elseif mod.ModFlags.astral_boss == 6 then
						achv = "uranus (HC)"
						text = "Achievement_Uranus"
					elseif mod.ModFlags.astral_boss == 7 then
						achv = "neptune (HC)"
						text = "Achievement_Neptune"
					elseif mod.ModFlags.astral_boss == 8 then
						achv = "kuiper (HC)"
						text = "Achievement_Kuiper"
					elseif mod.ModFlags.astral_boss == 9 then
						achv = "luna (HC)"
						text = "Achievement_Luna"
					elseif mod.ModFlags.astral_boss == 10 then
						achv = "errant (HC)"
						text = "Achievement_Errant"
					elseif mod.ModFlags.astral_boss == 11 then
						achv = "rsaturn (HC)"
						text = "Achievement_RSaturn"
					elseif mod.ModFlags.astral_boss == 12 then
						achv = "sol (HC)"
						text = "Achievement_Sol"
					end
					if achv and text then
						local unlocked = persistentGameData:TryUnlock(Isaac.GetAchievementIdByName(achv), false)
						if unlocked then
							mod:scheduleForUpdate(function ()
								mod:StartAchievement("paper", text)
							end,60)
						end
					else
						print("ERROR: INVALID ACHIEVEMENT!")
					end
				end
				mod:GoToGauntletInit()
			end

		else
			if entity.Type == mod.EntityInf[mod.Entity.Errant].ID then

				local everchanger = mod:SpawnEntity(mod.Entity.Everchanger, entity.Position, Vector.Zero, nil):ToNPC()
				everchanger.CanShutDoors = true
				local data = everchanger:GetData()

				data.Natural = true
				data.State = mod.ECState.INSTAKILL
				data.Map_Init = true
				data.Sol = current_difficulty > 2
				data.H = 1

				if data.Sol then
					everchanger.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

					sfx:Play(mod.SFX.Geiger, 2)
					sfx:Play(mod.SFX.Evil)

					mod:scheduleForUpdate(function ()
						if everchanger then
							everchanger:GetSprite():Play("Death", true)

							for i=1, 20 do
								local glitch = mod:SpawnEntity(mod.Entity.Glitch, everchanger.Position, 2*Vector.One + mod:RandomVector(5), nil)
							end
						end
						local room = game:GetRoom()
						local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.OtherItems.Egg, room:GetCenterPos(), Vector.Zero, nil)

						local door = room:GetDoor(DoorSlot.RIGHT0)
						mod:TransformDoor2Solar(door, room)

					end,90)
					mod:SolarQQQLaser(everchanger, 90, 180, 4, 4)
				else
					game:GetHUD():ShowItemText("This is the end", "try ascended difficulty")
				end
				
				sfx:Play(mod.SFX.AngryStaticScream, 3.5)
                game:ShakeScreen(15)

				local unlocked = persistentGameData:TryUnlock(Isaac.GetAchievementIdByName("challenge_everchanger (HC)"), false)
				if unlocked then
					mod:scheduleForUpdate(function ()
						mod:StartAchievement("paper", "Achievement_ChallengeEverchanger")
					end,90)
				end
			end
		end
	end
end

function mod:SpawnChestAfterAstralBoss(entity)

	local level = game:GetLevel()
	local center = game:GetRoom():GetCenterPos()

	if mod.savedatarun().planetNum == mod.Entity.Luna then
		for i=-1, 1, 2 do
			local position = game:GetRoom():FindFreePickupSpawnPosition(entity.Position)
			local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false), position, Vector.Zero, nil)
		end
		local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, entity.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)
	else
		local position = game:GetRoom():FindFreePickupSpawnPosition(entity.Position)
		local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false), position, Vector.Zero, nil)
	end


	local chestFlag = (mod.savedatasettings().victoryChest and mod.savedatasettings().victoryChest == 1) or (mod.savedatarun().planetSol1 and mod.savedatarun().planetSol2)
	local stage6Flag = mod:CheckChestUnlock()

	if chestFlag and stage6Flag then
		local corpseFlag = mod:AreWeOnCorpse() and mod.savedatarun().planetSol1
		
		if game:GetLevel():GetStage() == LevelStage.STAGE5 then
			if mod:CheckCorrectPolaroid() then
				local winChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 0, center, Vector.Zero, nil)
				mod:HeavenifyChest()
			end
			
			if rng:RandomFloat() <= 0.5 and mod:CheckVoidUnlock() then
				
				local voidPortal = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, center + Vector(0,75), true)
				voidPortal.VarData = 1
				
				-- Replace the spritesheet to make it look like a Void Portal
				local sprite = voidPortal:GetSprite()
				sprite:Load("gfx/grid/voidtrapdoor.anm2", true)
			end
		elseif corpseFlag then
			local winChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 0, center, Vector.Zero, nil)
			mod:HeavenifyChest()
		end
	end
end

--difficulty
mod.Difficulties = {
	NORMAL = 0,
	ATTUNED = 1,
	ASCENDED = 2,
}

table.insert(mod.PostLoadInits, {"savedatasettings", "Difficulty", mod.Difficulties.NORMAL})
function mod:ResetDifficulty(iscontinued)
	if not iscontinued then
		mod:UpdateDifficulty(mod.Difficulties.NORMAL)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetDifficulty)
function mod:UpdateDifficulty(difficulty, instant)
	difficulty = difficulty or mod.savedatasettings().Difficulty or mod.Difficulties.NORMAL

	if not instant then
		mod:scheduleForUpdate(function ()
			mod.savedatasettings().Difficulty = difficulty
		end,1)
	else
		mod.savedatasettings().Difficulty = difficulty
	end

	mod:SetJupiterDifficulty(difficulty)
	mod:SetSaturnDifficulty(difficulty)
	mod:SetUranusDifficulty(difficulty)
	mod:SetNeptuneDifficulty(difficulty)
	mod:SetKuiperDifficulty(difficulty)

	mod:SetMercuryDifficulty(difficulty)
	mod:SetVenusDifficulty(difficulty)
	mod:SetTerraDifficulty(difficulty)
	mod:SetMarsDifficulty(difficulty)

	mod:SetRSaturnDifficulty(difficulty)
end
--mod.SaveManager.AddCallback(mod.SaveManager.Utility.CustomCallback.POST_DATA_LOAD, mod.UpdateDifficulty)



local vsSprite = Sprite()
local vsFrame = 0
local onVSScreen = false

function mod:ShowBattleScreen(entity)

	if entity.Type == mod.EntityInf[mod.Entity.Sol].ID then
		vsSprite:Load("hc/gfx/ui/versusscreen_sol.anm2", true)
		vsSprite:Play("Scene", true)
		
        music:Crossfade(mod.Music.SOL, 2)
		music:Queue(mod.Music.SOL)
	end

	--cosas
	local player_config = EntityConfig.GetPlayer(Isaac.GetPlayer(0):GetPlayerType())
	local portrait = player_config:GetPortraitPath()
	local name = player_config:GetNameImagePath()

	vsSprite:ReplaceSpritesheet(6, portrait)
	vsSprite:ReplaceSpritesheet(2, portrait)
	vsSprite:ReplaceSpritesheet(3, name)

	vsSprite:LoadGraphics()

	vsFrame = 0


	game:GetHUD():SetVisible(false)
	if not onVSScreen then
		onVSScreen = true
		mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderBattleScreen)
	end

	local flag = mod.ShaderData.solData.ENABLED
	mod:scheduleForUpdate(function()
		mod:HideBattleScreen()
		if flag then
			mod.ShaderData.solData.ENABLED = true
		end
	end, 100)

	mod.ShaderData.solData.ENABLED = false

end
function mod:HideBattleScreen()
	onVSScreen = false
	vsFrame = 0
	game:GetHUD():SetVisible(true)
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.RenderBattleScreen)
end

function mod:RenderBattleScreen()
	if not onVSScreen then return end

	local room = game:GetRoom()
	--local position = room:WorldToScreenPosition(room:GetCenterPos() + Vector(20,-140))
	--local position = room:WorldToScreenPosition(room:GetCenterPos())
	local position = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2)
	vsFrame = vsFrame + 0.5

	vsSprite:Render(position)
	vsSprite:SetFrame(math.floor(vsFrame))

	if vsSprite:IsFinished() then
		mod:HideBattleScreen()
	end

	--dark esau
	for i, esau in ipairs(Isaac.FindByType(EntityType.ENTITY_DARK_ESAU)) do
		esau.Velocity = Vector.Zero
	end

	--skip
	for i=0, game:GetNumPlayers ()-1 do
		if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, i) then
			mod:HideBattleScreen()

			for _, sol in ipairs(mod:FindByTypeMod(mod.Entity.Sol)) do
				sol:GetData().SkippedIntro = true
				sol:GetSprite():SetLastFrame()
			end
		end

		local player = Isaac.GetPlayer(i)
		if player then
			player.ControlsCooldown = 1
			player:SetMinDamageCooldown(1)
		end
	end

end

mod.ETERNAL_CHANCE = 35
table.insert(mod.PostLoadInits, {"savedatasettings", "eternalChance", mod.ETERNAL_CHANCE})

function mod:ShouldBossBeEternal(entity)

	if game.Challenge > 0 then return false end
	if not entity then return false end
	if not (Isaac.GetSoundIdByName("super sloth spawn spiders") > 0) then return false end

	local id = entity.Type

	local isKuiper = (id == mod.EntityInf[mod.Entity.Pluto].ID) or (id == mod.EntityInf[mod.Entity.Charon1].ID) or (id == mod.EntityInf[mod.Entity.Charon2].ID) or (id == mod.EntityInf[mod.Entity.Eris].ID) or (id == mod.EntityInf[mod.Entity.Haumea].ID) or (id == mod.EntityInf[mod.Entity.Makemake].ID) or (id == mod.EntityInf[mod.Entity.Ceres].ID)
	if isKuiper then id = mod.EntityInf[mod.Entity.Pluto].ID end
	
	local isTerra = (id == mod.EntityInf[mod.Entity.Terra1].ID) or (id == mod.EntityInf[mod.Entity.Terra2].ID) or (id == mod.EntityInf[mod.Entity.Terra3].ID)
	if isTerra then id = mod.EntityInf[mod.Entity.Terra1].ID end

	local rng = RNG(id, game:GetSeeds():GetStartSeed()%79+1)
	local r = rng:RandomFloat()
	
	return r < mod.savedatasettings().eternalChance/100
end

function mod:CheckEternalBoss(entity)
	if mod:ShouldBossBeEternal(entity) then
		local sprite = entity:GetSprite()

		local id = entity.Type
		local isSecondaryKuiper = (id == mod.EntityInf[mod.Entity.Charon1].ID) or (id == mod.EntityInf[mod.Entity.Charon2].ID) or (id == mod.EntityInf[mod.Entity.Eris].ID) or (id == mod.EntityInf[mod.Entity.Haumea].ID) or (id == mod.EntityInf[mod.Entity.Makemake].ID) or (id == mod.EntityInf[mod.Entity.Ceres].ID)

		local isRSaturn = id == mod.EntityInf[mod.Entity.RSaturn].ID
		local isSol = id == mod.EntityInf[mod.Entity.Sol].ID

		if (isRSaturn or isSol) or (mod:IsRoomDescAstralChallenge(game:GetLevel():GetCurrentRoomDesc()) and (not isSecondaryKuiper) and (not game:GetRoom():IsClear())) then
			mod:UpdateDifficulty(math.min(mod.Difficulties.ASCENDED, mod.savedatasettings().Difficulty+1), true)
		end
		
		if entity.Type == mod.EntityInf[mod.Entity.Jupiter].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/jupiter/jupiter_eternal.png")
			sprite:ReplaceSpritesheet (1, "hc/gfx/bosses/jupiter/jupiter_eternal.png")

		elseif entity.Type == mod.EntityInf[mod.Entity.Saturn].ID then
			sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/saturn/saturn_eyesless_eternal.png")

		elseif entity.Type == mod.EntityInf[mod.Entity.Uranus].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/uranus/uranus_eternal.png")
			sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/uranus/uranus_eternal.png")
			sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/uranus/uranus_eternal.png")
			sprite:ReplaceSpritesheet (8, "hc/gfx/bosses/uranus/uranus_eternal.png")

		elseif entity.Type == mod.EntityInf[mod.Entity.Neptune].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_eternal.png")
			sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/neptune/neptune_eternal.png")
			sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/neptune/neptune_eternal_eyes.png")
			sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/neptune/neptune_eternal_body.png")
			
		elseif entity.Type == mod.EntityInf[mod.Entity.Mercury].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/mercury/Mercury_eternal.png")
			sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/mercury/Mercury_eternal.png")
			sprite:ReplaceSpritesheet (7, "hc/gfx/bosses/mercury/Mercury_eternal.png")
			sprite:ReplaceSpritesheet (8, "hc/gfx/bosses/mercury/Mercury_eternal.png")
			sprite:ReplaceSpritesheet (10, "hc/gfx/bosses/mercury/Mercury_eternal.png")

		elseif entity.Type == mod.EntityInf[mod.Entity.Venus].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/venus/venus_eternal.png")
			sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/venus/venus_eternal.png")
			sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/venus/venus_eternal.png")
			sprite:ReplaceSpritesheet (7, "hc/gfx/bosses/venus/venus_eternal.png")
			sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/venus/venus_eternal.png")

		elseif entity.Type == mod.EntityInf[mod.Entity.Terra1].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/terra/terra_green_eternal.png")
			sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/terra/terra_green_eternal.png")
			sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/terra/terra_green_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Terra3].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/terra/terra_eden_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Mars].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/mars/mars_eternal.png")
			sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/mars/mars_eternal.png")
			sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/mars/mars_eternal.png")
			sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/mars/mars_eternal.png")
			sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/mars/mars_eternal.png")
			sprite:ReplaceSpritesheet (7, "hc/gfx/bosses/mars/mars_eternal.png")

			
		elseif entity.Type == mod.EntityInf[mod.Entity.Pluto].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/kuiper/pluto_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Charon1].ID or entity.Type == mod.EntityInf[mod.Entity.Charon2].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/kuiper/charon_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Eris].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/kuiper/eris_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Makemake].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/kuiper/makemake_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Haumea].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/kuiper/haumea_eternal.png")
			sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/kuiper/haumea_eternal.png")
		elseif entity.Type == mod.EntityInf[mod.Entity.Ceres].ID then
			sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/kuiper/ceres_eternal.png")
			sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/kuiper/ceres_eternal.png")
			sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/kuiper/ceres_eternal.png")

		end

		sprite:LoadGraphics()

		return true
	end
	return false
end


-- FPS

local lastFrame = 0
local renderCalls = 0
mod.fps = 60
mod.fpsCounter = 0

function mod:GetFps()
	if mod.CriticalState then
		mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.GetFps)
	end

	if renderCalls == 0 then
		local currentFrame = Isaac.GetTime()
		local fps = 1000 / (currentFrame - lastFrame) * 30
		fps = math.floor(fps + 0.5)

		mod.fps = fps
		if fps < 35 then
			mod.fpsCounter = mod.fpsCounter + 1
			if mod.fpsCounter > 5 then
				mod.CriticalState = true
				print("[Heaven's Call INFO] Consistent FPS drops during boss battle, disabling secondary effects to gain performance.")
			end
		else
			mod.fpsCounter = 0
		end
		--print(mod.fpsCounter)

		lastFrame = currentFrame
	end

	renderCalls = (renderCalls + 1) % 30
end
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.GetFps)



function mod:OnVictoryChestCollision(entity, collider, collision)
	if collider:ToPlayer() and entity:GetSprite():IsFinished() then
		if entity:GetData().IsHeaven then
			local level = game:GetLevel()
			local levelStage = level:GetStage()
			mod.savedatarun().solEnabled = true

			local corpseFlag = ( (LevelStage.STAGE4_1 <= levelStage and levelStage == LevelStage.STAGE4_2) and ( level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B )) or (LastJudgement and LastJudgement.STAGE.Mortis:IsStage())
			if corpseFlag then
				
				local cathedral = mod:RandomInt(0,1)
				if player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then
					cathedral = 1
				elseif player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
					cathedral = 0
				end

				if cathedral == 0 and not persistentGameData:Unlocked(Achievement.NEGATIVE) then
					cathedral = 1
				end

				if cathedral == 1 then
					if not player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then
						Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_POLAROID)
					end
				else
					if not player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
						Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_NEGATIVE)
					end
				end

				level:SetStage(10, cathedral)

				return false
			end
		else
			mod.savedatarun().solEnabled = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnVictoryChestCollision, PickupVariant.PICKUP_BIGCHEST)