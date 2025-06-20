local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

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

mod.TvenusConsts = {
    MIN_ENEMY_HEALTH = 7,

    N_STAGE_1 = 4,
    N_STAGE_2 = 8,
    N_STAGE_3 = 12,

    WILLO_BURN_TIME = 5,

	DEFAULT_CHANCE = 0.01,

	MAX_LOCUST = 4,
}

--UPDATES-------------------------------
function mod:OnVenusUpdate(player)
    if player:HasCollectible(mod.Items.Venus) then

		if Input.GetActionValue(ButtonAction.ACTION_DROP, player.ControllerIndex) > 0 then

			mod.ItemsVars.waxCount = mod.ItemsVars.waxCount + 1
			if mod.ItemsVars.waxCount > 30*3 then
				mod.ItemsVars.waxCount = 0
	
				for _, entity in ipairs(Isaac.GetRoomEntities()) do
					if entity:GetData().IsTrueWax_HC and entity:GetData().WaxPlayer_HC == mod:PlayerId(player) then
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
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnVenusUpdate, 0)

--CANDLE-----------------------------------------------
function mod:OnCanldeInit(familiar)
    familiar.IsFollower = true
	familiar:AddToFollowers()

	local sprite = familiar:GetSprite()
	sprite:Play("Idle0")
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
			mod:SpawnWaxFriend(familiar.Player, familiar)
		end

		sprite:Play("Idle0", true)
		data.Souls = 0
	end

end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnCanldeInit, mod.EntityInf[mod.Entity.FamiliarCandle].VAR)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnCandleUpdate, mod.EntityInf[mod.Entity.FamiliarCandle].VAR)
function mod:SpawnWaxFriend(player, familiar)
	familiar = familiar or player

	player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, false, false, true, false)
	mod:scheduleForUpdate(function()
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			local data = entity:GetData()
			if not data.Flagged_HC and (entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or entity:HasEntityFlags(EntityFlag.FLAG_CHARM)) then
				data.IsWax_HC = true
				data.IsTrueWax_HC = true
				data.WaxPlayer_HC = mod:PlayerId(player)
				--Wax skin
				mod:WaxifyEnemy(entity)
				mod:scheduleForUpdate(function() if entity then mod:WaxifyEnemy(entity) end end, 1)
				mod:scheduleForUpdate(function() if entity then mod:WaxifyEnemy(entity) end end, 3)
				entity.Position = familiar.Position
			end
		end
	end, 3)

	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, familiar.Position + Vector(5,0), Vector.Zero, nil)
	poof:GetSprite().Color = mod.Colors.fire

end

function mod:OnEnemyDeathCandle(entity)
    local valid = entity:IsEnemy()
				and entity.MaxHitPoints > mod.TvenusConsts.MIN_ENEMY_HEALTH
				and mod:SomebodyHasItem(mod.Items.Venus)
				and not entity.Parent
				and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
	if valid then
		for _, candle in ipairs(mod:FindByTypeMod(mod.Entity.FamiliarCandle)) do
			local data = candle:GetData()
			local sprite = candle:GetSprite()

			data.Souls = data.Souls + 1

			local a=mod.TvenusConsts.N_STAGE_1
			local b=mod.TvenusConsts.N_STAGE_2
			local c=mod.TvenusConsts.N_STAGE_3

			if candle.Player and candle.Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
				a=math.ceil(a*2/3)
				b=math.ceil(b*2/3)
				c=math.ceil(c*2/3)
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
end
--mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnEnemyDeathCandle)

function mod:WaxSummon(entity)
	if entity.SpawnerEntity and entity.SpawnerEntity:GetData().IsWax_HC then
		mod:scheduleForUpdate(function()
			entity:GetData().IsWax_HC = true
			entity:GetSprite().Color = mod.Colors.fire
		end,1)
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.WaxSummon)
--mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.WaxSummon)
--mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.WaxSummon)

--DAMAGES--------------------------------------------------------------------------------
function mod:OnWaxFriendDamage(entity, amount, damageFlags)
	if entity:GetData().IsWax_HC then
		local invalid = (damageFlags&DamageFlag.DAMAGE_FIRE==DamageFlag.DAMAGE_FIRE)
		or (damageFlags&DamageFlag.DAMAGE_SPIKES==DamageFlag.DAMAGE_SPIKES)
		if invalid then return false end
	end
end
--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,  mod.OnWaxFriendDamage)

function mod:OnWilloHit(willo, entity)
	entity = entity:ToNPC()

	if willo.SubType == mod.EntityInf[mod.Entity.Willo].SUB and mod:IsVulnerableEnemy(entity) then
		entity:AddBurn(EntityRef(willo), 30*mod.TvenusConsts.WILLO_BURN_TIME, 3.5)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.OnWilloHit, mod.EntityInf[mod.Entity.Willo].VAR)

function mod:CheckIfBlazeHeartLostOnHit(player, amount, damageFlags, source, frames)
	--invalid means that the blaze heart will not break or protect
	local invalid = (damageFlags&DamageFlag.DAMAGE_FIRE==DamageFlag.DAMAGE_FIRE)
				or (damageFlags&DamageFlag.DAMAGE_RED_HEARTS==DamageFlag.DAMAGE_RED_HEARTS)
				or (damageFlags&DamageFlag.DAMAGE_DEVIL==DamageFlag.DAMAGE_DEVIL)
				or (damageFlags&DamageFlag.DAMAGE_INVINCIBLE==DamageFlag.DAMAGE_INVINCIBLE)
				or (damageFlags&DamageFlag.DAMAGE_CURSED_DOOR==DamageFlag.DAMAGE_CURSED_DOOR)
				or (damageFlags&DamageFlag.DAMAGE_IV_BAG==DamageFlag.DAMAGE_IV_BAG)
				or (damageFlags&DamageFlag.DAMAGE_FAKE==DamageFlag.DAMAGE_FAKE)

	if not invalid then
		local mantle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 11, player.Position+Vector(0,-20), Vector.Zero, player):ToEffect()
		mantle:GetSprite():ReplaceSpritesheet(0, "hc/gfx/effects/blaze_heart_break.png", true)
		mantle.DepthOffset = 40
		mantle:FollowParent(player)

		sfx:Play(SoundEffect.SOUND_BEAST_LAVA_BALL_SPLASH)
		--sfx:Stop(SoundEffect.SOUND_HOLY_MANTLE)

		return mod:DestroyBlazeHeartFromPlayer(player)
	end
end

--OTHERS--------------------------------------------------
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType == mod.EntityInf[mod.Entity.BlazeHeart].SUB then
		if pickup:GetSprite():IsFinished("Collect") then
			pickup:Remove()
		end
	end
end, mod.EntityInf[mod.Entity.BlazeHeart].VAR)

function mod:GetBlazeHearts(player)
	mod.SaveManager.GetRunSave(player).nLocusts = mod.SaveManager.GetRunSave(player).nLocusts or 0
	return mod.SaveManager.GetRunSave(player).nLocusts
end
function mod:CanPickBlazeHearts(player)
	local n_blaze_hearts = mod:GetBlazeHearts(player)

	local n_hearts = mod:GetPlayerHearts(player)
	local capacity_flag = n_hearts >= n_blaze_hearts + 1

	if capacity_flag and n_blaze_hearts < mod.TvenusConsts.MAX_LOCUST then
		return true
	end
	return false
end
function mod:AddBlazeHeartToPlayer(player)
	if mod:CanPickBlazeHearts(player) then
		
		mod.SaveManager.GetRunSave(player).nLocusts = mod.SaveManager.GetRunSave(player).nLocusts + 1

		mod:WilloCheck(player)

		mod:CheckBlazeHeartRender()

		return true
	end
	return false
end
function mod:DestroyBlazeHeartFromPlayer(player)
	local n_blaze_hearts = mod:GetBlazeHearts(player)

	if n_blaze_hearts > 0 then
		for i=1, 8 do
			local angle = i*360/8
			local fire = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE, 0, player.Position, Vector(10,0):Rotated(angle), player)
			fire:GetSprite().Color = mod.Colors.fire
		end

		sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)

		mod.SaveManager.GetRunSave(player).nLocusts = math.max(0, n_blaze_hearts - 1)
		mod:WilloCheck(player)

		mod:CheckBlazeHeartRender()

		return true
	end
	return false
end

function mod:OnBlazeHeartPickup(pickup, collider)
    if pickup.SubType == mod.EntityInf[mod.Entity.BlazeHeart].SUB then
		local player = collider:ToPlayer()
		if not player then return end

		local success =  mod:AddBlazeHeartToPlayer(player)
		if success then
			pickup.Velocity = Vector.Zero
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup:GetSprite():Play("Collect")

			sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)

			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnBlazeHeartPickup, mod.EntityInf[mod.Entity.BlazeHeart].VAR)

function mod:WaxifyEnemy(enemy)
	local id = enemy.Type
	local variant = enemy.Variant

	local sprite = enemy:GetSprite()

	if id == EntityType.ENTITY_CLOTTY then
		if variant == 0 then--Normal clotty
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/clotty_wax.png")
		elseif variant == 1 then--Tar clot
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/clot_wax.png")
		elseif variant == 2 then--I blob
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/lblob_wax.png")
		elseif variant == 3 then--Grilled clotty
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/grilledclotty_wax.png")
		end

	elseif id == EntityType.ENTITY_VIS then
		if variant == 0 then--Normal vis
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/vis_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/vis_wax.png")
		elseif variant == 1 then--Doble vis
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/doublevis_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/doublevis_wax.png")
		elseif variant == 2 then--Chubber
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/chubber_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/chubber_wax.png")
		end

	elseif id == EntityType.ENTITY_DANNY then
		if variant == 0 then--Danny
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/danny_body_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/danny_wax.png")
		elseif variant == 1 then--Coal boy
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/coalboy_body_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/coalboy_wax.png")
		end
		
	elseif id == EntityType.ENTITY_GURGLE then
		if variant == 0 then--Gurgle
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/gurgle_body_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/gurgle_wax.png")
		end

	elseif id == EntityType.ENTITY_HIVE then
		if variant == 0 then--Hive
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/hive_wax.png")
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/generic_body2_wax.png")
		elseif variant == 1 then--DHive
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/drownedhive_wax.png")
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/generic_body2_wax.png")
		elseif variant == 2 then--Holy
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/holy_mulligan_wax.png")
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/generic_body_wax.png")
		end
		
	elseif id == EntityType.ENTITY_NEST then
		if variant == 0 then--Nest
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/nest_wax.png")
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/generic_body2_wax.png")
		end

	elseif id == EntityType.ENTITY_BONY then
		if variant == 0 then--Bony
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/bonye_body_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/boney_wax.png")
		elseif variant == 1 then--HBony
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/holy_bony_body_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/holy_bony_wax.png")
		end
	elseif id == EntityType.ENTITY_BLACK_BONY then
		if variant == 0 then--BBony
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/blackboney_wax.png")
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/bonye_body_wax.png")
		end
		
	elseif id == EntityType.ENTITY_BLASTER then
		if variant == 0 then--Blaster
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/blaster_wax.png")
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/blaser_body_wax.png")
		end

	elseif id == EntityType.ENTITY_DOPLE then
		if variant == 0 then--Dople
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/generic_body2_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/doble_wax.png")
		elseif variant == 1 then--Evil twin
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/eviltwin_wax.png")
			sprite:ReplaceSpritesheet(1, "hc/gfx/monsters/wax_friends/eviltwin_wax.png")
			sprite:ReplaceSpritesheet(2, "hc/gfx/monsters/wax_friends/eviltwin_wax.png")
		end
		
	elseif id == EntityType.ENTITY_MAW then
		if variant == 0 then--Maw
			sprite:ReplaceSpritesheet(0, "hc/gfx/monsters/wax_friends/maw_wax.png")
		end

	end

	enemy:GetData().OriginalHP = enemy.HitPoints
	sprite:LoadGraphics()
	sprite.Color = Color.Default
end

function mod:WaxDeath(entity)
    if entity:GetData().IsTrueWax_HC then
		local chance = mod.TvenusConsts.DEFAULT_CHANCE
		if rng:RandomFloat() < chance then
			local heart = mod:SpawnEntity(mod.Entity.BlazeHeart, entity.Position, Vector.Zero, nil)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.WaxDeath)

--Check how many willos should the player have
local function IsLocustOfPlayer(willo, player)
	local source = willo.Parent or willo.Player or willo.SpawnerEntity
	local r = player and source and (mod:PlayerId(source:ToPlayer()) == mod:PlayerId(player))
	return r
end
function mod:WilloCheck(player)

	local willos = mod:FindByTypeMod(mod.Entity.Willo)

	local nWillosReal = mod:GetBlazeHearts(player) --How many willos should be

	local nWillos = 0 --How many willos are in room
	for _, willo in ipairs(willos) do
		if IsLocustOfPlayer(willo, player) then
			nWillos = nWillos + 1
		end
	end

	if nWillos > nWillosReal then --If there are more than there should be
		for i, willo in ipairs(willos) do
			if IsLocustOfPlayer(willo, player) then
				if i>nWillosReal then
					willo:Remove()
				end
			end
		end
	elseif nWillos < nWillosReal then --If there are less that there should be
		for i = nWillos, nWillosReal-1 do
			local willo = mod:SpawnEntity(mod.Entity.Willo, player.Position, Vector.Zero, player):ToFamiliar()
			willo:Update()
			willo.Parent = player
			willo.Player = player
		end
	end

	mod:scheduleForUpdate(function()
		for i, willo in ipairs(willos) do
			if willo then
				local sprite = willo:GetSprite()
				sprite:Load("hc/gfx/familiar_BlazingLocust.anm2", true)
				sprite:Play("Fly", true)

				sprite.Color = Color.Default
			end
		end
	end, 2)

end
function mod:CheckAllWillos()
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			mod:WilloCheck(player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckAllWillos)

--HEART RENDER
local blaze_sprite = Sprite()
blaze_sprite:Load("hc/gfx/ui/blaze_heart.anm2", true)
blaze_sprite:Play("HeartFull")
local s_offset = 12

function mod:BlazeRenderHealth(offset, sprite, position, scale, player)

	local n_hearts = mod:GetPlayerHearts(player)

	local nWillosReal = mod:GetBlazeHearts(player)
	nWillosReal = math.min(n_hearts, nWillosReal)

	for i=0, nWillosReal-1 do
		local last_index = n_hearts - i

		local x = (last_index-1)%6
		local y = math.floor((last_index-1)/6)

		if player:GetPlayerType() == PlayerType.PLAYER_ESAU and player:GetOtherTwin() then
			blaze_sprite:Render(position+Vector(-x*s_offset+1, y*s_offset-y*2))
		else
			blaze_sprite:Render(position + Vector(s_offset*x,(s_offset-2)*y))
		end
	end
end
function mod:CheckBlazeHeartRender()
	mod:RemoveCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, mod.BlazeRenderHealth)
	
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			local n_blaze_hearts = mod:GetBlazeHearts(player)
			if n_blaze_hearts > 0 then
				mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, mod.BlazeRenderHealth)
				return true
			end
		end
	end
end
mod.SaveManager.AddCallback(mod.SaveManager.Utility.CustomCallback.POST_DATA_LOAD, mod.CheckBlazeHeartRender)

--CACHE
function mod:OnVenusCache(player, cacheFlag)

    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		local numItem = player:GetCollectibleNum(mod.Items.Venus)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)

		player:CheckFamiliar(mod.EntityInf[mod.Entity.FamiliarCandle].VAR, numFamiliars, player:GetCollectibleRNG(mod.Items.Venus), Isaac.GetItemConfig():GetCollectible(mod.Items.Venus))
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnVenusCache)

--CALLBACKS
function mod:AddTVenusCallbacks()
	mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnVenusUpdate, 0)
	mod:RemoveCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnEnemyDeathCandle)

	mod:RemoveCallback(ModCallbacks.MC_POST_NPC_INIT, mod.WaxSummon)
	mod:RemoveCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.WaxSummon)
	mod:RemoveCallback(ModCallbacks.MC_POST_LASER_INIT, mod.WaxSummon)

	mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,  mod.OnWaxFriendDamage)

	if mod:SomebodyHasItem(mod.Items.Venus) then
		mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnVenusUpdate, 0)
		mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnEnemyDeathCandle)

		mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.WaxSummon)
		mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.WaxSummon)
		mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.WaxSummon)

		mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,  mod.OnWaxFriendDamage)
	end
end
mod:AddTVenusCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTVenusCallbacks, mod.Items.Venus)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTVenusCallbacks)