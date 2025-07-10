local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@&%#///(#&&@&/ *#%/ ,#%/ ,#%/ *%@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&(/*,,,,*/#&@@&#//#&%(/#&%(/#&%(/#@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&(/*,,,,*/#&@@&#//#&%(/#&%(/#&%##%@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@#/*,,*/#&@@&%##%&%##%&%##%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%&&@@&((#&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@&#(//////(#&&/ *%@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@%(#&@#/(&@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%&&&&&&&@@&#(##%@@%#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%(*/(%@&#*/(##%&&%(*/(##%&&&#*/(##%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#,.(@@@&/ .,*/(#%%* .,*/(#%%/ .,*/(%&@&&&@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#,.(@@@&/ .,*/(#%%* .,*/(#%%/ .,*/(%&@@&&&&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#,.(@@@@&&%###%&&&&&%###%&&&&&%###%&@@@@@@&&&&@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%(/%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%(***/((((#&%(*,                   .,***/((((%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&&&&%(%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&#(/*,    .,*/(%&@@@@@@%#(/*.    .*/(#%@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@&&&%#((/***/(##%&&&&&&&&&&%#(/****/(#%&&&@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@%((/*.         ,*/(#%&%#(/*,.        .,*/(%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@%((/*.         ,*/(#%&%#(/*,.        .,*/(%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&&%#(/*********/(#%&&&&&%#((/********/(##%&@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@%((/*.         ,*/(#%&%#(/*,.        .,*/(%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

local costs = {
    sword = 8,
    lung = 12,
    techx = 25,
    default = 1
}

function mod:OnEngineUpdate(player)
    if player:HasCollectible(mod.SolarItems.Engine) then

        local damageMultiplier = 1

        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
            damageMultiplier = damageMultiplier + 0.5
        end

        local range = 75 * player.TearRange/260
        local damage = player.Damage * damageMultiplier
        local maxTime = 100 / player.MaxFireDelay * 30
        local rechargeSpeed = player.ShotSpeed*1.33

        local data = player:GetData()
        data.EngineMaxTime_HC = maxTime
        data.EngineCounter_HC = player:GetData().EngineCounter_HC or 0
        data.EngineForceBlock_HC = data.EngineForceBlock_HC or 0

        if not data.EngineSprite_HC then
            local sprite = Sprite()
            sprite:Load("hc/gfx/effect_Chargebar.anm2", true)

            data.EngineSprite_HC = sprite
        end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
            mod:EngineSwordUpdate(player, player, true, false, range, damage, maxTime, rechargeSpeed)
   
        elseif not (player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION)) then
            mod:EngineShooterUpdate(player, player, true, false, range, damage, maxTime, rechargeSpeed)
        end

    elseif player:GetData().EngineUpdate_HC then
        player:GetData().EngineUpdate_HC = false
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    end
end

mod.PlayerLasers = {}

local function banShot2(_, entity, hook, button)
    for i=0, game:GetNumPlayers ()-1 do
        local player = game:GetPlayer(i)
        if player then
            if Input.GetActionValue(button, player.ControllerIndex) > 0 then
                if button == ButtonAction.ACTION_SHOOTLEFT or button == ButtonAction.ACTION_SHOOTRIGHT or button == ButtonAction.ACTION_SHOOTUP or button == ButtonAction.ACTION_SHOOTDOWN then
                    mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, banShot2)
                    return false
                end
            end
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, banShot2, InputHook.GET_ACTION_TRIGGER)

local function banShot(_, entity, hook, button)
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
            if Input.GetActionValue(button, player.ControllerIndex) > 0 then
                if button == ButtonAction.ACTION_SHOOTLEFT or button == ButtonAction.ACTION_SHOOTRIGHT or button == ButtonAction.ACTION_SHOOTUP or button == ButtonAction.ACTION_SHOOTDOWN then
                    mod:scheduleForUpdate(function()
                        mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, banShot)
                        mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, banShot2, InputHook.IS_ACTION_TRIGGERED)
                    end, 1)
                    return 0
                end
            end
		end
	end
end

function mod:EngineShooterUpdate(entity, player, setFiredelay, isFamiliar, range, damage, maxTime, rechargeSpeed)
    local data = entity:GetData()
    local playerData = player:GetData()

    data.EngineCounter_HC = data.EngineCounter_HC or 0
    data.EngineUpdate_HC = true

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then range = 0 end

    player:GetSprite():PlayOverlay("head", false)

    local playerLaserId = 0
    local function OnEngineInactive()

        if data.IsEngineActive then
            data.IsEngineActive = false
            mod:SetEngineCostume(player, false, isFamiliar)
        end 

        if data.EngineExhausted_HC then
            data.EngineCounter_HC = math.max(0, data.EngineCounter_HC - rechargeSpeed)
        else
            data.EngineCounter_HC = math.max(0, data.EngineCounter_HC - rechargeSpeed*1.5)
        end
        if data.EngineCounter_HC <= 0 then
            if data.EngineExhausted_HC then
                sfx:Play(mod.SFX.EngineLoaded)
            end
            data.EngineExhausted_HC = false
        end

        if mod.PlayerLasers[playerLaserId] then
            for i=1, #mod.PlayerLasers[playerLaserId] do
                local laser = mod.PlayerLasers[playerLaserId][i]
                laser:Remove()
            end

            mod.PlayerLasers[playerLaserId] = nil
        end
    end

    if setFiredelay == nil then setFiredelay = true end

    local isForgotten = ((player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B) and player:HasWeaponType(WeaponType.WEAPON_BONE)) or player.SamsonBerserkCharge > 0
    if isForgotten then
        data.EngineForceBlock_HC = 0
    end

    local chargedFlag = player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) or player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)

    if data.EngineForceBlock_HC and data.EngineForceBlock_HC <= 0 then
        if not (data.EngineExhausted_HC and isForgotten)
        and not (player:GetPlayerType() == PlayerType.PLAYER_LILITH_B)
        and setFiredelay then
            --Prevent normal firing
            player.FireDelay = 30
        end

        local shotDirection = playerData.CurrentAttackDirection_DIG_HC

        --local playerLaserId = (not isFamiliar) and mod:PlayerId(player) or isFamiliar and entity.InitSeed
        playerLaserId = mod:PlayerId(player)

        if ( (player:CanShoot() or player:GetPlayerType() == PlayerType.PLAYER_LILITH) or entity:ToFamiliar()) and (shotDirection and shotDirection:Length() > 0.1) and not data.EngineExhausted_HC and data.EngineCounter_HC < maxTime then
            if not data.IsEngineActive then
                data.IsEngineActive = true

                mod:SetEngineCostume(player, true, isFamiliar)

                local numberTears =  math.min(16, mod:GetNumOfTearShots(player) + math.max(0, player:GetCollectibleNum(mod.SolarItems.Engine)))

                local maxAngle = math.sqrt((numberTears-1)*60*60/15)

                mod.PlayerLasers[playerLaserId] = {}
                for i=1, numberTears do
                    local angle = -maxAngle + 2*maxAngle*(i-0.5)/numberTears

                    if chargedFlag then
                        local cost = 0
                        local consumeFlag = false
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
                            cost = math.max(costs.techx, cost)
                            if true then

                                local lasers = mod:FindByTypeMod(mod.Entity.EngineLaser, nil, LaserSubType.LASER_SUBTYPE_RING_PROJECTILE)
                                if not lasers[#lasers] or lasers[#lasers] and lasers[#lasers].FrameCount > 10 then
                                    consumeFlag = true

                                    --spawn laser
                                    local trueAngle = (angle + shotDirection:GetAngleDegrees() + 360)%360
                                    local velocity = Vector(10, 0):Rotated(trueAngle)*player.ShotSpeed
                                    --local laser = mod:SpawnEntity(mod.Entity.EngineLaser, entity.Position, velocity, entity, nil, LaserSubType.LASER_SUBTYPE_RING_PROJECTILE):ToLaser()
                                    local ring = Isaac.Spawn(EntityType.ENTITY_LASER, mod.EntityInf[mod.Entity.EngineLaser].VAR, LaserSubType.LASER_SUBTYPE_RING_PROJECTILE, entity.Position, velocity, entity):ToLaser()
                                    ring.Parent = entity
                                    ring.Radius = 50
                                    ring.CollisionDamage = damage/2

                                    ring.Velocity = velocity
                                    ring.Angle = angle
                                end
                            end
                        end
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                            cost = math.max(costs.lung, cost)
                            if true then
                                consumeFlag = true

                                local tearsAmount = 11
                                for j=1, tearsAmount do
                                    local vel = shotDirection:Rotated(math.random(-15*j-100, 15*j+100)/10)*(10*(0.5 + rng:RandomFloat()))*player.ShotSpeed
                                    vel = vel + entity.Velocity/2
                                    local tear = player:FireTear(entity.Position, vel, true, false, true, entity, 0.67)
                                    tear:ChangeVariant(TearVariant.FIRE_MIND)
                                    local rand = mod:RandomInt(0,8000)/1000
                                    tear.Height = tear.Height - rand
                                    tear.FallingSpeed = tear.FallingSpeed - rand
                                    tear.FallingAcceleration = tear.FallingAcceleration + 0.5
                                    --tear:GetSprite().Color = mod.Colors.fire
                                    --tear:AddTearFlags(TearFlags.TEAR_BURN)
                                    tear.Scale = tear.Scale*(0.5 + rng:RandomFloat())
                                end
                            end
                        end

                        if consumeFlag then
                            data.EngineCounter_HC = data.EngineCounter_HC + cost
                            if data.EngineCounter_HC >= maxTime then
                                data.EngineCounter_HC = maxTime
                                data.EngineExhausted_HC = true
                            end
                        end
                    else
    
                        local laser = EntityLaser.ShootAngle(mod.EntityInf[mod.Entity.EngineLaser].VAR, entity.Position, angle, 0, Vector(0,-25), entity)
                        local laserData = laser:GetData()
                        laserData.OriginalAngle_HC = angle
                        laser.Angle = (laser.Angle + shotDirection:GetAngleDegrees() + 360)%360
                        --local laser = player:FireBrimstone(shotDirection)
            
                        --laser.Timeout = 0
                        --laser.ParentOffset = Vector(0, -20)
                        --laser.PositionOffset = Vector.Zero
                        laser.MaxDistance = range
                        
                        laser.TearFlags = laser.TearFlags | player.TearFlags
                        laser:SetColor(player.TearColor, 0, 99, true, true)
            
                        laser.CollisionDamage = damage/2
    
                        laser:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
    
                        --endSprite
                        laserData.TailSprite = Sprite()
                        laserData.TailSprite:Load("hc/gfx/laser_EngineLaser.anm2", true)
                        laserData.TailSprite:Play("Tail", true)
    
                        mod.PlayerLasers[playerLaserId][i] = laser
                    end
                end

                sfx:Play(mod.SFX.Fireblast)

            elseif mod.PlayerLasers[playerLaserId] and #mod.PlayerLasers[playerLaserId]>0 then

                data.EngineCounter_HC = data.EngineCounter_HC + costs.default
                if data.EngineCounter_HC >= maxTime then
                    data.EngineExhausted_HC = true
                end

                for i=1, #mod.PlayerLasers[playerLaserId] do
                    local laser = mod.PlayerLasers[playerLaserId][i]
                    mod:EngineLaserUpdate(entity, player, laser, maxTime, shotDirection, range)
                end
            elseif chargedFlag and not data.EngineExhausted_HC then
                
                data.EngineCounter_HC = math.max(0, data.EngineCounter_HC - rechargeSpeed*1.33)
                if player.FrameCount%2==0 then
                    mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, banShot)
                    mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, banShot, InputHook.GET_ACTION_VALUE)
                end
            end
        else
            if data.EngineExhausted_HC and (shotDirection and shotDirection:Length() > 0.1) then
                mod:OnEngineNoFuel(entity, playerData)
            end
            OnEngineInactive()
        end
    else
        OnEngineInactive()
    end
    data.EngineForceBlock_HC = data.EngineForceBlock_HC - 1
