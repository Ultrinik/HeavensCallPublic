local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()
local json = require("json")

--ENTITIES--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Ariral
function mod:AriralUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.GlassGaper].VAR and entity.SubType == mod.EntityInf[mod.Entity.GlassGaper].SUB+2 then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
    
        if not data.Init then
            data.Init = true
            data.Flaged = false
			data.cooldown = 0
    
            sprite:PlayOverlay("Head", true)
            sprite:SetOverlayRenderPriority(false)
    
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			sprite.Color = Color(1,1,1,0)
        end
    
        sprite.FlipX = false
        if entity.Velocity:Length() <= 0 then
            sprite:Play("WalkV", true)
            sprite:Stop()
        else
            if entity.Velocity.X > 0 then
                if not sprite:IsPlaying("WalkR") then
                    sprite:Play("WalkR", true)
                end
            elseif entity.Velocity.X < 0 then
                if not sprite:IsPlaying("WalkL") then
                    sprite:Play("WalkL", true)
                end
            else
                if not sprite:IsPlaying("WalkV") then
                    sprite:Play("WalkV", true)
                end
            end
        end
		data.cooldown = data.cooldown - 1
		if sfx:IsPlaying(SoundEffect.SOUND_ZOMBIE_WALKER_KID) then
			sfx:Stop(SoundEffect.SOUND_ZOMBIE_WALKER_KID)
			if data.cooldown <= 0 then
				sfx:Play(Isaac.GetSoundIdByName("Ariral"))
				data.cooldown = 60
			end
		end

    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.AriralUpdate, mod.EntityInf[mod.Entity.GlassGaper].ID)
function mod:AriralDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.GlassGaper].VAR and entity.SubType == mod.EntityInf[mod.Entity.GlassGaper].SUB+2 then
		

        local MIN_GIBS = 20 -- max is double this
        local MAX_BLOOD_GIB_SUBTYPE = 6
    
        local gibCount = rng:RandomInt(MIN_GIBS + 1) + MIN_GIBS
        for _ = 1, gibCount do
            local speed = rng:RandomInt(4) + 1
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, rng:RandomInt(MAX_BLOOD_GIB_SUBTYPE + 1), entity.Position, RandomVector() * speed, player)
        end
    
        local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, player)
        cloud.SpriteScale = Vector.One*1
        cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, player)
        cloud.SpriteScale = Vector.One*1
        cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, player)
        cloud.SpriteScale = Vector.One*1
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)

	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.AriralDeath, mod.EntityInf[mod.Entity.GlassGaper].ID)
function mod:AriralDamage(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.GlassGaper].VAR and entity.SubType == mod.EntityInf[mod.Entity.GlassGaper].SUB+2 then
		
		entity:SetColor(Color(1,1,1,0), -1, 1, true, true)
		entity:SetColor(Color.Default, 30, 2, true, true)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.AriralDamage, mod.EntityInf[mod.Entity.GlassGaper].ID)

--EFFECTS---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--ICUP
function mod:ICUPUpdate(entity)
	local sprite = entity:GetSprite()

	if sprite:IsFinished("FlowerStart") then
		sprite:Play("FlowerIdle", true)
	elseif sprite:IsFinished("Idle") then
		entity:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ICUPUpdate, mod.EntityInf[mod.Entity.ICUP].VAR)

--Trail
function mod:TrailUpdate(effect)
	if effect:GetData().HC and not effect.Parent then
		effect:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.TrailUpdate, EffectVariant.SPRITE_TRAIL)

--Techdot
function mod:TechdotUpdate(effect)
	if effect.Parent == nil and effect:GetData().MarsShot_HC then
		effect:Die()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.TechdotUpdate, EffectVariant.TECH_DOT)

--Glass Fracture
function mod:GlassFractureInit(effect)
	if effect.SubType == mod.EntityInf[mod.Entity.GlassFracture].SUB then
		
        local fractures = Isaac.FindByType(EntityType.ENTITY_EFFECT, mod.EntityInf[mod.Entity.GlassFracture].VAR, mod.EntityInf[mod.Entity.GlassFracture].SUB)
        if #fractures > 30 then
            fractures[1]:Remove()
        end
    
        effect.DepthOffset = -5000

		local sprite = effect:GetSprite()
		sprite:Play("Idle"..mod:RandomInt(1,2), true)
        sprite.Rotation = 360 * rng:RandomFloat()

        sfx:Play(Isaac.GetSoundIdByName("CrystalBreak"), 3, 2, false, 1)
		
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND

		
		local roomdesc = game:GetLevel():GetCurrentRoomDesc()
		local room = game:GetRoom()
		if not (room:GetBackdropType() == BackdropType.PLANETARIUM or mod:IsRoomDescAstralChallenge(roomdesc) or mod:IsRoomDescErrant(roomdesc)) then
			effect:Remove()
		end

	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.GlassFractureInit, mod.EntityInf[mod.Entity.GlassFracture].VAR)

