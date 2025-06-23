local mod = HeavensCall
local game = Game()

function mod:FineTuneRoomData(roomdesc, mult)
    local n = math.ceil(120*mult)

    local stb = Isaac.GetCurrentStageConfigId()
    if stb == StbType.VOID then
        return
    end

    local roomdata = roomdesc.Data
    if roomdata and roomdata.Type ~= RoomType.ROOM_BOSS then
        local final_stb = stb
        local final_n = n
        if roomdata.Type ~= RoomType.ROOM_DEFAULT then
            final_stb = StbType.SPECIAL_ROOMS
            final_n = math.ceil(n*0.5)
        end

        local min_weight = 999
        local final_newroomdata
        for i=1, final_n do
            local newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,10000), false, final_stb, roomdata.Type, roomdata.Shape, 0, -1, 0, 19, roomdata.Doors, -1, -1)

            if newroomdata and newroomdata.Weight < min_weight then
                min_weight = newroomdata.Weight
                final_newroomdata = newroomdata
            end
        end
        if final_newroomdata then
            roomdesc.Data = final_newroomdata
        end
    end
end

function mod:SolRoomsRoll()
	if mod:SomebodyHasTrinket(mod.Trinkets.Sol) then
        local level = game:GetLevel()

        for index = 0, 13*13-1 do
            local roomdesc = game:GetLevel():GetRoomByIdx(index)
            if index ~= level:GetCurrentRoomIndex() then
                mod:FineTuneRoomData(roomdesc, mod:HowManyTrinkets(mod.Trinkets.Sol))
            end
        end
    end
end