local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

mod.EntityVoidSub = 370


mod.voidConsts = {
    BOMB_CHANCE = 0.001,
    KEY_CHANCE = 0.001,
    HEART_CHANCE = 0.001,
    COIN_CHANCE = 0.0005,
    BATTERY_CHANCE = 0.005,

    CHEST_CHANCE = 0.0025,
    SACK_CHANCE = 0.005,

    CARD_CHANCE = 0.00333,
    PILL_CHANCE = 0.00333,
    RUNE_CHANCE = 0.00333,
}

--Evil particles
function mod:OnVoidPickupUpdate(pickup, forced)
    local var = pickup.Variant
    if (pickup.SubType == mod.EntityVoidSub and (var == 10 or var == 20 or var == 30 or var == 40 or var == 50 or var == 69 or var == 300 or var == 90)) or forced then
        local sprite = pickup:GetSprite()
        if sprite:IsPlaying("Idle") then
            local velocity = mod:RandomVector()*4
            local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, pickup.Position+Vector(0,-5), velocity, pickup):ToEffect()
            particle.SpriteScale = Vector.One*0.75
            --particle.DepthOffset = 20

            particle:SetColor(Color(0,0,0,1), -1, 99, true, true)

            if pickup.Variant == PickupVariant.PICKUP_COIN then
                particle.Position = particle.Position + Vector(0, 3)
            elseif pickup.Variant == PickupVariant.PICKUP_HEART then
                particle.Position = particle.Position + Vector(-1, -2)
            elseif pickup.Variant == PickupVariant.PICKUP_CHEST then
                particle.Position = particle.Position + Vector(0, -10)
                particle.Velocity = particle.Velocity*1.5
                particle.SpriteScale = Vector.One*1.0
            elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
                particle.Position = particle.Position + Vector(0, -3)

            end
        end

        if sprite:IsFinished("Collect") then
            pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidPickupUpdate)
--[[mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup.SubType == mod.VoidConsumables[1] or pickup.SubType == mod.VoidConsumables[2] or pickup.SubType == mod.VoidConsumables[3] then
        mod:OnVoidPickupUpdate(pickup, true)
    end
end, PickupVariant.PICKUP_TAROTCARD)]]


include("scripts.items.solaritems.pickups.voidcoin")
--include("scripts.items.solaritems.pickups.voidsack")
include("scripts.items.solaritems.pickups.voidbattery")
--include("scripts.items.solaritems.pickups.voidconsumables")
include("scripts.items.solaritems.pickups.voidheart")
--include("scripts.items.solaritems.pickups.voidchest")
include("scripts.items.solaritems.pickups.voidbomb")
include("scripts.items.solaritems.pickups.voidkey")

function mod:SpawnAllVoids()
    
		Isaac.ExecuteCommand("spawn abyssal h")
		Isaac.ExecuteCommand("spawn abyssal p")
		Isaac.ExecuteCommand("spawn abyssal k")
		Isaac.ExecuteCommand("spawn abyssal bomb (")
		Isaac.ExecuteCommand("spawn abyssal c")
		Isaac.ExecuteCommand("spawn abyssal s")
		Isaac.ExecuteCommand("spawn abyssal ba")
        mod.lockVoidRerroll = true
		Isaac.ExecuteCommand("spawn 5.300."..tostring(Isaac.GetCardIdByName("Void Card")))
        mod.lockVoidRerroll = true
		Isaac.ExecuteCommand("spawn 5.300."..tostring(Isaac.GetCardIdByName("Void Pill")))
        mod.lockVoidRerroll = true
		Isaac.ExecuteCommand("spawn 5.300."..tostring(Isaac.GetCardIdByName("Void Rune")))
end