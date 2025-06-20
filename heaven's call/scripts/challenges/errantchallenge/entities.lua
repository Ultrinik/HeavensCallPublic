local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

mod.ChallengeStuff = {
    --FakeDoor = {ID = Isaac.GetEntityTypeByName("Fake Door (HC)"), VAR = Isaac.GetEntityVariantByName("Fake Door (HC)"), }
}

local stuff = mod.ChallengeStuff

local flags = mod.EverchangerFlags

--[[
--This fake doors only work for the rooms that are used in the Everchanger challenge, sorry uwu

function mod:FakeDoorUpdate(entity)
    if entity.Variant == stuff.FakeDoor.VAR then
        local data = entity:GetData()

        if not data.Init then
            data.Init = true
            data.OgPos = entity.Position

            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        entity.Position = data.OgPos

        for i=0, game:GetNumPlayers ()-1 do
            local player = game:GetPlayer(i)
            if player and player.Position:Distance(entity.Position)<15 then 
                mod:UseFakeDoor(entity)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.FakeDoorUpdate, stuff.FakeDoor.ID)

function mod:UseFakeDoor(entity)
    local data = entity:GetData()
    if data.TargetIndex and data.Slot then
        game:StartRoomTransition(data.TargetIndex, data.Slot%4)

        mod:scheduleForUpdate(function()
            local player = Isaac.GetPlayer(0)
            local room = game:GetRoom()
            local direction = (room:GetCenterPos()-player.Position):Normalized()
            local position = room:GetDoorSlotPosition(mod.oppslots[data.Slot%4])+direction*100
            player.Position = position
        end,2)
    end
end

function mod:IsStartingRoom(roomdesc)
    if game:GetLevel():GetStartingRoomIndex() == roomdesc.GridIndex then return true end
end

function mod:RoomHasLongRoomAbove(roomdesc)
    local level = game:GetLevel()

    local currentIdx = roomdesc.GridIndex
    
    local otherIdx = currentIdx - 2*13
    local potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) and (potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x2 or potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_LTR) then
        return otherIdx
    end
    
    otherIdx = currentIdx - 2*13 - 1
    potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) and potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_LTR then
        return otherIdx
    end



    return false
end

function mod:LongRoomHasRoomsDown(roomdesc)
    local level = game:GetLevel()

    local currentIdx = roomdesc.GridIndex
    local doors = {[0] = nil, [1] = nil, [2] = nil}
    
    local otherIdx = currentIdx + 2*13
    local potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) then
        doors[1] = otherIdx
    end
    
    otherIdx = currentIdx + 1*13 - 1
    potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) then
        doors[0] = otherIdx
    end
    
    if roomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x2 then
        otherIdx = currentIdx + 1*13 + 1
    elseif roomdesc.Data.Shape == RoomShape.ROOMSHAPE_LTR then
        otherIdx = currentIdx + 1*13 + 2
    end
    potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) then
        doors[2] = otherIdx
    end


    return doors
end

function mod:RoomHasLongRoomSide(roomdesc)
    local level = game:GetLevel()

    local currentIdx = roomdesc.GridIndex
    local doors = {[0] = nil, [1] = nil}
    
    local otherIdx = currentIdx - 1*13 + 1
    local potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) and (potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x2 or potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_LTR) then
        doors[1] = otherIdx
    end
    
    
    otherIdx = currentIdx - 1*13 - 1
    potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) and potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x2 then
        doors[0] = otherIdx
    end
    otherIdx = currentIdx - 1*13 - 2
    potentialRoomdesc = level:GetRoomByIdx(otherIdx)
    if potentialRoomdesc.Data and not mod:IsStartingRoom(potentialRoomdesc) and potentialRoomdesc.Data.Shape == RoomShape.ROOMSHAPE_LTR then
        doors[0] = otherIdx
    end



    return doors
end

function mod:OnNewRoomFakeDoors()
    local level = game:GetLevel()
    local room = game:GetRoom()
    local currentroomdesc = level:GetCurrentRoomDesc()

    if level:GetStartingRoomIndex() == currentroomdesc.GridIndex then return end

    local upDoorIdx = mod:RoomHasLongRoomAbove(currentroomdesc)
    if upDoorIdx then
        local position = room:GetDoorSlotPosition(DoorSlot.UP0) + mod.DoorOffset[DoorSlot.UP0%4]*1.25

        local door = Isaac.Spawn(stuff.FakeDoor.ID, stuff.FakeDoor.VAR, 0, position, Vector.Zero, nil)
        door:GetData().TargetIndex = upDoorIdx
        door:GetData().Slot = DoorSlot.UP0
    end

    local sideDoorsIdxs = mod:RoomHasLongRoomSide(currentroomdesc)
    if sideDoorsIdxs[0] then
        local position = room:GetDoorSlotPosition(DoorSlot.LEFT0) + mod.DoorOffset[DoorSlot.LEFT0%4]*1.25

        local door = Isaac.Spawn(stuff.FakeDoor.ID, stuff.FakeDoor.VAR, 0, position, Vector.Zero, nil)
        door:GetSprite().Rotation = -90
        door:GetData().TargetIndex = sideDoorsIdxs[0]
        door:GetData().Slot = DoorSlot.LEFT0

    end
    if sideDoorsIdxs[1] then
        local position = room:GetDoorSlotPosition(DoorSlot.RIGHT0) + mod.DoorOffset[DoorSlot.RIGHT0%4]*1.25

        local door = Isaac.Spawn(stuff.FakeDoor.ID, stuff.FakeDoor.VAR, 0, position, Vector.Zero, nil)
        door:GetSprite().Rotation = 90
        door:GetData().TargetIndex = sideDoorsIdxs[1]
        door:GetData().Slot = DoorSlot.RIGHT0
    end

    if currentroomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x2 or currentroomdesc.Data.Shape == RoomShape.ROOMSHAPE_LTR then
        local downDoorsIdxs = mod:LongRoomHasRoomsDown(currentroomdesc)
        if downDoorsIdxs[0] then
            local position = room:GetDoorSlotPosition(DoorSlot.LEFT1) + mod.DoorOffset[DoorSlot.LEFT1%4]*1.25
    
            local door = Isaac.Spawn(stuff.FakeDoor.ID, stuff.FakeDoor.VAR, 0, position, Vector.Zero, nil)
            door:GetSprite().Rotation = -90
            door:GetData().TargetIndex = downDoorsIdxs[0]
            door:GetData().Slot = DoorSlot.LEFT1
        end
        if downDoorsIdxs[1] then
            local position = room:GetDoorSlotPosition(DoorSlot.DOWN0) + mod.DoorOffset[DoorSlot.DOWN0%4]*1.25
    
            local door = Isaac.Spawn(stuff.FakeDoor.ID, stuff.FakeDoor.VAR, 0, position, Vector.Zero, nil)
            door:GetSprite().Rotation = -180
            door:GetData().TargetIndex = downDoorsIdxs[1]
            door:GetData().Slot = DoorSlot.DOWN0
        end
        if downDoorsIdxs[2] then
            local position = room:GetDoorSlotPosition(DoorSlot.RIGHT1) + mod.DoorOffset[DoorSlot.RIGHT1%4]*1.25
    
            local door = Isaac.Spawn(stuff.FakeDoor.ID, stuff.FakeDoor.VAR, 0, position, Vector.Zero, nil)
            door:GetSprite().Rotation = 90
            door:GetData().TargetIndex = downDoorsIdxs[2]
            door:GetData().Slot = DoorSlot.RIGHT1
        end
    end

end
]]


--FAKER
mod.EntityFakerData = {
    ID = Isaac.GetEntityTypeByName("  Fake Isaac  "),
    VAR = Isaac.GetEntityVariantByName("  Fake Isaac  "),
    SUB = Isaac.GetEntitySubTypeByName("  Fake Isaac  "),
}

function mod:FakeUpdate(entity)
    if entity.Variant == mod.EntityFakerData.VAR and entity.SubType == mod.EntityFakerData.SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
    
        if not data.Init then
            data.Init = true
        
            sprite:SetOverlayRenderPriority(false)
    
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

        end

        sprite:SetOverlayFrame("Head1", mod:RandomInt(0,65))

        if rng:RandomFloat() < 0.075 then
            sprite.Rotation = rng:RandomFloat()*360
        else
            sprite.Rotation = 0
        end
        if rng:RandomFloat() < 0.1 then
            entity.Scale = rng:RandomFloat()
        else
            entity.Scale = 1
        end
    
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

        
        if rng:RandomFloat() < 0.005 then
            sfx:Play(mod.SFX.GlitchGaper, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.FakeUpdate, mod.EntityFakerData.ID)

function mod:FakerDeath(entity)
    if entity.Variant == mod.EntityFakerData.VAR and entity.SubType == mod.EntityFakerData.SUB then
        mod:SpawnGibs(entity, 15)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.FakerDeath, mod.EntityFakerData.ID)

function mod:SpawnGibs(entity, n)
    local MIN_GIBS = n -- max is double this
    local MAX_BLOOD_GIB_SUBTYPE = 3

    local gibCount = rng:RandomInt(MIN_GIBS + 1) + MIN_GIBS
    for _ = 1, gibCount do
        local speed = rng:RandomInt(4) + 1
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, rng:RandomInt(MAX_BLOOD_GIB_SUBTYPE + 1), entity.Position, RandomVector() * speed, nil)
    end

    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, nil)
    cloud.SpriteScale = Vector.One*0.5
    cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, nil)
    cloud.SpriteScale = Vector.One*0.5
    cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, nil)
    cloud.SpriteScale = Vector.One*0.5
    sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
end

