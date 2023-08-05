local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()
local json = require("json")



--ENTITIES--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Statue----------------------------------------------------------------------------------------------------------------------------
local PickupPoolMin = 6
local PickupPoolMax = 10
local PickupPool = {}
for i=1,15 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_HEART end
for i=1,14 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_BOMB end
for i=1,14 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_KEY end
for i=1,15 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_COIN end
for i=1,10 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_TAROTCARD end
for i=1,5 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_TRINKET end
for i=1,10 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_PILL end
for i=1,7 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_GRAB_BAG end
for i=1,10 do PickupPool[#PickupPool+1]=PickupVariant.PICKUP_LIL_BATTERY end
function mod:SpawnPickup(entity)

	local pickup = PickupPool[mod:RandomInt(1,#PickupPool)]
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

	local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, pickup, pickupSub, entity.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)
	--pickup:GetData().isAstral = true --This was to transform it into pool if "exploit" is used
end

function mod:StatueUpdate(entity)
	if mod.EntityInf[mod.Entity.Statue].VAR <= entity.Variant and entity.Variant <= mod.EntityInf[mod.Entity.Statue].VAR+9 then
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
			
			if entity.Variant == mod.EntityInf[mod.Entity.Statue].VAR or entity.Variant == mod.EntityInf[mod.Entity.Statue].VAR+1 then
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
function mod:StatueRenderUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Statue].VAR then
		--IAM DOING AN Isaac.FindByType EVERY RENDER, AND NOBODY CAN STOP ME!!!!!
		for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)) do
			if pedestal:GetData().WasDeleted ~= true then
				pedestal:Remove()
				mod:StatueDie(entity)

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

function mod:StatueDie(entity)
	entity:GetSprite():Play("Ded")

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	if mod:IsRoomDescAstralChallenge(roomdesc) and mod.savedata.planetNum and #(mod:FindByTypeMod(mod.savedata.planetNum))==0 then
		
		mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.Dyings)

		local planet = mod:SpawnEntity(mod.savedata.planetNum, entity.Position, Vector.Zero, entity)
		planet:GetData().SlowSpawn = true

		mod.savedata.planetAlive = true --Yes, I know about FLAG_PERSISTENT
		mod.savedata.planetHP = planet.HitPoints

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

	elseif mod:IsRoomErrant(roomdesc) and #(mod:FindByTypeMod(mod.Entity.Errant))==0 then
		mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.Dyings)

		local planet = mod:SpawnEntity(mod.Entity.Errant, entity.Position, Vector.Zero, entity)
		planet:GetData().SlowSpawn = true

		planet:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		mod.savedata.errantAlive = true
		mod.savedata.errantKilled = false
		mod.savedata.errantHP = planet.HitPoints

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
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.StatueUpdate, mod.EntityInf[mod.Entity.Statue].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.StatueRenderUpdate, mod.EntityInf[mod.Entity.Statue].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, _, damageFlag, _, _)
	if entity.Variant == mod.EntityInf[mod.Entity.Statue].VAR then
		if (damageFlag & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION) and not entity:GetData().Spawnflag then
			for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				for i=1, mod:RandomInt(PickupPoolMin,PickupPoolMax) do
					mod:SpawnPickup(pedestal)
				end
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pedestal.Position, Vector.Zero, nil)
				pedestal:Remove()
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY,1)
			end

			entity:GetData().Spawnflag = true--For double in same frame explosions
			mod:StatueDie(entity)
		end
		return false
	end
end, mod.EntityInf[mod.Entity.Statue].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, entity)--You can kill it with the Chaos card
	if mod.EntityInf[mod.Entity.Statue].VAR <= entity.Variant and entity.Variant <= mod.EntityInf[mod.Entity.Statue].VAR+9 then
		game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 75, 9)
		sfx:Play(SoundEffect.SOUND_MIRROR_BREAK,1)

		if mod.EntityInf[mod.Entity.Statue].VAR == entity.Variant then
			mod.savedata.planetAlive = false
			
			local roomdesc = game:GetLevel():GetCurrentRoomDesc()
			if mod:IsRoomDescAstralChallenge(roomdesc) then
				if roomdesc.Data.Variant <= mod.maxvariant1 then
					mod.savedata.planetKilled1 = true
				elseif roomdesc.Data.Variant >= mod.minvariant2 then
					mod.savedata.planetKilled2 = true
				end
			elseif mod:IsRoomErrant(roomdesc) and roomdesc.Data.Type == RoomType.ROOM_ERROR then
				local trapdoor = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, game:GetRoom():GetCenterPos(), true)
			end

		else
			game:GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, false)
		end
	end
end, mod.EntityInf[mod.Entity.Statue].ID)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_,pickup,entity)
	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
		if entity.Type == EntityType.ENTITY_PLAYER and pickup:GetData().WasDeleted ~= true then
			local statues = mod:FindByTypeMod(mod.Entity.Statue)
			if #statues>0 then
				mod:StatueDie(statues[1])
			end
		end
	end
end)

--Telescope-------------------------------------------------------------------------------------------------------------------------
mod.telescopeTrinkets = {
	TelescopeLens = TrinketType.TRINKET_TELESCOPE_LENS,
	Shard = Isaac.GetTrinketIdByName("Quantum Shard"),
	Sputnik = Isaac.GetTrinketIdByName("Sputnik"),
	Flag = Isaac.GetTrinketIdByName("Faded flag"),
}

mod.TRewards = {
	[1] = "MOON",
	[2] = "WISP",
	[3] = "ASTRAL",
	[4] = "RETROGRADE",
	[5] = "SOUL",
	[6] = "HALF_SOUL",
	[7] = "BLAZE",
	[8] = "EXPLODE",
	[9] = "NOTHING",
}
--                   		MOON    WISP    ASTRAL   RETRO    SOUL    HSOUL   BLAZE    EXPLO    NOTHING
mod.TelescopeChain = 		{0.06,  0.075,   0.03,    0.03,    0.03,   0.05,   0.03,    0.03,    1}
mod.LuckyTelescopeChain = 	{0.09,  0.1,     0.035,   0.035,   0.045,  0.075,  0.06,    0.06,    1}

function mod:TelescopeUpdate(slot)
	if slot.Variant == mod.EntityInf[mod.Entity.Telescope].VAR and slot.SubType == mod.EntityInf[mod.Entity.Telescope].SUB then
		local sprite = slot:GetSprite()
		local data = slot:GetData()

		if not data.Init then
			data.Init = true

			slot.HitPoints = 1
		end

		if slot.HitPoints <= 0  then
			if not (sprite:GetAnimation()=="Death" or sprite:GetAnimation()=="Broken") then
				sprite:Play("Death", true)

			elseif sprite:IsFinished("Death") then
				sprite:Play("Broken", true)
			end
		else
			if sprite:IsFinished("Initiate") then
				sprite:Play("Wiggle", true)
	
			elseif sprite:IsFinished("Wiggle") then
				sprite:Play("Prize", true)
	
			elseif sprite:IsFinished("Prize") then
				sprite:Play("Idle", true)
	
			end

			if sprite:IsEventTriggered("Sound") then
				sfx:Play(SoundEffect.SOUND_DOGMA_LIGHT_APPEAR, 0.5, 0, false, 3)

			elseif sprite:IsEventTriggered("Prize") then

				local chain = mod.TelescopeChain
				if data.Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
					chain = mod.LuckyTelescopeChain
				end

				local roll = rng:RandomFloat()
				local reward = "NOTHING"

				local sum = 0
				for index, chance in ipairs(chain) do
					sum = sum + chance
					if roll <= sum then
						reward = mod.TRewards[index]
						break
					end
				end


				if reward == "NOTHING" and mod:ExtraMoonRoll(data.Player) then
					reward = "MOON"
				end

				if reward ~= "NOTHING" then
					slot:SetColor(mod.Colors.jupiterLaser2, 10, 1, true, false)
					sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1, 0, false, 2)
				end


				if reward == "MOON" then--Moon
					mod:ChooseMiniMoon(data.Player)

				elseif reward == "WISP" then
					data.Player:AddWisp(1, data.Player.Position)

				elseif reward == "ASTRAL" then
					data.Player:AddItemWisp(mod:GetAstralCollectible(), data.Player.Position)

				elseif reward == "RETROGRADE" then
					data.Player:AddItemWisp(mod:random_elem(mod.PassiveItems), data.Player.Position)

				elseif reward == "SOUL" then
					local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, slot.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)
				
				elseif reward == "BLAZE" then
					local pickup = mod:SpawnEntity(mod.Entity.BlazeHeart, slot.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)

				elseif reward == "HALF_SOUL" then
					local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, slot.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)

				elseif reward == "EXPLODE" then
					game:BombExplosionEffects (slot.Position, 0, TearFlags.TEAR_NORMAL, mod.Colors.jupiterLaser2, nil, 0.1, true, false, DamageFlag.DAMAGE_EXPLOSION )
					data.Ended = true
				end
			end
	
			
			for i=0, game:GetNumPlayers ()-1 do
				local player = game:GetPlayer(i):ToPlayer()
	
				if player.Position:Distance(slot.Position) <= player.Size + slot.Size then
					if sprite:IsPlaying("Idle") and player:GetNumCoins() > 0 then
						data.Player = player
						player:AddCoins(-1)
						sprite:Play("Wiggle", true)
						sfx:Play(SoundEffect.SOUND_COIN_SLOT)
					end
				end
			end
	
			for _, explosion in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)) do
				local radius = (explosion.SpriteScale.X + explosion.SpriteScale.Y)/2
				if slot.HitPoints>0 and explosion.Position:Distance(slot.Position)*radius <= 70 then
					slot.HitPoints = 0

					local roll = rng:RandomFloat()
					
					local bonus = 0
					if data.Player and data.Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
						bonus = 0.15
					end

					if (roll < 0.15 + bonus) and data.Ended then
						local item = 0
						if rng:RandomFloat() < 0.5 then
							item = mod:random_elem(mod.Items)
						else
							item = mod:GetAstralCollectible()
						end
						local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, slot.Position, Vector.Zero, nil)

					elseif (roll < 0.65 + bonus) and data.Ended  then
						local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod:random_elem(mod.telescopeTrinkets), slot.Position, (slot.Position - explosion.Position):Normalized()*6, nil)
					
					end
				end
			end

		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if mod.ModFlags.IsThereTelescope then
		for _, slot in ipairs(mod:FindByTypeMod(mod.Entity.Telescope)) do
			mod:TelescopeUpdate(slot)
		end
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()

	if game:GetRoom():IsFirstVisit() then
		for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, 3)) do
			if rng:RandomFloat() < mod:TelescopeChance() then
				local telescope = mod:SpawnEntity(mod.Entity.Telescope, slot.Position, Vector.Zero, nil)
				slot:Remove()
			end
		end
	end


	mod.ModFlags.IsThereTelescope = false
	if #mod:FindByTypeMod(mod.Entity.Telescope) > 0 then
		mod.ModFlags.IsThereTelescope = true
	end
end)

--IETDDATD (dont ask why this exists)-----------------------------------------------------------------------------------------------
function mod:DieInstantly(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.IETDDATD].VAR then
		entity:Remove()
	end
end

--mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.DieInstantly, mod.EntityInf[mod.Entity.IETDDATD].ID)


--Hyperion---------------------------------------------------------------------------------------------------------------------------
--Nerfing hyperion (OLD)
--[[mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, _, flags, source, frames)
	if entity.Type == EntityType.ENTITY_PLAYER and source.SpawnerType == EntityType.ENTITY_SUB_HORF and #(Isaac.FindByType(EntityType.SATURN_HC))>0 then
		mod:scheduleForUpdate(function()
			entity:TakeDamage (1,flags, source, frames)
		end, 0, ModCallbacks.MC_POST_UPDATE)
		return false
	end
end)--]]

--Ice turd---------------------------------------------------------------------------------------------------------------------------
function mod:IceTurdUpdate(entity)
	if mod.EntityInf[mod.Entity.IceTurd].VAR == entity.Variant or mod.EntityInf[mod.Entity.Turd].VAR == entity.Variant then
		--Dont freeze the ice duh
		entity:ClearEntityFlags(EntityFlag.FLAG_ICE_FROZEN)
		entity:ClearEntityFlags(EntityFlag.FLAG_ICE)
		entity.Velocity = Vector.Zero

		local data = entity:GetData()
		if not data.Init then
			mod:IceTurdInit(entity)
		end

		if(entity:GetSprite():IsFinished("Appear")) then
			game:ShakeScreen(10);
			sfx:Play(Isaac.GetSoundIdByName("IceCrash"),1);
			mod:SpawnIceCreep(entity.Position, mod.UConst.turdIceSize, entity)
			mod:IceTurdFinishedAppear(entity)
		elseif entity:GetSprite():IsEventTriggered("Crack") then
			sfx:Play(Isaac.GetSoundIdByName("IceCrack"), 1, 2, false, 1)
		end
	end
end
function mod:IceTurdInit(entity)
	entity:GetData().Init = true
	
	entity.CollisionDamage = 0
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

	--Mom's knife cant damage FLAG_NO_TARGET entities (Which is something good, but I dont care), probably not the only item with that side effect
	if not mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
		entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end

	entity:GetSprite():Play("Appear",true)
end
function mod:IceTurdFinishedAppear(entity)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

	--Crash damage
	for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.UConst.turdRadius)) do
		if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Uranus].ID then
			entity_:TakeDamage(mod.UConst.turdDamage, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
		elseif entity_.Type == EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Uranus].ID then
			entity_:TakeDamage(1, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
		end
	end

	--Sprite
	local roomdesc = game:GetLevel():GetCurrentRoomDesc()
	entity:GetSprite():Play("Idle", true)
	if entity.Variant == mod.EntityInf[mod.Entity.IceTurd].VAR then
		entity:GetSprite():SetFrame(mod:RandomInt(0,40))
		entity:GetSprite().PlaybackSpeed = 0.2
	end
	if roomdesc and mod:IsGlassRoom(roomdesc) then
		local reflection = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 0, entity.Position, Vector.Zero, entity)
		local refSprite = reflection:GetSprite()
		refSprite:Load("gfx/entity_IceTurdGlass.anm2", true)
		refSprite:LoadGraphics()
		refSprite:Play("Idle", true)
		entity.Child = reflection
		
		mod:SpawnGlassFracture(entity)
	end

end
function mod:IceTurdDeath(entity)
	if mod.EntityInf[mod.Entity.IceTurd].VAR == entity.Variant or mod.EntityInf[mod.Entity.Turd].VAR == entity.Variant then
		sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
		game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 50, 9)
		for i=0, mod.UConst.nTurdIcicles do
			local angle = i*360/mod.UConst.nTurdIcicles
			--Ring projectiles:
			local hail = mod:SpawnEntity(mod.Entity.Icicle, entity.Position, Vector(1,0):Rotated(angle)*mod.UConst.turdIcicleSpeed, entity):ToProjectile()
			hail:GetData().IsIcicle_HC = true
			--hail:GetSprite().Color = Colors.hailColor
			hail:GetData().iceSize = mod.UConst.turdIcicleIceSize
			hail:GetData().hailTrace = false
			hail:GetData().hailSplash = false

			if entity.Child then entity.Child:Remove() end
			
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.IceTurdDeath, mod.EntityInf[mod.Entity.IceTurd].ID)

function mod:IceTurd2Update(entity)
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()

	entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	if sprite:IsFinished("Idle") then
		sprite:Play("Attack", true)
	elseif sprite:IsFinished("Attack") then
		sprite:Play("Idle", true)
	elseif sprite:IsEventTriggered("Attack") then
		local direction = (target.Position - entity.Position):Normalized()

		local poop = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction * 8, entity):ToProjectile()
		poop:GetSprite().Color = mod.Colors.poop
		poop.Height = -12
	end
end

function mod:IceTurd1Update(entity)
	if entity:GetSprite():IsFinished("Idle") then
		entity:Die()
	end
end

--Ulcers---------------------------------------------------------------------------------------------------------------------------
function mod:UlcersUpdate(entity)
	if mod.EntityInf[mod.Entity.Ulcers].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()

		if sprite:IsPlaying("Attack") and sprite:GetFrame() == 1 and rng:RandomFloat() < 0.67 then
			sprite:Play("Fly",true)
		end

		if sprite:IsEventTriggered("Fireball") then
			local velocity = (target.Position - entity.Position):Normalized()*mod.VConst.blazeSpeedSlow*(0.3 + 0.6*rng:RandomFloat())
			local fireball = mod:SpawnEntity(mod.Entity.Fireball, entity.Position, velocity, entity):ToProjectile()

			fireball:GetData().IsFireball_HC = true
			fireball:GetSprite().Scale = Vector(1,1)*0.75
			
			fireball.FallingSpeed = -10
			fireball.FallingAccel = 1.5
			
			fireball:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
			
        	sfx:Play(Isaac.GetSoundIdByName("FireballBit"),1)
		end
	end
end

--Candles---------------------------------------------------------------------------------------------------------------------------
mod.CandleGirs = {
	[1] = mod.Entity.CandleSiren,
	[2] = mod.Entity.CandleGurdy,
	[3] = mod.Entity.CandleColostomia,
	[4] = mod.Entity.CandleMist
}

--States and matrix
mod.SirenMSTATE = {
	APPEAR = 0,
	SING = 1,
	ANNOYED = 2,
	AMBUSH = 3
}
mod.chainSiren = {          
	[mod.SirenMSTATE.APPEAR] = 	{0,  1,  0,  0},
	[mod.SirenMSTATE.SING] = 	{0,  1,  0,  0},
	[mod.SirenMSTATE.ANNOYED] = {0,  0,  0,  1},--This last two does nothing, I know why they do nothing, I just dont care anymore
	[mod.SirenMSTATE.AMBUSH] = 	{0,  1,  0,  0}
}

mod.GurdyMSTATE = {
	APPEAR = 0,
	TAUNT = 1,
	SUMMON = 2
}
mod.chainGurdy = {          
	[mod.GurdyMSTATE.APPEAR] = 	{0,  1,   0},
	[mod.GurdyMSTATE.TAUNT] = 	{0,  0.60,0.40},
	[mod.GurdyMSTATE.SUMMON] = 	{0,  1,   0}
}

mod.ColostomiaMSTATE = {
	APPEAR = 0,
	IDLE = 1,
	JUMP = 2,
	BOMB = 3
}
mod.chainColostomia = {          
	[mod.ColostomiaMSTATE.APPEAR] = {0,  1,    0,    0},
	[mod.ColostomiaMSTATE.IDLE] = 	{0,  0.6,  0.20, 0.20},
	[mod.ColostomiaMSTATE.JUMP] = 	{0,  1,    0,    0},
	[mod.ColostomiaMSTATE.BOMB] = 	{0,  1,    0,    0}
}

mod.MaidMSTATE = {
	APPEAR = 0,
	IDLE = 1,
	ATTACK = 2
}
mod.chainMaid = {          
	[mod.MaidMSTATE.APPEAR] = 	{0,  1,    0},
	[mod.MaidMSTATE.IDLE] = 	{0,  0.80, 0.20},
	[mod.MaidMSTATE.ATTACK] = 	{0,  1,    0}
}

function mod:CandleUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	local target = entity:GetPlayerTarget()
	local room = game:GetRoom()

	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end

	--Frame
	data.StateFrame = data.StateFrame + 1

	if data.GlowInit == nil and entity.Variant ~= mod.EntityInf[mod.Entity.Candle].VAR then
		data.GlowInit = true
		local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, entity.Position, Vector.Zero, entity):ToEffect()
		glow:FollowParent(entity)
		glow.SpriteScale = Vector.One*1.5
		glow:GetSprite().Color = mod.Colors.fire
	end

	if mod.EntityInf[mod.Entity.Candle].VAR == entity.Variant then

		if data.Init == nil then
			data.Init = true

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		
			if not mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
				entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			end

			sprite:Play("Appear", true) 
			mod:scheduleForUpdate(function()
			sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1.2,2,false,0.5)
			end, 20)
		end

		entity.Velocity = Vector.Zero

		if sprite:IsFinished("Appear") then 
			sprite:Play("Idle", true) 
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		elseif sprite:IsFinished("IdleLit") then 
			sprite:Play("Transform", true)
		elseif sprite:IsFinished("Transform") then

			
			local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil):ToEffect()
			sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)

			local entity2Transform = mod.CandleGirs[mod:RandomInt(1,#mod.CandleGirs)]
			--Dont spawn Siren if theres a Lilith or there are no familiars
			if mod:IsThereLilith() or (#Isaac.FindByType(EntityType.ENTITY_FAMILIAR)==0) then
				entity2Transform = mod.CandleGirs[mod:RandomInt(2,#mod.CandleGirs)]
			end
			
			local candleGirl = mod:SpawnEntity(entity2Transform, entity.Position, Vector.Zero, entity.Parent)
			candleGirl.Parent = entity.Parent

			entity:Remove()
		end
		
	elseif mod.EntityInf[mod.Entity.CandleSiren].VAR == entity.Variant then
		if data.SirenResummonCount == nil then data.SirenResummonCount = 0 end
		sfx:Stop (SoundEffect.SOUND_SIREN_SING_STAB)

		if data.State == mod.SirenMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.SirenMSTATE.SING then
			if data.StateFrame == 1 then
				sprite:Play("SingStart",true)
				for i=1, mod.VConst.sirenSummons do
					local sirenRag = mod:SpawnEntity(mod.Entity.SirenRag, entity.Position, Vector.Zero, entity)
					sirenRag.Parent = entity
					mod:SirenRagSprite(sirenRag)
				end

			elseif sprite:IsFinished("SingStart") then
				sprite:Play("SingLoop",true)

			elseif sprite:IsFinished("SingLoop") then
				local sirenRags = mod:FindByTypeMod(mod.Entity.SirenRag)
				if #(sirenRags)>0 then
					sprite:Play("SingLoop",true)
					data.SirenResummonCount = data.SirenResummonCount + 1
				else
					sprite:Play("SingEnd",true)
				end

			elseif sprite:IsFinished("SingEnd") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
				
			elseif sprite:IsEventTriggered("Sing") then
				sfx:Play(SoundEffect.SOUND_SIREN_SING)

			end

			--Movement
			if entity.Parent then
				local parent = entity.Parent
				--idleTime == frames moving in the same direction
				if not data.idleTime then 
					data.idleTime = mod:RandomInt(mod.VConst.idleTimeInterval.X, mod.VConst.idleTimeInterval.Y)

					if parent.Position:Distance(entity.Position) < 100 then
						data.targetvelocity = (-(parent.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-45, 45))
					else
						data.targetvelocity = ((parent.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
					end
				end
				
				--If run out of idle time
				if data.idleTime <= 0 and data.idleTime ~= nil then
					data.idleTime = nil
				else
					data.idleTime = data.idleTime - 1
				end
				
				--Do the actual movement
				entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * 1.2
				data.targetvelocity = data.targetvelocity * 0.99
			end

		elseif data.State == mod.SirenMSTATE.ANNOYED then
			if data.StateFrame == 1 then
				sprite:Play("Teleport",true)
				entity.Velocity = Vector.Zero
				entity.CollisionDamage = 0
			elseif sprite:IsFinished("Teleport") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
			end

		elseif data.State == mod.SirenMSTATE.AMBUSH then
			if data.StateFrame == 1 then
				sprite:Play("Revive",true)
				entity.Velocity = Vector.Zero
				entity.Position = target.Position
			elseif sprite:IsFinished("Revive") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
			
			elseif sprite:IsEventTriggered("Reappear") then
				entity.CollisionDamage = 1

			end

		end

	elseif mod.EntityInf[mod.Entity.CandleGurdy].VAR == entity.Variant then
		entity.Velocity = Vector.Zero
		if data.State == mod.GurdyMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
				entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
				entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainGurdy)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.GurdyMSTATE.TAUNT then
			if data.StateFrame == 1 then
				sprite:Play("Idle"..tostring(mod:RandomInt(1,3)),true)

				if tostring(mod:RandomInt(2,3)) == 2 then
					sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,0.8,2,false,2)
				else
					sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_4,0.8,2,false,2)
				end
				
			elseif sprite:IsFinished("Idle1") or sprite:IsFinished("Idle2") or sprite:IsFinished("Idle3") then
				data.State = mod:MarkovTransition(data.State, mod.chainGurdy)
				data.StateFrame = 0
				
			end
			
		elseif data.State == mod.GurdyMSTATE.SUMMON then
			if data.StateFrame == 1 then
				sprite:Play("Attack"..tostring(mod:RandomInt(1,3)),true)
			elseif sprite:IsFinished("Attack1") or sprite:IsFinished("Attack2") or sprite:IsFinished("Attack3") then
				data.State = mod:MarkovTransition(data.State, mod.chainGurdy)
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("Summon") then
				if #mod:FindByTypeMod(mod.Entity.Ulcers) < 4 then
					local butter = mod:SpawnEntity(mod.Entity.Ulcers, entity.Position, Vector.Zero, entity)
					sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
				end
				
			end

		end
	elseif mod.EntityInf[mod.Entity.CandleColostomia].VAR == entity.Variant then
		if data.State == mod.ColostomiaMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.ColostomiaMSTATE.IDLE then

			entity.Velocity = entity.Velocity / 2

			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0
				
			end
			
		elseif data.State == mod.ColostomiaMSTATE.JUMP then
			if data.StateFrame == 1 then
				sprite:Play("Jump",true)
			elseif sprite:IsFinished("Jump") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("Land") then
				game:ShakeScreen(10)
				entity.Velocity = Vector.Zero

			elseif sprite:IsEventTriggered("Jump") then
				local direction = entity.Parent.Position - entity.Position
				local velocity = direction:Normalized()*mod.VConst.coloJumpSpeed
				entity.Velocity = velocity
				
				sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,2,false,0.5)
				
			end
			
		elseif data.State == mod.ColostomiaMSTATE.BOMB then
			if data.StateFrame == 1 then
				
				if target.Position.X - entity.Position.X > 0 then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end

				sprite:Play("Attack",true)
			elseif sprite:IsFinished("Attack") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0
				
			elseif sprite:IsEventTriggered("Bomb") then
				
				if target.Position.X - entity.Position.X > 0 then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end
				
				local target_pos = target.Position - entity.Position
				local velocity = target_pos:Normalized()*15

				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_BUTT, 0, entity.Position + velocity, velocity, entity):ToBomb()
				bomb:GetSprite().Color = mod.Colors.buttFire
				bomb:SetExplosionCountdown(mod.VConst.colostomiaBombTime)
				bomb:AddTearFlags(TearFlags.TEAR_BURN)
				
				sfx:Play(SoundEffect.SOUND_FART,1)
			end

		end
	elseif mod.EntityInf[mod.Entity.CandleMist].VAR == entity.Variant then
		if data.State == mod.MaidMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.MaidMSTATE.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0
				
			end

			--Movement
			if entity.Parent then
				local parent = entity.Parent
				--idleTime == frames moving in the same direction
				if not data.idleTime then 
					data.idleTime = mod:RandomInt(mod.VConst.idleTimeInterval.X, mod.VConst.idleTimeInterval.Y)

					if parent.Position:Distance(entity.Position) < 75 then
						data.targetvelocity = (-(parent.Position - entity.Position):Normalized()*3):Rotated(mod:RandomInt(-45, 45))
					else
						data.targetvelocity = ((parent.Position - entity.Position):Normalized()):Rotated(mod:RandomInt(-10, 10))
					end
				end
				
				--If run out of idle time
				if data.idleTime <= 0 and data.idleTime ~= nil then
					data.idleTime = nil
				else
					data.idleTime = data.idleTime - 1
				end
				
				--Do the actual movement
				entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * 1.2
				data.targetvelocity = data.targetvelocity * 0.99
			end
			
		elseif data.State == mod.MaidMSTATE.ATTACK then
			if data.StateFrame == 1 then
				if target.Position.X - entity.Position.X > 0 then
					sprite:Play("AttackR",true)
				else
					sprite:Play("AttackL",true)
				end
			elseif sprite:IsFinished("AttackL") or sprite:IsFinished("AttackR") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("Attack") then

				local direction = (data.TargetPos - entity.Position):Normalized()
				local velocity = direction*mod.VConst.flameSpeed*1.5
				local number = direction.X
				local sign = number > 0 and 1 or (number == 0 and 0 or -1)
				local flame = mod:SpawnEntity(mod.Entity.Flame, entity.Position + Vector(sign * 10,0), velocity, entity):ToProjectile()
				flame.FallingAccel  = -0.1
				flame.FallingSpeed = 0
				flame.Scale = 2
		
				flame:GetData().IsFlamethrower_HC = true
				flame:GetData().NoGrow = true
				flame:GetData().EmberPos = -20
				
				sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING,1,2,false,1)

			elseif sprite:IsEventTriggered("SetAim") then

				data.TargetPos = target.Position
				
				if data.TargetPos.X - entity.Position.X > 0 then
					sprite:SetAnimation ("AttackR",false)
				else
					sprite:SetAnimation ("AttackL",false)
				end
			end

		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsKiss_HC then
		if collider.Type == mod.EntityInf[mod.Entity.Candle].ID and collider.Variant == mod.EntityInf[mod.Entity.Candle].VAR then
			collider:GetSprite():Play("IdleLit",true)
			collider:GetData().GlowInit = true
			local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, collider.Position, Vector.Zero, collider):ToEffect()
			glow:FollowParent(collider)
			glow.SpriteScale = Vector.One*1.5
			glow:GetSprite().Color = mod.Colors.fire
			collider.Child = glow

			local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector.Zero, nil):ToEffect()
			cloud:GetSprite().Color = mod.Colors.fire
			tear:Remove()
			
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_,entity)
	if entity.Type == mod.EntityInf[mod.Entity.Candle].ID then
		for _, e in ipairs(mod:FindByTypeMod(mod.Entity.SirenRag)) do
			e:Remove()
		end

		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		bloody:GetSprite().Color = mod.Colors.wax
		
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.wax)

		if entity.Child then entity.Child:Die() end
	end
end)

--Siren rag doll (I just tought it was a good name)---------------------------------------------------------------------------------
function mod:SirenRagUpdate(entity)
	if mod.EntityInf[mod.Entity.SirenRag].VAR == entity.Variant and mod.EntityInf[mod.Entity.SirenRag].SUB == entity.SubType  then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		local animName = sprite:GetAnimation()
		
		if data.Init == nil then
			sprite:Play("Attack2BStart", true)
			entity.State = 10
			data.Init = true
			
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod:SirenRagSprite(entity)
			sprite:Play("Attack2BStart")

			
			for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT)) do
				if e.Parent == entity then
					e:Remove()
				end
			end
		end

		
		if entity.Parent then
			entity.Position = entity.Parent.Position
			entity.Velocity = Vector.Zero
		end

		entity.State = 10
	end
end

function mod:SirenRagSprite(entity)
	local sprite = entity:GetSprite()
	sprite.Scale = Vector.Zero
	sprite:ReplaceSpritesheet (0, "gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (1, "gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (2, "gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (3, "gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (4, "gfx/effects/empty.png")
	sprite:LoadGraphics()
end

--Deimos & Phobos-------------------------------------------------------------------------------------------------------------------
function mod:MartiansUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()

    if entity.Variant == mod.EntityInf[mod.Entity.Deimos].VAR and entity.SubType == mod.EntityInf[mod.Entity.Deimos].SUB then
		if sprite:IsEventTriggered("SetAim") and entity.Parent:GetData().State ~= mod.MMSState.AIRSTRIKE and entity.Parent:GetData().State ~= mod.MMSState.LASER and entity.Parent:GetData().State ~= mod.MMSState.CHARGE then
			data.targetAim = target.Position

			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, target.Position, Vector.Zero, entity):ToEffect()
			target.Timeout = 38

			local targetSprite = target:GetSprite()
			targetSprite:ReplaceSpritesheet (0, "gfx/effects/deimos_target.png")
			targetSprite:LoadGraphics()

		elseif sprite:IsEventTriggered("Shot") and data.targetAim then
			local distance = data.targetAim:Distance(entity.Position)
			if distance >= 75 then
				local direction = data.targetAim - entity.Position
				local laser = EntityLaser.ShootAngle(2, entity.Position + Vector(0,-10), direction:GetAngleDegrees(), 1, Vector.Zero, entity)
				data.targetAim = nil
			end
		end

	elseif entity.Variant == mod.EntityInf[mod.Entity.Phobos].VAR and entity.SubType == mod.EntityInf[mod.Entity.Phobos].SUB then
		if sprite:IsEventTriggered("Shot") and entity.Parent:GetData().State ~= mod.MMSState.CHARGE then
            sfx:Play(Isaac.GetSoundIdByName("EnergyShot"),1)

			local targetAim = target.Position - entity.Position
			local velocity = targetAim:Normalized()*mod.MConst.shotSpeed
			local shot =  mod:SpawnMarsShot(entity.Position, velocity, entity, true)

		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_,entity)
	if entity.Type == mod.EntityInf[mod.Entity.Mars].ID then
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13)
		if entity.Variant ~= mod.EntityInf[mod.Entity.Mars].VAR then
			sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 2, false, 1)
		end
	end
end)

--Mercury Bird---------------------------------------------------------------------------------------------------------------------
function mod:BirdUpdate(entity)
	if mod.EntityInf[mod.Entity.MercuryBird].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local parent = entity.Parent
		local data = entity:GetData()

		if parent == nil then entity:Die() end

		if data.Init == nil then
			data.Init = true

			entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)
			entity:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS)
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			sprite:Play("Flying", true)
			sprite:SetFrame(mod:RandomInt(1,10))

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			--entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		end


		if sprite:IsEventTriggered("Shot") then

			if (target.Position - entity.Position):Length() >= 150 then

				local direction = (target.Position - entity.Position):Normalized()

				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction*mod.MRConst.birdShotSpeed, entity):ToProjectile()
				tear:GetSprite().Color = mod.Colors.mercury

			end

		end

		if entity.Velocity.X > 0 then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end

		--Movement--------------
		--idle move taken from 'Alt Death' by hippocrunchy
		--It just basically stays around a something
		
		--idleTime == frames moving in the same direction
		if entity.Parent and entity.Parent:GetData().Regen then
			data.idleTime = 1
			data.targetvelocity = ((parent.Position - entity.Position):Normalized()*10)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		else
			if not data.idleTime then 
				data.idleTime = mod:RandomInt(mod.MRConst.idleBirdTimeInterval.X, mod.MRConst.idleBirdTimeInterval.Y)
				if parent then
					data.targetvelocity = ((parent.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-30, 30))
				end
			end
		end
		
		--If run out of idle time
		if data.idleTime and data.idleTime <= 0 then
			data.idleTime = nil
		else
			data.idleTime = data.idleTime - 1
		end
		
		--Do the actual movement
		entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.MRConst.birdSpeed
		data.targetvelocity = data.targetvelocity * 0.99
		
		end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, entity, collider)
	if entity.Type == mod.EntityInf[mod.Entity.MercuryBird].ID and collider.Type == mod.EntityInf[mod.Entity.Mercury].ID then
		if collider:GetData().Regen then
			entity:Remove()
		end
	end
end)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
	if entity.Type == mod.EntityInf[mod.Entity.MercuryBird].ID then
		if entity.Parent then
			entity.Parent:TakeDamage(amount/3, flags, source, frames)
		end
	end
end)

--Horsemen---------------------------------------------------------------------------------------------------------------------
function mod:HorsemenUpdate(entity)
	if mod.EntityInf[mod.Entity.Horsemen].VAR == entity.Variant or mod.EntityInf[mod.Entity.AltHorsemen].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local parent = entity.Parent
		local data = entity:GetData()

		if mod.EntityInf[mod.Entity.AltHorsemen].VAR == entity.Variant then
			entity.I2 = 1
		else
			entity.I2 = 0
		end

		if entity.I1 == 0 or entity.I1 == nil then --Famine

			if data.Init == nil then
				data.Init = true
	
				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
				sprite:Play("Famine", true)
				sprite:SetFrame(100)
	
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				
				data.Speed = mod.TConst.horsemenSpeed

				entity.CollisionDamage = 0
	
			end
	
	
			if sprite:IsEventTriggered("Attack") then
				local direction = (target.Position - entity.Position):Normalized()

				if entity.I2 == 0 then
					for i=-1, 1 do
						local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction:Rotated(i*mod.TConst.famineShotAngle)*mod.TConst.famineShotSpeed, entity):ToProjectile()
					end
				else
					local waterParams = ProjectileParams()
					waterParams.Variant = ProjectileVariant.PROJECTILE_TEAR
					entity:FireBossProjectiles (5, target.Position + direction*100, 0, waterParams )
				end

				sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0)
			end
			
			if sprite:IsFinished("Famine") then
				entity:Remove()
			end

		elseif entity.I1 == 1 then --Pestilence

				if data.Init == nil then
					data.Init = true
		
					entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
					entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
		
					sprite:Play("Pestilence", true)
					sprite:SetFrame(50)

					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

					data.Speed = mod.TConst.horsemenSpeed
					data.Farting = false
		
					entity.CollisionDamage = 0
				end
		
		
				if sprite:IsEventTriggered("Attack") then
					sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_5)

					data.Speed = mod.TConst.horsemenSpeed*2
					data.Farting = true
				end
				
				if data.Farting then
					if entity.FrameCount % 3 == 0 then
						local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, entity):ToEffect()
						gas.Timeout = mod.TConst.pestilenceGasTime
						
						local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
					end

					if entity.I2 == 1 and entity.FrameCount % 5 == 0 then
						for i=-1,1,2 do
							local velocity = entity.Velocity:Rotated(i*90)/4
							local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity):ToProjectile()
							tear:GetSprite().Color = mod.Colors.boom
							tear.Scale = 1.5
						end
					end
				end

				if sprite:IsFinished("Pestilence") then
					entity:Remove()
				end
		elseif entity.I1 == 2 then --War

			if data.Init == nil then
				data.Init = true
	
				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
				sprite:Play("War", true)
				sprite:SetFrame(24)
	
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

				data.Speed = mod.TConst.horsemenSpeed
				if entity.I2 == 0 then
					data.Speed = data.Speed + 5
				end
	
				entity.CollisionDamage = 0
			end
	
	
			if sprite:IsEventTriggered("Attack") then
				
				sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_4)

				local direction = (target.Position - entity.Position):Normalized()

				if entity.I2 == 0 then
					entity.Velocity = Vector(direction.X, -direction.Y) * data.Speed*2
					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

					local rocket = mod:SpawnEntity(mod.Entity.MarsRocket, entity.Position + direction*100, direction, entity):ToBomb()
					rocket:GetData().IsDirected_HC = true
					rocket:GetData().Direction = direction
					rocket:GetSprite().Rotation = direction:GetAngleDegrees()
				else
					for i=1,3 do
						local velocity = (15 + rng:RandomFloat()*15) * direction * 10
						velocity = velocity:Rotated(mod:RandomInt(-45,45))
						local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, entity.Position, velocity, entity):ToBomb()
						bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						bomb:SetExplosionCountdown(60)

						bomb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/mars_bomb.png")
						bomb:GetSprite():LoadGraphics()
					end	
				end
			end

			if sprite:IsFinished("War") then
				entity:Remove()
			end

		elseif entity.I1 >= 3 then --Death

			if data.Init == nil then
				data.Init = true
	
				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
				sprite:Play("Death", true)
				if entity.I1 == 4 then sprite:Play("Conquest", true) end
				sprite:SetFrame(mod:RandomInt(0,20))
	
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

				data.Speed = mod.TConst.horsemenSpeed + 2
	
			end
	
	
			if sprite:IsEventTriggered("Attack") then
				
				sfx:Play(Isaac.GetSoundIdByName("Slash"), 1, 2, false, 1)

				local sing = 1
				if entity.Position.Y > target.Position.Y then sing = -1 end

				entity.Velocity =  Vector(data.Speed, data.Speed*sing*1.4)
			end

			if sprite:IsFinished("Death") or sprite:IsFinished("Conquest") then
				entity:Remove()
			end
		end
		
		local direction = 1
		if entity.I2 and entity.I2 == 1 then
			direction = -1
		end

		entity.Velocity =  Vector(direction * data.Speed, entity.Velocity.Y)
	end
end

--TarBomb-----------------------------------------------------------------------------------------------------------------------
function mod:TarBombUpdate(entity)
	if mod.EntityInf[mod.Entity.TarBomb].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local parent = entity.Parent
		local data = entity:GetData()

		if data.Init == nil then
			data.Init = true

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			sprite:Play("Idle"..tostring(mod:RandomInt(1,3)), true)

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

		end
		
		if sprite:IsFinished("Idle1") or sprite:IsFinished("Idle2") or sprite:IsFinished("Idle3") then
			--Explosion:
			local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
			explode:GetSprite().Color = mod.Colors.tar
			
			--Explosion damage
			for i, e in ipairs(Isaac.FindInRadius(entity.Position, mod.TConst.tarExplosionRadius)) do
				if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
					e:TakeDamage(100, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity.Parent), 0)
				end
			end
			
			--Creep
			local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
			tar.Timeout = 150
			tar:GetSprite().Scale = 3 * Vector(1,1)
			
			--[[Splash of projectiles:
			for i=0, mod.TConst.nTarRingProjectiles do
				--Ring projectiles:
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector(10,0):Rotated(i*360/mod.TConst.nTarRingProjectiles), entity.Parent):ToProjectile()
				tear:GetSprite().Color = mod.Colors.tar
				tear.FallingSpeed = -0.1
				tear.FallingAccel = 0.3
			end
			for i=0, mod.TConst.nTarRndProjectiles do
				--Random projectiles:
				local angle = mod:RandomInt(0, 360)
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector(7,0):Rotated(angle), entity.Parent):ToProjectile()
				tear:GetSprite().Color = mod.Colors.tar
				local randomFall = -1 * mod:RandomInt(1, 500) / 1000
				tear.FallingSpeed = randomFall
				tear.FallingAccel = 0.2
			end]]
			
			for i=1, mod.TConst.nTarBubbles do
				local bubble = mod:SpawnEntity(mod.Entity.Bubble, entity.Position, Vector.Zero, entity)
				bubble:GetData().IsBubble_HC = true
				bubble:GetData().IsTar_HC = true
			end

			
			game:SpawnParticles (entity.Position, EffectVariant.POOP_PARTICLE, 20, 13, mod.Colors.black)
			local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
			bloody:GetSprite().Color = mod.Colors.black

			entity:Remove()
		end

		if entity.FrameCount % 3 == 0 then
			local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
			tar.Timeout = 60
			--tar:GetSprite().Scale = Vector.One
		end
	end
end

--Luna Wisp-----------------------------------------------------------------------------------------------------------------------
function mod:LunaWispUpdate(entity)
	if entity.Parent then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity.Parent:ToNPC():GetPlayerTarget()

		if sprite:IsFinished("Idle") then
			local targetAim = (target.Position - entity.Parent.Position):Normalized()
			local velocity = targetAim*mod.LConst.wispShotSpeed
			local shot =  Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity.Parent):ToProjectile()
			sprite:Play("Idle", true)

			shot:GetSprite().Color = mod.Colors.redlight
			shot.Scale = shot.Scale/3
		end
	else
		entity:Remove()
	end

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_,entity)
	if entity.Type == mod.EntityInf[mod.Entity.LunaWisp].ID and entity.Variant == mod.EntityInf[mod.Entity.LunaWisp].VAR then
		sfx:Play(SoundEffect.SOUND_STEAM_HALFSEC,1)
	end
end)

--Luna Knife-----------------------------------------------------------------------------------------------------------------------
function mod:LunaKnifeUpdate(entity)
	if not entity.Parent then
		entity:Remove()
	end
	local parent = entity.Parent:ToNPC()
	local target = parent:GetPlayerTarget()

	local data = entity:GetData()

	if not data.Init then
		data.Init = true
		data.ColClass = entity.EntityCollisionClass
	end
	if not parent.Visible then
		entity.Visible = false
		entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	else
		entity.Visible = true
		entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
		entity.EntityCollisionClass = data.ColClass or EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	end

	local vector = (target.Position - parent.Position):Normalized()
	local distance = mod.LConst.knifeRange * (1 + math.sin(entity.FrameCount/12))

	local sprite = entity:GetSprite()
	sprite.Rotation = vector:GetAngleDegrees() - 90

	local objective = parent.Position + vector*distance
	entity.Position = mod:Lerp(entity.Position, objective, 0.1)

	entity.Velocity = parent.Velocity

end

--Luna Incubus-----------------------------------------------------------------------------------------------------------------------
function mod:LunaIncubusUpdate(entity)
	if not entity.Parent then
		entity:Remove()
		return
	end
	local parent = entity.Parent:ToNPC()
	local target = parent:GetPlayerTarget()

	local sprite = entity:GetSprite()
	local parentSprite = parent:GetSprite()

	local data = entity:GetData()

	if not data.Init then
		sprite:Play("Float", true)
		data.targetvelocity = Vector.Zero
		data.Init = true
		data.ColClass = entity.EntityCollisionClass
	end
	if not parent.Visible then
		entity.Visible = false
		entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	else
		entity.Visible = true
		entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
		entity.EntityCollisionClass = data.ColClass or EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	end

	if (parentSprite:IsPlaying("NormalAttack") or parentSprite:IsPlaying("NormalLaser") or parentSprite:IsPlaying("LongLaser")) and parentSprite:IsEventTriggered("Attack") then
		mod:LunaSynergy(entity, entity:GetData(), sprite, target, game:GetRoom(), true)
	elseif parentSprite:IsPlaying("NormalLaser") and parentSprite:IsEventTriggered("Aim") and parent:GetData().SecondaryP == mod.LSecondaryPassives.CONTINUUM then
		mod:scheduleForUpdate(function()
			mod:LunaTraceLaser(entity, entity:GetData(), sprite, target, game:GetRoom(), true)
		end, 3)

	elseif parentSprite:IsEventTriggered("Incubus1") then
		sprite:Play("FloatShoot", true)
	elseif parentSprite:IsEventTriggered("Incubus2") then
		sprite:Play("Float", true)
	elseif parentSprite:IsEventTriggered("Incubus3") then
		sprite:Play("Charge", true)
	elseif sprite:IsFinished("Charge") then
		sprite:Play("FloatCharged", true)
	elseif parentSprite:IsEventTriggered("Incubus4") then
		sprite:Play("Shoot2", true)
	end

	mod:FamiliarParentMovement(entity, 50, 0.1, 10)

end
function mod:FamiliarParentMovement(entity, distance, speed, stopness) --srsl... stopness??
	local parent = entity.Parent

	entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, speed)

    local direction = parent.Position - entity.Position

	if parent.Position:Distance(entity.Position) > distance then
		entity.Velocity = mod:Lerp(entity.Velocity, direction / stopness, speed)
	end
end

--Mini Errants-----------------------------------------------------------------------------------------------------------------------
function mod:MiniErrantsUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()

	if entity.Variant == mod.EntityInf[mod.Entity.Attlerock].VAR and entity.SubType == mod.EntityInf[mod.Entity.Attlerock].SUB then
		if not entity.Parent then
			entity.Velocity = entity.Velocity:Normalized()*mod.QConst.attlerockSpeed

			if entity:CollidesWithGrid() then
				
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1)

				game:ShakeScreen(10)
				game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 6, 3)
			end
		end
	elseif entity.Variant == mod.EntityInf[mod.Entity.WhiteHole].VAR and entity.SubType == mod.EntityInf[mod.Entity.WhiteHole].SUB then

		if not data.Init then
			data.Init = true
			data.Queue = 0
		end

		if entity.Parent then
			local direction = entity.Parent.Position - game:GetRoom():GetCenterPos()
			entity.Position = game:GetRoom():GetCenterPos() - direction
		else
			entity:Remove()
		end

		if sprite:IsEventTriggered("Attack") then

			for i=1, data.Queue do
				local angle = rng:RandomFloat()*360
				local velocity = 5 + rng:RandomFloat()*10

				local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, Vector(1,0):Rotated(angle)*velocity, entity):ToProjectile()
				rock:GetSprite().Color = mod.Colors.hot
				rock:GetData().NoAbsorb = true
				mod:TearFallAfter(rock, 15)
			end
			data.Queue = 0

		elseif sprite:IsFinished("Attack") then
			sprite:Play("Idle", true)
		end

		
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			local dist = player.Position:Distance(entity.Position)
			if dist < 75 then
				local direction = (player.Position - entity.Position)
				player.Velocity = player.Velocity + direction:Length()/75 * direction:Normalized()
			end
		end
		
		for _, t in ipairs(mod.QProjectiles) do
			if t then
				local dist = t.Position:Distance(entity.Position)
				if not t:GetData().NoAbsorb and dist < 100 then
					local direction = (t.Position - entity.Position)
					t.Velocity = t.Velocity + direction:Length()/100 * direction:Normalized()*2
				end
			end
		end
		for _, t in ipairs(mod.QTears) do
			if t then
				local dist = t.Position:Distance(entity.Position)
				if dist < 100 then
					local direction = (t.Position - entity.Position)
					t.Velocity = t.Velocity + direction:Length()/100 * direction:Normalized()*2
				end
			end
		end

	elseif entity.Variant == mod.EntityInf[mod.Entity.HollowsLantern].VAR and entity.SubType == mod.EntityInf[mod.Entity.HollowsLantern].SUB then
		if sprite:IsFinished("Idle") then
			sprite:Play("Attack", true)
		elseif sprite:IsFinished("Attack") then
				sprite:Play("Idle", true)

		elseif sprite:IsEventTriggered("Attack") then
			sfx:Play(Isaac.GetSoundIdByName("HollowMeteor"),2)

			local n = mod:RandomInt(2,5)
			for i=1, n do
				local angle = rng:RandomFloat()*360
				local velocity = 1 + rng:RandomFloat()*2
	
				local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, Vector(1,0):Rotated(angle)*velocity, entity):ToProjectile()
				rock:GetSprite().Color = mod.Colors.hot
				mod:TearFallAfter(rock, 300)
			end
		end
	end
end

--Brable Seed-----------------------------------------------------------------------------------------------------------------------
function mod:BrambleSeedUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()

	if not data.Init then
		data.Init = true
		entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
	end
	if data.Stop then
		entity.Velocity = Vector.Zero
	end

	if sprite:IsFinished("Appear") then
		data.Stop = true
		sprite:Play("Spikes", true)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		sprite.Rotation = 360*rng:RandomFloat()
	elseif sprite:IsFinished("Spikes") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Death", true)
	elseif sprite:IsFinished("Death") then
		entity:Remove()
		
	elseif sprite:IsEventTriggered("Attack") then
		local offset = sprite.Rotation
		for i=1, 5 do
			local angle = offset + i*360/5
			local velocity = Vector(40,0):Rotated(angle)
			
			--Better vanilla monsters was of help here
			local worm = mod:SpawnEntity(mod.Entity.MiniBranbleSeed, entity.Position, velocity, entity)
			worm.Parent = entity
			worm.DepthOffset = entity.DepthOffset - 50
			worm.Mass = 0
			worm:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_DEATH_TRIGGER)
			worm:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			worm.MaxHitPoints = 0

			local cord = mod:SpawnEntity(mod.Entity.BrambleCord, entity.Position, Vector.Zero, entity)
			cord.Parent = worm
			cord.Target = entity
			cord.DepthOffset = worm.DepthOffset - 125
			data.Tonguecord = cord
			cord:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_BLOOD_SPLASH)

		end
	else

	end
end

--Brable Spike-----------------------------------------------------------------------------------------------------------------------
function mod:BrambleSpikeUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()

	if not data.PosX then
		data.PosX = entity.Position.X 
		data.PosY = entity.Position.Y
	end

	if math.abs(entity.Position.Y - data.PosY) > 175 then
		data.Stop = true
	end
	if data.Stop then
		entity.Velocity = Vector.Zero
	else
		entity.Velocity = Vector(0, entity.Velocity.Y)
		entity.Position = Vector(data.PosX, entity.Position.Y)
	end

	if not data.Init then
		data.Init = true
		entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
		entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

		sprite:Play("Idle"..tostring(mod:RandomInt(1,3)))
	end

	if sprite:IsFinished("Idle1") or sprite:IsFinished("Idle2") or sprite:IsFinished("Idle3") then
		entity:Remove()
		
	elseif sprite:IsEventTriggered("Ready") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

	elseif sprite:IsEventTriggered("Push") then
		local direction = 1
		if sprite.FlipY then
			direction = -1
		end
		entity.Velocity = Vector(0, direction * 40)

	elseif sprite:IsEventTriggered("End") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
end


--Fix Position
function mod:FixPosition(entity)
	local data = entity:GetData()
	if data.Position_HC then
		entity.Position = data.Position_HC
		entity.Velocity = Vector.Zero
	end
end
--Selfdestruct
function mod:Selfdestruct(entity)
	local data = entity:GetData()
	if not data.FrameCount then
		data.FrameCount = 0
	end

	if data.MaxFrames and data.FrameCount and (data.FrameCount > data.MaxFrames) then
		if data.Die then
			entity:Die()
		elseif data.NoPoof then
			entity:Remove()
		else
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position + Vector(5,0), Vector.Zero, nil)
			poof.DepthOffset = 100
			entity:Remove()
		end
	end
	data.FrameCount = data.FrameCount + 1
end

--Entity updates
function mod:UpdateEntity(entity, data)
	local id = entity.Type
	local variant = entity.Variant
	local subType = entity.SubType
	local sprite = entity:GetSprite()

	if id == mod.EntityInf[mod.Entity.TarBomb].ID then
		mod:TarBombUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.Horsemen].ID then
		mod:HorsemenUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.MercuryBird].ID then
		mod:BirdUpdate(entity)
	elseif data.IsMartian and variant ~= mod.EntityInf[mod.Entity.Mars].VAR then
		mod:OrbitParent(entity)
		mod:MartiansUpdate(entity)
	elseif id == EntityType.ENTITY_SIREN then
		mod:SirenRagUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.Candle].ID then
		mod:CandleUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.Ulcers].ID then
		mod:UlcersUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.IceTurd].ID then
		mod:IceTurdUpdate(entity)
		if variant == mod.EntityInf[mod.Entity.Turd].VAR then
			mod:IceTurd2Update(entity)
		else
			mod:IceTurd1Update(entity)
		end
	elseif id == mod.EntityInf[mod.Entity.LunaWisp].ID and variant == mod.EntityInf[mod.Entity.LunaWisp].VAR then
		mod:OrbitParent(entity)
		mod:LunaWispUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.LunaKnife].ID and variant == mod.EntityInf[mod.Entity.LunaKnife].VAR then
		mod:LunaKnifeUpdate(entity)
	elseif id == mod.EntityInf[mod.Entity.LunaIncubus].ID and variant == mod.EntityInf[mod.Entity.LunaIncubus].VAR  then
		mod:LunaIncubusUpdate(entity)
	elseif id == EntityType.ENTITY_ATTACKFLY then
		sprite.Color = mod.Colors.red
	elseif id == mod.EntityInf[mod.Entity.Errant].ID then
		if variant == mod.EntityInf[mod.Entity.BrambleSeed].VAR then
			mod:BrambleSeedUpdate(entity)
		elseif variant == mod.EntityInf[mod.Entity.BrambleSpike].VAR then
			mod:BrambleSpikeUpdate(entity)
		else
			mod:MiniErrantsUpdate(entity)
		end
	end

	--other
	if (id == EntityType.ENTITY_CLUTCH and variant == 1)
	or (id == mod.EntityInf[mod.Entity.Attlerock].ID and variant == mod.EntityInf[mod.Entity.Attlerock].VAR and subType == mod.EntityInf[mod.Entity.Attlerock].SUB) 
	or (id == mod.EntityInf[mod.Entity.HollowsLantern].ID and variant == mod.EntityInf[mod.Entity.HollowsLantern].VAR and subType == mod.EntityInf[mod.Entity.HollowsLantern].SUB) then
		mod:OrbitParent(entity)
	end
	if data.FixPosition then
		mod:FixPosition(entity)
	end
	if data.Selfdestruct then
		mod:Selfdestruct(entity)
	end

end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
	local data = entity:GetData()
	if data.HeavensCall then
		mod:UpdateEntity(entity, data)
	end
end)
--EFFECTS---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Snowflake
function mod:SpawnSnowflake(entity, room, speed)
	if not mod.ModConfigs.noSnow then
		if not speed then speed = 1 end
		if rng:RandomFloat() < 0.6 then
			local position = room:GetRandomPosition(0)-Vector(room:GetCenterPos().X*3.1,0)
			position = position + position*(1-2*rng:RandomFloat())/2 + (speed-1)*Vector(speed*160,speed*85)
			local velocity = Vector(10*speed,rng:RandomFloat())
			local snowflake = mod:SpawnEntity(mod.Entity.Snowflake, position, velocity, entity)

			local sprite = snowflake:GetSprite()
			local randomAnim = tostring(mod:RandomInt(1,4))
			sprite:Play("Drop0"..randomAnim,true)
		end
	end
end

--Ice updates-----------------------------------------------------------------------------------------------------------------------
function mod:IceCreep(entity)
	entity:GetSprite().Color = Color(1,1,1,1)
	if entity:GetData().iceCount <= 0 then
		entity:GetData().isIce = false
	else
		entity:GetData().iceCount = entity:GetData().iceCount - 1
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, creep)
	if creep:GetData().isIce then
		mod:IceCreep(creep)
	end
end)

--Tornado---------------------------------------------------------------------------------------------------------------------------
function mod:TornadoUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.Tornado].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if data.Lifespan == nil then data.Lifespan = 12 end
		if data.Height == nil then data.Height = 6 end
		if data.Scale == nil then data.Scale = 0.5 end
		if data.Duped == nil then data.Duped = false end
		if data.OriginalPos == nil then data.OriginalPos = entity.Position end
		if data.Frame == nil then data.Frame = 0 end
		if data.FlagForSpawn == nil then data.FlagForSpawn = false end
		if data.Velocity == nil then data.Velocity = Vector.Zero end

		if not data.Init then
			data.Init = true
			sprite.Scale = Vector(1,1)*data.Scale

			if not data.IsGiants and (game:GetLevel():GetStage()==LevelStage.STAGE4_1 or game:GetLevel():GetStage()==LevelStage.STAGE4_2) then
				
				sprite:ReplaceSpritesheet (0, "gfx/effects/tornado_shiny.png")
				sprite:LoadGraphics()
			end
		end

		if data.FlagForSpawn then
			data.FlagForSpawn = false
			if not data.Duped and data.Height > 0 then
				data.Duped = true
				local tornado = mod:SpawnEntity(mod.Entity.Tornado, data.OriginalPos+Vector(0,-32*data.Scale), Vector.Zero, entity)
				tornado:GetSprite().Color = sprite.Color
				tornado:GetData().Lifespan = data.Lifespan
				tornado:GetData().Height = data.Height - 1
				tornado:GetData().Scale = data.Scale * 1.3
				tornado:GetData().Velocity = data.Velocity
				tornado:GetData().IsGiants = data.IsGiants
				tornado.DepthOffset = entity.DepthOffset + 44
			end
		end

		if sprite:IsFinished("Appear") then
			sprite:Play("Idle",true)
			data.FlagForSpawn = true
		elseif sprite:IsEventTriggered("FastSpawn") and data.FastSpawn then
			data.FlagForSpawn = true
		elseif sprite:IsFinished("Idle") then
			if data.Lifespan > 0 then
				data.Lifespan = data.Lifespan - 1
				sprite:Play("Idle",true)

			else
				sprite:Play("Death",true)
			end
		elseif sprite:IsFinished("Death") then
			entity:Remove()
		end

		--Waving
		local angle = data.Frame/(data.Scale)
		entity.Position = data.OriginalPos + Vector(10*data.Scale,0)*math.sin(angle)
		data.OriginalPos = data.OriginalPos + data.Velocity/2
		data.Frame = data.Frame + 1

		--Rain
		if data.Rain and entity.FrameCount%3==0 then
			for i=0, mod.QConst.nRainDrop/5 do
				local angle = 360*rng:RandomFloat()
				local position = entity.Position + Vector(math.sqrt(mod:RandomInt(0,mod.QConst.rainDropRadius^2)),0):Rotated(angle)
				--Rain projectiles:
				local dropParams = ProjectileParams()
				dropParams.Scale = mod:RandomInt(1,100)/100
				dropParams.FallingAccelModifier = 2
				dropParams.ChangeTimeout = 3
				dropParams.HeightModifier = -mod:RandomInt(380,1200)
				dropParams.Variant = ProjectileVariant.PROJECTILE_TEAR
				dropParams.Color = sprite.Color
				
				if entity.Parent then
					entity.Parent:ToNPC():FireProjectiles(position, Vector.Zero, 0, dropParams)
				end
			end
		end
	end
end

--Airstrike---------------------------------------------------------------------------------------------------------------------------
function mod:AirstrikeUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.MarsTarget].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if data.Init == nil then
			data.Init = true
			sprite:Play("Blink",true)
			sprite:SetFrame(mod:RandomInt(1,90))
			entity.DepthOffset = -100
		end

		if sprite:IsFinished("Blink") then

			local airstrike = mod:SpawnEntity(mod.Entity.MarsAirstrike, entity.Position, Vector.Zero, entity.Parent)

			entity:Remove()
		end

	elseif entity.SubType == mod.EntityInf[mod.Entity.MarsAirstrike].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if sprite:IsFinished("Falling") then

			--Explosion:
			local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
			explosion:GetSprite().Scale = Vector.One*1.5
			--Explosion damage
			for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.MConst.airstrikeExplosionRadius)) do
				if entity_.Type ~= EntityType.ENTITY_PLAYER and not entity_:GetData().IsMartian then
					entity_:TakeDamage(mod.MConst.explosionDamage/2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
				elseif entity_.Type == EntityType.ENTITY_PLAYER then
					entity_:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
				end
			end

			local fractures = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 0)
			if #fractures >= 8 then
				fractures[1]:Remove()
			end
			local fracture = mod:SpawnGlassFracture(entity, 0.5)
			entity:Remove()
		end

	end
end

