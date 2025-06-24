local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.furnitureData = {
    CORPSE = {ID = Isaac.GetEntityTypeByName("Corpse (HC)"), VAR = Isaac.GetEntityVariantByName("Corpse (HC)"), SUB = 370},
    GENERATOR = {ID = Isaac.GetEntityTypeByName("Generator (HC)"), VAR = Isaac.GetEntityVariantByName("Generator (HC)"), SUB = 371},
    SINK = {ID = Isaac.GetEntityTypeByName("Sink (HC)"), VAR = Isaac.GetEntityVariantByName("Sink (HC)"), SUB = 372},
    STOVE = {ID = Isaac.GetEntityTypeByName("Stove (HC)"), VAR = Isaac.GetEntityVariantByName("Stove (HC)"), SUB = 373},
    FRIDGE = {ID = Isaac.GetEntityTypeByName("Fridge (HC)"), VAR = Isaac.GetEntityVariantByName("Fridge (HC)"), SUB = 374},
    TOILET = {ID = Isaac.GetEntityTypeByName("Toilet (HC)"), VAR = Isaac.GetEntityVariantByName("Toilet (HC)"), SUB = 375},
    TANK = {ID = Isaac.GetEntityTypeByName("Tank (HC)"), VAR = Isaac.GetEntityVariantByName("Tank (HC)"), SUB = 377},
    TURRET = {ID = Isaac.GetEntityTypeByName("Turret (HC)"), VAR = Isaac.GetEntityVariantByName("Turret (HC)"), SUB = 379},
    TREE = {ID = Isaac.GetEntityTypeByName("Tree (HC)"), VAR = Isaac.GetEntityVariantByName("Tree (HC)"), SUB = 380},
    STATUE = {ID = Isaac.GetEntityTypeByName("Solar Statue (HC)"), VAR = Isaac.GetEntityVariantByName("Solar Statue (HC)"), SUB = 382},
}

local flags = mod.EverchangerFlags

mod.furnitureQueue = {}

function mod:IsRoomElectrified()
    return #Isaac.FindByType(mod.furnitureData.GENERATOR.ID, mod.furnitureData.GENERATOR.VAR, mod.furnitureData.GENERATOR.SUB) > 0
end