end

function mod:EngineShooterRender(player)
    if player:HasCollectible(mod.SolarItems.Engine) then
        local data = player:GetData()
        local room = game:GetRoom()

        local playerLaserId = mod:PlayerId(player)

        if data.EngineForceBlock_HC and data.EngineForceBlock_HC <= 0 then
            if mod.PlayerLasers[playerLaserId] then

                for i=1, #mod.PlayerLasers[playerLaserId] do
                    local laser = mod.PlayerLasers[playerLaserId][i]
                    if laser and laser.FrameCount > 0 and laser.MaxDistance > 0 then
                        local laserData = laser:GetData()
                        local endPoint = Vector(laser.MaxDistance + 23, 0):Rotated(laser.Angle)

                        local sprite = laserData.TailSprite
                        if sprite then
                            sprite.Color = laser:GetSprite().Color
                            sprite.Rotation = laser.Angle
                            sprite:SetFrame((sprite:GetFrame()+1)%4)
                            local position = endPoint + player.Position + laser.PositionOffset - player.Velocity*(0.00239017*laser.MaxDistance + 0.783237)--laser.MaxDistance/75 + laser.MaxDistance^2/75)
                            --local position = laser:GetEndPoint() + laser.PositionOffset - player.Velocity/2
                            if room:IsPositionInRoom(position, 0) then
                                sprite:Render(room:WorldToScreenPosition (position))
                            end
                        end
                    end
                end
            end

            local shotDirection = data.CurrentAttackDirection_DIG_HC
            if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) and shotDirection and shotDirection:Length() > 0.1 then
                mod.hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, 5)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.EngineShooterRender, 0)

