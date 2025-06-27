local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

local function print_transformed_path(path, separator, transform)
    local transformed = {}
    for i, v in ipairs(path) do
        transformed[i] = tostring(transform(v))
    end
    return table.concat(transformed, separator)
end

mod.EverchangerEntityFlags = {
    errantMoving = false,
    errantMovingOOV = true,
    everchangerCurrentIdx = nil,
    everchangerPreviousIdx = nil,
    everchangerNodes = {},

    movingDirection = nil,
    roomProgress = 0,

    positionDebug = false
}

mod.EverchangerConsts = {
    ROOM_OUSIDE_SPEED = 0.015,
    ROOM_OUTSIDE_SPEED_RUN = 0.015,
    ROOM_INSIDE_SPEED = 0.007,
    ROOM_SPEED = 2.5,--unused

    ITEM_ROLL_CHANCE = 0.5,
}

mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "EverchangerEntityFlags.errantMovingOOV", true)
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "EverchangerEntityFlags.errantMoving", false)

mod.ECState = {
    APPEAR = 0,
    IDLE = 1,
    ATTACK = 2,
    HUNT = 3,
    ARENA = 4,
    LASTSTAND = 5,
    FUCKED = 6,
    SUS = 7,
    INSTAKILL = 8,
}

function mod:EverchangerUpdateChallenge(entity, data, sprite, room, level, target)
    mod.EverchangerFlags.position1 = {[0]=entity.Position.X, [1]=entity.Position.Y-15, [2]=100 + 20*math.sin( (mod.EverchangerFlags.time or 0) )}
    mod:EverchangerSeek(entity, data, sprite, room, level, Isaac.GetPlayer(0))

    if data.State == mod.ECState.APPEAR then
        data.State = mod.ECState.IDLE
    elseif data.State == mod.ECState.HUNT then
        local no_rainbow_flag = (not target:GetData().Rainbow) or (target:GetData().Rainbow and (target:GetData().Rainbow <= 0))
        if no_rainbow_flag then
            mod:EverchangerHunt(entity, data, sprite, room, level, target)
        end

    elseif data.State == mod.ECState.SUS then

        local target_position = data.target_position
        entity.Position = mod:Lerp(entity.Position, target_position, 0.001)
        entity.Velocity = mod:Lerp(entity.Velocity, (target_position-entity.Position)*0.5, 0.0025)
        
        --mod.EverchangerEntityFlags.roomProgress = math.max(0,mod.EverchangerEntityFlags.roomProgress - mod.EverchangerConsts.ROOM_INSIDE_SPEED)

        if target_position:Distance(entity.Position) < 20 then
            data.State = mod.ECState.IDLE

            data.P0 = entity.Position
            mod.EverchangerEntityFlags.roomProgress = 0
        end

        if (target.Position:Distance(entity.Position) < 150) and (not target:GetData().dinamic_hiding) then
            sprite:Play("Fang", true)
            data.State = mod.ECState.HUNT
            sfx:Play(mod.SFX.AngryStaticScream, 5)
        end


    elseif data.State == mod.ECState.IDLE then
        local no_rainbow_flag = (not target:GetData().Rainbow) or (target:GetData().Rainbow and (target:GetData().Rainbow <= 0))
        local distance_flag = target.Position:Distance(entity.Position) < 400

        if not distance_flag then
            data.SusCount = 0
        end

        if distance_flag and no_rainbow_flag and (not target:GetData().IsHidden) and (not target:GetData().dinamic_hiding) then
            data.SusCount = data.SusCount + 1
            if data.SusCount > 20 then
                data.State = mod.ECState.SUS
                data.target_position = target.Position

                --local direction = data.target_position - entity.Position
                --local laser = EntityLaser.ShootAngle(LaserVariant.TRACTOR_BEAM, entity.Position, direction:GetAngleDegrees(), 1, Vector.Zero, entity)
                --laser:SetColor(Color(1,0,1,1), -1, 1, true, false)
            end

        end
        mod:EverchangerMove(entity, data, sprite, room, level, target)

    elseif data.State == mod.ECState.ARENA then
        mod:EverchangerBattle(entity, data, sprite, room, level, target)
    elseif data.State == mod.ECState.LASTSTAND then
        mod:EverchangerLastStand(entity, data, sprite, room, level, target)
    end
end
function mod:EverchagerRunUpdate(entity, data, sprite, room, level, target)
    if data.State == mod.ECState.APPEAR then
        data.State = mod.ECState.IDLE
    elseif data.State == mod.ECState.IDLE then
        mod:EverchangerMove(entity, data, sprite, room, level, target)

        if entity.Position:Distance(target.Position) < 200 and entity.FrameCount > 30 and not data.Attacked then
            data.Attacked = entity.FrameCount

            data.State = mod.ECState.ATTACK
            sprite:Play("Cloud", true)
        end

    elseif data.State == mod.ECState.ATTACK then
        mod:EverchangerAttack(entity, data, sprite, room, level, target)
        entity.Velocity = Vector.Zero
    end
end
function mod:EverchangerBabelUpdate(entity, data, sprite, room, level, target)
    local direction = (target.Position - entity.Position):Normalized()
    local vel_direction = entity.Velocity:Normalized()
    local dot = math.abs(vel_direction.X * direction.X + vel_direction.Y * direction.Y) + 0.01
    dot = math.sqrt(dot)

    local distance = (target.Position - entity.Position):Length() * 0.0001 * data.H
    local t_velocity = 10*direction*dot

    entity.Velocity = mod:Lerp(entity.Velocity, t_velocity, distance)

    if data.Sol then
        data.H = math.min(100, data.H * 1.001)

    else
        local pitch = 3 + 2*math.sin(entity.FrameCount/15)
        music:PitchSlide(pitch)

        if rng:RandomFloat() < 0.01 * data.H then
            local faker = Isaac.Spawn(mod.EntityFakerData.ID, mod.EntityFakerData.VAR, mod.EntityFakerData.SUB, entity.Position, Vector.Zero, entity)
        end
        data.H = math.min(100, data.H * 1.01)

        if target.Position:Distance(entity.Position) <= (target.Size + entity.Size + 10) then
            local player = target:ToPlayer()
            if player and player:GetDamageCooldown() <= 0 then
                local current_blood = math.ceil(player:GetHearts()*0.5)
                local current_hearts = math.ceil(player:GetMaxHearts()*0.5)

                if current_hearts > current_blood then
                    player:AddMaxHearts(current_blood-current_hearts)
                end

                player:TakeDamage(1, 0, EntityRef(entity), 0)
                player:AddBrokenHearts(3)
                sfx:Play(mod.SFX.StaticScream, 5, 2, false, 2.25)
                game:ShakeScreen(15)
            end
        end
    end
end
function mod:EverchangerUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Everchanger].VAR and entity.SubType == mod.EntityInf[mod.Entity.Everchanger].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local room = game:GetRoom()
        local level = game:GetLevel()
        local target = entity:GetPlayerTarget()

        local PC = room:GetCenterPos()

        if not data.Init then

            if not data.Natural then
                entity:Remove()
                mod:StartEverchangerEntity(nil, level:GetCurrentRoomIndex())

                return
            end

            data.Init = true
            data.State = data.State or mod.ECState.APPEAR

            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            sprite:Play("Cloud")
            --sprite:PlayOverlay("Cloud")
            --sprite:SetOverlayRenderPriority(false)

            local quantum_player = mod:SpawnEntity(mod.Entity.QuantumPlayer, entity.Position + Vector(0,-60), Vector.Zero, entity):ToEffect()
            quantum_player.DepthOffset = 59
            quantum_player.Parent = Isaac.GetPlayer(0)
            quantum_player:FollowParent(entity)

            if not data.Map_Init then
                data.Map_Init = true

                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                data.SusCount = 0

                entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
                entity:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)


                entity.CollisionDamage = 0

                local positions = mod:GetEverchangerDoors()
                data.P0 = positions[1]
                data.P1 = positions[2]

                data.is_dead_end = (PC.X == data.P1.X) and (PC.Y == data.P1.Y)

                data.v_mult = 1
                if data.is_dead_end then
                    data.v_mult = 1
                end
            end
        end

        if mod.EverchangerFlags.inChallenge then
            mod:EverchangerUpdateChallenge(entity, data, sprite, room, level, target)
        elseif mod:IsChallenge(mod.Challenges.BabelTower) then
            mod:EverchangerBabelUpdate(entity, data, sprite, room, level, target)
        else
            mod:EverchagerRunUpdate(entity, data, sprite, room, level, target)
            
            if (entity.FrameCount & (16-1)) == 0 then
                for i, e in ipairs(Isaac.FindInRadius(entity.Position, 100)) do
                    if (e:ToNPC() and e:ToNPC():CanReroll()) and (e.FrameCount > 30) and (e.MaxHitPoints >= 10) and e:IsActiveEnemy() and e:IsVulnerableEnemy() then
                        game:RerollEnemy(e)

                        local position = e.Position
                        mod:scheduleForUpdate(function ()
                            for j, locust in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 0)) do
                                if locust.FrameCount == 0 then
                                    locust:Remove()
                                end
                            end
                        end, 1)
                    end
                end
            end
        end

        --effects
        if entity.FrameCount & 2 == 0 then
            if entity.FrameCount & 4 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_STATIC, 0, entity.Position + mod:RandomVector(40,0), mod:RandomVector(1), entity):ToEffect()
                creep.SpriteScale = Vector.One*1.5
                creep.Timeout = 0
                creep.CollisionDamage = 0
                creep:Die()
                creep:Update()
            end
            
            local glitch = mod:SpawnEntity(mod.Entity.Glitch, entity.Position + Vector(0,-60) + mod:RandomVector(100), Vector.Zero, nil)
        end

        mod:EverchangerMoveEye(entity, data, sprite, room, level, target)
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.EverchangerUpdate, mod.EntityInf[mod.Entity.Everchanger].ID)

function mod:EverchangerMove(entity, data, sprite, room, level, target)
    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    entity.CollisionDamage = 0

    local PC = room:GetCenterPos()

    local target_position = mod:GetBezierPosition(mod.EverchangerEntityFlags.roomProgress, data.P0, data.P1, PC)
    local distance_p1 = entity.Position:Distance(data.P1)

    if distance_p1 < 10 then
        if data.is_dead_end then
            mod:EverchangerChangeRoom(false)

            data.P0 = PC
            
            for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                local door = room:GetDoor(i)
                if door then
                    local target_door_idx = mod:GetTrueSafeGridIndex(door.TargetRoomIndex, level)
                    local path_door_idx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.Path[1], level)
                    if path_door_idx == target_door_idx then
                        data.P1 = door.Position
                        break
                    end
                end
            end
            data.is_dead_end = false
        else
            entity:Remove()
            mod:EverchangerChangeRoom(false)

            if mod.EverchangerFlags.position1 then
                mod.EverchangerFlags.position1 = {[0]=0,[1]=0,[2]=0}
            end

            sfx:Play(SoundEffect.SOUND_DOOR_HEAVY_CLOSE, 0.5)
        end
    end
    
    --local direction = (target_position-entity.Position):Normalized()
    --entity.Velocity = mod:Lerp(entity.Velocity, direction * mod.EverchangerConsts.ROOM_SPEED*data.v_mult, 0.15)
    entity.Position = mod:Lerp(entity.Position, target_position, 0.01)
    entity.Velocity = mod:Lerp(entity.Velocity, (target_position-entity.Position), 0.15)

    local distance = data.P1:Distance(data.P0)
    local speed = mod.EverchangerConsts.ROOM_INSIDE_SPEED * 560/distance
    mod.EverchangerEntityFlags.roomProgress = math.min(1,mod.EverchangerEntityFlags.roomProgress + speed)

    if PC:Distance(entity.Position) > 40 then
        local alpha = math.min(distance_p1/40, 1)
        sprite.Color.A = alpha
    end
end

function mod:EverchangerHunt(entity, data, sprite, room, level, target)
    local player = Isaac.GetPlayer(0)

    data.CatchSpeed = data.CatchSpeed or 0
    data.CatchSpeed = math.max(data.CatchSpeed+0.05, 5)

    local direction = target.Position - entity.Position
    direction = direction:Normalized()

    entity.Velocity = entity.Velocity * 0.5 + direction * 5
    entity.Velocity = entity.Velocity:Normalized() * data.CatchSpeed

    if entity.Position:Distance(player.Position) < (player.Size + entity.Size) then
        entity:Remove()
        mod:TriggerEverchangerBattle()
        mod:scheduleForUpdate(function()
            --mod:TriggerEverchangerBattle()
        end, 2)
    end
end
function mod:EverchangerBattle(entity, data, sprite, room, level, target)
    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    entity.CollisionDamage = 1

    data.Direction = data.Direction or Vector.Zero
    if rng:RandomFloat() < 0.025 then
        data.Direction = (target.Position - entity.Position):Normalized()
    end
    entity.Velocity = data.Direction

