local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()
local persistentData = Isaac.GetPersistentGameData()


mod.astralChallengeConsts = {
	BASE_SPAWN_CHANCE1 = 10,
	BASE_SPAWN_CHANCE2 = 30,
	FUTURE_SPAWN_CHANCE = 40,
}

mod.ModFlags.LunaTriggered = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.LunaTriggered", false)
mod.ModFlags.ErrantTriggered = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.ErrantTriggered", false)
mod.ModFlags.ErrantRoomSpawned = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.ErrantRoomSpawned", false)

table.insert(mod.PostLoadInits, {"savedatarun", "spawnchancemultiplier1", 1})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.spawnchancemultiplier1", 1)
table.insert(mod.PostLoadInits, {"savedatarun", "spawnchancemultiplier2", 1})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.spawnchancemultiplier2", 1)


--Roll the spawn for the Astral Challenge Room at the beggining of the floor.
function mod:AstralRoomGenerator()

	local level = game:GetLevel()
	local levelStage = level:GetStage()


	local spawnChance = 0

	local extraChance = 0
	local extraMult = 1

	local success = nil
	local mode = 0

	if mod:SomebodyHasTrinket(TrinketType.TRINKET_TELESCOPE_LENS) then
		extraChance = extraChance + 0.05*mod:HowManyTrinkets(TrinketType.TRINKET_TELESCOPE_LENS)
	end
	if mod:SomebodyHasTrinket(mod.Trinkets.Noise) then
		extraMult = extraMult + 1*mod:HowManyTrinkets(mod.Trinkets.Noise)
	end
	if mod:SomebodyHasItem(mod.SolarItems.SunGlasses) then
		extraMult = extraMult + 0.5*mod:HowManyItems(mod.SolarItems.SunGlasses)
	end

	local totalchance = 0

	local astralMode = mod:GetAstralChallengeGenType()

	if astralMode == "outer" then
		if mod.savedatasettings().roomSpawnChance == nil then mod.savedatasettings().roomSpawnChance = mod.astralChallengeConsts.BASE_SPAWN_CHANCE1 end

		if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0 then
			spawnChance = spawnChance + (1 - (1-mod.savedatasettings().roomSpawnChance/100)^2)--You dont add probabilities
		else
			spawnChance = spawnChance + mod.savedatasettings().roomSpawnChance/100
		end

	elseif astralMode == "inner" then
		if mod.savedatasettings().roomSpawnChance2 == nil then mod.savedatasettings().roomSpawnChance2 = mod.astralChallengeConsts.BASE_SPAWN_CHANCE2 end
		spawnChance = mod.savedatasettings().roomSpawnChance2/100
		
		if levelStage ~= LevelStage.STAGE5 then --is corpse
			if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH  > 0 then
				spawnChance = spawnChance --Keep the same
			else
				spawnChance = 1 - (1-spawnChance)^0.5
			end
		end
	end

	local futureFlag = TheFuture and TheFuture.Stage:IsStage()
	if futureFlag then
		spawnChance = math.max(spawnChance, mod.astralChallengeConsts.FUTURE_SPAWN_CHANCE/100)
	end

	local pill_bonus = mod.savedatarun().planetariumPillsPermanent or 0
	spawnChance = spawnChance + pill_bonus*5/100

	--Apply persistent multiplier
	if (astralMode == "outer") and not mod.savedatarun().planetAlive and not mod.savedatarun().planetKilled1 then
		if mod.savedatarun().spawnchancemultiplier1 == nil then mod.savedatarun().spawnchancemultiplier1 = 1 end
		totalchance = mod.savedatarun().spawnchancemultiplier1*spawnChance
	elseif (astralMode == "inner") and not mod.savedatarun().planetAlive and not mod.savedatarun().planetKilled2 then
		if mod.savedatarun().spawnchancemultiplier2 == nil then mod.savedatarun().spawnchancemultiplier2 = 1 end
		totalchance = mod.savedatarun().spawnchancemultiplier2*spawnChance
	end

	local negFlag = mod:IsStageRedStage()
    totalchance = (totalchance + extraChance) * extraMult

	for i, room_type in ipairs(game:GetChallengeParams():GetRoomFilter()) do
		if room_type == RoomType.ROOM_TREASURE then
			totalchance = 0
			break
		end
	end

	if GODMODE and StageAPI then
		if StageAPI:GetCurrentStage() and StageAPI:GetCurrentStage().Name == 'IvoryPalace' then
			totalchance = 0
		end
	end

	if (totalchance > 0) and not negFlag then
		local randomchance = rng:RandomFloat()
		if randomchance <= (totalchance) or mod.ModFlags.forceSpawn then
			--SPAWN IT! (It may not spawn if there is absolutelly no avalible space in the stage...)
			local newroomdata
			if astralMode=="outer" then
				newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, mod.RoomVariantVecs.Astral1.X, mod.RoomVariantVecs.Astral1.Y, 20, 20, mod.normalDoors)
			elseif astralMode=="inner" then
				newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, mod.RoomVariantVecs.Astral2.X, mod.RoomVariantVecs.Astral2.Y, 20, 20, mod.normalDoors)
			end

			if newroomdata then
				local newroomdesc = mod:GenerateRoomFromData(newroomdata, true)
				if not newroomdesc then
					mod.ModFlags.forceSpawn = true
				else
					mod.ModFlags.forceSpawn = false
						
					--The little wisps to mark that the room spawned
					if mod.savedatasettings().astraltooltip == 1 then
						for i=1,5 do
							local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.WISP,0,game:GetRoom():GetRandomPosition(0),Vector.Zero,nil)
							wisp:GetSprite().Color = Color.Default
						end
					elseif mod.savedatasettings().astraltooltip == 2 then
						mod:scheduleForUpdate(function ()
							local hud = game:GetHUD()
							hud:ShowItemText("The heaven calls your name","")
						end, 30)
					end
					success = newroomdesc
				end
			end
		end
	end

	if success and success.Data then
		local data = success.Data

		if MinimapAPI then
			local gridIndex = success.SafeGridIndex
			local position = mod:GridIndexToVector(gridIndex)
			
			local maproom = MinimapAPI:GetRoomAtPosition(position)
			if maproom then
				--maproom.ID = "astralchallenge"..tostring(gridIndex)

				--Anything below is optional
				maproom.Type = RoomType.ROOM_DICE
				maproom.PermanentIcons = {"AstralChallenge"}
				maproom.DisplayFlags = 0
				maproom.AdjacentDisplayFlags = 3
				maproom.Descriptor = success
				maproom.AllowRoomOverlap = false
				maproom.Color = Color.Default
			else
				MinimapAPI:AddRoom{
					ID = "astralchallenge"..tostring(gridIndex),
					Position = position,
					Shape = data.Shape,

					--Anything below is optional
					Type = RoomType.ROOM_DICE,
					PermanentIcons = {"AstralChallenge"},
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

function mod:OnAstralChallengeInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:PlayRoomMusic(Music.MUSIC_PLANETARIUM)
	mod:RerollAstralPool()

	if room:IsFirstVisit() then
		Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM)
		for _, poof in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01)) do
			poof:Remove()
		end

		mod:UpdateDifficulty(mod.Difficulties.NORMAL, true)
		mod.savedatafloor().DoubleNothing = nil

		if persistentData:Unlocked(Isaac.GetAchievementIdByName("double_nothing (HC)")) then
			mod:AppearDoubleNothing()
		end
	end

	local futureFlag = TheFuture and TheFuture.Stage:IsStage() and (not mod.savedatarun().nevermoreDefeated)
	local beatFutureFlag = TheFuture and TheFuture.Stage:IsStage() and mod.savedatarun().nevermoreDefeated

	if not futureFlag then

		if not mod.savedatarun().planetAlive then
			if ((not mod.savedatarun().planetKilled1) and mod:IsRoomDescAstralChallenge(roomdesc, 1)) or ((not mod.savedatarun().planetKilled2) and mod:IsRoomDescAstralChallenge(roomdesc, 2)) then
				local statue = mod:SpawnEntity(mod.Entity.Statue, game:GetRoom():GetCenterPos()+Vector(0,-20), Vector.Zero, Isaac.GetPlayer(0))
			
			elseif beatFutureFlag then
				for i, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
					if item.SubType > 0 and item.Position:Distance(Vector(320,320)) < 1 then
						item:Remove()
						break
					end
				end
			end
		end

		--What planet should spawn
		if mod.RoomsPlanet[roomdata.Variant] ~= nil and not (mod.savedatarun().planetNum == mod.Entity.Terra2 and mod.RoomsPlanet[roomdata.Variant] == mod.Entity.Terra1) then
			mod.savedatarun().planetNum = mod.RoomsPlanet[roomdesc.Data.Variant]
		end

		if roomdata.Variant > mod.RoomVariantVecs.Astral1.Y then --Inner
			
			if mod.savedatarun().planetKilled1 and mod.savedatarun().planetKilled2 then
				mod:HeavenifyChest()
			end

			--Do not appear again >:(
			mod.savedatarun().spawnchancemultiplier2 = 0
		else --Outer
		
			--Do not appear again >:(
			mod.savedatarun().spawnchancemultiplier1 = 0
		end



		if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
			mod:ChangeRoomBackdrop(mod.Backdrops.ASCENDEDASTRAL)
		else
			mod:ChangeRoomBackdrop(mod.Backdrops.ASTRAL)
		end
		if mod.ModFlags.LunaTriggered then
			for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
				e:Remove()
			end
			mod:ChangeRoomBackdrop(mod.Backdrops.LUNAR, true)
		end

	else
		if not mod.savedatarun().ouroborosEnabled then
			local statue = mod:SpawnEntity(mod.Entity.Statue, game:GetRoom():GetCenterPos()+Vector(0,-20), Vector.Zero, Isaac.GetPlayer(0))
		end
		mod.savedatarun().spawnchancemultiplier1 = 0


		if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
			mod:ChangeRoomBackdrop(mod.Backdrops.ASCENDEDASTRAL)
		else
			mod:ChangeRoomBackdrop(mod.Backdrops.THEFUTURE)
		end
	end
end
function mod:OnAstralBossInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local variant = roomdata.Variant
	local room = game:GetRoom()

	mod.PreviousVariant = variant
	mod.PreviousSeed = room:GetDecorationSeed()

	roomdesc.NoReward = true
	
	mod:CleanRoom()
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR))

	if variant == 8534 then
		mod:OnInitBabelInterior(room)

		local player = Isaac.GetPlayer(0)
		if room:IsFirstVisit() then
			player.Position = room:GetCenterPos()

			local item = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_KEY_PIECE_1)[1]
			if item then
				local pitem = item:ToPickup()
				if pitem then pitem:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.OtherItems.Apple) end
			end

			--pole
			local pole = mod:SpawnEntity(mod.Entity.House, room:GetCenterPos() + Vector(-1500, 1500), Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.House].SUB+1)
            pole:GetData().Lposition_HC = pole.Position
			pole:Update()
			pole:SetSize(5, Vector.One, 12)

			mod:SetTowerDifficulty(0)
		else
			local houses = Isaac.FindByType(mod.EntityInf[mod.Entity.House].ID)
			for i, house in ipairs(houses) do
				if house.SubType == mod.EntityInf[mod.Entity.House].SUB+1 then
					house:Update()
					house:SetSize(5, Vector.One, 12)
				end
			end

			local house = mod:FindByTypeMod(mod.Entity.House)[1]
			if house then
				--player.Position = room:GetCenterPos()
				player.Position = house.Position + Vector(0,80)
			end

			if player:GetPlayerType() == PlayerType.PLAYER_ISAAC then
				mod:SetTowerDifficulty(mod.savedatasettings().Difficulty)
			else
				mod:SetTowerDifficulty(3)
			end
		end
		
		--local ogCamera = Options.CameraStyle
        --Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF
        --room:GetCamera():SnapToPosition(player.Position)
        --room:GetCamera():SetFocusPosition(player.Position)
        --room:GetCamera():SnapToPosition(room:GetCenterPos())
        --room:GetCamera():SetFocusPosition(room:GetCenterPos())
        --Options.CameraStyle = ogCamera

	elseif variant ~= 8533 then
		mod:OnNormalAstralBossInterior(room, variant)
	end

end
function mod:OnNormalAstralBossInterior(room, variant)
	local no_future_flag = (variant == 8532) and (mod.ModFlags.astral_boss == nil) and (mod.savedatapersistent().AstralBossesEncountered & (1 << 11) == 0)

	if room:IsClear() and not no_future_flag then
		mod:ActivateAstralBossBackground(variant, room:GetDecorationSeed())
	else
		if no_future_flag then
			--WARNING
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
			effect.SortingLayer = SortingLayer.SORTING_DOOR
			effect.DepthOffset = 15
			local sprite = effect:GetSprite()
			sprite.Scale = Vector.One*0.85
			sprite:Load("hc/gfx/backdrop/the_future.anm2", true)
			sprite:Play("idle", true)
			--print(sprite:GetAnimation())

			mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.RSaturn))

			mod:ActivateAstralBossBackground(variant, room:GetDecorationSeed())
		else
		
			room:SetBackdropType(BackdropType.HALLWAY, room:GetSpawnSeed())
	
			mod:scheduleForUpdate(function ()
				local flash = mod:SpawnEntity(mod.Entity.ICUP, room:GetCenterPos(), Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.ICUP].SUB+9)
			end, 85)

			local level = game:GetLevel()
			local idx = level:GetCurrentRoomIndex()
			mod:scheduleForUpdate(function ()
				if idx == level:GetCurrentRoomIndex() then
					mod:ActivateAstralBossBackground(variant, room:GetDecorationSeed())
					sfx:Play(SoundEffect.SOUND_FLASHBACK)
				end
			end, 90)
		end
	end

	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			door:SetLocked(false)
			mod:TransformDoor2Babel(door, room, variant)
		end
	end