function mod:OnEngineNoFuel(player, data)
    if not sfx:IsPlaying(mod.SFX.NoFuel) then
        sfx:Play(mod.SFX.NoFuel)
    end
    local direction = data.CurrentAttackDirection_DIG_HC
    if direction then
        for i=2,5 do
            local velocity = direction:Rotated(mod:RandomInt(-10,10))*(8 + 8*rng:RandomFloat())
            local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, player.Position, velocity, nil)
            smoke.SpriteOffset = Vector(0,-20)
            smoke:GetSprite().Color = Color(0.1,0.1,0.1, 1)
        end
    end
end

function mod:EngineSwordUpdate(entity, player, setFiredelay, isFamiliar, range, damage, maxTime, rechargeSpeed)
    local data = player:GetData()

    if data.EngineExhausted_HC then
        data.EngineCounter_HC = math.max(0, data.EngineCounter_HC - rechargeSpeed*0.67)
    else
        data.EngineCounter_HC = math.max(0, data.EngineCounter_HC - rechargeSpeed*1.33)
    end
    if data.EngineCounter_HC <= 0 then
        if data.EngineExhausted_HC then
            sfx:Play(mod.SFX.EngineLoaded)
        end
        data.EngineExhausted_HC = false
    end
end

function mod:SetEngineCostume(player, active, isFamiliar)
    if not isFamiliar then
        if active then
            local costume = Isaac.GetCostumeIdByPath("hc/gfx/characters/costume_engineActive.anm2")
            player:AddNullCostume(costume) 
        else
            local costume = Isaac.GetCostumeIdByPath("hc/gfx/characters/costume_engineActive.anm2")
            player:TryRemoveNullCostume(costume) 
        end
    end
