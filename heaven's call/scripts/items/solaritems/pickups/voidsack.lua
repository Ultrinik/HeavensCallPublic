local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

function mod:OnVoidSackUpdate(sack)

    if sack.SubType == mod.EntityVoidSub then
        local sprite = sack:GetSprite()
        local data = sack:GetData()

        if sprite:IsEventTriggered("DropSound") then

        elseif sprite:IsEventTriggered("Sound") then
            data.n = data.n or 0
            sfx:Play(mod.SFX.Effigy+data.n)
            data.n = data.n+1

        elseif sprite:IsPlaying("Collect") then
            sack.Velocity = Vector.Zero

        elseif sprite:IsFinished("Collect") then
            local randoms = mod:RerrolAmounts()
            sfx:Play(SoundEffect.SOUND_DOGMA_JACOBS_ZAP)

            -- Loop for coins
            local i = 1
            while i <= randoms[1] do
                local subtype = CoinSubType.COIN_PENNY
                if i <= randoms[1] - 2 and rng:RandomFloat() < 0.5 then
                    subtype = CoinSubType.COIN_DOUBLEPACK
                    i = i + 2
                elseif i <= randoms[1] - 5 and rng:RandomFloat() < 0.5 then
                    subtype = CoinSubType.COIN_NICKEL
                    i = i + 5
                elseif i <= randoms[1] - 10 and rng:RandomFloat() < 0.5 then
                    subtype = CoinSubType.COIN_DIME
                    i = i + 10
                else
                    i = i + 1
                end
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, subtype, sack.Position, mod:RandomVector() * 5, nil)
            end

            -- Loop for bombs
            i = 1
            while i <= randoms[2] do
                local subtype = BombSubType.BOMB_NORMAL
                if i <= randoms[2] - 2 and rng:RandomFloat() < 0.5 then
                    subtype = BombSubType.BOMB_DOUBLEPACK
                    i = i + 2
                else
                    i = i + 1
                end
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, subtype, sack.Position, mod:RandomVector() * 5, nil)
            end

            -- Loop for keys
            i = 1
            while i <= randoms[3] do
                local subtype = KeySubType.KEY_NORMAL
                if i <= randoms[3] - 2 and rng:RandomFloat() < 0.5 then
                    subtype = KeySubType.KEY_DOUBLEPACK
                    i = i + 2
                else
                    i = i + 1
                end
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, subtype, sack.Position, mod:RandomVector() * 5, nil)
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidSackUpdate, PickupVariant.PICKUP_GRAB_BAG)

function mod:OnVoidSackCollide(pickup, player)
    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.Velocity = Vector.Zero
    pickup.TargetPosition = pickup.Position


    local sprite = pickup:GetSprite()
    sprite:Play("Collect", true)

    sfx:Play(mod.SFX.VoidPickup)
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            mod:OnVoidSackCollide(pickup, collider:ToPlayer())
        end
        return false
    end
end, PickupVariant.PICKUP_GRAB_BAG)

function mod:RerrolAmounts()
    local player = Isaac.GetPlayer(0)

    local num1 = math.min(99, player:GetNumCoins())
    local num2 = player:GetNumKeys()
    local num3 = player:GetNumBombs()
    local num4 = mod:GetBismuth()

    local total_sum = num1 + num2 + num3 + num4
    total_sum = math.ceil(total_sum*1.5)

    player:AddCoins(-99)
    player:AddKeys(-99)
    player:AddBombs(-99)
    mod:AddBismuth(-99)

    local randoms = {}
    randoms[1] = mod:RandomInt(0, math.ceil(total_sum * 0.33))
    randoms[2] = mod:RandomInt(0, math.max(0, total_sum - randoms[1] * 2))
    randoms[3] = total_sum - randoms[1] - randoms[2]

    return mod:Shuffle(randoms)
end


function mod:OnVoidSackSpawn(pickup, variant, subType)
    
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidSackSpawn, {"void_pickups_A (HC)", mod.voidConsts.SACK_CHANCE, PickupVariant.PICKUP_GRAB_BAG, SackSubType.SACK_NORMAL, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidSackSpawn, {"void_pickups_A (HC)", mod.voidConsts.SACK_CHANCE, PickupVariant.PICKUP_GRAB_BAG, SackSubType.SACK_BLACK, mod.EntityVoidSub})
