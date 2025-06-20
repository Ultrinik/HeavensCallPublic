local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

mod.Challenges = {
    BabelTower = Isaac.GetChallengeIdByName("[HC] Tower of Babel"),
    SolarSystem = Isaac.GetChallengeIdByName("[HC] True Solar System"),
    Doomsday = Isaac.GetChallengeIdByName("[HC] Doomsday!"),
    Everchanger = Isaac.GetChallengeIdByName("[HC] Escape the Everchanger"),
    Omnitricked = Isaac.GetChallengeIdByName("[HC] Omnitricked"),
}

function mod:IsChallenge(challenge)
    return game.Challenge == challenge
end

function mod:InitializeChallenge()

    mod:ContinueChallenge()

    if mod:IsChallenge(mod.Challenges.BabelTower) then
        mod:OnGauntletStart()

    elseif mod:IsChallenge(mod.Challenges.SolarSystem) then
        mod:OnSolarSystemStart()

    elseif mod:IsChallenge(mod.Challenges.Doomsday) then
        --mod:OnDoomsdayChallengeStart()

    elseif mod:IsChallenge(mod.Challenges.Everchanger) then


    elseif mod:IsChallenge(mod.Challenges.Omnitricked) then


    end
end

function mod:ContinueChallenge()

    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnTransitionRoomEnter)
    
    if mod:IsChallenge(mod.Challenges.BabelTower) then
        mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnTransitionRoomEnter)

    elseif mod:IsChallenge(mod.Challenges.SolarSystem) then

    elseif mod:IsChallenge(mod.Challenges.Doomsday) then

    elseif mod:IsChallenge(mod.Challenges.Everchanger) then

    elseif mod:IsChallenge(mod.Challenges.Omnitricked) then


    end
end


include("scripts.challenges.astralgauntlet")
include("scripts.challenges.solarsystem")
include("scripts.challenges.doomsday")
include("scripts.challenges.errantchallenge.everchangermain")
