local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--Statue----------------------------------------------------------------------------------------------------------------------------

function mod:StatueUpdate(entity)
	if mod.EntityInf[mod.Entity.Statue].VAR == entity.Variant and mod.EntityInf[mod.Entity.Statue].SUB <= entity.SubType and entity.SubType <= mod.EntityInf[mod.Entity.Statue].SUB+9 then
		entity.Velocity = Vector.Zero
		entity.Position = game:GetRoom():GetCenterPos() + Vector(0,-20)
		if entity:GetData().Initialized == nil then
			entity:GetData().Initialized = true
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
			entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
			
			if entity.SubType == mod.EntityInf[mod.Entity.Statue].SUB or entity.SubType == mod.EntityInf[mod.Entity.Statue].SUB+1 then
				entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
				entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
			end

			entity:GetSprite():Play("Appear",true)
		end

		if entity:GetSprite():IsFinished("Ded") then
			entity:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.StatueUpdate, mod.EntityInf[mod.Entity.Statue].ID)

function mod:StatueRenderUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Statue].VAR and mod.EntityInf[mod.Entity.Statue].SUB == entity.SubType then

		for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)) do
			if pedestal:GetData().WasDeleted ~= true then
				pedestal:Remove()
				mod:StatueTriggerSpawn(entity)

				--Turn pickups into poop if the items was taken in the same frame... or not, cuz its commented :)
				--[[mod:scheduleForUpdate(function()
					for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
						if pickup:GetData().isAstral then
							pickup = pickup:ToPickup()
							pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, mod:RandomInt(0,1))
						end
					end
				end,0)]]--
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.StatueRenderUpdate, mod.EntityInf[mod.Entity.Statue].ID)

function mod:StatueTriggerSpawn(entity)
	entity:GetSprite():Play("Ded")

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	
	local futureFlag = TheFuture and TheFuture.Stage:IsStage() and (not mod.savedatarun().nevermoreDefeated)
	if futureFlag then
		
		sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS,1)
		room:SetClear(false)

		game:SetColorModifier(ColorModifier(1,1,1,1,1),true)
		sfx:Play(Isaac.GetSoundIdByName("ouroborosDeath"))
		mod:scheduleForUpdate(function ()
			game:SetColorModifier(ColorModifier(1,1,1,0),true)
			if not mod.FcukScreen then
				mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnFcukScreenRender)
			end
		end, 30)

		return
	end

	if mod:IsRoomDescAstralChallenge(roomdesc) and mod.savedatarun().planetNum and #(mod:FindByTypeMod(mod.savedatarun().planetNum))==0 then

		local planet = mod:SpawnEntity(mod.savedatarun().planetNum, entity.Position, Vector.Zero, entity)
		planet:GetData().SlowSpawn = true

		mod.savedatarun().planetAlive = true
		mod.savedatarun().planetHP = planet.HitPoints

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

	elseif mod:IsRoomDescErrant(roomdesc) and #(mod:FindByTypeMod(mod.Entity.Errant))==0 then

		local planet = mod:SpawnEntity(mod.Entity.Errant, entity.Position, Vector.Zero, entity)
		planet:GetData().SlowSpawn = true

		planet:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		mod.savedatarun().errantAlive = true
		mod.savedatarun().errantKilled = false
		mod.savedatarun().errantHP = planet.HitPoints

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
	end

	mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.StarAstral))
end

function mod:OnStatueDamage(entity, amount, damageFlags, source, frames)
	if entity.Variant == mod.EntityInf[mod.Entity.Statue].VAR and entity.SubType == mod.EntityInf[mod.Entity.Statue].SUB then

		if (damageFlags&DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION) and not entity:GetData().Spawnflag then
			for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				for i=1, mod:RandomInt(mod.StatuePickupPoolMin, mod.StatuePickupPoolMax) do
					mod:SpawnPickup(pedestal)
				end

				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pedestal.Position, Vector.Zero, nil)
				pedestal:Remove()
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY,1)
			end

			if mod.savedatafloor().DoubleNothing then
				mod.savedatafloor().DoubleNothing = -1
			end

			entity:GetData().Spawnflag = true--For double in same frame explosions
			
			mod:StatueTriggerSpawn(entity)
		end
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnStatueDamage, mod.EntityInf[mod.Entity.Statue].ID)

