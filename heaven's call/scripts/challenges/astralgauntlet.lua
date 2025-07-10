local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

mod.ModFlags.LoopRoom = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ModFlags.LoopRoom", false)

function mod:SetGauntletLayout()
    mod.mapa = {
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ','X','X',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ','Y','Y',' ',' ',' ',' ',' '},
        {'X','X',' ','X','X',' ','Y','Y',' ',' ',' ',' ',' '},
        {'X','X',' ','X','X',' ','Y',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ','Y','Y','Y',' ',' ',' ',' ',' '},
        {'X','X',' ','X','X',' ','Y',' ',' ',' ',' ',' ',' '},
        {'X','X',' ','X','X',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '}
    }
    mod.mapa = mod:transposeMatrix(mod.mapa)
end
function mod:GenerateGauntletBosses()
    local level = game:GetLevel()
    local roomDesc

    -- get roomdesc data
    local dataset = {}
    for i = mod.RoomVariantVecs.AstralBoss.X, mod.RoomVariantVecs.AstralBoss.Y do
        local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, i, 20)
        dataset[i] = newroomdata
    end
    local i = 8500
    local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, i, 20)
    dataset[i] = newroomdata

    --replace rooms
    roomDesc = level:GetRoomByIdx(121)--Mercury
    roomDesc.Data = dataset[8525]

    roomDesc = level:GetRoomByIdx(108)--Venus
    roomDesc.Data = dataset[8526]

    roomDesc = level:GetRoomByIdx(104)--Terra
    roomDesc.Data = dataset[8527]

    roomDesc = level:GetRoomByIdx(117)--Mars
    roomDesc.Data = dataset[8528]

    roomDesc = level:GetRoomByIdx(120)--Luna T
    roomDesc.Data = dataset[8530]

    roomDesc = level:GetRoomByIdx(16)--Errant
    roomDesc.Data = dataset[8531]


    roomDesc = level:GetRoomByIdx(66)--Jupiter
    roomDesc.Data = dataset[8520]

    roomDesc = level:GetRoomByIdx(78)--Saturn
    roomDesc.Data = dataset[8521]

    roomDesc = level:GetRoomByIdx(65)--Saturn P
    roomDesc.Data = dataset[8532]

    roomDesc = level:GetRoomByIdx(82)--Uranus
    roomDesc.Data = dataset[8522]

    roomDesc = level:GetRoomByIdx(69)--Neptune
    roomDesc.Data = dataset[8523]

    roomDesc = level:GetRoomByIdx(68)--Pluto+
    roomDesc.Data = dataset[8524]

    roomDesc = level:GetRoomByIdx(118)--Luna I
    roomDesc.Data = dataset[8529]

    roomDesc = level:GetRoomByIdx(17)--Sol
    roomDesc.Data = dataset[8500]

    --

    roomDesc = level:GetRoomByIdx(145)--Home
    roomDesc.Data = dataset[8535]

    roomDesc = level:GetRoomByIdx(158)--Init
    roomDesc.Data = dataset[8534]

    --[[
    roomDesc = level:GetRoomByIdx(79)--Trans
    roomDesc.Data = dataset[8533]
    roomDesc = level:GetRoomByIdx(81)--Trans
    roomDesc.Data = dataset[8533]
    roomDesc = level:GetRoomByIdx(107)--Trans
    roomDesc.Data = dataset[8533]
    roomDesc = level:GetRoomByIdx(105)--Trans
    roomDesc.Data = dataset[8533]
    roomDesc = level:GetRoomByIdx(29)--Trans
    roomDesc.Data = dataset[8533]
    ]]--


end

function mod:GauntletStartRoom()
    local room = game:GetRoom()
    local level = game:GetLevel()

    for _, chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        chest:Remove()
    end

    --Door(s)
    for i = 0, DoorSlot.NUM_DOOR_SLOTS do
        local door = room:GetDoor(i)
        if door then
            local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
            if targetroomdesc and targetroomdesc.Data then
                local data = targetroomdesc.Data
                if data.Type == RoomType.ROOM_PLANETARIUM then
                    local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, 8503, 20)
                    targetroomdesc.Data = newroomdata
                    door:GetSprite():Play("Closed")
                    door:SetLocked (false)

                elseif data.Type == RoomType.ROOM_SHOP then

                    local newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 19, mod.normalDoors)
                    targetroomdesc.Data = newroomdata
                    door:GetSprite():Play("Closed", true)
                    door:SetLocked (true)
                    door:Close (true)
                    door.Busted = false

                end
            end
        end
    end
