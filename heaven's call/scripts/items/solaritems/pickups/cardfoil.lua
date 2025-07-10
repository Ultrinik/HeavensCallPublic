local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.FoilConsts = {
    FOIL_ID = Isaac.GetCardIdByName("Card Protector"),
    BREAK_CHANCE = 0.4
}

table.insert(mod.PostLoadInits, {"savedatarun", "foiledCards", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.foiledCards", {})

function mod:OnFoilUse(card, player, flags)
    if flags & UseFlag.USE_OWNED then

        local target_card
        for i, entity in ipairs(Isaac.FindInRadius(player.Position, 100)) do
            local pickup = entity:ToPickup()
			if pickup and pickup.Variant == PickupVariant.PICKUP_TAROTCARD and pickup.SubType ~= card then
                local t_card = pickup.SubType
                local itemConfig = Isaac:GetItemConfig():GetCard(t_card)
                if itemConfig:IsCard() and not mod.savedatarun().foiledCards[tostring(pickup.SubType)] then
                    if (not target_card) or (player.Position:Distance(pickup.Position) < player.Position:Distance(target_card.Position)) then
                        target_card = pickup
                    end
                end
			end
		end

        if target_card then
            mod.savedatarun().foiledCards[tostring(target_card.SubType)] = true
            sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 1, 2, false, 1.5)
        else
            local og_n = #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card)
            mod:scheduleForUpdate(function ()
                if og_n == #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card) + (mod:PlayerHasCard(player, card) and 1 or 0) then
                    local position = Isaac.GetFreeNearPosition(player.Position, 1000)
                    local foil = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, position, Vector.Zero, nil)
                end
            end,1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnFoilUse, mod.FoilConsts.FOIL_ID)

function mod:OnFoiledCardUse(card, player, flags)
    if flags & UseFlag.USE_OWNED and (player:GetCard(0) ~= card) then
        if mod.savedatarun().foiledCards[tostring(card)] then
            player:AddCard(card)
            if rng:RandomFloat() < math.max(0.2, mod.FoilConsts.BREAK_CHANCE - 0.05*player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TAROT_CLOTH)) then
                mod.savedatarun().foiledCards[tostring(card)] = false
                sfx:Play(SoundEffect.SOUND_BONE_BREAK, 1, 2, false, 1.5)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnFoiledCardUse)

function mod:OnFoiledCardUpdate(entity)
    if mod.savedatarun().foiledCards[tostring(entity.SubType)] then
        if entity.FrameCount & 7 == 0 then
            local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ULTRA_GREED_BLING, 0, entity.Position +Vector(0,-10)+ mod:RandomVector(20), mod:RandomVector(1), entity)
            shine.DepthOffset = 50
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnFoiledCardUpdate, PickupVariant.PICKUP_TAROTCARD)