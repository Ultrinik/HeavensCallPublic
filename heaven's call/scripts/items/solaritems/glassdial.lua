local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local maxCharge = 30*60

function mod:OnDialUpdate(player)--game update
    local data = player:GetData()

    if data.WithDial then
        if data.DialTransformed then
            mod:DialTransformed(player)

            if player:HasCollectible(mod.SolarItems.Dial) then
                mod:ItemGainCharge(player, mod.SolarItems.Dial, -1)
                local collectibleType, slot = mod:GetCurrentDial(player)
                if player:GetActiveCharge(slot) <= 0 and data.DialTransformed then--destransform
                    data.DialTransformed = false
                    mod:DialDetransform(player)
                end
                
            end
        else
            local g = 0.5
            mod:ItemGainCharge(player, mod.SolarItems.Dial, g)
            for i=1, 8 do 
                local item = mod.SolarItems["Dial"..tostring(i)]
                if player:HasCollectible(item) then
                    mod:ItemGainCharge(player, item, g)
                end
            end
        end
    end
end

function mod:OnDialPlayerUpdate(player)--player update
    if Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then
        local collectibleType, slot = mod:GetCurrentDial(player)
        if slot and player:GetActiveCharge(slot) >= maxCharge then
            local newType = mod:SelectRandomDial(collectibleType)
            player:AddCollectible(newType, player:GetActiveCharge(slot), false, slot)
        end
        sfx:Play(mod.SFX.BismuthPick, 10)
    end

    mod:DialTransformedPlayer(player)
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnDialPlayerUpdate, 0)

function mod:OnDialActiveUse(collectibleType, rng, player, flags, slot, customVarData)--active use
    
    if collectibleType == mod.SolarItems.Dial then
        local newType = mod:SelectRandomDial(collectibleType)
        player:AddCollectible(newType, maxCharge, false, slot, customVarData)
        return {Discharge = false, Remove = false, ShowAnim = false}

    else
        --transform
        mod:DialTransform(player)

        player:AddCollectible(mod.SolarItems.Dial, maxCharge-1, false, slot, customVarData)
        mod:scheduleForUpdate(function()
            player:SetActiveCharge(maxCharge-1, slot)
        end, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnDialActiveUse, mod.SolarItems.Dial)
for i=0, 8 do 
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnDialActiveUse, mod.SolarItems["Dial"..tostring(i)]) 
end

--obtain/lose item
function mod:OnDialObtained(collectibleType, charge, firstTime, slot, varData, player)

    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnDialPlayerUpdate, 0)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.DialTransformedRender, 0)

    mod:scheduleForUpdate(function()
        local flag = player:HasCollectible(mod.SolarItems.Dial)
        for i=0, 8 do 
            flag = flag or player:HasCollectible(mod.SolarItems["Dial"..tostring(i)])
            if flag then break end
        end

        if flag then
            player:GetData().WithDial = true
            mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnDialPlayerUpdate, 0)
            mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.DialTransformedRender, 0)
        else
            player:GetData().WithDial = false
            mod:DialDetransform(player)
        end
    end, 1)

end
local auxF = function(_, player, collectibleType)
    mod:OnDialObtained(collectibleType, nil, nil, nil, nil, player)
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.OnDialObtained, mod.SolarItems.Dial)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, auxF, mod.SolarItems.Dial)
for i=0, 8 do
    mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.OnDialObtained, mod.SolarItems["Dial"..tostring(i)])
    mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, auxF, mod.SolarItems["Dial"..tostring(i)])
end

function mod:SelectRandomDial(collectibleType)
    if collectibleType == mod.SolarItems.Dial then
        local r = mod:RandomInt(1,8)
        local selected = mod.SolarItems["Dial"..tostring(r)]
        return selected
    else
        local a = mod.SolarItems.Dial1
        local b = mod.SolarItems.Dial8
        local r = (collectibleType-a+1)%8 + 1
        local selected = mod.SolarItems["Dial"..tostring(r)]
        return selected
    end
end

function mod:GetCurrentDial(player)
    local test = function(collectibleType)
        local slot
        if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == collectibleType then slot = ActiveSlot.SLOT_PRIMARY
        elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == collectibleType then slot = ActiveSlot.SLOT_SECONDARY
        elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == collectibleType then slot = ActiveSlot.SLOT_POCKET end
        if slot then
            return slot
        end
    end
    local slot = test(mod.SolarItems.Dial)
    if slot then return mod.SolarItems.Dial, slot end

    for i=1, 8 do
        local item = mod.SolarItems["Dial"..tostring(i)]
        slot = test(item)
        if slot then return item, slot end
    end
end

--trans
function mod:DialDetransform(player)
    if player:GetPlayerType() == mod.DollCharacterId then return end

    for i=1, 20 do
        local velocity = Vector(mod:RandomInt(5, 25), 0):Rotated(rng:RandomFloat()*360)
        local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, player.Position, velocity, nil)
    end
    
    sfx:Play(mod.SFX.EvilClock, 4)

    local light = mod:SpawnEntity(mod.Entity.TransformLight, player.Position+Vector(0,-30), Vector.Zero, player):ToEffect()
    light.DepthOffset = 100
    light:FollowParent(player)


    local data = player:GetData()

    player:GetSprite().Color.A = 1

    data.DialTransformed = false
    data.DialSprite = nil
    data.DialPlanet = nil

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end

function mod:DialTransform(player)
    for i=1, 20 do
        local velocity = Vector(mod:RandomInt(5, 25), 0):Rotated(rng:RandomFloat()*360)
        local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, player.Position, velocity, nil)
    end

    sfx:Play(mod.SFX.Triton, 4)

    local light = mod:SpawnEntity(mod.Entity.TransformLight, player.Position+Vector(0,-30), Vector.Zero, player):ToEffect()
    light.DepthOffset = 100
    light:FollowParent(player)


    local data = player:GetData()
    
    local planet, slot = mod:GetCurrentDial(player)
    data.DialPlanet = planet
    data.DialSprite = Sprite()

    local sprite = data.DialSprite

    if planet == mod.SolarItems.Dial1 then
        sprite:Load("hc/gfx/entity_Mercury.anm2", true)
        sprite:Play("IdleIdle", true)

    elseif planet == mod.SolarItems.Dial2 then
        sprite:Load("hc/gfx/entity_Venus.anm2", true)
        sprite:Play("Idle", true)
    elseif planet == mod.SolarItems.Dial3 then
        sprite:Load("hc/gfx/entity_Terra1.anm2", true)
        sprite:Play("Idle", true)
    elseif planet == mod.SolarItems.Dial4 then
        sprite:Load("hc/gfx/entity_Mars.anm2", true)
        sprite:Play("Idle", true)
    elseif planet == mod.SolarItems.Dial5 then
        sprite:Load("hc/gfx/entity_Jupiter.anm2", true)
        sprite:Play("Idle", true)
    elseif planet == mod.SolarItems.Dial6 then
        sprite:Load("hc/gfx/entity_Saturn.anm2", true)
        sprite:Play("Idle", true)
    elseif planet == mod.SolarItems.Dial7 then
        sprite:Load("hc/gfx/entity_Uranus.anm2", true)
        sprite:Play("Idle", true)
    elseif planet == mod.SolarItems.Dial8 then
        sprite:Load("hc/gfx/entity_Neptune.anm2", true)
        sprite:Play("Idle", true)
    end

    data.DialTransformed = true

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
end

--TRANSFORMATIONS
function mod:DialTransformed(player)--game update
    local data = player:GetData()
    if data.DialSprite then
        local sprite = data.DialSprite
        local planet = data.DialPlanet
        local room = game:GetRoom()
        
        sprite:Update()
    end
end

function mod:DialTransformedRender(player)--player render
    local data = player:GetData()

    if data.WithDial then
        if data.DialTransformed then

            if data.DialSprite then
                local sprite = data.DialSprite
                local planet = data.DialPlanet
                local room = game:GetRoom()
        
                sprite:Render(room:WorldToScreenPosition(player.Position))
            end
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.DialTransformedRender, 0)

