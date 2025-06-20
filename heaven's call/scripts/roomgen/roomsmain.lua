local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local persistentData = Isaac.GetPersistentGameData()

--Room and planet
mod.RoomsPlanet = {
	[8500] = mod.Entity.Jupiter,
	[8501] = mod.Entity.Saturn,
	[8502] = mod.Entity.Uranus,
	[8503] = mod.Entity.Neptune,
	[8504] = mod.Entity.Pluto,

	[8505] = mod.Entity.Mercury,
	[8506] = mod.Entity.Venus,
	[8507] = mod.Entity.Terra1,
	[8508] = mod.Entity.Mars,
	[8509] = mod.Entity.Luna,
	
	[8510] = mod.Entity.Errant,
}

include("scripts.roomgen.newrooms")

include("scripts.roomgen.roomsdata")
include("scripts.roomgen.roomgen")

include("scripts.roomgen.astralchallenge")
include("scripts.roomgen.lunarpact")
include("scripts.roomgen.hyperdice")


include("scripts.roomgen.solarfloor.heavenfloor")
include("scripts.roomgen.solarfloor.levelgen")

function mod:TryToGenerateSpecialRooms()
	if StageAPI then
		mod:scheduleForUpdate(function()
			mod:GenerateRooms()
		end, 3)
	else
		mod:GenerateRooms()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.TryToGenerateSpecialRooms)

function mod:GenerateRooms()
	if (game:IsGreedMode() or game:GetLevel():IsAscent()) then return end

	mod:SolRoomsRoll()
	mod:IRoomsRoll()

	if mod.savedatasettings().UnlockAll or persistentData:Unlocked(Isaac.GetAchievementIdByName("astral_challenge (HC)")) then mod:AstralRoomGenerator() end

	mod:GenerateGoldenRooms()

    game:GetLevel():UpdateVisibility()
end