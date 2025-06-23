local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local json = require("json")
local persistentData = Isaac.GetPersistentGameData()

--Save
function mod:SaveModdedModData(shouldSave)
	if shouldSave then
		if mod.savedatarun().planetAlive and mod.savedatarun().planetNum then
			local planet = mod:FindByTypeMod(mod.savedatarun().planetNum)
			if planet~=nil and #planet>0 and planet[1]~=nil then
				mod.savedatarun().planetHP = planet[1].HitPoints --There should not be more than 1 planet at the same time so... (we dont talk about meat cleaver)

				if mod.savedatarun().planetNum == mod.Entity.Pluto then
					local eris = mod:FindByTypeMod(mod.Entity.Eris)[1]
					if eris then
						mod.savedatarun().planetHP2 = eris.HitPoints
					end
					local makemake = mod:FindByTypeMod(mod.Entity.Makemake)[1]
					if makemake then
						mod.savedatarun().planetHP3 = makemake.HitPoints
					end
					local haumea = mod:FindByTypeMod(mod.Entity.Haumea)[1]
					if haumea then
						mod.savedatarun().planetHP4 = haumea.HitPoints
					end
					local errant = mod:FindByTypeMod(mod.Entity.Errant)[1]
					if errant then
						mod.savedatarun().errantHP = errant.HitPoints
					end
				end
			end
		end
		if mod.savedatarun().errantAlive then
			local errant = mod:FindByTypeMod(mod.Entity.Errant)[1]
			if errant then
				mod.savedatarun().errantHP = errant.HitPoints
			end
		end
	end
end
mod.SaveManager.AddCallback(mod.SaveManager.Utility.CustomCallback.PRE_DATA_SAVE, mod.SaveModdedModData)

-- New runs thigns
function mod:OnContinuedRunMain()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	--Close the room if the boss is alive in AC room
	if mod.savedatarun().planetAlive and mod:IsRoomDescAstralChallenge(roomdesc) then
		mod:scheduleForUpdate(function()
			--Close door
			for i = 0, DoorSlot.NUM_DOOR_SLOTS do
				local door = room:GetDoor(i)
				if door then
					door:Close()
				end
			end
			sfx:Play(SoundEffect.SOUND_CASTLEPORTCULLIS,1)
			--Make room uncleared
			room:SetClear( false )
		end, 0)
	end
end
function mod:OnNewRunMain()
	rng:SetSeed(game:GetSeeds():GetStartSeed(), 35)

	--mod:DoomsdayOnNewRun()
end

--UNLOCKS-----------------------------------------------------------------------------------------------------------------------------

function mod:OnSlotInit(slot)
	if slot.SubType == mod.EntityInf[mod.Entity.Computer].SUB then
		if not (mod.savedatasettings().UnlockAll or persistentData:Unlocked(Isaac.GetAchievementIdByName("computer (HC)"))) then
			local penny = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, slot.Position, Vector.Zero, nil)
			slot:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, mod.OnSlotInit, mod.EntityInf[mod.Entity.Computer].VAR)