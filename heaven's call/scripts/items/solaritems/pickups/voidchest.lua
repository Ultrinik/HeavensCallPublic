local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.minMaxPickupsVoidChest = 15


function mod:OnVoidChestUpdate(chest)

    if chest.SubType == mod.EntityVoidSub then
        local sprite = chest:GetSprite()

        if sprite:IsEventTriggered("DropSound") then

        elseif sprite:IsFinished("Open") then
            sprite:Play("Opened", true)

        elseif sprite:IsEventTriggered("Open") then
            --mod:VoidChestOpen(chest, player)

        end

        local data = chest:GetData()
        if not data.Init then
            data.Init = true

            --avoid FF chest overwrite
            if FiendFolio and FiendFolio.getFieldInit and FiendFolio.savedata then
                local chestseed = tostring(chest.InitSeed)
                local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
                d.chestRerollCheck = true
                d.chestReplaced = true
            end
        end
        
        if sprite:IsPlaying("Idle") then

            local player = Isaac.GetPlayer(0)
            local pickups = {}
            pickups[1] = math.floor(math.min(99, player:GetNumCoins())/3)
            pickups[2] = player:GetNumKeys()
            pickups[3] = player:GetNumBombs()
        
            local index, value = mod:getMaxValueFromTable(pickups)

            sprite:SetOverlayFrame("Lock", index-1)
            sprite:SetOverlayRenderPriority(false)

            chest:GetData().SelectedPickup = index

            if chest.FrameCount > 30 then
                local position = chest.Position
                local velocity = chest.Velocity
                local scale = chest.SpriteScale
                local animation = sprite:GetAnimation()
                local frame = sprite:GetFrame()

                --local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub, position, velocity, nil)

                chest:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub, false, true)
                local newChest = chest

                newChest:Update()
                newChest.SpriteScale = scale
                newChest:GetSprite():Play(animation, true)
                newChest:GetSprite():SetFrame(frame)
                    
                newChest:GetSprite():SetOverlayFrame("Lock", index-1)
                newChest:GetSprite():SetOverlayRenderPriority(false)

                newChest.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

                --chest:Remove()

            end
            
            --Isaac.GetPlayer(0):AddKeys(99)
            --Isaac.GetPlayer(0):AddCoins(99)
            --Isaac.GetPlayer(0):AddBombs(99)
        else
            sprite:RemoveOverlay ()

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidChestUpdate, PickupVariant.PICKUP_CHEST)

function mod:OnVoidChestCollide(pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            mod:VoidChestOpen(pickup, player)
        end
        --return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnVoidChestCollide, PickupVariant.PICKUP_CHEST)

function mod:VoidChestOpen(pickup, player)

    local sprite = pickup:GetSprite()
    if sprite:IsPlaying("Idle") then
        sprite:Play("Open", true)
    
        sfx:Play(mod.SFX.VoidPickup)
        sfx:Play(mod.SFX.Triton)
        sfx:Stop(SoundEffect.SOUND_CHEST_OPEN)
        game:MakeShockwave(pickup.Position, 0.175, 0.025, 60)
    
        --Take pickups--------------------
        local index = pickup:GetData().SelectedPickup
        local totalPickups = 0
        if index==1 then
            totalPickups = math.min(99, Isaac.GetPlayer(0):GetNumCoins())
            if player then player:AddCoins(-totalPickups) end
        elseif index==2 then
            totalPickups = Isaac.GetPlayer(0):GetNumKeys()
            if player then player:AddKeys(-totalPickups) end
        elseif index==3 then
            totalPickups = Isaac.GetPlayer(0):GetNumBombs()
            if player then player:AddBombs(-totalPickups) end
        end

        mod:scheduleForUpdate(function ()
            for i, collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                if collectible.Position:Distance(pickup.Position) < 10 then
                    local sprite = collectible:GetSprite()
                    sprite:ReplaceSpritesheet(5, "hc/gfx/items/void_altar.png", true)
                    sprite:SetOverlayFrame("Alternates", 10)
                    break
                end
            end        
        end, 1)

        sprite:RemoveOverlay ()
        return true
    else
        return false
    end
end

