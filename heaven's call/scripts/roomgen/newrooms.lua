local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()


table.insert(mod.PostLoadInits, {"savedatafloor", "redplanetariumIdx", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatafloor.redplanetariumIdx", 0)
table.insert(mod.PostLoadInits, {"savedatafloor", "redplanetariumIdy", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatafloor.redplanetariumIdy", 0)

mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.ErrorRoom", false)
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.ErrorRoomSource", -2)

--ROOM CHEKCERS------------------------------------
---------------------------------------------------
---------------------------------------------------
function mod:IsRoomDescAstralChallenge(roomdesc, var)
	var = var or -1
	if var == 1 then
		return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DICE and (mod.RoomVariantVecs.Astral1.X <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.RoomVariantVecs.Astral1.Y)
	elseif var == 2 then
		return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DICE and (mod.RoomVariantVecs.Astral2.X <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.RoomVariantVecs.Astral2.Y)
	else
		return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DICE and (mod.RoomVariantVecs.Astral1.X <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.RoomVariantVecs.Astral2.Y)
	end
end
function mod:IsRoomDescUltraSecret(roomdesc)
	if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_ULTRASECRET then
		return true
	else
		return false
	end
end
function mod:IsRoomDescLunarPact(roomdesc)
	return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DEVIL and (mod.RoomVariantVecs.Lunar.X <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.RoomVariantVecs.Lunar.Y+1)
end
function mod:IsRoomDescSolarBoss(roomdesc, n)
	if roomdesc and roomdesc.Data and ( (roomdesc.Data.Type == RoomType.ROOM_ERROR and (roomdesc.Data.Variant == 8500) and n == 1) or
	(roomdesc.Data.Type == RoomType.ROOM_DUNGEON and (roomdesc.Data.Variant == 8501)) and n == 2) then
		return true
	end
	return false
end
function mod:IsRoomDescSolarWin(roomdesc)
	if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_ERROR and roomdesc.Data.Variant == 8502 then
		return true
	else
		return false
	end
end
function mod:IsRoomDescErrant(roomdesc)
	if roomdesc and roomdesc.Data and (
		(roomdesc.Data.Type == RoomType.ROOM_DICE and roomdesc.Data.Variant == 8510) or
		(roomdesc.Data.Type == RoomType.ROOM_ERROR and (roomdesc.Data.Variant == 8510 or roomdesc.Data.Variant == 8511)))
	then
		return true
	end
	return false
end

function mod:IsRoomDescPlanetarium(roomdesc)
	return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_PLANETARIUM
end
function mod:IsRoomDescMirror(roomdesc)
	return roomdesc and roomdesc.Data and roomdesc.Data.Subtype == RoomSubType.DOWNPOUR_MIRROR
end
function mod:IsRoomDescEvilPlanetarium(roomdesc, sameRoom)
	local a = (mod:SomebodyHasTrinket(TrinketType.TRINKET_DEVILS_CROWN) or mod:SomebodyHasTrinket(mod.Trinkets.Crown) or mod:IsStageRedStage()) and roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_PLANETARIUM and (roomdesc.VisitedCount == 0 or (sameRoom and game:GetRoom():IsFirstVisit()))

	local x = 1 << (roomdesc.SafeGridIndex%13+1)
	local y = 1 << (math.floor(roomdesc.SafeGridIndex/13)+1)

	local b = mod.savedatafloor().redplanetariumIdx and ((x & mod.savedatafloor().redplanetariumIdx > 0) and (y & mod.savedatafloor().redplanetariumIdy > 0))

	return a or b
end

function mod:IsRedRoom(roomdesc)
	return roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM > 0
end
function mod:IsGlassRoom(roomdesc)
	return mod:IsRoomDescAstralChallenge(roomdesc) or (roomdesc.Data.Type == RoomType.ROOM_PLANETARIUM)
end

function mod:IsRoomDescAstralBoss(roomdesc)
	return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DICE and (mod.RoomVariantVecs.AstralBoss.X <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.RoomVariantVecs.AstralBoss.Y)
end

function mod:IsRoomDescChallenge(roomdesc)
	return roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_CHALLENGE
end

--DOORS--------------------------------------------
---------------------------------------------------
---------------------------------------------------
function mod:TransformDoor2Astral(door, room, is_solar)
	if door.TargetRoomType ~= RoomType.ROOM_SECRET then
		local doorSprite = door:GetSprite()

		local isOnRevelStage = REVEL and (REVEL.STAGE.Glacier:IsStage() or REVEL.STAGE.Tomb:IsStage())
		
		if not isOnRevelStage then
			if is_solar then
				doorSprite:Load("hc/gfx/grid/astralchallengeroor_solar.anm2", true)
			else
				doorSprite:Load("hc/gfx/grid/astralchallengeroor.anm2", true)
			end
		end

		if isOnRevelStage then
			local doorEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE, 0, door.Position, Vector.Zero, nil)
			doorEffect.DepthOffset = -100

			local doorEffectSprite = doorEffect:GetSprite()

			doorEffectSprite.Rotation = doorSprite.Rotation

			doorEffectSprite:Load("hc/gfx/effect_RevelationDoor.anm2", true)

			mod.RevelationDoor = door;

			if REVEL.STAGE.Glacier:IsStage() then

				for i=0,4 do
					doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/glacier_astralchallengedoor.png")
				end
			elseif REVEL.STAGE.Tomb:IsStage() then

				for i=0,4 do
					doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/tomb_astralchallengedoor.png")
				end
			end

			--doorEffectSprite:Play(doorSprite:GetAnimation(), true)
			doorEffectSprite:LoadGraphics()
		end
		doorSprite:LoadGraphics()
		doorSprite:Play("Closed")
		door:SetLocked (false)
	end
end
function mod:TransformDoor2LunarPact(door, room)
	if door.TargetRoomType ~= RoomType.ROOM_SECRET then
		local doorSprite = door:GetSprite()

		local isOnRevelStage = REVEL and (REVEL.STAGE.Glacier:IsStage() or REVEL.STAGE.Tomb:IsStage())
		
		if not isOnRevelStage then
			doorSprite:Load("hc/gfx/grid/astralchallengeroor.anm2", true)
			for i=0,4 do
				doorSprite:ReplaceSpritesheet(i, "hc/gfx/grid/lunarroomdoor.png")
			end
		end

		if isOnRevelStage then
			local doorEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE, 0, door.Position, Vector.Zero, nil)
			doorEffect.DepthOffset = -100

			local doorEffectSprite = doorEffect:GetSprite()

			doorEffectSprite.Rotation = doorSprite.Rotation

			doorEffectSprite:Load("hc/gfx/effect_RevelationDoor.anm2", true)

			mod.RevelationDoor = door;

			if REVEL.STAGE.Glacier:IsStage() then

				for i=0,4 do
					doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/glacier_lunarroomdoor.png")
				end
			elseif REVEL.STAGE.Tomb:IsStage() then

				for i=0,4 do
					doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/tomb_lunarroomdoor.png")
				end
			end

			--doorEffectSprite:Play(doorSprite:GetAnimation(), true)
			doorEffectSprite:LoadGraphics()
		end
		doorSprite:LoadGraphics()
		doorSprite:Play("Open")
		door:SetLocked (false)
	end
end
function mod:TransformDoor2UltraSecret(door, room)
	local doorSprite = door:GetSprite()
	if mod.savedatasettings().ultraSkin and mod.savedatasettings().ultraSkin == 1 then

		local isOnRevelStage = REVEL and (REVEL.STAGE.Glacier:IsStage() or REVEL.STAGE.Tomb:IsStage())

		if not isOnRevelStage then
			doorSprite:Load("hc/gfx/grid/astralchallengeroor.anm2", true)
			for i=0,4 do
				doorSprite:ReplaceSpritesheet(i, "hc/gfx/grid/redultrasecretdoor.png")
			end
		end

		if isOnRevelStage then
			local doorEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE, 0, door.Position, Vector.Zero, nil)
			doorEffect.DepthOffset = -100

			local doorEffectSprite = doorEffect:GetSprite()

			doorEffectSprite.Rotation = doorSprite.Rotation

			doorEffectSprite:Load("hc/gfx/effect_RevelationDoor.anm2", true)
			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/redultrasecretdoor.png")
			end

			mod.RevelationDoor = door;

			if REVEL.STAGE.Glacier:IsStage() then

				for i=0,4 do
					doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/glacier_redultrasecretdoor.png")
				end
			elseif REVEL.STAGE.Tomb:IsStage() then

				for i=0,4 do
					doorEffectSprite:ReplaceSpritesheet(i, "hc/gfx/grid/tomb_redultrasecretdoor.png")
				end
			end

			doorEffectSprite:LoadGraphics()
		end
		doorSprite:LoadGraphics()
		doorSprite:Play("Closed")
		
		local offset = (room:GetCenterPos() - door.Position)*0.05
		if math.abs(offset.Y) > 0 then
			offset = (room:GetCenterPos() - door.Position)*0.08
		end
		doorSprite.Offset = offset

		door:SetLocked (false)
	else
		doorSprite:Load("hc/gfx/grid/astralchallengeroor.anm2", true)
		for i=0, 4 do
			doorSprite:ReplaceSpritesheet(i, "hc/gfx/grid/secreroomdoor.png")
		end
		doorSprite.Offset = mod.DoorOffset[door.Direction]
	end
end
function mod:TransformDoor2Solar(door, room)
	local doorSprite = door:GetSprite()

	doorSprite:Load("hc/gfx/grid/megasoldoor.anm2", true)
end

function mod:TransformDoor2EvilPlanetarium(door, room, sameRoom)
	if door.TargetRoomType ~= RoomType.ROOM_SECRET then
		local doorSprite = door:GetSprite()
		local animation = doorSprite:GetAnimation()
		doorSprite:Load("gfx/grid/door_01_normaldoor.anm2")
		for i=0, 4 do
			doorSprite:ReplaceSpritesheet(i, "hc/gfx/grid/evilplanetarium.png")
		end
		doorSprite:LoadGraphics()
		doorSprite:Play(animation)

		if sameRoom then
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, door.Position, Vector.Zero, nil)
		end
	end
