local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()


function mod:IRoomsRoll()
	if mod:SomebodyHasTrinket(mod.Trinkets.i) then
        local level = game:GetLevel()

        for index = 0, 13*13-1 do
            local roomdesc = game:GetLevel():GetRoomByIdx(index)
            local roomdata = roomdesc.Data
            if roomdata and rng:RandomFloat() < 0.5 and index ~= level:GetCurrentRoomIndex() then
                if mod:ValidHyperRollRoom(roomdata.Type) then
                    mod:RerrollRoom(roomdesc)
                    --mod:UpdateRoomDisplayFlags(roomdesc)
                end
            end
        end

        local room = game:GetRoom()
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door and door.TargetRoomType ~= RoomType.ROOM_SECRET then
                mod:HyperUpdateDoor(door, door.TargetRoomType)
            end
        end

        if MinimapAPI then
            MinimapAPI:ClearLevels()
            MinimapAPI:LoadDefaultMap()
        end
        level:UpdateVisibility()
    end
end