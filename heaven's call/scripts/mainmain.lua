local mod = HeavensCall
local game = Game()


mod.hiddenItemManager = require("scripts.libs.hidden_item_manager")
mod.hiddenItemManager:Init(mod)



--Some callbacks can't execute certain functions at the time they are execute, so we delay them
--This is from Fiend Folio
function mod:runUpdates(delayedFuncs)
    for i = #delayedFuncs, 1, -1 do
        local f = delayedFuncs[i]
        f.Delay = f.Delay - 1
        if f.Delay <= 0 then
            f.Func()
            table.remove(delayedFuncs, i)
        end
    end
end
mod.delayedFuncs = {}
function mod:scheduleForUpdate(foo, delay, callback)
    callback = callback or ModCallbacks.MC_POST_UPDATE
    if not mod.delayedFuncs[callback] then
        mod.delayedFuncs[callback] = {}
        mod:AddCallback(callback, function()
            mod:runUpdates(mod.delayedFuncs[callback])
        end)
    end

    table.insert(mod.delayedFuncs[callback], { Func = foo, Delay = delay })
end

--SAVE DATA STUFF-------------------------------------------------------------------
------------------------------------------------------------------------------------

mod.ModFlags = {

	glowingHourglass = 0,
	currentMusic = nil,
	noPool = false,
	forceSpawn = false,

	ErrorRoom = false,
	ErrorRoomSource = -2,
	ErrorRoomSlot = -1,

	SpikeHits = 0,
	
	LunaTriggered = false,
	ErrantTriggered = false,
	ErrantRoomSpawned = false,

	LunarPactInStage = {},

	jupiterLocked = false,
}

mod.PostLoadInits = {}
function mod.savedatarun() return mod.SaveManager.GetRunSave() end
function mod.savedatafloor() return mod.SaveManager.GetFloorSave() end
function mod.savedataroom() return mod.SaveManager.GetRoomSave() end
function mod.savedatasettings() return mod.SaveManager.GetSettingsSave() end
function mod.savedatapersistent() return mod.SaveManager.GetPersistentSave() end
function mod.savedatadss() return mod.SaveManager.GetDeadSeaScrollsSave() end

local data_load_flag = false
function mod:OnPostDataLoadMain(saveData, isLuamod)
	if not data_load_flag then
		print("Initializing Heaven's Call Data Load")--, game:GetFrameCount())
	end

	--mod.savedatarun() = mod.SaveManager.GetRunSave()
	--mod.savedatafloor() = mod.SaveManager.GetFloorSave()
	--mod.savedataroom() = mod.SaveManager.GetRoomSave()

	--mod.savedatasettings() = mod.SaveManager.GetSettingsSave()
	--mod.savedatapersistent() = mod.SaveManager.GetPersistentSave()
	--mod.savedatadss() = mod.SaveManager.GetDeadSeaScrollsSave()

	--mod.savedatarun() = saveData.game.run
	--mod.savedatafloor() = saveData.game.floor
	--mod.savedataroom() = saveData.game.room

	--mod.savedatasettings() = saveData.file.settings
	--mod.savedatapersistent() = saveData.file.other
	--mod.savedatadss() = saveData.file.deadSeaScrolls

	--mod.savedatapersistent().CharAchivement = mod.savedatapersistent().CharAchivement or {}
	--mod.savedatapersistent().ChallAchivement = mod.savedatapersistent().ChallAchivement or {}
	--mod.savedatasettings().UnlockAll = true

	mod.savedatapersistent().CharAchivement = mod.savedatapersistent().CharAchivement or {}
	mod.savedatapersistent().ChallAchivement = mod.savedatapersistent().ChallAchivement or {}

	--mod.savedatasettings().UnlockAll = true
	--print("WARNING: UnlockAll always active")

	for i, entry in ipairs(mod.PostLoadInits) do
		mod[entry[1]]()[entry[2]] = mod[entry[1]]()[entry[2]] or entry[3]
	end

	mod:UpdateDifficulty(mod.savedatasettings().Difficulty)

	if not data_load_flag then
		data_load_flag = true
		print("Heaven's Call Data Loaded!")
	end
end
mod.SaveManager.AddCallback(mod.SaveManager.Utility.CustomCallback.POST_DATA_LOAD, mod.OnPostDataLoadMain)

include("scripts.utils")
include("scripts.sounds")
include("scripts.sillycallbacks")

include("scripts.findentities")

include("scripts.entities.entitiesmain")

include("scripts.items.itemsmain")

include("scripts.roomgen.roomsmain")

include("scripts.curses.cursesmain")

include("scripts.challenges.challenges")

include("scripts.custompool")

include("scripts.savemanager")
include("scripts.specialvanilla")

include("scripts.libs.giantbook")
include("scripts.compatilibity")

mod.PlayerIds2Num = {}
mod.PlayerNum2Ids = {}
function mod:OnPlayerInitGetId(player)
	local seed_num = mod:PlayerId(player)

    for id=0, game:GetNumPlayers ()-1 do
		local other_player = game:GetPlayer(id)
		if mod:PlayerId(other_player) == seed_num then
			mod.PlayerIds2Num[id] = seed_num
			mod.PlayerNum2Ids[seed_num] = id
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.OnPlayerInitGetId)
for id=0, game:GetNumPlayers ()-1 do
	local player = game:GetPlayer(id)
	if player then
		mod:OnPlayerInitGetId(player)
	end
end

--THINGS----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
function mod:InitialUnlocks()
	if not mod.savedatasettings().ProtoSolarInit then
		mod.savedatasettings().ProtoSolarInit = true

		local achievement_names = {
    		"astral_challenge (HC)",
			"lunar_pact (HC)",
			"retro_planet (HC)",
			"clairvoyance (HC)",
			"balls_up (HC)",
			"glass_heart (HC)",
			"telescope (HC)",
			--"titan (HC)",
			--"double_nothing (HC)",
			--"challenge_everchanger (HC)",
			--"curse_wanderer (HC)",
			--"lil_sol (HC)",
			"hyperdice (HC)",
			"space_jam (HC)",
			"asteroid_belt (HC)",
			"void_pickups_A (HC)",
			"heralds_stallion (HC)",
			"panspermia (HC)",
			"theia (HC)",
			"rocket_engine (HC)",
			"void_matter (HC)",
			"stellar_battery (HC)",
			"mothership (HC)",
			"golden_telescope (HC)",
			"quasar (HC)",
			"red_shovel (HC)",
			"picatrix (HC)",
			"infinity_chest (HC)",
			--"mercury (HC)",
			--"venus (HC)",
			--"terra (HC)",
			--"mars (HC)",
			--"jupiter (HC)",
			--"saturn (HC)",
			--"uranus (HC)",
			--"neptune (HC)",
			--"kuiper (HC)",
			--"luna (HC)",
			--"errant (HC)",
			--"rsaturn (HC)",
			--"sol (HC)",
		}
		local persistentData = Isaac.GetPersistentGameData()
		for i, text in ipairs(achievement_names) do
			persistentData:TryUnlock(Isaac.GetAchievementIdByName(text), true)
		end

		mod.savedatasettings().ultraSkin = mod.savedatasettings().ultraSkin or 1
		mod.savedatasettings().victoryChest = mod.savedatasettings().victoryChest or 1
		mod.savedatasettings().astraltooltip = mod.savedatasettings().astraltooltip or 1
		mod.savedatasettings().eternalChance = mod.savedatasettings().eternalChance or mod.ETERNAL_CHANCE
		mod.savedatasettings().taintedTreasurePool = mod.savedatasettings().taintedTreasurePool or 0
	end
end
function mod:OnGameStartMain(iscontinued)

	if iscontinued then
		mod:OnContinuedRunMain()
		mod:ContinueChallenge()
	else
		mod:OnNewRunMain()
		mod:InitializeChallenge()
	end
	mod:InitialUnlocks()
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnGameStartMain)

function mod:OnNewRoomMain()
	
	--things------------------------------------------------------------
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	--Door(s)
	mod:DoorFunctionOutside(room, level, roomdesc)
	
	--Rooms------------------------------------------------------------
	mod:RoomsFunctionOutside(room, level, roomdesc)
	
	if roomtype == RoomType.ROOM_SHOP then
		--mod:SpawnHook()
	end

	--Clear Heaven Stuff
	if not mod:CurrentlyInHeaven() then
		for i, b in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
			if b:GetData().bMark then
				b:Remove()
			end
		end
	end

	--Luna crawler------------------------------------------------------------
	mod:TryToSpawnLunarCrawler(roomdesc)

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomMain)

--Weird stuff-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
local function caca(cmd, parameters)
	if cmd == "NearEntities" then
		print("Printing near entities data")
		local room = game:GetRoom()

		local player = Isaac.GetPlayer(0)

		local entities = Isaac.GetRoomEntities()
		for index, entity in ipairs(entities) do
			if entity.Position:Distance(player.Position) < 100 then
				if entity.Type ~= 1 then
					print(entity.Type)
					print(entity.Variant)
				end
			end
		end

		local gridSize = room:GetGridSize()
		for index = 0, gridSize do
			local grid = room:GetGridEntity(index)
			if grid and grid.Position:Distance(player.Position) < 30 then
				if grid:GetType() ~= GridEntityType.GRID_WALL then
					print(grid:GetType())
				end
			end
		end

	elseif cmd == "HCHud" then
		game:GetHUD():SetVisible(not game:GetHUD():IsVisible())
		
	elseif cmd == "HCSol" then
		--Isaac.ExecuteCommand("debug 3")
		Isaac.ExecuteCommand("stage 9")
		Isaac.ExecuteCommand("goto s.error.8500")

		local player = Isaac.GetPlayer(0)
		if not player:HasCollectible(mod.OtherItems.Apple) then
			player:AddCollectible(mod.OtherItems.Apple)
			player:AddCollectible(mod.OtherItems.Carrot)
			player:AddCollectible(mod.OtherItems.Egg)
		end

	elseif cmd == "HCIrradiate" then
		mod:IrradiateAll()

		
	elseif cmd == "Hide" then
		Isaac.GetPlayer(0).Visible = false
		game:GetHUD():SetVisible(false)
	elseif cmd == "HideHud" then
		game:GetHUD():SetVisible(false)
	elseif cmd == "Show" then
		Isaac.GetPlayer(0).Visible = true
		game:GetHUD():SetVisible(true)

	elseif cmd == "SOL" then
		mod.savedatarun().solEnabled = true
	end
end
--mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, caca)

