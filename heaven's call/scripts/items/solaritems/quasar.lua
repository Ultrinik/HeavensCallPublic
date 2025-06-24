local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.QuasarConsts = {
    LASER_FRAMES = 100,
    LASER_DAMAGE = 66.6,
    N_CHARGES = 3,
}

function mod:OnQuasarObtained(collectibleType, charge, firstTime, slot, varData, player)
    
    if firstTime then
        mod.SaveManager.GetRunSave(player).quasarCharges = 6
    end
    
    if mod:ComparePlayer(player, Isaac.GetPlayer(0)) then
        mod.QuasarCharges = mod.SaveManager.GetRunSave(player).quasarCharges
    end

    if mod:ComparePlayer(player, Isaac.GetPlayer(0)) then
        mod:RemoveCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnQuasarRender)
        mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnQuasarRender)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.OnQuasarObtained, mod.SolarItems.Quasar)

function mod:OnQuasarActiveUse(collectibleType, rng, player, flags, slot, customVarData)

    if string.sub(player:GetSprite():GetAnimation(), 1, 6) == 'Pickup' then
        return
    end

    local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    local nItems = 0
    for i, item in ipairs(items) do
        if item.SubType > 0 then
            nItems = nItems + 1
            break
        end
    end
    
    mod.SaveManager.GetRunSave(player).quasarCharges = mod.SaveManager.GetRunSave(player).quasarCharges or 0

    if nItems > 0 then
        player:AnimateCollectible(collectibleType, "UseItem", "PlayerPickup")

        for i, _item in ipairs(items) do
            _item = _item:ToPickup()
            if _item.SubType > 0 and _item.Price == 0 then
                local item = _item:ToPickup()

                local deintegration = mod:SpawnDeintegration(item, 32, 32, 4, player, nil, 1, nil, nil, 1)
                deintegration:GetData().EnabledSound = true

                item:Remove()
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, item.Position, Vector.Zero, nil)

                local charges = 4 * (1 + mod:GetItemQuality(item.SubType))
                mod.SaveManager.GetRunSave(player).quasarCharges = mod.SaveManager.GetRunSave(player).quasarCharges + charges
            end
        end

        sfx:Play(SoundEffect.SOUND_MEGA_BLAST_END)
        sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)

    else
        if mod.SaveManager.GetRunSave(player).quasarCharges > 0 then
            player:AnimateCollectible(collectibleType, "LiftItem", "PlayerPickup")

            local angle = player:GetLastDirection():GetAngleDegrees()
            for i=0,1 do
                local n = 1 - 2*i
                local offset = Vector.Zero--Vector(n*40, 0):Rotated(angle)

                --local laser = mod:SpawnEntity(mod.Entity.HyperBeam, player.Position, Vector.Zero, player):ToLaser()
                --local laser = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.BEAST, 0, player.Position-offset, Vector.Zero, player):ToLaser()
                local laser = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.GIANT_BRIM_TECH, 0, player.Position-offset, Vector.Zero, player):ToLaser()
                
                laser.Angle = angle + 181*i
                laser.Timeout = mod.QuasarConsts.LASER_FRAMES
                laser.Parent = player
                laser.DisableFollowParent = false
                
                laser.CollisionDamage = mod.QuasarConsts.LASER_DAMAGE
        
                laser.DepthOffset = 2000
                        
                --laser:AddTearFlags(TearFlags.TEAR_RAINBOW)

                local color = Color(0,0,2,1,0.8,0.9,2)
                laser:GetSprite().Color = color
                laser:Update()
                laser:SetColor(color, 9999, 99, true, true)

                laser.PositionOffset = Vector(0,-55)

                sfx:Play(SoundEffect.SOUND_BEAST_ANGELIC_BLAST, 0.75, 2, false, 2)
                sfx:Play(mod.SFX.LightBeam, 1, 2, false, 1.4)
                sfx:Stop(SoundEffect.SOUND_MEGA_BLAST_LOOP)

                laser:GetData().QuasarLaser = true
                laser:GetData().QuasarId = i
            end

            local ogRoom = game:GetLevel():GetCurrentRoomIndex()
            mod:scheduleForUpdate(function ()
                if ogRoom == game:GetLevel():GetCurrentRoomIndex() and string.sub(player:GetSprite():GetAnimation(),1,1) == 'P' then
                    player:AnimateCollectible(collectibleType, "HideItem", "PlayerPickup")
                end
                mod:RemoveCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.OnQuasarLaserUpdate)
            end, mod.QuasarConsts.LASER_FRAMES+5)

            mod:RemoveCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.OnQuasarLaserUpdate)
            mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.OnQuasarLaserUpdate, LaserVariant.GIANT_BRIM_TECH)
            
            mod.SaveManager.GetRunSave(player).quasarCharges = mod.SaveManager.GetRunSave(player).quasarCharges - 1
        else
		    sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1)
        end
    end

    if mod:ComparePlayer(player, Isaac.GetPlayer(0)) then
        mod.QuasarCharges = mod.SaveManager.GetRunSave(player).quasarCharges
    end