function mod:OnStatueDeath(entity)
	if mod.EntityInf[mod.Entity.Statue].VAR == entity.Variant and mod.EntityInf[mod.Entity.Statue].SUB <= entity.SubType and entity.SubType <= mod.EntityInf[mod.Entity.Statue].SUB+9 then
		game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 75, 9)
		sfx:Play(SoundEffect.SOUND_MIRROR_BREAK,1)

		if mod.EntityInf[mod.Entity.Statue].SUB == entity.SubType then
			mod.savedatarun().planetAlive = false
			
			local roomdesc = game:GetLevel():GetCurrentRoomDesc()
			if mod:IsRoomDescAstralChallenge(roomdesc) then
				if roomdesc.Data.Variant <= mod.RoomVariantVecs.Astral1.Y then
					mod.savedatarun().planetKilled1 = true
					mod.savedatarun().planetSol1 = true
				elseif roomdesc.Data.Variant >= mod.RoomVariantVecs.Astral2.X then
					mod.savedatarun().planetKilled2 = true
					mod.savedatarun().planetSol2 = true
				end
			elseif mod:IsRoomDescErrant(roomdesc) and roomdesc.Data.Type == RoomType.ROOM_ERROR then
				local trapdoor = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, game:GetRoom():GetCenterPos(), true)
			end

			if game:GetLevel():GetStage() == LevelStage.STAGE5 then
				mod:SpawnChestAfterAstralBoss(entity)
			end

		else
			game:GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, false)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnStatueDeath, mod.EntityInf[mod.Entity.Statue].ID)

function mod:OnPedestalTouch(pickup, collider)
	if collider.Type == EntityType.ENTITY_PLAYER and pickup:GetData().WasDeleted ~= true then
		mod:ForceStatueToTrigger()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnPedestalTouch, PickupVariant.PICKUP_COLLECTIBLE)


