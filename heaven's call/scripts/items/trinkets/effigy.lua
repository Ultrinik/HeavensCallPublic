local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local EFFIGY_CHANCE = 0.75

function mod:ShouldEffigyBlockCurse()
    local chance = 1 - (1 - EFFIGY_CHANCE)^mod:HowManyTrinkets(mod.Trinkets.Effigy)
    local level = game:GetLevel()

	local _rng = RNG(game:GetSeeds():GetStartSeed(), level:GetStage()+1)
    local r = _rng:RandomFloat()
    if r < chance then
        return true
    end
end

function mod:OnNewLevelCurseEffigy(curses_bit)
    if mod:SomebodyHasTrinket(mod.Trinkets.Effigy) then
        if mod:ShouldEffigyBlockCurse() then
            return 0
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_CURSE_EVAL, CallbackPriority.LATE+100, mod.OnNewLevelCurseEffigy)