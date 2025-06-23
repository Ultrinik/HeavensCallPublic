local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--Telescope-------------------------------------------------------------------------------------------------------------------------
mod.telescopeTrinkets = {}
function mod:AddTrinketToTelescope(trinket)
	for i, t in ipairs(mod.telescopeTrinkets) do
		if t == trinket then
			return
		end
	end
	table.insert(mod.telescopeTrinkets, trinket)
end
mod:AddTrinketToTelescope(TrinketType.TRINKET_TELESCOPE_LENS)
mod:AddTrinketToTelescope(TrinketType.TRINKET_FRAGMENTED_CARD)
mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Sputnik"))
mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Faded Flag"))

if ANDROMEDA then
	local function AddAndromedaTrinkets()
		local variant = PickupVariant.PICKUP_TRINKET
	
		--[[
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Stardust"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Stardust"))
		end
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Meteorite"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Meteorite"))
		end
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Moon Stone"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Moon Stone"))
		end
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Polaris"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Polaris"))
		end
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Sextant"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Sextant"))
		end
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Alien Transmitter"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Alien Transmitter"))
		end
		]]
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Crying Pebble"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Crying Pebble"))
		end
		if ANDROMEDA:IsItemUnlocked(Isaac.GetTrinketIdByName("Eye of Spode"), variant) then
			mod:AddTrinketToTelescope(Isaac.GetTrinketIdByName("Eye of Spode"))
		end
	end
	AddAndromedaTrinkets()
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, AddAndromedaTrinkets)
end

mod.TRewards = {
	[1] = "MOON",
	[2] = "WISP",
	[3] = "ASTRAL",
	[4] = "RETROGRADE",
	[5] = "SOUL",
	[6] = "HALF_SOUL",
	[7] = "BLAZE",
	[8] = "EXPLODE",
	[9] = "GLASS_HEART",
	[10] = "NOTHING",
}
--                   		MOON    WISP    ASTRAL 	RETRO   SOUL    HSOUL   BLAZE   EXPLO   GLASS	NOTHING	
mod.TelescopeChain = 		{7,  	12,		5,		5,		5,		5,		5,		5,		5,		104}
mod.TelescopeChain = mod:NormalizeList(mod.TelescopeChain)
mod.LuckyTelescopeChain = 	{14, 	18, 	8, 		7, 		8, 		7, 		8, 		10, 	7, 		100}
mod.LuckyTelescopeChain = mod:NormalizeList(mod.LuckyTelescopeChain)

function mod:SpawnTelescopeReward(slot)
	local chain = mod.TelescopeChain
	local data = slot:GetData()

	local player = data.Player
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
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


	if reward == "NOTHING" and mod:ExtraMoonRoll(player) then
		reward = "MOON"
	end

	if reward ~= "NOTHING" then
		slot:SetColor(mod.Colors.jupiterLaser2, 10, 1, true, false)
		sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1, 0, false, 2)
	end


	if reward == "MOON" then--Moon
		local moon = mod:ChooseMiniMoon(player)
		if moon == -1 then
			local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, player.Position + Vector(25,0):Rotated(rng:RandomFloat()*360), Vector.Zero, nil)
		else
			player:AddCollectible(moon)
		end

	elseif reward == "WISP" then
		player:AddWisp(1, player.Position)

	elseif reward == "ASTRAL" then
		player:AddItemWisp(mod:GetAstralCollectible(), player.Position)

	elseif reward == "RETROGRADE" then
		local item = mod:random_elem(mod.TelescopeItems)
		if mod:IsItemActive(item) then
			local n = 0
			if item == mod.Items.Saturnus then
				n = 4
			elseif item == mod.Items.Mars then
				n = 2
			end
			for i=1, n do
				mod:AddItemSpark(player, item)
			end
		else
			player:AddItemWisp(item, player.Position)
		end

	elseif reward == "SOUL" then
		local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, slot.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)
	
	elseif reward == "BLAZE" then
		local pickup = mod:SpawnEntity(mod.Entity.BlazeHeart, slot.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)

	elseif reward == "HALF_SOUL" then
		local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, slot.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)

	elseif reward == "EXPLODE" then
		game:BombExplosionEffects (slot.Position, 0, TearFlags.TEAR_NORMAL, mod.Colors.jupiterLaser2, nil, 0.01, true, false, DamageFlag.DAMAGE_EXPLOSION )
		local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, slot.Position, Vector.Zero, nil)
		explosion:GetSprite().Color = mod.Colors.jupiterLaser2
		data.Ended = true
	end
end

function mod:TelescopeUpdate(slot)
	if slot.SubType == mod.EntityInf[mod.Entity.Telescope].SUB then
		local sprite = slot:GetSprite()
		local data = slot:GetData()

		if not data.Init then
			data.Init = true

			slot.HitPoints = 1

			data.Uses = 0

			data.TouchFrame = 0
			data.OldTouchFrame = 0
		end

		if data.TouchFrame == data.OldTouchFrame then
			data.TouchFrame = 0
		end
		data.OldTouchFrame = data.TouchFrame

		sprite.PlaybackSpeed = 1 + math.min(data.TouchFrame,90)/90 * 2

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
				data.PrizeDone = false
				sprite:Play("Idle", true)

			elseif data.Uses > 0 and sprite:IsPlaying("Idle") and data.Player then
				data.Uses = data.Uses - 1
				sprite:Play("Wiggle", true)
				sfx:Play(SoundEffect.SOUND_COIN_SLOT)
			end

			if sprite:IsEventTriggered("Sound") then
				sfx:Play(SoundEffect.SOUND_DOGMA_LIGHT_APPEAR, 0.5, 0, false, 3)

			elseif (not data.PrizeDone) and sprite:WasEventTriggered("Prize") then
				data.PrizeDone = true
				mod:SpawnTelescopeReward(slot)
			end

			mod:CheckSlotContact(slot, mod.OnTelescopeCollide)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.TelescopeUpdate, mod.EntityInf[mod.Entity.Telescope].VAR)

function mod:OnTelescopeCollide(slot, player)
	local sprite = slot:GetSprite()
	local data = slot:GetData()
	if sprite:IsPlaying("Idle") and player:GetNumCoins() > 0 then
		player:AddCoins(-1)
		data.Player = player
		data.Uses = data.Uses + 1
	end

	if tmmc then
		data.TouchFrame = data.TouchFrame + 1
	end
end
function mod:OnTelescopeBreak(slot)
	local data = slot:GetData()
		
	local bonus = 0
	if data.Player and data.Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
		bonus = 0.15
	end

	local roll = rng:RandomFloat()
	if (roll < 0.15 + bonus) then
		local item = game:GetItemPool():GetCollectible(Isaac.GetPoolIdByName("telescope HC"), false)
		local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, slot.Position, Vector.Zero, nil)

	elseif (roll < 0.65 + bonus) then
		local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod:GetTrinketFromList(mod.telescopeTrinkets), slot.Position, mod:RandomVector(10), nil)
	end
end

function mod:TelescopeReplacement()

	if game:GetRoom():IsFirstVisit() then
		for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.FORTUNE_TELLING_MACHINE)) do
			if rng:RandomFloat() < mod:TelescopeChance() then
				local telescope = mod:SpawnEntity(mod.Entity.Telescope, slot.Position, Vector.Zero, nil)
				slot:Remove()
			end
		end
	end
end

--death
function mod:SlotDropTelescope(slot)
	if slot.SubType == mod.EntityInf[mod.Entity.Telescope].SUB then
		slot.HitPoints = 0
		if slot:GetData().Ended then
			mod:OnTelescopeBreak(slot)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.SlotDropTelescope, mod.EntityInf[mod.Entity.Telescope].VAR)