end
function mod:EverchangerLastStand(entity, data, sprite, room, level, target)

    local player = Isaac.GetPlayer(0)
    data.Direction = data.Direction or Vector.Zero
    if rng:RandomFloat() < 0.25 then
        data.Direction = (player.Position - entity.Position):Normalized()
    end
    entity.Velocity = data.Direction

    local player = Isaac.GetPlayer(0)
    if entity.Position:Distance(player.Position) < (player.Size + entity.Size + 10) then
        

        local playerSprite = player:GetSprite()

        if not player:HasCollectible(CollectibleType.COLLECTIBLE_ARIES) then
            for i=0, 14 do
                playerSprite:ReplaceSpritesheet(i, "hc/gfx/characters/costumes/antichrist.png")
            end
            playerSprite:LoadGraphics()
            player:AddNullCostume(Isaac.GetCostumeIdByPath("hc/gfx/characters/costume_Antichrist.anm2"))
        end

        --target:TakeDamage(0, 0, EntityRef(entity), 0)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false)
    end

end

function mod:EverchangerAttack(entity, data, sprite, room, level, target)
    if entity.FrameCount - data.Attacked > 20 and sprite:IsPlaying("Cloud") then
        sprite:Play("Eyeless", true)
        local eye = mod:SpawnEntity(mod.Entity.ECEye, entity.Position, Vector.Zero, entity):ToEffect()
        eye.Parent = entity

    elseif sprite:IsFinished("Eyeless") then
        local eyes = mod:FindByTypeMod(mod.Entity.ECEye)
        if #eyes > 0 then
            sprite:Play("Eyeless", true)
        else
            entity:SetColor(Color(1,1,1,1, 1,1,1), 30, 1, true, true)
            sprite:Play("Cloud", true)

            data.State = mod.ECState.IDLE
            
            data.P0 = entity.Position
            mod.EverchangerEntityFlags.roomProgress = 0
        end
    end
end

function mod:EverchangerSeek(entity, data, sprite, room, level, target)
    local player = target
    local direction = (player.Position - entity.Position):Normalized()

    local increment = 7.5
    for i=1, 30 do
        local current_positon = entity.Position + math.min(15*15, i*increment)*direction

        local grid_index = room:GetClampedGridIndex(current_positon)
        local grid = room:GetGridEntity(grid_index)
        
        if grid and grid:GetType() == GridEntityType.GRID_PILLAR then
            player:GetData().dinamic_hiding = true
            return
        end
    end
    player:GetData().dinamic_hiding = false
end

function mod:EverchangerMoveEye(entity, data, sprite, room, level, target)
    local n = 20
    local eyes = {[n]='eye', [n-1]='pupil', [n-2]='mpupil', [n-0.01]='fang'}

    for d, name in pairs(eyes) do

        local distance = (d / n)*30
        local distance2 = (d / n)*25

        local layer = sprite:GetLayer(name)
    
        local entity_position = entity.Position + Vector(0, -60)
        local target_position
    
        if data.State == mod.ECState.IDLE or data.State == mod.ECState.SUS then
            target_position = entity.Position + entity.Velocity
        elseif data.State == mod.ECState.HUNT or data.State == mod.ECState.ARENA or data.State == mod.ECState.LASTSTAND or data.State == mod.ECState.INSTAKILL then
            target_position = target.Position
        else
            target_position = entity.Position
        end
    
        local direction = (target_position - entity.Position):Normalized()
        local final_direction = mod:Lerp(layer:GetPos(), distance*direction, 0.1)
        layer:SetPos(final_direction)

        local x_scale = 1 - 0.3 * math.abs(final_direction.X)/distance2
        layer:SetSize(Vector(x_scale,1))
    end
end

--OVERWORLD
function mod:StartEverchangerEntity(start_idx, end_idx, prev_idx)

    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.EverchangerWorldUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.EverchangerWorldUpdate)

    local level = game:GetLevel()

    local playerIdx = level:GetCurrentRoomIndex()

    mod:GenerateEverchangerGraph()

    --verify idx inside pathfind
    local mapa = mod:GetWorldMap()
    if start_idx and mapa[math.floor(start_idx/13)+1] and mapa[math.floor(start_idx/13)+1][start_idx%13+1] == ' ' then
        --print("start_idx", start_idx)
        start_idx = nil
    end
    if end_idx and mapa[math.floor(end_idx/13)+1] and mapa[math.floor(end_idx/13)+1][end_idx%13+1] == ' ' then
        --print("end_idx", end_idx)
        end_idx = nil
    end

    --verify them not being the same
    local counter = 0
    while counter<100 and (counter==0 or not (start_idx and end_idx)) do
        counter = counter + 1
        if not start_idx then
            start_idx = mod:GetDeadend(nil, playerIdx)
        end
        if not end_idx then
            end_idx = mod:GetDeadend(start_idx, nil)
        end

        if mod:GetTrueSafeGridIndex(start_idx, level) == mod:GetTrueSafeGridIndex(end_idx, level) then
            end_idx = nil
        end
        if (not prev_idx) and mod:GetTrueSafeGridIndex(start_idx, level) == mod:GetTrueSafeGridIndex(end_idx, level) then
            start_idx = nil
        end
    end

    --if counter >= 100 then print("MAX LOOP REACHED") end
    --print("NEW PATH", start_idx%13, math.floor(start_idx/13), end_idx%13, math.floor(end_idx/13))

    if not ((start_idx and (0 <= start_idx) and (start_idx <= 13*13 -1)) and (end_idx and (0 <= end_idx) and (end_idx <= 13*13 -1))) then
        return false
    end

    start_idx = mod:GetTrueSafeGridIndex(start_idx, level)
    end_idx = mod:GetTrueSafeGridIndex(end_idx, level)

    mod.EverchangerEntityFlags.errantMoving = true
    mod.EverchangerEntityFlags.everchangerCurrentIdx = start_idx
    mod.EverchangerEntityFlags.everchangerPreviousIdx = (prev_idx and mod:GetTrueSafeGridIndex(prev_idx, level)) or start_idx

    local path = mod:dijkstra(mod.EverchangerEntityFlags.everchangerNodes, start_idx, end_idx)
    mod.EverchangerEntityFlags.Path = path
    
    --print("Path:", print_transformed_path(path, ' -> ', function (v) return tostring(v%13)..', '..tostring(math.floor(v/13)) end))
    
    mod.EverchangerEntityFlags.everchangerNextIdx = mod:GetTrueSafeGridIndex(path[1], level)
    
    
    --print(0, mod.EverchangerEntityFlags.everchangerPreviousIdx, mod.EverchangerEntityFlags.everchangerCurrentIdx, mod.EverchangerEntityFlags.everchangerNextIdx)
    if mod.EverchangerFlags.inChallenge then
        sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"), 1)
    else
        sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"), 0.5)
    end
    return true
end

function mod:EverchangerWorldUpdate()
    if mod.EverchangerEntityFlags.errantMoving and not mod.EverchangerFlags.inBattle then
        local level = game:GetLevel()
        local room = game:GetRoom()

        local playerIdx = mod:GetTrueSafeGridIndex(level:GetCurrentRoomIndex(), level)

        local currentPath = mod.EverchangerEntityFlags.Path
        local everchangerSpeed

        if mod.EverchangerFlags.inChallenge then
            everchangerSpeed = mod.EverchangerConsts.ROOM_OUSIDE_SPEED
        else
            everchangerSpeed = mod.EverchangerConsts.ROOM_OUTSIDE_SPEED_RUN
        end

        if currentPath and #currentPath > 0 then

            if mod.EverchangerFlags.gameOverflag then return end

            --print("world update", mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerCurrentIdx, level), playerIdx)
            if mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerCurrentIdx, level) ~= playerIdx then
                mod.EverchangerEntityFlags.errantMovingOOV = true

                local mapa = mod:GetWorldMap()
                local player_in_map = mapa[math.floor(playerIdx/13)+1] and mapa[math.floor(playerIdx/13)+1][playerIdx%13+1] ~= ' '

                if player_in_map then
                    mod.EverchangerEntityFlags.roomProgress = mod.EverchangerEntityFlags.roomProgress + everchangerSpeed
                end

                local playerInPath = false
                for _, idx in pairs(currentPath) do
                    if idx == playerIdx then
                        playerInPath = true
                        break
                    end
                end
                mod.EverchangerFlags.distance = mod.EverchangerFlags.distance or 9999
                if playerInPath then
                    mod.EverchangerFlags.distance = math.max(100, mod.EverchangerFlags.distance - everchangerSpeed)
                else
                    mod.EverchangerFlags.distance = mod.EverchangerFlags.distance + everchangerSpeed*100
                end

                if mod.EverchangerEntityFlags.roomProgress >= 1 then --Crossed a room-----------------------------------------
                    mod:EverchangerChangeRoom(playerInPath)
                end

                --quantum signal
                if player_in_map then
                    local ec_idx = mod.EverchangerEntityFlags.everchangerCurrentIdx
                    local ex = ec_idx % 13
                    local ey = math.floor(ec_idx/13)

                    local px = playerIdx % 13
                    local py = math.floor(playerIdx/13)

                    local distance = math.sqrt((px-ex)^2 + (py-ey)^2) + 1

                    if playerInPath then
                        distance = distance - mod.EverchangerEntityFlags.roomProgress
                    else
                        distance = distance + mod.EverchangerEntityFlags.roomProgress
                    end

                    local volume = math.min(1, (1/distance))
                    volume = volume

                    local sound = Isaac.GetSoundIdByName("quantum_signal")
                    if not sfx:IsPlaying(sound) then
                        sfx:Play(sound, volume, 2, true)
                    else
                        sfx:AdjustVolume(sound, volume)
                    end
                else
                    sfx:Stop(Isaac.GetSoundIdByName("quantum_signal"))
                end

            else -- OH SHIT OH SHIT, IT REACHED YOU
                if mod.EverchangerEntityFlags.errantMovingOOV then
                    mod.EverchangerEntityFlags.errantMovingOOV = false

                    local position = mod:GetEverchangerPosition() or room:GetCenterPos()
                    local everchanger = mod:SpawnEntity(mod.Entity.Everchanger, position, Vector.Zero, nil)
                    everchanger:GetData().Natural = true
                    everchanger:Update()

                    --sound
                    local sound = Isaac.GetSoundIdByName("quantum_signal")
                    if not sfx:IsPlaying(sound) then
                        sfx:Play(sound, 1, 2, true)
                    else
                        sfx:AdjustVolume(sound, 1)
                    end
                end
            end
        else

            local mapa = mod:GetWorldMap()
            local player_in_map = mapa[math.floor(playerIdx/13)+1] and mapa[math.floor(playerIdx/13)+1][playerIdx%13+1] ~= ' '
            
            local player_in_dead_end = false
            --print(playerIdx, mod.EverchangerEntityFlags.everchangerCurrentIdx)
            for i, dead_idx in ipairs(mod:GetAllDeadends(mod.EverchangerEntityFlags.everchangerCurrentIdx, nil)) do
                --print("dead:", dead_idx%13, dead_idx/13, dead_idx)
                if mod:GetTrueSafeGridIndex(dead_idx, level) == playerIdx then
                    player_in_dead_end = true
                    break
                end
            end
            --print(player_in_dead_end)
            if player_in_map and (player_in_dead_end or rng:RandomFloat() < 0.5) and not mod.EverchangerFlags.inChallenge then
                --print("Seeking player")
                mod:StartEverchangerEntity(mod.EverchangerEntityFlags.everchangerCurrentIdx, playerIdx, mod.EverchangerEntityFlags.everchangerPreviousIdx)
            else
                --print("new path from:", mod.EverchangerEntityFlags.everchangerCurrentIdx, mod.EverchangerEntityFlags.everchangerPreviousIdx)
                mod:StartEverchangerEntity(mod.EverchangerEntityFlags.everchangerCurrentIdx, nil, mod.EverchangerEntityFlags.everchangerPreviousIdx)
            end
        end
    else
        local sound = Isaac.GetSoundIdByName("quantum_signal")
        sfx:Stop(sound)
    end
end

function mod:EverchangerChangeRoom(playerInPath)
    if mod.EverchangerEntityFlags.inBattle then return end
    if not mod.EverchangerEntityFlags.everchangerCurrentIdx then return end

    local level = game:GetLevel()
    local room = game:GetRoom()
    local currentRoomIdx = level:GetCurrentRoomIndex()

    --print(1, mod.EverchangerEntityFlags.everchangerPreviousIdx, mod.EverchangerEntityFlags.everchangerCurrentIdx, mod.EverchangerEntityFlags.everchangerNextIdx)

    mod.EverchangerEntityFlags.everchangerPreviousIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerCurrentIdx, level)
    mod.EverchangerEntityFlags.everchangerCurrentIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerNextIdx, level)

    table.remove(mod.EverchangerEntityFlags.Path, 1)
    if #mod.EverchangerEntityFlags.Path > 0 then
        mod.EverchangerEntityFlags.everchangerNextIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.Path[1], level)
    end
    
    --print(2, mod.EverchangerEntityFlags.everchangerPreviousIdx, mod.EverchangerEntityFlags.everchangerCurrentIdx, mod.EverchangerEntityFlags.everchangerNextIdx)

    --print("Path:", print_transformed_path(mod.EverchangerEntityFlags.Path, ' -> ', function (v) return tostring(v%13)..', '..tostring(math.floor(v/13)) end))

    mod.EverchangerEntityFlags.roomProgress = 0

    if mod.EverchangerEntityFlags.positionDebug then
        for i=0, 13*13-1 do
            local roomdesc = level:GetRoomByIdx(i)
            if roomdesc.Data and roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM > 0 then
                roomdesc.Flags = roomdesc.Flags ~ RoomDescriptor.FLAG_RED_ROOM
            end
        end

        local roomdesc = level:GetRoomByIdx(mod.EverchangerEntityFlags.everchangerCurrentIdx)
        roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_RED_ROOM
        
        level:UpdateVisibility()
    end
    
    if playerInPath then
        local playerPath = mod:dijkstra(mod.EverchangerEntityFlags.everchangerNodes, mod.EverchangerEntityFlags.everchangerCurrentIdx, currentRoomIdx)
        mod.EverchangerFlags.distance = 100*(#playerPath)
    end
end

function mod:GetEverchangerDoors()
    local level = game:GetLevel()
    local room = game:GetRoom()

    local currentRoomprogress = mod.EverchangerEntityFlags.roomProgress
    
    local everchangerPreviousIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerPreviousIdx, level)
    local everchangerCurrentIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerCurrentIdx, level)
    local everchangerNextIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerNextIdx, level)

    local P0
    local P1

    for i = 0, DoorSlot.NUM_DOOR_SLOTS do
        local door = room:GetDoor(i)
        if door then
            local target_door_idx = mod:GetTrueSafeGridIndex(door.TargetRoomIndex, level)
    
            if everchangerPreviousIdx and everchangerPreviousIdx == target_door_idx then
                P0 = room:GetDoorSlotPosition(i)
            end
            if everchangerNextIdx and everchangerNextIdx == target_door_idx then
                P1 = room:GetDoorSlotPosition(i)
            end
        end
    end

    if not P1 then
        P1 = room:GetCenterPos()
    end
    if not P0 then
        P0 = room:GetRandomPosition(0)
    end
    
    return {P0, P1}
end
function mod:GetEverchangerPosition()
    local level = game:GetLevel()
    local room = game:GetRoom()

    local currentRoomprogress = mod.EverchangerEntityFlags.roomProgress
    
    local everchangerPreviousIdx = mod:GetTrueSafeGridIndex(mod.EverchangerEntityFlags.everchangerPreviousIdx, level)

    local PC = room:GetCenterPos()
    if everchangerPreviousIdx then

        --print(3, mod.EverchangerEntityFlags.everchangerPreviousIdx, mod.EverchangerEntityFlags.everchangerCurrentIdx, mod.EverchangerEntityFlags.everchangerNextIdx)
        local positions = mod:GetEverchangerDoors()
        local P0 = positions[1]
        local P1 = positions[2]


        if P0 and P1 then
            local position = mod:GetBezierPosition(currentRoomprogress, P0, P1, PC)
            return position
        end

    else
        return PC
    end
end

-- WORLD MAP
local function PrintMapa(mapa, indexmode)
    mapa = mapa or mod:GetWorldMap()
    for y=1,13 do
        local row = mapa[y]
        local s = ''
        for i,v in ipairs(row) do
            if indexmode then
                if v ~= ' ' then
                    v = (i-1)+(y-1)*13
                    if v < 10 then
                        v = '0'..tostring(v)
                    end
                    if v < 100 then
                        v = '0'..tostring(v)
                    end
                    v = tostring(v)
                else
                    v = '   '
                end
            end
            s = s..v..','
        end
        print(s)
    end
end

function mod:GetWorldMap()
    if mod.EverchangerFlags.inChallenge then
        local mapa = {
            {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
            {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
            {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
            {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
            {' ',' ',' ',' ',' ',' ',' ',' ',' ','X','X','X',' '},
            {' ',' ',' ',' ','X',' ',' ',' ',' ','X',' ','X','X'},
            {'X','X','X','X','X',' ','Y',' ','X','X','X','X',' '},
            {' ',' ','X',' ','X','X','Y','X','X',' ',' ','X',' '},
            {' ',' ','X','X','X',' ','X',' ','X',' ',' ','X','X'},
            {' ',' ','X',' ','X',' ',' ',' ','X',' ',' ','X',' '},
            {' ',' ',' ',' ','X','X','X',' ',' ',' ',' ',' ',' '},
            {' ',' ',' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' '},
            {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        }
        return mapa
    else
        local level = game:GetLevel()

        local mapa = {}
        for y=1,13 do
            local row = {}
            table.insert(mapa, row)
            for x=1,13 do
                local index = (x-1) + 13*(y-1)
                local roomconfig = level:GetRoomByIdx(index)
                local cleared = roomconfig.Clear
                local roomdata = roomconfig.Data
                if roomdata and not ((roomdata.Type == RoomType.ROOM_SECRET or roomdata.Type == RoomType.ROOM_SUPERSECRET or roomdata.Type == RoomType.ROOM_CHALLENGE or mod:IsRoomDescAstralChallenge(roomconfig)) and not cleared)  then
                    if ((roomdata.Type == RoomType.ROOM_BOSS or roomdata.Type == RoomType.ROOM_MINIBOSS) and not cleared) then
                            row[x] = 'b'
                    else
                        if roomdata.Shape == RoomShape.ROOMSHAPE_1x2 or roomdata.Shape == RoomShape.ROOMSHAPE_IIV or roomdata.Shape == RoomShape.ROOMSHAPE_2x1 or roomdata.Shape == RoomShape.ROOMSHAPE_IIH or roomdata.Shape == RoomShape.ROOMSHAPE_2x2 or roomdata.Shape == RoomShape.ROOMSHAPE_LTL or roomdata.Shape == RoomShape.ROOMSHAPE_LTR or roomdata.Shape == RoomShape.ROOMSHAPE_LBL or roomdata.Shape == RoomShape.ROOMSHAPE_LBR then
                            row[x] = 'y'
                        else
                            row[x] = 'x'
                        end
                    end
                else
                    row[x] = ' '
                end
            end
        end
    
        local function MarkMainland(mapa, x, y)
            if mapa[y][x] == 'y' or mapa[y][x] == 'x' or mapa[y][x] == 'b' then
    
                mapa[y][x] = string.upper(mapa[y][x])
    
                if mapa[y+1] and mapa[y+1][x] then MarkMainland(mapa, x, y+1) end
                if mapa[y-1] and mapa[y-1][x] then MarkMainland(mapa, x, y-1) end
                if mapa[y][x+1] then MarkMainland(mapa, x+1, y) end
                if mapa[y][x-1] then MarkMainland(mapa, x-1, y) end
            end
        end
        MarkMainland(mapa, 7, 7)--6,6 is starting room
    
        for y=1,13 do
            for x=1,13 do
                if mapa[y][x] ~= string.upper(mapa[y][x]) then
                    mapa[y][x] = ' '
                end
            end
        end
    
        --PrintMapa(mapa, true)
        return mapa
    end
end

function mod:GetNodeNeightbours(node, direction)
    local target_idx = node[direction]

    local is_multinode = false
    local final_m_nodes_idxs = nil
    for m_idx, m_nodes_idxs in pairs(mod.EverchangerEntityFlags.everchangerMultiNodes) do
        if target_idx == m_idx then
            final_m_nodes_idxs = m_nodes_idxs
            is_multinode = true
            break
        end
    end

    if is_multinode then
        return final_m_nodes_idxs
    else
        return target_idx
    end
end
function mod:GenerateEverchangerGraph()
    local level = game:GetLevel()
    local mapa = mod:GetWorldMap()

    mod.EverchangerEntityFlags.everchangerNodes = {}
    mod.EverchangerEntityFlags.everchangerMultiNodes = {}
    for y = 1, 13 do
        for x = 1, 13 do
            if mapa[y][x] == "X" or mapa[y][x] == "Y" then
                local index = (x-1) + 13*(y-1)
                local roomconfig = level:GetRoomByIdx(index)
                local roomdata = roomconfig.Data
                if roomdata then
                    mod:CreateNode(roomdata, mapa, x, y)
                end
            end
        end
    end
end

function mod:CreateNode(roomdata, mapa, x, y)
    local newNode = {RIGHT0 = nil, UP0 = nil, LEFT0 = nil, DOWN0 = nil, RIGHT1 = nil, UP1 = nil, LEFT1 = nil, DOWN1 = nil}
    local function CheckConection(direction, test_y, test_x)
        if mapa[test_y] and mapa[test_y][test_x] and not (mapa[test_y][test_x] == ' ' or mapa[test_y][test_x] == 'B') then
            newNode[direction] = (test_x-1) + (test_y-1)*13
        end
    end

    if roomdata.Shape == RoomShape.ROOMSHAPE_1x2 then
        
        CheckConection('LEFT0', y, x-1)
        CheckConection('LEFT1', y+1, x-1)
        
        CheckConection('RIGHT0', y, x+1)
        CheckConection('RIGHT1', y+1, x+1)
        
        CheckConection('UP0', y-1, x)

        CheckConection('DOWN0', y+2, x)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y+1][x] = string.lower(mapa[y+1][x])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end

    elseif roomdata.Shape == RoomShape.ROOMSHAPE_IIV then
        
        CheckConection('UP0', y-1, x)
        
        CheckConection('DOWN0', y+2, x)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y+1][x] = string.lower(mapa[y+1][x])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_2x1 then
        
        CheckConection('LEFT0', y, x-1)

        CheckConection('RIGHT0', y, x+2)
        
        CheckConection('UP0', y-1, x)
        CheckConection('UP1', y-1, x+1)
        
        CheckConection('DOWN0', y+1, x)
        CheckConection('DOWN1', y+1, x+1)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y][x+1] = string.lower(mapa[y][x+1])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1 + 1) + (y-1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_IIH then
        
        CheckConection('LEFT0', y, x-1)

        CheckConection('RIGHT0', y, x+2)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y][x+1] = string.lower(mapa[y][x+1])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1 + 1) + (y-1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_2x2 then
        
        CheckConection('LEFT0', y, x-1)
        CheckConection('LEFT1', y+1, x-1)
        
        CheckConection('RIGHT0', y, x+2)
        CheckConection('RIGHT1', y+1, x+2)
        
        CheckConection('UP0', y-1, x)
        CheckConection('UP1', y-1, x+1)
        
        CheckConection('DOWN0', y+2, x)
        CheckConection('DOWN1', y+2, x+1)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y][x+1] = string.lower(mapa[y][x+1])
        mapa[y+1][x] = string.lower(mapa[y+1][x])
        mapa[y+1][x+1] = string.lower(mapa[y+1][x+1])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1 + 1) + (y-1)*13, (x-1) + (y-1 + 1)*13, (x-1 + 1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_LTL then

        CheckConection('LEFT0', y, x-1)
        CheckConection('LEFT1', y+1, x-2)
        
        CheckConection('RIGHT0', y, x+1)
        CheckConection('RIGHT1', y+1, x+1)
        
        CheckConection('UP0', y, x-1)
        CheckConection('UP1', y-1, x)
        
        CheckConection('DOWN0', y+2, x-1)
        CheckConection('DOWN1', y+2, x)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y+1][x] = string.lower(mapa[y+1][x])
        mapa[y+1][x-1] = string.lower(mapa[y+1][x-1])

        local multinode_idxs = {(x-1) + (y-1)*13, (x-1) + (y-1 + 1)*13, (x-1 - 1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_LTR then
        
        CheckConection('LEFT0', y, x-1)
        CheckConection('LEFT1', y+1, x-1)
        
        CheckConection('RIGHT0', y, x+1)
        CheckConection('RIGHT1', y+1, x+2)
        
        CheckConection('UP0', y-1, x)
        CheckConection('UP1', y, x+1)
        
        CheckConection('DOWN0', y+2, x)
        CheckConection('DOWN1', y+2, x+1)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y+1][x] = string.lower(mapa[y+1][x])
        mapa[y+1][x+1] = string.lower(mapa[y+1][x+1])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1) + (y-1 + 1)*13, (x-1 + 1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_LBL then
        
        CheckConection('LEFT0', y, x-1)
        CheckConection('LEFT1', y+1, x)
        
        CheckConection('RIGHT0', y, x+2)
        CheckConection('RIGHT1', y+1, x+2)
        
        CheckConection('UP0', y-1, x)
        CheckConection('UP1', y-1, x+1)
        
        CheckConection('DOWN0', y+1, x)
        CheckConection('DOWN1', y+2, x+1)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y][x+1] = string.lower(mapa[y][x+1])
        mapa[y+1][x+1] = string.lower(mapa[y+1][x+1])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1 + 1) + (y-1)*13, (x-1 + 1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    elseif roomdata.Shape == RoomShape.ROOMSHAPE_LBR then
        
        CheckConection('LEFT0', y, x-1)
        CheckConection('LEFT1', y+1, x-1)
        
        CheckConection('RIGHT0', y, x+2)
        CheckConection('RIGHT1', y+1, x+1)
        
        CheckConection('UP0', y-1, x)
        CheckConection('UP1', y-1, x+1)
        
        CheckConection('DOWN0', y+2, x)
        CheckConection('DOWN1', y+1, x+1)
        
        mapa[y][x] = string.lower(mapa[y][x])
        mapa[y][x+1] = string.lower(mapa[y][x+1])
        mapa[y+1][x] = string.lower(mapa[y+1][x])


        local multinode_idxs = {(x-1) + (y-1)*13, (x-1 + 1) + (y-1)*13, (x-1) + (y-1 + 1)*13}
        for i, idx in ipairs(multinode_idxs) do
            mod.EverchangerEntityFlags.everchangerNodes[idx] = newNode

            mod.EverchangerEntityFlags.everchangerMultiNodes[idx] = multinode_idxs
        end
        
    else
        
        CheckConection('LEFT0', y, x-1)
        
        CheckConection('RIGHT0', y, x+1)
        
        CheckConection('UP0', y-1, x)

        CheckConection('DOWN0', y+1, x)
        
        mapa[y][x] = string.lower(mapa[y][x])

        mod.EverchangerEntityFlags.everchangerNodes[(x-1) + (y-1)*13] = newNode
    end
    --[[
    for slot, idx in pairs(newNode) do
        if idx then
            print(slot, '->', idx)
        end
    end
    PrintMapa(mapa)
    ]]--
end

-- deadend and some corners
function mod:GetAllDeadends(currentIdx, playerIdx)
    local level = game:GetLevel()

    local deadends = {}
    for key, _ in pairs(mod.EverchangerEntityFlags.everchangerNodes) do
        --print("key", key, _)

        local roomdata = level:GetRoomByIdx(key).Data
        if roomdata then
            local shape = roomdata.Shape
    
            local neighbors = mod.EverchangerEntityFlags.everchangerMultiNodes[key]
            if not neighbors then
                neighbors = {key}
            end
    
            local already_in = false
            for j, dead_idx in ipairs(deadends) do
                if mod:GetTrueSafeGridIndex(key, level) == mod:GetTrueSafeGridIndex(dead_idx, level) then
                    already_in = true
                    break
                end
            end
    
            local already_occuped = false
            if currentIdx and (mod:GetTrueSafeGridIndex(currentIdx, level) == mod:GetTrueSafeGridIndex(key, level)) then
                already_occuped = true
            end
            if playerIdx and (mod:GetTrueSafeGridIndex(playerIdx, level) == mod:GetTrueSafeGridIndex(key, level)) then
                already_occuped = true
            end

            if not (already_in or already_occuped) then
                local enabled_directions = 0
                for i, idx in ipairs(neighbors) do
                    local node = mod.EverchangerEntityFlags.everchangerNodes[idx]
                    for direction, target_idx in pairs(node) do
                        if target_idx then
                            enabled_directions = enabled_directions | (1<<DoorSlot[direction])
                            --print((1<<DoorSlot[direction]))
                        end
                    end
                end
                --print(enabled_directions)
    
                local doors_order = {1<<DoorSlot.LEFT0, 1<<DoorSlot.LEFT1, 1<<DoorSlot.DOWN0, 1<<DoorSlot.DOWN1, 1<<DoorSlot.RIGHT1, 1<<DoorSlot.RIGHT0, 1<<DoorSlot.UP1, 1<<DoorSlot.UP0}
                local dead_flag = false
    
                for i, slot in ipairs(doors_order) do
                    local slot1 = doors_order[(i % 8) + 1]
                    local slot2 = doors_order[((i + 1) % 8) + 1]
                    local slot3 = doors_order[((i + 2) % 8) + 1]
    
                    dead_flag = dead_flag or (enabled_directions == slot)
    
                    if shape > RoomShape.ROOMSHAPE_IV then
                        dead_flag = dead_flag or ((enabled_directions == (slot | slot1)))
                        
                        if shape > RoomShape.ROOMSHAPE_IIH then
                            dead_flag = dead_flag or ((enabled_directions == (slot | slot1 | slot2)))
                            dead_flag = dead_flag or ((enabled_directions == (slot | slot1 | slot2 | slot3)))
                        end
                    end
                end
    
                if dead_flag then
                    --print(key, (enabled_directions&(1<<DoorSlot.LEFT0))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.LEFT1))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.DOWN0))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.DOWN1))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.RIGHT1))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.RIGHT0))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.UP1))>0 and 1 or 0, (enabled_directions&(1<<DoorSlot.UP0))>0 and 1 or 0)
                    table.insert(deadends, key)
                end
            end
        end
    end

    return deadends
