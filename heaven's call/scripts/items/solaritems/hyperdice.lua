local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,/%@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&(,,,,,,,,,,,/%&&&&&&&&&&&&&&&%/,,,*#@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&(,,,*(&#*,,,/%&&&&&&&&&&&&&&&&&&#*,,,/%@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&(,,,*(&&&%(,,,*(&&&&&&&&&&&&&&&&&&%(,,,,#@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%*,,,/%&&&&&%(,,,*(&&&&&&&&%(,/#&&&&&%(,,,,#@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%*,,,/%&&&&&&&&#*,,,/%&&&&&&&&&&&&&&&&&&#/,,,/%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@&(,,,*(&&&%(,/%&&&#*,,,/#%%%%%&&&&&&&&&&&&&&&&(,,,,#@@@@@@@@@@@@@@@
@@@@@@@@@@@@@&(,,,*(&&&&&&&&&&&%%%/,,,,(%%%%%%&&&&&&&&&&&&&(,,,,#@@@@@@@@@@@@@@@
@@@@@@@@@@@@@&(,,,*(&&&&&&&&%/,/#%/,,,,(%%%%%%&&&&&&&&&&&&&&&#/,,,/%@@@@@@@@@@@@
@@@@@@@@@@@#*,,,/%&&&&&%(,/#%%%%%%/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/%@@@@@@@@@@@@
@@@@@@@@@@@#*,,,/##/,/#%%%%%%%%(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/%@@@@@@@@@@@@
@@@@@@@@@@@#*,,,/%@@&&&&&&&&%%%(*,,,/#%%%%%%%%&&&&&&&&&&&&&@@%/,,,/%@@@@@@@@@@@@
@@@@@@@@@@@@@&(,,,*(&&&%(,/%%(,,,*(%%%%%%%%&&&&&&&&#*,(&&&&(,,,,#@@@@@@@@@@@@@@@
@@@@@@@@@@@@@&(,,,*#@@&&&&&&%(,,,*(%%%%%%%%&&&&&&&&&&&&&&@&(,/%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%*,,,/%&&&#*,,,/%&&&&&&&&&&%(,/#&&&&&&&&#/,,,/%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%*,,,/%&&&#*,,,/%&&&&&&&&&&&&&&&&&&&&&@@%/,#@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%*,,,/%&(,,,*(&&&&&&#**(&&&&&&&&&&&&@&(,,,,#@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&(,,,,,,,,*(&&&&&&&&&&&&&&&&&&&&@%/,,,/%@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&(,,,,,,/%@@@@@@@@@@@@@@@@@@@@&(,,,*#@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,/%@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.HyperVanillaRooms = {
	[1] = RoomType.ROOM_SHOP,
	[2] = RoomType.ROOM_TREASURE,
	[3] = RoomType.ROOM_SECRET,
	[4] = RoomType.ROOM_ARCADE,
	[5] = RoomType.ROOM_CURSE,
	[6] = RoomType.ROOM_CHALLENGE,
	[7] = RoomType.ROOM_LIBRARY,
	[8] = RoomType.ROOM_SACRIFICE,
	[9] = RoomType.ROOM_DEVIL,
	[10] = RoomType.ROOM_ANGEL,
	[11] = RoomType.ROOM_ISAACS,
	[12] = RoomType.ROOM_CHEST,
	[13] = RoomType.ROOM_DICE,
	[14] = RoomType.ROOM_PLANETARIUM,
	[15] = RoomType.ROOM_ULTRASECRET,
}

mod.ModFlags.hyperdicedRooms = {}
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.hyperdicedRooms", {})

----------------------------------------------------------------------------------------------------------------------
--ROOMS SETUP---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------------------------------
--ACTUAL ITEM EFFECTS-------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

--ACTIVE---------------------------------------------------
function mod:OnHyperdiceUse(item, rng, player)
    local room = game:GetRoom()
	local level = game:GetLevel()

	local closestDoor
	for i = 0, DoorSlot.NUM_DOOR_SLOTS-1 do
		if (room:GetDoor(i) and not closestDoor) or (room:GetDoor(i) and (room:GetDoorSlotPosition(i):Distance(player.Position)) < (closestDoor.Position:Distance(player.Position))) then
			closestDoor = room:GetDoor(i)
		end
	end

	local targetroomdesc = level:GetRoomByIdx(closestDoor.TargetRoomIndex)
	
	if targetroomdesc.Data and targetroomdesc.VisitedCount == 0 and (targetroomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x1 or targetroomdesc.Data.Shape == RoomShape.ROOMSHAPE_IH or targetroomdesc.Data.Shape == RoomShape.ROOMSHAPE_IV) and ( (mod.RoomType2String[targetroomdesc.Data.Type] ~= nil) or (GODMODE and ( tostring(level:GetRoomByIdx(closestDoor.TargetRoomIndex).SafeGridIndex) == tostring(GODMODE.save_manager.get_data("ObservatoryGridIdx","")) )) ) then
		mod:GenerateHyperRoom(closestDoor)

		if player:HasCollectible(mod.SolarItems.HyperDice) then
			player:AnimateCollectible(mod.SolarItems.HyperDice, "UseItem")
			sfx:Play(Isaac.GetSoundIdByName("Hyperdice"),3)

			mod:PlayBookAnimation(0, false)
			ItemOverlay.Show(Isaac.GetGiantBookIdByName("The Hyperdice"), 3, player)
		end

		return {Discharge = true, ShowAnim = true}
	else
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1)
		return {Discharge = false, ShowAnim = false}
	end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnHyperdiceUse,  mod.SolarItems.HyperDice)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item, rng, player)
	player:UseActiveItem(mod.SolarItems.HyperDice, false, false, true, false)
end,  CollectibleType.COLLECTIBLE_D100)

function mod:GenerateHyperRoom(door)

	local level = game:GetLevel()

	local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
	mod:RerrollRoom(targetroomdesc, door)
end

function mod:RerrollRoom(targetroomdesc, door)

	local level = game:GetLevel()

	--get Original type
	local ogType = targetroomdesc.Data.Type
	for idKey, identificationFunction in pairs(mod.RoomIdentificationFunctions) do
		if identificationFunction(nil, targetroomdesc) then
			ogType = idKey
			break
		end
	end

	--get the new room type id
	local function ChooseRoomType()
		local newRoomType

		--choose random number inside the range of total room types
		local randomN = mod:RandomInt(1, mod.nSpecialRooms)
		--randomN = 1

		--if the number is leq than the amount of modded rooms then lets choose a modded room
		if randomN <= (mod.nSpecialRooms-mod.nVanillaRooms) then
			newRoomType = mod.HyperModdedRooms[mod:RandomInt(1, #mod.HyperModdedRooms)]
		else--else, lets choose a vanilla room
			newRoomType = mod.HyperVanillaRooms[mod:RandomInt(1,#mod.HyperVanillaRooms)]
		end
		
		--if ogType == RoomType.ROOM_CURSE then newRoomType = RoomType.ROOM_SECRET else newRoomType = RoomType.ROOM_CURSE end
		--if rng:RandomFloat() < 0.25 then newRoomType = 42 end--test
		
		return newRoomType
	end
	local newRoomType = ChooseRoomType()
	local restrictedFlag = (mod.RoomRestrictionFunctions[newRoomType] and mod.RoomRestrictionFunctions[newRoomType](nil)) or false
	local counter = 0
	while (
	
	(newRoomType == ogType) or
	restrictedFlag or

	--(ogType == RoomType.ROOM_CURSE and newRoomType == RoomType.ROOM_SECRET) or --i forgor why this
	
	--((not mod.savedatasettings().ultraSkin) and ogType == RoomType.ROOM_SECRET and newRoomType == RoomType.ROOM_ULTRASECRET) or --The doors are the same
	--((not mod.savedatasettings().ultraSkin) and ogType == RoomType.ROOM_ULTRASECRET and newRoomType == RoomType.ROOM_SECRET) or
	--((not mod.savedatasettings().ultraSkin) and ogType == RoomType.ROOM_SUPERSECRET and newRoomType == RoomType.ROOM_ULTRASECRET) or
	--(ogType == RoomType.ROOM_SUPERSECRET and newRoomType == RoomType.ROOM_SECRET) or

	(targetroomdesc.SafeGridIndex < 0 and newRoomType == RoomType.ROOM_SECRET) or --softlock, forces you to waste bomb
	(targetroomdesc.SafeGridIndex < 0 and newRoomType == RoomType.ROOM_ULTRASECRET)
	) do
		newRoomType = ChooseRoomType()
		counter = counter + 1
		restrictedFlag = (mod.RoomRestrictionFunctions[newRoomType] and mod.RoomRestrictionFunctions[newRoomType](nil)) or false

		if counter > 500 then
			print("ERROR: No new room type avalible")
			break
		end
	end

	--Get the new room data
	local newRoomData
	local specialCaseRoomdataFunction = mod.RoomdataFunctions[newRoomType]
	if specialCaseRoomdataFunction then
		newRoomData = specialCaseRoomdataFunction(nil, door)
	end
	if not newRoomData then
		newRoomData = mod:GetHyperDiceRoomData(newRoomType)
	end
	--print(newRoomData.Name, newRoomData.Shape, newRoomData.Type, newRoomData.Variant, newRoomData.StageID, newRoomData.Difficulty)

	targetroomdesc.Data = newRoomData
	targetroomdesc.Flags = 0
	
	--Shop prices
	if targetroomdesc.Data and targetroomdesc.Data.Type ~= RoomType.ROOM_SHOP then
		targetroomdesc.ShopItemIdx = -1
	end

	--Post procesing
	for key, postporsFunction in pairs(mod.RoomPostFunctions) do
		postporsFunction(nil, ogType, newRoomType, targetroomdesc)
	end

	--UpdateDoor
	if door then
		if not (ogType == RoomType.ROOM_SECRET or ogType == RoomType.ROOM_SUPERSECRET) then
			door:SetRoomTypes(door.CurrentRoomType, newRoomData.Type)
		end
		mod:HyperUpdateDoor(door, newRoomType)
	end
end

--UTILS-------------------------------
function mod:HyperUpdateDoor(door, newRoomType)
	local level = game:GetLevel()
	local room = game:GetRoom()
	local roomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
	local roomdata = roomdesc.Data

	local doorSprite = door:GetSprite()

	doorSprite.Offset = mod.DoorOffset[door.Direction]


	local doorFunction = mod.RoomDoorUpdateFunctions[newRoomType]

	mod.ModFlags.hyperdicedRooms[roomdesc.GridIndex] = true

	if doorFunction then
		doorFunction(nil, door, room)
	else

		if mod:IsRoomDescUltraSecret(roomdesc) then
			mod:TransformDoor2UltraSecret(door, room)
			doorSprite.Offset = mod.DoorOffset[door.Direction]
		elseif roomdata.Type == RoomType.ROOM_DICE then
			doorSprite:Load("gfx/grid/door_01_normaldoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_00_diceroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_SHOP then
			doorSprite:Load("gfx/grid/door_01_normaldoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_00_shopdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_TREASURE then
			doorSprite:Load("gfx/grid/door_02_treasureroomdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_02_treasureroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_SECRET then
			doorSprite:Load("hc/gfx/grid/astralchallengeroor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "hc/gfx/grid/secreroomdoor.png")
			end
			doorSprite.Offset = mod.DoorOffset[door.Direction]
		elseif roomdata.Type == RoomType.ROOM_ARCADE then
			doorSprite:Load("gfx/grid/door_05_arcaderoomdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_05_arcaderoomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_CURSE then
			doorSprite:Load("gfx/grid/door_04_selfsacrificeroomdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_04_selfsacrificeroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_CHALLENGE then
			doorSprite:Load("gfx/grid/door_03_ambushroomdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_03_ambushroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_LIBRARY then
			doorSprite:Load("gfx/grid/door_01_normaldoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_13_librarydoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_SACRIFICE then
			doorSprite:Load("gfx/grid/door_01_normaldoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_00_sacrificeroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_DEVIL then
			doorSprite:Load("gfx/grid/door_07_devilroomdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_07_devilroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_ANGEL then
			doorSprite:Load("gfx/grid/door_07_holyroomdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_07_holyroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_ISAACS then
			doorSprite:Load("gfx/grid/door_01_normaldoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_23_chestdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_CHEST then
			doorSprite:Load("gfx/grid/door_01_normaldoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_02b_chestroomdoor.png")
			end
		elseif roomdata.Type == RoomType.ROOM_PLANETARIUM then
			doorSprite:Load("gfx/grid/door_00x_planetariumdoor.anm2", true)
			for i=0, 4 do
				doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_00x_planetariumdoor.png")
			end
		
		end
	end

	if MinimapAPI then
		local gridIndex = roomdesc.SafeGridIndex
		local position = mod:GridIndexToVector(gridIndex)
		
		local maproom = MinimapAPI:GetRoomAtPosition(position)
		if maproom then
			--maproom.ID = "astralchallenge"..tostring(gridIndex)
			maproom.Shape = roomdata.Shape

			--Anything below is optional
			maproom.Type = RoomType.ROOM_DICE
			maproom.PermanentIcons = {"HyperDice"}
			maproom.DisplayFlags = 0
			maproom.AdjacentDisplayFlags = 3
			maproom.Descriptor = roomdesc
			maproom.AllowRoomOverlap = false
			maproom.Color = Color.Default
		end
	end

	doorSprite:LoadGraphics()
	doorSprite:Play("Open")
	door:SetLocked (false)
	door:Open()

	mod:UpdateRoomDisplayFlags(roomdesc)
	level:UpdateVisibility()
end