local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.batteryConsts = {
    MAX_LAYER_1 = 9,
    MAX_LAYER_2 = 9,
    MAX_LAYER_3 = 9,
    RAD_FLAG = (2 << 27),
}

mod.OneUseItems = {
    [CollectibleType.COLLECTIBLE_FORGET_ME_NOW] = 12,
    [CollectibleType.COLLECTIBLE_BLUE_BOX] = 12,
    [CollectibleType.COLLECTIBLE_DIPLOPIA] = 12,
    [CollectibleType.COLLECTIBLE_PLAN_C] = 6,
    [CollectibleType.COLLECTIBLE_MAMA_MEGA] = 12,
    [CollectibleType.COLLECTIBLE_EDENS_SOUL] = 12,
    [CollectibleType.COLLECTIBLE_MYSTERY_GIFT] = 12,
    [CollectibleType.COLLECTIBLE_DAMOCLES] = 12,
    [CollectibleType.COLLECTIBLE_ALABASTER_BOX] = 12,
    [CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE] = 24,
    [CollectibleType.COLLECTIBLE_R_KEY] = 24,
    [CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR] = 12,

    [CollectibleType.COLLECTIBLE_BUTTER_BEAN] = 1,
    [CollectibleType.COLLECTIBLE_TEAR_DETONATOR] = 1,
    [CollectibleType.COLLECTIBLE_SHARP_STRAW] = 2,
    [CollectibleType.COLLECTIBLE_SUPLEX] = 2,
}

mod.BannedBatteryItems = {
    CollectibleType.COLLECTIBLE_NOTCHED_AXE,
    CollectibleType.COLLECTIBLE_BREATH_OF_LIFE,
    CollectibleType.COLLECTIBLE_MOMS_BRACELET,
    CollectibleType.COLLECTIBLE_STITCHES,
    --CollectibleType.COLLECTIBLE_LEMEGETON,
    CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
    CollectibleType.COLLECTIBLE_GENESIS,
    CollectibleType.COLLECTIBLE_SHARP_KEY,
    CollectibleType.COLLECTIBLE_STITCHES,
    CollectibleType.COLLECTIBLE_R_KEY,
    CollectibleType.COLLECTIBLE_URN_OF_SOULS,
    CollectibleType.COLLECTIBLE_VADE_RETRO,
    CollectibleType.COLLECTIBLE_SPIN_TO_WIN,
    CollectibleType.COLLECTIBLE_ESAU_JR,
    CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING,
    CollectibleType.COLLECTIBLE_SUMPTORIUM,
    CollectibleType.COLLECTIBLE_RECALL,
    CollectibleType.COLLECTIBLE_HOLD,
    CollectibleType.COLLECTIBLE_DECAP_ATTACK,
    CollectibleType.COLLECTIBLE_KAMIKAZE,
    CollectibleType.COLLECTIBLE_GUPPYS_PAW,
    CollectibleType.COLLECTIBLE_IV_BAG,
    CollectibleType.COLLECTIBLE_REMOTE_DETONATOR,
    CollectibleType.COLLECTIBLE_PORTABLE_SLOT,
    CollectibleType.COLLECTIBLE_BLOOD_RIGHTS,
    CollectibleType.COLLECTIBLE_HOW_TO_JUMP,
    CollectibleType.COLLECTIBLE_THE_JAR,
    CollectibleType.COLLECTIBLE_MAGIC_FINGERS,
    CollectibleType.COLLECTIBLE_CONVERTER,
    CollectibleType.COLLECTIBLE_BOOMERANG,
    CollectibleType.COLLECTIBLE_CANDLE,
    CollectibleType.COLLECTIBLE_RED_CANDLE,
    CollectibleType.COLLECTIBLE_GLASS_CANNON,
    CollectibleType.COLLECTIBLE_FRIEND_BALL,
    CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR,
    CollectibleType.COLLECTIBLE_JAR_OF_FLIES,
    CollectibleType.COLLECTIBLE_POTATO_PEELER,
    CollectibleType.COLLECTIBLE_BLACK_HOLE,
}
function mod:AddStellarBatteryBan(item)
    table.insert(mod.BannedBatteryItems, item)
end
mod:AddStellarBatteryBan(mod.Items.Saturnus)
mod:AddStellarBatteryBan(mod.Items.Mars)
mod:AddStellarBatteryBan(mod.SolarItems.RedShovel)

