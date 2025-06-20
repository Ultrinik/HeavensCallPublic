local mod = HeavensCall
local game = Game()

mod.LunarCrownConts = {
    PACT_CHANCE = 0.666,
    REROLL_CHANCE = 0.333
}

--Evil Planetarium Devils Crown
function mod:OnEvilCrownPickup(player, trinket, firstTime)
	if not (mod.savedatasettings().UnlockAll or Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("retro_planet (HC)"))) then
		return
	end
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			if targetroomdesc.VisitedCount == 0 then
            	mod:EvilPlanetariumDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc, true)
			end
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.OnEvilCrownPickup, TrinketType.TRINKET_DEVILS_CROWN)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.OnEvilCrownPickup, mod.Trinkets.Crown)

function mod:OnEvilCrownDrop(player, trinket)
	if not (mod.savedatasettings().UnlockAll or Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("retro_planet (HC)"))) then
		return
	end
	if mod:SomebodyHasTrinket(trinket) then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			if targetroomdesc and targetroomdesc.Data and targetroomdesc.Data.Type == RoomType.ROOM_PLANETARIUM and targetroomdesc.VisitedCount == 0 then
            	mod:TransformDoor2Planetarium(door, room, true)
			end
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnEvilCrownDrop, TrinketType.TRINKET_DEVILS_CROWN)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.OnEvilCrownDrop, mod.Trinkets.Crown)