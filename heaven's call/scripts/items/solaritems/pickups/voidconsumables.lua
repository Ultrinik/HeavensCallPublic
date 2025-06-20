local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

table.insert(mod.PostLoadInits, {"savedatarun", "voidedCards", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.voidedCards", {})
table.insert(mod.PostLoadInits, {"savedatarun", "voidedPills", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.voidedPills", {})
table.insert(mod.PostLoadInits, {"savedatarun", "voidedRunes", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.voidedRunes", {})

mod.VoidConsumables = {
    [1] = Isaac.GetCardIdByName("Void Card"),
    [2] = Isaac.GetCardIdByName("Void Pill"),
    [3] = Isaac.GetCardIdByName("Void Rune"),
    [4] = Isaac.GetCardIdByName("fAKE Void Pill"),
}

mod.TPCardPriority = {
    [Card.CARD_FOOL] = 0,
    [Card.CARD_EMPEROR] = 1,
    [Card.CARD_HERMIT] = 2,
    [Card.CARD_STARS] = 3,
    [Card.CARD_MOON] = 4,
    [Card.CARD_REVERSE_EMPEROR] = 5,
    [Card.CARD_JOKER] = 6,
    [Card.CARD_REVERSE_MOON] = 7,
}

local voidTPIdx = 1
mod.ModFlags.lockVoidConsumable = false

function mod:AddObjectToVoid(card, player, flags)
    if flags & UseFlag.USE_OWNED and (not mod.ModFlags.lockVoidConsumable) then
        
        local itemConfig = Isaac:GetItemConfig():GetCard(card)
        local isCard = itemConfig:IsCard()
        local isRune = itemConfig:IsRune()

        if isCard then
            mod:AddCardToVoid(card, player, flags)
        elseif isRune then
            mod:AddRuneToVoid(card, player, flags)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.AddObjectToVoid)


function mod:AddCardToVoid(card, player, flags)
    if card ~= mod.VoidConsumables[1] then
        if mod.savedatarun().voidedCards[voidTPIdx] == nil then mod.savedatarun().voidedCards[voidTPIdx] = -1 end

        local condition = card == Card.CARD_FOOL or card == Card.CARD_EMPEROR or card == Card.CARD_HERMIT or card == Card.CARD_STARS or
        card == Card.CARD_MOON or card == Card.CARD_JOKER or card == Card.CARD_REVERSE_EMPEROR or card == Card.CARD_REVERSE_MOON
        
        if condition then --a tp card is going to be used
            local tpCard = mod.savedatarun().voidedCards[voidTPIdx]
            tpCard = tpCard or Card.CARD_FOOL
            if tpCard==-1 or mod.TPCardPriority[card] >= mod.TPCardPriority[tpCard] then
                mod.savedatarun().voidedCards[voidTPIdx] = card
            end
            
            return
        end

        table.insert(mod.savedatarun().voidedCards, card)
        
    end
end

function mod:AddRuneToVoid(rune, player, flags)
    if rune ~= mod.VoidConsumables[3] then
        table.insert(mod.savedatarun().voidedRunes, rune)
    end
end

function mod:AddPillToVoid(pill, player, flags)
    if flags & UseFlag.USE_OWNED and (not mod.ModFlags.lockVoidConsumable) then
        for index, pillEffect in pairs(mod.savedatarun().voidedPills) do
            if pillEffect == pill and pill == PillEffect.PILLEFFECT_TELEPILLS then --Dont add telepills twice
                return
            end
        end
        table.insert(mod.savedatarun().voidedPills, pill)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.AddPillToVoid)

--USES

function mod:OnVoidCardUse(voidCard, player, flags)
    flags = flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOANIM

    mod.ModFlags.lockVoidConsumable = true
    mod:scheduleForUpdate(function()
        mod.ModFlags.lockVoidConsumable = false
    end, 10)
    

    local tpCard = mod.savedatarun().voidedCards[voidTPIdx]
    if tpCard then
        player:UseCard(tpCard, flags | UseFlag.USE_MIMIC)
    end

    mod:scheduleForUpdate(function()
        for index, card in pairs(mod.savedatarun().voidedCards) do
            if index ~= voidTPIdx and card ~= -1 then
                player:UseCard(card, flags | UseFlag.USE_MIMIC)
            end
        end
    end,5)

    sfx:Play(mod.SFX.VoidPickup)
    sfx:Play(mod.SFX.Triton)
    game:MakeShockwave(player.Position, 0.175, 0.025, 60)
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnVoidCardUse, mod.VoidConsumables[1])

function mod:OnVoidRuneUse(voidRune, player, flags)
    flags = flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOANIM

    mod.ModFlags.lockVoidConsumable = true
    mod:scheduleForUpdate(function()
        mod.ModFlags.lockVoidConsumable = false
    end, 10)

    for index, rune in pairs(mod.savedatarun().voidedRunes) do
        player:UseCard(rune, flags | UseFlag.USE_MIMIC)
    end
    
    sfx:Play(mod.SFX.VoidPickup)
    sfx:Play(mod.SFX.Triton)
    game:MakeShockwave(player.Position, 0.175, 0.025, 60)
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnVoidRuneUse, mod.VoidConsumables[3])

function mod:OnVoidPillUse(voidPill, player, flags)
    flags = flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOANIM

    mod.ModFlags.lockVoidConsumable = true
    mod:scheduleForUpdate(function()
        mod.ModFlags.lockVoidConsumable = false
    end, 10)

    for index, pillEffect in pairs(mod.savedatarun().voidedPills) do
        player:UsePill (pillEffect, PillColor.PILL_WHITE_WHITE, flags)
    end
    
    sfx:Play(mod.SFX.VoidPickup)
    sfx:Play(mod.SFX.Triton)
    game:MakeShockwave(player.Position, 0.175, 0.025, 60)
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnVoidPillUse, mod.VoidConsumables[2])


function mod:OnPlaceboVoidUse(item, rng, player, flags, slot, vardata)
    local oldPickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
    for slot=0, 3 do
        local card = player:GetCard(slot)
        if card == mod.VoidConsumables[2] then
            player:UseCard(card, UseFlag.USE_NOANNOUNCER | UseFlag.USE_MIMIC)
            player:AddCollectible(CollectibleType.COLLECTIBLE_PLACEBO, 0, false, slot, 12)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnPlaceboVoidUse, CollectibleType.COLLECTIBLE_PLACEBO)


--CONSUMABLES

function mod:OnVoidCardSpawn(pickup, variant, subType)
    
    local itemConfig = Isaac:GetItemConfig():GetCard(subType)
    if itemConfig:IsCard() then
        if pickup then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[1])
        end
        return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[1]}
    end
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidCardSpawn, {"void_pickups_B (HC)", mod.voidConsts.CARD_CHANCE, PickupVariant.PICKUP_TAROTCARD, -1, mod.VoidConsumables[1]})

function mod:OnVoidPillSpawn(pickup, variant, subType)
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[2])
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[2]}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidPillSpawn, {"void_pickups_B (HC)", mod.voidConsts.PILL_CHANCE, PickupVariant.PICKUP_PILL, -1, mod.VoidConsumables[2]})

function mod:OnVoidRuneSpawn(pickup, variant, subType)
    
    local itemConfig = Isaac:GetItemConfig():GetCard(subType)
    if itemConfig:IsRune() and not mod:IsMeteoricRune(subType) then
        if pickup then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[3])
        end
        return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[3]}
    end
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidRuneSpawn, {"void_pickups_B (HC)", mod.voidConsts.RUNE_CHANCE, PickupVariant.PICKUP_TAROTCARD, -1, mod.VoidConsumables[3]})


function mod:OnWrongPillAppear(pickup)
    if pickup.SubType == mod.VoidConsumables[4] then
        pickup:Morph(pickup.Type, PickupVariant.PICKUP_TAROTCARD, mod.VoidConsumables[2])
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnWrongPillAppear, PickupVariant.PICKUP_TAROTCARD)