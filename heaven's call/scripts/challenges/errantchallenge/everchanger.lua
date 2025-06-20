local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

local ID = Isaac.GetEntityTypeByName(" Everchanger ")
local VAR = Isaac.GetEntityVariantByName(" Everchanger ")
mod.EverchangerData = {
    ID = ID,
    VAR = VAR,
    SUB = 0,
}

local flags = mod.EverchangerFlags
flags.currentPath = nil
flags.everchangerCurrentIdx = nil
flags.everchangerNextIdx = nil
flags.everchangerPreviousIdx = nil
flags.currentRoomprogress = 0
flags.roaming = true
flags.direction = nil
flags.distance = 9999

local everchangerSpeed = 1.5


mod.ECState = {
    ROAMING = 0,
    CATCH = 1,
    BATTLE = 2,
    LASTSTAND = 3,
}

function mod:EverchangerUpdate(entity)
    if entity.Variant == VAR then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()


        flags.position1 = {[0]=entity.Position.X, [1]=entity.Position.Y-15, [2]=100 + 20*math.sin( (flags.time or 0) )}

        if not data.Init then
            data.Init = true
            data.State = data.State or mod.ECState.ROAMING
            data.HasSawPlayer = false
            data.Direction = (target.Position - entity.Position):Normalized()
            data.BattleSpeed = data.BattleSpeed or 1
            data.CatchSpeed = data.CatchSpeed or 0
            
            entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            sprite:Play("Idle")
            if data.State == mod.ECState.CATCH then
                entity.CollisionDamage = 0
            end
        end

        if data.State == mod.ECState.CATCH then
            if ((not target:GetData().Rainbow) or (target:GetData().Rainbow and (target:GetData().Rainbow <= 0))) and (not target:GetData().IsHidden or data.HasSawPlayer) then
                mod:EverchangerCatch(entity, sprite, data, target)
                flags.currentRoomprogress = math.max(0, flags.currentRoomprogress - everchangerSpeed/3)

                if not data.HasSawPlayer and (target.Position:Distance(entity.Position) < 300) then
                    data.HasSawPlayer = true
                    sfx:Play(mod.SFX.AngryStaticScream, 10)
                end
            else
                flags.currentRoomprogress = flags.currentRoomprogress + everchangerSpeed/1.5
                local targetPos = mod:GetEverchangerPosition(flags.direction, flags.currentRoomprogress)
                entity.Position = mod:Lerp(entity.Position, targetPos, 0.5)

                if flags.currentRoomprogress >= 100 then
                    flags.position1 = {[0]=0,[1]=0,[2]=0}
                    entity:Remove()
                    mod:EverchangerChangeRoom(false)
                end
            end

        elseif data.State == mod.ECState.BATTLE then
            mod:EverchangerBattle(entity, sprite, data, target)
        elseif data.State == mod.ECState.LASTSTAND then
            mod:EverchangerLastStand(entity, sprite, data, target)
        end

    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.EverchangerUpdate, ID)

function mod:EverchangerCatch(entity, sprite, data, target)
    local speed = data.CatchSpeed
    data.CatchSpeed = math.max(data.CatchSpeed+0.05, 5)

    local direction = target.Position - entity.Position
    direction = direction:Normalized()

    entity.Velocity = entity.Velocity*0.5 + direction*5
    entity.Velocity = entity.Velocity:Normalized()*speed

    if entity.Position:Distance(target.Position) < (target.Size + entity.Size + 10) then
        entity:Remove()
        mod:scheduleForUpdate(function()
            mod:TriggerEverchangerBattle()
        end, 2)
    end
end
function mod:EverchangerBattle(entity, sprite, data, target)
    entity.Velocity = data.Direction*data.BattleSpeed

    if rng:RandomFloat() < 0.025 then
        data.Direction = (target.Position - entity.Position):Normalized()
    end

end
function mod:EverchangerLastStand(entity, sprite, data, target)
    entity.Velocity = data.Direction*data.BattleSpeed

    if rng:RandomFloat() < 0.25 then
        data.Direction = (target.Position - entity.Position):Normalized()
    end

    if entity.Position:Distance(target.Position) < (target.Size + entity.Size + 10) then
        

        local player = Isaac.GetPlayer(0)
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



--OVERWORLD
function mod:EverchangerWorldUpdate()
    local level = game:GetLevel()
    --print(flags.everchangerCurrentIdx, level:GetCurrentRoomIndex())
    if flags.errantMoving then
        local level = game:GetLevel()
        local room = game:GetRoom()
        local currentRoomIdx = level:GetCurrentRoomIndex()
        local shape = room:GetRoomShape()

        --if currentRoomIdx == 84 then currentRoomIdx = currentRoomIdx + 13 end

        if flags.currentPath and #flags.currentPath>0 then
            if flags.everchangerCurrentIdx ~= currentRoomIdx then
                flags.Roaming = true
                flags.currentRoomprogress = flags.currentRoomprogress + everchangerSpeed

                local playerInPath = false
                for _, idx in pairs(flags.currentPath) do
                    if idx == currentRoomIdx then
                        playerInPath = true
                        break
                    end
                end
                if playerInPath then
                    flags.distance = math.max(100, flags.distance-everchangerSpeed)
                else
                    flags.distance = flags.distance+everchangerSpeed

                end

                if flags.currentRoomprogress >= 100 then --Crossed a room-----------------------------------------
                    mod:EverchangerChangeRoom(playerInPath)
                end
            else
                if flags.Roaming then
                    flags.Roaming = false

                    local room = game:GetRoom()

                    local position = mod:GetEverchangerPosition(flags.direction, flags.currentRoomprogress) or room:GetCenterPos()
                    local ever = Isaac.Spawn(ID, VAR, 0, position, Vector.Zero, nil)
                    ever:GetData().State = mod.ECState.CATCH
                end
            end
        else
            mod:ChanceEverchangerPath()
        end
    end