table.insert(mod.PostLoadInits, {"savedatarun", "currentItemWisps", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.currentItemWisps", {})

function mod:CheckIsStellarItemSpecial(collectibleType)

    for item, charge in pairs(mod.OneUseItems) do
        if item == collectibleType then 
            return true
        end
    end
    return false
end

function mod:AddItemSpark(player, item, flags, customVarData, isSpecial, noAnim)
    sfx:Play(SoundEffect.SOUND_LASERRING_STRONG)

    flags = flags or 0
    customVarData = customVarData or 0

    mod:scheduleForUpdate(function()
        local wisp = player:AddItemWisp(item, player.Position)
        wisp:GetData().UseFlags_HC = flags
        wisp:GetData().CustomVarData_HC = customVarData

        wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        local itemConfig = Isaac.GetItemConfig():GetCollectible(item)

        if isSpecial then
            wisp.HitPoints = mod.OneUseItems[item]*0.67
        else
            if itemConfig.MaxCharges > 12 then
                wisp.HitPoints = 2
            elseif itemConfig.MaxCharges > 0 then
                wisp.HitPoints = itemConfig.MaxCharges*0.67 + 1
            else
                wisp.HitPoints = 12 + 1
            end
        end

        mod:IrradiateWisp(wisp)

    end,5)

    if not noAnim then
        player:AnimateCollectible(item, "UseItem")
    end

    mod.SaveManager.GetRunSave(player).currentItemWisps = mod.SaveManager.GetRunSave(player).currentItemWisps or {}
    table.insert(mod.SaveManager.GetRunSave(player).currentItemWisps, item)
end
function mod:IrradiateWisp(wisp)

    mod:scheduleForUpdate(function()
        wisp:GetData().IsRadioactive_HC = true
        wisp:GetData().CustomVarData_HC = (wisp:GetData().CustomVarData_HC or 0) | mod.batteryConsts.RAD_FLAG

        --wisp:GetSprite():ReplaceSpritesheet(1, "hc/gfx/familiars/star_wisp.png")
        --wisp:GetSprite():LoadGraphics()
        --wisp:GetSprite():Load("hc/gfx/familiar_RadioactiveWisp.anm2", true)

        wisp:GetData().RadSprite = Sprite()

        wisp:GetData().RadSprite:Load("hc/gfx/familiar_RadioactiveWisp.anm2", true)
        wisp:GetData().RadSprite:Play("Idle", true)

        wisp:GetData().RadSprite:ReplaceSpritesheet(0, "gfx/ui/death items.png")
        wisp:GetData().RadSprite:LoadGraphics()

        wisp:SetColor(Color(1,1,1,1,0,1,0), -1, 99, true, true)
        wisp.Visible = false

        mod:CountWispsOfPlayer(wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer())
    end, 5)
end

function mod:LockWisps(player)
    for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()

        if wispPlayer and wisp:GetData().IsRadioactive_HC and mod:ComparePlayer(player, wispPlayer) then
            wisp:GetData().Locked_HC = true
        end
    end
    mod:scheduleForUpdate(function()
        for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
            local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()
    
            if wispPlayer and wisp:GetData().IsRadioactive_HC and mod:ComparePlayer(player, wispPlayer) then
                wisp:GetData().Locked_HC = false
            end
        end
    end, 5)
end

function mod:RefactorWisps(player)
    local counter = 0
    for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()

        if wispPlayer and wisp:GetData().IsRadioactive_HC and mod:ComparePlayer(player, wispPlayer) then
            counter = counter + 1
        end
    end
end

function mod:CountWispsOfPlayer(player)
    if not player then return -1 end

    local count = 0
    for _, _wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
        local wisp = _wisp:ToFamiliar()
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()

        if wispPlayer and wisp:GetData().IsRadioactive_HC and mod:ComparePlayer(player, wispPlayer) then
            count = count + 1

            if wisp and player then
                local nWisps = count
                if nWisps <= mod.batteryConsts.MAX_LAYER_1 then
        
                    wisp:AddToOrbit (2)
                    --wisp.OrbitSpeed = 0.15
                    wisp.OrbitDistance = Vector(40,30)
        
                elseif nWisps <= mod.batteryConsts.MAX_LAYER_2 + mod.batteryConsts.MAX_LAYER_1 then
        
                    wisp:AddToOrbit (3)
                    --wisp.OrbitSpeed = -0.125
                    wisp.OrbitDistance = Vector(55,45)
        
                else
        
                    wisp:AddToOrbit (6)
                    --wisp.OrbitSpeed = 0.1
                    wisp.OrbitDistance = Vector(70,60)
        
                    if nWisps >= mod.batteryConsts.MAX_LAYER_3 + mod.batteryConsts.MAX_LAYER_2 + mod.batteryConsts.MAX_LAYER_1 then
                        mod:UseStellarWisp(player, -1)
                    end
                end
            end
        end
    end
    return count
end

function mod:UseStellarWisp(player, slot)
    for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()

        if wispPlayer and wisp:GetData().IsRadioactive_HC and mod:ComparePlayer(player, wispPlayer) then

            mod:OnStellarWispDeath(wisp, 9999, nil, nil, nil, true, slot or -1)
            wisp:Die()
            --mod:CountWispsOfPlayer(wispPlayer)
            break
        end
    end
end

function mod:OnStellarWispDeath(wisp, amount, flags, source, frames, forced, slot)
    if wisp.Variant == FamiliarVariant.ITEM_WISP  then
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()
        local letal = (wisp.HitPoints - amount) <= 0

        if (letal or forced) and wispPlayer and wisp:GetData().IsRadioactive_HC then

            wispPlayer:UseActiveItem(wisp.SubType, (wisp:GetData().UseFlags_HC or 0) | UseFlag.USE_NOANIM, slot, (wisp:GetData().CustomVarData_HC or 0) | mod.batteryConsts.RAD_FLAG)

            local techDot = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, wisp.Position + Vector(0,-10), wisp.Velocity, nil):ToEffect()
            if techDot then
                techDot:SetColor(Color(1,1,1,1,0,1,0), -1, 99, true, true)
                techDot.Timeout = 1
            end

            mod:scheduleForUpdate(function()
                mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01))
                mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A))
            end, 3, ModCallbacks.MC_POST_RENDER)

            mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps = mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps or {}
            local currentItemWisps = mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps
            for i, item in ipairs(currentItemWisps) do
                if item == wisp.SubType then
                    table.remove(mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps, i)
                    break
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnStellarWispDeath, EntityType.ENTITY_FAMILIAR)

mod.JustUsedItem = false

function mod:OnBatteryPlayerUpdate(player)
    if mod.JustUsedItem then 
        mod.JustUsedItem = false
        return 
    end

    local condition = (Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex))
    if condition then
        
        local slot = ActiveSlot.SLOT_PRIMARY
        if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
            slot = ActiveSlot.SLOT_POCKET
        end

        if (player:NeedsCharge(slot) or (slot == ActiveSlot.SLOT_PRIMARY and player:GetActiveItem(slot)==0)) and not player:GetData().WispCache then
            mod:UseStellarWisp(player, slot)
        else
            player:GetData().WispCache = false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnBatteryPlayerUpdate, 0)

function mod:CheckStellarCollectibleBan(collectibleType)
    for index, item in pairs(mod.BannedBatteryItems) do
        if item == collectibleType then return true end
    end
    return false
end

function mod:OnStellarActiveUse(collectibleType, rng, player, flags, slot, customVarData)
    if player:HasCollectible(mod.SolarItems.Battery) and player:HasCollectible(collectibleType, true) then

        local byWisp = customVarData & mod.batteryConsts.RAD_FLAG > 0
        if not byWisp then

            --Check of banned
            if mod:CheckStellarCollectibleBan(collectibleType) then return end
            
            --Check if special
            local specialFlag = mod:CheckIsStellarItemSpecial(collectibleType)
            
            local itemConfig = Isaac.GetItemConfig():GetCollectible(collectibleType)
            if specialFlag or itemConfig.MaxCharges > 0 then
                player:GetData().WispCache = true
    
                local nWisps = player:GetCollectibleNum(mod.SolarItems.Battery)
                if specialFlag then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then nWisps = nWisps*2 end
                    player:RemoveCollectible(collectibleType)
                end

                local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, player.Position, Vector.Zero, nil)
                impact:SetColor(Color(1,1,1,1,0,1,0), -1, 99, true, true)

                for i=1, nWisps do
                    mod:AddItemSpark(player, collectibleType, flags, customVarData, false, specialFlag)
                end
                return true
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnStellarActiveUse)
function mod:PostUseItem(collectibleType, rng, player, flags, slot, customVarData)
    if player:HasCollectible(collectibleType, true)  then
        mod.JustUsedItem = true
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PostUseItem)

function mod:CheckForStellarWisps()
    for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()
        if wispPlayer then
            mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps = mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps or {}
            local currentItemWisps = mod.SaveManager.GetRunSave(wispPlayer).currentItemWisps
            for __, item in ipairs(currentItemWisps) do
                if item == wisp.SubType then
                    mod:IrradiateWisp(wisp)
                    break
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckForStellarWisps)


function mod:WispUpdateDebug(wisp)
    local sprite = wisp:GetData().RadSprite
    if sprite then
        local room = game:GetRoom()
        sprite:RenderLayer(2, room:WorldToScreenPosition(wisp.Position+Vector(-0.5,2.5)))
        sprite:RenderLayer(1, room:WorldToScreenPosition(wisp.Position))

        local idx = wisp.SubType-1
        if idx > 357 then idx = idx + 1 end
        if idx > 403 then idx = idx + 3 end
        if idx > 555 then idx = idx + 4 end
        --if idx > 552 then idx = idx + 4 end
        local x = idx % 20
        local y = math.floor(idx / 20)

        local diecises = 16

        local clamp = Vector(diecises*(x), diecises*(y))
        local clamp2 = Vector(320, 592) - (clamp + Vector.One*diecises)
        
        local position = room:WorldToScreenPosition(wisp.Position) - clamp + Vector(0.5,2.5)
        sprite:RenderLayer(0, position, clamp, clamp2)

        sprite:Update(room:WorldToScreenPosition(room:GetCenterPos()))

        --local s = CollectionMenu.GetDeathScreenSprite()
        --s:Render()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, mod.WispUpdateDebug, FamiliarVariant.ITEM_WISP)