function mod:SpawnVoidChestItem(pickup)
    --local item = mod:GetVoidCollectible()
    local item = game:GetItemPool():GetCollectible(Isaac.GetPoolIdByName("pain HC"), false)

    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item)

    local sprite = pickup:GetSprite()
    sprite:ReplaceSpritesheet(5, "hc/gfx/items/void_altar.png", true)
    sprite:SetOverlayFrame("Alternates", 10)
end


mod.VoidTrinkets = {
    TrinketType.TRINKET_LOCUST_OF_WRATH,
    TrinketType.TRINKET_LOCUST_OF_PESTILENCE,
    TrinketType.TRINKET_LOCUST_OF_FAMINE,
    TrinketType.TRINKET_LOCUST_OF_DEATH,
    TrinketType.TRINKET_LOCUST_OF_DEATH,
    TrinketType.TRINKET_LOCUST_OF_WRATH,
    TrinketType.TRINKET_CURVED_HORN,
    TrinketType.TRINKET_CANCER,
    TrinketType.TRINKET_ENDLESS_NAMELESS,
    TrinketType.TRINKET_BLOODY_CROWN,
    TrinketType.TRINKET_DEVILS_CROWN,
    TrinketType.TRINKET_HOLY_CROWN,
    TrinketType.TRINKET_WICKED_CROWN,
    TrinketType.TRINKET_SILVER_DOLLAR,
    TrinketType.TRINKET_SILVER_DOLLAR,
    TrinketType.TRINKET_SILVER_DOLLAR,
    TrinketType.TRINKET_STRANGE_KEY,
    TrinketType.TRINKET_LIL_CLOT,
    TrinketType.TRINKET_APOLLYONS_BEST_FRIEND,
    mod.Trinkets.Void,
    mod.Trinkets.Noise,
}

mod.VoidCards = {
    Card.RUNE_HAGALAZ,
    Card.RUNE_JERA,
    Card.RUNE_EHWAZ,
    Card.RUNE_DAGAZ,
    Card.RUNE_ANSUZ,
    Card.RUNE_PERTHRO,
    Card.RUNE_BERKANO,
    Card.RUNE_ALGIZ,
    Card.RUNE_BLANK,
    Card.RUNE_BLACK,
    Card.CARD_CHAOS,
    Card.CARD_CREDIT,
    Card.CARD_RULES,
    Card.CARD_HUMANITY,
    Card.CARD_SUICIDE_KING,
    Card.CARD_GET_OUT_OF_JAIL,
    Card.CARD_QUESTIONMARK,
    Card.CARD_DICE_SHARD,
    Card.CARD_EMERGENCY_CONTACT,
    Card.CARD_HOLY,
    Card.CARD_HUGE_GROWTH,
    Card.CARD_ANCIENT_RECALL,
    Card.CARD_ERA_WALK,
    Card.CARD_REVERSE_FOOL,
    Card.CARD_REVERSE_MAGICIAN,
    Card.CARD_REVERSE_HIGH_PRIESTESS,
    Card.CARD_REVERSE_EMPRESS,
    Card.CARD_REVERSE_EMPEROR,
    Card.CARD_REVERSE_HIEROPHANT,
    Card.CARD_REVERSE_LOVERS,
    Card.CARD_REVERSE_CHARIOT,
    Card.CARD_REVERSE_JUSTICE,
    Card.CARD_REVERSE_HERMIT,
    Card.CARD_REVERSE_WHEEL_OF_FORTUNE,
    Card.CARD_REVERSE_STRENGTH,
    Card.CARD_REVERSE_HANGED_MAN,
    Card.CARD_REVERSE_DEATH,
    Card.CARD_REVERSE_TEMPERANCE,
    Card.CARD_REVERSE_DEVIL,
    Card.CARD_REVERSE_TOWER,
    Card.CARD_REVERSE_STARS,
    Card.CARD_REVERSE_MOON,
    Card.CARD_REVERSE_SUN,
    Card.CARD_REVERSE_JUDGEMENT,
    Card.CARD_REVERSE_WORLD,
    Card.CARD_QUEEN_OF_HEARTS,
    Card.CARD_WILD,
    Card.CARD_SOUL_ISAAC,
    Card.CARD_SOUL_MAGDALENE,
    Card.CARD_SOUL_CAIN,
    Card.CARD_SOUL_JUDAS,
    Card.CARD_SOUL_BLUEBABY,
    Card.CARD_SOUL_EVE,
    Card.CARD_SOUL_SAMSON,
    Card.CARD_SOUL_AZAZEL,
    Card.CARD_SOUL_LAZARUS,
    Card.CARD_SOUL_EDEN,
    Card.CARD_SOUL_LOST,
    Card.CARD_SOUL_LILITH,
    Card.CARD_SOUL_KEEPER,
    Card.CARD_SOUL_APOLLYON,
    Card.CARD_SOUL_FORGOTTEN,
    Card.CARD_SOUL_BETHANY,
    Card.CARD_SOUL_JACOB,
    mod.TheMoonConsts.CARD_ID,
}

