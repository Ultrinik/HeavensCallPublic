local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.Pills = {
    CLAIRVOYANCE = Isaac.GetPillEffectByName("  Clairvoyance  "),
    CLAIRVOYANCE_BAD = Isaac.GetPillEffectByName("  Clarivoyance  "),
    BALLS_UP = Isaac.GetPillEffectByName("  Balls Up   "),
    BALLS_DOWN = Isaac.GetPillEffectByName("  Balls Down   "),
    MARSHMALLOW = Isaac.GetPillEffectByName("Marshmallow!?"),
}


table.insert(mod.PostLoadInits, {"savedatarun", "planetariumPills", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.planetariumPills", 0)
table.insert(mod.PostLoadInits, {"savedatarun", "planetariumPillsPermanent", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.planetariumPillsPermanent", 0)

table.insert(mod.PostLoadInits, {"savedatarun", "ballsPills", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.ballsPills", 0)


--PLANETARIUM

function mod:OnClairvoyanceUse(pill, player, flags, color)

    local n = 1
    if color & PillColor.PILL_GIANT_FLAG > 0 then n = 3 end

    mod.savedatarun().planetariumPillsPermanent = mod.savedatarun().planetariumPillsPermanent + math.ceil(n/2)
    mod.savedatarun().planetariumPills = mod.savedatarun().planetariumPills + n
    
	player:AnimateHappy()
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnClairvoyanceUse, mod.Pills.CLAIRVOYANCE)
function mod:OnPrePlanetariumChance(chance)
    local pills = mod.savedatarun().planetariumPills or 0
    return chance + 0.01 * pills
end
mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_TELESCOPE_LENS, mod.OnPrePlanetariumChance)

function mod:OnClarivoyanceUse(pill, player, flags, color)

    local n = 1
    if color & PillColor.PILL_GIANT_FLAG > 0 then n = 2 end

    game:SetDizzyAmount(0,n*0.35)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
        local position = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true)
        local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, position, Vector.Zero, nil)
    end

	player:AnimateSad()
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnClarivoyanceUse, mod.Pills.CLAIRVOYANCE_BAD)


--BALLS !!!
function mod:OnBallsUpUse(pill, player, flags, color)

	player:AnimateHappy()
    if mod.savedatarun().ballsPills >= 3 then
        return
    end

    local n = 1
    if color & PillColor.PILL_GIANT_FLAG > 0 then n = 2 end

    mod.savedatarun().ballsPills = mod.savedatarun().ballsPills + n

    for i=1, n do
        local moon = mod:ChooseMiniMoon(player)
        if moon ~= -1 then
            player:AddCollectible(moon)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnBallsUpUse, mod.Pills.BALLS_UP)

function mod:OnBallsDownUse(pill, player, flags, color)

    local n = 1
    if color & PillColor.PILL_GIANT_FLAG > 0 then n = 2 end
    
    mod.savedatarun().ballsPills = math.max(0,mod.savedatarun().ballsPills - n)

    for i=1, n do
        local moon = mod:GetRandomHeldMiniMoon(player)
        if moon ~= -1 then
            player:RemoveCollectible(moon)
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
        if not mod.savedatarun().currentStatUps then mod.savedatarun().currentStatUps = {} end
        local playerKey = tostring(mod:PlayerId(player))
        if not mod.savedatarun().currentStatUps[playerKey] then mod.savedatarun().currentStatUps[playerKey] = {DAMAGE = 0, SPEED = 0, TEARS = 0, RANGE = 0, SSPEED = 0, LUCK = 0} end
        mod.savedatarun().currentStatUps[playerKey].DAMAGE = mod.savedatarun().currentStatUps[playerKey].DAMAGE + 0.6*n
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end

	player:AnimateSad()
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnBallsDownUse, mod.Pills.BALLS_DOWN)

--other stuff
function mod:ReplacePillEffect(pillEffect, pillColor)

    local toPositive = mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_LUCKY_FOOT) or mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_PHD) or mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_VIRGO)
    local toNegative = mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_FALSE_PHD)

    if toPositive and not toNegative then
        if pillEffect == mod.Pills.CLAIRVOYANCE_BAD then
            return mod.Pills.CLAIRVOYANCE

        elseif pillEffect == mod.Pills.BALLS_DOWN then
            return mod.Pills.BALLS_UP

        end
        
    elseif toNegative and not toPositive then
        if pillEffect == mod.Pills.CLAIRVOYANCE then
            return mod.Pills.CLAIRVOYANCE_BAD

        elseif pillEffect == mod.Pills.BALLS_UP then
            return mod.Pills.BALLS_DOWN
            
        end
        
    end
end
mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, mod.ReplacePillEffect)

--MARSHMALLOW
function mod:OnMarshmallowUse(pill, player, flags, color)

    if color & PillColor.PILL_GIANT_FLAG > 0 then
        mod.hiddenItemManager:AddForRoom(player, CollectibleType.COLLECTIBLE_BFFS)
    end

    for newMoon=mod.Moons.Ash, mod.Moons.Bramble do
        mod.hiddenItemManager:AddForRoom(player, newMoon)
    end
    mod.hiddenItemManager:AddForRoom(player, mod.Moons.Errant)
    mod:ChangeLilErrantOrbit()
    
	player:AnimateHappy()
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.OnMarshmallowUse, mod.Pills.MARSHMALLOW)