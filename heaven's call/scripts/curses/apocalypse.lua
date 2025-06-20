local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()
local seeds = game:GetSeeds()

mod.ModFlags.IsApocalypseActive = false

mod.ModFlags.FirstApocalypse = false
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "ModFlags.FirstApocalypse", false)

function mod:OnApocalypseStart(forced, skip)
    if game:GetLevel():GetStage() > LevelStage.STAGE1_2 or forced then
        --Curses
        mod:AddApocalypseCurses()
        mod:SetHarmbinger()

        mod.ShaderData.apocalypseStartFrame = Isaac.GetFrameCount()
        mod.ShaderData.isApocalypseActive = true

        if (not mod.ModFlags.FirstApocalypse) and (not skip) then
            mod.ModFlags.FirstApocalypse = true
            Isaac.PlayCutscene(Isaac.GetCutsceneIdByName("Eclipse"))
        end

        mod:scheduleForUpdate(function()
            music:UpdateVolume()
            music:PitchSlide(0.5)
            
            mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnApocalypseUpdate)
            mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnApocalypseRender)

            mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnApocalypseUpdate)
            mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnApocalypseRender)
        end, 1)
    end
end

function mod:OnApocalypseEnd()
    mod.savedatapersistent().doomsdayState = mod.DState.DISABLED
    mod.savedatapersistent().doomsdayTimer = mod.DState.TO_BE_ACTIVATED
    
    --Isaac.GetPlayer(0):UseCard(Card.RUNE_DAGAZ, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
    Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE, 0, false)
    Isaac.GetPlayer(0):RemoveCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)

    music:ResetPitch()

    --seeds:ClearSeedEffects()
end

local initializadFlag = false

function mod:OnApocalypseNewRoomInit()
    if mod:IsApocalypseActive() then
        mod.ModFlags.IsApocalypseActive = true
        mod.ShaderData.isApocalypseActive = true

        if not initializadFlag then
            initializadFlag = true

            mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnApocalypseUpdate)
            mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnApocalypseUpdate)
            mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnApocalypseRender)
            mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnApocalypseRender)
        end

    else
        mod.ModFlags.IsApocalypseActive = false
        mod.ShaderData.isApocalypseActive = false

    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnApocalypseNewRoomInit)

function mod:OnApocalypseUpdate()
    if mod.ModFlags.IsApocalypseActive then

        local room = game:GetRoom()
        local level = game:GetLevel()

        mod:TryToSpawnRandomMeteor(room, level)
    end
end

function mod:OnApocalypseRender()
    if mod.ModFlags.IsApocalypseActive then
        music:PitchSlide(0.5)
    end
end

function mod:AddApocalypseCurses()
    local level = game:GetLevel()

    local candleFlag = false
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
            local n = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
            for i=1, n do
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
                candleFlag = true
            end
		end
	end

    
    --add curses
    mod:scheduleForUpdate(function()
        local hud = game:GetHUD()

        local n = 3 - mod:CountCurses()
        for i=1, n do
            local newCurse = mod:GetRandomCurse()
            if newCurse then
                level:AddCurse(newCurse, false)
            end
        end
        level:AddCurse(mod.Curse.APOCALYPSE, false)
        hud:ShowItemText("The world is ending!","")
        
        mod.ShaderData.apocalypseStartFrame = Isaac.GetFrameCount()

        if candleFlag then
            mod:scheduleForUpdate(function()
                hud:ShowItemText("The black candle has extinguished","")
            end, 30)
        end
    end, 1)
end

function mod:TryToSpawnRandomMeteor(room, level)
    if rng:RandomFloat() < 0.01 and not mod:IsRoomDescDoomsday(level:GetCurrentRoomDesc()) then
        local position = room:GetRandomPosition(0)
        
        local meteor = mod:SpawnEntity(mod.Entity.TerraTarget, position, Vector.Zero, nil):ToEffect()
        meteor:GetSprite().Color = Color.Default
        meteor:SetTimeout(mod.TConst.METEOR_TIMEOUT)
    end
end

