local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

local base_chance = 0.5

function mod:IRoomsRoll()
	if mod:SomebodyHasTrinket(mod.Trinkets.i) then
        local level = game:GetLevel()
        local chance = 1 - (1-base_chance)^mod:HowManyTrinkets(mod.Trinkets.i)

        for index = 0, 13*13-1 do
            local roomdesc = game:GetLevel():GetRoomByIdx(index)
            local roomdata = roomdesc.Data
            if roomdata and rng:RandomFloat() < chance and index ~= level:GetCurrentRoomIndex() then
                if mod:ValidHyperRollRoom(roomdata.Type) then
                    mod:RerrollRoom(roomdesc)
                    --mod:UpdateRoomDisplayFlags(roomdesc)
                end
            end
        end

        local room = game:GetRoom()
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door and door.TargetRoomType ~= RoomType.ROOM_SECRET and door.TargetRoomIndex > 0 then
                door:SetRoomTypes(RoomType.ROOM_DEFAULT, RoomType.ROOM_DEFAULT)
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