end
function mod:OnInitBabelInterior(room)

	local controller = mod:SpawnEntity(mod.Entity.LoopController, room:GetCenterPos(), Vector.Zero, nil)

	if room:IsFirstVisit() then
        game:SetColorModifier(ColorModifier(1,1,1,1,5),false)
        game:SetColorModifier(ColorModifier(1,1,1,1),true)

		sfx:Play(SoundEffect.SOUND_DOOR_HEAVY_OPEN)
	else
        game:SetColorModifier(ColorModifier(1,1,1,1,1.25),false)
        game:SetColorModifier(ColorModifier(1,1,1,1),true)
	end

	sfx:Play(SoundEffect.SOUND_FLASHBACK)

	--floor
	mod:ChangeRoomBackdrop(mod.Backdrops.EDEN, nil, nil)

	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			door:GetSprite().Color = Color(1,1,1,0)
		end
	end
end

function mod:ActivateAstralBossBackground(variant, seed)
	if mod:IsChallenge(mod.Challenges.BabelTower) then

		local room = game:GetRoom()

		if not variant then
			local level = game:GetLevel()
			local roomdesc = level:GetCurrentRoomDesc()
			local roomdata = roomdesc.Data
			variant = roomdata.Variant
		end

		if variant == 8520 then--jupiter
			mod:ChangeRoomBackdrop(mod.Backdrops.JUPITER, nil, seed)
		elseif variant == 8521 then--saturn
			room:TurnGold()
			mod:ChangeRoomBackdrop(mod.Backdrops.GOLDEN, nil, seed)
		elseif variant == 8522 then--uranus
			mod:ChangeRoomBackdrop(mod.Backdrops.URANUS, nil, seed)
		elseif variant == 8523 then--neptune
			mod:ChangeRoomBackdrop(mod.Backdrops.NEPTUNE, true, seed)
		elseif variant == 8524 then--kuiper
			mod:ChangeRoomBackdrop(mod.Backdrops.HEX, nil, seed)
		elseif variant == 8525 then--mercury
			mod:ChangeRoomBackdrop(mod.Backdrops.BISMUTH, nil, seed)
		elseif variant == 8526 then--veuns
			mod:ChangeRoomBackdrop(mod.Backdrops.VENUS, nil, seed)
		elseif variant == 8527 then--terra
			mod:ChangeRoomBackdrop(mod.Backdrops.FOREST, nil, seed)
		elseif variant == 8528 then--mars
			mod:ChangeRoomBackdrop(mod.Backdrops.MARTIAN, nil, seed)
		elseif variant == 8529 then--luna
			mod:ChangeRoomBackdrop(mod.Backdrops.DRAW, nil, seed)
			
			local item = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SISTER_MAGGY)[1]
			if item then
				local pitem = item:ToPickup()
				if pitem then pitem:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.OtherItems.Carrot) end
			end

		elseif variant == 8530 then--luna t
			mod:ChangeRoomBackdrop(mod.Backdrops.LUNAR, true, seed)
		elseif variant == 8531 then--errant
			mod:ChangeRoomBackdrop(mod.Backdrops.QUANTUM, true, seed)
		elseif variant == 8532 then--saturn2
			mod:ChangeRoomBackdrop(mod.Backdrops.HYPER, true, seed)
		elseif variant == 8535 then--home
			room:SetBackdropType(BackdropType.HALLWAY, seed)
		end

		--Door(s)
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				mod:TransformDoor2Babel(door, room, variant)
				door:GetSprite():Play("Closed", true)
			end
		end
	end
end

function mod:CanAstralChallengeSpawnInWomb()
    return mod:SomebodyHasTrinket(TrinketType.TRINKET_TELESCOPE_LENS) or mod:SomebodyHasItem(mod.SolarItems.SunGlasses)
end

function mod:IsThereAstralChallengeInFloor()
    local level = game:GetLevel()
    for i=0, 13*13-1 do
        local roomdesc = level:GetRoomByIdx(i)
        if roomdesc and mod:IsRoomDescAstralChallenge(roomdesc) then
            return true
        end
    end
    return false
end

function mod:OnErrantRoomInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.ASTRALERRANT)


	if not mod.savedatarun().errantAlive then
		if not mod.savedatarun().errantKilled then
			local statue = mod:SpawnEntity(mod.Entity.Statue, game:GetRoom():GetCenterPos()+Vector(0,-20),Vector.Zero, Isaac.GetPlayer(0))
			--statue:GetSprite():SetRenderFlags(AnimRenderFlags.GLITCH)
		end
	end

	if room:IsFirstVisit() then
		--glitch items
		for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
			pedestal:AddEntityFlags(EntityFlag.FLAG_GLITCH)
			pedestal:GetSprite():SetRenderFlags(AnimRenderFlags.GLITCH)
		end
	end
end
function mod:OnErrantBossInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.ASTRALERRANT)
end

------------------------------------------------------------
--DOUBLE OR NOTHING-----------------------------------------
------------------------------------------------------------

function mod:AppearDoubleNothing()

	local room = game:GetRoom()

	local gridSet = mod.SolZodiacs[mod:RandomInt(1,12)]
	local gridAngle = 2*math.pi*rng:RandomFloat()

	local scale = 4

	local tPos = room:GetCenterPos()

	for _, trace in ipairs(gridSet) do
		for index, point in ipairs(trace) do

			point = point - Vector(50,50)
			point = Vector(math.cos(gridAngle)*point.X - math.sin(gridAngle)*point.Y, math.sin(gridAngle)*point.X + math.cos(gridAngle)*point.Y)
			point = scale*point + tPos
			point = room:GetClampedPosition(point, 5)

			local flag = true
			for _, star in ipairs(mod:FindByTypeMod(mod.Entity.StarAstral)) do
				if point:Distance(star.Position) < 40 then
					flag = false
					break
				end
			end
			for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
				if point:Distance(pickup.Position) < 30 then
					flag = false
					break
				end
			end
			if math.abs(point.X - room:GetCenterPos().X) < 30 and point.Y < room:GetCenterPos().Y then
				flag = false
			end

			if flag then
				local star = mod:SpawnEntity(mod.Entity.StarAstral, point, Vector.Zero, nil)
				star:GetSprite().Color = Color.Default
				star.SpriteScale = Vector.One*(0.2 + 0.2*rng:RandomFloat())
				star:GetSprite().Rotation = 360*rng:RandomFloat()
				star:GetData().total_amount = #gridSet
			end
		end
	end
end

function mod:StarAstralUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.StarAstral].SUB then
		local sprite = effect:GetSprite()
		if sprite:IsPlaying("Idle") then
			for i=0, game:GetNumPlayers ()-1 do
				local player = game:GetPlayer(i)
				if player then
					if effect.Position:Distance(player.Position) < 30 then
						sprite:Play("Death", true)
						
						local n_stars = 0
						for i, star in ipairs(mod:FindByTypeMod(mod.Entity.StarAstral)) do
							if not star:GetSprite():IsPlaying("Death") then
								n_stars = n_stars + 1
							end
						end
						--print(n_stars, mod.savedatasettings().Difficulty, mod.Difficulties.NORMAL)

						local total_stars = effect:GetData().total_amount or 1
						if (n_stars <= 0) and (mod.savedatasettings().Difficulty == mod.Difficulties.NORMAL) then
							mod:AscendAstralChallenge(2)
							sfx:Play(Isaac.GetSoundIdByName("EffigyCompleted"), 0.67, 2,false, 1.5)
						else
							sfx:Play(Isaac.GetSoundIdByName("effigy1"), 0.67, 2, false, math.max(n_stars,1)/total_stars)
						end
						break
					end
				end
			end
		else
			if sprite:IsFinished("Death") then
				effect:Remove()
			end
		end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.StarAstralUpdate, mod.EntityInf[mod.Entity.StarAstral].VAR)

function mod:AscendAstralChallenge(amount)
	local difficulty = mod.savedatasettings().Difficulty
	local new_difficulty = math.min(mod.Difficulties.ASCENDED, difficulty + amount)

	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)

	if (#items > 0) and (difficulty ~= new_difficulty) then
		local room = game:GetRoom()

		local flash = mod:SpawnEntity(mod.Entity.ICUP, room:GetCenterPos(), Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.ICUP].SUB+9)
		mod:ChangeRoomBackdrop(mod.Backdrops.ASCENDEDASTRAL)

		mod:UpdateDifficulty(new_difficulty)
		
		sfx:Play(SoundEffect.SOUND_FLASHBACK)

		local v = Vector(320,320)
		local final_item
		for _, item in ipairs(items) do
			if item.SubType ~= 0 then
				if (not final_item) or item.Position:Distance(v) < final_item.Position:Distance(v) then
					final_item = item
				end
			end
		end
		if final_item then
			mod.savedatafloor().DoubleNothing = final_item.SubType
		end

		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player then
				player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
				--mod.hiddenItemManager:AddForRoom(player, CollectibleType.COLLECTIBLE_HOLY_MANTLE)
			end
		end

	else
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1)
	end
end

function mod:OnAstralPlayerDamage()
	if mod.savedatafloor().DoubleNothing ~= nil and mod.savedatarun().planetAlive then

		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player and player:HasCollectible(mod.savedatafloor().DoubleNothing) then

				local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.savedatafloor().DoubleNothing, player.Position, Vector.Zero, nil)
				item.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				--item.Visible = false
				item:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				item:Update()
				local deintegration = mod:SpawnDeintegration(item, 32, 32, 4, nil, nil, 1, nil, nil, 1)
				deintegration.DepthOffset = 100
                item:Remove()

				player:RemoveCollectible(mod.savedatafloor().DoubleNothing)

				player:AnimateTrapdoor()
				mod:scheduleForUpdate(function()
					player:GetSprite():Play("Sad", true)
				end, 0)
			end
		end
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
		
		mod.savedatafloor().DoubleNothing = nil
	end
end