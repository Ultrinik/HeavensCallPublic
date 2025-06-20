local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

function mod:OnVoidCoinUpdate(coin)

    if coin.SubType == mod.EntityVoidSub then
        local sprite = coin:GetSprite()

        if sprite:IsEventTriggered("DropSound") then
            sfx:Play(SoundEffect.SOUND_DIMEDROP)

        elseif sprite:IsEventTriggered("Gild") then
            coin.DepthOffset = 999999
            mod:GildEverythingCoin(coin)

        elseif sprite:IsPlaying("Collect") then
            coin.Velocity = Vector.Zero

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidCoinUpdate, PickupVariant.PICKUP_COIN)

function mod:OnVoidCoinCollide(pickup, player)
    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.Velocity = Vector.Zero
    pickup.TargetPosition = pickup.Position


    local sprite = pickup:GetSprite()
    sprite:Play("Collect", true)

    player:AddCoins(-999)

    sfx:Play(mod.SFX.VoidPickup)
    sfx:Stop(SoundEffect.SOUND_PENNYPICKUP)

    sfx:Play(SoundEffect.SOUND_ULTRA_GREED_TURN_GOLD_1)
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            mod:OnVoidCoinCollide(pickup, collider:ToPlayer())
        end
        return false
    end
end, PickupVariant.PICKUP_COIN)

function mod:GildEverythingCoin(vcoin)

    local room = game:GetRoom()
    room:TurnGold()

    game:SpawnParticles(vcoin.Position + Vector(0,-20), EffectVariant.GOLD_PARTICLE, 64, 12)
    vcoin:Remove()

    mod:GildEverything()

    mod:GildPlayerTrinkets()

    sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
end