function mod:DialTransformedPlayer(player)--player update
    local data = player:GetData()
    if data.DialSprite then
        player.ControlsCooldown = 1

        player:GetSprite().Color.A = 0

        local sprite = data.DialSprite
        local room = game:GetRoom()
        local planet = data.DialPlanet


        local shotDirection =   Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex)*Vector(1,0) +
                                Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex)*Vector(0,-1) +
                                Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex)*Vector(-1,0) +
                                Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)*Vector(0,1)
        shotDirection = shotDirection:Normalized()
        data.shotDirection_HC = shotDirection

        local moveDirection =   Input.GetActionValue(ButtonAction.ACTION_RIGHT, player.ControllerIndex)*Vector(1,0) +
                                Input.GetActionValue(ButtonAction.ACTION_UP, player.ControllerIndex)*Vector(0,-1) +
                                Input.GetActionValue(ButtonAction.ACTION_LEFT, player.ControllerIndex)*Vector(-1,0) +
                                Input.GetActionValue(ButtonAction.ACTION_DOWN, player.ControllerIndex)*Vector(0,1)
        moveDirection = moveDirection:Normalized()
        data.moveDirection_HC = moveDirection

        local h = 0.05

        local speed = 1
        local speedMult = 10

        if player:GetSprite():IsPlaying("Appear") then
            speedMult = 0
        end

        if planet == mod.SolarItems.Dial1 then--mercury
            speed = 4
            if sprite:IsPlaying("Idle") and sprite:GetFrame() < 3 then
                speedMult = 0.5
            end

            if not data.moveLock_HC and not (sprite:IsPlaying("CrashR") or sprite:IsPlaying("CrashL")) then
                if moveDirection:Length() > 0 and shotDirection:Length() <= 0 and not sprite:IsPlaying("Idle") then
                    sprite:Play("Idle", true)
                elseif moveDirection:Length() <= 0 and sprite:IsFinished("Idle") then
                    sprite:Play("IdleIdle", true)
                elseif sprite:IsFinished("Idle") then
                    sprite:Play("Idle", true)
                end
            end

            if sprite:IsFinished("CrashR") or sprite:IsFinished("CrashL") then
                sprite:Play("Idle", true)
            elseif sprite:IsPlaying("CrashR") or sprite:IsPlaying("CrashL") then
                speedMult = 0
            end

            if shotDirection:Length() > 0 then
                speedMult = 0
            end

            mod:DialMercury(player, data, sprite, room)
        elseif planet == mod.SolarItems.Dial2 then--venus
        elseif planet == mod.SolarItems.Dial3 then--terra
        elseif planet == mod.SolarItems.Dial4 then--mars
        elseif planet == mod.SolarItems.Dial5 then--jupiter
            speed = 0.67
        elseif planet == mod.SolarItems.Dial6 then--saturn
        elseif planet == mod.SolarItems.Dial7 then--uranus
        elseif planet == mod.SolarItems.Dial8 then--neptune
        end

        if not data.moveLock_HC then
            player.Velocity = mod:Lerp(player.Velocity, moveDirection*speed*speedMult, h)
        end
    end
end

