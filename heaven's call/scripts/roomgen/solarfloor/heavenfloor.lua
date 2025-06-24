local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED
--THIS IS NOT A COMPLETE 'NORMAL' FLOOR!!!!!! DONT EVEN DARE TO GET EXCITED


table.insert(mod.PostLoadInits, {"savedatarun", "solEnabled", false})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.solEnabled", false)

table.insert(mod.PostLoadInits, {"savedatarun", "solRoomGenerated", false})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatarun.solRoomGenerated", false)

function mod:IsSolEnalbed()
	return mod.savedatarun().solEnabled
end
function mod:CurrentlyInHeaven()
	local level = game:GetLevel()
	return mod.savedatarun().solEnabled and (level:GetStage() == LevelStage.STAGE_NULL)
end

--Transform MSatan room
function mod:MegaSatanSetup(room)

end

function mod:MarkSolarBossRoom()
	if MinimapAPI then
		for roomidx=0, 13*13-1 do
			local roomdesc = game:GetLevel():GetRoomByIdx(roomidx)
			local minimaproom = MinimapAPI:GetRoomByIdx(roomidx)

			if minimaproom and roomdesc and mod:IsRoomDescSolarBoss(roomdesc, 1) or mod:IsRoomDescSolarBoss(roomdesc, 2) then
				minimaproom.PermanentIcons = {"SolarBoss"}
			end
		end
	end
end

function mod:InitSolarFloor()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	mod:scheduleForUpdate(function()
		--mod:InitializeMapGrid(level:GetCurrentRoomIndex())
		--mod:GenerateMapa()
		--mod:GenerateRoomsFromMapa()

		level:SetStage(0,0)
		level:SetName("Heaven")
	end,1)
	
	--rooms
	mod:GenerateHeavenRooms()

	--no devil
	level:DisableDevilRoom()

	--Challenges
	if mod:IsChallenge(mod.Challenges.BabelTower) then
		mod:GauntletStartRoom()
	end
end

function mod:GenerateHeavenRooms()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	
	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			if targetroomdesc and targetroomdesc.Data then
				local data = targetroomdesc.Data
				if data.Type == RoomType.ROOM_BOSS then
					local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, 8500, 20)
					targetroomdesc.Data = newroomdata
					mod:TransformDoor2Solar(door, room)

					if MinimapAPI then
						local gridIndex = targetroomdesc.SafeGridIndex
						local position = mod:GridIndexToVector(gridIndex)
						
						local maproom = MinimapAPI:GetRoomAtPosition(position)
						if maproom then
							--maproom.ID = "astralchallenge"..tostring(gridIndex)

							--Anything below is optional
							maproom.Type = RoomType.ROOM_DICE
							maproom.PermanentIcons = {"SolarBoss"}
							maproom.DisplayFlags = 0
							maproom.AdjacentDisplayFlags = 3
							maproom.Descriptor = targetroomdesc
							maproom.AllowRoomOverlap = false
							maproom.Color = Color.Default
						end
					end

				elseif data.Type == RoomType.ROOM_TREASURE then
					local newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_PLANETARIUM, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 19, mod.normalDoors)
					targetroomdesc.Data = newroomdata
					door:GetSprite():Load("gfx/grid/door_00x_planetariumdoor.anm2", true)
					door:GetSprite():Play("KeyClosed", true)

                elseif data.Type == RoomType.ROOM_SHOP then
					
				end
			end
		end
	end
end