end
function mod:TransformDoor2Planetarium(door, room, sameRoom)
	if door.TargetRoomType ~= RoomType.ROOM_SECRET then
		local doorSprite = door:GetSprite()
		local animation = doorSprite:GetAnimation()
		doorSprite:Load("gfx/grid/door_01_normaldoor.anm2")
		for i=0, 4 do
			doorSprite:ReplaceSpritesheet(i, "gfx/grid/door_00x_planetariumdoor.png")
		end
		doorSprite:LoadGraphics()
		doorSprite:Play(animation)

		if sameRoom then
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, door.Position, Vector.Zero, nil)
		end
	end
end
function mod:TransformDoor2Babel(door, room, variant)
	if door.TargetRoomType ~= RoomType.ROOM_SECRET then
		local doorSprite = door:GetSprite()
		local animation = doorSprite:GetAnimation()

		-- vertial -> odd
		-- horizontal -> even

		local n = 0
		if variant == 8520 then--jupiter
			n = 1
		elseif variant == 8521 then--saturn
			n = 1
		elseif variant == 8522 then--uranus
			n = 0
		elseif variant == 8523 then--neptune
			n = 1
		elseif variant == 8524 then--kuiper
			n = 0
		elseif variant == 8525 then--mercury
			n = 0
		elseif variant == 8526 then--veuns
			n = 1
		elseif variant == 8527 then--terra
			n = 0
		elseif variant == 8528 then--mars
			n = 1
		elseif variant == 8529 then--luna
			n = 0
		elseif variant == 8530 then--luna t
			n = 1
		elseif variant == 8531 then--errant
			n = 0
		elseif variant == 8532 then--saturn2
			n = 0
		elseif variant == 8535 then--home
			n = -1
		end
		
		if n ~= -1 then
			if door.Slot%2 == n then
				doorSprite:Load("hc/gfx/grid/stairs.anm2")
			else
				doorSprite:Load("hc/gfx/grid/stairs_down.anm2")
			end
		else
			if door.Slot == DoorSlot.UP0 then
				doorSprite:Load("hc/gfx/grid/stairs.anm2")
			else
				doorSprite:Load("hc/gfx/grid/door_garden.anm2")
			end
		end

		doorSprite:LoadGraphics()
		doorSprite:Play(animation)
	end
end

--Rooms outside
function mod:RoomsFunctionOutside(room, level, roomdesc)

	--STAGE API MUSIC CONFLICT
	mod.MusicChanged = false

	if roomdesc.Data and roomdesc.Data.Type ~= RoomType.ROOM_DEFAULT then
		if mod:IsRoomDescAstralChallenge(roomdesc) then
			mod:OnAstralChallengeInterior()
	
		elseif mod:IsRoomDescLunarPact(roomdesc) then
			mod:OnLunarPactInterior()
			
		elseif mod:IsRoomDescUltraSecret(roomdesc) then
			mod:OnUltraSecretInterior()
	
		elseif mod:IsRoomDescSolarBoss(roomdesc, 1) or mod:IsRoomDescSolarBoss(roomdesc, 2) then
			--mod:OnNormalSolarInterior()
			mod:OnSolarRoomInterior()
	
		elseif mod:IsRoomDescErrant(roomdesc) then
			mod:OnErrantRoomInterior()
			
		elseif mod:IsRoomDescSolarWin(roomdesc) then
			mod:OnDefeatedMSatanRoomInterior()
	
		elseif mod:IsRoomDescAstralBoss(roomdesc) then
			mod:OnAstralBossInterior()
		elseif mod:IsRoomDescPlanetarium(roomdesc, true) then
			if mod:IsRoomDescEvilPlanetarium(roomdesc, true) then
				mod:OnEvilPlanetariumInterior()
			end
			mod:OnPlanetairumInterior()

		elseif mod:IsRoomDescChallenge(roomdesc, true) then
			if ANDROMEDA then
				for i = 0, game:GetNumPlayers() - 1 do
					local player = Isaac.GetPlayer(i)
			
					if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Andromeda", false) then
						local astralMode = mod:GetAstralChallengeGenType()
		
						if astralMode ~= "none" and room:IsFirstVisit() then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Grav Shift Indicator"), 0, player.Position, Vector.Zero, player)
						end
					end
				end
			end
		end
	
	else
		if mod:IsRoomDescMirror(roomdesc) then
			mod:SpawnEntity(mod.Entity.NeptuneMirrorTimer, Vector.Zero, Vector.Zero, nil)
		end
	end
	
	--Sol Room and Floor
	if mod.savedatarun().solEnabled then
		mod:MegaSatanDoorRoomTransform()
		mod:MegaSatanRoomTransform()
		mod:HushFloor()

		if mod:IsRoomDescNormalSolarFloor(roomdesc) then
			mod:OnNormalSolarInterior()
		end
	end

	--STAGE API MUSIC CONFLICT
	if StageAPI then

		if (not mod.MusicChanged) and mod.StageApiMusicAdded then
			mod:table_remove_element(StageAPI.NonOverrideMusic, Music.MUSIC_PLANETARIUM)
			for i, music in ipairs(mod.Music) do
				mod:table_remove_element(StageAPI.NonOverrideMusic, music)
			end
			
			mod.StageApiMusicAdded = false
		end

		if mod.MusicChanged and (not mod.StageApiMusicAdded) then
			table.insert(StageAPI.NonOverrideMusic, Music.MUSIC_PLANETARIUM)
			for i, music in ipairs(mod.Music) do
				table.insert(StageAPI.NonOverrideMusic, music)
			end

			mod.StageApiMusicAdded = true
		end
	end
end
function mod:PlayRoomMusic(musicID, crossfade)
	crossfade = crossfade or 0.08
	mod.MusicChanged = true

	--music:Play(musicID, Options.MusicVolume)
	mod:scheduleForUpdate(function() music:Crossfade(musicID, crossfade) end, 1, ModCallbacks.MC_POST_RENDER)
	--mod:scheduleForUpdate(function() music:Crossfade(musicID, crossfade) end, 2)
end

--Update doors from the outside
function mod:DoorFunctionOutside(room, level, roomdesc)

	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
            mod:AstralDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)
            mod:LunarDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)
            mod:UltraSecretDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)
            mod:EvilPlanetariumDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)
            mod:OtherDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)
        end
	end
end
--Update the door of the room to an Astral Challenge
function mod:AstralDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)

    if mod:IsRoomDescAstralChallenge(targetroomdesc) or mod:IsRoomDescErrant(targetroomdesc) then
        mod:TransformDoor2Astral(door, room)
    elseif mod.ModFlags.ErrorRoom and
        mod.ModFlags.ErrorRoomSource == roomdesc.GridIndex and
        mod.ModFlags.ErrorRoomSlot == door.DoorSlot then
            
        room:RemoveDoor(door.DoorSlot)
        mod.ModFlags.ErrorRoom = false
    end
end
--Update the door of the room to a Lunar pact one
function mod:LunarDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)

    if mod:IsRoomDescLunarPact(targetroomdesc) then
        mod:TransformDoor2LunarPact(door, room)
    end
end
--Update the door of the room to a Lunar pact one
function mod:UltraSecretDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)

    if (mod.savedatasettings().ultraSkin and mod.savedatasettings().ultraSkin == 1) and mod:IsRoomDescUltraSecret(targetroomdesc) then
        mod:TransformDoor2UltraSecret(door, room)
    end
end
--Update the door of the room to the evil planetarium
function mod:EvilPlanetariumDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc, sameRoom)
    if mod:IsRoomDescEvilPlanetarium(targetroomdesc) then
        mod:TransformDoor2EvilPlanetarium(door, room, sameRoom)
    end
end

--Update other doors
function mod:OtherDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)

end

--ROOM INTERIORS-----------------------------------
---------------------------------------------------
---------------------------------------------------
function mod:OnUltraSecretInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	if mod.savedatasettings().ultraSkin and mod.savedatasettings().ultraSkin == 1 then
		mod:ChangeRoomBackdrop(mod.Backdrops.LUNAR, false)
	end
end
function mod:OnSolarRoomInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	if room:IsFirstVisit() then
		for door = DoorSlot.LEFT0, DoorSlot.DOWN1 do
			room:RemoveDoor(door)
		end
	end

	if mod:IsRoomDescSolarBoss(roomdesc, 1) then
		
		mod:ChangeRoomBackdrop(mod.Backdrops.SOLARBOSS)
		
	elseif mod:IsRoomDescSolarBoss(roomdesc, 2)  then

		mod:ChangeRoomBackdrop(mod.Backdrops.VOIDBOSS)

		--Grids
		local newGrids = {}
		for i=0, 27 do
			room:RemoveGridEntity(i, 0, false)
            table.insert(newGrids, i)
		end
		for i=420, 447 do
			room:RemoveGridEntity(i, 0, false)
            table.insert(newGrids, i)
		end
		for i=28, 419, 28 do
			room:RemoveGridEntity(i, 0, false)
            table.insert(newGrids, i)
		end
		for i = 1, #newGrids do
			for k = 1, 3 do
				mod:scheduleForUpdate(function()
					local room = game:GetRoom()
					room:SpawnGridEntity(newGrids[i], GridEntityType.GRID_WALL, 0, 0, 0)
				end, k)
			end
		end

	end

end
function mod:OnDefeatedMSatanRoomInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.MSATAN)
end
function mod:OnRedAstralBossInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.LUNAR)

    mod:PlayRoomMusic(mod.Music.LUNA)

end
function mod:OnEvilPlanetariumInterior()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	local x = roomdesc.SafeGridIndex%13+1
	mod.savedatafloor().redplanetariumIdx = mod.savedatafloor().redplanetariumIdx | (1<<x)
	local y = math.floor(roomdesc.SafeGridIndex/13)+1
	mod.savedatafloor().redplanetariumIdy = mod.savedatafloor().redplanetariumIdy | (1<<y)

	local pool = Isaac.GetPoolIdByName("retrogradePlanetarium HC")
	room:SetItemPool(pool)

	if room:IsFirstVisit() then
        --mod:scheduleForUpdate(function()
			for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				mod:MakeLunarPact(pedestal, true, pool)
			end
			--Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D6, false)
		--end, 1)

		--campfires
		for i, fire in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
			if fire.Variant == 2 or fire.Variant == 3 then
				local newFire = Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 1, 0, fire.Position, Vector.Zero, nil)
				fire:Remove()
			end
		end
	end

	for i, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
		wisp:GetSprite().Color = Color(1,0.5,0,1)
	end

	mod:ChangeRoomBackdrop(mod.Backdrops.DELI)
end
function mod:OnPlanetairumInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

    if room:IsFirstVisit() then
		mod.savedatarun().planetariumPills = 0
    end

end

--GENERATORS---------------------------------------
function mod:MartianRoomGenerator()

    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			if mod:HasAllMotherModule(player) or (not mod:HasMotherModule(player)) then return end
		end
	end

	local level = game:GetLevel()


	local extraChance = 0
	local extraMult = 1

	local success = nil

	if mod:SomebodyHasTrinket(mod.Trinkets.Noise) then
		extraMult = extraMult + 1*mod:HowManyTrinkets(mod.Trinkets.Noise)
	end

	local totalchance = 0

	--Spawn floors
	local stageMin = LevelStage.STAGE2_1

	if level:GetStage() >= stageMin and not game:IsGreedMode() and not level:IsAscent() then
		if mod.savedatasettings().martianRoomSpawnChance == nil then mod.savedatasettings().martianRoomSpawnChance = mod.martianConsts.BASE_SPAWN_CHANCE end


		if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0 then
			totalchance = totalchance + (1 - (1-mod.savedatasettings().martianRoomSpawnChance/100)^2)--You dont add probabilities
		else
			totalchance = totalchance + mod.savedatasettings().martianRoomSpawnChance/100
		end
	end
	totalchance = totalchance*extraMult + extraChance

	if totalchance > 0 then
		local randomchance = rng:RandomFloat()
		if randomchance <= totalchance then
			--SPAWN IT! (It may not spawn if there is absolutelly no avalible space in the stage...)
			local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, 8556, 20)
			local newroomdesc = mod:GenerateRoomFromData(newroomdata, true)
			success = newroomdesc
		end
	end
	
	if success and success.Data then
		local data = success.Data

		if MinimapAPI then
			local gridIndex = success.SafeGridIndex
			local position = mod:GridIndexToVector(gridIndex)

			local maproom = MinimapAPI:GetRoomAtPosition(position)
			if maproom then
				--maproom.ID = "martianlaboratory"..tostring(gridIndex)

				--Anything below is optional
				maproom.Type = RoomType.ROOM_DICE
				maproom.PermanentIcons = {"MartianLaboratory"}
				maproom.DisplayFlags = 0
				maproom.AdjacentDisplayFlags = 3
				maproom.Descriptor = success
				maproom.AllowRoomOverlap = false
				maproom.Color = Color.Default
			else
				MinimapAPI:AddRoom{
					ID = "martianlaboratory"..tostring(gridIndex),
					Position = position,
					Shape = data.Shape,

					--Anything below is optional
					Type = RoomType.ROOM_DICE,
					PermanentIcons = {"MartianLaboratory"},
					DisplayFlags = 0,
					AdjacentDisplayFlags = 3,
					Descriptor = success,
					AllowRoomOverlap = false,
					Color = Color.Default,
				}
			end
		end
	end
end


--BACKDROPS
mod.Backdrops = {
	ASTRAL = 0,
	LUNAR = 1,
	QUANTUM = 2,
	BISMUTH = 3,
	DOOMSDAY = 4,
	MARTIAN = 5,
	NEPTUNE = 6,
	SOLARBOSS = 7,
	VOIDBOSS = 8,
	SOLAR = 9,
	MSATAN = 10,
	HYPER = 11,
	JUPITER = 12,
	ASTRALERRANT = 13,
	APOCALYPSEPLANETARIUM = 14,
	VENUS = 15,
	URANUS = 16,
	DELI = 17,
	HEX = 18,
	FOREST = 19,
	EDEN = 20,
	DRAW = 21,
	GOLDEN = 22,
	THEFUTURE = 23,
	DOOM_FOREST = 24,
	ASCENDEDASTRAL = 25,
}
function mod:ChangeRoomBackdrop(backdrop, vardata, seed)
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	seed = seed or room:GetDecorationSeed()

	for i, background in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
		if not background:GetData().bMark or not (backdrop == mod.Backdrops.SOLAR or backdrop == mod.Backdrops.SOLARBOSS) then
			background:GetData().bMark = false
			background:Remove()
		end
	end

	if backdrop == mod.Backdrops.ASTRAL then


		--room:SetBackdropType(Isaac.GetBackdropIdByName("astral_challenge (hc)"), seed)
		room:SetBackdropType(BackdropType.PLANETARIUM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:CleanRoom()

		if room:IsFirstVisit() then
			--The little wisps
			for i=1,15 do
				local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
				wisp:GetSprite().Color = Color.Default
			end
		end
	
		if true then
			--SPACEEE
			local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2

			if roomdata.Variant < 8509 then
				local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
				effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
				effect.DepthOffset = -99999
				local sprite = effect:GetSprite()
				sprite.Color = Color(1,1,1,1)
				sprite:Load("hc/gfx/backdrop/astralchallengecosmos.anm2", true)
				sprite:LoadGraphics()
				sprite:Play("idle", true)
				effect:SetColor(Color(0, 0, 0, 0), 30, 1, true, true)
			end
	
			local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			effect.DepthOffset = -99999+1
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,1,1,1)
			sprite:Load("hc/gfx/backdrop/astralchallengestars1.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			effect:SetColor(Color(0, 0, 0, 0), 30, 1, true, true)
			
			--Walls
			local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,1,1,1)
			sprite:Load("hc/gfx/backdrop/astralchallengewalls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1", true)

			sprite:SetLastFrame()
			local lastFrame = sprite:GetFrame()
			sprite:SetFrame(mod:RandomInt(0, lastFrame))
			sprite:Stop()
			
		end

		--Door
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				mod:TransformDoor2Astral(door, room)
			end
		end

	elseif backdrop == mod.Backdrops.LUNAR then

		local noMoon = vardata

		--room:SetBackdropType(Isaac.GetBackdropIdByName("lunar_pact (hc)"), seed)
		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:CleanRoom()

		if room:IsFirstVisit() then
			--The little wisps
			for i=1,15 do
				local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
			end
		end
	
		--Redify
		for _, sk in ipairs(Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER)) do
			sk:GetSprite().Color = Color(1,0,0,1)
		end
		for _, w in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
			w:GetSprite().Color = Color(1,0,0,1)
		end
		for i=0, room:GetGridSize()-1 do
			local grid = room:GetGridEntity(i)
			if grid then
				grid:GetSprite().Color = Color(0.8,0,0,1)
			end
		end

	
		if true then
			--VOID
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/sol/solarsky.anm2", true)
			sprite:Play("idle", true)
			effect.DepthOffset = -4000

			--HOLE
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			local sprite = effect:GetSprite()
			sprite.Scale = Vector.One * 0.75
			sprite.Color = Color(1,1,1,1)
			sprite:Load("hc/gfx/backdrop/lunaroomvoid.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			effect.DepthOffset = -4000+1

			local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2

			if not noMoon then
				--Moon
				local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
				effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
				local sprite = effect:GetSprite()
				sprite.Color = Color(1,1,1,1)
				sprite:Load("hc/gfx/backdrop/lunaroommoon.anm2", true)
				sprite:LoadGraphics()
				sprite:Play("idle", true)
				sprite:SetLastFrame()
				local lastFrame = sprite:GetFrame()
				sprite:SetFrame(game:GetFrameCount()%lastFrame)
				effect.DepthOffset = -4000+2
			end
		
			--Glass
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,0,0,1,1,0,0,1)
			sprite:Load("hc/gfx/backdrop/glassfloor.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			effect.DepthOffset = -4000+3
			
			--Walls
			local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,1,1,1)
			sprite:Load("hc/gfx/backdrop/lunarroomwalls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1", true)

			sprite:SetLastFrame()
			local lastFrame = sprite:GetFrame()
			sprite:SetFrame(mod:RandomInt(0, lastFrame))
			sprite:Stop()
			
		end

		--Door
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				if (mod.savedatasettings().ultraSkin and mod.savedatasettings().ultraSkin == 1) and mod:IsRoomDescUltraSecret(roomdesc) then
					mod:TransformDoor2UltraSecret(door, room)
				else
					mod:TransformDoor2LunarPact(door, room)
				end
			end
		end


	elseif backdrop == mod.Backdrops.QUANTUM then

		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:CleanRoom()
	
		--SPACEEE
		local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
	
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
		effect.DepthOffset = -99999
		local sprite = effect:GetSprite()
		sprite.Color = Color.Default
		sprite:Load("hc/gfx/backdrop/eyeoftheuniverse.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("idle", true)
				
		--Walls
		if vardata then
			if vardata == 2 then
				sprite.Color = Color(0,0,0,1)
			end
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant. WOMB_TELEPORT, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/quantumwalls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1", true)
		end

	elseif backdrop == mod.Backdrops.SOLAR then

		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)
		--game:ShowHallucination(0,BackdropType.ERROR_ROOM)
		--sfx:Stop (SoundEffect. SOUND_DEATH_CARD)--Silence the ShowHallucination sfx
		mod:CleanRoom()

		--Inside sol boss room
		local isSolBoss = mod:IsRoomDescSolarBoss(roomdesc, 1)

		--The little wisps
		if not (isSolBoss or mod:IsRoomDescSolarBoss(roomdesc, 2)) then
			if room:IsFirstVisit() then
				for i=1,15 do
					local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
					wisp:GetSprite().Color = Color(0.5,0,2,0.3)
				end
	
			end
			--dye wisps
			for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0)) do
				wisp:GetSprite().Color = Color(1,0,0,1,1,1,0.5)
			end
		end

		local grid_index = level:GetCurrentRoomIndex()

		--chests
		mod:HeavenifyChest()

		--Background
		local spawnVoid = function()
			--VOID
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/sol/solarsky.anm2", true)
			sprite:Play("idle", true)
			effect.DepthOffset = -4000
			effect:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			mod:scheduleForUpdate(function()
				if effect then
					effect:GetData().bMark = 1
				end
			end, 1)
		end

		if true then

			local totalB = 0
			for i, b in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
				if b:GetData().bMark then
					totalB = totalB + b:GetData().bMark
				end
			end
			if totalB < 5 then
				mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Background))

				if not (isSolBoss and room:IsClear()) then
					mod:scheduleForUpdate(function()
						if grid_index ~= level:GetCurrentRoomIndex() then return end

						--STARS
						for i=1, 4 do
		
							local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
							effect:Update()
							effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
							local sprite = effect:GetSprite()
							sprite.Scale = Vector.One
							sprite:Load("hc/gfx/backdrop/sol/solarsky.anm2", true)
							for j=0, 3 do
								sprite:ReplaceSpritesheet(j, "hc/gfx/backdrop/sol/stars"..tostring(i)..".png")
							end
							sprite:LoadGraphics()
							sprite:Play("idle")
		
							sprite.PlaybackSpeed = (1 + 1.5*i)
							sprite.PlaybackSpeed = sprite.PlaybackSpeed*sprite.PlaybackSpeed
							sprite.PlaybackSpeed = sprite.PlaybackSpeed*0.0125
							--sprite.PlaybackSpeed = 5
		
							effect.DepthOffset = -4000 + i*10
							effect:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		
							effect:SetColor(Color(0, 0, 0, 0), 30, 1, true, true)
		
							mod:scheduleForUpdate(function()
								if effect then
									effect:GetData().bMark = 1
									effect:GetData().bId = i
								end
							end, 1)
						end
					end, 1)
				end
				spawnVoid()
			end
		end

		if vardata then
			mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Background))
			spawnVoid()

		else

			--GLASS
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			local sprite = effect:GetSprite()
			effect.DepthOffset = -3000
			sprite:Load("hc/gfx/backdrop/solarfloor.anm2", true)
			if room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then
				sprite:Play("idle1X1", true)
			elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2 then
				sprite:Play("idle1X2", true)
			elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then
				sprite:Play("idle2X2", true)
				sprite.Scale = Vector(0.87, 0.78)
			end
		end

		--DOORS-------
		--Doors
		for slot = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(slot)
			if door then
				local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
				if targetroomdesc then
					local doorSprite = door:GetSprite()
	
					if mod:IsRoomDescSolarBoss(targetroomdesc, 1) then
						mod:TransformDoor2Solar(door, room)

						door:GetSprite():Play("Opening", true)
						door:SetLocked (false)
						door:Open()
	
					elseif mod:IsRoomDescNormalSolarFloor(targetroomdesc) then
						doorSprite:Play("Opened")
						door:SetLocked (false)
					end
				end
			end
		end

		--Inside sol boss room
		if isSolBoss then
			for i = 0, DoorSlot.NUM_DOOR_SLOTS do
				local door = room:GetDoor(i)
				if door then
					mod:TransformDoor2Solar(door, room)
				end
			end
		end

	elseif backdrop == mod.Backdrops.BISMUTH then

		room:SetBackdropType(Isaac.GetBackdropIdByName("mercury_room (hc)"), seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()

	elseif backdrop == mod.Backdrops.DOOMSDAY then


		room:SetBackdropType(Isaac.GetBackdropIdByName("doomsday_chamber (hc)"), seed)

		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		--mod:CleanRoom()


	elseif backdrop == mod.Backdrops.MARTIAN then


		room:SetBackdropType(Isaac.GetBackdropIdByName("martian_laboratory (hc)"), seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()

		if room:IsFirstVisit() then
			--The little wisps
			if not vardata then
				for i=1,15 do
					local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
				end
			end
		end

		--wisps
		if not vardata then
			for i, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
				wisp:GetSprite().Color = Color(1,0,0,1,1,0,0)
			end
		end

		--[[
		--Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
		game:ShowHallucination (0,BackdropType.DUNGEON)
		sfx:Stop (SoundEffect.SOUND _DEATH_CARD)--Silence the ShowHallucination sfx
		mod:CleanRoom()
	
		local dice = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR)
		if #dice > 0 then
			--Remove dice floor
			for i = 1, #dice do
				dice[i]:Remove()
			end
		end
	
		if true then
	
			--Now the actual background and walls
			--SPACEEE
			local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
			
			--Walls
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant. WORMWOOD_HOLE, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/martianwalls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1_room", true)
			
			--Black
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant. WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.DepthOffset = -5000
			local sprite = effect:GetSprite()
			sprite.Scale = sprite.Scale * 2
			sprite.Color = Color(0,0,0,1)
			sprite:Load("hc/gfx/backdrop/astralchallengecosmos.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			
			--Glass
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant. WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.DepthOffset = -5000 + 1
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/glassfloor.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idlePale", true)
		end
		]]--
	elseif backdrop == mod.Backdrops.NEPTUNE then

		room:SetBackdropType(Isaac.GetBackdropIdByName("neptune_room (hc)"), seed)

		if not vardata then
			mod:EnableWeather(mod.WeatherFlags.UNDERWATER)
		end

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()

		local room = game:GetRoom()
		for i=0, room:GetGridSize()-1 do
			local grid = room:GetGridEntity(i)
			if grid then
				if grid:GetType() == GridEntityType.GRID_PIT then
					grid:GetSprite():ReplaceSpritesheet(0, "gfx/grid/grid_pit_cathedral.png")
					grid:GetSprite():LoadGraphics()
				end
			end
		end

		--[[
		--game:GetHUD():SetVisible(false)

		game:ShowHallucination (0,BackdropType.FLOODED_CAVES)
		sfx:Stop (SoundEffect. SOUND_DEATH_CARD)--Silence the ShowHallucination sfx
		mod:CleanRoom()
	
		local dice = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR)
		if #dice > 0 then
			--Remove dice floor
			for i = 1, #dice do
				dice[i]:Remove()
			end
		end
	
		if false then
	
			--Now the actual background and walls
			--SPACEEE
			local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
			
			
			--Walls
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant. WORMWOOD_HOLE, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/martianwalls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1_room", true)
		end
		
        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		]]--

	elseif backdrop == mod.Backdrops.JUPITER then

		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))

		room:SetBackdropType(Isaac.GetBackdropIdByName("jupiter_room (hc)"), seed)

		
	elseif backdrop == mod.Backdrops.SOLARBOSS then

		roomdesc.NoReward = true

		local isClear = room:IsClear()

		if isClear then

			--mod:ChangeRoomBackdrop(mod.Backdrops.SOLAR, true)
			mod:ChangeRoomBackdrop(mod.Backdrops.DELI, true)
		else
			--statue
			if #mod:FindByTypeMod(mod.Entity.BossSolStatue) == 0 then
				local statue = mod:SpawnEntity(mod.Entity.BossSolStatue, room:GetCenterPos(), Vector.Zero, nil)
				statue:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end

			mod:ChangeRoomBackdrop(mod.Backdrops.SOLAR)
		end

	elseif backdrop == mod.Backdrops.VOIDBOSS then
	elseif backdrop == mod.Backdrops.MSATAN then
	
		mod:CleanRoom()
	
		if true then
			--Background
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			effect.DepthOffset = -5000
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/sol/solarsky.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			effect.SpriteScale = Vector.One*1.5
			--sprite.Color = Color(1,0.1,0.1,1)
			sprite.Color = Color(0,0,0,1)
	
			--Floor
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos()+Vector(0,135), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			effect.DepthOffset = -5000+1
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/solarmegasatan.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			--effect.SpriteScale = Vector.One*1.5
		end
	elseif backdrop == mod.Backdrops.HYPER then

		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)
		
		--game:ShowHallucination (0,BackdropType.ERROR_ROOM)
		--sfx:Stop (SoundEffect. SOUND_DEATH_CARD)--Silence the ShowHallucination sfx

		mod:CleanRoom()
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
	

		if true then
	
			local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
			
			--VOID
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			local sprite = effect:GetSprite()
			sprite.Color = Color(0,0,0,1)
			sprite:Load("hc/gfx/backdrop/astralchallengecosmos.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
			effect.DepthOffset = -99999
			
			--Walls
			local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			local sprite = effect:GetSprite()
			sprite.Scale = Vector(1.1,1)
			sprite:Load("hc/gfx/backdrop/hyper_walls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1_room", true)

			local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/hyper_walls.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1_room", true)


			--hyperdice
			local dice = mod:SpawnEntity(mod.Entity.Hyperdice, room:GetCenterPos(), Vector.Zero, nil)
			if mod.savedatafloor().activatedHyperdice then
				dice.Visible = false
			end
			if vardata then
				dice:GetData().Deactivated = true
			end

			local hyperdicefloorgenerator = mod:SpawnEntity(mod.Entity.Hyperfloor, room:GetCenterPos(), Vector.Zero, nil)
		end

	elseif backdrop == mod.Backdrops.ASTRALERRANT then
		
		mod:CleanRoom()
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		

		if room:IsFirstVisit() then
			--The little wisps
			for i=1,15 do
				local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,room:GetRandomPosition(0),Vector.Zero,nil)
			end
		end
		--wisps
		for i, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
			wisp:GetSprite().Color = Color(0.5,0,2,1,0,0,0.1)
			wisp:GetSprite():SetRenderFlags(AnimRenderFlags.GLITCH)
		end

		if roomdata.Type == RoomType.ROOM_DICE then
			room:SetBackdropType(BackdropType.PLANETARIUM, seed)

		elseif roomdata.Type == RoomType.ROOM_ERROR then
			if (mod.savedatarun().errantAlive == false and mod.savedatarun().errantKilled == true) then
				local trapdoor = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, game:GetRoom():GetCenterPos(), true)
			end
		end

		--Door again, but opened
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				mod:TransformDoor2Astral(door, room)
			end
		end

		if mod.ModFlags.ErrantTriggered then
			mod:ChangeRoomBackdrop(mod.Backdrops.QUANTUM)
		end
	elseif backdrop == mod.Backdrops.APOCALYPSEPLANETARIUM then

		mod:ChangeRoomBackdrop(mod.Backdrops.DELI)
		mod:AppearSatellite(room, 8500, -3900)

	elseif backdrop == mod.Backdrops.VENUS then


		room:SetBackdropType(Isaac.GetBackdropIdByName("venus_room (hc)"), seed)
		--room:SetBackdropType(BackdropType.BURNT_BASEMENT, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()

		--Walls
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect.SortingLayer = SortingLayer.SORTING_DOOR
		effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		local sprite = effect:GetSprite()
		if level:GetCurrentRoomIndex()%4==0 then sprite.FlipX = true end
		if level:GetCurrentRoomIndex()%4==1 then sprite.FlipY = true end
		if level:GetCurrentRoomIndex()%4==2 then 
			sprite.FlipX = true 
			sprite.FlipY = true 
		end
		sprite.Color = Color(1,1,1,1)
		sprite:Load("hc/gfx/backdrop/venus_planks.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("idle", true)

	elseif backdrop == mod.Backdrops.URANUS then


		room:SetBackdropType(Isaac.GetBackdropIdByName("bathroom (hc)"), seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))

		--carpet
		for i, carpet in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ISAACS_CARPET)) do
			carpet.Visible = false
		end
	elseif backdrop == mod.Backdrops.DELI then


		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)
		mod:CleanRoom()

		if true then
			--VOID
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
			effect.SpriteScale = effect.SpriteScale * 1.5
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/delirant/voidsky.anm2", true)
			sprite:Play("idle", true)
			effect.DepthOffset = -4005

			--STARS
			for i=0,4 do
				
			 	if vardata and i > 2 then break end
	
				local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
				effect:Update()
				effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
				local sprite = effect:GetSprite()
				sprite.Scale = Vector.One
				if i==3 then
					sprite:Load("hc/gfx/backdrop/delirant/stringsky.anm2", true)
					sprite.Scale = Vector(1,1)*0.75
					sprite:SetFrame("idle",600)
				else
					sprite:Load("hc/gfx/backdrop/delirant/voidsky.anm2", true)
				end
				for j=0, 3 do
					sprite:ReplaceSpritesheet(j, "hc/gfx/backdrop/delirant/stars"..tostring(i)..".png")
				end
				sprite:LoadGraphics()
				sprite:Play("idle")

				if i==3 then
					sprite:SetFrame(600)
				end

				sprite.PlaybackSpeed = (1 + 1.5*(4-i))^0.5
				sprite.PlaybackSpeed = sprite.PlaybackSpeed*sprite.PlaybackSpeed
				sprite.PlaybackSpeed = sprite.PlaybackSpeed*0.5
				--sprite.PlaybackSpeed = 5

				effect.DepthOffset = -4000 + i*10

				if i < 3 then
					effect:GetData().Spin = (i+3)/3
				else
					effect:GetData().Spin = (i-2)/10
				end

				effect:SetColor(Color(0, 0, 0, 0), 30*(5-i), 1, true, true)

				if i == 0 and not vardata then
					--HOLE
					local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
					effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
					local sprite = effect:GetSprite()
					sprite.Scale = Vector.One * 0.1
					sprite.Color = Color(1,1,1,1)
					sprite:Load("hc/gfx/backdrop/lunaroomvoid.anm2", true)
					sprite:LoadGraphics()
					sprite:Play("idle", true)
					effect.DepthOffset = -3999
					effect:SetColor(Color(0, 0, 0, 0), 60, 1, true, true)
				end
			end

			--Glass
			if not vardata then
				local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
				effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
				local glass_sprite = effect:GetSprite()
				glass_sprite.Color = Color(1,1,1,1,1,0,0,-1)
				glass_sprite:Load("hc/gfx/backdrop/glassfloor.anm2", true)
				glass_sprite:LoadGraphics()
				effect.DepthOffset = -3800

				if roomdata.Shape == RoomShape.ROOMSHAPE_IH then
					glass_sprite:Play("idleh", true)
				elseif roomdata.Shape == RoomShape.ROOMSHAPE_IV then
					glass_sprite:Play("idlev", true)
				else
					glass_sprite:Play("idle", true)
				end
			end
		end

		--Door
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				
				if not vardata then
					mod:TransformDoor2EvilPlanetarium(door, room)
				else
					mod:TransformDoor2Solar(door, room)
				end
			end
		end

		if vardata then
			--chests
			mod:HeavenifyChest()

			
            for i, background in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
                background.SpriteScale = background.SpriteScale * 1.25
            end
			
			mod:PlayRoomMusic(Music.MUSIC_DARK_CLOSET, 0.02)
		end

	elseif backdrop == mod.Backdrops.HEX then


		room:SetBackdropType(Isaac.GetBackdropIdByName("charon_room (hc)"), seed)

		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))

	elseif backdrop == mod.Backdrops.FOREST then

		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		--mod:CleanRoom()
	
		if not vardata then
			--Walls
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/terra_forest.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("idle", true)
		end

		--floor
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
		effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		local sprite = effect:GetSprite()
		sprite:Load("hc/gfx/backdrop/terra_floor.anm2", true)
		sprite:Play("idle", true)

	elseif backdrop == mod.Backdrops.DOOM_FOREST then

		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		--mod:CleanRoom()
	
		
		--Walls
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect.SortingLayer = SortingLayer.SORTING_DOOR
		effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		local sprite = effect:GetSprite()
		sprite:Load("hc/gfx/backdrop/terra_forest.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("idle2", true)

		--floor
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
		effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
		local sprite = effect:GetSprite()
		sprite:Load("hc/gfx/backdrop/terra_floor.anm2", true)
		sprite:Play("idle2", true)

	elseif backdrop == mod.Backdrops.EDEN then

		room:SetBackdropType(BackdropType.ERROR_ROOM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()

		--floor
		mod:scheduleForUpdate(function ()
			mod:SpawnGrass()
		end,2)
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
		effect.SpriteOffset = Vector(200,200)
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
		local sprite = effect:GetSprite()
		sprite:Load("hc/gfx/backdrop/terra_floor.anm2", true)
		sprite:Play("idle", true)
		effect:GetData().Looping_HC = true

	elseif backdrop == mod.Backdrops.DRAW then

		room:SetBackdropType(Isaac.GetBackdropIdByName("draw (hc)"), seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()


	elseif backdrop == mod.Backdrops.GOLDEN then

		room:SetBackdropType(Isaac.GetBackdropIdByName("golden (hc)"), seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP))
		mod:CleanRoom()


	elseif backdrop == mod.Backdrops.THEFUTURE then

		room:SetBackdropType(BackdropType.PLANETARIUM, seed)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:CleanRoom()
	
		--NVERMORE HOLE
	
		local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil)
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
		effect.DepthOffset = -99999
		local sprite = effect:GetSprite()
		sprite:Load("hc/gfx/backdrop/the_future/nevermore.anm2", true)
		sprite:Play("idle", true)
		effect:GetData().Nevermore = true
		
		for i=1, 6 do
			local layer = sprite:GetLayer(i)
			layer:SetSize(Vector.One * 0.8)
		end
				
		--Walls
		if vardata then
			local effect = mod:SpawnEntity(mod.Entity.Background, room:GetCenterPos(), Vector.Zero, nil)
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			local sprite = effect:GetSprite()
			sprite:Load("hc/gfx/backdrop/the_future/future_walls.anm2", true)
			sprite:Play("idle", true)
		end

		--Door
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				mod:TransformDoor2Astral(door, room)
			end
		end
	elseif backdrop == mod.Backdrops.ASCENDEDASTRAL then

		mod:ChangeRoomBackdrop(mod.Backdrops.SOLAR)

        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))
		mod:CleanRoom()

		for i, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0)) do
			wisp:GetSprite().Color = Color(1,0.5,0,1, 1,1,1)
		end
	
		if true then

			--SPACEEE
			local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
			
			--Walls
			local effect = mod:SpawnEntity(mod.Entity.Background, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local sprite = effect:GetSprite()
			sprite.Color = Color(1,1,1,1)
			sprite:Load("hc/gfx/backdrop/astralchallengewalls_solar.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("1x1", true)

			sprite:SetLastFrame()
			local lastFrame = sprite:GetFrame()
			sprite:SetFrame(mod:RandomInt(0, lastFrame))
			sprite:Stop()
			
		end

		--Door
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				mod:TransformDoor2Astral(door, room, true)
			end
		end

		for i, statue in ipairs(mod:FindByTypeMod(mod.Entity.Statue)) do
			statue:GetSprite():ReplaceSpritesheet(0, "hc/gfx/effects/solarstatue.png", true)
			statue:GetSprite():GetLayer(0):SetPos(Vector(-3,0))
		end
	end

	for i, background in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
		background:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
	end

end

function mod:BackgroundUpdate(effect)
	if effect.SubType == mod.EntityInf[mod.Entity.Background].SUB then
		local sprite = effect:GetSprite()
		local data = effect:GetData()

		if data.Spin then
			sprite.Rotation = sprite.Rotation + data.Spin
		end

		if data.Nevermore then
			for i=1, 6 do
				local layer = sprite:GetLayer(i)

				local angle = effect.FrameCount * (i^2) * 0.1
				local angle2 = angle * i

				local direction = Vector.FromAngle(angle) * 5
				layer:SetPos(direction)
				layer:SetRotation(angle2*0.5)
			end
		end

		if data.Color then
			sprite.Color = Color.Lerp(sprite.Color, data.Color, 0.1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BackgroundUpdate, mod.EntityInf[mod.Entity.Background].VAR)