function mod:FurnitureUpdate(entity)
    local sprite = entity:GetSprite()
    local data = entity:GetData()
    local room = game:GetRoom()

    if not data.Init then
        data.Init = true

        if sprite:GetAnimation() == "" then
            sprite:Play("Idle", true)
        end

        if not (entity.SubType == mod.furnitureData.GENERATOR.SUB or entity.SubType == mod.furnitureData.CORPSE.SUB) then
            data.FixedPosition = entity.Position
        else
            data.FixedPosition = Vector.Zero
        end

        if entity.SubType == mod.furnitureData.CORPSE.SUB then
            entity:SetSize(6+4*rng:RandomFloat(), Vector(1.5,1), 12)

            sprite:SetFrame("Idle", mod:RandomInt(0, 3))
            sprite:Stop()
            sprite.Scale = Vector.One

        else
            entity:SetSize(20, Vector(2,1), 12)
        end
        
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    if data.FixedPosition:Length() > 0 then
        entity.Position = data.FixedPosition
        entity.Velocity = Vector.Zero

    else
            
        --Door(s)
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door and door:IsOpen() then
                if door.Position:Distance(entity.Position) < 70 then
                    table.insert(mod.furnitureQueue, {SUB = entity.SubType, IDX = door.TargetRoomIndex, SLOT = mod.oppslots[i]})

                    if entity.SubType == mod.furnitureData.GENERATOR.SUB then
                        sfx:Play(mod.SFX.LightsOff, 10)
                        sfx:Stop(mod.SFX.Generator)
                        mod:scheduleForUpdate(function()
                            sfx:Stop(mod.SFX.Generator)
                            flags.position5 = {[0]=0, [1]=0, [2]=0}
                        end, 2)
                    end

                    sfx:Play(mod.SFX.ThroughDoor, 10)
                    entity:Remove()
                end
            end
        end
    end


    if entity.SubType == mod.furnitureData.GENERATOR.SUB then
        local room = game:GetRoom()

        --sound loop
        if not sfx:IsPlaying(mod.SFX.Generator) then
            sfx:Play(mod.SFX.Generator)
        end

        --lock
        local lockIdx = 112
        local grid = room:GetGridEntity(lockIdx)
        if grid and grid:GetType() == GridEntityType.GRID_LOCK then
            if grid.State == 0 then
                if not entity.Child then
                    local anchor = mod:SpawnEntity(mod.Entity.NeptuneFaker, grid.Position + Vector(0,10), Vector.Zero, entity)
                    anchor.Visible = false
                    anchor:GetSprite().Color = Color(1,1,1,0)
                    anchor:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    anchor.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    anchor.GridCollisionClass = GridCollisionClass.COLLISION_NONE

                    local cord = Isaac.Spawn(mod.EntityInf[mod.Entity.TongueCord].ID, mod.EntityInf[mod.Entity.TongueCord].VAR, mod.EntityInf[mod.Entity.TongueCord].SUB+2, entity.Position, Vector.Zero, entity)
                    cord.Parent = anchor
                    cord.Target = entity

                    --local cordSprite = cord:GetSprite()
                    --cordSprite:ReplaceSpritesheet(0, "gfx/effects/chains_metal.png")
                    --cordSprite:ReplaceSpritesheet(1, "gfx/effects/chains_metal.png")
                    --cordSprite:LoadGraphics()
                    --cordSprite:Play("Gut", true)

                    entity.Child = cord
                else
                    local direction = entity.Position - grid.Position
                    if direction:Length() > 200 then
                        entity.Position = grid.Position + direction:Normalized()*200
                    end
                end
            else
                if entity.Child then
                    entity.Child:Remove()
                    entity.Child = nil
                end
            end
        end

        --light
        flags.position5 = {[0]=entity.Position.X, [1]=entity.Position.Y-15, [2]=450 + 70*math.sin( (flags.time or 0) )}

        if data.Overcharged and not mod.CirclesStates[4] then
            if entity.FrameCount % 30 == 0 then
                local thunder = mod:SpawnEntity(mod.Entity.Thunder, room:GetRandomPosition(0), Vector.Zero, Isaac.GetPlayer(0))
            end
        end

    elseif entity.SubType == mod.furnitureData.SINK.SUB then
        if sprite:IsFinished("On") then
            sprite:Play("Idle", true)
        end

    elseif entity.SubType == mod.furnitureData.STOVE.SUB then
        if not data.Init2 and mod:IsRoomElectrified() then
            data.Init2 = true
            sprite:Play("Burning", true)
        end

    elseif entity.SubType == mod.furnitureData.FRIDGE.SUB then
        if sprite:IsFinished("On") or sprite:IsFinished("Off") then
            sprite:Play("Idle", true)

        elseif sprite:IsEventTriggered("Open") then
            if mod:IsRoomElectrified() then
                if (#Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.icecube) == 0) and not Isaac.GetPlayer(0):HasTrinket(mod.EverchangerTrinkets.icecube) then
                    local cube = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.icecube, entity.Position, Vector(0, 5), entity)
                    sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER)
                end
            else
                sfx:Play(SoundEffect.SOUND_BATTERYDISCHARGE)
            end
        elseif sprite:IsEventTriggered("Close") then
        end
    elseif entity.SubType == mod.furnitureData.CORPSE.SUB then
        local player = Isaac.GetPlayer(0)
        if player.Position:Distance(entity.Position) > 300 then
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", true)
            end
             
            if rng:RandomFloat() < 0.075 then
                sprite.Rotation = rng:RandomFloat()*360
            else
                sprite.Rotation = 0
            end
            if rng:RandomFloat() < 0.1 then
                entity.SpriteScale = Vector.One*rng:RandomFloat()
            else
                entity.SpriteScale = Vector.One
            end
        elseif sprite:IsPlaying("Idle") then
            sprite:SetFrame("Idle", mod:RandomInt(0, 3))
            sprite:Stop()

            sprite.Rotation = 0
            entity.SpriteScale = Vector.One
        end

    elseif entity.SubType == mod.furnitureData.TANK.SUB then

        local explosion = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0)[1]
        if explosion then
            entity:Morph(entity.Type, entity.Variant, entity.SubType+1)
            sprite:Play("Empting", true)
            
            local velocity = Vector((rng:RandomFloat() * 3) + 3,0):Rotated(rng:RandomFloat()*360)
            local corpse = Isaac.Spawn(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB, entity.Position, velocity, entity)
            
            local matter = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.redkey, entity.Position, Vector(0, 5), entity)
            
            sfx:Play(SoundEffect.SOUND_GASCAN_POUR)
            sfx:Play(SoundEffect.SOUND_MIRROR_BREAK)

            --Splash of projectiles:
            if true then
                for i=0, mod.JConst.N_CALLISTO_CLOUD_PROJECTILES do
                    --Ring projectiles:
                    local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector(5,0):Rotated(i*360/mod.JConst.N_CALLISTO_CLOUD_PROJECTILES), entity):ToProjectile()
                    if tear then
                        tear:AddProjectileFlags(ProjectileFlags.ACID_RED)
                        tear.FallingSpeed = -0.1
                        tear.FallingAccel = 0.3
                    end
                end
                for i=0, mod.JConst.N_CALLISTO_CLOUD_PROJECTILES do
                    --Random projectiles:
                    local angle = mod:RandomInt(0, 360)
                    local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector(3,0):Rotated(angle), entity):ToProjectile()
                    if tear then
                        tear:AddProjectileFlags(ProjectileFlags.ACID_RED)
                        local randomFall = -1 * mod:RandomInt(1, 500) / 1000
                        tear.FallingSpeed = randomFall
                        tear.FallingAccel = 0.2
                    end
                end
            end
        end
    elseif entity.SubType == mod.furnitureData.TREE.SUB then

        local explosion = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0)[1]
        if explosion then
            local position = entity.Position + Vector(50, 12)
            local apple = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.apple, position, Vector.Zero, entity)
            apple.Visible = false
            apple:GetSprite():Play("Idle", true)
            apple.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            mod:scheduleForUpdate(function()
                if apple then
                    apple.Visible = true
                end
            end, 10)

            entity:Morph(entity.Type, entity.Variant, entity.SubType+1)
            sprite:Play("Fall", true)
        end

    elseif entity.SubType == mod.furnitureData.TURRET.SUB then

        local player = Isaac.GetPlayer(0)
        local direction = player.Position - entity.Position
        local range = 550

        if not data.Init2 then
            data.Init2 = true

            data.Offset = mod:RandomInt(-10,10)/10
            data.TargetPos = player.Position
        end

        local targetPos = player.Position + data.Offset*player.Velocity*25
        data.TargetPos = mod:Lerp(data.TargetPos, targetPos, 0.1)
        local aimDirection = targetPos - entity.Position

        local correctDirection = (player.Position.X < entity.Position.X)
        local inRange = (75 <= direction:Length() and direction:Length() < range)

        if sprite:IsFinished("Sleep") then
            sprite:Play("Idle", true)

        elseif sprite:IsFinished("Wake") then
            sprite:Play("Attack", true)

        elseif sprite:IsFinished("Attack") then
            sprite:Play("Attack", true)

        end

        if not player:HasTrinket(TrinketType.TRINKET_SAFETY_SCISSORS) and correctDirection and inRange then
            
            if not (sprite:IsPlaying("Wake") or sprite:IsPlaying("Attack")) then
                sprite:Play("Wake", true)
            end

            if not data.Laser then
                data.Laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, entity.Position, aimDirection:GetAngleDegrees(), -1, Vector(0,-10), player)
                data.Laser.DisableFollowParent = true
                local laserSprite = data.Laser:GetSprite()
                laserSprite.Color = Color(1,0,0,0.25,1,0,0)
            else
                local laser = data.Laser
                laser.Angle = aimDirection:GetAngleDegrees()
                laser.MaxDistance = aimDirection:Length()
                laser.Radius = 0.1

                if sprite:IsEventTriggered("Attack") then
                    local rocketDirection = aimDirection:Normalized()
                    local rocket = mod:SpawnEntity(mod.Entity.MarsRocket, entity.Position + rocketDirection*25, rocketDirection, entity):ToBomb()
					rocket:GetData().IsDirected_HC = true
					rocket:GetData().Direction = rocketDirection
					rocket:GetData().MaxParentDistance = aimDirection:Length()
                    rocket.Parent = entity
					rocket:GetSprite().Rotation = rocketDirection:GetAngleDegrees()
                    rocket.RadiusMultiplier = 0.5
                end
            end
        else
            if not (sprite:IsPlaying("Sleep") or sprite:IsPlaying("Idle")) then
                sprite:Play("Sleep", true)
            end

            if data.Laser then
                data.Laser:Remove()
                data.Laser = nil
            end
        end

    elseif entity.SubType == mod.furnitureData.STATUE.SUB then
        mod:EverchangerSolarStateUpdate(entity, data, sprite, room)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.FurnitureUpdate, mod.furnitureData.CORPSE.VAR)


function mod:FurnitureCollision(entity, player)
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if sprite:IsPlaying("Idle") then
        if entity.SubType == mod.furnitureData.SINK.SUB then
            sprite:Play("On", true)

            sfx:Play(mod.SFX.Sink)

            if player:HasTrinket(mod.EverchangerTrinkets.redkey) then
                player:TryRemoveTrinket(mod.EverchangerTrinkets.redkey)
                local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_STRANGE_KEY, player.Position, Vector.Zero, entity)
            end

        elseif entity.SubType == mod.furnitureData.FRIDGE.SUB then
            if mod:IsRoomElectrified() then
                sprite:Play("On", true)
            else
                sprite:Play("Off", true)
            end
        elseif entity.SubType == mod.furnitureData.TOILET.SUB then
            if player:HasTrinket(mod.EverchangerTrinkets.plunger) then
                entity:Morph(entity.Type, entity.Variant, entity.SubType+1)
                --Poops
                for i=1,15 do
                    local velocity = Vector((rng:RandomFloat() * 3) + 3,0):Rotated(rng:RandomFloat()*360)
                    local poop = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, mod:RandomInt(0,1), entity.Position + 2*velocity, velocity, entity)
                end
                
                local velocity = Vector(0, (rng:RandomFloat() * 3) + 3):Rotated(mod:RandomInt(-90,90))
                local corpse = Isaac.Spawn(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB, entity.Position, velocity, entity)
                
                local matter = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.darkmatter, entity.Position, Vector(0, 5), entity)
                local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, entity.Position, Vector(-2.5, 1), entity)
                
                sfx:Play(SoundEffect.SOUND_FLUSH)
            end
        end
    end

    
    if sprite:IsPlaying("Burning") and not player:HasTrinket(mod.EverchangerTrinkets.pyro) then
        mod:BurnPlayer(player, 15)
        sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
    end

    if data.FixedPosition and data.FixedPosition:Length() == 0 then
        entity.Velocity = entity.Velocity + player.Velocity/10

        if entity.SubType == mod.furnitureData.CORPSE.SUB then
            if not sfx:IsPlaying(mod.SFX.CorpsePush) then
                sfx:Play(mod.SFX.CorpsePush, 40)
            end
            
            if entity.FrameCount % 2 == 0 then
                local flag = true
                local stains = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT)
                for _, s in ipairs(stains) do
                    if s.Position:Distance(entity.Position) < 20 then
                        flag = false
                        break
                    end
                end
                if flag then
                    local stain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, entity.Position, Vector.Zero, entity)
                end
            end
        end
    end
    
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, player)
    if player:ToPlayer() then
        mod:FurnitureCollision(pickup, player:ToPlayer())
    end
