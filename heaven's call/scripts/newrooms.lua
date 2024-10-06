local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()
local json = require("json")


--ROOM CHEKCERS-----------------------------------
function mod:IsRoomDescAstralChallenge(roomdesc)
	if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DICE and ((roomdesc.Data.Variant >= mod.minvariant1 and roomdesc.Data.Variant <= mod.maxvariant2)) then
		return true
	end
	return false
end
function mod:IsRoomDescUltraSecret(roomdesc)
	if mod.ModConfigs.ultraSkin and roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_ULTRASECRET then
		return true
	else
		return false
	end
end
function mod:IsRoomDescLunarPact(roomdesc)
	if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DEVIL and (mod.minlunarvariant <= roomdesc.Data.Variant and roomdesc.Data.Variant <= mod.maxlunarvariant) then
		return true
	end
	return false
end
function mod:IsRoomDescSolarBoss(roomdesc, n)
	if roomdesc and roomdesc.Data and ( (roomdesc.Data.Type == RoomType.ROOM_PLANETARIUM and (roomdesc.Data.Variant == 8500) and n == 1) or
	(roomdesc.Data.Type == RoomType.ROOM_ERROR and (roomdesc.Data.Variant == 8501)) and n == 2) then
		return true
	end
	return false
end

function mod:IsRoomErrant(roomdesc)
	if roomdesc and roomdesc.Data and (
		(roomdesc.Data.Type == RoomType.ROOM_DICE and roomdesc.Data.Variant == 8510) or
		(roomdesc.Data.Type == RoomType.ROOM_ERROR and (roomdesc.Data.Variant == 8510 or roomdesc.Data.Variant == 8511))
 )	 then
		return true
	end
	return false
end
function mod:IsRedRoom(roomdesc)
	return roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM
end
function mod:IsGlassRoom(roomdesc)
	return mod:IsRoomDescAstralChallenge(roomdesc) or (roomdesc.Data.Type == RoomType.ROOM_PLANETARIUM)
end

--DOORS------------------------------------------
function mod:TransformDoor2Astral(door, room, level)
	local doorSprite = door:GetSprite()

	local isOnRevelStage = REVEL and (REVEL.STAGE.Glacier:IsStage() or REVEL.STAGE.Tomb:IsStage())
	
	if not isOnRevelStage then
		doorSprite:Load("gfx/grid/astralchallengeroor.anm2", true)
	end

	if isOnRevelStage then
		local doorEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE, 0, door.Position, Vector.Zero, nil):ToEffect()
		doorEffect.DepthOffset = -100

		local doorEffectSprite = doorEffect:GetSprite()

		doorEffectSprite.Rotation = doorSprite.Rotation

		doorEffectSprite:Load("gfx/effect_RevelationDoor.anm2", true)

		mod.RevelationDoor = door;

		if REVEL.STAGE.Glacier:IsStage() then

			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/glacier_astralchallengedoor.png")
			end
		elseif REVEL.STAGE.Tomb:IsStage() then

			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/tomb_astralchallengedoor.png")
			end
		end

		--doorEffectSprite:Play(doorSprite:GetAnimation(), true)
		doorEffectSprite:LoadGraphics()
	end
	doorSprite:LoadGraphics()
	doorSprite:Play("Closed")
	door:SetLocked (false)
end
function mod:TransformDoor2LunarPact(door, room)
	local doorSprite = door:GetSprite()

	local isOnRevelStage = REVEL and (REVEL.STAGE.Glacier:IsStage() or REVEL.STAGE.Tomb:IsStage())
	
	if not isOnRevelStage then
		doorSprite:Load("gfx/grid/astralchallengeroor.anm2", true)
        for i=0,4 do
            doorSprite:ReplaceSpritesheet(i, "gfx/grid/lunarroomdoor.png")
        end
	end

	if isOnRevelStage then
		local doorEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE, 0, door.Position, Vector.Zero, nil):ToEffect()
		doorEffect.DepthOffset = -100

		local doorEffectSprite = doorEffect:GetSprite()

		doorEffectSprite.Rotation = doorSprite.Rotation

		doorEffectSprite:Load("gfx/effect_RevelationDoor.anm2", true)

		mod.RevelationDoor = door;

		if REVEL.STAGE.Glacier:IsStage() then

			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/glacier_lunarroomdoor.png")
			end
		elseif REVEL.STAGE.Tomb:IsStage() then

			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/tomb_lunarroomdoor.png")
			end
		end

		--doorEffectSprite:Play(doorSprite:GetAnimation(), true)
		doorEffectSprite:LoadGraphics()
	end
	doorSprite:LoadGraphics()
	doorSprite:Play("Open")