end

function mod:OnGauntletStart()
    game:SetColorModifier(ColorModifier(0,0,0,1),false)

    music:Pause()

    Isaac.GetPlayer(0):AddBombs(-1)
    Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_THE_JAR)

    mod.ModFlags.babelHeight = 0

    mod:scheduleForUpdate(function()
        Isaac.ExecuteCommand("stage 9")
        game:SetColorModifier(ColorModifier(0,0,0,1),false)
        game:GetHUD():ShowItemText("Climb the tower", "reach the heavens")

        game:GetLevel():AddCurse(LevelCurse.CURSE_OF_THE_LOST, false)

        mod:SetGauntletLayout()
        mod:GenerateRoomsFromMapa()
        mod:GenerateGauntletBosses()
        
        mod:scheduleForUpdate(function()

            local roomConfigStage = RoomConfig.GetStage(StbType.BLUE_WOMB)
            roomConfigStage:SetMusic(mod.Music.HEAVEN_FLOOR)
    
            mod:GoToGauntletInit()
        end, 1)
    end, 1)
end

function mod:GoToGauntletInit()
    local astral_boss = mod.ModFlags.astral_boss
    mod.ModFlags.astral_boss = nil
    

    local player = Isaac.GetPlayer(0)
    player:RemoveCollectible(mod.OtherItems.Carrot)
    player:RemoveCollectible(mod.OtherItems.Egg)

    game:SetColorModifier(ColorModifier(1,1,1,1,5),false)
    sfx:Play(SoundEffect.SOUND_FLASHBACK)
    game:StartRoomTransition(158, Direction.NO_DIRECTION, RoomTransitionAnim.DEATH_CERTIFICATE)

    game:SetColorModifier(ColorModifier(1,1,1,1,5),false)

    if astral_boss then
        local n = 0
        local function func()
            game:SetColorModifier(ColorModifier(1,1,1,1,1.5),false)
            n=n+1
            if n>300 then
                mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, func)
            end
        end
        mod:AddCallback(ModCallbacks.MC_POST_RENDER, func)

        mod:scheduleForUpdate(function ()

            mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, func)
            game:SetColorModifier(ColorModifier(1,1,1,0),true)
            for i, statue in ipairs(mod:FindByTypeMod(mod.Entity.BossStatue)) do
                local data = statue:GetData()

                if data.Planet == astral_boss then
                    player.Position = statue.Position + Vector(0,60)

                    player:AddMaxHearts(-24)

                    if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.OtherItems.Apple) > 0 then
                        player:RemoveCollectible(mod.OtherItems.Apple)
                        player:AddMaxHearts(6)
                    else
                        player:AddMaxHearts(10)
                    end

                    player:SetFullHearts()

                    --Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF; local roomdesc = game:GetLevel():GetRoomByIdx(game:GetLevel():GetCurrentRoomIndex()); roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_NO_WALLS; local camera = game:GetRoom():GetCamera(); camera:SnapToPosition(player.Position)                    
                    break
                end
            end
        end,2)
    end
end
function mod:GauntletDeath(player)
    if mod:IsChallenge(mod.Challenges.BabelTower) and mod.ModFlags.astral_boss then
        mod:GoToGauntletInit()
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.GauntletDeath)