end

function mod:ChanceEverchangerPath(targetIdx)
    local level = game:GetLevel()
    local room = game:GetRoom()
    local currentRoomIdx = level:GetCurrentRoomIndex()
    local shape = room:GetRoomShape()

    sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"))

    targetIdx = targetIdx or mod:GetDeadend(flags.everchangerCurrentIdx, level:GetCurrentRoomIndex())

    --print(mod.EverchangerNodes, mod.EverchangerNodes[flags.everchangerCurrentIdx], flags.everchangerCurrentIdx)
    local path = mod:dijkstra(mod.EverchangerNodes, flags.everchangerCurrentIdx, targetIdx)


    for key, idx in pairs(path) do
        if idx == flags.everchangerCurrentIdx then
            table.remove(path, key)
        end
    end
    for _, idx in pairs(path) do
        flags.everchangerNextIdx = idx
        break
    end

    mod:GetEverchangerDirection(flags.everchangerCurrentIdx, flags.everchangerNextIdx, shape)

    flags.currentPath = path
end

function mod:EverchangerChangeRoom(playerInPath)
    local level = game:GetLevel()
    local room = game:GetRoom()
    local currentRoomIdx = level:GetCurrentRoomIndex()
    local shape = room:GetRoomShape()
    if currentRoomIdx == 84 then currentRoomIdx = currentRoomIdx + 13 end

    flags.everchangerPreviousIdx = flags.everchangerCurrentIdx
    flags.everchangerCurrentIdx = flags.everchangerNextIdx

    for key, idx in pairs(flags.currentPath) do
        if idx == flags.everchangerCurrentIdx then
            table.remove(flags.currentPath, key)
        end
    end
    for _, idx in pairs(flags.currentPath) do
        flags.everchangerNextIdx = idx
        break
    end

    mod:GetEverchangerDirection(flags.everchangerCurrentIdx, flags.everchangerNextIdx, shape)

    flags.currentRoomprogress = 0

    if flags.enabledHUD then
        for i=0, 13*13-1 do
            local roomdesc = level:GetRoomByIdx(i)
            if roomdesc.Data and roomdesc.Flags then
                roomdesc.Flags = roomdesc.Flags & (~RoomDescriptor.FLAG_RED_ROOM)
            end
        end

        local roomdesc = level:GetRoomByIdx(flags.everchangerCurrentIdx)
        --roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_RED_ROOM
        
        level:UpdateVisibility()
    end
    if playerInPath then
        local playerPath = mod:dijkstra(mod.EverchangerNodes, flags.everchangerCurrentIdx, currentRoomIdx)
        flags.distance = 100*(#playerPath)
    end
end

function mod:GetEverchangerDirection(everchangerCurrentIdx, everchangerNextIdx, shape)

    local x1 = math.floor(everchangerCurrentIdx / 13)
    local y1 = everchangerCurrentIdx % 13
    local v1 = Vector(x1, y1)

    local x2 = math.floor(everchangerNextIdx / 13)
    local y2 = everchangerNextIdx % 13
    local v2 = Vector(x2, y2)

    local direction = v2-v1

    if direction.X < 0 then
        flags.direction = DoorSlot.DOWN0
    elseif direction.X > 0 then
        flags.direction = DoorSlot.UP0
    elseif direction.Y > 0 then
        flags.direction =  DoorSlot.LEFT0 + (shape > 1 and 4 or 0)
    elseif direction.Y < 0 then
        flags.direction = DoorSlot.RIGHT0 + (shape > 1 and 4 or 0)
    end
end
function mod:GetEverchangerPosition(direction, currentRoomprogress)
    local room = game:GetRoom()

    if flags.everchangerPreviousIdx then
    
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door and flags.everchangerPreviousIdx == door.TargetRoomIndex then

                if currentRoomprogress < 50 then
                    local v1 = room:GetDoorSlotPosition(i)
                    local v2 = room:GetCenterPos()
            
                    local d = v2-v1
            
                    local position = v1 + d*currentRoomprogress/50
                    return position
                else
                    local v1 = room:GetCenterPos()
                    local v2 = room:GetDoorSlotPosition(mod.oppslots[direction])
            
                    local d = v2-v1
            
                    local position = v1 + d*((currentRoomprogress-50)/50)
                    return position
                end

            end
        end



    else
        local v1 = room:GetDoorSlotPosition(direction)
        local v2 = room:GetDoorSlotPosition(mod.oppslots[direction])

        local d = v2-v1

        local position = v1 + d*currentRoomprogress/100
        return position
    end
end

--0PBT V7LS