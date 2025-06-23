local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.ModFlags.currentUnvisitedRooms = 0
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "ModFlags.currentUnvisitedRooms", 0)

mod.ModFlags.goldenRoomsQueue = 0
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "ModFlags.goldenRoomsQueue", 0)

mod.ModFlags.goldenRoomsIdx = {}
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.goldenRoomsIdx", {})


function mod:GoldenTelescopeOnNewRoom()
    if mod:SomebodyHasItem(mod.SolarItems.Telescope) then
        local level = game:GetLevel()

        local currentroomidx = level:GetCurrentRoomIndex() 
        for _, idx in ipairs(mod.ModFlags.goldenRoomsIdx) do
            if currentroomidx == idx then
                game:GetRoom():TurnGold()
                break
            end
        end

        mod:scheduleForUpdate(function()
            --count all the unvisited valid rooms (-3 cuz secret rooms wont count)
            local unvisitedCount = 0
            for idx=0, 13*13-1 do
                local roomdesc = level:GetRoomByIdx(idx)
                if roomdesc.Data and roomdesc.VisitedCount == 0 then
                    unvisitedCount = unvisitedCount + 1
                end
            end
            mod.ModFlags.currentUnvisitedRooms = unvisitedCount-3

        end, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.GoldenTelescopeOnNewRoom)

function mod:GoldenTelescopeOnNewStage()
    if mod:SomebodyHasItem(mod.SolarItems.Telescope) then
        local level = game:GetLevel()

        if (level:GetStage() < LevelStage.STAGE8) and not (mod.savedatarun().solEnabled and level:GetStage() == LevelStage.STAGE4_3) and not game:IsGreedMode() then

            --on a new stage, the unvisited rooms are the unvisited room from the last stage + the rooms that didnt generate
            mod.ModFlags.currentUnvisitedRooms = mod.ModFlags.currentUnvisitedRooms + mod.ModFlags.goldenRoomsQueue
            local unvisitedCount = mod.ModFlags.currentUnvisitedRooms

            --we will try to generate them all
            for i=1, unvisitedCount do
                local roomdesc = mod:GenerateRoom(true)
                if roomdesc and roomdesc.Data then
                    table.insert(mod.ModFlags.goldenRoomsIdx, roomdesc.GridIndex)
                    mod.ModFlags.currentUnvisitedRooms = mod.ModFlags.currentUnvisitedRooms - 1

                    mod:FineTuneRoomData(roomdesc, 0.5 * mod:HowManyItems(mod.SolarItems.Telescope))
                end
            end

            --but there will probably be some leftovers
            mod.ModFlags.goldenRoomsQueue = math.max(0, mod.ModFlags.currentUnvisitedRooms)
        end
    end
end

function mod:GenerateGoldenRooms()
    mod:GoldenTelescopeOnNewStage()
end

function mod:GoldenTelescopeCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_LUCK and player:HasCollectible(mod.SolarItems.Telescope) then
        player.Luck = player.Luck + 2
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GoldenTelescopeCache)