end

function mod:EngineLaserUpdate(entity, player, laser, maxTime, shotDirection, range)

    if laser:GetData().OriginalAngle_HC then
        laser.Angle = shotDirection:GetAngleDegrees() + 360 - laser:GetData().OriginalAngle_HC
        laser.PositionOffset = Vector(0, -30) + Vector(20*shotDirection.X, -8*shotDirection.Y)
        laser.ParentOffset = shotDirection*10
        laser.DepthOffset = 0 + 2*shotDirection.Y

        --Invisible tear that does 0 damage for debuff effects
        if player.FrameCount % 10 == 0 then
            local velocity = shotDirection* range/75 *20 + entity.Velocity
            local fallSpeed = range/75 *6
            local tear = player:FireTear (entity.Position, velocity)
            tear.CollisionDamage = 0
            tear.FallingSpeed = fallSpeed
            tear:SetColor(Color(1,1,1,0), 0, 99, true, true)
            tear.SpriteScale = Vector.Zero

            tear:ClearTearFlags(TearFlags.TEAR_SPLIT | TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_WIGGLE | 
            TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_BOUNCE | TearFlags.TEAR_PULSE | TearFlags.TEAR_SPIRAL | 
            TearFlags.TEAR_FETUS | TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_LASERSHOT)-- | TearFlags.TEAR_HOMING)

        end

        sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
        sfx:Stop(SoundEffect.SOUND_TEARIMPACTS)
        sfx:Stop(SoundEffect.SOUND_SPLATTER)
    else
        entity:Die()
    end
end

function mod:OnKnifeEngineUpdate(knife)
    local player = knife.Parent and (knife.Parent:ToPlayer() or knife.Parent:ToFamiliar() and knife.Parent:ToFamiliar().Player)
    if player and player:HasCollectible(mod.SolarItems.Engine) then
        if knife.Variant == 0 or knife.Variant == 5 then

            local knifeSprite = knife:GetSprite()
            local heat = 1/( knife:GetKnifeDistance()/25 +1)
            knifeSprite.Color = Color(1,1,1,1, 1*heat,0.25*heat,0)

            if knife.Charge > 0.5 and knife:IsFlying() and knife:GetKnifeVelocity() > 0 and knife.FrameCount % 3 == 0 then

                --Knife is going to max distance
                local velocity = knife:GetKnifeVelocity() * Vector.FromAngle(knife.Rotation + (-20 + 40*rng:RandomFloat()))
                --local fire = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE, 0, knife.Position, velocity*0.5, knife)
                
                --local fire = Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 10, 0, knife.Position, velocity*0.9, knife.Parent)
                --fire.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
                --fire:AddCharmed(EntityRef(knife.Parent), -1)

                local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, knife.Position, velocity*0.9, knife.Parent)
                fire.CollisionDamage = 0.75
            end

        elseif (knife.Variant == 10 or knife.Variant == 11) then
            mod:OnSwordEngineUpdate(knife, player)  
        elseif (knife.Variant == 1 or knife.Variant == 2 or knife.Variant == 3 or knife.Variant == 4 or knife.Variant == 9) then
            mod:OnClubEngineUpdate(knife, player)  
        end
    end
    
