local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

function mod:OnLeakedBatteryActiveUse(collectible, rng, player, flags, slot, vardata)
    if (slot and slot~=-1) and player:HasTrinket(mod.Trinkets.Battery) then
        local charge = player:GetActiveCharge(slot)
        local held_collectible = player:GetActiveItem(slot)

        if collectible == held_collectible and 0 <= charge and charge <= 12 then
            for i=1, charge*player:GetTrinketMultiplier(mod.Trinkets.Battery) do

                local color
                if i&1==0 then
                    color = mod.Colors.jupiterLaser2
                else
                    color = mod.Colors.jupiterLaser3
                end

                local fly = player:AddBlueFlies(1, player.Position, nil)
                fly:SetColor(color, -1, 1, true, true)
                fly.SpriteOffset = Vector(0,12)
                fly:Update()

                --laser
                local ring = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, fly.Position, Vector.Zero, player):ToLaser()
                ring:GetData().FromBatteryAcid = true

                ring.CollisionDamage = fly.CollisionDamage*1.5
                ring.Parent = fly
                ring.Radius = 30
                ring.Shrink = true
    
                ring.Timeout = -1
    
                ring.DepthOffset = -200
                ring.TargetPosition = fly.Position

                ring:SetColor(color, -1, 1, true, true)

                ring:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnLeakedBatteryActiveUse)

function mod:OnLeakedBatteryNewRoom()
    for i, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT)) do
        if laser:GetData().FromBatteryAcid and laser.Parent then
            for j=1,8 do
                laser.Position = laser.Parent.Position
                laser:Update()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnLeakedBatteryNewRoom)