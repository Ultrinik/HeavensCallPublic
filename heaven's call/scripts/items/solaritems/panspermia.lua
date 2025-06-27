local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

mod.PanspermiaConsts = {
    MAX_BLOOD = 10*3,
    TRUE_MAX_BLOOD = 10*4,
    TENTACLE_CONSUME = 10,
    TENTACLE_DAMAGE = 15,
    BLOOD_PERC = 1/20,
    REGEN_CHANCE = 0.25,
}

function mod:OnPlayerPanspermiaUpdate(player)
	if player:HasCollectible(mod.SolarItems.Panspermia) then
		local data = player:GetData()
        data.BloodLock = math.max(0, (data.BloodLock and (data.BloodLock - 1)) or 0)

        --mod.SaveManager.GetRunSave(player).currentBloodCharge = mod.PanspermiaConsts.MAX_BLOOD
        mod.SaveManager.GetRunSave(player).currentBloodCharge = mod.SaveManager.GetRunSave(player).currentBloodCharge or mod.PanspermiaConsts.TENTACLE_CONSUME

        if mod.SaveManager.GetRunSave(player).currentBloodCharge >= 9 then
            for action = ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTDOWN do
                if Input.IsActionTriggered(action, player.ControllerIndex) then
                    data.PanspermiaKeyPressHC = data.PanspermiaKeyPressHC or {}
                    local previousKey = data.PanspermiaKeyPressHC[1]
                    local previousTime = data.PanspermiaKeyPressHC[2]

                    if previousTime and previousKey == action and (player.FrameCount - previousTime) < 10 then
                        mod.SaveManager.GetRunSave(player).currentBloodCharge = mod.SaveManager.GetRunSave(player).currentBloodCharge - mod.PanspermiaConsts.TENTACLE_CONSUME
                        mod:SummonFleshWhip(player)
                    end
                    data.PanspermiaKeyPressHC = {action, player.FrameCount}
                end
            end
        end

        if player:CanPickRedHearts() and (rng:RandomFloat() < mod.PanspermiaConsts.REGEN_CHANCE) and ((player.FrameCount+2)&((1<<10)-1))==1 then
            player:AddHearts(1)

            local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position + Vector(0,-50), Vector.Zero, player)
            healHeart.DepthOffset = 200
            sfx:Play(SoundEffect.SOUND_VAMP_GULP,1)
        end
	end
end

function mod:SummonFleshWhip(player)
    player:GetData().BloodLock = 30
    local shot_angle = player:GetAimDirection():GetAngleDegrees()

    for tenta=1,3 do
        local numberTears =  math.min(4, mod:GetNumOfTearShots(player))+1
        local maxAngle = math.sqrt((numberTears-1)*60*60/15)

        for j=1, numberTears do
            local angle_offset = -maxAngle + 2*maxAngle*(j-0.5)/numberTears

            mod:scheduleForUpdate(function ()
                local whip = mod:SpawnEntity(mod.Entity.FleshWhip, player.Position+Vector(0,-5), Vector.Zero, player):ToEffect()
                whip:FollowParent(player)
                whip:GetData().Angle = shot_angle+angle_offset
                whip:Update()

                sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
            end, tenta*3)
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) then
        for i=1, 3 do
            local whip = mod:SpawnEntity(mod.Entity.FleshWhip, player.Position+Vector(0,-5), Vector.Zero, player):ToEffect()
            whip:FollowParent(player)
            whip:GetData().Angle = shot_angle+90*i
            whip:Update()
        end
    end

    game:SpawnParticles(player.Position, EffectVariant.BLOOD_PARTICLE, 10, 8)
    sfx:Play(SoundEffect.SOUND_WHIP)
end