--beha
function mod:DialMercury(player, data, sprite, room)
    local shotDirection = data.shotDirection_HC
    local moveDirection = data.moveDirection_HC

    mod:MercuryColor(player, sprite, room)
    
    if sprite:IsPlaying("Horn") then
        data.moveLock_HC = true
        if sprite:IsEventTriggered("Shot") then
            local victim = mod:GetTargetEnemy(player, 9999) or player
            local horn = mod:SpawnEntity(mod.Entity.Horn, victim.Position, Vector.Zero, player)
            horn.Parent = player
    
        elseif sprite:IsEventTriggered("Sound") then
            sfx:Play(SoundEffect.SOUND_BULLET_SHOT,3)
        end

    else

        if shotDirection:Length() > 0 then
            --Spindash
            if sprite:GetAnimation() ~= "SpindashIdle" then
                mod:MercurySpindashAngle(player, data, player.Position+shotDirection, sprite)
                sprite:Play("SpindashIdle", true)
                sfx:Play(mod.SFX.Spindash, 1)
            end
            if player.FrameCount%5==0 then
                mod:MercurySpindashAngle(player, data, player.Position+shotDirection, sprite)
            end
    
            --Charge
            data.moveLock_HC  = true
    
            data.moveBoost_HC = data.moveBoost_HC or Vector.Zero
            data.moveBoost_HC = data.moveBoost_HC + shotDirection*2
            data.moveBoost_HC = Vector(data.moveBoost_HC:Length(), 0):Rotated(shotDirection:GetAngleDegrees())
            if data.moveBoost_HC:Length() > 75 then
                data.moveBoost_HC = data.moveBoost_HC:Normalized()*75
            end
    
            --tears
            if player.FrameCount%3 == 0 then
    
                local velocity = -shotDirection*(15 + 15*rng:RandomFloat())
                velocity = velocity:Rotated(mod:RandomInt(-15,15))
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, player.Position, velocity, player):ToTear()
                tear:GetSprite().Color = mod.Colors.mercury
                tear.Height = -10
                tear.FallingSpeed = -20
                tear.FallingAcceleration = 5
            end
    
        else
            if data.moveBoost_HC and data.moveBoost_HC:Length() > 1 then
                if sprite:IsPlaying("SpindashIdle") then
                    sprite:Play("SpindashVanilla", true)
    
                    --fix target
                    local minAngle = 9999
                    local minEntity
                    for i, entity in ipairs(Isaac.GetRoomEntities()) do
                        if mod:IsVulnerableEnemy(entity) then
                            local p = entity.Position - player.Position
                            local dot = p.X*data.moveBoost_HC.X + p.Y*data.moveBoost_HC.Y
    
                            local angle = dot/(p:Length()*data.moveBoost_HC:Length())
                            local angle = math.acos(angle)*180/math.pi
    
                            if angle < minAngle and angle < 60 then
                                minAngle = angle
                                minEntity = entity
                            end
                        end
                    end
                    if minEntity then
                        local l = data.moveBoost_HC:Length()
                        data.moveBoost_HC = (minEntity.Position - player.Position):Normalized() * l
                    end
    
                    player.Velocity = data.moveBoost_HC
    
                    --effect
                    if data.moveBoost_HC:Length() > 25 then
                        local sonicBoom = mod:SpawnEntity(mod.Entity.SonicBoom, player.Position + Vector(0,-40), Vector.Zero, player):ToEffect()
                        sonicBoom:FollowParent(player)
                        sonicBoom:GetSprite().Rotation = data.moveBoost_HC:GetAngleDegrees() - 180
                        sonicBoom.DepthOffset = 60
                    end
                    
                elseif sprite:IsPlaying("SpindashVanilla") then
                    for i, entity in ipairs(Isaac.GetRoomEntities()) do
                        if mod:IsVulnerableEnemy(entity) and entity.Position:Distance(player.Position)<40 then
                            local damage = player.Damage*(5 + 5*player.Velocity:Length()/75)
                            entity:TakeDamage(damage, DamageFlag.DAMAGE_CRUSH, EntityRef(player), 5)
                        end
                    end
                end
    
                if player.Velocity:Length() < 5 then
                    data.moveBoost_HC = Vector.Zero
                end
    
                if player:CollidesWithGrid() and player.Velocity:Length() > 5 then
                    if player.Velocity.X > 0 then
                        sprite:Play("CrashR", true)
                    else
                        sprite:Play("CrashL", true)
                    end
                    player.Velocity = Vector.Zero
                    data.moveBoost_HC = Vector.Zero
                    player:SetMinDamageCooldown(90)
    
                    for i=1, 30 do
                        local angle = i*360/48
                        local velocity = Vector(1,0)*(2 + 8*rng:RandomFloat())
                        velocity = velocity:Rotated(mod:RandomInt(-15,15)+angle)
                        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, player.Position, velocity, player):ToTear()
                        tear:GetSprite().Color = mod.Colors.mercury
                        tear.Height = -15
                        tear.FallingSpeed = -30
                        tear.FallingAcceleration = 2
                        tear.CollisionDamage = 7
                    end
                end
            else
                data.moveLock_HC  = false
                data.moveBoost_HC = Vector.Zero
                if sprite:IsPlaying("SpindashVanilla") then
                    player:SetMinDamageCooldown(15)
                    sprite:Play("Idle", true)
                end
            end
        end

        if Input.IsActionTriggered (ButtonAction.ACTION_ITEM, player.ControllerIndex) then
            data.moveLock_HC = true
            sprite:Play("Horn", true)
        end
    end
    if sprite:IsFinished("Horn") then
        sprite:Play("Idle", true)
        data.moveLock_HC = false
    end
end
function mod:DialVenus(player, data, sprite)

end
function mod:DialTerra(player, data, sprite)

end
function mod:DialMars(player, data, sprite)

end
function mod:DialJupiter(player, data, sprite)

end
function mod:DialSaturn(player, data, sprite)

end
function mod:DialUranus(player, data, sprite)

end
function mod:DialNeptune(player, data, sprite)

end


function mod:DamageDial(player, amount, flags, source, frames)
    local data = player:GetData()
    local sprite = data.DialSprite
    player = player:ToPlayer()
    if player and sprite and data.DialTransformed then

        if sprite:IsPlaying("SpindashVanilla") then
            return false
        end

        --Charge
        local hit = math.floor(maxCharge/10)
        mod:ItemGainCharge(player, mod.SolarItems.Dial, -hit)
        for i=1, 8 do 
            local item = mod.SolarItems["Dial"..tostring(i)]
            if player:HasCollectible(item) then
                mod:ItemGainCharge(player, item, -hit)
            end
        end
        sfx:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT, 2,2,false,2)
        player:SetMinDamageCooldown(30)
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DamageDial, EntityType.ENTITY_PLAYER)