--Pickup stuff
mod.StatuePickupPoolMin = 10
mod.StatuePickupPoolMax = 15
mod.StatuePickupPool = {}
for i=1,15 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_HEART end
for i=1,14 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_BOMB end
for i=1,14 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_KEY end
for i=1,15 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_COIN end
for i=1,10 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_TAROTCARD end
for i=1,5 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_TRINKET end
for i=1,10 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_PILL end
for i=1,7 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_GRAB_BAG end
for i=1,10 do mod.StatuePickupPool[#mod.StatuePickupPool+1]=PickupVariant.PICKUP_LIL_BATTERY end
function mod:SpawnPickup(entity)

	local pickup = mod.StatuePickupPool[mod:RandomInt(1,#mod.StatuePickupPool)]
	local pickupSub = 0
	--No troll bomb and maybe giga bomb
	if pickup == PickupVariant.PICKUP_BOMB then
		pickupSub = ({1,1,1,2,})[mod:RandomInt(1,4)]
		if mod:RandomInt(1,20)==7 then
			pickupSub = BombSubType.BOMB_GOLDEN
		elseif mod:RandomInt(1,2000)==777 then
			pickupSub = BombSubType.BOMB_GIGA
		end
	end
	--Increase red key chance
	if pickup == PickupVariant.PICKUP_TAROTCARD then
		if mod:RandomInt(1,25)==7 then
			pickupSub = Card.CARD_CRACKED_KEY
		end
	end

	local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, pickup, pickupSub, entity.Position, mod:RandomVector(4, 3.5), nil)
	--pickup:GetData().isAstral = true --This was to transform it into pool if "exploit" is used
end

--Compat
function mod:StatueDie()
	mod:ForceStatueToTrigger()
end

function mod:ForceStatueToTrigger()
	local statues = mod:FindByTypeMod(mod.Entity.Statue)
	if statues[1] then
		mod:StatueTriggerSpawn(statues[1])
	end
end

------------------------------------------------------------------------
-----------------------Astral boss statue-------------------------------
------------------------------------------------------------------------


function mod:BossStatueUpdate(entity)
	if mod.EntityInf[mod.Entity.BossStatue].SUB == entity.SubType then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if data.Init == nil then
			data.Init = true

			entity.SpriteOffset = Vector(0,10)

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
			entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)

			entity.TargetPosition = entity.Position
			data.FixedPosition = entity.Position

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

			--0 mr, 1 v, 2 t, 3 m, 4 j, 5 s, 6 u, 7 n, 8 k, 9 l, 10 e, 11 rs, 12 so
			data.Planet = data.Planet or 0
			data.FirstSpawn = data.FirstSpawn or false

			
			if data.Planet==12 then
            	entity:SetSize(25, Vector(2.5,1), 12)
			else
            	entity:SetSize(15, Vector(2.25,1), 12)
			end

			mod.savedatapersistent().AstralBossesEncountered = mod.savedatapersistent().AstralBossesEncountered or 0
			local astral_bosses_encountered = mod.savedatapersistent().AstralBossesEncountered
			--mod.savedatapersistent().AstralBossesDifficulty = mod.savedatapersistent().AstralBossesDifficulty or "0000000000000"
			--local astral_bosses_difficulty = mod.savedatapersistent().AstralBossesDifficulty
			mod.savedatapersistent().AstralBossesDifficultyDefeat = mod.savedatapersistent().AstralBossesDifficultyDefeat or "0000000000000"
			local astral_bosses_difficulty_defeated = mod.savedatapersistent().AstralBossesDifficultyDefeat

			if (astral_bosses_encountered & (1<<data.Planet)) == 0 then
				if data.Planet==12 then
					sprite:Play("LockedBig", true)
				else
					sprite:Play("Locked", true)
				end
				data.Disabled = true
				return
			end

			if data.FirstSpawn then
				entity:SetColor(Color(1,1,1,1, 1,1,1), 15, 1, true, true)

				for _=1, 30 do
					local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
					local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity)
					feather:GetData().FromPlayer = true
				end
			end


			for i=0, 12 do
				if i==data.Planet then
					local defeated_difficulty = tonumber(string.sub(astral_bosses_difficulty_defeated, i+1, i+1))

					sprite:Play(tostring(i), true)
					sprite:SetFrame(defeated_difficulty)
					break
				end
			end


			if data.Planet==12 then
				sprite:PlayOverlay("BaseBig", true)
			else
				sprite:PlayOverlay("Base", true)
			end
			sprite:SetOverlayRenderPriority(true)
		end
		
		entity.Position = entity.TargetPosition
		entity.Velocity = Vector.Zero

		if not data.Disabled then
			local player = Isaac.GetPlayer(0)
			if player.Position:Distance(entity.Position + Vector(0,30)) < 20 then
				data.Disabled = true

				local mapa = {
					[0] = 8525,
					[1] = 8526,
					[2] = 8527,
					[3] = 8528,

					[4] = 8520,
					[5] = 8521,
					[6] = 8522,
					[7] = 8523,

					[8] = 8524,
					[9] = 8530,
					[10] = 8531,
					[11] = 8532,

					[12] = 8500,
				}
    			
    			game:SetColorModifier(ColorModifier(1,1,1,1,5),false)

				local id = mapa[data.Planet]
				if data.Planet == 12 then
					Isaac.ExecuteCommand("goto s.error."..tostring(id))
				else
					Isaac.ExecuteCommand("goto s.dice."..tostring(id))
				end
				sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS,1)
				
				mod.ModFlags.astral_boss = data.Planet

				if data.Planet < 4 or data.Planet > 7 and data.Planet ~= 11 and data.Planet ~= 8 then
					player:AddCollectible(mod.OtherItems.Carrot)
				end
				if data.Planet == 12 then
					player:AddCollectible(mod.OtherItems.Egg)
				end
				if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.OtherItems.Apple) > 0 then
					player:AddCollectible(mod.OtherItems.Apple)
				end

				mod:scheduleForUpdate(function ()
					local room = game:GetRoom()
					for i=DoorSlot.LEFT0, DoorSlot.DOWN1 do
						room:RemoveDoor(i)
					end
				end,1)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.BossStatueUpdate, mod.EntityInf[mod.Entity.BossStatue].VAR)

function mod:SpawnBossStatues(center_position)

	local room = game:GetRoom()

	local center = center_position or room:GetCenterPos()

	mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.BossStatue))
	for y = 0, 2 do
		for x = 0, 3 do
			
			local offset = Vector(x*150, y*200)
			local position = center + offset
			
			local planet = y * 4 + (3-x)

			--if planet ~= 11 then
				local statue = mod:SpawnEntity(mod.Entity.BossStatue, position, Vector.Zero, nil)
				statue:GetData().Planet = planet
				statue:Update()
			--end

		end
	end
	
	local position = center + Vector(450/2,-175)
	local statue = mod:SpawnEntity(mod.Entity.BossStatue, position, Vector.Zero, nil)
	statue:GetData().Planet = 12
	statue:Update()

	mod:scheduleForUpdate(function ()
		for _, furniture in ipairs(Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP)) do
			furniture.Visible = false
			furniture.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		end
	end,6)
end