--THINGS
function mod:OnTransitionRoomEnter()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local roomidx = level:GetCurrentRoomIndex()
    local door = level.EnterDoor

    local player = Isaac.GetPlayer(0)

    if not mod:IsChallenge(mod.Challenges.BabelTower) then
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnTransitionRoomEnter)
        return
    end

    if roomidx == 81 or roomidx == 107 or roomidx == 105 or roomidx == 79 or roomidx == 29 or roomidx == 132 then
        mod:ActivateAstralBossBackground(mod.PreviousVariant, mod.PreviousSeed)
		mod:CleanRoom()
            

        local position = player.Position

        --Door(s)
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door then
                door:SetLocked(false)

                if door.Position:Distance(position) <= 41 then
                    local sprite = door:GetSprite()
                    sprite.Rotation = sprite.Rotation + 180

                    if i == DoorSlot.UP0 then
                        sprite.Offset = Vector(0, 280+107)
                    elseif i == DoorSlot.DOWN0 then
                        sprite.Offset = Vector(0, -280-107)
                    elseif i == DoorSlot.RIGHT0 then
                        sprite.Offset = Vector(-520-177, 0)
                    elseif i == DoorSlot.LEFT0 then
                        sprite.Offset = Vector(520+177, 0)
                    end
                    sprite.Offset = sprite.Offset/2
                end
                
            end
        end

        if position.X + 40 < room:GetCenterPos().X then
            player.Position = position + Vector(520+40,0)
        elseif position.X - 40 > room:GetCenterPos().X then
            player.Position = position + Vector(-520-40,0)
        elseif position.Y + 40 < room:GetCenterPos().Y then
            player.Position = position + Vector(0,280+40)
        elseif position.Y - 40 > room:GetCenterPos().Y then
            player.Position = position + Vector(0,-280-40)
        end

        if roomidx == 81 then -- 1
            if door == DoorSlot.UP0 then --TO HOME
                game:StartRoomTransition(145, Direction.DOWN)
            elseif door == DoorSlot.RIGHT0 then --TO SATURN
                game:StartRoomTransition(78, Direction.LEFT)
            end
        elseif roomidx == 107 then -- 2
            if door == DoorSlot.DOWN0 then --TO ERRANT
                game:StartRoomTransition(16, Direction.UP)
            elseif door == DoorSlot.RIGHT0 then --TO TERRA
                game:StartRoomTransition(104, Direction.LEFT)
            end
        elseif roomidx == 105 then -- 3
            if door == DoorSlot.DOWN0 then --TO JUPITER
                game:StartRoomTransition(66, Direction.UP)
            elseif door == DoorSlot.LEFT0 then --TO VENUS
                game:StartRoomTransition(108, Direction.RIGHT)
            end
        elseif roomidx == 79 then -- 4
            if door == DoorSlot.UP0 then --TO I LUNA
                game:StartRoomTransition(118, Direction.DOWN)
            elseif door == DoorSlot.LEFT0 then --TO URANUS
                game:StartRoomTransition(82, Direction.RIGHT)
            end
        elseif roomidx == 29 then -- 5
            if door == DoorSlot.UP0 then --TO LUNA
                game:StartRoomTransition(120, Direction.DOWN)
            end
        elseif roomidx == 132 then -- 6
            if door == DoorSlot.DOWN0 then --TO KUIPER
                game:StartRoomTransition(68, Direction.UP)
            end
        end
        game:SetColorModifier(ColorModifier(0,0,0,1),false)
        
    end

    if not (roomidx == 145 or roomidx == 158 or roomidx == 132) then
        sfx:Play(Isaac.GetSoundIdByName("wood_stairs"), 2)
    end

    if roomidx == 145 and level:GetPreviousRoomIndex() == 158 then
        player.Position = Vector(320, 680)
        mod:scheduleForUpdate(function ()
            player.Position = Vector(320, 680)
        end,1)
        
        game:SetColorModifier(ColorModifier(1,1,1,1,1.5),false)
        game:SetColorModifier(ColorModifier(1,1,1,0),true)
        
		sfx:Play(SoundEffect.SOUND_DOOR_HEAVY_OPEN)
    end

    
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnTransitionRoomEnter)


--LOOP CONTROLLER-------------------------
function mod:LoopControllerInit(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.LoopController].SUB then
        mod.ModFlags.LoopRoom = true
        
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.LoopControllerUpdate)
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.LoopControllerRender)
        mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.LoopPlayerCollsion)

        mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.LoopControllerUpdate)
        mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.LoopControllerRender)
        --mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.LoopPlayerCollsion)

        mod:FixLoopingRoom()

        --
        local room = game:GetRoom()
        local level = game:GetLevel()
        
        Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF

        local roomdesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
        roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_NO_WALLS

        --local camera = room:GetCamera()
        --local center = room:GetCenterPos()
        --camera:SetFocusPosition(center)
        --camera:SnapToPosition(center)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.LoopControllerInit, mod.EntityInf[mod.Entity.LoopController].VAR)

--[[
function mod:LoopControllerRender()
    if game:IsPaused() then return end
    if not mod.ModFlags.LoopRoom then
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.LoopControllerRender)
        mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.LoopPlayerCollsion)
        return
    end

    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    local camera = room:GetCamera()

    local center = room:GetCenterPos()
    local dim = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
    camera:SetFocusPosition(center)
    --camera:SnapToPosition(dim*0.5)

    local pvelocity = player.Velocity
    local hpvelocity = pvelocity

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()

        if entity.Type ~= EntityType.ENTITY_PLAYER then
                
            data.Lposition_HC = data.Lposition_HC or entity.Position
            data.Lposition_HC = data.Lposition_HC - hpvelocity

            if data.ogScale_HC == nil then data.ogScale_HC = Vector(entity.SpriteScale.X, entity.SpriteScale.Y) end

            entity.Position = data.Lposition_HC
            entity.TargetPosition = data.Lposition_HC
            entity:GetData().FixedPosition = data.Lposition_HC

            if entity:GetData().Looping_HC then
                local size = 295.2-- 96*3.075
                
                local x = entity.Position.X % size - size
                local y = entity.Position.Y % size - size
                entity.Position = center + Vector(x,y)
                entity.Velocity = - player.Velocity
            else

                if not (entity.Type == EntityType.ENTITY_PICKUP or entity.Type == EntityType.ENTITY_GENERIC_PROP) then
                    data.Lposition_HC = data.Lposition_HC + entity.Velocity*0.5
                end

                if data.Lposition_HC:Distance(center) > 500 then
                    entity.SpriteScale = mod:Lerp(entity.SpriteScale, Vector.Zero, 0.05)
                else
                    entity.SpriteScale = mod:Lerp(entity.SpriteScale, data.ogScale_HC, 0.5)
                end
            end
            
            entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE

        else
            if not mod:ComparePlayer(entity, player) then
                entity.Position = entity.Position + hpvelocity
            end
        end
    end

    player.Position = center
end
]]

function mod:LoopControllerUpdate()
    if game:IsPaused() then return end
    if not mod.ModFlags.LoopRoom then
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.LoopControllerUpdate)
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.LoopControllerRender)
        mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.LoopPlayerCollsion)
        return
    end

    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    local level = game:GetLevel()
    local camera = room:GetCamera()
    
    local center = room:GetCenterPos()

    if player.Position:Distance(center) > 100 then
        local direction = -(player.Position - center)
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            local data = entity:GetData()

            local isfollowing = nil
            local effect = entity:ToEffect()
            if effect then
                isfollowing = effect.IsFollowing
                effect.IsFollowing = false
            end
            local laser = entity:ToLaser()
            if laser then
                isfollowing = laser.DisableFollowParent
                laser.DisableFollowParent = true
            end

            local parent = entity.Parent
            entity.Parent = nil

            entity.Position = entity.Position + direction
            if entity.TargetPosition then
                entity.TargetPosition =  entity.TargetPosition + direction
            end
            if data.FixedPosition then
                data.FixedPosition = data.FixedPosition + direction
            end

            if data.Looping_HC then
                if data.Looping_Grass_HC then
                    local sizex = 2080
                    local sizey = 1120
                    local x = (entity.Position.X % sizex + sizex) % sizex
                    local y = (entity.Position.Y % sizey + sizey) % sizey
                    entity.Position = Vector(x, y)
                else
                    local size = 96*3.075
                    local x = entity.Position.X % size - size
                    local y = entity.Position.Y % size - size
                    entity.Position = Vector(x,y)
                end
            end

            if isfollowing then
                if effect then
                    effect.IsFollowing = isfollowing
                end
                if laser then
                    laser.DisableFollowParent = isfollowing
                end
            end
            entity.Parent = parent
        end
        
        --camera:SnapToPosition(player.Position*2)
        --game:Render()
        --player.Position = center
        camera:SnapToPosition(player.Position*2 - 2*player.Velocity)
        --game:Render()
        --game:Render()
        --camera:SnapToPosition(player.Position*2)
        --game:Update()
        --camera:SnapToPosition(player.Position*2)
        --game:Update()
        --camera:SnapToPosition(player.Position*2)
        --game:Render()

        --[[
        for _, grass in ipairs(mod:FindByTypeMod(mod.Entity.Grass)) do
            grass.Visible = true
            for _, _entity in ipairs(Isaac.FindInRadius(grass.Position, 40)) do
                if _entity:ToPickup() or _entity.DepthOffset < 0 then
                    grass.Visible = false
                    break
                end
            end
        end
        ]]
    end

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()

        if entity.Type ~= EntityType.ENTITY_PLAYER then

            if data.ogScale_HC == nil then
                data.ogScale_HC = Vector(entity.SpriteScale.X, entity.SpriteScale.Y)
                entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE
            end

            if entity:GetData().Looping_HC then
                
            else

                if entity.Position:Distance(center) > 500 then
                    entity.SpriteScale = mod:Lerp(entity.SpriteScale, Vector.Zero, 0.05)
                else
                    entity.SpriteScale = mod:Lerp(entity.SpriteScale, data.ogScale_HC, 0.5)
                end
            end
        end

    end

end
function mod:LoopControllerRender()
    if game:IsPaused() then return end
    if not mod.ModFlags.LoopRoom then
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.LoopControllerUpdate)
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.LoopControllerRender)
        mod:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.LoopPlayerCollsion)
        return
    end

    local player = Isaac.GetPlayer(0)
    local room = game:GetRoom()
    local camera = room:GetCamera()

    Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF
    camera:SnapToPosition(player.Position*2)
    --camera:SetFocusPosition(player.Position*2)
end

function mod:LoopPlayerCollsion(player, collider, collision)
    if (collider.Type == EntityType.ENTITY_GENERIC_PROP) or (collider.Type == EntityType.ENTITY_PICKUP and collider.Variant == mod.furnitureData.CORPSE.VAR) then
        local direction = (player.Position - collider.Position):Normalized()
        player.Velocity = direction*0.5
        player.ControlsCooldown = 1
        return true
    end
end

local positions = {
    [mod.EntityInf[mod.Entity.House].VAR] = {[mod.EntityInf[mod.Entity.House].SUB] = Vector(480, 320), [mod.EntityInf[mod.Entity.House].SUB-2] = Vector(760, 400), [mod.EntityInf[mod.Entity.House].SUB+1] = Vector(-1000, 1000)},
    [PickupVariant.PICKUP_COLLECTIBLE] = {[mod.OtherItems.Apple] = Vector(720,440), [CollectibleType.COLLECTIBLE_KEY_PIECE_1] = Vector(720,440)}
}
function mod:FixLoopingRoom()
    local player = Isaac.GetPlayer(0)
    local flag = false
    
    for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        if entity.SpriteScale:Length() <= 0.005 or (positions[entity.Variant] and positions[entity.Variant][entity.SubType]) then
            flag = true
            break
        end
    end

    if flag then
        for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
            if positions[entity.Variant] and positions[entity.Variant][entity.SubType] then
                entity.Position = positions[entity.Variant][entity.SubType] + Vector(85, 40)
            else
                entity.Position = player.Position + mod:RandomVector(300, 180) + Vector(1000,0)
            end
            entity.SpriteScale = Vector.One
        end
        
        
        local room = game:GetRoom()
        local level = game:GetLevel()

        Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF

        local roomdesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
        roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_NO_WALLS
        
        --local camera = room:GetCamera()
        --local center = room:GetCenterPos()
        --camera:SetFocusPosition(center)
        --camera:SnapToPosition(center)
    end
end

--HOUSE-------------------------
function mod:OnHouseUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.House].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local room = game:GetRoom()

        if not data.Init then
            data.Init = true
            entity.DepthOffset = 30
		    --room:SetBackdropType(BackdropType.DUNGEON, 5)

            if mod.ModFlags.babelHeight and mod.ModFlags.babelHeight > 0 then
                local h = math.min(8, mod.ModFlags.babelHeight)
                sprite:Play("Idle"..tostring(h), true)
            else
                sprite:Play("Idle", true)
            end
            data.FixedPosition = entity.Position

            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            data.Flag = false

            for i, e in ipairs(Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP, 3, 0)) do
                e:Remove()
            end
            for i=40, 240, 100 do
                for j=0, -80, -40 do
                    local col = Isaac.Spawn(EntityType.ENTITY_GENERIC_PROP, 3, 0, entity.Position + Vector(i,j), Vector.Zero, nil)
                    col.Visible = false
                    col.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                end
            end

            --buttons
            if mod.ModFlags.babelHeight == 0 then
                local ogPos = entity.Position + Vector(0, 200)
                for i=1, 4 do
                    local position = ogPos + (i-1)*Vector(128,0)
                    local button = mod:SpawnEntity(mod.Entity.BabelButton, position, Vector.Zero, nil)
                    button:GetData().Level = i
                end

                mod:SpawnBossStatues(entity.Position + Vector(-600,-100))
            end
        end

        if not data.Flag then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            if entity.Position:Distance(Isaac.GetPlayer(0).Position) > 80 then
                data.Flag = true
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
        end

        entity.Velocity = Vector.Zero

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnHouseUpdate, mod.EntityInf[mod.Entity.House].VAR)

function mod:OnHouseCollision(entity, collider, collision)
    if entity.SubType == mod.EntityInf[mod.Entity.House].SUB then
        if collider.Type == EntityType.ENTITY_PLAYER then
            
            game:StartRoomTransition(145, Direction.UP)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnHouseCollision, mod.EntityInf[mod.Entity.House].VAR)

--Items
function mod:OnBabelItemsCache(player, cache)
    if player:HasCollectible(mod.OtherItems.Apple) then
        if cache == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 0.5 * player:GetCollectibleNum(mod.OtherItems.Apple)
        end
        if cache == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.1 * player:GetCollectibleNum(mod.OtherItems.Apple)
        end
        if cache == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 1.7 * player:GetCollectibleNum(mod.OtherItems.Apple)
        end
        if cache == CacheFlag.CACHE_RANGE then
            player.TearRange  = player.TearRange + 30 * player:GetCollectibleNum(mod.OtherItems.Apple)
        end
        if cache == CacheFlag.CACHE_FAMILIARS then
            --player:CheckFamiliar(FamiliarVariant.BROTHER_BOBBY, 1, player:GetCollectibleRNG(mod.OtherItems.Apple), Isaac.GetItemConfig():GetCollectible(mod.OtherItems.Apple), 0)
        end
    end
    
    if player:HasCollectible(mod.OtherItems.Carrot) then
        if cache == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 3 * player:GetCollectibleNum(mod.OtherItems.Carrot)
        end
        if cache == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.2 * player:GetCollectibleNum(mod.OtherItems.Carrot)
        end
        if cache == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 3.56 * player:GetCollectibleNum(mod.OtherItems.Carrot)
        end
        if cache == CacheFlag.CACHE_RANGE then
            player.TearRange  = player.TearRange + 30 * player:GetCollectibleNum(mod.OtherItems.Carrot)
        end
        if cache == CacheFlag.CACHE_FAMILIARS then
            --player:CheckFamiliar(FamiliarVariant.SISTER_MAGGY, 1, player:GetCollectibleRNG(mod.OtherItems.Apple), Isaac.GetItemConfig():GetCollectible(mod.OtherItems.Apple), 0)
        end
    end
    
    if player:HasCollectible(mod.OtherItems.Egg) then
        if cache == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 2.5 * player:GetCollectibleNum(mod.OtherItems.Egg)
        end
        if cache == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.2 * player:GetCollectibleNum(mod.OtherItems.Egg)
        end
        if cache == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 2.5 * player:GetCollectibleNum(mod.OtherItems.Egg)
        end
        if cache == CacheFlag.CACHE_RANGE then
            player.TearRange  = player.TearRange + 60 * player:GetCollectibleNum(mod.OtherItems.Egg)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnBabelItemsCache)


function mod:SetTowerDifficulty(n)
    local player = Isaac.GetPlayer(0)

    player:RemoveCollectible(CollectibleType.COLLECTIBLE_WAFER)
    
    if player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
        player:ChangePlayerType(PlayerType.PLAYER_ISAAC)
        if player:HasCollectible(mod.OtherItems.Apple) then
            player:AddMaxHearts(10)
        else
            player:AddMaxHearts(6)
        end
        player:AddHearts(24)
        player:AddSoulHearts(-24)
    end

    local tree = mod:FindByTypeMod(mod.Entity.Tree)[1]
    if tree then
        tree:GetData().Level = tree:GetData().Level or ""
    end
    local newTreeLevel = ""

    local grass = mod:FindByTypeMod(mod.Entity.Background)[1]

    local buttons = mod:FindByTypeMod(mod.Entity.BabelButton)
    local theButton = buttons[1]
    for i, button in ipairs(buttons) do
        if i-1 == n then
            theButton = button
        end

        button:GetSprite():SetFrame("Idle"..tostring(button:GetData().Level), 0)
        button:GetData().Pressed = false
    end

    if n == 0 then --normal
        player:AddCollectible(CollectibleType.COLLECTIBLE_WAFER)
        mod.savedatasettings().Difficulty = mod.Difficulties.NORMAL

        newTreeLevel = ""

        game:SetColorModifier(ColorModifier(0.85,0.85,1, 0.15, -0.1, 0.9))

        if grass then grass:GetData().Color = Color(0.75,0.75,0.75,1) end

    elseif n == 1 then --attuned
        mod.savedatasettings().Difficulty = mod.Difficulties.ATTUNED

        newTreeLevel = "2"

        game:SetColorModifier(ColorModifier(0.95,0.95,1, 0.07, 0, 1))

        if grass then grass:GetData().Color = Color.Default end

    elseif n == 2 then --ascended
        mod.savedatasettings().Difficulty = mod.Difficulties.ASCENDED

        newTreeLevel = "3"

        game:SetColorModifier(ColorModifier(1,1,1, 0, 0.1, 1.25))

        if grass then grass:GetData().Color = Color(1.5,1,1,1) end

    else --radiant
        mod.savedatasettings().Difficulty = mod.Difficulties.ASCENDED

        newTreeLevel = "4"

        game:SetColorModifier(ColorModifier(1,1,1, 0, 0.25, 2))

        player:ChangePlayerType(PlayerType.PLAYER_THELOST_B)

        if grass then grass:GetData().Color = Color(1.5,0.8,0.8,1, 0.1) end
    end

    mod:UpdateDifficulty(mod.savedatasettings().Difficulty, true)

    if theButton then
        theButton:GetSprite():SetFrame("Idle"..tostring(theButton:GetData().Level), 1)
        theButton:GetData().Pressed = true
    end

    if tree then
        tree:GetSprite():Play("Down"..tostring(tree:GetData().Level), true)
        tree:GetData().Level = newTreeLevel
        mod:scheduleForUpdate(function ()
            if tree then tree:GetSprite():Play("Up"..newTreeLevel, true) end
        end,5)
    end
    
    if mod.ModFlags.babelHeight == 0 then
        mod:SpawnBossStatues(mod:FindByTypeMod(mod.Entity.House)[1].Position + Vector(-600,-100))
    else
	    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.BossStatue))
    end

    for _, grass in ipairs(mod:FindByTypeMod(mod.Entity.Grass)) do
        mod:ChangeGrass(grass, n)
    end
end

--button
function mod:BabelButtonUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.BabelButton].SUB then
        local data = effect:GetData()
        local sprite = effect:GetSprite()
        local player = Isaac.GetPlayer(0)

        if not data.Init then
            data.Init = true
            data.Level = data.Level or 1

            local current_difficulty = mod.savedatasettings().Difficulty
            if current_difficulty == mod.Difficulties.ASCENDED and Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_THELOST_B and mod:IsChallenge(mod.Challenges.BabelTower) then
                current_difficulty = 3
            end
            current_difficulty = current_difficulty + 1
            
            if data.Level == current_difficulty then
                sprite:SetFrame("Idle"..tostring(data.Level), 1)
                data.Pressed = true
            else
                sprite:SetFrame("Idle"..tostring(data.Level), 0)
            end

            effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
            effect.DepthOffset = -100
        end

        if not data.Pressed then

            if player.Position:Distance(effect.Position) < 10 then
                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 2)
                mod:SetTowerDifficulty(data.Level-1)
            end

        else
            local frame = game:GetFrameCount()
            if data.Level == 1 and (frame&3==1) then
			    local rain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RAIN_DROP, 0, player.Position + mod:RandomVector(250), Vector.Zero, nil)
            elseif data.Level == 4 and (frame&7==1) then
                local ember = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, player.Position + mod:RandomVector(350), Vector.Zero, nil)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BabelButtonUpdate, mod.EntityInf[mod.Entity.BabelButton].VAR)

--grass
function mod:SpawnGrass()
    local room = game:GetRoom()
	local _rng = RNG(game:GetSeeds():GetStartSeed(), game:GetSeeds():GetStartSeed()%79+1)
    for i=1, 50 do
        
        local position = room:GetRandomPosition(0)*2
        local flag = true
        for _, _entity in ipairs(Isaac.FindInRadius(position, 100)) do
            if _entity:ToPickup() or (_entity.DepthOffset < 0) then
                flag = false
                break
            end
        end
        if flag then
            local grass = mod:SpawnEntity(mod.Entity.Grass, position, Vector.Zero, nil)
            grass:GetData().Seed = mod:RandomInt(1,21, _rng)
            grass:GetSprite().FlipX = mod:RandomInt(0,1, _rng)==0
        end
    end
end
function mod:ChangeGrass(effect, difficulty)
    local sprite = effect:GetSprite()
    sprite:SetFrame(difficulty)

    sprite.Scale.Y = 0.5

    --[[
    effect.Visible = true
    for _, _entity in ipairs(Isaac.FindInRadius(effect.Position, 40)) do
        if _entity:ToPickup() or _entity.DepthOffset < 0 then
            effect.Visible = false
            break
        end
    end
    ]]
end
function mod:GrassUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Grass].SUB then
        local data = effect:GetData()
        local sprite = effect:GetSprite()

        if not data.Init then
            data.Init = true

            data.Seed = data.Seed or 1

            sprite:Play(tostring(data.Seed), true)

		    data.Looping_HC = true
		    data.Looping_Grass_HC = true

            

            local current_difficulty = mod.savedatasettings().Difficulty
            if current_difficulty == mod.Difficulties.ASCENDED and Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_THELOST_B and mod:IsChallenge(mod.Challenges.BabelTower) then
                current_difficulty = 3
            end
            mod:ChangeGrass(effect, current_difficulty)

            
            for _, _entity in ipairs(Isaac.FindInRadius(effect.Position, 100)) do
                if _entity:ToPickup() or (_entity.DepthOffset < 0) then
                    effect:Remove()
                end
            end
            

            effect.DepthOffset = 0--20
        end

        if sprite.Scale.Y < 1 then
            sprite.Scale.Y = math.min(1.001, sprite.Scale.Y * 1.25)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.GrassUpdate, mod.EntityInf[mod.Entity.Grass].VAR)

--MAP
function mod:OnBabelRoomChange(targetRoomIdx, dimension)
    
    if not mod:IsChallenge(mod.Challenges.BabelTower) then
        mod:RemoveCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, mod.OnBabelRoomChange)
        return
    end

    local room = game:GetRoom()
    local level = game:GetLevel()
    local door = level.EnterDoor

	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local variant = roomdata.Variant

    local roomidx = level:GetCurrentRoomIndex()
    
    local returnVal = nil

    local tidx = nil
    local didx = nil
    if targetRoomIdx == 132 then -- up hall to Kuiper
        returnVal = {68, dimension}
        --game:StartRoomTransition(68, Direction.UP)
        tidx = 68
        didx = Direction.UP

    elseif targetRoomIdx == 81 then -- K U
        if roomidx == 82 then --from Uranus to Saturn
            returnVal = {78, dimension}
            --game:StartRoomTransition(78, Direction.UP)
            tidx = 78
            didx = Direction.UP

        elseif roomidx == 68 then --from Kuiper to Hall
            returnVal = {145, dimension}
            --game:StartRoomTransition(145, Direction.UP)
            tidx = 145
            didx = Direction.UP

        end
    end
    
    return {68, dimension}
end
--mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, mod.OnBabelRoomChange)


--[[

]]