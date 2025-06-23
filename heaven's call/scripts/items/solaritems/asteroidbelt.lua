local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()



function mod:OnAsteroidBeltUpdate(player)
    if player:HasCollectible(mod.SolarItems.AsteroidBelt) then
        if Isaac:GetFrameCount() % 10 == 0 then
            mod:SpawnPickupsFamiliars(player)

        end
    end
end

function mod:GetPickupFamiliarAmount(player)
    local nBelts = 0
    for i=0, game:GetNumPlayers ()-1 do
        local checkPlayer = Isaac.GetPlayer(i)
        if checkPlayer then
            if checkPlayer:HasCollectible(mod.SolarItems.AsteroidBelt) then
                nBelts = nBelts + 1
            end
        end
    end

    local coins = math.ceil(player:GetNumCoins() / nBelts)
    local bills = coins
    coins = (coins >= 99 and 5) or math.floor(coins/20)
    bills = bills - (coins*20-1)
    bills = math.max(0,math.floor(bills/100))

    local keys = math.ceil(player:GetNumKeys() / nBelts)
    keys = (keys >= 99 and 5) or math.floor(keys/20)

    local bombs = math.ceil(player:GetNumBombs() / nBelts)
    bombs = (bombs >= 99 and 5) or math.floor(bombs/20)

    return {coins, keys, bombs, bills}
end

function mod:SpawnPickupsFamiliars(player)
    local numFamiliars = mod:GetPickupFamiliarAmount(player)
    if not player:HasCollectible(mod.SolarItems.AsteroidBelt) then numFamiliars = {0,0,0,0} end

    local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

    for i=1, 4 do
        local baseNum = numFamiliars[i]*player:GetCollectibleNum(mod.SolarItems.AsteroidBelt)
        
        local finalNum = (baseNum > 0 and (baseNum + boxUses) or 0)
        
        local subtype = i-1
        player:CheckFamiliar(mod.EntityInf[mod.Entity.PickupFamiliar].VAR, finalNum, player:GetCollectibleRNG(mod.SolarItems.AsteroidBelt), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.AsteroidBelt), subtype)

    end
end

function mod:OnAsteroidBeltCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
        if player:HasCollectible(mod.SolarItems.AsteroidBelt) then
            mod:SpawnPickupsFamiliars(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnAsteroidBeltCache)

------------------------------------------------------------------------------------------------------------
--Familiars-------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

mod.PickupSpeeds = {
	[0] = 0.02,
	[1] = -0.04, 
	[2] = 0.06,
	[3] = -0.08,
}
mod.PickupOrbits = {
    [0] = 30,
    [1] = 60,
    [2] = 90,
    [3] = 120
}
mod.PickupOrbitsIds = {
    [0] = 60,
    [1] = 61,
    [2] = 62,
    [3] = 63
}

function mod:OnFamiliarPickupUpdate(familiar)
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local data = familiar:GetData()

    data.Deactivated = data.Deactivated and math.max(-1, data.Deactivated - 1) or 0
    if data.Deactivated == 0 then
        familiar.Visible = true
    end

    if player then

        familiar.Velocity = familiar:GetOrbitPosition(player.Position + player.Velocity) - familiar.Position
        familiar.OrbitSpeed = mod.PickupSpeeds[familiar.SubType]
        familiar.OrbitDistance = Vector.One * mod.PickupOrbits[familiar.SubType]
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnFamiliarPickupUpdate, mod.EntityInf[mod.Entity.PickupFamiliar].VAR)

function mod:OnFamiliarPickupInit(familiar, flag)

    familiar:AddToOrbit(mod.PickupOrbitsIds[familiar.SubType])

    familiar:GetData().Deactivated = 0

	local sprite = familiar:GetSprite()
	sprite:Play("Idle")
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnFamiliarPickupInit, mod.EntityInf[mod.Entity.PickupFamiliar].VAR)

function mod:OnFamiliarPickupCollision(familiar, collider)
    if familiar.SubType == 0 or familiar.SubType == 1 then
        mod:FamiliarProtection(familiar, collider)
        
    elseif familiar.SubType == 2 and familiar:GetData().Deactivated <= 0 and mod:IsVulnerableEnemy(collider) then
        familiar:GetData().Deactivated = 450
        familiar.Visible = false

        --Explosion:
        local scale = 0.33
        local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
        explosion.DepthOffset = 10
        explosion.SpriteScale = Vector.One*scale
    
        --Explosion damage
        local damage = 50
        for i, e in ipairs(Isaac.FindInRadius(familiar.Position, 25)) do
            if e.Type ~= EntityType.ENTITY_PLAYER then
                e:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION, EntityRef(familiar), 0)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.OnFamiliarPickupCollision, mod.EntityInf[mod.Entity.PickupFamiliar].VAR)

--CALLBACKS
function mod:AddAsteroidsCallbacks()
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnAsteroidBeltUpdate)

	if mod:SomebodyHasItem(mod.SolarItems.AsteroidBelt) then
        mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnAsteroidBeltUpdate)
	end
end
mod:AddAsteroidsCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddAsteroidsCallbacks, mod.SolarItems.AsteroidBelt)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddAsteroidsCallbacks)