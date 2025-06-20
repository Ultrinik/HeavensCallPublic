local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

mod.hyperdiceConsts = {
    BASE_SPAWN_CHANCE = 15,--%
}

table.insert(mod.PostLoadInits, {"savedatafloor", "activatedHyperdice", false})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatafloor.activatedHyperdice", false)

function mod:HyperDiceGenerator()
    local level = game:GetLevel()

    if mod.savedatasettings().hyperDiceSpawnChance == nil then mod.savedatasettings().hyperDiceSpawnChance = mod.hyperdiceConsts.BASE_SPAWN_CHANCE end
    local totalchance = mod.savedatasettings().hyperDiceSpawnChance/100
    local extraMult = 1

    if mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY) then
        extraMult = extraMult + 1*mod:HowManyItems(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY)
    end
    if mod:SomebodyHasTrinket(mod.Trinkets.Noise) then
        extraMult = extraMult + 1*mod:HowManyTrinkets(mod.Trinkets.Noise)
    end

    totalchance = totalchance*extraMult
    for i=0, 13*13-1 do
        local roomdesc = level:GetRoomByIdx(i, 0)
        if roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DICE and roomdesc.Data.Weight > 0.01 and roomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x1 then
            if rng:RandomFloat() < totalchance then

                local newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, mod.RoomVariantVecs.Hyper.X, mod.RoomVariantVecs.Hyper.Y, 20, 20, roomdesc.Data.Doors)

                roomdesc.Data = newroomdata

                if MinimapAPI and false then
                    local success = roomdesc
                    local data = roomdesc.Data

                    local gridIndex = success.SafeGridIndex
                    local position = mod:GridIndexToVector(gridIndex)
				
                    local maproom = MinimapAPI:GetRoomAtPosition(position)
                    if maproom then
                        --maproom.ID = "astralchallenge"..tostring(gridIndex)
    
                        --Anything below is optional
                        maproom.Type = RoomType.ROOM_DICE
                        maproom.PermanentIcons = {"DiceRoom"}
                        maproom.DisplayFlags = 0
                        maproom.AdjacentDisplayFlags = 3
                        maproom.Descriptor = success
                        maproom.AllowRoomOverlap = false
                        maproom.Color = Color.Default
                    else
                        MinimapAPI:AddRoom{
                            ID = "hyperdice"..tostring(gridIndex),
                            Position = position,
                            Shape = data.Shape,
    
                            --Anything below is optional
                            Type = RoomType.ROOM_DICE,
                            PermanentIcons = {"DiceRoom"},
                            DisplayFlags = 0,
                            AdjacentDisplayFlags = 3,
                            Descriptor = success,
                            AllowRoomOverlap = false,
                            Color = Color.Default,
                        }
                    end
                end

                break
            end
        end
    end
end

function mod:OnHyperInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.HYPER)

	--mod:PlayRoomMusic(mod.Music.HYPER)

    if room:IsFirstVisit() then
        if MinimapAPI and MinimapAPI:GetCurrentRoom() then
            MinimapAPI:GetCurrentRoom().PermanentIcons = {"HyperDice"}
        end
    end

end

function mod:OnHyperdiceUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Hyperdice].SUB then
        local room = game:GetRoom()
        local data = effect:GetData()
        local sprite = effect:GetSprite()
        sprite.Rotation = sprite.Rotation + 0.5

        if not data.Init then
            data.Init = true

            effect.DepthOffset = 5000
    
            sprite:PlayOverlay("Idle2", true)
            sprite:SetOverlayRenderPriority(false)
    
            sprite.Scale = Vector.One*0.4
            sprite.PlaybackSpeed = 0.85
    
            if not data.Deactivated then
                local condition = effect.Position.X > game:GetRoom():GetCenterPos().X
                if not condition then
        
                    local floor = mod:SpawnEntity(mod.Entity.Hyperdice, effect.Position, Vector.Zero, effect, nil, 162)
                    floor.SpriteScale = Vector.One*0.18
                    floor.SortingLayer = SortingLayer.SORTING_DOOR
        
                else
                    sfx:Play(Isaac.GetSoundIdByName("Hyperdice"),3)
        
                    sprite.Scale = Vector.One * 0.1
                    sprite.Color = Color(1,1,1, 0.1)
                end
            else
                effect.Visible = false
            end
        end

        if not data.Deactivated then
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                if player and player.Position:Distance(effect.Position) < 50 then
                    mod:ActivateHyperdice()
                    data.Anim = true
                end
            end
        end

        --Doors
        if effect.Visible then
            for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                local door = room:GetDoor(i)
                if door then
                    local doorSprite = door:GetSprite()
                    if not doorSprite:IsPlaying("Opened") then
                        doorSprite:Play("Opened", true)
                    end
                end
            end
        end

        if data.Anim then
            sprite.Scale = sprite.Scale * 1.1
            sprite.Color = Color(1,1,1, sprite.Color.A*0.9)
        elseif data.InitAnim then
            local scale = sprite.Scale.X
            scale = (scale*scale*scale*scale*1.35)^0.225
            
            sprite.Scale = Vector(scale, scale)
            sprite.Color = Color(1,1,1, (sprite.Color.A*sprite.Color.A*1.1)^0.5)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnHyperdiceUpdate, mod.EntityInf[mod.Entity.Hyperdice].VAR)



