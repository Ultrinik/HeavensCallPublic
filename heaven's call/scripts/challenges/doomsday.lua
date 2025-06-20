local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local music = MusicManager()


function mod:OnDoomsdayChallengeStart()
    if game.Challenge == mod.Challenges.Doomsday then
        mod:OnApocalypseStart(true, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnDoomsdayChallengeStart)