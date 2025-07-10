local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

include("scripts.items.solaritems.pickups.glassheart")
include("scripts.items.solaritems.pickups.meteors")
include("scripts.items.solaritems.pickups.voidpickups")
include("scripts.items.solaritems.pickups.infinitychest")
include("scripts.items.solaritems.pickups.pills")
include("scripts.items.solaritems.pickups.bismuth")
include("scripts.items.solaritems.pickups.cardfoil")


if FiendFolio then
    include("scripts.items.solaritems.pickups.disc")
else
    local function removeDisc(_, pickup, variant, subtype)
        if not FiendFolio then
            if variant == PickupVariant.PICKUP_TAROTCARD and subtype == Isaac.GetCardIdByName("Retrograde Disc") then
                mod:scheduleForUpdate(function ()
                    if pickup then
                        pickup:Remove()
                    end
                end, 1)
    
                Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, pickup.Position, pickup.Velocity, pickup.SpawnerEntity)
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, removeDisc)
end