end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnQuasarActiveUse, mod.SolarItems.Quasar)

function mod:OnQuasarLaserUpdate(entity)
    if entity:GetData().QuasarLaser then
        local player = entity.Parent:ToPlayer()

        local angle = player:GetLastDirection():GetAngleDegrees()
        entity.Angle = entity.Angle - entity:GetData().QuasarId*181
        entity.Angle = mod:AngleLerp(entity.Angle, angle, 0.1)
        entity.Angle = entity.Angle + entity:GetData().QuasarId*181
        
        sfx:Stop(SoundEffect.SOUND_MEGA_BLAST_LOOP)
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.OnQuasarLaserUpdate, mod.EntityInf[mod.Entity.HyperBeam].VAR)


function mod:OnQuasarRender()

    mod.QuasarCharges = mod.QuasarCharges or 0
    if not mod.QuasarText then
        mod.QuasarText = Font()
        mod.QuasarText:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
    end

    local text = mod.QuasarText
    if text then

        local dim = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
        local offsetVector = dim / dim:Length() * Options.HUDOffset * 25

		local iconPosition = Vector(24, 20) + offsetVector


        local nChagres = mod.QuasarCharges
        local chargeText = "x"..tostring(nChagres)

		text:DrawString(chargeText, iconPosition.X+ 2,  iconPosition.Y + 2, KColor(0,0,0,1),0,true)
		text:DrawString(chargeText, iconPosition.X,     iconPosition.Y,     KColor(1,1,1,1),0,true)


        --local hud = Game():GetHUD()
        --local sprite = hud:GetChargeBarSprite()
        --sprite:Play("BarEmpty", true)
        --print(sprite:Render(iconPosition))
    end

    if not Isaac.GetPlayer(0):HasCollectible(mod.SolarItems.Quasar)then
        mod:RemoveCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnQuasarRender)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnQuasarRender)


