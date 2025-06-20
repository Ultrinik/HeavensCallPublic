local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

function mod:CoinCollisionBismuth(pickup, collider)
    local player = collider:ToPlayer()
    if player and player:HasTrinket(mod.Trinkets.BismuthPenny) then
        local coin_value = 1

        if pickup.SubType == CoinSubType.COIN_NICKEL or pickup.SubType == CoinSubType.COIN_STICKYNICKEL then
            coin_value = 5
        elseif pickup.SubType == CoinSubType.COIN_DIME then
            coin_value = 10
        elseif pickup.SubType == CoinSubType.COIN_DOUBLEPACK then
            coin_value = 2
        end

        local final_coin_chance = 1 - (1-mod.bismuthConsts.COIN_CHANCE)^coin_value

        local final_trinket_chance = 1 - (1-final_coin_chance)^player:GetTrinketMultiplier(mod.Trinkets.BismuthPenny)

        if rng:RandomFloat() < final_trinket_chance then
            local position = game:GetRoom():FindFreePickupSpawnPosition(pickup.Position)
            
            local idx = mod:RandomInt(0,2)
            local bismuth = mod:SpawnEntity(mod.Entity.BismuthOre, position, Vector.Zero, player, nil, mod.EntityInf[mod.Entity.BismuthOre].SUB+idx)
            local sprite = bismuth:GetSprite()
            if bismuth.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB then
                sprite:Play("Appear1", true)
            elseif bismuth.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+1 then
                sprite:Play("Appear2", true)
            elseif bismuth.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+2 then
                sprite:Play("Appear3", true)
            end
            bismuth:GetData().Init = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.CoinCollisionBismuth, PickupVariant.PICKUP_COIN)