function mod:OnVoidChestLoot(chest, shouldAdvance)
    if chest.Variant == PickupVariant.PICKUP_CHEST and chest.SubType == mod.EntityVoidSub then
        local lootList = LootList()

        local player = Isaac.GetPlayer(0)
        local pickups = {}
        pickups[1] = math.floor(math.min(99, player:GetNumCoins())/3)
        pickups[2] = player:GetNumKeys()
        pickups[3] = player:GetNumBombs()
    
        local index, value = mod:getMaxValueFromTable(pickups)

        local totalPickups = 0
        if index==1 then
            totalPickups = math.min(99, Isaac.GetPlayer(0):GetNumCoins())
        elseif index==2 then
            totalPickups = Isaac.GetPlayer(0):GetNumKeys()
        elseif index==3 then
            totalPickups = Isaac.GetPlayer(0):GetNumBombs()
        end

        local condition = math.min(mod.minMaxPickupsVoidChest,totalPickups)/mod.minMaxPickupsVoidChest

        local center = game:GetRoom():GetCenterPos()
        local direction = chest.Position - center

        local l = direction:Length()*100
        local a = direction:GetAngleDegrees()+1

        local seed = math.floor(l*a + 1)
        local rngvoid = RNG(); rngvoid:SetSeed(seed, 35)

        if rngvoid:RandomFloat() < condition then
            --mod:SpawnVoidChestItem(pickup)
            local item = game:GetItemPool():GetCollectible(Isaac.GetPoolIdByName("pain HC"), false, seed)
            lootList:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item)
            mod:FillVoidChestLoot(chest, condition/2, lootList, rngvoid)
        else
            --mod:SpawnVoidChestPickups(pickup, condition)
            mod:FillVoidChestLoot(chest, condition, lootList, rngvoid)
        end

        return lootList
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_GET_LOOT_LIST, mod.OnVoidChestLoot)

function mod:FillVoidChestLoot(pickup, ratio, lootList, rngvoid)

    for i=1, 2+math.ceil(4*ratio) do
        local r = rngvoid:RandomFloat()
        if r < 0.2 then
            lootList:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod:PickTrinketFromTable(mod.VoidTrinkets, rngvoid))
        elseif r < 0.85 then
            lootList:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidCards[mod:RandomInt(1, #mod.VoidCards, rngvoid)])
        else
            local rr = mod:RandomInt(1,9, rngvoid)
            local v
            local s = mod.EntityVoidSub
            if rr == 1 then
                v = PickupVariant.PICKUP_COIN
            elseif rr == 2 then
                v = PickupVariant.PICKUP_HEART
            elseif rr == 3 then
                v = PickupVariant.PICKUP_BOMB
            elseif rr == 4 then
                v = PickupVariant.PICKUP_KEY
            elseif rr == 5 then
                v = PickupVariant.PICKUP_LIL_BATTERY
            elseif rr == 6 then
                v = PickupVariant.PICKUP_GRAB_BAG
            elseif rr == 7 then
                v = PickupVariant.PICKUP_TAROTCARD
            elseif rr == 8 then
                v = PickupVariant.PICKUP_TAROTCARD
                s = s + 1
            elseif rr == 9 then
                v = PickupVariant.PICKUP_TAROTCARD
                s = s + 2
            end
            lootList:PushEntry(EntityType.ENTITY_PICKUP, v, s)
        end
    end
end



function mod:OnVoidChestSpawn(pickup, variant, subType)
    
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_CHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_BOMBCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_SPIKEDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_MIMICCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_WOODENCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_HAUNTEDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_LOCKEDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidChestSpawn, {"void_pickups_B (HC)", mod.voidConsts.CHEST_CHANCE, PickupVariant.PICKUP_REDCHEST, ChestSubType.CHEST_CLOSED, mod.EntityVoidSub})