end, mod.furnitureData.CORPSE.VAR)

function mod:EverchangerSolarStateUpdate(entity, data, sprite, room)
    if not data.InitRoom then
        data.InitRoom = true

        sprite:Load("hc/gfx/furniture_SolarStatue_old.anm2", true)
        sprite:Play("Idle", true)

        local totalCount = 0
        for tipo = 0, 8 do
            if mod.CirclesStates[tipo] then totalCount = totalCount + 1 end
        end

        if totalCount >= 9 then
            data.Finished = true
            mod.EverchangerEntityFlags.errantMoving = false
        end

        if data.Finished then
            local tentacle = Isaac.Spawn(EntityType.ENTITY_NERVE_ENDING, 0, 0, Vector.Zero, Vector.Zero, nil)
            tentacle.CollisionDamage = 0
            tentacle.HitPoints = 9999
            tentacle:GetSprite().Color = Color(1,1,1,0)
            
            --Close door
            for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                local door = room:GetDoor(i)
                if door then
                    door:Close()
                end
            end
            sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS,1)
            --Make room uncleared
			room:SetClear( false )

            mod:scheduleForUpdate(function()
                sfx:Play(SoundEffect.SOUND_FAMINE_BURST)
                flags.enabledDarkness = 0
                flags.enabledStatic = 0
                flags.enabledZoom = 0
            end, 60)

            --local player = Isaac.GetPlayer(0)
            --player:RemoveCollectible(CollectibleType.COLLECTIBLE_MOMS_PURSE)
        end
    end

    if data.Finished then
        local planets = Isaac.FindByType(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+6)
        for i, planet in ipairs(planets) do
            local planetData = planet:GetData()
            planetData.orbitSpeed = math.min(5, planetData.orbitSpeed+0.05)

            if planetData.orbitSpeed >= 5 and sprite:IsPlaying("Idle") then
                sprite:Play("End1", true)
                --sprite:Play("End2", true)
            end
        end

        flags.currentRoomprogress = 0
        flags.distance = 9999
    end

    if sprite:IsFinished("End1") then
        local planets = Isaac.FindByType(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+6)
        if #planets > 1 then
            sprite:Play("End1", true)
        else
            sprite:Play("End1_5", true)
        end

        local planet = planets[1]
        if planet then
            planet.SortingLayer = SortingLayer.SORTING_DOOR
            planet:GetData().Dissapear = true
        end

    elseif sprite:IsFinished("End1_5") then
        sfx:Play(SoundEffect.SOUND_GLASS_BREAK)
        sprite:Play("End2", true)
		game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 15, 9, Color(1,1,0.5,1,1,1,1))
        game:ShakeScreen(15)
            
        local ever = mod:SpawnEntity(mod.Entity.Everchanger, room:GetDoorSlotPosition(DoorSlot.DOWN0), Vector.Zero, nil)
        ever:GetData().State = mod.ECState.LASTSTAND
        ever:GetData().Natural = true
        ever:GetData().BattleSpeed = 3
        ever.CollisionDamage = 0
        sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),0.5)

    elseif sprite:IsFinished("End2") then
        local nEffigies = #Isaac.FindByType(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+11)

        data.effigyOffset = data.effigyOffset or (360*rng:RandomFloat())
        local position = entity.Position + Vector(200, 0):Rotated(data.effigyOffset + nEffigies*360/9)
        local effigy = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+11, position, Vector.Zero, entity)
        effigy:GetSprite():Play("Idle"..tostring(nEffigies), true)
        effigy:SetColor(Color(1, 1, 1, 1, 1,1,1), 30, 1, true, true)

        sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK)

        entity:SetColor(Color(1, 1, 1, 1, 1,1,1), 15, 1, true, true)
        sfx:Play(SoundEffect.SOUND_GLASS_BREAK)
        sprite:Play("End2", true)
        game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 15, 9, Color(1,1,0.5,1,1,1,1))
        game:ShakeScreen(15)


        local ever = mod:FindByTypeMod(mod.Entity.Everchanger)[1]
        ever:GetSprite():Play(tostring(nEffigies), true)

        if nEffigies == 8 then
            sprite:Play("End3", true)
            mod:scheduleForUpdate(function()
                ever:GetSprite():Play("Idle", true)
            end, 30)
        else
        end

    elseif sprite:GetAnimation() == "End3" then
        if sprite:IsFinished("End3") then
            sprite:Play("End4", true)
            local sol = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+12, entity.Position, Vector.Zero, entity)

        elseif sprite:IsEventTriggered("Ded") then
            sfx:Play(SoundEffect.SOUND_MIRROR_BREAK,1)
            game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 75, 9, Color(1,1,0.5,1,1,1,1))
            game:ShakeScreen(45)
        end
    end
end