function mod:SetHarmbinger()
    --[[
    local player = Isaac.GetPlayer(0)
    local sHealth = player:GetSoulHearts()
    player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS, false, false, true, false)
    local newSHealth = player:GetSoulHearts()
    local gainedHealth = newSHealth - sHealth
    if gainedHealth > 0 then
        player:AddSoulHearts(-gainedHealth)
    end
    ]]
    game:GetLevel():ForceHorsemanBoss(game:GetLevel():GetDungeonPlacementSeed())
end

function mod:OnApocalypseNewLevel(isContinued)
    if game.Challenge > 0 then return end
    if mod.savedatapersistent().doomsdayState and mod.savedatapersistent().doomsdayState == mod.DState.APOCALYPSE then
        if game:GetLevel():GetStage() > LevelStage.STAGE1_2 then
            mod:OnApocalypseStart()
        else
            mod:OnApocalypseEnd()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnApocalypseNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnApocalypseNewLevel)

function mod:OnApocalypseNewRoom()
    if mod.ModFlags.IsApocalypseActive then
        local room = game:GetRoom()
        local level = game:GetLevel()
        local currentroomdesc = level:GetCurrentRoomDesc()

        for slot = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(slot)
            if door then
                local dsprite = door:GetSprite()
                local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
                if targetroomdesc.Data then
                    if targetroomdesc.VisitedCount == 0 then
                        if targetroomdesc.Data.Type == RoomType.ROOM_SHOP then
                            targetroomdesc.SurpriseMiniboss = true
                        elseif targetroomdesc.Data.Type == RoomType.ROOM_SECRET then
                            targetroomdesc.SurpriseMiniboss = true
                        elseif targetroomdesc.Data.Type == RoomType.ROOM_SUPERSECRET then
                            local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SUPERSECRET, 8500, 20)
                            targetroomdesc.Data = newroomdata
                        elseif targetroomdesc.Data.Type == RoomType.ROOM_DEVIL then
                            targetroomdesc.SurpriseMiniboss = true
                        
                        end
                    else
                        --...
                    end

                    if targetroomdesc.Data.Type == RoomType.ROOM_SECRET then
                        --dsprite:Play("Hidden", true)
                        --door:Close(true)
                        --door:SetLocked(true)
                    elseif targetroomdesc.Data.Type == RoomType.ROOM_SUPERSECRET then
                        --dsprite:Play("Hidden", true)
                        --door:Close(true)
                        --door:SetLocked(true)
                    
                    end
                end
            end
        end

        if currentroomdesc.Data and currentroomdesc.VisitedCount == 1 then
            if currentroomdesc.Data.Type == RoomType.ROOM_CURSE then
                local newCurse = mod:GetRandomCurse()
                if newCurse then
                    level:AddCurse(newCurse, true)
                end

            elseif currentroomdesc.Data.Type == RoomType.ROOM_PLANETARIUM then
                mod:ChangeRoomBackdrop(mod.Backdrops.APOCALYPSEPLANETARIUM)

            elseif currentroomdesc.Data.Type == RoomType.ROOM_TREASURE then
                mod:EvilTreasure()

            end
            
            --musics
            if currentroomdesc.Data.Type == RoomType.ROOM_SHOP or currentroomdesc.Data.Type == RoomType.ROOM_SECRET then
                --mod:PlayRoomMusic(Music.MUSIC_BOSS)
            elseif currentroomdesc.Data.Type == RoomType.ROOM_SUPERSECRET then
                mod:PlayRoomMusic(mod.Music.ERRANT)
            elseif currentroomdesc.Data.Type == RoomType.ROOM_DEVIL then
                --mod:PlayRoomMusic(Music.MUSIC_BOSS)
            end

            mod:scheduleForUpdate(function()
                mod:SetApocalypseGrids()
            end, 1, ModCallbacks.MC_POST_RENDER)
        end

        mod:DupeEnemies()
        mod:ChampifyEnemies()

        if room:IsFirstVisit() then
            mod:DowngradeItems()
        end
    end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnApocalypseNewRoom)

