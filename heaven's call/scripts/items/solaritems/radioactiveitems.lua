local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local persistentData = Isaac.GetPersistentGameData()

table.insert(mod.PostLoadInits, {"savedatasettings", "RadioactiveChance", 1/200})

table.insert(mod.PostLoadInits, {"savedatarun", "RadioactiveItems", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatarun.RadioactiveItems", {})

table.insert(mod.PostLoadInits, {"savedatarun", "currentRadioactiveItems", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.currentRadioactiveItems", {})

function mod:AddRadioactiveItem(collectible)

    mod.savedatarun().RadioactiveItems[#mod.savedatarun().RadioactiveItems + 1] = {ROOM = game:GetLevel():GetCurrentRoomIndex(), ITEM = collectible.SubType}
end
function mod:TakeRadioactiveItem(collectible, player)
    collectible:GetData().IsRadioactive_HC = false

    for i, entry in ipairs(mod.savedatarun().RadioactiveItems) do
        if entry.ROOM == game:GetLevel():GetCurrentRoomIndex() and collectible.SubType == entry.ITEM then
            mod.savedatarun().RadioactiveItems[i] = nil
            break
        end
    end
    mod:SearchForRadiactiveItems()

    
    mod.SaveManager.GetRunSave(player).currentRadioactiveItems = mod.SaveManager.GetRunSave(player).currentRadioactiveItems or {}
    mod.SaveManager.GetRunSave(player).currentRadioactiveItems[tostring(collectible.SubType)] = true

    player:GetData().RadioactiveCache = true

end

function mod:SetRadioactivesOnNewRoom()

    --summon them
    mod.savedatarun().RadioactiveItems = mod.savedatarun().RadioactiveItems or {}
    for _, entry in ipairs(mod.savedatarun().RadioactiveItems) do
        if entry.ROOM == game:GetLevel():GetCurrentRoomIndex() then
            for _, collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                if collectible.SubType > 0 and collectible.SubType == entry.ITEM and not collectible:GetData().IsRadioactive_HC then
                    mod:IradiateCollectible(collectible, false)
                    break
                end
            end
        end
    end

    --create them
    if game:GetRoom():IsFirstVisit() and (mod.savedatasettings().UnlockAll or persistentData:Unlocked(Isaac.GetAchievementIdByName("radioactive_items (HC)"))) then
        for _, _collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            local collectible = _collectible:ToPickup()
            if collectible then
                if (rng:RandomFloat() < mod.savedatasettings().RadioactiveChance) then
                    mod:IradiateCollectible(collectible:ToPickup(), true)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SetRadioactivesOnNewRoom)

function mod:SearchForRadiactiveItems()
    for _, collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        if collectible.SubType ~= 0 and collectible:GetData().IsRadioactive_HC then
            mod:IradiateCollectible(collectible, false)
        end
    end
end

--RADIOACTIVE COLLECTIBLE
function mod:IradiateCollectible(collectible, created)
    if (collectible.SubType > 0 and mod:IsItemActive(collectible.SubType) and (not mod:CheckStellarCollectibleBan(collectible.SubType))) then
        collectible:GetData().IsRadioactive_HC = true

        local offset = Vector.Zero
        if collectible:GetSprite():GetAnimation() == "ShopIdle" then
            offset = Vector(0,32)
        end

        local sprite = collectible:GetSprite()

        local currentAnimation = sprite:GetAnimation()
        local currentOverlayAnimation = sprite:GetOverlayAnimation()
        local overlayFrame = sprite:GetOverlayFrame()
        local item = collectible.SubType

        sprite:Load("hc/gfx/pickup_RadioactiveCollectible.anm2", false)
        sprite:Play(currentAnimation, true)
        sprite:SetOverlayFrame(currentOverlayAnimation, overlayFrame)
        sprite:ReplaceSpritesheet(1, Isaac.GetItemConfig():GetCollectible(item).GfxFileName)
        sprite:ReplaceSpritesheet(6, Isaac.GetItemConfig():GetCollectible(item).GfxFileName)
        sprite:LoadGraphics()

        --sprite:SetCustomShader("hc/shaders/irradiated")
        sprite:SetCustomShader("hc/shaders/irradiated_v2")
        --Isaac.GetPlayer(0):GetSprite():SetCustomShader("hc/shaders/irradiated")

        if created then
            mod:AddRadioactiveItem(collectible)
        end
    end
end

function mod:RadioactiveCollectibleUpdate(collectible)
	if collectible:GetData().IsRadioactive_HC then
        local offset = Vector.Zero
        if collectible:GetSprite():GetAnimation() == "ShopIdle" then
            offset = Vector(0,28)
        end
        local position = collectible.Position + Vector(0,-40) + RandomVector() * ( 10 * rng:RandomFloat() + 10 )
        local velocity = (position - (collectible.Position + Vector(0,-40)))*0.2

		local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, position + offset, velocity, collectible)
        shine:SetColor(Color(1,1,1,1,0,1,0), -1, 99, true, true)
		shine.DepthOffset = 50
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.RadioactiveCollectibleUpdate, PickupVariant.PICKUP_COLLECTIBLE)

function mod:RadioactiveCollectibleCollision(collectible, collider)
	if collectible:GetData().IsRadioactive_HC then
		collider = collider:ToPlayer()
		if collider and collider:GetHeldSprite():GetAnimation() == "" then
			mod:TakeRadioactiveItem(collectible, collider)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.RadioactiveCollectibleCollision, PickupVariant.PICKUP_COLLECTIBLE)

function mod:CheckForRadioactiveDrop(collectible)

    
    for i=0, game:GetNumPlayers ()-1 do
        local player = game:GetPlayer(i)
        mod.SaveManager.GetRunSave(player).currentRadioactiveItems = mod.SaveManager.GetRunSave(player).currentRadioactiveItems or {}
        for itemStringId, _ in pairs(mod.SaveManager.GetRunSave(player).currentRadioactiveItems) do
            if tostring(collectible.SubType) == itemStringId then
                mod:IradiateCollectible(collectible, true)
                mod.SaveManager.GetRunSave(player).currentRadioactiveItems[itemStringId] = nil
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.CheckForRadioactiveDrop, PickupVariant.PICKUP_COLLECTIBLE)