function mod:GildEverything()
    local room = game:GetRoom()
    
    for _, _coin in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN)) do
        local coin = _coin:ToPickup()
        if coin and not (coin.SubType == CoinSubType.COIN_GOLDEN or coin.SubType == mod.EntityVoidSub or (FiendFolio and coin.SubType == Isaac.GetEntitySubTypeByName("Golden Cursed Penny"))) then
            coin:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN)
        end
    end
    for _, _key in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY)) do
        local key = _key:ToPickup()
        if key and key.SubType ~= KeySubType.KEY_GOLDEN then
            key:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN)
        end
    end
    for _, _bomb in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB)) do
        local bomb = _bomb:ToPickup()
        if bomb and not (bomb.SubType == BombSubType.BOMB_GOLDENTROLL or bomb.SubType == BombSubType.BOMB_GOLDEN) then
            if bomb.SubType == BombSubType.BOMB_TROLL then
                bomb:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDENTROLL)
            elseif bomb.SubType ~= BombSubType.BOMB_GIGA then
                bomb:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN)
            end
        end
    end
    for _, _trollbomb in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMB)) do
        local trollbomb = _trollbomb:ToBomb()
        if trollbomb and trollbomb.SubType ~= BombVariant.BOMB_GOLDENTROLL then
            if trollbomb.Variant == BombVariant.BOMB_TROLL or trollbomb.Variant == BombVariant.BOMB_SUPERTROLL then
                local newTrollbomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_GOLDENTROLL, 0, trollbomb.Position, trollbomb.Velocity, nil):ToBomb()
                newTrollbomb.ExplosionDamage = trollbomb.ExplosionDamage
                newTrollbomb.Flags = trollbomb.Flags
                newTrollbomb.IsFetus = trollbomb.IsFetus
                newTrollbomb.RadiusMultiplier = trollbomb.RadiusMultiplier

                trollbomb:Remove()
            end
        end
    end
    for _, _heart in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART)) do
        local heart = _heart:ToPickup()
        if heart and heart.SubType ~= HeartSubType.HEART_GOLDEN then
            heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN)
        end
    end
    for _, _battery in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY)) do
        local battery = _battery:ToPickup()
        if battery and battery.SubType ~= BatterySubType.BATTERY_GOLDEN then
            battery:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_GOLDEN)
        end
    end
    for _, _chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        local chest = _chest:ToPickup()
        if chest and (chest.Variant ~= PickupVariant.PICKUP_LOCKEDCHEST or chest.Variant ~= PickupVariant.PICKUP_MEGACHEST) then
            local variant = chest.Variant
            if variant == PickupVariant.PICKUP_CHEST or variant == PickupVariant.PICKUP_BOMBCHEST or variant == PickupVariant.PICKUP_SPIKEDCHEST or variant == PickupVariant.PICKUP_ETERNALCHEST or variant == PickupVariant.PICKUP_MIMICCHEST or variant == PickupVariant.PICKUP_OLDCHEST or variant == PickupVariant.PICKUP_WOODENCHEST or variant == PickupVariant.PICKUP_HAUNTEDCHEST or variant == PickupVariant.PICKUP_REDCHEST then
                chest:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, ChestSubType.CHEST_CLOSED)
            end
        end
    end
    for i, enemy in ipairs(Isaac.GetRoomEntities()) do
        if mod:IsVulnerableEnemy(enemy) then
            enemy:AddEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE)
            enemy:AddMidasFreeze(EntityRef(player), 9999)
        end
    end
    for _, _pill in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL)) do
        local pill = _pill:ToPickup()
        if pill and (pill.SubType ~= PillColor.PILL_GOLD or pill.SubType ~= PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG) then
            if pill.SubType & PillColor.PILL_GIANT_FLAG > 0 then
                pill:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG)
            else
                pill:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, PillColor.PILL_GOLD)
            end
        end
    end
    for _, _trinket in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        local trinket = _trinket:ToPickup()
        if trinket and not (trinket.SubType & TrinketType.TRINKET_GOLDEN_FLAG > 0) then
            trinket:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket.SubType | TrinketType.TRINKET_GOLDEN_FLAG)
        end
    end
    for _, _collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local collectible = _collectible:ToPickup()
        if collectible then
            if collectible.SubType == CollectibleType.COLLECTIBLE_TELEPORT then
                collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_TELEPORT_2)
            elseif collectible.SubType == CollectibleType.COLLECTIBLE_IRON_BAR then
                collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_MIDAS_TOUCH)
            elseif collectible.SubType == CollectibleType.COLLECTIBLE_RAZOR_BLADE then
                collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_GOLDEN_RAZOR)
            elseif collectible.SubType == CollectibleType.COLLECTIBLE_THERES_OPTIONS or collectible.SubType == CollectibleType.COLLECTIBLE_OPTIONS then
                collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_MORE_OPTIONS)
            else
                if not mod:IsItemActive(collectible.SubType) and Epiphany and Epiphany.Pickup and Epiphany.Pickup.GOLDEN_ITEM and Epiphany.Pickup.GOLDEN_ITEM.TurnItemGold and not (collectible:GetSprite():GetRenderFlags() & AnimRenderFlags.GOLDEN > 0) then
                    Epiphany.Pickup.GOLDEN_ITEM:TurnItemGold(collectible, false)
                end
            end
        end
    end
    for _, poop in ipairs(Isaac.FindByType(EntityType.ENTITY_POOP)) do
        if poop.Variant ~= EntityPoopVariant.GOLDEN then
            local position = poop.Position
            local velocity = poop.Velocity
            poop:Remove()

            mod:scheduleForUpdate(function()
                local newPoop = Isaac.Spawn(EntityType.ENTITY_POOP, 1, 0, position, velocity, nil)
            end,2)
        end
    end

    for _, _bismuth in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.EntityInf[mod.Entity.BismuthOre].VAR)) do
        local bismuth = _bismuth:ToPickup()
        if bismuth and bismuth.SubType ~= mod.EntityInf[mod.Entity.BismuthOre].SUB+3 then
            --bismuth:Morph(EntityType.ENTITY_PICKUP, mod.EntityInf[mod.Entity.BismuthOre].VAR, mod.EntityInf[mod.Entity.BismuthOre].SUB+3)
            mod:GildBismuth(bismuth)
        end
    end

    
    local gridSize = room:GetGridSize()
    for index=0, gridSize do
        local grid = room:GetGridEntity(index)
        if grid then
            if grid.State < 2 and (grid:GetType() == GridEntityType.GRID_ROCK or grid:GetType() == GridEntityType.GRID_ROCKT or grid:GetType() == GridEntityType.GRID_ROCK_BOMB or grid:GetType() == GridEntityType.GRID_ROCK_ALT or grid:GetType() == GridEntityType.GRID_ROCK_SS or grid:GetType() == GridEntityType.GRID_ROCK_SPIKED) then
                
                room:RemoveGridEntity(index, 0, true)
                mod:scheduleForUpdate(function()
                    room:SpawnGridEntity(index, GridEntityType.GRID_ROCK_GOLD, 0, grid:GetRNG():GetSeed(), 0)
                end,2)
            elseif grid.State ~= 1000 and grid:GetType() == GridEntityType.GRID_POOP and grid:GetVariant() ~= GridPoopVariant.GOLDEN then
                room:RemoveGridEntity(index, 0, true)
                mod:scheduleForUpdate(function()
                    room:SpawnGridEntity(index, GridEntityType.GRID_POOP, GridPoopVariant.GOLDEN, grid:GetRNG():GetSeed(), 0)
                end,2)
            end
        end
    end

    if FiendFolio and Isaac.GetEntityVariantByName("Golden Slot Machine") and Isaac.GetEntitySubTypeByName("Golden Slot Machine") then
        for i, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
            if mod:IsSlotAMachine(slot) and slot.Variant ~= Isaac.GetEntityVariantByName("Golden Slot Machine") then
                local newSlot = Isaac.Spawn(EntityType.ENTITY_SLOT, Isaac.GetEntityVariantByName("Golden Slot Machine"), Isaac.GetEntitySubTypeByName("Golden Slot Machine"), slot.Position, Vector.Zero, nil)
                slot:Remove()
            end
        end
    end

    if ARACHNAMOD and Isaac.GetEntityVariantByName("Golden Shopkeeper") and Isaac.GetEntitySubTypeByName("Golden Shopkeeper") then
        for i, keeper in ipairs(Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER)) do
            local gkeeper = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Golden Shopkeeper"), Isaac.GetEntitySubTypeByName("Golden Shopkeeper"), keeper.Position, Vector.Zero, nil)
            keeper:Remove()
        end
    end
end

function mod:GildPlayerTrinkets()
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then 
			local t1 = player:GetTrinket(0)
			local t2 = player:GetTrinket(1)
            if t1 > 0 then
                player:TryRemoveTrinket(t1)
                player:AddTrinket(t1 | TrinketType.TRINKET_GOLDEN_FLAG, false)
            end
            if t2 > 0 then
                player:TryRemoveTrinket(t2)
                player:AddTrinket(t2 | TrinketType.TRINKET_GOLDEN_FLAG, false)
            end
		end
	end
end

function mod:OnVoidCoinSpawn(pickup, variant, subType)
    
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidCoinSpawn, {"void_pickups_A (HC)", mod.voidConsts.COIN_CHANCE, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidCoinSpawn, {"void_pickups_A (HC)", mod.voidConsts.COIN_CHANCE, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidCoinSpawn, {"void_pickups_A (HC)", mod.voidConsts.COIN_CHANCE, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidCoinSpawn, {"void_pickups_A (HC)", mod.voidConsts.COIN_CHANCE, PickupVariant.PICKUP_COIN, CoinSubType.COIN_STICKYNICKEL, mod.EntityVoidSub})