function mod:SetApocalypseGrids()
    local room = game:GetRoom()
    local gridSize = room:GetGridSize()

    for index = 1, gridSize do
        local grid = room:GetGridEntity(index)
        if grid then
            if grid.State ~= 1000 and (grid:GetType() == GridEntityType.GRID_POOP) then
                grid:SetVariant(1)
                room:RemoveGridEntity(index, 0, true)
                mod:scheduleForUpdate(function()
                    room:SpawnGridEntity(index, GridEntityType.GRID_POOP, 1, grid:GetRNG():GetSeed(), 0)
                end,2)

            elseif grid.State ~= 2 and (grid:GetType() == GridEntityType.GRID_ROCK) and rng:RandomFloat() < 0.4 then
                grid:SetType(GridEntityType.GRID_ROCK_SPIKED)
                --room:RemoveGridEntity(index, 0, true)
                grid:Destroy(true)
                room:SpawnGridEntity(index, GridEntityType.GRID_ROCK_SPIKED, 1, grid:GetRNG():GetSeed(), 0)
                sfx:Stop(SoundEffect.SOUND_ROCK_CRUMBLE)

            elseif grid.State ~= 2 and (grid:GetType() == GridEntityType.GRID_ROCK_GOLD or grid:GetType() == GridEntityType.GRID_ROCKT or grid:GetType() == GridEntityType.GRID_ROCK_SS) then
                grid:SetType(GridEntityType.GRID_ROCK_BOMB)
                room:RemoveGridEntity(index, 0, true)
                mod:scheduleForUpdate(function()
                    room:SpawnGridEntity(index, GridEntityType.GRID_ROCK_BOMB, 1, grid:GetRNG():GetSeed(), 0)
                end,2)

            elseif grid.State ~= 2 and (grid:GetType() == GridEntityType.GRID_ROCKB) and grid:GetSprite():GetFilename() == "gfx/grid/grid_rock.anm2" then
                grid:SetType(GridEntityType.GRID_PILLAR)
                room:RemoveGridEntity(index, 0, true)
                mod:scheduleForUpdate(function()
                    room:SpawnGridEntity(index, GridEntityType.GRID_PILLAR, 1, grid:GetRNG():GetSeed(), 0)
                end,2)

                
            elseif (grid:GetType() == GridEntityType.GRID_STATUE) then
                grid:Destroy()

            end
        end
    end
end

function mod:DowngradeItems()
    local itemconfig = Isaac:GetItemConfig()

    for i, _collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        local collectible = _collectible:ToPickup()
        if collectible and itemconfig:GetCollectible(collectible.SubType).Quality >= 3 and rng:RandomFloat() < 0.5 then
            collectible:Morph(collectible.Type, collectible.Variant, -1)
        end
    end
end

function mod:DupeEnemies()
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
			
        if rng:RandomFloat() < 0.1 and mod:IsHostileEnemy(entity) and not entity:ToNPC():IsBoss() then
            local dupe = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, entity.Velocity, nil)
        end
    end
end

function mod:ChampifyEnemies()

    --seeds:AddSeedEffect(SeedEffect.SEED_ALL_CHAMPIONS)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
			
        if entity:ToNPC() and mod:IsHostileEnemy(entity) and not entity:ToNPC():IsBoss() then
            local enemy = entity:ToNPC()
            if enemy and enemy.InitSeed then
                enemy:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
                enemy:MakeChampion(enemy.InitSeed, -1, false)
            end

        elseif entity.Type == EntityType.ENTITY_FIREPLACE then
            if entity.Variant == 0 then
                local newFire = Isaac.Spawn(entity.Type, 1, 0, entity.Position, entity.Velocity, nil)
                entity:Remove()

            elseif entity.Variant == 2 then
                local newFire = Isaac.Spawn(entity.Type, 3, 0, entity.Position, entity.Velocity, nil)
                entity:Remove()

            end
        end
    end
end

function mod:MakeKrampusRoom()
    if mod.ModFlags.IsApocalypseActive then
        local room = game:GetRoom()
        local level = game:GetLevel()

        for slot = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(slot)
            if door then
                local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
                if targetroomdesc.VisitedCount == 0 then
                    if targetroomdesc.Data.Type == RoomType.ROOM_DEVIL then
                        targetroomdesc.SurpriseMiniboss = true
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.MakeKrampusRoom)

function mod:ChangeKrampusReward(entity)
    if mod.ModFlags.IsApocalypseActive and entity.Variant == 1 then
        mod:scheduleForUpdate(function()
            for _, _collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                local collectible = _collectible:ToPickup()

                if collectible and collectible.SubType == CollectibleType.COLLECTIBLE_LUMP_OF_COAL or collectible.SubType == CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS then
                    local newItem = game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL)
                    collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem)
                end
            end
        end, 2)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ChangeKrampusReward, EntityType.ENTITY_FALLEN)

function mod:EvilTreasure()
    local bulbs = Isaac.FindByType(EntityType.ENTITY_SUCKER, 5)
    local room = game:GetRoom()
    for i=1, 2-#bulbs do
        local position = rng:RandomFloat()<0.5 and room:GetBottomRightPos() or room:GetTopLeftPos()
        local bulb = Isaac.Spawn(EntityType.ENTITY_SUCKER, 5, 0, position, Vector.Zero, nil)
    end
end

function mod:ApocallypseCollectible(collectible)
    if mod.ModFlags.IsApocalypseActive then
        local itemconfig = Isaac:GetItemConfig()

        if collectible.SubType == CollectibleType.COLLECTIBLE_BLACK_CANDLE then
            collectible:Morph(collectible.Type, collectible.Variant, -1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ApocallypseCollectible, PickupVariant.PICKUP_COLLECTIBLE)


function mod:IsApocalypseActive()
    return mod:IsApocalypseActive2() and (game:GetLevel():GetCurses() & mod.Curse.APOCALYPSE > 0)
end
function mod:IsApocalypseActive2()
    return (mod.savedatapersistent().doomsdayState and mod.savedatapersistent().doomsdayState == mod.DState.APOCALYPSE) or game.Challenge == mod.Challenges.Doomsday
end

function mod:ApocalypseDischarge(Type, Charge, FirstTime, Slot, VarData, Player)
    if mod.ModFlags.IsApocalypseActive then
        return {Type, 0, FirstTime, Slot, VarData}
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.ApocalypseDischarge)


function mod:ApolaypsePickupInit(pickup)
    if mod.ModFlags.IsApocalypseActive then

        if pickup.Variant == PickupVariant.PICKUP_HEART and (pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_DOUBLEPACK or pickup.SubType == HeartSubType.HEART_BLENDED) then
            pickup:Morph(pickup.Type, pickup.Variant, HeartSubType.HEART_SCARED)
        elseif pickup.Variant == PickupVariant.PICKUP_COIN and not (pickup.SubType == CoinSubType.COIN_PENNY) then
            pickup:Morph(pickup.Type, pickup.Variant, CoinSubType.COIN_PENNY)
        elseif pickup.Variant == PickupVariant.PICKUP_KEY and not (pickup.SubType == KeySubType.KEY_NORMAL) then
            pickup:Morph(pickup.Type, pickup.Variant, KeySubType.KEY_NORMAL)
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB and not (pickup.SubType == BombSubType.BOMB_NORMAL or pickup.SubType == BombSubType.BOMB_TROLL) then
            pickup:Morph(pickup.Type, pickup.Variant, BombSubType.BOMB_NORMAL)
        elseif pickup.Variant == PickupVariant.PICKUP_POOP and not (pickup.SubType == 0) then
            pickup:Morph(pickup.Type, pickup.Variant, 0)
        elseif pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY and not (pickup.SubType == BatterySubType.BATTERY_MICRO) then
            pickup:Morph(pickup.Type, pickup.Variant, BatterySubType.BATTERY_MICRO)
        elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
            local trinket = pickup.SubType
            if trinket > TrinketType.TRINKET_GOLDEN_FLAG then
                pickup:Morph(pickup.Type, pickup.Variant, trinket-TrinketType.TRINKET_GOLDEN_FLAG)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ApolaypsePickupInit)