local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

table.insert(mod.PostLoadInits, {"savedatarun", "VoidKeyQueue", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.VoidKeyQueue", 0)

function mod:VoidKeyUpdate()
    if mod.savedatarun().VoidKeyQueue > 0 then
        local room = game:GetRoom()
        --Door(s)
        for slot = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(slot)
            if door then
                local sprite = door:GetSprite()
                local sprite2 = door.ExtraSprite
                if ((sprite:GetAnimation() == "KeyOpen" or sprite:GetAnimation() == "GoldenKeyOpen" or sprite:GetAnimation() == "CoinOpen") and sprite:GetFrame() == 0) or 
                ((sprite2:GetAnimation() == "KeyOpenChain1" or sprite2:GetAnimation() == "KeyOpenChain2" or sprite2:GetAnimation() == "GoldenKeyOpenChain1" or sprite2:GetAnimation() == "GoldenKeyOpenChain2") and sprite2:GetFrame() == 0) then
                    mod:UseVoidKey(slot)

                    if sprite:GetAnimation() == "KeyOpen" or sprite:GetAnimation() == "GoldenKeyOpen" or sprite:GetAnimation() == "CoinOpen" then
                        sprite:ReplaceSpritesheet(4, "hc/gfx/grid/void_key.png")
                        sprite:LoadGraphics()
                    else
                        sprite2:ReplaceSpritesheet(0, "hc/gfx/grid/void_key.png")
                        sprite2:LoadGraphics()
                    end
                end

                if not door:IsOpen() then
                    local void_key_count_index = "voidKeyCount"..tostring(slot)
                    for _, player in ipairs(PlayerManager.GetPlayers()) do
                        local data = player:GetData()
                        if player.Position:Distance(door.Position) < 32 then
                            
                            if not data[void_key_count_index] then
                                data[void_key_count_index] = 0

                                local count = mod:SpawnEntity(mod.Entity.ICUP, player.Position + Vector(0,-40), Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.ICUP].SUB+6)
                                count.DepthOffset = 100
                            end

                            data[void_key_count_index] = data[void_key_count_index] + 1

                            if data[void_key_count_index] >= 60 then
                                local flag = false
                                for __, c in ipairs(mod:FindByTypeMod(mod.Entity.ICUP, nil, mod.EntityInf[mod.Entity.ICUP].SUB+6)) do
                                    flag = flag or c:GetSprite():GetFrame() >= 60
                                    if flag then break end
                                end
                                if flag then
                                    mod:UseVoidKey(slot)
                                    data[void_key_count_index] = nil
                                end
                            end
                            
                        elseif data[void_key_count_index] then
                            for __, c in ipairs(mod:FindByTypeMod(mod.Entity.ICUP, nil, mod.EntityInf[mod.Entity.ICUP].SUB+6)) do
                                c:Remove()
                            end
                            data[void_key_count_index] = nil
                        end
                    end
                end
            end
        end

    else
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.VoidKeyUpdate)
    end
end

function mod:OnVoidKeyUpdate(key)

    if key.SubType == mod.EntityVoidSub then
        local sprite = key:GetSprite()

        if sprite:IsEventTriggered("DropSound") then

        elseif sprite:IsPlaying("Collect") then
            key.Velocity = Vector.Zero

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidKeyUpdate, PickupVariant.PICKUP_KEY)

function mod:OnVoidKeyCollide(pickup, player)

    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.Velocity = Vector.Zero
    pickup.TargetPosition = pickup.Position

    player:AddKeys(1)
    mod:AddVoidKey(player)

    local sprite = pickup:GetSprite()
    sprite:Play("Collect", true)

    sfx:Play(mod.SFX.VoidPickup)
    sfx:Stop(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)

    mod:CheckRenderVoidPickups()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            mod:OnVoidKeyCollide(pickup, collider:ToPlayer())
        end

        return false
    end
end, PickupVariant.PICKUP_KEY)

function mod:AddVoidKey(player)
    mod.savedatarun().VoidKeyQueue = mod.savedatarun().VoidKeyQueue or 0
    mod.savedatarun().VoidKeyQueue = mod.savedatarun().VoidKeyQueue + 1
end

function mod:UseVoidKey(slot)
    mod.savedatarun().VoidKeyQueue = mod.savedatarun().VoidKeyQueue or 0
    mod.savedatarun().VoidKeyQueue = mod.savedatarun().VoidKeyQueue - 1

    Isaac.GetPlayer(0):UseCard(Card.CARD_SOUL_CAIN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

    local level = game:GetLevel()
    local room = game:GetRoom()
    local roomidx = level:GetCurrentRoomIndex()--room:GetDoor(slot).TargetRoomIndex
    local n = mod:CreateVoidRoom(roomidx, slot, Vector(-1, 0):Rotated(slot*90), level)

    local position = room:GetDoorSlotPosition(slot)
    game:MakeShockwave(position, 0.175, 0.025, 60)

    n = n or 1
    for i=0, n do
        local v = (n-i)/n
        local p = 1 + (1-v)
        mod:scheduleForUpdate(function()
            sfx:Play(SoundEffect.SOUND_DOGMA_JACOBS_ZAP, v, 2, false, p)
            game:ShakeScreen(10)
        end, i*15)
    end
    sfx:Stop(SoundEffect.SOUND_GOLDENKEY)

end

function mod:CreateVoidRoom(roomidx, slot, direction, level)

    roomidx = math.floor(roomidx)
    local newroomdesc = level:MakeRedRoomDoor(roomidx, slot)

    local coords = Vector(roomidx%13, roomidx//13)
    local newCoords = coords + direction
    local newroomidx = newCoords.X + 13*newCoords.Y

    if level:GetRoomByIdx(newroomidx).Data then
        if 0 <= newCoords.X and newCoords.X <= 13-1 and 0 <= newCoords.Y and newCoords.Y <= 13-1 then
            return 1 + mod:CreateVoidRoom(newroomidx, slot, direction, level)
        end
    end
    return 1
end


function mod:OnVoidKeySpawn(pickup, variant, subType)
    
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidKeySpawn, {"void_pickups_A (HC)", mod.voidConsts.KEY_CHANCE, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidKeySpawn, {"void_pickups_A (HC)", mod.voidConsts.KEY_CHANCE, PickupVariant.PICKUP_KEY, KeySubType.KEY_DOUBLEPACK, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidKeySpawn, {"void_pickups_A (HC)", mod.voidConsts.KEY_CHANCE, PickupVariant.PICKUP_KEY, KeySubType.KEY_CHARGED, mod.EntityVoidSub})