--Meteors---------------------------------------------------------------------------------------------------------------------------
function mod:MeteorUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()

	if data.Init == nil then
		data.Init = true

		if rng:RandomFloat() < 0.01 then
			sprite:Play("Type3",true)
		else
			sprite:Play("Type"..tostring(mod:RandomInt(1,2)),true)
		end
	end

	if sprite:IsFinished("Type1") or sprite:IsFinished("Type2") then
		--Explosion:
		local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, nil):ToEffect()
		explosion:GetSprite().Scale = Vector.One*1.5
		explosion:GetSprite().Color = mod.Colors.hot
		--Explosion damage
		for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.TConst.meteorExplosionRadius)) do
			if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
				entity_:TakeDamage(mod.MConst.explosionDamage, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity.Parent), 0)
			elseif entity_.Type == EntityType.ENTITY_PLAYER then
				entity_:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity.Parent), 0)
			end
		end

		for i = 1, 4 do
			local velocity = Vector.FromAngle(i*360/4)*mod.TConst.debbriesSpeed
			local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, velocity, entity.Parent):ToProjectile()
			rock.FallingSpeed = 2
			rock:GetSprite().Color = mod.Colors.hot
		end

		mod:SpawnGlassFracture(entity, 0.5)
		entity:Remove()
		
	elseif sprite:IsFinished("Type3") then
		
		--Explosion:
		local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, nil):ToEffect()
		explosion:GetSprite().Scale = Vector.One*1.5
		explosion:GetSprite().Color = Color(2,0,0,1)
		--Impact damage
		for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.TConst.meteorExplosionRadius)) do
			if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
				entity_:TakeDamage(mod.MConst.explosionDamage, DamageFlag.DAMAGE_CRUSH, EntityRef(entity.Parent), 0)
			elseif entity_.Type == EntityType.ENTITY_PLAYER then
				entity_:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity.Parent), 0)
			end
		end

		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
		creep.SpriteScale = Vector.One*3
		creep:SetTimeout(45)

		for i=1, mod:RandomInt(2,3) do
			local leech = Isaac.Spawn(EntityType.ENTITY_SMALL_LEECH, 0, 0, entity.Position, RandomVector()*50, entity.Parent)
		end

		entity:Remove()
	end

end

--Rockblast---------------------------------------------------------------------------------------------------------------------------
function mod:RockblastUpdate(entity)
	local data = entity:GetData()
	if data.IsActive_HC and entity:GetSprite():GetFrame() == 1 then
		local position = entity.Position + data.Direction * 50

		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, position, Vector.Zero, entity):ToEffect()
		creep.Timeout = 30
		creep.SpriteScale = Vector.One * 2


	elseif data.IsActive_HC and entity:GetSprite():GetFrame() == 3 then
		local position = entity.Position + data.Direction * 40
		if not mod:IsOutsideRoom(position, game:GetRoom()) then
			local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ROCK_EXPLOSION, 0, position, Vector.Zero, entity):ToEffect()
			local rockData = rock:GetData()
			rockData.Direction = data.Direction:Rotated(mod.TConst.blastAngle * 2 * rng:RandomFloat() - mod.TConst.blastAngle)
			rockData.IsActive_HC = true
			rockData.HeavensCall = true

			local fracture = mod:SpawnGlassFracture(entity, 0.5)
			if fracture then fracture.Position = position end
			
            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 2, false, 1)
		end
		--Damage
		for i, e in ipairs(Isaac.FindInRadius(entity.Position, 30)) do
			if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
				e:TakeDamage(50, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
			elseif e.Type == EntityType.ENTITY_PLAYER then
					e:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
			end
		end
		data.IsActive_HC = false
	end
end

--Horn---------------------------------------------------------------------------------------------------------------------------
function mod:HornUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()

	if sprite:IsFinished("Idle") then
		
        sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 4, 2, false, 1)

		for i=1, mod.MRConst.nHornDivisions do
			local angle = 360 * rng:RandomFloat()
			local speed = Vector.FromAngle(angle) *  ( mod.MRConst.bismuthSpeed * rng:RandomFloat() + 2 )
			local shot = mod:SpawnEntity(mod.Entity.Bismuth, entity.Position, speed, entity.Parent):ToProjectile()
			shot.FallingSpeed = -20;
			shot.FallingAccel = 1.5;
			shot.Parent = entity.Parent
			shot:GetData().IsBismuth_HC = true
		end

		entity:Remove()
	end
end

--Laser sword-------------------------------------------------------------------------------------------------------------------------
function mod:LaserSwordSpin(entity)
	local sprite = entity:GetSprite()

	local distance = 70
	local center1 = Vector(0, distance)
	local center2 = Vector(0, distance)

	if sprite:IsEventTriggered("Hit1") then
		center1 = entity.Position + center1:Rotated(0)
		center2 = entity.Position + center2:Rotated(45)
	elseif sprite:IsEventTriggered("Hit2") then
		center1 = entity.Position + center1:Rotated(90)
		center2 = entity.Position + center2:Rotated(90+45)
	elseif sprite:IsEventTriggered("Hit3") then
		center1 = entity.Position + center1:Rotated(180)
		center2 = entity.Position + center2:Rotated(180+45)
	elseif sprite:IsEventTriggered("Hit4") then
		center1 = entity.Position + center1:Rotated(270)
		center2 = entity.Position + center2:Rotated(270+45)
	end

	mod:LaserSwordDamage(entity,center1)
	mod:LaserSwordDamage(entity,center2)
end
function mod:LaserSwordAttack(entity)
	local sprite = entity:GetSprite()

	local center_ = Vector(71,0)
	local center = nil
	local angle = sprite.Rotation + 90
	
	if sprite:IsEventTriggered("Hit1") then
		center = entity.Position + center_:Rotated(angle-30)
	elseif sprite:IsEventTriggered("Hit2") then
		center = entity.Position + center_:Rotated(angle)
	elseif sprite:IsEventTriggered("Hit3") then
		center = entity.Position + center_:Rotated(angle+30)
	end

	mod:LaserSwordDamage(entity,center)
end
function mod:LaserSwordUpdate(entity)
	local sprite = entity:GetSprite()

	if sprite:IsPlaying("Spin") then
		mod:LaserSwordSpin(entity)
	elseif sprite:IsPlaying("AttackCW") or sprite:IsPlaying("AttackCCW") then
		mod:LaserSwordAttack(entity)
	end

	if not entity.Parent then
		entity:Remove()
	end

end

function mod:LaserSwordDamage(entity,center)
	if center then
		--Damage
		for i, e in ipairs(Isaac.FindInRadius(center, mod.MConst.laserSwordRadius)) do
			if e.Type ~= EntityType.ENTITY_PLAYER and not e:GetData().IsMartian then
				if e:GetData().IsKuiper then
					e:TakeDamage(10, 0, EntityRef(entity.Parent), 0)
				elseif e.Type == mod.EntityInf[mod.Entity.Charon2].ID then
					e.Velocity = (e.Position - entity.Position):Normalized()*15
				else
					e:TakeDamage(50, 0, EntityRef(entity.Parent), 0)
				end
			elseif e.Type == EntityType.ENTITY_PLAYER then
				e:TakeDamage(1, 0, EntityRef(entity.Parent), 0)
			end
			
			if e.Type == EntityType.ENTITY_TEAR then

				local projectile = nil
				if e.Variant == TearVariant.CHAOS_CARD then
					projectile = mod:SpawnEntity(mod.Entity.ChaosCard, e.Position, e.Velocity, entity.Parent):ToProjectile()
					projectile:GetData().IsChaos_HC = true
					projectile:GetSprite():Play("Rotate",true)
					projectile:AddProjectileFlags(ProjectileFlags.EXPLODE)
				else
					projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, e.Position, e.Velocity, entity.Parent):ToProjectile()
				end

				projectile.Velocity = -e.Velocity*1.5
				if e.Height then projectile.Height = e.Height end
				if e.FallingAcceleration then projectile.FallingAccel = e.FallingAcceleration end
				if e.FallingSpeed then projectile.FallingSpeed = e.FallingSpeed end
				
				e:Remove()

				sfx:Play(Isaac.GetSoundIdByName("SaberReflect"), 1, 2, false, 1)

			elseif e.Type == EntityType.ENTITY_BOMB then
				local direction = Vector.FromAngle((center - entity.Position):GetAngleDegrees())
				e.Velocity = 40 * direction

				if e.Variant == BombVariant.BOMB_ROCKET then
					e:GetData().IsDirected_HC = true
					e:GetData().Direction = direction
					if direction.X > 0 then 
						e:GetSprite().FlipX = true 
					end
				end
			end
		end
	end
end

--ICUP-------------------------------------------------------------------------------------------------------------------------------
function mod:ICUPUpdate(entity)
	local sprite = entity:GetSprite()

	if sprite:IsFinished("FlowerStart") then
		sprite:Play("FlowerIdle", true)
	elseif sprite:IsFinished("Idle") then
		entity:Remove()
	end
end

--Luna Doors-------------------------------------------------------------------------------------------------------------------------------
mod.DoorType = {
	NORMAL = 0,
	TREASURE = 1,
	SHOP = 2,
	DEVIL = 3,
	ANGEL = 4,
	TAINTED = 5,
	GLACIAR = 6,
	TOMB = 7,
	LIBRARY = 8,
	SECRET = 9,
	BOSS = 10,
	CURSE = 11,
	ARCADE = 12,
	BEDROOM = 13,
	DICE = 14,
	PLANETARIUM = 15,
	VAULT = 16,
	SACRIFICE = 17,

}

function mod:LunaDoorUpdate(entity)
	local timeDespawn = 50

	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if not data.Frame then data.Frame = 0 end
	data.Frame = data.Frame + 1

	if sprite:IsFinished("Close") then
		entity:Remove()
	elseif sprite:IsFinished("Open") then
		sprite:Play("Opened", true)
	elseif sprite:IsPlaying("Close") and sprite:GetFrame()==1 then
		sfx:Play(SoundEffect.SOUND_DOOR_HEAVY_CLOSE)
	end

	local doorType = data.DoorType

	if doorType == mod.DoorType.NORMAL then
		if entity.Position:Distance(entity.Parent.Position) < 35 or data.Frame == timeDespawn then
			sprite:Play("Close", true)
			
			if entity.Position:Distance(entity.Parent.Position) < 35 then
				local luna = entity.Parent

				luna:GetData().DashFlag = false
				luna:GetData().Height = nil
				luna.Velocity = Vector.Zero

				--Luna teleport
				luna.Visible = false
				luna.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

				mod:scheduleForUpdate(function()

					if luna:GetSprite():IsPlaying("ChargeR") or luna:GetSprite():IsPlaying("ChargeL") then
						luna:GetSprite():Play("TrapdoorOut",true)
					end
					luna.Visible = true
					luna.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				end, 25, ModCallbacks.MC_POST_UPDATE)

				local position = Isaac.GetRandomPosition(0)
				while entity.Parent and position:Distance(entity.Parent:ToNPC():GetPlayerTarget().Position) < mod.LConst.minDistanceToReappear and entity.Position:Distance(entity.Parent.Position) > 35 do
					position = Isaac.GetRandomPosition(0)
				end
				luna.Position = position

				mod:scheduleForUpdate(function()
					local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, position, Vector.Zero, luna)
					trapdoor:GetSprite():Play("BigIdle", true)
				end, 15, ModCallbacks.MC_POST_UPDATE)
			end
		end

	elseif doorType == mod.DoorType.TREASURE or doorType == mod.DoorType.DEVIL or doorType == mod.DoorType.ANGEL or doorType == mod.DoorType.TAINTED or
	doorType == mod.DoorType.LIBRARY or doorType == mod.DoorType.SECRET then
		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.SHOP then
		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.GLACIAR then
		if data.Frame == 30 then
			if REVEL then
				local chillwisp = Isaac.Spawn(Isaac.GetEntityTypeByName("Chill O' Wisp"), Isaac.GetEntityVariantByName("Chill O' Wisp"), 0, entity.Position + Vector(0,10), Vector.Zero, nil)
				chillwisp:GetData().HeavensCall = true
				chillwisp:GetData().Selfdestruct = true
				chillwisp:GetData().Die = true
				chillwisp:GetData().MaxFrames = 30*15
			end
		elseif data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.TOMB then
		
		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.BOSS then
		if data.Frame == 20 then
			local random = mod:RandomInt(1,4)

			sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
			local boss
			if random == 1 then
				boss = Isaac.Spawn(EntityType.ENTITY_MONSTRO, 0, 0, entity.Position + Vector(0,10), Vector.Zero, nil)
			elseif random == 2 then
				boss = Isaac.Spawn(EntityType.ENTITY_DUKE, 0, 0, entity.Position + Vector(0,10), Vector.Zero, nil)
			elseif random == 3 then
				boss = Isaac.Spawn(EntityType.ENTITY_GEMINI, 0, 0, entity.Position + Vector(0,10), Vector.Zero, nil)
			elseif random == 4 then
				local boss1 = Isaac.Spawn(EntityType.ENTITY_LARRYJR, 0, 0, entity.Position + Vector(0,10), Vector.Zero, nil)
				for i=1,6 do
					local boss2 = Isaac.Spawn(EntityType.ENTITY_LARRYJR, 0, 0, entity.Position + Vector(0,10), Vector.Zero, nil)
					boss2.Parent = boss1
					boss1.Child = boss2

					boss1 = boss2
				end
			end

			if boss then
				boss.MaxHitPoints = 125
				boss.HitPoints = 125
			end

		elseif data.Frame == 45 then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.CURSE then

		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player.Position:Distance(entity.Position) < 30 then 
				player:TakeDamage(2, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(entity.Parent), 0)
			end
		end

		if data.Frame == timeDespawn or (entity.Velocity:Length() <= 0.1 and data.Launched) then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.ARCADE then

		if data.Frame == timeDespawn/2 then
			local card = mod:SpawnEntity(mod.Entity.Card, entity.Position, Vector.Zero, entity.Parent)
			card.Parent = entity.Parent
		elseif data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.BEDROOM then

		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.DICE then
		
		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.PLANETARIUM then

		if data.Frame == 1 then
			local random = mod:RandomInt(1,4)

			local boss
			if random == 1 then
				boss = mod:SpawnEntity(mod.Entity.Pluto, entity.Position + Vector(0,1), Vector.Zero, nil)
			elseif random == 2 then
				boss = mod:SpawnEntity(mod.Entity.Eris, entity.Position + Vector(0,1), Vector.Zero, nil)
			elseif random == 3 then
				boss = mod:SpawnEntity(mod.Entity.Haumea, entity.Position + Vector(0,1), Vector.Zero, nil)
			elseif random == 4 then
				boss = mod:SpawnEntity(mod.Entity.Makemake, entity.Position + Vector(0,1), Vector.Zero, nil)
			end
			boss:GetData().NoTrapdoor = true
			boss:GetData().LunaSummon = true
			boss.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			mod:scheduleForUpdate(function()
				if boss then
					sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
					local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position + Vector(5,0), Vector.Zero, nil)
					poof.DepthOffset = 100
					boss.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

					boss.Position = entity.Position
					boss.HitPoints = 80
					boss.MaxHitPoints = 80

					if boss.Child then
						boss.Child.Visible = true
					end
				end
			end,30)

		elseif data.Frame == 45 then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.VAULT then
		
		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	elseif doorType == mod.DoorType.SACRIFICE then
		
		if data.Frame == timeDespawn then
			sprite:Play("Close", true)
		end

	end

end

function mod:SpawnLunaDoor(entity, doorType, position)
	if not position then
		position = entity.Position + Vector(50, 0):Rotated(rng:RandomFloat()*360)
		for i=0, 100 do
			if (not mod:IsOutsideRoom(position, game:GetRoom())) then break end
			position = entity.Position + Vector(50, 0):Rotated(rng:RandomFloat()*360)
		end
	end

	local door = mod:SpawnEntity(mod.Entity.LunaDoor, position, Vector.Zero, entity):ToEffect()
	local sprite = door:GetSprite()

	local dir = "gfx/grid/door_00_reddoor.png"

	if doorType == mod.DoorType.NORMAL then
		dir = "gfx/grid/door_00_reddoor.png"
	elseif doorType == mod.DoorType.TREASURE then
		dir = "gfx/grid/door_02_treasureroomdoor.png"
	elseif doorType == mod.DoorType.SHOP then
		dir = "gfx/grid/door_00_shopdoor.png"
	elseif doorType == mod.DoorType.DEVIL then
		sprite:Load("gfx/grid/door_07_devilroomdoor.anm2")
		dir = nil
	elseif doorType == mod.DoorType.ANGEL then
		sprite:Load("gfx/grid/door_07_holyroomdoor.anm2")
		dir = nil
	elseif doorType == mod.DoorType.TAINTED then
		dir = "gfx/grid/taintedtreasureroomdoor.png"
	elseif doorType == mod.DoorType.GLACIAR then
		dir = "gfx/grid/revel1/doors/glacier.png"
	elseif doorType == mod.DoorType.TOMB then
		dir = "gfx/grid/revel2/doors/tomb.png"
	elseif doorType == mod.DoorType.LIBRARY then
		dir = "gfx/grid/door_13_librarydoor.png"
	elseif doorType == mod.DoorType.SECRET then
		dir = "gfx/grid/secreroomdoor.png"
	elseif doorType == mod.DoorType.BOSS then
		sprite:Load("gfx/grid/door_10_bossroomdoor.anm2")
		dir = nil
	elseif doorType == mod.DoorType.CURSE then
		dir = "gfx/grid/door_04_selfsacrificeroomdoor.png"
	elseif doorType == mod.DoorType.ARCADE then
		dir = "gfx/grid/door_05_arcaderoomdoor.png"
	elseif doorType == mod.DoorType.BEDROOM then
		dir = "gfx/grid/door_01_normaldoor.png"
	elseif doorType == mod.DoorType.DICE then
		dir = "gfx/grid/door_00_diceroomdoor.png"
	elseif doorType == mod.DoorType.PLANETARIUM then
		dir = "gfx/grid/door_00x_planetariumdoor.png"
	elseif doorType == mod.DoorType.VAULT then
		dir = "gfx/grid/door_02b_chestroomdoor.png"
	elseif doorType == mod.DoorType.SACRIFICE then
		dir = "gfx/grid/door_00_sacrificeroomdoor.png"
	end

	if dir then
		for i=0,3 do
			sprite:ReplaceSpritesheet (i, dir)
		end
	end
	sprite:LoadGraphics()

	door:GetData().DoorType = doorType
	door.Parent = entity
	entity.Child = door

	sfx:Play(SoundEffect.SOUND_UNLOCK00,1)

	sprite:Play("Open", true)
	return door

end

function mod:LunaMegaSatanDoorUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if not data.Frame then 
		data.Frame = 0
		sfx:Play(SoundEffect.SOUND_SATAN_BLAST)
	 end
	data.Frame = data.Frame + 1

	if sprite:IsFinished("Open") and entity.Parent then
		sprite:Play("Opened", true)

		local angle = -90
		if (entity.Position.Y < game:GetRoom():GetCenterPos().Y) then
			angle = 90
		end

		local laser = EntityLaser.ShootAngle(LaserVariant.GIANT_RED, entity.Position, angle, 55, Vector.Zero, entity.Parent):ToLaser()
		laser:AddTearFlags(TearFlags.TEAR_SPECTRAL)
		laser.DepthOffset = 10
		laser.DisableFollowParent = true

	elseif sprite:IsFinished("Close") then
		entity:Remove()
	elseif data.Frame == 140 then
		sprite:Play("Close", true)
	end

end

--Card Show Luna--------------------------------------------------------------------------------------------------------------------
function mod:CardShowUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if not data.Init then
		data.Init = true
		local random = mod:RandomInt(1,4)
		if random==1 then
			sprite:Play("Heart", true)
		elseif random==2 then
			sprite:Play("Key", true)
		elseif random==3 then
			sprite:Play("Bomb", true)
		else
			sprite:Play("Coin", true)
		end

		entity.Parent = entity.SpawnerEntity
	end
	
	if sprite:IsFinished("Heart") then
		for i=1, mod.LConst.nCoins do
			local offset = Vector(rng:RandomFloat()*20, 0):Rotated(rng:RandomFloat()*360)
			local coin = Isaac.Spawn(EntityType.ENTITY_ULTRA_COIN, 3, 0, entity.Position + offset, offset/5, entity.Parent)
			coin.Parent = entity.Parent

			coin.MaxHitPoints = 35
			coin.HitPoints = 35
			coin:GetData().HeavensCall = true
		end
		entity:Remove()
	elseif sprite:IsFinished("Key") then
		local room = game:GetRoom()
		local randomPos = (room:GetRandomPosition(0) - room:GetCenterPos())*0.9 + room:GetCenterPos()

		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, randomPos + Vector(5,0), Vector.Zero, nil)
		poof.DepthOffset = 100

		local door = mod:SpawnEntity(mod.Entity.GreedDoor, randomPos, Vector.Zero, nil)
		local doorData = door:GetData()

		mod:scheduleForUpdate(function()
			doorData.HeavensCall = true

			doorData.FixPosition = true
			doorData.Position = door.Position
			door.Position = randomPos

			doorData.Selfdestruct = true
			doorData.MaxFrames = 360

			door:GetSprite().Rotation = 0
		end,2)
		
		for i=1, mod.LConst.nCoins do
			local offset = Vector(rng:RandomFloat()*20, 0):Rotated(rng:RandomFloat()*360)
			local coin = Isaac.Spawn(EntityType.ENTITY_ULTRA_COIN, 1, 0, entity.Position + offset, offset/5, entity.Parent)
			coin.Parent = entity.Parent

			coin.MaxHitPoints = 35
			coin.HitPoints = 35
			coin:GetData().HeavensCall = true
		end

		entity:Remove()
	elseif sprite:IsFinished("Bomb") then
		for i=1, mod.LConst.nCoins do
			local offset = Vector(rng:RandomFloat()*20, 0):Rotated(rng:RandomFloat()*360)
			local coin = Isaac.Spawn(EntityType.ENTITY_ULTRA_COIN, 2, 0, entity.Position + offset, offset/5, entity.Parent)
			coin.Parent = entity.Parent

			coin.MaxHitPoints = 35
			coin.HitPoints = 35
		end
		entity:Remove()
	elseif sprite:IsFinished("Coin") then
		for i=1, mod.LConst.nCoins do
			local offset = Vector(rng:RandomFloat()*40, 0):Rotated(rng:RandomFloat()*360)
			local coin = Isaac.Spawn(EntityType.ENTITY_ULTRA_COIN, 0, 0, entity.Position + offset, offset/5, entity.Parent)
			coin.Parent = entity.Parent
			coin.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			
			coin.MaxHitPoints = 35
			coin.HitPoints = 35
		end
		entity:Remove()
	end


end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
	if not entity:GetData().HeavensCall then return end

	if entity:GetSprite():IsPlaying("HeartChange") and entity:GetSprite():GetFrame() == 11 then
		for _, l in ipairs(mod:FindByTypeMod(mod.Entity.Luna)) do
			mod:LunaHeal(l, mod.LConst.healPerSleep)
			entity.TargetPosition = l.Position
			entity.Target = l
		end
	elseif entity:GetSprite():IsPlaying("KeyChange") and entity:GetSprite():GetFrame() == 11 then
		for _, door in ipairs(mod:FindByTypeMod(mod.Entity.GreedDoor)) do
			door:GetSprite():Play("Open", true)

			sfx:Play(SoundEffect.SOUND_UNLOCK00, 1)

			entity.TargetPosition = door.Position
			entity.Target = door
		end
		entity:Die()

	elseif entity.FrameCount > 350 then
		entity:Die()
	end

end, EntityType.ENTITY_ULTRA_COIN)

function mod:LunaGreedDoorUpdate(entity)
	local sprite = entity:GetSprite()

	if sprite:IsFinished("Open") then
		sprite:Play("Opened", true)
	elseif sprite:IsFinished("Opened") then
		sprite:Play("Close", true)
	elseif sprite:IsFinished("Close") then
		entity:Remove()

	elseif sprite:IsEventTriggered("Summon") then
		local gaper = Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, entity.Position, Vector.Zero, nil)
		gaper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		gaper:GetSprite():Play(gaper:GetSprite():GetDefaultAnimation(), true)
	end
end

--Spike Luna--------------------------------------------------------------------------------------------------------------------
function mod:LunaSpikeUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	local tookDamage = false
	entity.DepthOffset = -100
	if sprite:IsEventTriggered("LowDamage") then
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player.Position:Distance(entity.Position) < 20 and not player.CanFly then
				tookDamage = player:TakeDamage(2, 0, EntityRef(entity.Parent), 0)
			end
		end
	elseif sprite:IsEventTriggered("HightDamage") then
		if not data.Flag then
			data.Flag = true
			sfx:Play(SoundEffect.SOUND_TOOTH_AND_NAIL)
		end

		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player.Position:Distance(entity.Position) < 20 then
				tookDamage = player:TakeDamage(2, DamageFlag.DAMAGE_SPIKES, EntityRef(entity.Parent), 0)
			end
		end
	end

	if tookDamage and entity.Parent then
		local spikeHits = mod.ModFlags.SpikeHits + 1
		mod.ModFlags.SpikeHits = spikeHits

		local position = game:GetRoom():GetCenterPos() + Vector(0,30)
		position = Isaac.GetFreeNearPosition(position, 50)

		local random = rng:RandomFloat()
		if spikeHits <= 2 then
			if random < 0.5 then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, position, Vector.Zero, nil)
			end
		elseif spikeHits == 3 then
			if random < 0.666667 then
				game:GetLevel():AddAngelRoomChance(game:GetRoom():GetDevilRoomChance() * 0.15)
			end
		elseif spikeHits == 4 then
			if random < 0.5 then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, position, Vector.Zero, nil)
			end
		elseif spikeHits == 5 then
			if random < 0.666667 then
				game:GetLevel():AddAngelRoomChance(game:GetRoom():GetDevilRoomChance() * 0.5)
			else
				for i=1,3 do
					local position2 = Isaac.GetFreeNearPosition(position, 50)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, position2, Vector.Zero, nil)
				end
			end
		elseif spikeHits == 6 then
			if random < 0.666667 then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, position, Vector.Zero, nil)
			else
				game:GetPlayer(0):UseCard (Card.CARD_JOKER)
			end
		elseif spikeHits == 7 then
			if random < 0.666667 then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, position, Vector.Zero, nil)
			else
				local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, position, Vector.Zero, nil)
			end
		elseif spikeHits == 8 then
			for i=1,6 do
				mod:scheduleForUpdate(function()
					Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, game:GetRoom():GetRandomPosition(0), Vector.Zero, nil)
				end, i*5)
			end
		elseif spikeHits == 9 then
			Isaac.Spawn(EntityType.ENTITY_URIEL, 0,0, position, Vector.Zero, nil)
		elseif spikeHits == 10 then

			if random < 0.5 then
				for i=1,30 do
					local position2 = Isaac.GetFreeNearPosition(position, 50)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, position2, Vector.Zero, nil)
				end
			else
				for i=1,7 do
					local position2 = Isaac.GetFreeNearPosition(position, 50)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, position2, Vector.Zero, nil)
				end
			end
		elseif spikeHits == 11 then
			Isaac.Spawn(EntityType.ENTITY_GABRIEL, 0,0, position, Vector.Zero, nil)
		elseif spikeHits >= 12 then
			if random < 0.5 then
				mod.ModFlags.SpikeHits = 0

				--dark room
				local newlevel = {LevelStage = LevelStage.STAGE6, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false}
				
				game:GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
				game:GetLevel():SetStage(newlevel.LevelStage, newlevel.StageType)
				game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH, newlevel.IsAscent)
				
				game:SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)
				game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, false)
			end
		end
	end

end

--Revelations doors--------------------------------------------------------------------------------------------------------------------
function mod:RevelationsDoorsUpdate(entity)
	local parent = mod.RevelationDoor
	if parent then
		local sprite = entity:GetSprite()
		local parentSprite = parent:GetSprite()

		local animation = parentSprite:GetAnimation()
		sprite:Play(animation, true);
		sprite:SetFrame(parentSprite:GetFrame())

	end
end

--Revelation traps----- srl, It easier to reimplement the trap than to figure out how they work in the mod
function mod:RevelationTrapUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if entity.SubType == mod.EntityInf[mod.Entity.TrapTile].SUB then
		if not data.Init then
			data.Init = true

			entity.DepthOffset = -500
			sprite:Play("Arrow", true)
			sprite:Stop()
			sprite:SetFrame(0)

			local position, rotation = mod:RandomUpDown()
			position = Vector(entity.Position.X, position.Y)
			local trap = mod:SpawnEntity(mod.Entity.Trap, position, Vector.Zero, entity)
			trap:GetSprite().Rotation = rotation

			trap.Parent = entity
			entity.Child = trap
			
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position + Vector(5,0), Vector.Zero, nil)
			poof.DepthOffset = 100
			local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, trap.Position + Vector(5,0), Vector.Zero, nil)
			poof2.DepthOffset = 100
			
		end

		if sprite:GetFrame() == 0 then
			local flag = false

			for i=0, game:GetNumPlayers ()-1 do
				local player = game:GetPlayer(i)
				if player.Position:Distance(entity.Position) <= 20 then 
					flag = true
					break
				end
			end
			if not flag then
				for _, l in ipairs(mod:FindByTypeMod(mod.Entity.Luna)) do
					if l.Position:Distance(entity.Position) <= 20 then 
						flag = true
						break
					end
				end
			end

			if flag and entity.Child then
				sprite:SetFrame(1)
				entity.Child:GetSprite():Play("Shoot", true)
				sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
			end
		end
		
	elseif entity.SubType == mod.EntityInf[mod.Entity.Trap].SUB then
		local parent = entity.Parent
		if not parent then entity:Remove() end

		local arrowProjectilePositionOffset = Vector(0, 17)
		local arrowProjectileDamage = 14
	
		if entity:GetSprite():IsEventTriggered("Shootx3") then
			local t = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position+(Vector.FromAngle(entity:GetSprite().Rotation+90)*3)+arrowProjectilePositionOffset, (Vector.FromAngle(entity:GetSprite().Rotation+90)*10), entity):ToProjectile()
			t:GetData().IsArrowTrapProjectile = true
			local flags = BitOr(ProjectileFlags.HIT_ENEMIES, ProjectileFlags.NO_WALL_COLLIDE)
	
			REVEL.sfx:Play(SoundEffect.SOUND_STONESHOOT, 1, 0, false, 2)
	
			t:AddProjectileFlags(flags)
			t.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			t.FallingSpeed = 0
			t.FallingAccel = -0.09
			t.Height = -20
			t:GetData().ArrowTrapHitGrids = {}
			t.CollisionDamage = arrowProjectileDamage
		end

		if sprite:IsFinished("Shoot") or sprite:IsFinished("ShootOnce") then
			sprite:Play("Idle")

			parent:GetSprite():SetFrame(0)
		end
		
	end
	
end

--Luna red fart-----------------------------------------------------------------------------------------------------------------------
function mod:RedFartUpdate(entity)
	local data = entity:GetData()
	if data.IsActive_HC and entity:GetSprite():GetFrame() == 3 then
		local position = entity.Position + data.Direction * 60

		if not mod:IsOutsideRoom(position, game:GetRoom()) then
			local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 1, position, Vector.Zero, entity):ToEffect()
			explosion:GetSprite().Color = Color(1,0,0,1)
			explosion:GetSprite().PlaybackSpeed = 0.7
			local explosionData = explosion:GetData()
			explosionData.Direction = data.Direction:Rotated(mod.LConst.impactBlastAngle * 2 * rng:RandomFloat() - mod.LConst.impactBlastAngle)
			explosionData.IsActive_HC = true
			explosionData.HeavensCall = true

		end

		sfx:Stop(SoundEffect.SOUND_FART)

		--Damage
		for i, e in ipairs(Isaac.FindInRadius(entity.Position, 40)) do
			if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= mod.EntityInf[mod.Entity.Luna].ID then
				e:TakeDamage(100, DamageFlag.DAMAGE_CRUSH, EntityRef(entity.Parent), 0)
			elseif e.Type == EntityType.ENTITY_PLAYER then
					e:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity.Parent), 0)
			end
		end
		data.IsActive_HC = false
	end
end

