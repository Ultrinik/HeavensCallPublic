--This was taken from Tainted Treasure mod.
--This creates a Dice room Red room and changes its properties, really cool
--If I just added a Planetarium room the game counted it as an actual planetarium, and resets its chances to 1%
--so I had to stick with the dice

local mod = HeavensCall
local rng = mod:GetRunRNG()
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

				if mod:IsStageRedStage() then
					roomdesc.Flags = RoomDescriptor.FLAG_RED_ROOM
				end
			end
		end
	end
end

function mod:GenerateRoomFromDataset(dataset, onnewlevel, tipo)
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

	if tipo == 1 then
		
	else
		data = mod:Shuffle(setcopy)[1]
	end

	for i, entry in pairs(floordeadends) do
		local deadendslot = entry.Slot
		local deadendidx = entry.GridIndex
		local roomidx = entry.roomidx
		local visitcount = entry.visitcount
		local roomdesc = level:GetRoomByIdx(roomidx)

		data = data or setcopy[deadendslot%4+1]

		if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) and data.Doors & (1 << mod:GetOppositeDoorSlot(deadendslot)) > 0 then
			if level:MakeRedRoomDoor(roomidx, deadendslot) then
				local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
				newroomdesc.Data = data
				newroomdesc.Flags = 0
				mod:UpdateRoomDisplayFlags(newroomdesc)
				level:UpdateVisibility()

				return newroomdesc
			end
		end
	end

end

function mod:GenerateRoomFromData(data, onnewlevel)
	onnewlevel = onnewlevel or false
	local level = game:GetLevel()
	local floordeadends = {}
	local currentroomidx = level:GetCurrentRoomIndex()
	
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and roomdesc.Data.Subtype ~= 34 and roomdesc.Data.Subtype ~= 10 then --Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
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

	for i, entry in pairs(floordeadends) do
		local deadendslot = entry.Slot
		local deadendidx = entry.GridIndex
		local roomidx = entry.roomidx
		local visitcount = entry.visitcount
		local roomdesc = level:GetRoomByIdx(roomidx)

		if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) and data.Doors & (1 << mod:GetOppositeDoorSlot(deadendslot)) > 0 then
			if level:MakeRedRoomDoor(roomidx, deadendslot) then
				local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
				newroomdesc.Data = data
				newroomdesc.Flags = 0
				mod:UpdateRoomDisplayFlags(newroomdesc)
				level:UpdateVisibility()

				return newroomdesc
			end
		end
	end

end

function mod:GenerateRoom(onnewlevel)
	onnewlevel = onnewlevel or false
	local level = game:GetLevel()
	local floordeadends = {}
	local currentroomidx = level:GetCurrentRoomIndex()
	
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and roomdesc.Data.Subtype ~= 34 and roomdesc.Data.Subtype ~= 10 then --Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
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

	for i, entry in pairs(floordeadends) do
		local deadendslot = entry.Slot
		local deadendidx = entry.GridIndex
		local roomidx = entry.roomidx
		local visitcount = entry.visitcount
		local roomdesc = level:GetRoomByIdx(roomidx)

		if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) then
			if level:MakeRedRoomDoor(roomidx, deadendslot) then
				local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
				newroomdesc.Flags = newroomdesc.Flags & (~RoomDescriptor.FLAG_RED_ROOM)
				mod:UpdateRoomDisplayFlags(newroomdesc)
				level:UpdateVisibility()

				if MinimapAPI then
					local gridIndex = newroomdesc.SafeGridIndex
					local position = mod:GridIndexToVector(gridIndex)
					
					local maproom = MinimapAPI:GetRoomAtPosition(position)
					if maproom then
						maproom.DisplayFlags = newroomdesc.Flags
						maproom.Color = Color(2,1,0,1)
					end
				end

				return newroomdesc
			end
		end
	end

end

--[[
function mod:Initialize RoomData(roomtype, minvariant, maxvariant, dataset)
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
]]--


------------------------------------------------------------------------------------------------------------------------------
--Get room data---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

function mod:ObtainRoomData(vanilla, roomType, doorFlags, varVector, varData)
	local newroomdata

	if vanilla then
		newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,9999), false, StbType.SPECIAL_ROOMS, roomType, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 19, doorFlags)
	else
		if roomType[2] == "Astral" then
			local tier = mod:GetAstralChallengeGenType()
			if tier == 'inner' then
				varVector = varVector or mod.RoomVariantVecs.Astral2
			else
				varVector = varVector or mod.RoomVariantVecs.Astral1
			end
		else
			varVector = varVector or mod.RoomVariantVecs[roomType[2]]
		end
		newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,9999), false, StbType.SPECIAL_ROOMS, roomType[1], RoomShape.ROOMSHAPE_1x1, varVector.X, varVector.Y, 0, 20, doorFlags)
	end
	return newroomdata
end

------------------------------------------------------------------------------------------------------------------------------
--Hyper dice rooms------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
mod.DiceRooms = {
	--1 SHOP
	{TYPE = RoomType.ROOM_SHOP, NUM = -1},
	
	--2 TREASURE
	{TYPE = RoomType.ROOM_TREASURE, NUM = -1},
	
	--3 SECRET
	{TYPE = RoomType.ROOM_SECRET, NUM = -1},
	
	--4 ARCADE
	{TYPE = RoomType.ROOM_ARCADE, NUM = -1},
	
	--5 CURSE
	{TYPE = RoomType.ROOM_CURSE, NUM = -1},
	
	--6 CHALLENGE
	{TYPE = RoomType.ROOM_CHALLENGE, NUM = -1},
	
	--7 LIBRARY
	{TYPE = RoomType.ROOM_LIBRARY, NUM = -1},
	
	--8 SACRIFICE
	{TYPE = RoomType.ROOM_SACRIFICE, NUM = -1},
	
	--9 DEVIL
	{TYPE = RoomType.ROOM_DEVIL, NUM = -1},
	
	--10 ANGEL
	{TYPE = RoomType.ROOM_ANGEL, NUM = -1},
	
	--11 BEDROOM
	{TYPE = RoomType.ROOM_ISAACS, NUM = -1},
	
	--12 CHEST
	{TYPE = RoomType.ROOM_CHEST, NUM = -1},
	
	--13 DICE
	{TYPE = RoomType.ROOM_DICE, NUM = -1},
	
	--14 PLANETARIUM
	{TYPE = RoomType.ROOM_PLANETARIUM, NUM = -1},
	
	--15 ULTRA SECRET
	{TYPE = RoomType.ROOM_ULTRASECRET, NUM = -1},
}
mod.nVanillaRooms = 15
mod.nSpecialRooms = mod.nVanillaRooms

mod.HyperModdedRooms = {}

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
}
mod.RoomType2Enum = {
	[RoomType.ROOM_SHOP] = RoomType.ROOM_SHOP,
	[RoomType.ROOM_TREASURE] = RoomType.ROOM_TREASURE,
	[RoomType.ROOM_MINIBOSS] = RoomType.ROOM_MINIBOSS,
	[RoomType.ROOM_SECRET] = RoomType.ROOM_SECRET,
	[RoomType.ROOM_SUPERSECRET] = RoomType.ROOM_SUPERSECRET,
	[RoomType.ROOM_ARCADE] = RoomType.ROOM_ARCADE,
	[RoomType.ROOM_CURSE] = RoomType.ROOM_CURSE,
	[RoomType.ROOM_CHALLENGE] = RoomType.ROOM_CHALLENGE,
	[RoomType.ROOM_LIBRARY] = RoomType.ROOM_LIBRARY,
	[RoomType.ROOM_SACRIFICE] = RoomType.ROOM_SACRIFICE,
	[RoomType.ROOM_DEVIL] = RoomType.ROOM_DEVIL,
	[RoomType.ROOM_ANGEL] = RoomType.ROOM_ANGEL,
	[RoomType.ROOM_ISAACS] = RoomType.ROOM_ISAACS,
	[RoomType.ROOM_CHEST] = RoomType.ROOM_CHEST,
	[RoomType.ROOM_DICE] = RoomType.ROOM_DICE,
	[RoomType.ROOM_PLANETARIUM] = RoomType.ROOM_PLANETARIUM,
	[RoomType.ROOM_ULTRASECRET] = RoomType.ROOM_ULTRASECRET,
}

mod.HyperroomsNames2Id = {}

mod.RoomdataFunctions = {}
mod.RoomRestrictionFunctions = {}
mod.RoomPostFunctions = {}
mod.RoomDoorUpdateFunctions = {}
mod.RoomIdentificationFunctions = {}

mod.lastHyperId = 40
function mod:AddNewHyperRoom(stringRoomType, enumRoomType, variantsVector, name, specialCaseRoomdataFunction, restrictionCaseFunction, postprocessFunction, doorUpdateFunction, roomIdentificationFunction)

	--ensure input
	stringRoomType = stringRoomType or "sacrifice"
	enumRoomType = enumRoomType or RoomType.ROOM_SACRIFICE

	--we get the id of the room
	local hyperId = mod.lastHyperId
	--the increment the next id for the next room
	mod.lastHyperId = mod.lastHyperId + 1

	--we add its string convertion
	mod.RoomType2String[hyperId] = stringRoomType
	mod.RoomType2Enum[hyperId] = enumRoomType

	--we store its future room datas
	table.insert(mod.DiceRooms, {TYPE = hyperId, NUM = variantsVector})

	--store the name
	mod.HyperroomsNames2Id[name] = hyperId
	--print(name, hyperId)
	
	--we store the id
	table.insert(mod.HyperModdedRooms, hyperId)

	--we increment the amount of special rooms
	mod.nSpecialRooms = mod.nSpecialRooms + 1

	--we store the special case roomdata scenario function, it recieves (door), it has to return a RoomDescriptor.Data
	if specialCaseRoomdataFunction then
		mod.RoomdataFunctions[hyperId] = specialCaseRoomdataFunction
	end

	--we store the restriction case scenario function, it has to return True if its not allowed to be choosed
	if restrictionCaseFunction then
		mod.RoomRestrictionFunctions[hyperId] = restrictionCaseFunction
	end

	--we store the post process function, it recieves (ogHyperId, newHyperId, targetroomdesc), this will be executed after the room was replaced
	if postprocessFunction then
		mod.RoomPostFunctions[hyperId] = postprocessFunction
	end

	--we store the door update function, it recieves (door, room)
	if doorUpdateFunction then
		mod.RoomDoorUpdateFunctions[hyperId] = doorUpdateFunction
	end

	--we store the function to identify the modded room, it recieves (roomdesc)
	if roomIdentificationFunction then
		mod.RoomIdentificationFunctions[hyperId] = roomIdentificationFunction
	end
end

--LETS ADD MODDED ROOMS TO HYPERDICE POOL
--Astral Challenge
function mod:HyperCaseAstralChallenge()
	local alreadyExists = mod:IsThereAstralChallengeInFloor()
	local tier = mod:GetAstralChallengeGenType()

	local newroomdata
	if tier == 'inner' then
		if alreadyExists or (mod.savedatarun().spawnchancemultiplier2 == 0) then
		else
			newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, 8505, 8509, 20, 20, mod.normalDoors)
		end

	elseif tier == 'outer' then
		if alreadyExists or (mod.savedatarun().spawnchancemultiplier1 == 0) then
		else
			newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, 8500, 8504, 20, 20, mod.normalDoors)
		end

	else
		newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, 8510, 20)
		mod.ModFlags.ErrantRoomSpawned = true
	end
	return newroomdata
end
function mod:HyperRestrictionAstralChallenge()

	if not (mod.savedatasettings().UnlockAll or Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("astral_challenge (HC)"))) then
		return true
	end

	local alreadyExists = mod:IsThereAstralChallengeInFloor()
	local tier = mod:GetAstralChallengeGenType()

	if alreadyExists then
		if mod.ModFlags.ErrantRoomSpawned then
			return true
		else
			return false
		end
	else
		if tier == 'outer' and (mod.savedatarun().spawnchancemultiplier1 > 0 or mod.ModFlags.ErrantRoomSpawned) then
			return false

		elseif tier == 'inner' and (mod.savedatarun().spawnchancemultiplier2 > 0 or mod.ModFlags.ErrantRoomSpawned) then
			return false
		end
	end

	return true
end
function mod:HyperIdentificationAstralChallenge(roomdesc)
	return mod:IsRoomDescAstralChallenge(roomdesc) or mod:IsRoomDescErrant(roomdesc)
end
mod:AddNewHyperRoom("dice", RoomType.ROOM_DICE, {}, "AstralChallenge", mod.HyperCaseAstralChallenge, mod.HyperRestrictionAstralChallenge, nil, mod.TransformDoor2Astral, mod.HyperIdentificationAstralChallenge)

--Lunar Pact
function mod:HyperRestrictionLunarPact()
	if not (mod.savedatasettings().UnlockAll or Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("lunar_pact (HC)"))) then
		return true
	end
end
mod:AddNewHyperRoom("devil", RoomType.ROOM_DEVIL, mod.RoomVariantVecs.Lunar, "LunarPact", nil, mod.HyperRestrictionLunarPact, nil, mod.TransformDoor2LunarPact, mod.IsRoomDescLunarPact)

--Tainted Treasure
if TaintedTreasure then
	function mod:HyperRestrictionTaintedTreasure()
		local spawnchance = 0
		for _, player in pairs(TaintedTreasure:GetAllPlayers()) do
			for j, entry in pairs(TaintedTreasure.savedata.taintedsets) do
				if player:HasCollectible(entry[1], true) and not TaintedTreasure:GetConditionValue(entry[3]) then
					spawnchance = spawnchance + (0.2 * (1 + TaintedTreasure:GetTotalTrinketMult(TaintedTrinkets.PURPLE_STAR)))
				end
			end
		end
		if spawnchance > 0 then return false end
		return true
	end
	mod:AddNewHyperRoom("dice", RoomType.ROOM_DICE, Vector(12000, 12051), "TaintedTreasure", nil, mod.HyperRestrictionTaintedTreasure, nil, TaintedTreasure.MakeDoorTainted, TaintedTreasure.IsRoomDescTainted)
end
--Andromeda
if ANDROMEDA then
	function mod:TransformDoor2AbandonedPlanetarium(door, room)
		local doorSprite = door:GetSprite()
		doorSprite:Load("gfx/grid/andromeda_abplanetariumdoor.anm2", true)
		for i=0, 4 do
			doorSprite:ReplaceSpritesheet(i, "gfx/grid/andromeda_abandonedplanetariumdoor_out.png")
		end
	end
	function mod:IsRoomDescBrokenPlanetarium(roomdesc)
		local roomDesc = roomdesc
		local roomConfig = roomDesc.Data
		local roomVariant = roomConfig.Variant

		if roomConfig.Type == RoomType.ROOM_DICE
		and roomVariant >= 4242
		and roomVariant < 4487
		then
			return true
		end

		return false
	end
	mod:AddNewHyperRoom("dice", RoomType.ROOM_DICE, Vector(4242,4487), "AbandonedPlanetarium", nil, nil, nil, mod.TransformDoor2AbandonedPlanetarium, mod.IsRoomDescBrokenPlanetarium)
end
--Rune rooms
if RuneRooms then
	function mod:TransformDoor2RuneRoom(door, room)
		local doorSprite = door:GetSprite()
		doorSprite:Load("gfx/grid/runeRoomDoor.anm2", true)
		for i=0, 4 do
			doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_rune_room.png")
		end
	end
	function mod:IsRoomDescRuneRoom(roomdesc)
		local roomDesc = roomdesc
		local roomConfig = roomDesc.Data
		local roomVariant = roomConfig.Variant

		if roomConfig.Type == RoomType.ROOM_CHEST
		and roomVariant >= 3670
		and roomVariant < 3690
		then
			return true
		end

		return false
	end
	mod:AddNewHyperRoom("chest", RoomType.ROOM_CHEST, Vector(3670,3690), "RuneRoom", nil, nil, nil, mod.TransformDoor2RuneRoom, mod.IsRoomDescRuneRoom)
end
--Demon Vaults
if DemonVaults then
	function mod:HyperCaseDemonVault(door, room)
		local newroomdesc = RoomConfigHolder.GetRandomRoom(
			mod:RandomInt(1,9999),
			false,
			StbType.SPECIAL_ROOMS,
			RoomType.ROOM_LIBRARY,
			RoomShape.ROOMSHAPE_1x1,
			-1,
			-1,
			0,
			10,
			mod.normalDoors,
			21
		)
		return newroomdesc
	end
	function mod:IsRoomDescDemonVault(roomdesc)
		local roomConfig = roomdesc.Data

		if roomConfig.Type ~= RoomType.ROOM_LIBRARY
		or roomConfig.Subtype ~= 21 then
			return false
		end
		return true
	end
	mod:AddNewHyperRoom("library", RoomType.ROOM_LIBRARY, {}, "DemonVault", mod.HyperCaseDemonVault, nil, nil, nil, mod.IsRoomDescDemonVault)

end
--Observatory
if GODMODE then
	function mod:HyperCaseCursedPlanetarium(door) --Before replacing room into an Observatory
		local targetroomdesc = game:GetLevel():GetRoomByIdx(door.TargetRoomIndex)
		GODMODE.api.set_observatory(targetroomdesc.SafeGridIndex, true)
	end
	function mod:HyperPostCursedPlanetarium(ogHyperId, newHyperId, targetroomdesc) --After replacing Observatory into other room
		if (ogHyperId == mod.HyperroomsNames2Id["CursedPlanetarium"]) then

			GODMODE.api.set_observatory(targetroomdesc.SafeGridIndex, false)
			mod:DeleteEntities(Isaac.FindByType(GODMODE.registry.entities.observatory_fx.type,GODMODE.registry.entities.observatory_fx.variant,8))
			GODMODE.cached_observatory_ids = nil
		end
	end
	function mod:HyperIdentificationCursedPlanetarium(roomdesc) --Is roomdesc from an Observatory
		return GODMODE.save_manager.list_contains("ObservatoryGridIdx",nil,function(ele) return tonumber(ele) == roomdesc.SafeGridIndex end)
	end
	function mod:TransformDoor2CursedPlanetarium(door) --Change door
		GODMODE.paint_observatory_door(door)
	end

	mod:AddNewHyperRoom("chest", RoomType.ROOM_CHEST, Vector(8550, 8556), "CursedPlanetarium", mod.HyperCaseCursedPlanetarium, nil, mod.HyperPostCursedPlanetarium, mod.TransformDoor2CursedPlanetarium, mod.HyperIdentificationCursedPlanetarium)
end

function mod:GetHyperDiceRoomData(hyperId)
	for key, value in pairs(mod.DiceRooms) do --bruh
		local roomDic = mod.DiceRooms[key]

		local roomHyperId = roomDic.TYPE
		if hyperId == roomHyperId then
			local roomVec = roomDic.NUM
			local roomEnum = mod.RoomType2Enum[roomHyperId]
			
			for i=1, 50 do-- for non consecutive room variants that will sometimes return nil
				local newroomdata
				if roomVec == -1 then
					newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,9999), false, StbType.SPECIAL_ROOMS, roomEnum, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 19, mod.normalDoors)
				else
					newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,9999), false, StbType.SPECIAL_ROOMS, roomEnum, RoomShape.ROOMSHAPE_1x1, roomVec.X, roomVec.Y, 0, 20, mod.normalDoors)
					if not newroomdata then
						newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, roomEnum, mod:RandomInt(roomVec.X, roomVec.Y), 1200, 0)
					end
				end
				if newroomdata and newroomdata.Shape == RoomShape.ROOMSHAPE_1x1 then
					return newroomdata
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------
--Apocalypse------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--function mod:InitializeEvilRoomData() end
