local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.TiRewards = {
    PRIZE = 1,
    NO_PRIZE = 2,
    FINAL_PRIZE = 3
}
--                   	 PRIZE  NOPRIZE     FINALPRIZE
mod.TitanChain = 		{0.25,  0.8,        0.025		    }
mod.TitanChain = mod:NormalizeList(mod.TitanChain)

mod.TitanConsts = {
    TITAN_CHANCE = 0.1,
    TITAN_COINS = Vector(1,7),

    LUCKY_REROLL_CHANCE = 0.5,

    TRINKET_CHANCE = 0.5,

}

function mod:SpawnTitanReward(slot)
	local chain = mod.TitanRewards
	local data = slot:GetData()

    if rng:RandomFloat() < mod.TitanConsts.TRINKET_CHANCE then
        local trinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, slot.Position, mod:RandomVector(1,6), nil):ToPickup()
        trinket:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket.SubType | TrinketType.TRINKET_GOLDEN_FLAG)
    else

        local variant
        local subtype

        local r = mod:RandomInt(1,5)
        if r==1 then
            variant = PickupVariant.PICKUP_HEART
            subtype = HeartSubType.HEART_GOLDEN
        elseif r==2 then
            variant = PickupVariant.PICKUP_KEY
            subtype = KeySubType.KEY_GOLDEN
        elseif r==3 then
            variant = PickupVariant.PICKUP_BOMB
            subtype = BombSubType.BOMB_GOLDEN
        elseif r==4 then
            variant = PickupVariant.PICKUP_PILL
            subtype = PillColor.PILL_GOLD
        elseif r==5 then
            variant = PickupVariant.PICKUP_LIL_BATTERY
            subtype = BatterySubType.BATTERY_GOLDEN
        end

        local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, subtype, slot.Position, mod:RandomVector(1,6), nil)
    end

end

mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.titan_demand", 1)
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.titan_killed", false)
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.titan_hidden", true)

local titanUncover = function (slot, sprite, data)
    if data.Hidden then
        mod.savedatarun().titan_hidden = false
        data.Hidden = false

        sfx:Play(SoundEffect.SOUND_SUMMON_POOF, 1, 2, false, 1)

        sprite:Load("hc/gfx/slot_Titan.anm2", true)

        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, slot.Position + Vector(5,0), Vector.Zero, nil)
        poof.DepthOffset = 100
    end
end

function mod:TitanUpdate(slot)
    if slot.SubType == mod.EntityInf[mod.Entity.Titan].SUB then
        local sprite = slot:GetSprite()
        local data = slot:GetData()

        if not data.Init then
            data.Init = true

            slot.HitPoints = 1

            data.Uses = 0

            data.Damned = false

            data.TouchFrame = 0
            data.OldTouchFrame = 0

            data.InactiveFrames = -1

            data.Hidden = false
            data.EID = false
            if mod.savedatarun().titan_hidden then
                data.Hidden = true
                sprite:Load("hc/gfx/slot_TitanHidden.anm2", true)
                sprite:Play("Idle", true)
            end
        end

        if data.TouchFrame == data.OldTouchFrame then
            data.TouchFrame = 0
        end
        data.OldTouchFrame = data.TouchFrame

        sprite.PlaybackSpeed = 1 + math.min(data.TouchFrame,90)/90 * 2

        if slot.HitPoints <= 0  then
            if sprite:GetAnimation() ~= "Death" then
                titanUncover(slot, sprite, data)
                sprite:Play("Death", true)

            elseif sprite:IsFinished("Death") then
                --dissapear
                slot:Remove()
            end
        else
            if sprite:IsFinished("Initiate") then
                sprite:Play("Wiggle", true)

            elseif sprite:IsFinished("Wiggle") then
                local reward_func = function()
                    if rng:RandomFloat() < mod.TitanChain[mod.TiRewards.FINAL_PRIZE] then
                        titanUncover(slot, sprite, data)
                        sprite:Play("FinalPrize", true)
                        return true
                    elseif rng:RandomFloat() < mod.TitanChain[mod.TiRewards.PRIZE] then
                        sprite:Play("Prize", true)
                        return true
                    else
                        sprite:Play("NoPrize", true)
                        return false
                    end
                end

                local player = data.Player
                local result = reward_func()
                if (not result) and (player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) and rng:RandomFloat() < mod.TitanConsts.LUCKY_REROLL_CHANCE) then
                    reward_func()
                end

                if not data.Hidden then
                    sfx:Play(SoundEffect.SOUND_MOTHER_SHOOT, 0.8,2,false, 3)
                end

            elseif sprite:IsFinished("NoPrize") then
                sprite:Play("Idle", true)

            elseif sprite:IsFinished("FinalPrize") then
                --final price and dissapear
                local item = game:GetItemPool():GetCollectible(Isaac.GetPoolIdByName("titan HC"), false)
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, slot.Position, Vector.Zero, nil)

                slot:Remove()
                sfx:Play(SoundEffect.SOUND_SLOTSPAWN)

            elseif sprite:IsFinished("Reveal") then
                sprite:Play("Idle", true)

            elseif sprite:IsFinished("Damn") then
                sprite:Play("Idle", true)

            elseif sprite:IsFinished("Prize") then
                data.PrizeDone = false
                sprite:Play("Idle", true)

            elseif data.Uses > 0 and sprite:IsPlaying("Idle") and data.Player then
                data.Uses = data.Uses - 1
                sprite:Play("Initiate", true)
            end

            if sprite:IsEventTriggered("Sound") then
                sfx:Play(Isaac.GetSoundIdByName("Chomp"), 0.4,0,false,1.5)

            elseif sprite:IsEventTriggered("Sound") then
                sfx:Play(mod.SFX.Shine, 0.67, 2, false, 2)

            elseif (not data.PrizeDone) and sprite:WasEventTriggered("Prize") then
                data.PrizeDone = true
                mod:SpawnTitanReward(slot)
                sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
            end

            mod:CheckSlotContact(slot, mod.OnTitanCollide)

            if sprite:IsPlaying("Idle") then

                if not data.Damned then
                    local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
                    for i, bomb in ipairs(bombs) do
                        if bomb.Position:Distance(slot.Position) <= mod:getBombRadius(bomb) then
                            titanUncover(slot, sprite, data)
                            sprite:Play("Damn", true)
                            data.Damned = true
                            return
                        end
                    end
                end

                if data.Hidden then
                    if data.InactiveFrames > -1 then
                        data.InactiveFrames = math.max(0, data.InactiveFrames + 1)
                    end
                    local player = data.Player
                    if data.InactiveFrames > 60 or player and slot.Position:Distance(player.Position) > 120 then
                        titanUncover(slot, sprite, data)
                        sprite:Play("Reveal", true)
                    end
                end
            end
        end
        
        if (not data.EID) and (not data.Hidden) then
            data.EID = true

            if Options.Language == "es" then
                data["EID_Description"] = "#{{Coin}} Toma una cantidad creciente de monedas # Puede recompensarte con objetos y baratijas doradas."
            else
                data["EID_Description"] = "#{{Coin}} Takes an increasing number of coins # Can reward you with golden pickups and trinkets."
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.TitanUpdate, mod.EntityInf[mod.Entity.Titan].VAR)

function mod:OnTitanCollide(slot, player)
	local sprite = slot:GetSprite()
	local data = slot:GetData()

    local cost = mod.savedatarun().titan_demand or 1

	if sprite:IsPlaying("Idle") and player:GetNumCoins() >= cost then

        sfx:Play(SoundEffect.SOUND_SCAMPER)
        data.InactiveFrames = 0

        --print("current titan cost:", cost)
        --player:AddCoins(999)

		player:AddCoins(-cost)

        mod.savedatarun().titan_demand = cost + 1

		data.Player = player
		data.Uses = data.Uses + 1
	end

	if tmmc then
        data.TouchFrame = data.TouchFrame or 0
		data.TouchFrame = data.TouchFrame + 1
	end
end
function mod:OnTitanBreak(slot)
    sfx:Play(SoundEffect.SOUND_WHEEZY_COUGH, 1, 2, false, 0.76)
	local data = slot:GetData()

	for i=1, mod:RandomInt(mod.TitanConsts.TITAN_COINS.X,mod.TitanConsts.TITAN_COINS.Y) do
        local penny = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, slot.Position, mod:RandomVector(1,6), nil)
    end
end

function mod:TitanReplacement()

    if not (mod.savedatasettings().UnlockAll or Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("titan (HC)"))) then return end
    if mod.savedatarun().titan_killed then return end

	if game:GetRoom():IsFirstVisit() then
		for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.BEGGAR)) do
			if rng:RandomFloat() < mod.TitanConsts.TITAN_CHANCE then
				local titan = mod:SpawnEntity(mod.Entity.Titan, slot.Position, Vector.Zero, nil)
                titan:Update()
				slot:Remove()
			end
		end
	end
end

--death
function mod:SlotDropTitan(slot)
	if slot.SubType == mod.EntityInf[mod.Entity.Titan].SUB then
        mod.savedatarun().titan_killed = true
		slot.HitPoints = 0
		mod:OnTitanBreak(slot)
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.SlotDropTitan, mod.EntityInf[mod.Entity.Titan].VAR)