--DEINTRAGRATION ENTITY
function mod:SpawnDeintegration(ogEntity, dimX, dimY, size, targetEntity, targetPosition, strenght, offset, overlay, acceleration)
    offset = offset or Vector.Zero

    targetPosition = targetPosition or ogEntity.Position

    local effect = mod:SpawnEntity(mod.Entity.Deintegration, ogEntity.Position, Vector.Zero, nil)
    local data = effect:GetData()

    data.dimX = dimX
    data.dimY = dimY
    data.size = size
    data.dim = math.floor(math.sqrt(dimX*dimY))

    data.acc = acceleration or 1
    data.umbral = 10
    data.SoundFlag = 0

    data.targetEntity = targetEntity
    data.targetPosition = targetPosition
    data.Strenght = strenght

    --local hdimX = math.floor(dimX*0.5)
    --local hdimY = math.floor(dimY*0.5)
    --for i=-hdimX, hdimX-size, size do
    --    for j=-hdimY, hdimY-size, size do
    for i=0, dimX-size, size do
        for j=0, dimY-size, size do
            data["SuckPos"..tostring(i)..","..tostring(j)] = effect.Position

            local center = Vector(dimX, dimY)*0.5
            local direction = Vector(i,j) - center
            direction = direction * (1 + strenght*rng:RandomFloat()) * 0.1

            data["SuckVel"..tostring(i)..","..tostring(j)] = direction
        end
    end


    local sprite = Sprite()
    local pngs = {}
    for i=0, 8 do
        local layer = ogEntity:GetSprite():GetLayer(i)
        if layer and layer:IsVisible() then
            local png = layer:GetSpritesheetPath()
            table.insert(pngs, png)
        else
            break
        end
    end
    sprite:Load(ogEntity:GetSprite():GetFilename(), true)
    sprite:SetFrame(ogEntity:GetSprite():GetAnimation(), ogEntity:GetSprite():GetFrame())
    for i=0, 8 do
        local layer = sprite:GetLayer(i)
        if layer then
            local png = pngs[i+1]
            if png then
                sprite:ReplaceSpritesheet(i, png)
            end
        else
            break
        end
    end
    sprite:LoadGraphics()
    data.sprite = sprite

    return effect
end
function mod:DeintegrationUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Deintegration].SUB then
        if entity.FrameCount > 120 then entity:Remove() end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DeintegrationUpdate, mod.EntityInf[mod.Entity.Deintegration].VAR)

function mod:DeintegrationRender(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Deintegration].SUB then
        local data = entity:GetData()
        local sprite = data.sprite
        local room = game:GetRoom()
            
        local dimX = data.dimX
        local dimY = data.dimY
        local size = data.size
        local dim = data.dim

        data.acc = data.acc*1.05
        data.umbral = data.umbral + 0.5

        local targetEntity = data.targetEntity
        local targetPosition = data.targetPosition

        --local c = 0
        --local hdimX = math.floor(dimX*0.5)
        --local hdimY = math.floor(dimY*0.5)
        --for i=-hdimX, hdimX-size, size do
        --    for j=-hdimY, hdimY-size, size do
        for i=0, dimX-size, size do
            for j=0, dimY-size, size do
                --print(i,j)
                
                local position = data["SuckPos"..tostring(i)..","..tostring(j)]
                local velocity = data["SuckVel"..tostring(i)..","..tostring(j)]

                --local tposition = (targetEntity and targetEntity.Position) or targetPosition
                local tposition = (targetEntity and targetEntity.Position) or (4*size*Vector(i-dimX*0.5, j-dimY*0.5) + entity.Position)
                --local tposition = (4*size*Vector(i-dimX*0.5, j-dimY*0.5) + entity.Position)
                local tvelocity = (tposition - position):Normalized()*(data.acc*rng:RandomFloat())
    
                data["SuckVel"..tostring(i)..","..tostring(j)] = mod:Lerp(velocity, tvelocity, 0.075)
                data["SuckPos"..tostring(i)..","..tostring(j)] = position + velocity
    
                local step = Vector(i,j)
                local step2 = Vector(i+size,j+size)

                local clamp = step
                local clamp2 = Vector(dimX,dimY) - step2
                
                if not data["SuckFlag"..tostring(i)..","..tostring(j)] then
                    sprite:Render(room:WorldToScreenPosition(position), clamp, clamp2)
                end

                if (position):Distance(tposition) < data.umbral then
                    data["SuckFlag"..tostring(i)..","..tostring(j)] = true
                    if data.EnabledSound then
                        data.SoundFlag = data.SoundFlag + 1
                        if data.SoundFlag == 6 then
                            sfx:Play(SoundEffect.SOUND_POOPITEM_STORE, 1,2, false, 3)
                        end
                    end
                end

                --c=c+1
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.DeintegrationRender, mod.EntityInf[mod.Entity.Deintegration].VAR)