end
function mod:OnSwordEngineUpdate(sword, player)
    local playerData = player:GetData()

    if playerData.EngineExhausted_HC then
        sfx:Stop(SoundEffect.SOUND_SHELLGAME)
        mod:scheduleForUpdate(function()
            sfx:Stop(SoundEffect.SOUND_SHELLGAME)
        end,1)
        mod:OnEngineNoFuel(player, playerData)

        sword:GetSprite().Color = Color(1,1,1,0)
        sword:Remove()

    else
        if not playerData.SwordSwitch then
            if sword:GetSprite():GetAnimation() ~= 'SpinRight' then
                sword:GetSprite():Play("SpinRight", true)
                sfx:Stop(SoundEffect.SOUND_SHELLGAME)
                mod:scheduleForUpdate(function()
                    sfx:Stop(SoundEffect.SOUND_SHELLGAME)
                end,1)
                sfx:Play(SoundEffect.SOUND_SWORD_SPIN)
                sfx:Play(mod.SFX.Fireblast)

                playerData.EngineCounter_HC = playerData.EngineCounter_HC + costs.sword
                playerData.SwordSwitch = true
                if playerData.EngineCounter_HC > playerData.EngineMaxTime_HC then
                    playerData.EngineExhausted_HC = true
                end
            end
        else
            if not playerData.CurrentAttackDirection_HC then
                playerData.SwordSwitch = false 
            end
        end
    end
end
function mod:OnClubEngineUpdate(club, player)
    local playerData = player:GetData()
    playerData.EngineForceBlock_HC = 2

    --[[if playerData.EngineMaxTime_HC and not playerData.EngineExhausted_HC then

        if (club:GetSprite():GetAnimation() == 'Swing' or club:GetSprite():GetAnimation() == 'Swing2') and club:GetSprite():IsFinished() then
            if club:GetSprite():GetAnimation() == 'Swing2' then
                club:GetSprite():Play("Swing", true)
            else
                club:GetSprite():Play("Swing2", true)
            end

            playerData.EngineCounter_HC = playerData.EngineCounter_HC + 1
            if playerData.EngineCounter_HC > playerData.EngineMaxTime_HC then
                playerData.EngineExhausted_HC = true
            end
        end
    end]]
    
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.OnKnifeEngineUpdate)

function mod:OnEngineBombInit(bomb)

    local player = bomb.SpawnerEntity and (bomb.SpawnerEntity:ToPlayer() or bomb.SpawnerEntity:ToFamiliar() and bomb.SpawnerEntity:ToFamiliar().Player)
    if player and player:HasCollectible(mod.SolarItems.Engine) and player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
        if not bomb:GetData().IsDirected_HC then
            if bomb.Variant == BombVariant.BOMB_ROCKET then
        
                local rocketSprite = bomb:GetSprite()
        
                mod:scheduleForUpdate(function()
                    rocketSprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/engine_rockets.png")
                    rocketSprite:LoadGraphics()
                end, 1)
        
                mod:scheduleForUpdate(function()
                    if bomb then
                        bomb.Velocity = bomb.Velocity/3
                        bomb:AddTearFlags(TearFlags.TEAR_HOMING)
        
                        mod:scheduleForUpdate(function()
                            rocketSprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/engine_rockets.png")
                            rocketSprite:LoadGraphics()
                        end, 0, ModCallbacks.MC_POST_RENDER)
                    end
                end, 15)
            else
                local rocket = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_ROCKET, 0, bomb.Position, Vector.Zero, player):ToBomb()
        
                local rocketSprite = rocket:GetSprite()
        
                mod:scheduleForUpdate(function()
                    if rocket then
        
                        rocket.ExplosionDamage = bomb.ExplosionDamage
                        rocket.Flags = bomb.Flags
                        rocket.RadiusMultiplier = bomb.RadiusMultiplier
                
                        --rocket:GetData().Engine_HC = true
                        rocket:GetData().IsDirected_HC = true
                        rocket:GetData().Direction = bomb.Velocity/5
                        rocket:GetSprite().Rotation = rocket:GetData().Direction:GetAngleDegrees()
                        rocket:AddTearFlags(TearFlags.TEAR_HOMING)
                        if not rocket:HasTearFlags(TearFlags.TEAR_HOMING) then
                        end
        
                        mod:scheduleForUpdate(function()
                            rocketSprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/engine_rockets.png")
                            rocketSprite:LoadGraphics()
                        end, 0, ModCallbacks.MC_POST_RENDER)
        
                        bomb:Remove()
                    end
                end, 2)
            end
        end
    end