function mod:FleshWhipUpdate(effect)
    if mod.EntityInf[mod.Entity.FleshWhip].SUB == effect.SubType then
        local data = effect:GetData()
        local sprite = effect:GetSprite()

        if not data.Init then
            data.Init = true
            sprite.PlaybackSpeed = 1.4+0.3*rng:RandomFloat()

            sprite.Scale = Vector(rng:RandomFloat()*0.3 + 0.7, 1)

            data.Angle = data.Angle or 0
            sprite.Rotation = data.Angle + mod:RandomInt(-15,15)

            if rng:RandomFloat() < 0.5 then
                sprite:Play("Idle2", true)
            end
        end

        if sprite:IsFinished() then
            effect:Remove()

        elseif sprite:GetFrame() == 1 or sprite:IsEventTriggered("Attack") then

            local direction = Vector(1, 0):Rotated(sprite.Rotation)

            local A = effect.Position
            local B = effect.Position + 200*direction
            local r = 30

            local flags = DamageFlag.DAMAGE_SPAWN_TEMP_HEART | DamageFlag.DAMAGE_IGNORE_ARMOR
            local source = EntityRef(effect.Parent or effect)

            local entities = Isaac.GetRoomEntities()
            for index, entity in ipairs(entities) do
                if mod:IsPointInCapsule(entity.Position, A, B, r) then
                    if (entity.Type ~= EntityType.ENTITY_PLAYER) and (entity.Type ~= EntityType.ENTITY_FAMILIAR) and (entity.Type ~= EntityType.ENTITY_EFFECT) then

                        if entity.Type == EntityType.ENTITY_PROJECTILE then
                            entity:Remove()
                        else
                            game:SpawnParticles(entity.Position, EffectVariant.BLOOD_PARTICLE, 1, 5)
                            entity:TakeDamage(mod.PanspermiaConsts.TENTACLE_DAMAGE, flags, source, 2)
                            entity:AddKnockback(source, direction*10, 1, false)

                            if false and (#mod:FindByTypeMod(mod.Entity.Teratomato) < 5) and (entity.MaxHitPoints >= 12) and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and (not entity:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)) and (not entity:IsBoss()) then
                                entity:Remove()
                                --spawn fleshling
                                local tera = mod:SpawnEntity(mod.Entity.Teratomato, entity.Position, Vector.Zero, source.Entity)
				                tera:AddCharmed(source, -1)
                                tera:SetColor(Color(1,0,0,1), 15, 1, true ,true)

                                if true then
                                    local MIN_GIBS = 30 -- max is double this
                                    local MAX_BLOOD_GIB_SUBTYPE = 3
                                
                                    local gibCount = rng:RandomInt(MIN_GIBS + 1) + MIN_GIBS
                                    for _ = 1, gibCount do
                                        local speed = rng:RandomInt(4) + 1
                                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, rng:RandomInt(MAX_BLOOD_GIB_SUBTYPE + 1), entity.Position, RandomVector() * speed, player)
                                    end
                                
                                    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, player)
                                    cloud.SpriteScale = Vector.One*0.5
                                    cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, player)
                                    cloud.SpriteScale = Vector.One*0.5
                                    cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, player)
                                    cloud.SpriteScale = Vector.One*0.5
                                    sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FleshWhipUpdate, mod.EntityInf[mod.Entity.FleshWhip].VAR)


function mod:OnPanspermiaDomesticAbuse(entity, amount, flags, source, frames)
    if source and source.Entity then

        local player = mod:GetPlayerFromSource(source.Entity)
        if player and player:HasCollectible(mod.SolarItems.Panspermia) and player:GetData().BloodLock <= 0 then
            if amount ~= mod.PanspermiaConsts.TENTACLE_DAMAGE then
                local blood = amount* mod.PanspermiaConsts.BLOOD_PERC * player:GetCollectibleNum(mod.SolarItems.Panspermia)
                mod.SaveManager.GetRunSave(player).currentBloodCharge = mod.SaveManager.GetRunSave(player).currentBloodCharge + blood

                if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF) <= 10 then
                    if mod.SaveManager.GetRunSave(player).currentBloodCharge >= mod.PanspermiaConsts.TRUE_MAX_BLOOD then
                        mod.SaveManager.GetRunSave(player).currentBloodCharge = 0--mod.PanspermiaConsts.MAX_BLOOD

                        local v = mod:RandomVector(10)
                        local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, player.Position-v, v, nil):ToPickup()
                        heart:Update()
                        heart.Wait = 0
                    end
                end

                mod.SaveManager.GetRunSave(player).currentBloodCharge = math.min(mod.SaveManager.GetRunSave(player).currentBloodCharge, mod.PanspermiaConsts.TRUE_MAX_BLOOD)
            end
        end
    end
end

local vessel_sprite = Sprite()
vessel_sprite:Load("hc/gfx/ui/blood_vessel.anm2", true)
vessel_sprite:Play("Idle", true)
function mod:OnBloodVesselSprite(offset, _, position, __, player)
    if player:HasCollectible(mod.SolarItems.Panspermia) then
        local frame = math.floor(math.min(30, mod.SaveManager.GetRunSave(player).currentBloodCharge or 0))
        vessel_sprite:SetFrame(frame)
        vessel_sprite:Render(position + Vector(-10,22))

        vessel_sprite.Scale = Vector.One--*0.85
    end
end