end
function mod:TransformDoor2UltraSecret(door, room)
	local doorSprite = door:GetSprite()

	if not isOnRevelStage then
		doorSprite:Load("gfx/grid/astralchallengeroor.anm2", true)
		for i=0,4 do
			doorSprite:ReplaceSpritesheet(i, "gfx/grid/redultrasecretdoor.png")
		end
	end

	isOnRevelStage = REVEL and (REVEL.STAGE.Glacier:IsStage() or REVEL.STAGE.Tomb:IsStage())

	if isOnRevelStage then
		local doorEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE, 0, door.Position, Vector.Zero, nil):ToEffect()
		doorEffect.DepthOffset = -100

		local doorEffectSprite = doorEffect:GetSprite()

		doorEffectSprite.Rotation = doorSprite.Rotation

		doorEffectSprite:Load("gfx/effect_RevelationDoor.anm2", true)
		for i=0,4 do
			doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/redultrasecretdoor.png")
		end

		mod.RevelationDoor = door;

		if REVEL.STAGE.Glacier:IsStage() then

			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/glacier_redultrasecretdoor.png")
			end
		elseif REVEL.STAGE.Tomb:IsStage() then

			for i=0,4 do
				doorEffectSprite:ReplaceSpritesheet(i, "gfx/grid/tomb_redultrasecretdoor.png")
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
end

--UTILITIES---------------------------------------
--Roll the spawn for the Astral Challenge Room at the beggining of the floor.
function mod:AstralRoomGenerator()
	mod.ModFlags.LunaTriggered = false
	mod.ModFlags.ErrantTriggered = false
	mod.ModFlags.ErrantRoomSpawned = false

	local level = game:GetLevel()

	--Initialize mod.roomdata
	if not mod.roomdata then
		return
	end

	local spawnChance = 0
	--Spawn floors
	local stageMin = LevelStage.STAGE2_1
	local stageLimit = LevelStage.STAGE3_2

	local extraChance = 0
	if mod:SomebodyHasTrinket(TrinketType.TRINKET_TELESCOPE_LENS) then
		stageLimit = LevelStage.STAGE4_2
		extraChance = 0.05
	end

	local totalchance = 0

	local corpseFlag = ( (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2) and ( level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B ))

	if (level:GetStage() < LevelStage.STAGE5 and not (corpseFlag or (LastJudgement and LastJudgement.STAGE.Mortis:IsStage()) ) ) and not mod.savedata.planetAlive and not mod.savedata.planetKilled1 then
		--If the room can spawn, the chance is 0.2
		if level:GetStage() >= stageMin and level:GetStage() <= stageLimit and not game:IsGreedMode() and not level:IsAscent() then
			if mod.ModConfigs.roomSpawnChance == nil then mod.ModConfigs.roomSpawnChance = 9 end
			if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
				spawnChance = spawnChance + (1 - (1-mod.ModConfigs.roomSpawnChance/100)^2)--You dont add probabilities
			else
				spawnChance = spawnChance + mod.ModConfigs.roomSpawnChance/100
			end
		end

	elseif (level:GetStage() == LevelStage.STAGE5 or corpseFlag or (LastJudgement and LastJudgement.STAGE.Mortis:IsStage()) ) and not mod.savedata.planetAlive and not mod.savedata.planetKilled2 then
		if mod.ModConfigs.roomSpawnChance2 == nil then mod.ModConfigs.roomSpawnChance2 = 30 end
		spawnChance = mod.ModConfigs.roomSpawnChance2/100
		if corpseFlag then
			if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH then
				spawnChance = spawnChance --Keep the same
			else
				spawnChance = 1 - (1-spawnChance)^0.5
			end
		end
	end
	
		
	--Apply persistent multiplier
	if (level:GetStage() < LevelStage.STAGE5 and not corpseFlag) and not mod.savedata.planetAlive and not mod.savedata.planetKilled1 then
		if mod.savedata.spawnchancemultiplier1 == nil then mod.savedata.spawnchancemultiplier1 = 1 end
		totalchance = mod.savedata.spawnchancemultiplier1*spawnChance
	elseif (level:GetStage() == LevelStage.STAGE5 or corpseFlag) and not mod.savedata.planetAlive and not mod.savedata.planetKilled2 then
		if mod.savedata.spawnchancemultiplier2 == nil then mod.savedata.spawnchancemultiplier2 = 1 end
		totalchance = mod.savedata.spawnchancemultiplier2*spawnChance
	end

	if (totalchance > 0) then
		local randomchance = rng:RandomFloat()
		if randomchance <= (totalchance+extraChance) or mod.ModFlags.forceSpawn then
			--SPAWN IT! (It may not spawn if there is absolutelly no avalible space in the stage...)
			local newroomdesc = mod:GenerateRoomFromDataset(mod.roomdata, true)
			if not newroomdesc then 
				mod.ModFlags.forceSpawn = true
			else
				mod.ModFlags.forceSpawn = false
					
				--The little wisps to mark that the room spawned
				for i=1,5 do
					local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,game:GetRoom():GetRandomPosition(0),Vector.Zero,nil)
					wisp:GetSprite().Color = Color.Default
				end
			end
		end
	end