--Solar Rooms
-- l HeavensCall.savedatarun().solEnabled = true
function mod:MegaSatanDoorRoomTransform()
	local room = game:GetRoom()
	local level = game:GetLevel()

	--Door(s)
	local door
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		door = room:GetDoor(i)
		if door then
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			local data = targetroomdesc.Data
			if (data.Type == RoomType.ROOM_BOSS) and (data.Variant == 5000) then
				break
			else
				door = nil
			end
			door = nil
		end
	end

	if door then

		--mod:InitInvictusCurse()

		--heck yeah, double if door then
		if door then

			if room:IsFirstVisit() and level:GetStageType() == StageType.STAGETYPE_ORIGINAL then
				local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DEFAULT, 2)
				local boss_index = mod:GetRoomTypeIndex(RoomType.ROOM_BOSS)
				if boss_index then
					local roomconfig = level:GetRoomByIdx(boss_index)
					if roomconfig.Data then
						roomconfig.Data = newroomdata
					end
				end
			end

			--Close doors
			for i = 0, DoorSlot.NUM_DOOR_SLOTS do
				local door = room:GetDoor(i)
				if door then
					door:Close()
				end
			end
			
			--remove keys
			for i=0, game:GetNumPlayers ()-1 do
				local player = game:GetPlayer(i)
				while (player:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1) or player:HasCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)) do
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1)
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2)
				end
			end

			--transform room
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, 8500, 20)
			targetroomdesc.Data = newroomdata
			targetroomdesc.Flags = 0
			
			mod:scheduleForUpdate(function()
				mod.savedatarun().solRoomGenerated = level:GetStageType()
			end, 1)
			local doorSprite = door:GetSprite()

			local delay = 10

			mod:scheduleForUpdate(function()
				sfx:Play(SoundEffect.SOUND_SATAN_RISE_UP)
			end, delay+20)
			mod:scheduleForUpdate(function()
				sfx:Play(SoundEffect.SOUND_SATAN_HURT)
			end, delay+60)

			for i=2,6 do
				mod:scheduleForUpdate(function()
					game:ShakeScreen(10)
				end, delay+i*10)
			end

			mod:scheduleForUpdate(function()
				if not ((level:GetCurrentRoomIndex() == 84) and (level:GetStage() == LevelStage.STAGE6)) then return end

				sfx:Play(SoundEffect.SOUND_BEAST_ANGELIC_BLAST)
				game:ShakeScreen(90)

				local crater = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, door.Position, Vector.Zero, nil)
				for i=1, 20 do
					local velocity = Vector(0,1):Rotated(-90+180*rng:RandomFloat())*(5+20*rng:RandomFloat())
					local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, door.Position, velocity, nil)
					wisp:GetSprite().Color = mod.Colors.whiteish
				end
				for i=1, 10 do
					local velocity = Vector(0,1):Rotated(-90+180*rng:RandomFloat())*(5+10*rng:RandomFloat())
					local debrie = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOOD_PARTICLE, 0, door.Position, velocity, nil)
					debrie.SpriteScale = Vector.One*0.5
					debrie:GetSprite().Color = mod.Colors.whiteish
				end
				for i=1, 20 do
					local velocity = Vector(0,1):Rotated(-90+180*rng:RandomFloat())*(10+10*rng:RandomFloat())
					local debrie = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GOLD_PARTICLE, 0, door.Position, velocity, nil)
					debrie:GetSprite().Color = mod.Colors.whiteish
				end
				for i=1,10 do
					local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, door.Position, Vector.Zero, nil)
				end
				
				room:MamaMegaExplosion(door.Position)

				mod:scheduleForUpdate(function()
					
					mod:TransformDoor2Solar(door, room)
			
					game:GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, false, false, true, false)
					sfx:Stop(SoundEffect.SOUND_GOLDENKEY)
					sfx:Stop(SoundEffect.SOUND_DOOR_HEAVY_CLOSE)
				end, 5)
	
				--Open door
				for i = 0, DoorSlot.NUM_DOOR_SLOTS do
					local _door = room:GetDoor(i)
					if _door then
						_door:Open()
					end
				end

				--Music
				mod:PlayRoomMusic(mod.Music.HEAVEN_FLOOR)

			end, delay+80)

		end

	elseif mod.savedatarun().solRoomGenerated and (level:GetCurrentRoomIndex() == 84) and (level:GetStage() == LevelStage.STAGE6) then
		local door = room:GetDoor(DoorSlot.UP0)
		local doorSprite = door:GetSprite()

		local crater = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, door.Position, Vector.Zero, nil)
		for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0)) do
			wisp:GetSprite().Color = mod.Colors.whiteish
		end
		for i=1,10 do
			local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, door.Position, Vector.Zero, nil)
		end

		local animation = doorSprite:GetAnimation()

		mod:TransformDoor2Solar(door, room)
		doorSprite:Play("Opened", true)
		
		if animation == "Closed" then
			door:Open()
			game:GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, false, false, true, false)
			sfx:Stop(SoundEffect.SOUND_GOLDENKEY)
			sfx:Stop(SoundEffect.SOUND_DOOR_HEAVY_CLOSE)
		end

		--Music
		mod:PlayRoomMusic(mod.Music.HEAVEN_FLOOR)
	end

end
function mod:MegaSatanRoomTransform()
	if false then
		local room = game:GetRoom()
		local level = game:GetLevel()
		local roomdesc = level:GetCurrentRoomDesc()
		if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_ERROR and roomdesc.Data.Variant == 8502 then
			mod:CleanRoom()
		end
	else
		local room = game:GetRoom()
		local level = game:GetLevel()
		local roomdesc = level:GetCurrentRoomDesc()
		if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_ERROR and roomdesc.Data.Variant == 8502 then
			mod:CleanRoom()
		end
	end
end
function mod:HushFloor()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

	if level:GetStage() == LevelStage.STAGE4_3 or level:GetStage() == LevelStage.STAGE_NULL then

		if room:IsFirstVisit() and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2 then
			mod:InitSolarFloor()
		end

		mod:MarkSolarBossRoom()

		--Challenges
		if mod:IsChallenge(mod.Challenges.BabelTower) then
			roomdesc.NoReward = true
		end
		
	end
end


function mod:IsRoomDescNormalSolarFloor(roomdesc)
	if mod.savedatarun().solEnabled then
		local level = game:GetLevel()
		if roomdesc and ((roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DEFAULT) and 
		(level:GetStage() == LevelStage.STAGE4_3 or level:GetStage() == LevelStage.STAGE_NULL))
		then
			return true
		end
	end
	return false
end


--for each room in heaven floor
function mod:OnNormalSolarInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.SOLAR)

end


--KILL LAMB AND ???
function mod:SolarQQQLaser(entity, n, size, mult, vel_mult)
	local player = Isaac.GetPlayer(0)
	mod:scheduleForUpdate(function ()
		if not (entity and entity:Exists()) then return end
		
		for i=1,3 do
			mod:scheduleForUpdate(function ()
				if entity then
					local deintegration = mod:SpawnDeintegration(entity, size, size, math.floor((2+i)*mult), nil, nil, 1, nil, nil, 0.2+i*0.1)
					deintegration.DepthOffset = 100
					local angle = 7
					deintegration.Velocity = vel_mult*5*Vector(2,1):Rotated(-2*angle+angle*i)
					
					entity.Visible = false

					if i==3 then
						entity:Remove()
						mod:PlayRoomMusic(mod.Music.HEAVEN_FLOOR)
					end
				end
			end, 1)
		end
		
		local direction = Vector(1,1):Rotated(mod:RandomInt(-20,20))
		for i=0, 1 do
			--laser
			--local direction = (entity.Position - player.Position):Normalized()

			direction = direction:Rotated(180*i)
			
			local ogPos = entity.Position - direction*500
		
			local laser = mod:SpawnEntity(mod.Entity.HyperBeam, ogPos, Vector.Zero, player):ToLaser()
			--local laser = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.BEAST, 0, ogPos, Vector.Zero, player):ToLaser()
			laser.Angle = direction:GetAngleDegrees()
			laser.Timeout = 10
			laser.Parent = player
			laser.DisableFollowParent = true
			
			mod:scheduleForUpdate(function()
				laser.Size = laser.Size*1.25
			end,1)

			laser.DepthOffset = 2000
		
		
			--laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

			local color = Color(1,1,1,1, 1,1,1)
			laser:GetSprite().Color = color
			laser:Update()
			laser:SetColor(color, 9999, 99, true, true)

			laser.Position = ogPos
				
		end

		sfx:Play(SoundEffect.SOUND_BEAST_ANGELIC_BLAST, 0.75, 2, false, 2)
		--sfx:Play(mod.SFX.LightBeam, 1, 2, false)
		sfx:Play(mod.SFX.LightBeamEnd, 1, 2, false, 2)
		sfx:Play(SoundEffect.SOUND_BEAST_SUCTION_START, 1, 2, false, 3)
			
	end, n)
end
function mod:OnStage6BossInit(entity)
	if mod.savedatarun().solEnabled then
		if entity.Type == EntityType.ENTITY_THE_LAMB then
			entity:Remove()
		elseif entity.Type == EntityType.ENTITY_ISAAC and  entity.Variant == 1 then
			sfx:Play(mod.SFX.Geiger, 2)
			sfx:Play(mod.SFX.Evil)
			mod:SolarQQQLaser(entity, 45, 64, 1, 1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.OnStage6BossInit, EntityType.ENTITY_THE_LAMB)
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.OnStage6BossInit, EntityType.ENTITY_ISAAC)

function mod:OnFinalChestInit(winChest)
	if mod.savedatarun().solEnabled then
		local level = game:GetLevel()
		local room = game:GetRoom()
		if level:GetStage() == LevelStage.STAGE6 and room:GetType() == RoomType.ROOM_BOSS then
			winChest:Remove()

			local gridSize = room:GetGridSize()
			for index = 0, gridSize do
				local grid = room:GetGridEntity(index)
				if grid and grid:GetType() == GridEntityType.GRID_TRAPDOOR and grid:GetVariant() == 1 then
					grid:Destroy(true)
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnFinalChestInit, PickupVariant.PICKUP_BIGCHEST)