--CIRCLE
mod.EntityCircleData = {
    ID = Isaac.GetEntityTypeByName("Effigy circle (HC)"),
    VAR = Isaac.GetEntityVariantByName("Effigy circle (HC)"),
    SUB = Isaac.GetEntitySubTypeByName("Effigy circle (HC)"),--160,
}

mod.CirclesStates = {}
mod.CircleTrinkets = {
    [0] = mod.EverchangerTrinkets.unicorn,
    [1] = mod.EverchangerTrinkets.pyro,
    [2] = mod.EverchangerTrinkets.apple,
    [3] = mod.EverchangerTrinkets.tech,
    [4] = mod.EverchangerTrinkets.yuckheart,
    [5] = mod.EverchangerTrinkets.sackhead,
    [6] = mod.EverchangerTrinkets.icecube,
    [7] = mod.EverchangerTrinkets.darkmatter,
    [8] = mod.EverchangerTrinkets.certificate,
}
mod.CirclesData = {
    [0] = {POSITION = Vector(120,205), IDX = 128}, --mercury
    [1] = {POSITION = Vector(520,390), IDX = 77}, --venus
    [2] = {POSITION = Vector(320, 340), IDX = 80}, --terra
    [3] = {POSITION = Vector(320,340), IDX = 136}, --mars
    [4] = {POSITION = Vector(190,215), IDX = 107}, --jupiter
    [5] = {POSITION = Vector(150,280), IDX = 116}, --saturn
    [6] = {POSITION = Vector(320,340), IDX = 125}, --uranus
    [7] = {POSITION = Vector(120,640), IDX = 118}, --neptune
    [8] = {POSITION = Vector(150,200), IDX = 48}, --luna
}

function mod:CircleUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        local tipo = data.Type

        if not data.Init then
            data.Init = true


            if #Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP) > 0 then
                mod.CirclesStates[tipo] = true
            end

            if mod.CirclesStates[tipo] then
                local corpse = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+11, entity.Position, Vector.Zero, entity)
                local corpseSprite = corpse:GetSprite()
                corpseSprite:Play("Idle"..tostring(data.Type), true)
            end

            sprite:SetFrame("Idle", data.Type)
            sprite:Stop()

            entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
            data.Dist = 100
        end
        if not mod.CirclesStates[tipo] then
            local corpse = Isaac.FindByType(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB)[1]
            local dist = data.Dist
            if corpse and corpse.Position:Distance(entity.Position) < dist then
                local trinket = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.CircleTrinkets[tipo])[1]
                if trinket and trinket.Position:Distance(entity.Position) < dist then
                    mod:TriggerCircle(entity, tipo, trinket, corpse)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.CircleUpdate, mod.EntityCircleData.VAR)

function mod:TriggerCircle(entity, tipo, trinket, fleshcorpse)

    local specialFlag = true

    if tipo == 4 and not mod:IsRoomElectrified() then--jupiter
        specialFlag = false
    end

    if specialFlag then
        --mod:SpawnGibs(fleshcorpse, 15)
        
        local corpse = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+11, entity.Position, Vector.Zero, entity)
        local corpseSprite = corpse:GetSprite()
        corpseSprite:Play("Idle"..tostring(entity:GetData().Type), true)

        trinket:Remove()
        fleshcorpse:Remove()
        mod.CirclesStates[tipo] = true

        for i=1, 20 do
            local velocity = Vector(mod:RandomInt(5, 25), 0):Rotated(rng:RandomFloat()*360)
            local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, entity.Position, velocity, nil)
        end

        if tipo == 1 then--venus
            local room = game:GetRoom()
            for i, index in ipairs({80,95,37,52}) do
                local position = room:GetGridPosition(index)

                for i, fire in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
                    if fire.Position:Distance(position) < 10 then
                        fire:Die()
                    end
                end
            end
        end

        sfx:Play(mod.SFX.EffigyCompleted)
    end
end

--SHOPKEEPERS
function mod:ShopkeeperUpdate(entity)
    entity.HitPoints = 9999

    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.SackHead then
        if not data.Init then
            data.Init = true

            sprite:Load("hc/gfx/entity_SaturnShopkeeper.anm2", true)
            if not flags.hasSackBeenTaken then
                sprite:Play("Idle", true)
            else
                sprite:Play("Naked", true)
            end
        end

        local player = Isaac.GetPlayer(0)
        if not flags.hasSackBeenTaken then
            if player.Position:Distance(entity.Position) < 20 then
                flags.hasSackBeenTaken = true
                
                local sack = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.sackhead, entity.Position+Vector(0,10), Vector.Zero, entity)
                sprite:Play("Naked", true)
                sfx:Play(SoundEffect.SOUND_BIRD_FLAP)
            end
        end
    end
end

--BUTTON
function mod:ComputerButtonUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+1 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)

        if not data.Init then
            data.Init = true
            data.Type = data.Type or 0
            sprite:Play(tostring(data.Type), true)
            sprite:Stop()

            flags.password = ""

            entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
        end

        if entity.Position:Distance(player.Position) < 20 then
            if sprite:GetFrame() == 0 then
                sprite:Play(tostring(data.Type), true)
            else

            end
        else
            if sprite:GetFrame() == 0 then
                
            else
                sprite:Play(tostring(data.Type), true)
                sprite:Stop()
            end
        end

        if sprite:IsEventTriggered("Click") then
            sfx:Play(mod.SFX.PasswordClick, 1)
            flags.password = flags.password .. tostring(data.Type)
            if #flags.password == 4 then
                if flags.password == "1112" then
                    sfx:Play(mod.SFX.CorrectPassword, 2)
                    data.Correct = true
                else
                    mod:LureErrant(game:GetLevel():GetCurrentRoomIndex()+1)
                    sfx:Play(mod.SFX.PasswordAlarm, 10)
                    flags.password = ""
                end
            end
        end

        if data.Type == 0 then--anyone
            local room = game:GetRoom()
            local door = room:GetDoor(DoorSlot.RIGHT0)
            if door then
                local doorSprite = door:GetSprite()

                if flags.password ~= "1112" then
                    local targetroomdesc = game:GetLevel():GetRoomByIdx(door.TargetRoomIndex)
                    if targetroomdesc.VisitedCount == 0 then
                        local everchanger = mod:FindByTypeMod(mod.Entity.Everchanger)[1]
                        local condition = everchanger and everchanger.Position:Distance(door.Position) < 400
                        if condition and (doorSprite:GetAnimation() == "Close" or doorSprite:GetAnimation() == "Closed") then
                            doorSprite:Play("Open", true)
                        end
        
                        if doorSprite:GetAnimation() == "Open" then
                            if not condition then
                                doorSprite:Play("Close", true)
                            end
                        end

                        if doorSprite:GetAnimation() ~= "Opened" then
                            local direction = player.Position - door.Position
                            local largo = 35
                            if direction:Length() < largo then
                                player.Position = door.Position + direction:Resized(largo)
                            end
                        end
                    else
                        if doorSprite:GetAnimation() == "Close" or doorSprite:GetAnimation() == "Closed" then
                            doorSprite:Play("Open", true)
                        end
                    end
                else
                    if doorSprite:GetAnimation() == "Close" or doorSprite:GetAnimation() == "Closed" then
                        doorSprite:Play("Open", true)
                    end
                end
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ComputerButtonUpdate, mod.EntityCircleData.VAR)

function mod:LureErrant(idx)
    sfx:Play(mod.SFX.AngryStaticScream, 5)
    if flags.enabledErrant then
        mod:StartEverchangerEntity(mod.EverchangerEntityFlags.everchangerCurrentIdx, idx, nil)
    end
end

--GUPPY
function mod:GuppyUpdate(entity)
    if entity.SubType == 160 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if not data.Init then
            data.Init = true
            entity.Position = game:GetRoom():GetCenterPos() + Vector(0, 100)
        end

        if data.Death then
            sprite.FlipX = false
            sprite:Play("Dead", true)
            entity.Velocity = Vector.Zero
            entity.Position = data.DeadPosition or entity.Position

        else

            if entity.FrameCount % 15 == 0 then
                data.Fish = #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.fish) > 0
            end
            if data.Fish then
                local fish = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.fish)[1]
                if fish then
                    fish.DepthOffset = -10
                    local direction = (fish.Position - entity.Position)
                    if direction:Length() < 100 then
                        entity.Velocity = direction/10
                        if entity.Velocity.X > 0 then 
                            sprite.FlipX = false
                        else
                            sprite.FlipX = true
                        end

                        if direction:Length() < 15 then
                            data.AnimFrame = data.AnimFrame or 0
                            sprite:SetFrame("Eat", data.AnimFrame)
                            data.AnimFrame = data.AnimFrame + 1

                            if sprite:IsEventTriggered("Eat") then
                                fish.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                                fish.Visible = false
                                mod:SpawnGibs(entity, 5)
                            elseif sprite:IsEventTriggered("Puke") then
                                local yuck = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.yuckheart, entity.Position, Vector(0, 5), entity)
                                sfx:Play(SoundEffect.SOUND_BLOBBY_WIGGLE)
                            elseif sprite:GetFrame() >= 51 then
                                fish:Remove()
                            else

                            end
                        else
                            data.AnimFrame = 0
                        end
                    end
                else
                    data.Fish = false
                end
            end

            if rng:RandomFloat() < 0.01 and entity.Position:Distance(entity.Player.Position) < 15 and not sfx:IsPlaying(mod.SFX.Purring) then
                sfx:Play(mod.SFX.Purring, 2)
            end
        end

        if data.Suicide then
            entity.Velocity = Vector(5, 0)
            if entity.Position.X > 400 then
                Isaac.GetPlayer(0):RemoveCollectible(mod.EverchangerTrinkets.guppy)
            end

            entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE
        else
            entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        end

        local maxvel = 5
        if entity.Velocity:Length() > maxvel then
            entity.Velocity = entity.Velocity:Resized(maxvel)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.GuppyUpdate, FamiliarVariant.LEECH)

function mod:GuppyInit(entity)

    if entity.SubType == 160 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01))
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.GuppyInit, FamiliarVariant.LEECH)

function mod:SwitchGuppyState(isDead, isSuicide)
    for i, guppy in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEECH, 160)) do
        guppy:GetData().Death = isDead
        guppy:GetData().Suicide = isSuicide
        if not isDead then
            guppy:GetSprite():Play("Appear", true)
        end
    end
end

--FLY CORPSE
function mod:FlyingCorpseUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+2 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if not data.Init then
            data.Init = true

            sprite:SetFrame("Idle", mod:RandomInt(0,4))
            sprite:Stop()
            sprite.Rotation = 360*rng:RandomFloat()

            entity.SortingLayer = SortingLayer.SORTING_BACKGROUND

            entity.Velocity = RandomVector()*(1.5+2*rng:RandomFloat())

            entity.SpriteScale = Vector.One * (0.5 + 0.4*rng:RandomFloat())

            entity.DepthOffset = -4500 + entity.SpriteScale.X*10
        end

        sprite.Rotation = (sprite.Rotation + 3)%360

        local direction = entity.Position - game:GetRoom():GetCenterPos()
        if direction:Length() > 400 then
            entity.Position = game:GetRoom():GetCenterPos() - direction*0.9
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FlyingCorpseUpdate, mod.EntityCircleData.VAR)

--MIRROR
function mod:MirrorEntityRender(entity)
    if entity.SubType == mod.EntityCircleData.SUB+3 or entity.SubType == mod.EntityCircleData.SUB+4 then
        local parent = entity.Parent

        if parent then
            local sprite = entity:GetSprite()
            local data = entity:GetData()
            local room = game:GetRoom()
            local data = entity:GetData()
            --data.Count = data.Count and data.Count+1 or 0
            
            local centerPos = room:GetCenterPos()
            local entityPos = parent.Position
            local mirrorPos = Vector(entityPos.X, centerPos.Y - (entityPos.Y - centerPos.Y))


            entity.Position = mirrorPos
            entity.Velocity = Vector(parent.Velocity.X, -parent.Velocity.Y)

            local ogSprite = parent:GetSprite()

            sprite:SetFrame(ogSprite:GetAnimation(), ogSprite:GetFrame())
            if parent.Type == EntityType.ENTITY_PLAYER then

                local olAnim = ogSprite:GetOverlayAnimation()
                if olAnim == "" then
                    sprite:RemoveOverlay()
                else
                    sprite:SetOverlayFrame(olAnim, ogSprite:GetOverlayFrame())
                end

                
                local r = 100 + 3*math.sin( (flags.time or 0)/10 )
                flags.position6 = {[0]=entity.Position.X, [1]=entity.Position.Y-15, [2]=r}

            else
                sprite.FlipX = ogSprite.FlipX
            end

        else
            entity:Remove()
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.MirrorEntityRender, mod.EntityCircleData.VAR)

--BUBBLES
function mod:BubbleSourceUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+5 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)

        if player.Position:Distance(entity.Position) < 50 then
            flags.oxygen = math.min(100, flags.oxygen+1)
        end

        if entity.FrameCount % 2 == 0 then
            local bubble = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, entity.Position + Vector(0,-5), Vector(0,-10), nil):ToEffect()
            bubble.DepthOffset = 500
            local bubbleSprite = bubble:GetSprite()
            bubbleSprite:Load("hc/gfx/effect_UnderwaterBubble.anm2", true)
            bubbleSprite:Play("Poof", true)
            bubbleSprite.Scale = Vector.One*(rng:RandomFloat()*0.3 + 0.1)
            bubbleSprite.PlaybackSpeed = 0.1
        end


    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BubbleSourceUpdate, mod.EntityCircleData.VAR)

--BACKGROUND PLANET
function mod:BackgroundPlanetUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+6 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if not data.Init then
            data.Init = true

            data.orbitTotal = data.orbitTotal or 1
            data.orbitDistance = data.orbitDistance or 1500

            data.orbitScaleOffset = 360*rng:RandomFloat()
            data.rotationSpeed = 1 - 2*rng:RandomFloat()

            entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
            entity.DepthOffset = -4000

            data.ogScale = Vector.One / 1.75

            data.Brigth = 0

            data.Tipo = data.Tipo or 8
            local tipo = data.Tipo

            --funny to scale
            if false then
                if tipo == 0 then
                    data.ogScale = Vector.One * 0.38
                elseif tipo == 1 then
                    data.ogScale = Vector.One * 0.95
                elseif tipo == 2 then
                    data.ogScale = Vector.One * 1
                elseif tipo == 3 then
                    data.ogScale = Vector.One * 0.53
                elseif tipo == 4 then
                    data.ogScale = Vector.One * 11.21
                elseif tipo == 5 then
                    data.ogScale = Vector.One * 9.45
                elseif tipo == 6 then
                    data.ogScale = Vector.One * 4.01
                elseif tipo == 7 then
                    data.ogScale = Vector.One * 3.88
                elseif tipo == 8 then
                    data.ogScale = Vector.One * 0.27
                end
                data.ogScale = data.ogScale * 0.15
            end
            if tipo == 0 then
                sprite:Load("hc/gfx/backdrop/planets/mercury.anm2", true)
            elseif tipo == 1 then
                sprite:Load("hc/gfx/backdrop/planets/venus.anm2", true)
            elseif tipo == 2 then
                sprite:Load("hc/gfx/backdrop/planets/terra.anm2", true)
            elseif tipo == 3 then
                sprite:Load("hc/gfx/backdrop/planets/mars.anm2", true)
            elseif tipo == 4 then
                sprite:Load("hc/gfx/backdrop/planets/jupiter.anm2", true)
            elseif tipo == 5 then
                sprite:Load("hc/gfx/backdrop/planets/saturn.anm2", true)
            elseif tipo == 6 then
                sprite:Load("hc/gfx/backdrop/planets/uranus.anm2", true)
            elseif tipo == 7 then
                sprite:Load("hc/gfx/backdrop/planets/neptune.anm2", true)
            end

            sprite:Play("idle", true)
            sprite.PlaybackSpeed = 0.5
        end

        if not data.orbitAngle then
            data.orbitAngle = data.orbitIndex*360/data.orbitTotal
        end
        if entity.Parent then
            local offset = Vector(175*math.cos(data.orbitAngle*math.pi/180)*(1-data.Brigth),0)
            entity.Position  = entity.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(data.orbitDistance) + offset
            data.orbitAngle = (data.orbitAngle + data.orbitSpin*data.orbitSpeed) % 360
        end

        entity.DepthOffset = -4000 + entity.Position.Y/10

        local t = (data.orbitScaleOffset + entity.FrameCount*2.5) % 360
        local sin = math.sin( t * math.pi / 180 )
        entity.SpriteScale = (data.ogScale) * (0.9 + 0.1*sin)

        if entity.FrameCount > 30 and not data.Dissapear then
            local c = 0.45 + 0.15*sin
            sprite.Color = Color(c, c, c, 1)
        end

        if data.Dissapear then
            sprite.Color = Color(1,1,1,1-data.Brigth,data.Brigth,data.Brigth,data.Brigth)
            data.Brigth = data.Brigth + 0.05
            data.ogScale = data.ogScale * 1.25
            data.orbitDistance = math.max(0, data.orbitDistance * 0.75)
            if data.Brigth >= 1 then
                sfx:Play(SoundEffect.SOUND_FAMINE_SHOOT)
                entity:Remove()

                local statue = Isaac.FindByType(mod.furnitureData.STATUE.ID, mod.furnitureData.STATUE.VAR, mod.furnitureData.STATUE.SUB)[1]
                if statue then
                    statue:SetColor(Color(1, 1, 1, 1, 1,1,1), 30, 1, true, true)
                    sfx:Play(mod.SFX.Effigy+data.Tipo)
                end
            end
        end

        sprite.Rotation = sprite.Rotation + 0.33*data.rotationSpeed 

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BackgroundPlanetUpdate, mod.EntityCircleData.VAR)

--SATURN BUTTON
function mod:SaturnButtonUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+7 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)

        if not data.Init then
            data.Init = true
            sprite:Stop()

            entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
        end

        if entity.Position:Distance(player.Position) < 20 then
            if sprite:GetFrame() == 0 then
                sprite:Play("Idle", true)
            else

            end
        else
            if sprite:GetFrame() == 0 then
                
            else
                sprite:Play("Idle", true)
                sprite:Stop()
            end
        end

        if sprite:IsEventTriggered("Click") then
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 2)

            if not flags.endRoomOpen then
                if mod.ClockPassword[1] and mod.ClockPassword[1] == data.Index then
                    for i=2, 5 do
                        mod.ClockPassword[i-1] = mod.ClockPassword[i]
                    end
                    if #mod.ClockPassword == 0 then
                        flags.endRoomOpen = true
                        sfx:Play(mod.SFX.SecretRoom)
                    end
                elseif #mod.ClockPassword > 0 then
                    mod.ClockPassword = {}
                    sfx:Play(mod.SFX.EvilClock)
                    mod:LureErrant(game:GetLevel():GetCurrentRoomIndex())
                end
            end

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SaturnButtonUpdate, mod.EntityCircleData.VAR)

--SATURN CLOCK
mod.ClockPassword = {}
function mod:SaturnClockUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+8 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)

        if not data.Init then
            data.Init = true

            sprite:Stop()
            sprite:SetFrame("Clock", 0)
            sprite:PlayOverlay("Idle", true)
            sprite:SetOverlayRenderPriority(true)

            data.HeldDown = false
            data.Animation = false
            data.State = -1
            data.Clicked = false

            entity.SortingLayer = SortingLayer.SORTING_BACKGROUND

            sprite.PlaybackSpeed = 0.5
        end

        if entity.Position:Distance(player.Position) < 40 and not flags.endRoomOpen then
            if not data.HeldDown then
                data.HeldDown = true

                local numbers = mod:Shuffle({1,2,3,4,5,6,7,8})
                for i=1, 4 do
                    mod.ClockPassword[i] = numbers[i]
                end
                table.sort(mod.ClockPassword)

                data.Password = {mod.ClockPassword[1], mod.ClockPassword[2], mod.ClockPassword[3], mod.ClockPassword[4]}
                data.State = data.Password[1]

                sprite:Play("Clock", true)
            end

        else
            data.HeldDown = false
        end

        if sprite:IsPlaying("Clock") then
            local state = data.State
            local targetAngle = 360/8 * (state%8)
            local targetFrame = math.floor(targetAngle * 74 / 360)

            if sprite:GetFrame()%73 == targetFrame then
                sfx:Play(mod.SFX.ClockTick, 2)

                local currentIdx = -1
                for index, n in ipairs(data.Password) do
                    if n == data.State then
                        currentIdx = index
                        break
                    end
                end
                if currentIdx < 4 then
                    data.State = data.Password[currentIdx+1]
                end

            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SaturnClockUpdate, mod.EntityCircleData.VAR)

--MINECART
function mod:MinecartUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+9 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local room = game:GetRoom()
        local player = Isaac.GetPlayer(0)

        if not data.Init then
            data.Init = true

            data.Direction = "Horizontal"
            if sprite:GetAnimation() == "IdleVertical" then
                data.Direction = "Vertical"
            end

            data.Inactive = data.Inactive or 0
        end

        local direction = player.Position - entity.Position
        local distance = direction:Length()

        if data.Inactive <= 0 and distance < 15 then
            player.Visible = false
            mod:scheduleForUpdate(function()
                player.Visible = true
            end, 30*10)
            player.ControlsCooldown = 30*10

            local animation = "Player"..data.Direction
            if sprite:GetAnimation() ~= animation then
                sprite:Play(animation, true)

                sfx:Play(mod.SFX.TrainBells, 0.75)
                mod:scheduleForUpdate(function()
                    mod:LureErrant(game:GetLevel():GetCurrentRoomIndex())
                end, 15)
            end
        end

        if sprite:IsFinished("PlayerVertical") then
            entity.Velocity = entity.Velocity + Vector(0, 0.25)

            if not room:IsPositionInRoom(entity.Position, 50) then
                game:StartRoomTransition(147, Direction.DOWN, RoomTransitionAnim.FADE)
                flags.FromMinecart = true
            end
        elseif sprite:IsFinished("PlayerHorizontal") then
            entity.Velocity = entity.Velocity + Vector(0.25, 0)

            if not room:IsPositionInRoom(entity.Position, 50) then
                game:StartRoomTransition(128, Direction.LEFT, RoomTransitionAnim.FADE)
                flags.FromMinecart = true
            end
        end

        if sprite:GetAnimation() == "PlayerHorizontal" or sprite:GetAnimation() == "PlayerVertical" then
            player.Visible = false
            player.Position = entity.Position
        end

        if distance > 50 then
            data.Inactive = data.Inactive - 1
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.MinecartUpdate, mod.EntityCircleData.VAR)

--BOMBS
function mod:AntiGoldBomb(bomb)
    if bomb.SubType == BombSubType.BOMB_GOLDEN then
        if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_STICKYNICKEL) > 0 then
            local troll = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_GOLDENTROLL, 0, bomb.Position, Vector.Zero, nil)
            bomb:Remove()
        else
            bomb:Morph(bomb.Type, bomb.Variant, BombSubType.BOMB_NORMAL)
        end
    end
end
function mod:EverchangerBombUpdate(bomb)
    if bomb:GetSprite():GetFrame() == 50 then
        
        local level = game:GetLevel()
        local roomdesc = level:GetCurrentRoomDesc()
        local roomid = roomdesc.Data.Variant

        local c1 = (roomid == 8515) and #Isaac.FindByType(mod.furnitureData.TREE.ID, mod.furnitureData.TREE.VAR, mod.furnitureData.TREE.SUB) > 0
        local c2 = (roomid == 8542) and #Isaac.FindByType(mod.furnitureData.TANK.ID, mod.furnitureData.TANK.VAR, mod.furnitureData.TANK.SUB) > 0
        if not (c1 or c2) then

            bomb:Die()
            local newBomb = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 1, bomb.Position, Vector.Zero, nil)
        end
    end
end

--MINI HUD
function mod:MinihudUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+10 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)

        if not data.Init then
            entity.DepthOffset = 5000
            entity:FollowParent(player)
            
            local hp = player:GetHearts()

            if data.Full then
                sprite:SetFrame("Full", hp)

                local itemConfig = Isaac:GetItemConfig()
                for i=0,1 do
                    local t = player:GetTrinket(i)
                    local config = itemConfig:GetTrinket(t)
                    local path = config and config.GfxFileName or ""
                    sprite:ReplaceSpritesheet(3+i, path)
                end

                data.coinT = Font()
                data.coinT:Load("font/droid.fnt")
                data.bombT = Font()
                data.bombT:Load("font/droid.fnt")
                data.keyT = Font()
                data.keyT:Load("font/droid.fnt")
            else
                sprite:SetFrame("Hearts", hp)
            end
            sprite:LoadGraphics()

            for _, hud in ipairs(Isaac.FindByType(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+10)) do
                if GetPtrHash(entity) ~= GetPtrHash(hud) then
                    hud:Remove()
                end
            end
            data.Init = true
        end

        if entity.FrameCount > 30 then
            sprite.Color = Color(1,1,1, 1 - (entity.FrameCount-30)/30)
            if entity.FrameCount > 60 then
                entity:Remove()
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.MinihudUpdate, mod.EntityCircleData.VAR)

function mod:MiniHudRenred(entity)
    local data = entity:GetData()
    if entity.SubType == mod.EntityCircleData.SUB+10 and data.Full and data.Init then
        local sprite = entity:GetSprite()
        local player = Isaac.GetPlayer(0)

        local cf = data.coinT
        local bf = data.bombT
        local kf = data.keyT

        local nc = tostring(math.floor(player:GetNumCoins()/10))..tostring(player:GetNumCoins()%10)
        local bc = tostring(math.floor(player:GetNumBombs()/10))..tostring(player:GetNumBombs()%10)
        local kc = tostring(math.floor(player:GetNumKeys()/10))..tostring(player:GetNumKeys()%10)

        local kColor = KColor(1,1,1,sprite.Color.A)
        
        local ogPos = Isaac.WorldToScreen(entity.Position + Vector(-45, 15))
        cf:DrawStringScaled(nc, ogPos.X, ogPos.Y, 0.5, 0.5, kColor,0,true) 
        ogPos = Isaac.WorldToScreen(entity.Position + Vector(-45, 15) + Vector(0,17))
        bf:DrawStringScaled(bc, ogPos.X, ogPos.Y, 0.5, 0.5, kColor,0,true) 
        ogPos = Isaac.WorldToScreen(entity.Position + Vector(-45, 15) + Vector(0,34))
        kf:DrawStringScaled(kc, ogPos.X, ogPos.Y, 0.5, 0.5, kColor,0,true) 
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.MiniHudRenred, mod.EntityCircleData.VAR)

--EFFIGY CORPSE
function mod:EffigyCorpseUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+11 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if sprite:IsPlaying("Idle7") and entity.FrameCount % 2 == 0 then
            local bubble = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, entity.Position + Vector(0,-15), Vector(0,-10):Rotated(mod:RandomInt(-15,15)), nil):ToEffect()
            bubble.DepthOffset = 500
            local bubbleSprite = bubble:GetSprite()
            bubbleSprite.Scale = Vector.One*(rng:RandomFloat()*0.3 + 0.1)
            bubbleSprite.PlaybackSpeed = 0.5
            bubbleSprite.Color = Color(0,0,0,1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.EffigyCorpseUpdate, mod.EntityCircleData.VAR)

--EFFIGY CORPSE
function mod:SolLightUpdate(entity)
    if entity.SubType == mod.EntityCircleData.SUB+12 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if not data.Init then
            data.Init = true

            entity.DepthOffset = 9999
            data.GrowScalar = 1.01

            entity.SpriteScale = Vector.One * 0.25
        end

        entity.SpriteScale = entity.SpriteScale * data.GrowScalar

        if not data.PlanetFlag and entity.SpriteScale.X >= 1 then
            data.PlanetFlag = true

            data.GrowScalar = 1.085

            for i, effigy in ipairs(Isaac.FindByType(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+11)) do
                effigy:GetSprite():Play(effigy:GetSprite():GetAnimation().."Summon", true)
                effigy:GetSprite().PlaybackSpeed = 0.67
            end
        end

        if not data.EndFlag and entity.SpriteScale.X >= 2 then
            data.EndFlag = true

            sfx:Play(mod.SFX.Supernova, 5)
            local ever = mod:FindByTypeMod(mod.Entity.Everchanger)[1]
            if ever then ever:Remove() end
        end

        if entity.SpriteScale.X >= 5 and not data.Ended then
            data.Ended = true
            
            local player = Isaac.GetPlayer(0)
    
            player:AddControlsCooldown(60)
            player.Velocity = Vector.Zero

            for t=1, 360, 10 do
                local position = player.Position + Vector(40, 0):Rotated(t)
                local trophy = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY, 0, position, Vector.Zero, nil)
                trophy.Visible=false
            end
        end


    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolLightUpdate, mod.EntityCircleData.VAR)

--PICKUPS
function mod:EverchangerPickupInit(entity)
    entity:GetSprite():Play("Appear", true)
end