--Electric Glow-----------------------------------------------------------------------------------------------------------------------
function mod:ElectricGlowUpdate(entity)
	local data = entity:GetData()
	if data.IsActive_HC and entity.Timeout == mod.QConst.electricityTimeout/2 then
		local position = entity.Position + data.Direction * mod.QConst.electricityDist
		data.NextPosition = position
		if not mod:IsOutsideRoom(position, game:GetRoom()) then
			local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, position, Vector.Zero, entity):ToEffect()
            glow:GetSprite().Color = mod.Colors.red
            glow.Parent = entity.Parent
            glow.Timeout = mod.QConst.electricityTimeout
			glow.SpriteScale = Vector.One*0.5

            local glowData = glow:GetData()
            glowData.Direction = data.Direction:Rotated(mod.QConst.electricityAngle * (2 * rng:RandomFloat() - 1))
            glowData.IsActive_HC = true
            glowData.HeavensCall = true

		end
	elseif data.IsActive_HC and entity.Timeout == 1 and data.NextPosition then
		data.IsActive_HC = false
		--Laser
		local angle = (data.NextPosition - entity.Position):GetAngleDegrees()
		local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, entity.Position, angle, 10, Vector.Zero, entity.Parent)
		laser:SetMaxDistance((data.NextPosition - entity.Position):Length())
		laser.DisableFollowParent = true
		laser:GetSprite().Color = mod.Colors.jupiterLaser2
	end
end

--Luna Anima Sola---------------------------------------------------------------
function mod:LunaAnimaSolaUpdate(effect)
	local data = effect:GetData()
	local sprite = effect:GetSprite()

	if not data.Init then
		data.Init = true
		sfx:Play(SoundEffect.SOUND_DARK_ESAU_OPEN)

	end

	if sprite:IsFinished("Appear") then
		sprite:Play("Idle", true)
	elseif sprite:IsFinished("Idle") then
		if effect.FrameCount < mod.LConst.animaTime then
			sprite:Play("Idle", true)
		else
			sprite:Play("Death", true)
			data.Chain = false

			for i,c in ipairs(mod:FindByTypeMod(mod.Entity.TwinChain)) do
				c:Remove()
			end

			sfx:Play(SoundEffect.SOUND_ANIMA_BREAK)
		end

	elseif sprite:IsFinished("Death") then
		effect:Remove()
		sfx:Play(SoundEffect.SOUND_DARK_ESAU_DEATH_OPEN)

	elseif sprite:IsEventTriggered("Catch") then
		data.Chain = true
		sfx:Play(SoundEffect.SOUND_ANIMA_TRAP)

		for index=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(index):ToPlayer()

			local parent = effect
			for i=1,mod.LConst.chainsL do
				local position = effect.Position + (player.Position - effect.Position)*i/mod.LConst.chainsL

				local chain = mod:SpawnEntity(mod.Entity.TwinChain, effect.Position, Vector.Zero, effect):ToNPC()
				chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				chain:GetSprite():Play("Anima", true)
				chain.CollisionDamage = 0
				chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				parent.Child = chain
				chain.Parent = parent
				chain.I1 = i
				chain.DepthOffset = -15
				
				parent = chain
			end
			
			parent.Child = player
		end
	end

	if data.Chain then
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i):ToPlayer()

			local distance = player.Position:Distance(effect.Position)
			if distance > 100 then
				player.Velocity = mod:Lerp(player.Velocity, (effect.Position-player.Position)/2, 0.005)
			end
		end
	end
end

--SandPillar-----------------------------------------------------------------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, entity)
	if entity.SpawnerEntity and entity.SpawnerEntity.Type == mod.EntityInf[mod.Entity.AshTwin].ID then
		mod:scheduleForUpdate(function()
			if entity then
				entity:GetSprite().Color = mod.Colors.sand
			end
		end, 2)
	end
end, EffectVariant.CREEP_SLIPPERY_BROWN)

--Effects updates
function mod:UpdateEffect(effect, data)
	local variant = effect.Variant
	local subType = effect.SubType
	local sprite = effect:GetSprite()

	if variant == mod.EntityInf[mod.Entity.Meteor].VAR then
		mod:MeteorUpdate(effect)
	elseif variant == EffectVariant.BIG_ROCK_EXPLOSION then
		mod:RockblastUpdate(effect)
	elseif variant == EffectVariant.FART and subType == 1 then
		mod:RedFartUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.TerraTarget].VAR and subType == mod.EntityInf[mod.Entity.TerraTarget].SUB then
		effect.DepthOffset = -50
		if effect.Timeout <= 1 then
			local meteor = mod:SpawnEntity(mod.Entity.Meteor, effect.Position, Vector.Zero, effect.Parent)
			meteor.Parent = effect.Parent

			effect:Remove()
		end
	elseif variant == mod.EntityInf[mod.Entity.MarsTarget].VAR then
		mod:AirstrikeUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.Tornado].VAR then
		mod:TornadoUpdate(effect)
	elseif data.isIce then
		mod:IceCreep(effect)
	elseif variant == mod.EntityInf[mod.Entity.Thunder].VAR and subType == mod.EntityInf[mod.Entity.Thunder].SUB then
		if sprite:IsEventTriggered("Hit") then
			sfx:Play(Isaac.GetSoundIdByName("Thunder"),1)
		end
	elseif variant == mod.EntityInf[mod.Entity.RedTrapdoor].VAR and subType == mod.EntityInf[mod.Entity.RedTrapdoor].SUB then
		if sprite:IsEventTriggered("Sound") then
			sfx:Play(Isaac.GetSoundIdByName("TrapdoorOC"),1)
		elseif sprite:IsFinished("Idle") or sprite:IsFinished("BigIdle") then
			effect:Remove()
		end
	elseif variant == EffectVariant.TECH_DOT then
		if effect.Parent == nil and data.MarsShot_HC then
			effect:Die()
		end
	elseif variant == mod.EntityInf[mod.Entity.LaserSword].VAR then
		mod:LaserSwordUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.Horn].VAR then
		mod:HornUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.ICUP].VAR then
		mod:ICUPUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.LunaDoor].VAR then
		if subType == mod.EntityInf[mod.Entity.LunaDoor].SUB then
			mod:LunaDoorUpdate(effect)
		else
			mod:LunaMegaSatanDoorUpdate(effect)
		end
	elseif variant == mod.EntityInf[mod.Entity.Card].VAR then
		if subType == mod.EntityInf[mod.Entity.Card].SUB then
			mod:CardShowUpdate(effect)
		elseif subType == mod.EntityInf[mod.Entity.GreedDoor].SUB then
			mod:LunaGreedDoorUpdate(effect)
		end
	elseif variant == mod.EntityInf[mod.Entity.Spike].VAR then
		mod:LunaSpikeUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.TrapTile].VAR then
		mod:RevelationTrapUpdate(effect)
	elseif variant == EffectVariant.GROUND_GLOW then
		mod:ElectricGlowUpdate(effect)
	elseif variant == EffectVariant.HUSH_LASER then
		mod:FamiliarParentMovement2(effect, 2, 1.5, 15)
		mod:LunaSpikeUpdate(effect)
	elseif variant == mod.EntityInf[mod.Entity.AnimaSola].VAR and subType == mod.EntityInf[mod.Entity.AnimaSola].SUB then
		mod:LunaAnimaSolaUpdate(effect)
	end
	
	--others
	if data.Selfdestruct then
		mod:Selfdestruct(effect)
	end

end

--Disappear after animation
function mod:DisappearEffect(effect, data)

	local variant = effect.Variant
	local subType = effect.SubType

	local valid = 
	variant == mod.EntityInf[mod.Entity.Aurora].VAR and subType == mod.EntityInf[mod.Entity.Aurora].SUB or
	variant == mod.EntityInf[mod.Entity.TimeFreezeSource].VAR and subType == mod.EntityInf[mod.Entity.TimeFreezeSource].SUB or
	variant == mod.EntityInf[mod.Entity.TimeFreezeObjective].VAR and subType == mod.EntityInf[mod.Entity.TimeFreezeObjective].SUB or
	variant == mod.EntityInf[mod.Entity.SonicBoom].VAR and subType == mod.EntityInf[mod.Entity.SonicBoom].SUB or
	variant == mod.EntityInf[mod.Entity.MarsBoost].VAR and subType == mod.EntityInf[mod.Entity.MarsBoost].SUB or
	variant == mod.EntityInf[mod.Entity.MercuryTrace].VAR and subType == mod.EntityInf[mod.Entity.MercuryTrace].SUB or
	variant == mod.EntityInf[mod.Entity.Spike].VAR and subType == mod.EntityInf[mod.Entity.Spike].SUB or
	variant == mod.EntityInf[mod.Entity.TritonHole].VAR and subType == mod.EntityInf[mod.Entity.TritonHole].SUB or
	variant == mod.EntityInf[mod.Entity.SleepZZZ].VAR and subType == mod.EntityInf[mod.Entity.SleepZZZ].SUB
	if valid then
		if effect:GetSprite():IsFinished("Idle") then
			effect:Remove()
			return
		end
	end

	local sprite = effect:GetSprite()
	if variant == mod.EntityInf[mod.Entity.Snowflake].VAR and subType == mod.EntityInf[mod.Entity.Snowflake].SUB then
		local finished = sprite:IsFinished("Drop01") or sprite:IsFinished("Drop02") or sprite:IsFinished("Drop03") or sprite:IsFinished("Drop04")
		if finished then
			effect:Remove()
		end
	end

end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local data = effect:GetData()
	if data.HeavensCall then
		mod:UpdateEffect(effect, data)
		mod:DisappearEffect(effect, data)
	end
end)
--PROJECTILES-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


--Key-------------------------------------------------------------------------------------------------------------------------------
function mod:KeyUpdate(key)
	local data = key:GetData()
	if data.isOrbiting then
		mod:OrbitKey(key)
	elseif data.Lifespan < 0 then
		key:Remove()
	else
		data.Lifespan = data.Lifespan-1
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, key, collider)
	if key.Variant == mod.EntityInf[mod.Entity.KeyKnife].VAR or key.Variant == mod.EntityInf[mod.Entity.KeyKnifeRed].VAR then
		if collider.Type == EntityType.ENTITY_PLAYER then
			if  key.SubType == mod.EntityInf[mod.Entity.KeyKnife].SUB then
				game:SpawnParticles (key.Position, EffectVariant.NAIL_PARTICLE, 3, 9)
			else
				game:SpawnParticles (key.Position, EffectVariant.TOOTH_PARTICLE, 3, 9)
			end
		end
	end
end)

--Hail------------------------------------------------------------------------------------------------------------------------------
function mod:HailProjectile(tear,collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()
	if data.Init == nil then
		data.Init = true

		--Sprite
		if tear.Variant == mod.EntityInf[mod.Entity.Icicle].VAR and tear.SubType == mod.EntityInf[mod.Entity.Icicle].SUB or
		tear.Variant == mod.EntityInf[mod.Entity.BigIcicle].VAR and tear.SubType == mod.EntityInf[mod.Entity.BigIcicle].SUB then
			sprite:Play("Idle", true)
			sprite.Rotation = tear.Velocity:GetAngleDegrees()
		end
	end

	--This leaves a trace of slippery ice
	if(data.hailTrace and math.floor(tear.Position.X+tear.Position.Y)%5==0) then
		--Spawn ice creep
		mod:SpawnIceCreep(tear.Position, mod.UConst.shotTraceIceSize, tear)
	end
	
	--If tear collided then
	if tear:IsDead() or collided then
		
		game:SpawnParticles (tear.Position, EffectVariant.DIAMOND_PARTICLE, 3, 9)
		
		--Spawn ice creep
		mod:SpawnIceCreep(tear.Position, tear:GetData().iceSize, tear)
		
		--Splash of projectiles:
		if data.hailSplash then
			for i=0, mod.UConst.nShotIcicles do
				local angle = i*360/mod.UConst.nShotIcicles
				--Ring projectiles:
				local hail = mod:SpawnEntity(mod.Entity.Icicle, tear.Position, Vector(1,0):Rotated(angle)*mod.UConst.shotIcicleSpeed, tear.Parent):ToProjectile()
				hail:GetData().IsIcicle_HC = true
				--hail:GetSprite().Color = mod.Colors.hailColor
				hail:GetData().iceSize = mod.UConst.shotIcicleIceSize
				hail:GetData().hailTrace = false
				hail:GetData().hailSplash = false
				
			end
			
			sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1);
		else
			
			sfx:Play(Isaac.GetSoundIdByName("HailBreak"),1);
		end
		
		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsIcicle_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:HailProjectile(tear,true)
		end
	end
end)

--Flame-----------------------------------------------------------------------------------------------------------------------------
function mod:FireUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		sprite:Play("Appear")
		data.Init = true
		if data.EmberPos == nil then data.EmberPos = -10 end
	end

	if sprite:IsFinished("Appear") then sprite:Play("Flickering",true) end

	sprite.Rotation = tear.Velocity:GetAngleDegrees()

	if not data.NoGrow then sprite.Scale = sprite.Scale + 0.018*Vector(1,1) end
	

	if game:GetFrameCount()%5==0 then
		--For tracing
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position + Vector(0,data.EmberPos), Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Scale = 0.8*Vector(1,1)
		cloud:GetSprite().Color = mod.Colors.superFire
	end

	--If tear collided then
	if tear:IsDead() or collided then
		
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Scale = 1.6*Vector(1,1)
		cloud:GetSprite().Color = mod.Colors.superFire

		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsFlamethrower_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:FireUpdate(tear,true)
		end
	end
end)

--Fireball---------------------------------------------------------------------------------------------------------------------------
function mod:FireballUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		sprite:Play("Idle")
		sprite:SetFrame(mod:RandomInt(1,12))
		sprite.PlaybackSpeed = 1.5
		data.Init = true
		data.Lifespan = mod:RandomInt(40,90)

		if tear.Velocity.X < 0 then
			sprite.FlipX = true
		end
		
        tear:AddProjectileFlags(ProjectileFlags.BOUNCE)
        tear:AddProjectileFlags (ProjectileFlags.BOUNCE_FLOOR)
	end

	data.Lifespan = data.Lifespan - 1
	
	if tear.Height >= 1 then
		tear.FallingSpeed = -5;
		tear.FallingAccel = 1.5;
		tear.Height = -23
        tear:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
	end

	if game:GetFrameCount()%5==0 then
		--For tracing
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Scale = 0.4*Vector(1,1)
		cloud:GetSprite().Color = mod.Colors.superFire
		
		game:SpawnParticles (tear.Position, EffectVariant.EMBER_PARTICLE, 3, 2)
	end

	--If tear collided then
	if tear:IsDead() or collided or data.Lifespan <= 0 then
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Scale = 0.8*Vector(1,1)
		cloud:GetSprite().Color = mod.Colors.superFire

		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsFireball_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:FireballUpdate(tear,true)
		end
	end
end)

--Kiss---------------------------------------------------------------------------------------------------------------------------
function mod:KissUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		sprite:Play("Idle")
		data.Init = true
	end

	if sprite:IsFinished("Appear") then sprite:Play("Idle",true) end

	sprite.Color = Color.Default

	if game:GetFrameCount()%2==0 then
		--For tracing
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position + Vector(0,-15), Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Scale = 1.4*Vector(1,1)
		cloud:GetSprite().Color = mod.Colors.superFire
		
		game:SpawnParticles (tear.Position, EffectVariant.EMBER_PARTICLE, 3, 2)
	end

	--If tear collided then
	if tear:IsDead() or collided then
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Color = mod.Colors.fire

		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsKiss_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:KissUpdate(tear,true)
		end
	end
end)

--Missile---------------------------------------------------------------------------------------------------------------------------
function mod:MissileUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		data.Trigger = false

		sprite:Play("Idle", true)
		tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

		tear.FallingSpeed = 0
		tear.FallingAccel = -0.1

		data.Init = true
		data.Counter = 0
		data.Flag = false

		data.OldAngle = sprite.Rotation
	end

	sprite.Rotation = mod:AngleLerp(sprite.Rotation, tear.Velocity:GetAngleDegrees(), 0.5)

	data.OldAngle = sprite.Rotation
	data.Counter = data.Counter + 1

	if data.Counter >= mod.MConst.missileTime and not data.Flag then
		data.Flag = true
		tear:AddProjectileFlags(ProjectileFlags.SMART_PERFECT)
	end

	--To near!
	if game:GetFrameCount()%4==0 and not data.Trigger then
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if tear.Position:Distance(player.Position) < 70 then
				sprite.Rotation = 0
				sprite:Play("Explosion", true)
				data.Trigger = true
				tear:ClearProjectileFlags (ProjectileFlags.SMART_PERFECT)
				tear:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
				tear.Velocity = Vector.Zero
				break
			end
		end
	end


	if sprite:IsFinished("Explosion") then
		--Explosion:
		local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, tear.Position, Vector.Zero, tear.Parent):ToEffect()
		--Explosion damage
		for i, entity in ipairs(Isaac.FindInRadius(tear.Position, mod.MConst.missileExplosionRadius)) do
			if entity.Type ~= EntityType.ENTITY_PLAYER and not entity:GetData().IsMartian then
				entity:TakeDamage(mod.MConst.missileExplosionDamage, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear.Parent), 0)
			elseif entity.Type == EntityType.ENTITY_PLAYER then
				entity:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear.Parent), 0)
			end
		end

		--Projectile ring
		for i=1, mod.MConst.nMissileTears do
			local angle = i*360/mod.MConst.nMissileTears
			
			local shot = mod:SpawnMarsShot(tear.Position, Vector(1,0):Rotated(angle)*mod.MConst.missileTearsSpeed, tear.Parent)
		end

		tear:Remove()
	end


end

--Bismuth-------------------------------------------------------------------------------------------------------------------------------
function mod:BismuthUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		sprite:Play("Rotate"..tostring(mod:RandomInt(0,2)), true)
		data.Init = true
	end

	--If tear collided then
	if tear:IsDead() or collided then

		for i=1, mod.MRConst.nBismuthDivisions do
			local angle = 360 * rng:RandomFloat()
			local speed = Vector.FromAngle(angle) * ( mod.MRConst.bismuthDivisionsSpeed * rng:RandomFloat() + 5 )
			local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, speed, tear.Parent):ToProjectile()
			shot.FallingSpeed = -10;
			shot.FallingAccel = 1.5;
			shot:GetSprite().Color = mod.Colors.mercury
		end

		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsBismuth_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:BismuthUpdate(tear,true)
		end
	end
end)

--Leaf-------------------------------------------------------------------------------------------------------------------------------
function mod:LeafUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		sprite:Play("Idle")
		sprite.Rotation = tear.Velocity:GetAngleDegrees()
		data.Init = true
	end

	--If tear collided then
	if tear:IsDead() or collided then

		game:SpawnParticles (tear.Position, EffectVariant.NAIL_PARTICLE, 9, 5, Color(0.6,1,0.6,1))
		tear:Die()
	end

	if tear.Height >= -33 and tear.FallingAccel > 0 then
		tear.FallingSpeed = 0.05
		tear.Height = -35
		tear.FallingAccel = 0
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsLeaf_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:LeafUpdate(tear,true)
		end
	end
end)

--Bubble-------------------------------------------------------------------------------------------------------------------------------
function mod:BubbleUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		if data.IsTar_HC then
			sprite:Play("IdleTar"..tostring(mod:RandomInt(1,3)))
		else
			sprite:Play("Idle"..tostring(mod:RandomInt(1,3)))
		end
		--sprite:Play("Idle")
		data.Init = true

		local velocity = (rng:RandomFloat() + 0.5) * tear.Velocity
		local hemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, tear.Position, velocity, nil):ToEffect()
		hemo.Visible = false
		hemo:GetSprite().PlaybackSpeed = 0.1
		hemo.LifeSpan = 300
		
		tear.Parent = hemo
		tear.Velocity = Vector.Zero
	end

	if tear.Parent then
		tear.Position = tear.Parent.Position
	end

	--If tear collided then
	if tear:IsDead() or collided or tear.Parent == nil then

		local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)

		if data.IsTar_HC then
            local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, tear.Position, Vector.Zero, tear.Parent):ToEffect()
            tar.Timeout = 30
		end

		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsBubble_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:BubbleUpdate(tear,true)
		end
	end
end)

--ChaosCard-------------------------------------------------------------------------------------------------------------------------------
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().IsChaos_HC then
		if collider.Type == EntityType.ENTITY_PLAYER then
			collider:Kill()

			
			local projectile = mod:SpawnEntity(mod.Entity.ChaosCard, tear.Position, tear.Velocity, nil):ToProjectile()
			projectile:GetData().IsChaos_HC = true
			projectile:GetSprite():Play("Rotate",true)
			projectile:AddProjectileFlags(ProjectileFlags.EXPLODE)
			
			if tear.Height then projectile.Height = tear.Height end
			if tear.FallingAcceleration then projectile.FallingAccel = tear.FallingAcceleration end
			if tear.FallingSpeed then projectile.FallingSpeed = tear.FallingSpeed end

			tear:Remove()
		end
	end
end)

--LunaFetus-------------------------------------------------------------------------------------------------------------------------------
function mod:LunaFetusUpdate(tear, collided)
	local sprite = tear:GetSprite()
	local data = tear:GetData()

	if data.Init == nil then
		data.Init = true

		tear:AddProjectileFlags(ProjectileFlags.SMART_PERFECT)

		if tear.Scale < 1 then
			sprite:Play("Rotate1")
		elseif tear.Scale < 1.5 then
			sprite:Play("Rotate2")
		elseif tear.Scale < 2.5 then
			sprite:Play("Rotate3")
		else
			sprite:Play("Rotate4")
		end
	end

	--If tear collided then
	if tear:IsDead() or collided then

		local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, tear.Position, Vector.Zero, nil)
		blood.SpriteScale = math.sqrt(tear.Scale) * Vector.One
		blood:GetSprite().Color = sprite.Color

		sfx:Play(SoundEffect.SOUND_SPLATTER)
		tear:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear.Variant == mod.EntityInf[mod.Entity.LunaFetus].VAR then
		if collider.Type == EntityType.ENTITY_PLAYER then
			mod:LunaFetusUpdate(tear,true)
		end
	end
end)

--Projectile Updates
function mod:UpdateProjectile(projectile, data)
	local variant = projectile.Variant
	local subType = projectile.SubType

	if data.IsBubble_HC then
		mod:BubbleUpdate(projectile,false)
	elseif data.IsLeaf_HC then
		mod:LeafUpdate(projectile,false)
	elseif data.IsMissile_HC then
		mod:MissileUpdate(projectile,false)
	elseif data.IsKiss_HC then
		mod:KissUpdate(projectile,false)
	elseif data.IsFireball_HC then
		mod:FireballUpdate(projectile,false)
	elseif data.IsFlamethrower_HC then
		mod:FireUpdate(projectile,false)
	elseif data.IsIcicle_HC then
		mod:HailProjectile(projectile,false)
	elseif variant == mod.EntityInf[mod.Entity.KeyKnife].VAR or variant == mod.EntityInf[mod.Entity.KeyKnifeRed].VAR then
		mod:KeyUpdate(projectile)
	elseif data.IsBismuth_HC then
		mod:BismuthUpdate(projectile)
	elseif projectile.Variant == mod.EntityInf[mod.Entity.LunaFetus].VAR then
		mod:LunaFetusUpdate(projectile,false)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, projectile)
	local data = projectile:GetData()
	if data.HeavensCall then
		mod:UpdateProjectile(projectile, data)
	end
end)


--LASERS----------------------------------------------------------------------------------------------------------------------------

--Luna Maw-----------------------------------------------------------------------------------------------------------------------
function mod:LunaMawUpdate(entity)
	if not entity.Parent then
		entity:Remove()
	end
	local parent = entity.Parent:ToNPC()

	local data = entity:GetData()

	if not data.Init then
		data.Init = true

		entity.Timeout = mod.LConst.mawTimeout
		entity.Radius = 0
	end

	entity.Radius = mod.LConst.mawRadius * (1 - math.cos( (1 - entity.Timeout/mod.LConst.mawTimeout) * 2 * math.pi ))

end


--PLAYER----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Burning effect
function mod:PlayerEffects(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	if data.BurnTime and data.BurnTime >= 0 and entity:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B then

		--Burning Color
		if data.BurnTime == mod.ModConstants.burningFrames then
			--data.PreBurnColor = sprite.Color
		elseif data.BurnTime <= 0 then
			sprite.Color = Color.Default
			local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
			cloud:GetSprite().Color = Color(0.03,0.03,0.03,1)
		else
			local color = Color(2*math.abs(math.sin(game:GetFrameCount()/1.5)),1.5*math.abs(math.sin(game:GetFrameCount()/1.5)),1*math.abs(math.sin(game:GetFrameCount()/1.5)),1)
			--color:SetColorize(+0.75,0.25,0.25,1)
			color:SetColorize(2*math.abs(math.sin(game:GetFrameCount()/1.5))+1,0.5,0,1)
			sprite.Color = color
		end

		--Timer
		data.BurnTime = data.BurnTime - 1

		--Movement
		if math.abs(entity:GetMovementInput().X) + math.abs(entity:GetMovementInput().Y) > 0 then 
			data.direction = entity:GetMovementInput():Normalized()
		elseif data.direction == nil then
			data.direction = Vector(1,0)
		end

		--Bounce
		if entity:CollidesWithGrid() then
			data.direction = - data.direction
		end

		--Move
		entity.Velocity = data.direction:Rotated(2*rng:RandomFloat()-1)*7
		
		--Its a me
		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, entity.Position + Vector(0,-20), Vector.Zero, entity):ToEffect()
		cloud:GetSprite().Scale = 0.8*Vector(1,1)
		cloud:GetSprite().Color = Color(0,0,0,1)
		if game:GetFrameCount()%15==0 then
            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS,0.5)
		elseif game:GetFrameCount()%2==0 then
			game:SpawnParticles (entity.Position, EffectVariant.EMBER_PARTICLE, 2, 2)
		end

	elseif data.GodheadTime_HC then
		data.GodheadTime_HC = math.max(0,data.GodheadTime_HC - 1)
		sprite.Color = Color.Lerp(sprite.Color, Color(1,1,1,1), 0.05)
	end

	if data.GodheadIncrease_HC then
		data.GodheadTime_HC = data.GodheadTime_HC + data.GodheadIncrease_HC + 1
		data.GodheadIncrease_HC = false
		
		if not sfx:IsPlaying(SoundEffect.SOUND_DOGMA_DEATH) then
			sfx:Play(SoundEffect.SOUND_DOGMA_DEATH, 0.8, 2, false, 4)
		end
	end
end

--Player damage
function mod:PlayerDamage(player, amount, damageFlags, sourceRef, frames)

	local source = sourceRef.Entity

	player = player:ToPlayer()

	if player:GetData().Invulnerable_HC then
		player:GetData().Invulnerable_HC = false
		return false
	end

	if mod:QuantumRoll(player) then
		mod:QuantumTeleport(player)
		return false
	end

    if source then

		--Luna strenght hit
		local luna
		if source.Type == mod.EntityInf[mod.Entity.Luna].ID and source.Variant == mod.EntityInf[mod.Entity.Luna].VAR then
			luna = source
		elseif source.SpawnerEntity and source.SpawnerEntity.Type == mod.EntityInf[mod.Entity.Luna].ID and source.SpawnerEntity.Variant == mod.EntityInf[mod.Entity.Luna].VAR then
			luna = source.SpawnerEntity
		end

		if luna then
			local strong = luna:GetData().StrengthTime >= 0 or
					luna:GetData().AssistP == mod.LAssistPassives.POLYPHEMUS or
					luna:GetData().AssistP == mod.LAssistPassives.MAGIC_MUSHROOM

			if strong and (damageFlags & DamageFlag.DAMAGE_INVINCIBLE) == 0 then
				player:TakeDamage(amount, damageFlags | DamageFlag.DAMAGE_INVINCIBLE, sourceRef, frames)
			end

			if luna:GetData().State == mod.LMSState.MOMS_SHOVEL then 
				sfx:Play(Isaac.GetSoundIdByName("ShovelHit"),3)
			end

		end

		--If fire damage (Venus)
		local fireFlag = false
        if source:GetData().IsFlamethrower_HC or source:GetData().IsFireball_HC or source.Type == mod.EntityInf[mod.Entity.Venus].ID then
            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
			fireFlag = true

        elseif source.Type == EntityType.ENTITY_PROJECTILE and source.Variant == mod.EntityInf[mod.Entity.Kiss].VAR and source.SubType == mod.EntityInf[mod.Entity.Kiss].SUB then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
            	player:GetData().BurnTime = mod.ModConstants.burningFrames
			end

            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
			return false
        end

		--Blaze heart lost
		if not fireFlag then
			local invalid = (damageFlags&DamageFlag.DAMAGE_FIRE==DamageFlag.DAMAGE_FIRE)
						or (damageFlags&DamageFlag.DAMAGE_RED_HEARTS==DamageFlag.DAMAGE_RED_HEARTS)
						or (damageFlags&DamageFlag.DAMAGE_DEVIL==DamageFlag.DAMAGE_DEVIL)
						or (damageFlags&DamageFlag.DAMAGE_ISSAC_HEART==DamageFlag.DAMAGE_ISSAC_HEART)
						or (damageFlags&DamageFlag.DAMAGE_INVINCIBLE==DamageFlag.DAMAGE_INVINCIBLE)
						or (damageFlags&DamageFlag.DAMAGE_CURSED_DOOR==DamageFlag.DAMAGE_CURSED_DOOR)
						or (damageFlags&DamageFlag.DAMAGE_IV_BAG==DamageFlag.DAMAGE_IV_BAG)
						or (damageFlags&DamageFlag.DAMAGE_FAKE==DamageFlag.DAMAGE_FAKE)

			if not invalid then
				if mod.savedata.nLocusts and mod.savedata.nLocusts[tostring(player.ControllerIndex)] then
					if mod.savedata.nLocusts[tostring(player.ControllerIndex)] > 0 then
						for i=1, 12 do
							local angle = i*360/12
							local velocity = Vector(10,0):Rotated(angle)
							--local fire = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE, 0, player.Position, Vector(10,0):Rotated(angle), player):ToTear()
							--fire:GetSprite().Color = mod.Colors.fire
	
	
							local fireball = mod:SpawnEntity(mod.Entity.Fireball, player.Position + velocity, velocity, player):ToProjectile()
							fireball.CollisionDamage = 12
							fireball:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
							fireball:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
	
							fireball.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	
							fireball:GetData().IsFireball_HC = true
				
							fireball.FallingSpeed = -5
							fireball.FallingAccel = 1.5
						end
	
						sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
					end
	
					mod.savedata.nLocusts[tostring(player.ControllerIndex)] = math.max(0, mod.savedata.nLocusts[tostring(player.ControllerIndex)] - 1)
					mod:WilloCheck(player)
				end
			end
		end

    end
end

--Burn sfx and burning effect for venus
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PlayerDamage, EntityType.ENTITY_PLAYER)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PlayerEffects, 0)

--[[
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,entity)

	print(entity.State)
	print(entity.V1)
	print(entity.V2)
	print(entity.I1)
	print(entity.I2)
	print()

end, EntityType.ENTITY_CLUTCH)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	for _, e in ipairs(Isaac.FindInRadius(player.Position, 30)) do
		if e.Type ~= EntityType.ENTITY_PLAYER and e:ToPickup() then
			e = e:ToPickup()
			print()
			print(e:CanReroll())
			print(e.Charge)
			print(e.Wait)
		end
	end
	
end,0)

function mod:MusicTest1()
	local music1 = MusicManager()
	local music2 = MusicManager()

	music2:Play(Music.MUSIC_GEHENNA)
	music2:EnableLayer(0)

	music1:Play(Music.MUSIC_MAUSOLEUM)
	music1:EnableLayer(1)

	music2:UpdateVolume()
	music1:UpdateVolume()

end]]