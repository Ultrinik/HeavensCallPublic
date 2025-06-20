local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

function mod:CheckSlotContact(slot, triggerFunction)
    for i=0, game:GetNumPlayers ()-1 do
        local player = game:GetPlayer(i):ToPlayer()
        if player.Position:Distance(slot.Position) <= player.Size + slot.Size then
            triggerFunction(_, slot, player)
        end
    end
end


--Callbacks
function mod:SlotsOnNewRoom()

    mod:TelescopeReplacement()
	mod:TitanReplacement()
	mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnBismuthRender)

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SlotsOnNewRoom)
mod:scheduleForUpdate(function()
	mod:SlotsOnNewRoom()
end, 1)

include("scripts.slots.telescope")
include("scripts.slots.computer.computer")
include("scripts.slots.titan")