function mod:OnHypersquareInit(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Hyperdice].SUB+1 then
        effect.DepthOffset = -500
        effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.OnHypersquareInit, mod.EntityInf[mod.Entity.Hyperdice].VAR)

function mod:OnHypersquareUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Hypersquare].SUB then

        local sprite = effect:GetSprite()
        
        if sprite:IsFinished("Idle") then
            effect:Remove()
        end

        --sprite.Color = Color(1,0,0,1)

        --print(sprite.Color)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnHypersquareUpdate, mod.EntityInf[mod.Entity.Hypersquare].VAR)


function mod:OnHyperholeUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Hyperhole].SUB then

        local sprite = effect:GetSprite()

        local t = effect.FrameCount/10
        local p = 2
        local color = 0.75 + 0.5*math.abs(t/p - math.floor(t/p + 1/2)) --(math.sin(t)^2)

        sprite.Color = Color(color, color, color, 1)--, color/4, color/4, color/4)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnHyperholeUpdate, mod.EntityInf[mod.Entity.Hyperhole].VAR)


function mod:ActivateHyperdice()
    if not mod.savedatafloor().activatedHyperdice then
        game:ShakeScreen(20)
        game:Darken(1,30)

        mod.savedatafloor().activatedHyperdice = true

        local room = game:GetRoom()
        local level = game:GetLevel()

        for i=0, 13*13-1 do
            local roomdesc = level:GetRoomByIdx(i, 0)
            if roomdesc and roomdesc.Data then
                mod:HyperPrepareSpecialRoom(room, roomdesc)
            end
        end
    end
end

function mod:ValidHyperRollRoom(roomtype)
    local condition = (roomtype == RoomType.ROOM_SHOP) or (roomtype == RoomType.ROOM_TREASURE) or (roomtype == RoomType.ROOM_SECRET) or (roomtype == RoomType.ROOM_SUPERSECRET) or (roomtype == RoomType.ROOM_ARCADE) or (roomtype == RoomType.ROOM_CURSE) or (roomtype == RoomType.ROOM_CHALLENGE) or (roomtype == RoomType.ROOM_LIBRARY) or (roomtype == RoomType.ROOM_SACRIFICE) or (roomtype == RoomType.ROOM_DEVIL) or (roomtype == RoomType.ROOM_ANGEL) or (roomtype == RoomType.ROOM_ISAACS) or (roomtype == RoomType.ROOM_BARREN) or (roomtype == RoomType.ROOM_CHEST) or (roomtype == RoomType.ROOM_DICE) or (roomtype == RoomType.ROOM_PLANETARIUM) or (roomtype == RoomType.ROOM_ULTRASECRET)
    return condition
end

function mod:IsHyperSpecialRoom(room, roomdesc)
    local roomtype = room:GetType()

    local condition = mod:ValidHyperRollRoom(roomtype)

    condition = condition and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1

    condition = condition and not mod:IsRoomDescHyper(roomdesc)

    return condition
end

function mod:HyperPrepareSpecialRoom(room, roomdesc)
    local condition = mod:IsHyperSpecialRoom(room, roomdesc)

    if condition then
        roomdesc.VisitedCount = 0
    end
end

mod.ModFlags.hyperroomInProgress = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.hyperroomInProgress", false)

function mod:OnHyperdiceNewRoom()
    if mod.savedatafloor().activatedHyperdice then
        mod.ModFlags.hyperroomInProgress = false
        local room = game:GetRoom()
        local level = game:GetLevel()
        local roomdesc = level:GetRoomByIdx(level:GetCurrentRoomIndex(), 0)

        mod:scheduleForUpdate(function()
            if roomdesc and roomdesc.Data then
                local condition = mod:IsHyperSpecialRoom(room) and (level:GetCurrentRoomIndex() >= 0)
                if (roomdesc.VisitedCount == 1) and condition and not mod.ModFlags.hyperroomInProgress then

                    local roomidx = level:GetCurrentRoomIndex()
                    local previdx = level:GetPreviousRoomIndex()

                    mod.ModFlags.hyperroomInProgress = roomidx
                    roomdesc.VisitedCount = 3
                    --roomdesc.VisitedCount = 0 --infinite loop testing

                    --hyper
                    local dice = mod:SpawnEntity(mod.Entity.Hyperdice, room:GetCenterPos()+Vector(1,0), Vector.Zero, nil)
                    dice:GetData().InitAnim = true

                    game:ShakeScreen(60)
                    game:Darken(1,100)

                    mod:scheduleForUpdate(function()
                        
                        if mod.ModFlags.hyperroomInProgress == roomidx then

                            mod:EraseRoom()
                            mod:scheduleForUpdate(function()
                                --roomdesc.VisitedCount = 0
                                mod:RerrollRoom(roomdesc)
                                roomdesc.Flags = 0
                                roomdesc.NoReward = true
                                mod:scheduleForUpdate(function()
                                    game:StartRoomTransition(roomidx, Direction.NO_DIRECTION, RoomTransitionAnim.FADE)
                                    mod.ModFlags.hyperroomInProgress = false
                                end, 1)
                            end, 5)

                        else
                            roomdesc.VisitedCount = 0

                        end
                    end,35)
                end
            end
        end, 3)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnHyperdiceNewRoom)

--floor
function mod:HyperDiceFloorGenerator(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Hyperfloor].SUB then

        if effect.FrameCount % 2 == 0 then
            local square = mod:SpawnEntity(mod.Entity.Hypersquare, effect.Position, Vector.Zero, effect)

            local t = effect.FrameCount/30
            local p = 2
            local color = 2 * math.abs(t/p - math.floor(t/p + 0.5))
            --local color = (math.sin(t)^2)

            square:GetSprite().Color = Color(color, color, color, 1)


            local color2 = color--2 * math.abs(t/p - math.floor(t/p + 1/2)) --(math.sin(t)^2)

            square:GetSprite().Rotation = 180*color2 % 360
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.HyperDiceFloorGenerator, mod.EntityInf[mod.Entity.Hyperfloor].VAR)

-- (partially) FROM FIEND FOLIO
function mod:EraseRoom()
	local room = game:GetRoom()

    mod:CleanRoom()

    for _,entity in ipairs(Isaac.GetRoomEntities()) do
        local id = entity.Type
        local var = entity.Variant

        local condition = id == EntityType.ENTITY_PICKUP or
                        id == EntityType.ENTITY_SLOT or
                        id == EntityType.ENTITY_SHOPKEEPER or
                        id == EntityType.ENTITY_FIREPLACE or
                        (id == EntityType.ENTITY_EFFECT and var == EffectVariant.DICE_FLOOR) or
                        (id == EntityType.ENTITY_EFFECT and var == EffectVariant.WISP) or
                        (id == EntityType.ENTITY_EFFECT and var == EffectVariant.ISAACS_CARPET)
        if condition then
            entity:Remove()
        end
    end

	--Rock Removal
    local newGrids = {}
    for i=0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity and not (gridEntity:GetType() == GridEntityType.GRID_DOOR or gridEntity:GetType() == GridEntityType.GRID_DECORATION or gridEntity:GetType() == GridEntityType.GRID_WALL or gridEntity:GetType() == GridEntityType.GRID_TRAPDOOR) then
            room:RemoveGridEntity(i, 0, false)
            --room:RemoveGridEntityImmediate(i, 0, false)
            table.insert(newGrids, i)
        end
    end
    for i = 1, #newGrids do
        for k = 1, 3 do
            mod:scheduleForUpdate(function()
                local room = game:GetRoom()
                room:SpawnGridEntity(newGrids[i], GridEntityType.GRID_DECORATION, 0, 0, 0)
            end, k)
        end
        mod:scheduleForUpdate(function()
            local square = mod:SpawnEntity(mod.Entity.Hyperdice, room:GetGridPosition(newGrids[i]), Vector.Zero, nil, nil, 163)
            square.SortingLayer = SortingLayer.SORTING_BACKGROUND
        end, 7)
    end
    if StageAPI then
        for _, customGrid in ipairs(StageAPI.GetCustomGrids()) do
            customGrid:Remove(false)
        end
    end
end