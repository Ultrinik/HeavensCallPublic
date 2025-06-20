local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()


function mod:OnVoidBatteryUpdate(battery)

    if battery.SubType == mod.EntityVoidSub then
        local sprite = battery:GetSprite()

        if sprite:IsEventTriggered("DropSound") then
            sfx:Play(SoundEffect.SOUND_SCAMPER)

        elseif sprite:IsPlaying("Collect") then
            battery.Velocity = Vector.Zero

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidBatteryUpdate, PickupVariant.PICKUP_LIL_BATTERY)

function mod:OnVoidBatteryCollide(pickup, player, slot)
    slot = slot or 0

    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.Velocity = Vector.Zero
    pickup.TargetPosition = pickup.Position

    mod:VoidCharge(pickup, player, slot)

    local sprite = pickup:GetSprite()
    sprite:Play("Collect", true)

    sfx:Play(mod.SFX.VoidPickup)
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            local player = collider:ToPlayer()
            for slot=0, 2 do
                local condition = (not player:NeedsCharge(slot)) and (player:GetActiveItem(slot) > 0) and Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(slot)).MaxCharges > 0
                if condition then
                    mod:OnVoidBatteryCollide(pickup, collider:ToPlayer(), slot)
                    break
                end
            end
        end
        
        return false
    end
end, PickupVariant.PICKUP_LIL_BATTERY)

function mod:VoidCharge(pickup, player, slot)

    player:DischargeActiveItem(slot)

    sfx:Play(SoundEffect.SOUND_BATTERYDISCHARGE)
    local notify = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 3, pickup.Position+Vector(0,-40), Vector.Zero, nil):ToEffect()
    notify.DepthOffset = 500

    local item = player:GetActiveItem(slot)
    for i=1, 5 do
        mod:AddItemSpark(player, item, nil, nil, mod:CheckIsStellarItemSpecial(item), true)
    end
    
end



function mod:OnVoidBatterySpawn(pickup, variant, subType)
    
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidBatterySpawn, {"void_pickups_A (HC)", mod.voidConsts.BATTERY_CHANCE, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL, mod.EntityVoidSub})
