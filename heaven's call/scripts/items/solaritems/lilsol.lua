local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.SolarItemsVars.LilSol = {}

function mod:OnLilSolInit(familiar)
    if familiar.SubType == 0 then
        local data = familiar:GetData()
        local player = familiar.Player
        local sprite = familiar:GetSprite()
        local room = game:GetRoom()

        data.Direction = Vector.FromAngle(360*rng:RandomFloat())

        familiar.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnLilSolInit, mod.EntityInf[mod.Entity.LilSol].VAR)

function mod:OnLilSolUpdate(familiar)

    if familiar.SubType == 0 then
        local data = familiar:GetData()
        local player = familiar.Player
        local sprite = familiar:GetSprite()
        local room = game:GetRoom()
        local child = familiar.Child
        
        if child then
            child.Position = familiar.Position + Vector(0,-15)
            child.Velocity = familiar.Velocity
        else
            local aura = Isaac.Spawn(EntityType.ENTITY_POOP, EntityPoopVariant.HOLY, 0, familiar.Position, Vector.Zero, familiar)
            aura.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            aura.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            aura.HitPoints = 9999
            aura.Visible = false

            --aura:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            aura.Parent = familiar
            familiar.Child = aura
        end

        familiar.Velocity = mod:Lerp(familiar.Velocity, data.Direction * 6.67, 0.05)

        if familiar:CollidesWithGrid() then
            mod:scheduleForUpdate(function()
                data.Direction = familiar.Velocity:Normalized():Rotated(mod:RandomInt(-10,10))
            end, 1, ModCallbacks.MC_POST_RENDER)
        end

        mod.SolarItemsVars.LilSol[mod:PlayerId(player)] = familiar

        local f = 8- 1
        if familiar.FrameCount & f == f then
            local velocity = mod:RandomVector(10)
            local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, familiar.Position, velocity + familiar.Velocity, familiar):ToEffect()
            feather.Visible = false
            feather.SpriteOffset = Vector(0,-15)
            feather.DepthOffset = -100
            feather:GetData().FromFamiliar = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnLilSolUpdate, mod.EntityInf[mod.Entity.LilSol].VAR)

function mod:OnLilSolCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		--Sol
		mod.SolarItemsVars.LilSol = {}
		local numItem = player:GetCollectibleNum(mod.SolarItems.LilSol)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
		
		player:CheckFamiliar(mod.EntityInf[mod.Entity.LilSol].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.LilSol), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.LilSol))
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnLilSolCache)