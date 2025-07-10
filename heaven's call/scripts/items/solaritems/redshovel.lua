local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()
local music = MusicManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&%%%%%&&&@@@@&&&&&&&&%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&%%%%%&@@@&&%%%%&&&&&%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&%%%%%&@@@&&%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&@@@&&%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@@@@@@@@&%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%&@@@@@&&@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%%%%%%%%%&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

table.insert(mod.PostLoadInits, {"savedatarun", "redShovelUsed", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.redShovelUsed", 0)


mod.StagesPacked = {
	[1] = {"1", "1a", "1b", "1c", "1d"},
	[2] = {"2", "2a", "2b", "2c", "2d"},

	[3] = {"3", "3a", "3b", "3c", "3d"},
	[4] = {"4", "4a", "4b", "4c", "4d"},

	[5] = {"5", "5a", "5b", "5c", "5d"},
	[6] = {"6", "6a", "6b", "6c", "6d"},

	[7] = {"7", "7a", "7b", "7c"},
	[8] = {"8", "8a", "8b", "8c"},

	[10] = {"10", "10a"},

	[11] = {"11", "11a"},
}

if StageAPI then
	if REVEL then
		table.insert(mod.StagesPacked[1], "Glacier")
		table.insert(mod.StagesPacked[2], "Glacier 2")

		table.insert(mod.StagesPacked[3], "Tomb")
		table.insert(mod.StagesPacked[4], "Tomb 2")
	end

	if FFGRACE then
		table.insert(mod.StagesPacked[1], "Boiler")
		table.insert(mod.StagesPacked[2], "Boiler 2")

		table.insert(mod.StagesPacked[3], "Grotto")
		table.insert(mod.StagesPacked[4], "Grotto 2")
	end

	if Isaac.GetEntityTypeByName("Mullibloom Seed") > 0 then
		table.insert(mod.StagesPacked[10], "Eden")
	end

	if LastJudgement then
		table.insert(mod.StagesPacked[7], "Mortis")
		table.insert(mod.StagesPacked[8], "Mortis 2")
	end

	if false and GODMODE then
		table.insert(mod.StagesPacked[11], "IvoryPalace")
	end
end

mod.RedStages = {
	["1"] = mod.StagesPacked[1],
	["1a"] = mod.StagesPacked[1],
	["1b"] = mod.StagesPacked[1],
	["1c"] = mod.StagesPacked[1],
	["1d"] = mod.StagesPacked[1],
	["Glacier"] = mod.StagesPacked[1],
	["Boiler"] = mod.StagesPacked[1],
	
	["2"] = mod.StagesPacked[2],
	["2a"] = mod.StagesPacked[2],
	["2b"] = mod.StagesPacked[2],
	["2c"] = mod.StagesPacked[2],
	["2d"] = mod.StagesPacked[2],
	["Glacier 2"] = mod.StagesPacked[2],
	["Boiler 2"] = mod.StagesPacked[2],
	
	["3"] = mod.StagesPacked[3],
	["3a"] = mod.StagesPacked[3],
	["3b"] = mod.StagesPacked[3],
	["3c"] = mod.StagesPacked[3],
	["3d"] = mod.StagesPacked[3],
	["Tomb"] = mod.StagesPacked[3],
	["Grotto"] = mod.StagesPacked[3],
	
	["4"] = mod.StagesPacked[4],
	["4a"] = mod.StagesPacked[4],
	["4b"] = mod.StagesPacked[4],
	["4c"] = mod.StagesPacked[4],
	["4d"] = mod.StagesPacked[4],
	["Tomb 2"] = mod.StagesPacked[4],
	["Grotto 2"] = mod.StagesPacked[4],
	
	["5"] = mod.StagesPacked[5],
	["5a"] = mod.StagesPacked[5],
	["5b"] = mod.StagesPacked[5],
	["5c"] = mod.StagesPacked[5],
	["5d"] = mod.StagesPacked[5],
	
	["6"] = mod.StagesPacked[6],
	["6a"] = mod.StagesPacked[6],
	["6b"] = mod.StagesPacked[6],
	["6c"] = mod.StagesPacked[6],
	["6d"] = mod.StagesPacked[6],
	
	["7"] = mod.StagesPacked[7],
	["7a"] = mod.StagesPacked[7],
	["7b"] = mod.StagesPacked[7],
	["7c"] = mod.StagesPacked[7],
	["Mortis"] = mod.StagesPacked[7],
	
	["8"] = mod.StagesPacked[8],
	["8a"] = mod.StagesPacked[8],
	["8b"] = mod.StagesPacked[8],
	["8c"] = mod.StagesPacked[8],
	["Mortis 2"] = mod.StagesPacked[8],
	
	["10"] = mod.StagesPacked[10],
	["10a"] = mod.StagesPacked[10],
	["Eden"] = mod.StagesPacked[10],
	
	["11"] = mod.StagesPacked[11],
	["11a"] = mod.StagesPacked[11],
	["IvoryPalace"] = mod.StagesPacked[11],
	
}

mod.WhiteStages = {
	[LevelStage.STAGE1_1] = {[StageType.STAGETYPE_ORIGINAL] = "1", [StageType.STAGETYPE_WOTL] = "1a", [StageType.STAGETYPE_AFTERBIRTH] = "1b", [StageType.STAGETYPE_REPENTANCE] = "1c", [StageType.STAGETYPE_REPENTANCE_B] = "1d"},
	[LevelStage.STAGE1_2] = {[StageType.STAGETYPE_ORIGINAL] = "2", [StageType.STAGETYPE_WOTL] = "2a", [StageType.STAGETYPE_AFTERBIRTH] = "2b", [StageType.STAGETYPE_REPENTANCE] = "2c", [StageType.STAGETYPE_REPENTANCE_B] = "2d"},
	
	[LevelStage.STAGE2_1] = {[StageType.STAGETYPE_ORIGINAL] = "3", [StageType.STAGETYPE_WOTL] = "3a", [StageType.STAGETYPE_AFTERBIRTH] = "3b", [StageType.STAGETYPE_REPENTANCE] = "3c", [StageType.STAGETYPE_REPENTANCE_B] = "3d"},
	[LevelStage.STAGE2_2] = {[StageType.STAGETYPE_ORIGINAL] = "4", [StageType.STAGETYPE_WOTL] = "4a", [StageType.STAGETYPE_AFTERBIRTH] = "4b", [StageType.STAGETYPE_REPENTANCE] = "4c", [StageType.STAGETYPE_REPENTANCE_B] = "4d"},

	[LevelStage.STAGE3_1] = {[StageType.STAGETYPE_ORIGINAL] = "5", [StageType.STAGETYPE_WOTL] = "5a", [StageType.STAGETYPE_AFTERBIRTH] = "5b", [StageType.STAGETYPE_REPENTANCE] = "5c", [StageType.STAGETYPE_REPENTANCE_B] = "5d"},
	[LevelStage.STAGE3_2] = {[StageType.STAGETYPE_ORIGINAL] = "6", [StageType.STAGETYPE_WOTL] = "6a", [StageType.STAGETYPE_AFTERBIRTH] = "6b", [StageType.STAGETYPE_REPENTANCE] = "6c", [StageType.STAGETYPE_REPENTANCE_B] = "6d"},
	
	[LevelStage.STAGE4_1] = {[StageType.STAGETYPE_ORIGINAL] = "7", [StageType.STAGETYPE_WOTL] = "7a", [StageType.STAGETYPE_AFTERBIRTH] = "7b", [StageType.STAGETYPE_REPENTANCE] = "7c"},
	[LevelStage.STAGE4_2] = {[StageType.STAGETYPE_ORIGINAL] = "8", [StageType.STAGETYPE_WOTL] = "8a", [StageType.STAGETYPE_AFTERBIRTH] = "8b", [StageType.STAGETYPE_REPENTANCE] = "8c"},
	
	[LevelStage.STAGE5] = {[StageType.STAGETYPE_ORIGINAL] = "10", [StageType.STAGETYPE_WOTL] = "10a"},
	
	[LevelStage.STAGE6] = {[StageType.STAGETYPE_ORIGINAL] = "11", [StageType.STAGETYPE_WOTL] = "11a"},
}

local first_init = false
function mod:IsStageRedStage()
	if first_init then
		local shovel_state = mod.savedatarun().redShovelUsed or 'INACTIVE'
		return shovel_state and (shovel_state == 'ACTIVE' or shovel_state == 'FIRST_ROOM')
	else
		first_init = true
	end
end

local stage_api_flag = false

--ACTIVE--------------------------------------------------
function mod:OnUseRedShovel(item, rng, player)
	local nope = function()
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1)
		player:AnimateCollectible(mod.SolarItems.RedShovel, "UseItem")
		return {Discharge = false}
	end

	local room = game:GetRoom()
	local level = game:GetLevel()

	local level_absStage = level:GetAbsoluteStage()
	local absStage = mod.WhiteStages[level_absStage]

	if absStage == nil  then
		return nope()
	end

	local currentStage = absStage[level:GetStageType()]

	if currentStage == nil  then
		return nope()
	else
		if REVEL then
			if REVEL.STAGE.Glacier:IsStage() then
				if mod:get_char(currentStage, 1) == '3' then
					currentStage = "Glacier"
				elseif mod:get_char(currentStage, 1) == '4' then
					currentStage = "Glacier 2"
				end
			elseif REVEL.STAGE.Tomb:IsStage() then
				if mod:get_char(currentStage, 1) == '3' then
					currentStage = "Tomb"
				elseif mod:get_char(currentStage, 1) == '4' then
					currentStage = "Tomb 2"
				end
			end
		end

		if FFGRACE then
			if FFGRACE.STAGE.Grotto:IsStage() then
				if mod:get_char(currentStage, 1) == '3' then
					currentStage = "Grotto"
				elseif mod:get_char(currentStage, 1) == '4' then
					currentStage = "Grotto 2"
				end
			elseif FFGRACE.STAGE.Boiler:IsStage() then
				if mod:get_char(currentStage, 1) == '3' then
					currentStage = "Boiler"
				elseif mod:get_char(currentStage, 1) == '4' then
					currentStage = "Boiler 2"
				end
			end
		end

		if Isaac.GetEntityTypeByName("Mullibloom Seed") > 0 then
			if StageAPI:GetCurrentStage() and StageAPI:GetCurrentStage().Name == 'Eden' then
				currentStage = "Eden"
			end
		end

		if LastJudgement then
			if LastJudgement.STAGE.Mortis:IsStage() then
				if mod:get_char(currentStage, 1) == '3' then
					currentStage = "Mortis"
				elseif mod:get_char(currentStage, 1) == '4' then
					currentStage = "Mortis 2"
				end
			end
		end

		if GODMODE then
			if StageAPI:GetCurrentStage() and StageAPI:GetCurrentStage().Name == 'IvoryPalace' then
				currentStage = "IvoryPalace"
			end
		end
	end

	local newStage = mod:random_elem(mod.RedStages[currentStage])

	if newStage == nil then
		return nope()
	end

	while newStage == currentStage do
		newStage = mod:random_elem(mod.RedStages[currentStage])
	end

    player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, false, false, true, false)

	player.Velocity = Vector.Zero
	player.ControlsCooldown = 49
	local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, player.Position, Vector.Zero, player)
	--trapdoor:GetSprite():Play("BigIdle", true)

	player:PlayExtraAnimation("Trapdoor")
	--swap polaroid for negative and vice versa
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			if currentStage == '10' and player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_NEGATIVE)
				player:AddCollectible(CollectibleType.COLLECTIBLE_POLAROID)
			elseif (currentStage == '10a' or currentStage == 'Eden') and player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_POLAROID)
				player:AddCollectible(CollectibleType.COLLECTIBLE_NEGATIVE)
			end
		end
	end

	sfx:Play(SoundEffect.SOUND_SHOVEL_DIG,1.5)

	mod:scheduleForUpdate(function()
		
		game:SetColorModifier(ColorModifier(0,0,0,1),false)

		if #newStage > 3 then
			Isaac.ExecuteCommand("cstage "..newStage)
			stage_api_flag = true
		else
			Isaac.ExecuteCommand("stage "..newStage)
			stage_api_flag = false
		end
		game:SetColorModifier(ColorModifier(0,0,0,1),false)
		music:SetCurrentPitch(0)
		

		mod:scheduleForUpdate(function()
			--game:StartStageTransition(true, 1)
			player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, false, false, true, false)
			
	
			mod:scheduleForUpdate(function()
				mod.savedatarun().redShovelUsed = 'JUST_USED'
			end, 1)
		end, 1)
	end, 16)
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnUseRedShovel,  mod.SolarItems.RedShovel)

--NEW ROOM--------------------------------------
function mod:OnNewRoomRedShovel()
	local current_idx = game:GetLevel():GetCurrentRoomIndex()

	mod:scheduleForUpdate(function()

		local room = game:GetRoom()
		local level = game:GetLevel()
		local roomDesc = level:GetCurrentRoomDesc()

		if current_idx ~= level:GetCurrentRoomIndex() then return end


		if ((level:GetCurrentRoomIndex() == level:GetStartingRoomIndex()) and (not level:IsAscent()) and room:IsFirstVisit()) or
		((roomDesc.Data.Type == RoomType.ROOM_BOSS) and level:IsAscent() and roomDesc.VisitedCount == 2) then


			if mod.savedatarun().redShovelUsed == 'FIRST_ROOM' then mod.savedatarun().redShovelUsed = 'ACTIVE' end
			if mod.savedatarun().redShovelUsed == 'JUST_USED' then mod.savedatarun().redShovelUsed = 'FIRST_ROOM' end
			if not mod.savedatarun().redShovelUsed then mod.savedatarun().redShovelUsed = 'INACTIVE' end


			if (mod.savedatarun().redShovelUsed == 'ACTIVE') then
				mod:NextStageAfterRedShovel()
			end

			--this executes once
			if mod.savedatarun().redShovelUsed == 'FIRST_ROOM' then
				mod:scheduleForUpdate(function()
					game:StartRoomTransition(roomDesc.GridIndex, 0, RoomTransitionAnim.FADE_MIRROR)
				end,2)

				for i=0, 13*13-1 do
					local roomDesc = level:GetRoomByIdx(i)
					local mirrorRoom = roomDesc.Data and (roomDesc.Data.Subtype == RoomSubType.DOWNPOUR_MIRROR)
					local secretRoom = roomDesc.Data and ((roomDesc.Data.Type == RoomType.ROOM_SECRET) or (roomDesc.Data.Type == RoomType.ROOM_SUPERSECRET))
					if not (mirrorRoom  or secretRoom) and (roomDesc and roomDesc.Flags) then
						roomDesc.Flags = roomDesc.Flags | RoomDescriptor.FLAG_RED_ROOM
					end
				end

				--level:AddCurse(mod.Curse.LUNA, false)
				mod:SetRedStagePitch()


				for i=0, game:GetNumPlayers ()-1 do
					local player = game:GetPlayer(i)
					if player and player:HasCollectible(mod.SolarItems.RedShovel) then
						player:RemoveCollectible(mod.SolarItems.RedShovel)
						mod:scheduleForUpdate(function()
							player:AddCollectible(CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER)
							player:DischargeActiveItem()
						end,1)
					end
				end
			end

		end
	end, 1)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomRedShovel)

--REMOVE ALT PATH DOOR----------------------------------
function mod:RemoveAltPath()
	if mod:IsStageRedStage() then
		local room = game:GetRoom()
		local level = game:GetLevel()
		local currentRoomDesc = level:GetCurrentRoomDesc()
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
			if door then
				local roomDesc = level:GetRoomByIdx(door.TargetRoomIndex)
				if roomDesc.Data.Type == RoomType.ROOM_SECRET_EXIT then
					room:RemoveDoor(i)

                    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD)) do
                        effect:Remove()
                    end

				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.RemoveAltPath)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.RemoveAltPath)

--VOID------------------------
function mod:OnVoidAbsorbRedShovel()
	for i, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.SolarItems.RedShovel)) do
		local position = item.Position
		item:Remove()
		mod:scheduleForUpdate(function()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.SolarItems.RedShovel, position, Vector.Zero, nil)
		end, 2)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnVoidAbsorbRedShovel,  CollectibleType.COLLECTIBLE_VOID)

--UTILS------------------------
function mod:NextStageAfterRedShovel()
	if mod:IsStageRedStage() then
		if stage_api_flag then
			stage_api_flag = false
		else
			mod.savedatarun().redShovelUsed = 'INACTIVE'
			for i=0, game:GetNumPlayers ()-1 do
				local player = Isaac.GetPlayer(i)
				if player:HasCollectible(CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER) then
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER)
					player:AddCollectible(mod.SolarItems.RedShovel)
					break
				end
			end
		end
	end
end

function mod:KeepPitchLow()
	if mod:IsStageRedStage() then
		music:SetCurrentPitch(0.5)
	else
		mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.KeepPitchLow)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.KeepPitchLow)

function mod:SetRedStagePitch()
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.KeepPitchLow)
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.KeepPitchLow)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.SetRedStagePitch)


--mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function () print(mod:IsStageRedStage(), mod.savedatarun().redShovelUsed) end)