--Debuff
function mod:AddDebuffOverlay(tipo, player)
	local effect = mod:SpawnEntity(mod.Entity.Debuff, player.Position+Vector(0,-50), Vector.Zero, player):ToEffect()
	local data = effect:GetData()

	effect.DepthOffset = 999

	if tipo == 'Cancer' then
		data.Cancer = true
		effect:GetSprite():SetFrame("Idle", 0)
	elseif tipo == 'Fire' then
		data.Fire = true
		effect:GetSprite():SetFrame("Idle", 1)
	end
	effect:GetSprite():Stop()

	effect:FollowParent(player)
end
function mod:DebuffUpdate(effect)
	if effect.SubType == mod.EntityInf[mod.Entity.GlassFracture].SUB then
		local player = effect.Parent and effect.Parent:ToPlayer()
		local data = effect:GetData()
		if player then

			if not data.Init then
				data.Init = true

				data.LastCancer = -1
			end

			if data.Cancer then
				if player:GetData().Cancer and player:GetData().Cancer <= data.LastCancer or player:GetData().Cancer <= 0 then
					effect:Remove()
				end
				data.LastCancer = player:GetData().Cancer

			elseif data.Fire then
				if not mod:IsPlayerBurning(player) then
					effect:Remove()
				end
			end
		else
			effect:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DebuffUpdate, mod.EntityInf[mod.Entity.Debuff].VAR)

--PLAYER----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--Burning effect
function mod:BurnPlayer(player, frames)
	if not (player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) or player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC)) then
		player:GetData().BurnTime = frames
		sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
		mod:AddDebuffOverlay('Fire', player)
	end
end
function mod:IsPlayerBurning(player)
	return player:GetData().BurnTime and player:GetData().BurnTime > 0
end

--effects
function mod:PlayerEffects(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	if data.BurnTime and data.BurnTime >= 0 and entity:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B then

		if entity:IsDead() then
			data.BurnTime = 0
		end

		--Burning Color
		if data.BurnTime == mod.VConst.BURNINGS_FRAMES then
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
			data.direction = entity:GetLastDirection()
		end

		--Bounce
		if entity:CollidesWithGrid() then
			data.direction = - data.direction
		end

		--Move
		entity.Velocity = data.direction:Rotated(2*rng:RandomFloat()-1)*6
		
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
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PlayerEffects, 0)

--Player damage
function mod:PrePlayerDamage(player, amount, damageFlags, sourceRef, frames)

	player = player:ToPlayer()
	local data = player:GetData()

	local source = sourceRef.Entity

	--make fake players inmortal
	if player:GetPlayerType() == mod.DollCharacterId then
		return false
	end
	if player:GetPlayerType() == mod.BlazeCharacterId and (game:GetLevel():GetCurrentRoomDesc().Data.Type ~= RoomType.ROOM_SACRIFICE) then
		return false
	end

	if player:GetDamageCooldown() > 0 then
		return
	end

	--shield hc
	if data.Invulnerable_HC then
		data.Invulnerable_HC = false
		return false
	end

	--stallion
	local floorDamage = ((DamageFlag.DAMAGE_ACID | DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_POOP) & damageFlags) ~= 0
	if data.Mounted_HC then
		if floorDamage then
			return false
		end

		if player.Velocity:Length() > mod.StallionCons.minRamSpeed then

			if source and mod:IsHostileEnemy(source) and player.Position:Distance(source.Position) < (player.Size + source.Size) then

				data.Invulnerable_HC = true
				mod:scheduleForUpdate(function()
					local seconds = 3
					player:ResetDamageCooldown()
					player:SetMinDamageCooldown(1*30)
				end, 2)
				return false
			end
		end
	end

	--quantum shard
	if mod:QuantumRoll(player) then
		player:SetMinDamageCooldown(30)
		mod:QuantumTeleport(player)
		return false
	end

	--mothership shield
	for _, mother in ipairs(mod:FindByTypeMod(mod.Entity.Mothership)) do
		mother = mother:ToFamiliar()
		if player:GetCollectibleRNG(1):GetSeed() == mother.Player:GetCollectibleRNG(1):GetSeed() then
			local data = mother:GetData()
			if data.Shields and data.Shields > 0 then
				data.Shields = data.Shields - 1
				if true then--shield
					sfx:Play(SoundEffect.SOUND_BISHOP_HIT)
					local shield = mod:SpawnEntity(mod.Entity.ICUP, player.Position + Vector(0,-25), Vector.Zero, player):ToEffect()
					shield:FollowParent(player)
					shield.DepthOffset = 500
					shield.SpriteScale = Vector.One*0.75
		
					local shieldSprite = shield:GetSprite()
					shieldSprite:Load("hc/gfx/effect_LunaShield.anm2", true)
					shieldSprite:ReplaceSpritesheet(2, "gfx/effects/bishop_shield.png")
					shieldSprite:ReplaceSpritesheet(1, "gfx/effects/bishop_shield.png")
					shieldSprite:Play("Idle", true)
					shieldSprite:LoadGraphics()
					
					shieldSprite.Color = mod.Colors.infected
				end

				local direction = (player.Position+ Vector(0,-25)) - mother.Position
				local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, mother.Position, direction:GetAngleDegrees(), 1, Vector.Zero, mother)
				laser.MaxDistance = direction:Length()
				laser.CollisionDamage = 0.01
				laser:AddTearFlags(TearFlags.TEAR_SPECTRAL)

				player:SetMinDamageCooldown(60)
				
				return false
			end
		end
	end

	if not player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true) then
		--blaze heart protection
		if mod:GetBlazeHearts(player) > 0 and mod:CheckIfBlazeHeartLostOnHit(player, amount, damageFlags, source, frames) then
			player:SetMinDamageCooldown(60)
			return false
		end

		--void heart
		if mod:GetVoidHearts(player) > 0 and mod:CheckVoidHeartOnHit(player, amount, damageFlags, source, frames) then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, false, true, false, -1)
			player:SetMinDamageCooldown(120)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, mod.PrePlayerDamage, 0)

