local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.InfinityChestConsts = {
    CHEST_CHANCE = 1/4103,
}

local infinityChestFlag = false
function mod:OnInfinityChestInit(chest)
    if chest.SubType == mod.EntityVoidSub+1 and game:GetRoom():GetFrameCount() <= 0 and not infinityChestFlag then
        infinityChestFlag = true
        local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub+1, chest.Position, Vector.Zero, nil):ToPickup()
        newChest.Wait = 60

        chest.Wait = 60
        chest.Position = Vector.Zero
        chest:Remove()
        chest:Update()
    end
    infinityChestFlag = false
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnInfinityChestInit, PickupVariant.PICKUP_CHEST)

function mod:OnInfinityChestLoot(chest, shouldAdvance)
    if chest.Variant == PickupVariant.PICKUP_CHEST and chest.SubType == mod.EntityVoidSub+1 then
        local lootList = LootList()
        lootList:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub+1, chest.InitSeed)
        return lootList
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_GET_LOOT_LIST, mod.OnInfinityChestLoot)

function mod:OnInfinityChestUpdate(chest)

    if chest.SubType == mod.EntityVoidSub+1 then
        local sprite = chest:GetSprite()

        if sprite:IsEventTriggered("DropSound") then

        elseif sprite:IsFinished("Open") then
            sprite:Play("Opened", true)

        end

        
        if false and sprite:GetAnimation() == "Idle" and chest.FrameCount%10==0 then
            local x = mod:RandomInt(-15, 15)
            local y = mod:RandomInt(-25, -18)
            local position = chest.Position + Vector(x, y)
            local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ULTRA_GREED_BLING, 0, position, Vector.Zero, chest)

            shine:GetSprite().PlaybackSpeed = 0.3
            shine:GetSprite().Color = Color(1,1,1,1,0,1,1)
            shine.DepthOffset = 50
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnInfinityChestUpdate, PickupVariant.PICKUP_CHEST)

--[[
function mod:OnInfinityChestCollide(pickup, player)
    mod:InfinityChestOpen(pickup)
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub+1 then
        if collider:ToPlayer() then
            mod:OnInfinityChestCollide(pickup, collider:ToPlayer())
        end
        
        return false
    end
end, PickupVariant.PICKUP_CHEST)

function mod:InfinityChestOpen(pickup)

    local sprite = pickup:GetSprite()
    if sprite:GetAnimation() == "Idle" then
        pickup:GetSprite():Play("Open", true)
    
        local velocity = mod:RandomVector(10,10)
        local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub+1, pickup.Position, velocity, pickup)
    
        newChest.SpriteScale = pickup.SpriteScale * 0.90
        newChest:SetSize(newChest.SpriteScale.X, Vector.One, 12)

        return true
    else
        return false
    end
    
end

function mod:DestroyOnActive()
    local flag = false
    for i, chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub+1)) do
        if flag then chest:Remove() end
        flag = true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.DestroyOnActive, CollectibleType.COLLECTIBLE_D20)
]]--


function mod:OnInfinityChestSpawn(pickup, variant, subType)
    if pickup and pickup.SubType ~= mod.EntityVoidSub+1 then
        --avoid FF chest overwrite
        if FiendFolio and FiendFolio.getFieldInit and FiendFolio.savedata then
            local chestseed = tostring(pickup.InitSeed)
            local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
            d.chestRerollCheck = true
            d.chestReplaced = true
        end

        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub+1, pickup.InitSeed)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub+1}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_CHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_BOMBCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_SPIKEDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_MIMICCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_WOODENCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_HAUNTEDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_LOCKEDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnInfinityChestSpawn, {"infinity_chest (HC)", mod.InfinityChestConsts.CHEST_CHANCE, PickupVariant.PICKUP_REDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub+1})