--FLESHLING
function mod:FleshlingUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Teratomato].VAR and entity.SubType == mod.EntityInf[mod.Entity.Teratomato].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()

        --data.Init = false
        --if true then return end

        if not data.Init then
            data.Init = true
            data.Tipo = 1--data.Tipo or mod:RandomInt(1,5)

            if data.Tipo == 1 then
                sprite:Load("hc/gfx/entity_FleshlingRavager.anm2")
            elseif data.Tipo == 2 then
                sprite:Load("hc/gfx/entity_FleshlingClot.anm2")
            elseif data.Tipo == 3 then
                sprite:Load("hc/gfx/entity_FleshlingTorch.anm2")
            elseif data.Tipo == 4 then
                sprite:Load("hc/gfx/entity_FleshlingAxon.anm2")
            elseif data.Tipo == 5 then
                sprite:Load("hc/gfx/entity_FleshlingSniper.anm2")
            end

            sprite:PlayOverlay("Head", true)
            sprite:SetOverlayRenderPriority(false)

            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end

        sprite.Color = Color.Default
        
        sprite.FlipX = false
        if entity.Velocity:Length() <= 0 then
            sprite:Play("WalkV", true)
            sprite:Stop()
        else
            if entity.Velocity.X > 0 then
                if not sprite:IsPlaying("WalkR") then
                    sprite:Play("WalkR", true)
                end
            elseif entity.Velocity.X < 0 then
                if not sprite:IsPlaying("WalkL") then
                    sprite:Play("WalkL", true)
                end
            else
                if not sprite:IsPlaying("WalkV") then
                    sprite:Play("WalkV", true)
                end
            end
        end

        entity.HitPoints = entity.HitPoints - 0.1

        if data.Tipo == 1 then
            mod:OnFleshRavagerUpdate(entity, data, sprite, target)
        elseif data.Tipo == 2 then
            mod:OnFleshClotUpdate(entity, data, sprite, target)
        end

    end
end
function mod:OnFleshlingDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Teratomato].VAR and entity.SubType == mod.EntityInf[mod.Entity.Teratomato].SUB then
        local v = mod:RandomVector(10)
        local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position-v, v, nil):ToPickup()
    end
end

function mod:OnFleshRavagerUpdate(entity, data, sprite, target)
    if target then
        if target.Position:Distance(entity.Position) < 10 then
            entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, 0.9)
            sprite:Play("WalkV", true)

            if target.Type ~= EntityType.ENTITY_PLAYER then
                sprite:PlayOverlay("HeadBite")
            else
                sprite:PlayOverlay("Head")
            end
        else
            sprite:PlayOverlay("HeadOpen")
        end
    else
        sprite:PlayOverlay("Head", true)
    end
end
--[[
function mod:OnFleshRavagerUpdate(entity, data, sprite, target)
    if target then
        if target.Position:Distance(entity.Position) < 40 then
            entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, 0.9)
            sprite:Play("WalkV", true)

            if target.Type ~= EntityType.ENTITY_PLAYER then
                sprite:PlayOverlay("HeadBite")
            else
                sprite:PlayOverlay("Head")
            end

            if sprite:IsOverlayEventTriggered("Bite") then
                for i, e in ipairs(Isaac.FindInRadius(entity.Position, 60)) do
                    if e.InitSeed ~= entity.InitSeed then
                        e:TakeDamage(16, 0, EntityRef(entity), 2)
                    end
                end
            end
        else
            sprite:PlayOverlay("HeadOpen")
        end
    else
        sprite:PlayOverlay("Head", true)
    end
end

function mod:OnFleshClotUpdate(entity, data, sprite, target)
    if target.Position:Distance(entity.Position) < 200 then
        entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, 0.5)

        if target.Type ~= EntityType.ENTITY_PLAYER then
            sprite:PlayOverlay("HeadAttack")
        else
            sprite:PlayOverlay("Head")
        end

        if sprite:IsOverlayEventTriggered("Open") then
            local vector = (target.Position-entity.Position)*0.028

            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position+Vector(50,0), vector, entity):ToProjectile()
            tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            --tear:GetData().LunaProjectile = true
            --tear:GetData().LunaBrust = true


        end

    else
        sprite:PlayOverlay("Head")
    end
end
]]


--CALLBACKS
function mod:AddPanspermiaCallbacks()
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerPanspermiaUpdate)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.OnBloodVesselSprite)
    mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPanspermiaDomesticAbuse)
    mod:RemoveCallback(ModCallbacks.MC_NPC_UPDATE, mod.FleshlingUpdate)
    mod:RemoveCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnFleshlingDeath)

	if mod:SomebodyHasItem(mod.SolarItems.Panspermia) then
        mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerPanspermiaUpdate, 0)
        mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_HEARTS, mod.OnBloodVesselSprite)
        mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPanspermiaDomesticAbuse)
        mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.FleshlingUpdate, mod.EntityInf[mod.Entity.Teratomato].ID)
        mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnFleshlingDeath, mod.EntityInf[mod.Entity.Teratomato].ID)
	end
end
mod:AddPanspermiaCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddPanspermiaCallbacks, mod.SolarItems.Panspermia)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddPanspermiaCallbacks)