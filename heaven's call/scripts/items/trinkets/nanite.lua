local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local NANITE_CHANCE = 0.0666

function mod:OnNaniteBombInit(bomb)
    if not bomb.SpawnerEntity then return end
    if bomb.Variant >= BombVariant.BOMB_GIGA then return end

	local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
	if player and player:HasTrinket(mod.Trinkets.Nanite) then
        local chance = 1 - (1-NANITE_CHANCE)^player:GetTrinketMultiplier(mod.Trinkets.Nanite)
        if rng:RandomFloat() < chance then
           local giga = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_GIGA, 0, bomb.Position, bomb.Velocity, player):ToBomb()
           
           giga:SetExplosionCountdown(bomb:GetExplosionCountdown())
           giga.ExplosionDamage = math.max(giga.ExplosionDamage,bomb.ExplosionDamage)
           giga.RadiusMultiplier = math.max(giga.RadiusMultiplier,bomb.RadiusMultiplier)
           giga.Flags = bomb.Flags

           giga:GetSprite():ReplaceSpritesheet(0, "hc/gfx/items/pick ups/mars_explosives.png", true)

           bomb:Remove()

           --[[
            --laser
            local ring = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, giga.Position, Vector.Zero, player):ToLaser()
            ring.Parent = giga
            --ring.Radius = 80
            ring.Shrink = true

            ring.Timeout = -1

            ring.DepthOffset = -200
            ring.TargetPosition = giga.Position
            ]]
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.OnNaniteBombInit)