end
--Clean the dice room from dice things.
function mod:CleanDiceRoom()
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TINY_BUG))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TINY_FLY))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WORM))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BEETLE))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WALL_BUG))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BUTTERFLY))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT))
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
            mod:UltraSecretFunctionOutside(door, room, level, roomdesc, targetroomdesc)
            mod:OtherDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)
        end
	end
end
--Update the door of the room to an Astral Challenge
function mod:AstralDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)

    if mod:IsRoomDescAstralChallenge(targetroomdesc) then
        mod:TransformDoor2Astral(door, room, level)
    elseif mod.ModFlags.ErrorRoom and 
        mod.ModFlags.ErrorRoomSource == roomdesc.GridIndex and 
        mod.ModFlags.ErrorRoomSlot == i then
            
        room:RemoveDoor(i)
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
function mod:UltraSecretFunctionOutside(door, room, level, roomdesc, targetroomdesc)

    if mod:IsRoomDescUltraSecret(targetroomdesc) then
        mod:TransformDoor2UltraSecret(door, room)
    end
end
--Update other doors
function mod:OtherDoorFunctionOutside(door, room, level, roomdesc, targetroomdesc)

end

--Reskin the Ultra secret room
function mod:UltraRedSetup(room, noMoon)
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	
	mod:CleanDiceRoom()
	
	--Redify
	for _, sk in ipairs(Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER)) do
		sk:GetSprite().Color = Color(1,0,0,1)
	end
	for _, w in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
		w:GetSprite().Color = Color(0,0,0,1)
	end
	for i=0, 600 do
		local grid = room:GetGridEntity(i)
		if grid then
			grid:GetSprite().Color = Color(0.8,0,0,1)
		end
	end

	--VOID
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
	local sprite = effect:GetSprite()
	sprite.Scale = Vector.One * 0.75
	sprite.Color = Color(1,1,1,1)
	sprite:Load("gfx/backdrop/lunaroomvoid.anm2", true)
	sprite:LoadGraphics()
	sprite:Play("idle", true)
	effect.DepthOffset = -99999

	local wallspos = room:GetCenterPos()-Vector(0,1)*room:GetCenterPos().Y/2
	if not noMoon then
		--Moon
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
		local sprite = effect:GetSprite()
		sprite.Color = Color(1,1,1,1)
		sprite:Load("gfx/backdrop/lunaroommoon.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("idle", true)
		sprite:SetLastFrame()
		local lastFrame = sprite:GetFrame()
		sprite:SetFrame(game:GetFrameCount()%lastFrame)
		effect.DepthOffset = -99999+1
	end
	
	--Glass
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
	local sprite = effect:GetSprite()
	sprite.Color = Color(100,0,0,1,1,0,0,1)
	sprite:Load("gfx/backdrop/glassfloor.anm2", true)
	sprite:LoadGraphics()
	sprite:Play("idle", true)
	
	--Walls
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORMWOOD_HOLE, 0, wallspos, Vector.Zero, nil) --Some inert thing thats in the floor
	effect:AddEntityFlags(EntityFlag.FLAG_FREEZE)
	local sprite = effect:GetSprite()
	sprite.Color = Color(1,1,1,1)
	sprite:Load("gfx/backdrop/lunarroomwalls.anm2", true)
	sprite:LoadGraphics()
	sprite:Play("1x1_room", true)

	--Door again, but opened
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			if mod:IsRoomDescUltraSecret(roomdesc) then
				mod:TransformDoor2UltraSecret(door, room)
			else
				mod:TransformDoor2LunarPact(door, room)
			end
		end
	end
end
--Reskin the ERRant room
function mod:QuantumSetup(room)

	--Change background
	game:ShowHallucination (0,BackdropType.ERROR_ROOM)
	sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx	

	for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
		wisp:Remove()
	end

	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
	effect.DepthOffset = 3
	local sprite = effect:GetSprite()
	sprite.Color = Color.Default
	sprite:Load("gfx/backdrop/eyeoftheuniverse.anm2", true)
	sprite:LoadGraphics()
	sprite:Play("idle", true)

end