--RENDER
function mod:OnUpdateCheckRadioactivity()
    if mod:CheckIfPlayerRadioactive(Isaac.GetPlayer(0)) then
        mod:UpdateShaderState(true)
    else
        mod:UpdateShaderState(false)
    end
end

function mod:UpdateShaderState(state)
    --mod.ShaderData.radUIParams.ENABLED = state

    if state then
        mod.ShaderData.radUIParams.ENABLED = true
    else
        mod.ShaderData.radUIParams.ENABLED = false
    end

end

function mod:CheckIfPlayerRadioactive(player)
    mod.SaveManager.GetRunSave(player).currentRadioactiveItems = mod.SaveManager.GetRunSave(player).currentRadioactiveItems or {}
    for itemStringId, _ in pairs(mod.SaveManager.GetRunSave(player).currentRadioactiveItems) do
        local item = tonumber(itemStringId)
        if player:HasCollectible(item, true) or player:GetData().RadioactiveCache then
            if mod:CheckIfItemLoaded(player, item) then
                player:GetData().RadioactiveCache = false
                return true
            end
        end
    end
    return false
end
function mod:CheckIfItemLoaded(player, collectible)
    for i=0, 3 do
        local citem = player:GetActiveItem(i)
        if collectible == citem then
            return not player:NeedsCharge(i)
        end
    end
    return false
end

function mod:CheckIfPlayerHasRadioactiveItem(player, itemToCheck)
    mod.SaveManager.GetRunSave(player).currentRadioactiveItems = mod.SaveManager.GetRunSave(player).currentRadioactiveItems or {}
    for itemStringId, _ in pairs(mod.SaveManager.GetRunSave(player).currentRadioactiveItems) do
        local item = tonumber(itemStringId)
        if itemToCheck == item and player:HasCollectible(item) then
            return true
        end
    end
    return false
end

--EFFECT
function mod:OnIrradiatedUse(collectibleType, rng, player, flags, slot, customVarData)
    mod.SaveManager.GetRunSave(player).currentRadioactiveItems = mod.SaveManager.GetRunSave(player).currentRadioactiveItems or {}
    for itemStringId, _ in pairs(mod.SaveManager.GetRunSave(player).currentRadioactiveItems) do
        local item = tonumber(itemStringId)
        if item == collectibleType then
            local byWisp = customVarData & mod.batteryConsts.RAD_FLAG > 0
            if not byWisp then
                mod:AddItemSpark(player, collectibleType, flags, customVarData)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnIrradiatedUse)

--Debug
function mod:IrradiateAll()
    for _, collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        mod:IradiateCollectible(collectible, true)
    end
end