end
function mod:GetDeadend(currentIdx, playerIdx)
    local level = game:GetLevel()
    
    local deadends = mod:GetAllDeadends(currentIdx, playerIdx)

    if #deadends == 0 then
        local keys = {}
        for k in pairs(mod.EverchangerEntityFlags.everchangerNodes) do table.insert(keys, k) end
        return keys[mod:RandomInt(1, #keys)]
    end

    return mod:GetTrueSafeGridIndex(deadends[mod:RandomInt(1, #deadends)], level)
end

--DIJKSTRA
function mod:dijkstra(graph, start, target)
    local distances = {} -- Shortest distances from the start node
    local predecessors = {} -- Predecessors in the shortest path
    local visited = {}   -- Set of visited nodes

    -- Initialize distances
    for node, _ in pairs(graph) do
        distances[node] = math.huge
    end
    distances[start] = 0

    while true do
        local minDistance = math.huge
        local current = nil

        -- Find the unvisited node with the smallest distance
        for node, dist in pairs(distances) do
            if not visited[node] and dist < minDistance then
                minDistance = dist
                current = node
            end
        end

        -- If there are no unvisited nodes left or the target is unreachable, exit
        if not current or minDistance == math.huge then
            break
        end

        visited[current] = true

        -- Update distances for neighbors of the current node
        local grafo = graph[current]
        if grafo then
            for direction, neighbor in pairs(grafo) do

                local neighbors = mod.EverchangerEntityFlags.everchangerMultiNodes[neighbor]

                if not neighbors then
                    neighbors = {neighbor}
                end

                for i, true_neighbor in ipairs(neighbors) do
                    if not visited[true_neighbor] then
                        local alt = distances[current] + 1 -- Assuming equal edge weights
        
                        if alt < distances[true_neighbor] then
                            distances[true_neighbor] = alt
                            predecessors[true_neighbor] = current
                        end
                    end
                end
            end
        else
            print("ERROR: EC Graph is invalid")
            print(current, graph[current], game:GetLevel():GetCurrentRoomIndex(), mod.EverchangerEntityFlags.everchangerCurrentIdx)
        end
    end

    -- Build the path from start to target
    local path = {}
    local current = target
    while current do
        table.insert(path, 1, current)
        current = predecessors[current]
    end

    --print("Shortest path:", print_transformed_path(path, ' -> ', function (v) return tostring(v%13)..', '..tostring(math.floor(v/13)) end))

    return path
end

function mod:tryDijsktra(start_idx, end_idx)
    local level = game:GetLevel()
    mod:GenerateEverchangerGraph()

    print("Start disktra test")
    local start_idx = start_idx or level:GetCurrentRoomIndex()
    local end_idx = end_idx or mod:GetDeadend(start_idx, level:GetCurrentRoomIndex())
    print("From node", start_idx, "to node", end_idx)

    local nodes = mod.EverchangerNodes
    
    local g = {}
    for i, k in pairs(mod.EverchangerEntityFlags.everchangerNodes) do
        table.insert(g,i)
    end
    print("Graph:", table.concat(g, ", "))
    
    local path = mod:dijkstra(mod.EverchangerEntityFlags.everchangerNodes, start_idx, end_idx)
    
    if #path > 0 then
        print("Shortest path idx:", table.concat(path, " -> "))
        
        for i=0, 13*13-1 do
            local roomdesc = level:GetRoomByIdx(i)
            roomdesc.Flags = roomdesc.Flags & (~RoomDescriptor.FLAG_RED_ROOM)
        end
        for i, idx in pairs(path) do
            local roomdesc = level:GetRoomByIdx(idx)
            roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_RED_ROOM
        end
        level:UpdateVisibility()
    else
        print("No path found from node", start_idx, "to node", end_idx)
    end
end

--OTHER------------------
----------------------
function mod:QuantumPlayerUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.QuantumPlayer].SUB then
        if not effect.Parent then
            effect:Remove()
            return
        end

        local sprite = effect:GetSprite()
        
        local player = Isaac.GetPlayer(0)
        local player_sprite = player:GetSprite()

        local animation = player_sprite:GetAnimation()
        local frame = player_sprite:GetFrame()

        sprite:SetFrame(animation, frame)
        

        local oanimation = player_sprite:GetOverlayAnimation()
        local oframe = player_sprite:GetOverlayFrame()

        sprite:SetOverlayFrame(oanimation, oframe)

        sprite.Color = effect.Parent:GetSprite().Color
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.QuantumPlayerUpdate, mod.EntityInf[mod.Entity.QuantumPlayer].VAR)

function mod:ECGlitchUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Glitch].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()
        if not data.Init then
            data.Init = true

            sprite:SetFrame(mod:RandomInt(1,70))

            data.DeathFrame = mod:RandomInt(15, 120)

            effect.DepthOffset = 25

            effect.SpriteScale = Vector.One * math.sqrt(rng:RandomFloat())

            sprite.FlipX = rng:RandomFloat() < 0.5
            sprite.FlipY = rng:RandomFloat() < 0.5
        end

        if effect.FrameCount > data.DeathFrame then
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ECGlitchUpdate, mod.EntityInf[mod.Entity.Glitch].VAR)

function mod:ECEyeUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.ECEye].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()
        local parent = effect.Parent and effect.Parent:ToNPC()
        
        if parent then
            local target = parent:GetPlayerTarget()
           
            if not data.Init then
                data.Init = true
                
                data.Speed = 1

                effect.DepthOffset = 100
            end
            effect.DepthOffset = math.max(-100, effect.DepthOffset - 3)

            if sprite:GetAnimation() == 'Appear' then
                local direction = (target.Position - effect.Position):Normalized()
                local max_speed = 15
                data.Speed = math.min(max_speed, data.Speed * 1.1)
                effect.Velocity = mod:Lerp(effect.Velocity, direction*data.Speed, data.Speed/(max_speed*4))
                effect.Position = mod:Lerp(effect.Position, target.Position, 0.01)

                if effect.Position:Distance(target.Position) < 20 then
                    effect.Velocity = Vector.Zero
                    sfx:Play(SoundEffect.SOUND_GFUEL_EXPLOSION_BIG, 2, 2, false, 4)
                    sprite:Play("Attack", true)
                end

            elseif sprite:IsEventTriggered("Attack") then
                for i, e in ipairs(Isaac.FindInRadius(effect.Position, 60)) do
                    if e.Type == EntityType.ENTITY_PLAYER then
                        e:TakeDamage(1, 0, EntityRef(parent), 0)

                    elseif e.Type == EntityType.ENTITY_PICKUP then
                        e = e:ToPickup()
                        if e.Variant == PickupVariant.PICKUP_COLLECTIBLE and e.SubType > 0 and e.SubType < Isaac.GetItemConfig():GetCollectibles ().Size then
                            local r = rng:RandomFloat()
                            if r < mod.EverchangerConsts.ITEM_ROLL_CHANCE then
                                e:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true, true)
                            else
                                if rng:RandomFloat() < 0.4 then
                                    e:Remove()
                                    local faker = Isaac.Spawn(mod.EntityFakerData.ID, mod.EntityFakerData.VAR, mod.EntityFakerData.SUB, e.Position, Vector.Zero, parent)
                                else
                                    -- for _,item in ipairs(Isaac.FindByType(5,100)) do item:ToPickup():Morph(5,100,2^32); item:AddEntityFlags(EntityFlag.FLAG_GLITCH) end
                                    Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
                                    e:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true, true)
                                    Isaac.GetPlayer(0):RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
    
                                    --e:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 2^32-2, true, true)
                                    --e:AddEntityFlags(EntityFlag.FLAG_GLITCH)
    
                                    --e:AddEntityFlags(EntityFlag.FLAG_GLITCH)
                                    --e:GetSprite():SetRenderFlags(AnimRenderFlags.GLITCH)
                                end
                            end
                        elseif e.Variant == PickupVariant.PICKUP_TRINKET then
                            local r = rng:RandomFloat()
                            if r < mod.EverchangerConsts.ITEM_ROLL_CHANCE then
                                e:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, true, true)
                            else
                                e:Remove()
                                local faker = Isaac.Spawn(mod.EntityFakerData.ID, mod.EntityFakerData.VAR, mod.EntityFakerData.SUB, e.Position, Vector.Zero, parent)
                            end
                        end
                    elseif e.Type ~= EntityType.ENTITY_FAMILIAR then
                        e:TakeDamage(20, 0, EntityRef(parent), 0)
                    end
                end

                sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
                sfx:Play(SoundEffect.SOUND_SIREN_SING_STAB,1,2,false, 2)

            elseif sprite:IsFinished("Attack") then
                effect:Remove()
            end
        else
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ECEyeUpdate, mod.EntityInf[mod.Entity.ECEye].VAR)