--This was taken from Tainted Treasure mod.
--This creates a Dice room Red room and changes its properties, really cool
--If I just added a Planetarium room the game counted it as an actual planetarium, and resets its chances to 1%
--so I had to stick with the dice

local mod = HeavensCall
local rng = RNG()
local game = Game()

function mod:IsDeadEnd(roomidx, shape)
	local level = game:GetLevel()
	shape = shape or RoomShape.ROOMSHAPE_1x1
	local deadend = false
	local adjindex = mod.adjindexes[shape]
	local adjrooms = 0
	for i, entry in pairs(adjindex) do
		local oob = false
		for j, idx in pairs(mod.borderrooms[i]) do
			if idx == roomidx then
				oob = true
			end
		end
		if level:GetRoomByIdx(roomidx+entry).GridIndex ~= -1 and not oob then
			adjrooms = adjrooms+1
		end
	end
	if adjrooms == 1 then
		deadend = true
	end
	return deadend
end

function mod:GetDeadEnds(roomdesc)
	local level = game:GetLevel()
	local roomidx = roomdesc.SafeGridIndex
	local shape = roomdesc.Data.Shape
	local adjindex = mod.adjindexes[shape]
	local deadends = {}
	for i, entry in pairs(adjindex) do
		if level:GetRoomByIdx(roomidx).Data then
			local oob = false
			for j, idx in pairs(mod.borderrooms[i]) do
				for k, shapeidx in pairs(mod.shapeindexes[shape]) do
					if idx == roomidx+shapeidx then
						oob = true
					end
				end
			end
			if roomdesc.Data.Doors & (1 << i) > 0 and mod:IsDeadEnd(roomidx+adjindex[i]) and level:GetRoomByIdx(roomidx+adjindex[i]).GridIndex == -1 and not oob then
				table.insert(deadends, {Slot = i, GridIndex = roomidx+adjindex[i]})
			end
		end
	end
	
	if #deadends >= 1 then
		return deadends
	else
		return nil
	end
end

function mod:GetOppositeDoorSlot(slot)
	return mod.oppslots[slot]
end

--Search where the room is on the map and updates its display on the map
function mod:UpdateRoomDisplayFlags(initroomdesc)
	local level = game:GetLevel()
	local roomdesc = level:GetRoomByIdx(initroomdesc.GridIndex) --Only roomdescriptors from level:GetRoomByIdx() are mutable
	local roomdata = roomdesc.Data
	if level:GetRoomByIdx(roomdesc.GridIndex).DisplayFlags then
		if level:GetRoomByIdx(roomdesc.GridIndex) ~= level:GetCurrentRoomDesc().GridIndex then
			if roomdata then 
				if level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ICON
				elseif roomdata.Type ~= RoomType.ROOM_DEFAULT and roomdata.Type ~= RoomType.ROOM_SECRET and roomdata.Type ~= RoomType.ROOM_SUPERSECRET and roomdata.Type ~= RoomType.ROOM_ULTRASECRET and level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ICON
				elseif roomdata and level:GetStateFlag(LevelStateFlag.STATE_BLUE_MAP_EFFECT) and (roomdata.Type == RoomType.ROOM_SECRET or roomdata.Type == RoomType.ROOM_SUPERSECRET) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ICON
				elseif level:GetStateFlag(LevelStateFlag.STATE_MAP_EFFECT) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_BOX
				else
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_NONE
				end

			end
		end
	end
end

function mod:GenerateRoomFromDataset(dataset, onnewlevel)
	onnewlevel = onnewlevel or false
	local level = game:GetLevel()
	local floordeadends = {}
	local setcopy = dataset
	local currentroomidx = level:GetCurrentRoomIndex()
	
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and roomdesc.Data.Subtype ~= 34 and roomdesc.Data.Subtype ~= 10 then --Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
			local deadends = mod:GetDeadEnds(roomdesc)
			if deadends and not (onnewlevel and roomdesc.GridIndex == currentroomidx) then
				for j, deadend in pairs(deadends) do
					table.insert(floordeadends, {Slot = deadend.Slot, GridIndex = deadend.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
				end
			end
		end
	end
	
	if not floordeadends[1] then
		return false--Bad ending
	end

	mod:Shuffle(floordeadends)

	
	local level = game:GetLevel()
	local data = nil

	if (level:GetStage() == LevelStage.STAGE5 or ( (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) and ( level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B ))) then
		data = dataset[mod:RandomInt(mod.minvariant2,mod.maxvariant2)]
	else
		data = dataset[mod:RandomInt(mod.minvariant1,mod.maxvariant1)]
	end

	for i, entry in pairs(floordeadends) do
		local deadendslot = entry.Slot
		local deadendidx = entry.GridIndex
		local roomidx = entry.roomidx
		local visitcount = entry.visitcount
		local roomdesc = level:GetRoomByIdx(roomidx)
		if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) and data and data.Doors & (1 << mod:GetOppositeDoorSlot(deadendslot)) > 0 then
			if level:MakeRedRoomDoor(roomidx, deadendslot) then
				local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
				newroomdesc.Data = data
				newroomdesc.Flags = 0
				mod:UpdateRoomDisplayFlags(newroomdesc)
				level:UpdateVisibility()
				table.insert(mod.minimaprooms, newroomdesc.GridIndex)

				mod.ModFlags.ErrorRoom = false
				mod.ModFlags.ErrorRoomSource = -2
				mod.ModFlags.ErrorRoomSlot = -1
				if newroomdesc.GridIndex < 0 then
					mod.ModFlags.ErrorRoom = true
					mod.ModFlags.ErrorRoomSource = roomdesc.GridIndex
					mod.ModFlags.ErrorRoomSlot = deadendslot
					return false
				end
				return newroomdesc
			end
		end
	end

end

function mod:InitializeRoomData(roomtype, minvariant, maxvariant, dataset)
	local level = game:GetLevel()
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	local hascurseofmaze = false
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		mod.applyingcurseofmaze = true
	end
	
	for i = minvariant, maxvariant do
		Isaac.ExecuteCommand("goto s."..roomtype.."."..i)
		dataset[i] = level:GetRoomByIdx(-3,0).Data
	end
	game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
	
	if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
		level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount - 1
	end
	
	if hascurseofmaze then
		mod:scheduleForUpdate(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			mod.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end
end

mod.DiceRooms = {
	{TYPE = RoomType.ROOM_SHOP, NUM = 1},
	{TYPE = RoomType.ROOM_SHOP, NUM = 3},
	{TYPE = RoomType.ROOM_SHOP, NUM = 5},
	
	{TYPE = RoomType.ROOM_TREASURE, NUM = 2},
	{TYPE = RoomType.ROOM_TREASURE, NUM = 10},
	{TYPE = RoomType.ROOM_TREASURE, NUM = 20},
	
	{TYPE = RoomType.ROOM_SECRET, NUM = 0},
	{TYPE = RoomType.ROOM_SECRET, NUM = 3},
	{TYPE = RoomType.ROOM_SECRET, NUM = 12},
	
	{TYPE = RoomType.ROOM_ARCADE, NUM = 0},
	{TYPE = RoomType.ROOM_ARCADE, NUM = 10},
	{TYPE = RoomType.ROOM_ARCADE, NUM = 25},
	
	{TYPE = RoomType.ROOM_CURSE, NUM = 5},
	{TYPE = RoomType.ROOM_CURSE, NUM = 6},
	{TYPE = RoomType.ROOM_CURSE, NUM = 20},
	
	{TYPE = RoomType.ROOM_CHALLENGE, NUM = 5},
	{TYPE = RoomType.ROOM_CHALLENGE, NUM = 9},
	{TYPE = RoomType.ROOM_CHALLENGE, NUM = 11},
	
	{TYPE = RoomType.ROOM_LIBRARY, NUM = 2},
	{TYPE = RoomType.ROOM_LIBRARY, NUM = 4},
	{TYPE = RoomType.ROOM_LIBRARY, NUM = 12},
	
	{TYPE = RoomType.ROOM_SACRIFICE, NUM = 1},
	{TYPE = RoomType.ROOM_SACRIFICE, NUM = 6},
	{TYPE = RoomType.ROOM_SACRIFICE, NUM = 9},
	
	{TYPE = RoomType.ROOM_DEVIL, NUM = 2},
	{TYPE = RoomType.ROOM_DEVIL, NUM = 10},
	{TYPE = RoomType.ROOM_DEVIL, NUM = 17},
	
	{TYPE = RoomType.ROOM_ANGEL, NUM = 1},
	{TYPE = RoomType.ROOM_ANGEL, NUM = 15},
	{TYPE = RoomType.ROOM_ANGEL, NUM = 7},
	
	{TYPE = RoomType.ROOM_ISAACS, NUM = 0},
	{TYPE = RoomType.ROOM_ISAACS, NUM = 16},
	{TYPE = RoomType.ROOM_ISAACS, NUM = 10},
	
	{TYPE = RoomType.ROOM_CHEST, NUM = 6},
	{TYPE = RoomType.ROOM_CHEST, NUM = 12},
	{TYPE = RoomType.ROOM_CHEST, NUM = 24},
	
	{TYPE = RoomType.ROOM_DICE, NUM = 0},
	{TYPE = RoomType.ROOM_DICE, NUM = 1},
	{TYPE = RoomType.ROOM_DICE, NUM = 15},
	
	{TYPE = RoomType.ROOM_PLANETARIUM, NUM = 1},
	{TYPE = RoomType.ROOM_PLANETARIUM, NUM = 6},
	{TYPE = RoomType.ROOM_PLANETARIUM, NUM = 8},
	
	{TYPE = RoomType.ROOM_ULTRASECRET, NUM = 1},
	{TYPE = RoomType.ROOM_ULTRASECRET, NUM = 4},
	{TYPE = RoomType.ROOM_ULTRASECRET, NUM = 6},
	
	{TYPE = 41, NUM = 8500},
	{TYPE = 41, NUM = 8501},
	{TYPE = 41, NUM = 8502},
}
mod.nSpecialRooms = 17

if TaintedTreasure then
	table.insert(mod.DiceRooms, {TYPE = 42, NUM = 12000})
	table.insert(mod.DiceRooms, {TYPE = 42, NUM = 12003})
	table.insert(mod.DiceRooms, {TYPE = 42, NUM = 12046})
	mod.nSpecialRooms = mod.nSpecialRooms + 1
end

if ANDROMEDA then
	table.insert(mod.DiceRooms, {TYPE = 43, NUM = 4849})
	table.insert(mod.DiceRooms, {TYPE = 43, NUM = 4484})
	table.insert(mod.DiceRooms, {TYPE = 43, NUM = 4252})
	mod.nSpecialRooms = mod.nSpecialRooms + 1
end

mod.RoomType2String = {
	[RoomType.ROOM_SHOP] = "shop",
	[RoomType.ROOM_TREASURE] = "treasure",
	[RoomType.ROOM_MINIBOSS] = "miniboss",
	[RoomType.ROOM_SECRET] = "secret",
	[RoomType.ROOM_SUPERSECRET] = "supersecret",
	[RoomType.ROOM_ARCADE] = "arcade",
	[RoomType.ROOM_CURSE] = "curse",
	[RoomType.ROOM_CHALLENGE] = "challenge",
	[RoomType.ROOM_LIBRARY] = "library",
	[RoomType.ROOM_SACRIFICE] = "sacrifice",
	[RoomType.ROOM_DEVIL] = "devil",
	[RoomType.ROOM_ANGEL] = "angel",
	[RoomType.ROOM_ISAACS] = "isaacs",
	[RoomType.ROOM_CHEST] = "chest",
	[RoomType.ROOM_DICE] = "dice",
	[RoomType.ROOM_PLANETARIUM] = "planetarium",
	[RoomType.ROOM_ULTRASECRET] = "ultrasecret",
	[40] = "dice", --Astral Challenge
	[41] = "devil", --Lunar Pact
	[42] = "dice", --TTS
	[43] = "dice", --Andromeda
}

function mod:InitializeDiceRoomData(dataset)
	local level = game:GetLevel()
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	local hascurseofmaze = false
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		mod.applyingcurseofmaze = true
	end

	for key,value in pairs(mod.DiceRooms) do --actualcode
		local roomDic = mod.DiceRooms[key]
		Isaac.ExecuteCommand("goto s."..mod.RoomType2String[roomDic.TYPE].."."..tostring(roomDic.NUM))
		dataset[tostring(roomDic.TYPE).."."..tostring(roomDic.NUM)] = level:GetRoomByIdx(-3,0).Data
	end

	game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
	
	if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
		level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount - 1
	end
	
	if hascurseofmaze then
		mod:scheduleForUpdate(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			mod.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end
end