function mod:PlayerDamage(player, amount, damageFlags, sourceRef, frames)

	player = player:ToPlayer()
	local data = player:GetData()

	local source = sourceRef.Entity

	--full heart damage from apocalypse
	if mod.ModFlags.IsApocalypseActive and (damageFlags & DamageFlag.DAMAGE_CLONES == 0) and (amount < 2) then
		player:TakeDamage(2, damageFlags | DamageFlag.DAMAGE_CLONES, sourceRef, frames)
		return false
	end

	local hostileDamage = ((DamageFlag.DAMAGE_DEVIL | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_CURSED_DOOR) & damageFlags) == 0
	if hostileDamage then

		--hit during boss
		if mod:IsCurrentRoomBossRoom() then
			mod.savedatafloor().mothershipHit = 1
		end

		--blaze fire
		--mod:OnLesbianDamage(player, amount, damageFlags, source, frames)

		--has a source
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
	
			--venus boss damage
			local wasKiss = mod:OnPlayerDamageVenus(player, amount, damageFlags, source, frames)
			if wasKiss then
				return false
			end
	
		end

		--lose the bismuths
		mod:OnPlayerHitBismuth(player)

		--lose ascended challenge
		mod:OnAstralPlayerDamage()

		--lose on invictus
		mod:OnInvictusHit(player)
	end

	--golden gear rewind
	if mod:OnGoldenGearDamage(player) then
		mod:scheduleForUpdate(function ()
			--Isaac.ExecuteCommand("rewind")
    		player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false)
		end, 10)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PlayerDamage, EntityType.ENTITY_PLAYER)


function mod:KillFakePlayers()
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
        if player and (player:GetPlayerType() == mod.BlazeCharacterId or player:GetPlayerType() == mod.DollCharacterId) then
            mod:FakePlayerDie(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.KillFakePlayers)

function mod:FakePlayerDie(summon)
	summon.Position = Isaac.GetPlayer(0).Position
	summon:GetData().Position_HC = Isaac.GetPlayer(0).Position
	summon:GetData().DollId = nil
	summon.Visible = false
	summon:GetSprite().Color = Color(1,1,1,0)
    mod:scheduleForUpdate(function()
        summon:GetSprite().PlaybackSpeed = 10
        summon:Die()

		for i=1, 200 do
			mod:scheduleForUpdate(function()
				--sfx:Stop(SoundEffect.SOUND_DEATH_BURST_SMALL)
				--sfx:Stop(SoundEffect.SOUND_DEATH_BURST_LARGE)
				sfx:Stop(SoundEffect.SOUND_ISAACDIES)

			end, i, ModCallbacks.MC_INPUT_ACTION)
		end

	end, 2)
end

function mod:MakePlayerJump(player, height, frames, invulnerable, animation)
	local data = player:GetData()

	data.IsJumping_HC = true

	data.JumpTimer_HC = 0
	data.JumpHeight_HC = height
	data.JumpFrames_HC = math.ceil(frames)

	if invulnerable then
		player:SetMinDamageCooldown(data.JumpFrames_HC*2)
	end

	if animation then
		player:AnimateTrapdoor()
		mod:scheduleForUpdate(function()
			player:GetSprite():Play("Jump", true)
		end, 0)
	end

	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnPlayerJump)
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnPlayerJump)

end
function mod:OnPlayerJump()

	local flag = false
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			local data = player:GetData()
			if data.IsJumping_HC then

				local height = data.JumpHeight_HC
				local frames = data.JumpFrames_HC+2

				if not game:IsPaused() then
					data.JumpTimer_HC = data.JumpTimer_HC + 0.5
				end

				local t = data.JumpTimer_HC

				local c = -4 * height / frames^2
				local y = c*(t)*(t-frames)
				local v = Vector(0, -y)
	
				player.SpriteOffset = v
				for i, costume in ipairs(player:GetCostumeSpriteDescs()) do
					local sprite = costume:GetSprite()
					sprite.Offset = v
				end

				if t > frames-1 then
					data.IsJumping_HC = false
				else
					flag = true
				end
			end
		end
	end

	--deactivate
    if not flag then
		mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnPlayerJump)

		local v = Vector.Zero
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player then
				player.SpriteOffset = v
				for i, costume in ipairs(player:GetCostumeSpriteDescs()) do
					local sprite = costume:GetSprite()
					sprite.Offset = v
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

--IETDDATD----------------------------------------------------------------------------------------------------------------------------
function mod:IETDDATDUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.IETDDATD].VAR and entity.SubType == mod.EntityInf[mod.Entity.IETDDATD].SUB then
		local data = entity:GetData()

		if not data.Init then
			data.Init = true
			
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

		end

		if entity.Parent then
			entity.Position = entity.Parent.Position
			entity.Velocity = entity.Parent.Velocity
		else
			entity:Remove()
		end
		
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.IETDDATDUpdate, mod.EntityInf[mod.Entity.IETDDATD].ID)
function mod:IETDDATDDamage(entity, amount, damageFlags, sourceRef, frames)
    if entity.Variant == mod.EntityInf[mod.Entity.IETDDATD].VAR and entity.SubType == mod.EntityInf[mod.Entity.IETDDATD].SUB then
		if entity.Parent and entity.Parent.SpawnerEntity then
			entity.Parent.SpawnerEntity:TakeDamage(amount, damageFlags, sourceRef, frames)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.IETDDATDDamage, mod.EntityInf[mod.Entity.IETDDATD].ID)


--[[
--Rope
function mod:CatchPlayer()
	local player = Isaac.GetPlayer(0)

	local effect = mod:SpawnEntity(mod.Entity.Statue, game:GetRoom():GetCenterPos(), Vector.Zero, nil)

	local parent = effect
	for i=1, 20 do
		local position = effect.Position + (player.Position - effect.Position)*i/mod.LConst.CHAIN_L

		local chain = mod:SpawnEntity(mod.Entity.RopeNode, effect.Position, Vector.Zero, effect):ToNPC()

		chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		chain:SetSize(10, Vector.One, 12)

		--chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		chain.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS


		parent.Child = chain
		chain.Parent = parent

		chain.I1 = i
		chain.DepthOffset = -15
		
		parent = chain
	end
	

	local cord = mod:SpawnEntity(mod.Entity.RopeCord, effect.Position, Vector.Zero, effect)
	cord.Parent = player
	cord.Target = parent
	parent.Child = player
	
	mod:scheduleForUpdate(function()
		for index, node in ipairs(mod:FindByTypeMod(mod.Entity.RopeNode)) do

			local cord = mod:SpawnEntity(mod.Entity.RopeCord, effect.Position, Vector.Zero, effect)
			cord.Parent = node
			cord.Target = node.Parent
			
			local cord = mod:SpawnEntity(mod.Entity.RopeCord, effect.Position, Vector.Zero, effect)
			cord.Parent = node.Parent
			cord.Target = node
			cord:SetColor(Color(0,0,1,1), 9999, 99, true, true)
		end
	end, 10)
end

function mod:NodeUpdate(entity)
	--entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	local parent = entity.Parent
	if parent then
		local angles = (parent.Position - entity.Position):GetAngleDegrees()
		local distance = parent.Position:Distance(entity.Position)*0.75

		local vector = Vector(4,2):Rotated(angles)
		vector = Vector(math.abs(vector.X), math.abs(vector.Y))

		entity:SetSize(distance, vector, 30)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.NodeUpdate, mod.EntityInf[mod.Entity.RopeNode].ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
	if entity.Variant == mod.EntityInf[mod.Entity.RopeNode].VAR and entity.SubType == mod.EntityInf[mod.Entity.RopeNode].SUB then
		mod:ChainUpdate(entity)
	end
end, mod.EntityInf[mod.Entity.RopeNode].ID)
]]