end
function mod:OnEngineBombInitOld(bomb)

    local player = bomb.SpawnerEntity and (bomb.SpawnerEntity:ToPlayer() or bomb.SpawnerEntity:ToFamiliar() and bomb.SpawnerEntity:ToFamiliar().Player)
    if (bomb.Velocity:Length() > 1) and not bomb:GetData().Engine_HC and player and player:HasCollectible(mod.SolarItems.Engine) then

        local rocket = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_ROCKET, 0, bomb.Position, Vector.Zero, player):ToBomb()

        local rocketSprite = rocket:GetSprite()

        mod:scheduleForUpdate(function()
            if rocket then

                rocket.ExplosionDamage = bomb.ExplosionDamage
                rocket.Flags = bomb.Flags
                rocket.RadiusMultiplier = bomb.RadiusMultiplier
        
                rocket:GetData().Engine_HC = true
                rocket:GetData().IsDirected_HC = true
                rocket:GetData().Direction = bomb.Velocity/5
                rocket:GetSprite().Rotation = rocket:GetData().Direction:GetAngleDegrees()
                rocket:AddTearFlags(TearFlags.TEAR_HOMING)
                if not rocket:HasTearFlags(TearFlags.TEAR_HOMING) then
                end

                mod:scheduleForUpdate(function()
                    rocketSprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/engine_rockets.png")
                    rocketSprite:LoadGraphics()
                end, 1)

                mod:scheduleForUpdate(function()
                    if rocket then
                        rocket:GetData().IsDirected_HC = false
                    end
                end, 15)

                bomb:Remove()
            end
        end, 2)
    end

end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.OnEngineBombInit)

function mod:OnEngineFetusInit(tear)
    local player = tear.SpawnerEntity and (tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity:ToFamiliar().Player)
    if player and player:HasCollectible(mod.SolarItems.Engine) then
        
        local angle = tear.Velocity:GetAngleDegrees()
        local range = 75 * player.TearRange/260
        local damage = player.Damage

        local ring = Isaac.Spawn(EntityType.ENTITY_LASER, mod.EntityInf[mod.Entity.EngineLaser].VAR, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, tear.Position, Vector.Zero, player):ToLaser()
        ring.Parent = tear
        ring.Radius = 20
        ring.CollisionDamage = damage/5
        ring.DisableFollowParent = false
        ring.DepthOffset = -100
        ring.PositionOffset = Vector(0,-20)

        ring.TearFlags = ring.TearFlags | player.TearFlags | tear.TearFlags
        ring:SetColor(tear:GetSprite().Color, 0, 99, true, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.OnEngineFetusInit, TearVariant.FETUS)

--Charge bar
function mod:OnEngineRender(player)
    if player:HasCollectible(mod.SolarItems.Engine) then
        local position = Isaac.WorldToScreen (player.Position + Vector(-30, -50))
        local sprite = player:GetData().EngineSprite_HC

        local data = player:GetData()
        if data.EngineCounter_HC then
            if data.EngineCounter_HC <= 0 then
                if (sprite:GetAnimation() ~= "Disappear") then
                    sprite:Play("Disappear", true)
                end
                sprite:Update()

            else
                if sprite:GetAnimation() ~= "Charging" then
                    sprite:Play("Charging", true)
                end

                local frame = 100 * (1 - data.EngineCounter_HC / data.EngineMaxTime_HC)
                sprite:SetFrame(math.ceil(frame)) 

            end

            sprite:Render(position)
        end
    end
end
--mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.OnEngineRender)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.OnEngineRender)

--CALLBACKS
function mod:AddEngineCallbacks()
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnEngineUpdate)

	if mod:SomebodyHasItem(mod.SolarItems.Engine) then
        mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnEngineUpdate)
	end
end
mod:AddEngineCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddEngineCallbacks, mod.SolarItems.Engine)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddEngineCallbacks)