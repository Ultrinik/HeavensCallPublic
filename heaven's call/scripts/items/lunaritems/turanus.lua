local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@&%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@&%&@@@@@%%&@@@@@@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@&%&@@@@@%%&@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@&%%%%%@@@@@@@&%%%%&@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%&@@&%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%%%%%%&@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@&%%&@@@@@@@@@&%%%%&@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
mod.ItemsVars.activePoopEnts = {}

mod.TuranusConsts = {
    CHANCE_CAP = 0.5,
    LUCK_CAP = 25,

    POOPED_SECONDS = 5,
}

mod.UEnts = {
	[1] = 1, -- Gold
	[2] = 12, -- Corn
	[3] = 13, -- Fire
	[4] = 16, -- Holy
	[5] = 11, -- Rock
	[6] = 15, -- Black
	[7] = 14, -- Poison
}

--UPDATES----------------------------------------------------
function mod:OnUranusPlayerUpdate(player)
	if player:HasCollectible(mod.Items.Uranus) then
		if mod:LuckRoll(player.Luck+2, mod.TuranusConsts.LUCK_CAP, mod.TuranusConsts.CHANCE_CAP) then
			
			local shotDirection = player:GetData().CurrentAttackDirection_HC

            if shotDirection then
				local velocity = -shotDirection*(10+rng:RandomFloat()*10)

				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, velocity, player):ToTear()
				tear:GetData().UranusPoopTear = true
				tear:SetColor(mod.Colors.poop2, 0, 99, true, true)


				tear.Height = tear.Height/4
				tear.FallingSpeed = -20;
				tear.FallingAcceleration = 1.5;
				tear.CollisionDamage = 1

			end
		end
	end
end

--DAMAGE-----------------------------------------------------
function mod:OnUranusHit(entity, _, _, source, _)
    if source.Entity and source.Entity:GetData().UranusPoopTear and mod:IsVulnerableEnemy(entity) then

		local time = 30*mod.TuranusConsts.POOPED_SECONDS

		if source.Entity:ToTear() and source.Entity:ToTear().SpawnerEntity and source.Entity:ToTear().SpawnerEntity:ToPlayer() then
			local player = source.Entity:ToTear().SpawnerEntity:ToPlayer()
			if player:HasTrinket(TrinketType.TRINKET_SECOND_HAND) then
				time = time*2
			end
		end

        mod.ItemsVars.activePoopEnts[entity.InitSeed] = { ent = entity, t = time }
        entity:SetColor(mod.Colors.poop, time, 99, true, true)
		entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)

		if next(mod.ItemsVars.activePoopEnts) ~= nil then
			mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnPoopedUpdate)
			mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnPoopedUpdate)
		end
    end
end

--DEBUFF---------------------------------------------------
--I forgor from where I got this
local next = next
function mod:OnPoopedUpdate()
    if next(mod.ItemsVars.activePoopEnts) ~= nil then
        local cont = game:GetFrameCount() % 3 == 0

        for key, value in pairs(mod.ItemsVars.activePoopEnts) do
            if value.ent:IsDead() or value.t < 1 then
				
				value.ent:ClearEntityFlags(EntityFlag.FLAG_WEAKNESS)

				if value.ent:IsDead() then
					local selection = mod:RandomInt(1,2)
					local position = game:GetRoom():FindFreePickupSpawnPosition(value.ent.Position, 0, true, false)

					local poop
					local player = game:GetPlayer(0)
					if selection <= 1 then
						poop = Isaac.Spawn(EntityType.ENTITY_POOP, 0, 0, position, Vector.Zero, player)
					else
						poop = Isaac.Spawn(EntityType.ENTITY_POOP, mod.UEnts[mod:RandomInt(2,6)], 0, position, Vector.Zero, player)
					end
					poop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
					poop.TargetPosition = poop.Position -- Lock it into place
					poop.Mass = 999
					poop.Parent = player

				elseif value.t < 1 and #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, 0) < 12 then
					local n = mod:RandomInt(-1,3)
					for i=1, n do
						local dip = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, 0, value.ent.Position, Vector.Zero, nil)
					end
				end

                mod.ItemsVars.activePoopEnts[key] = nil
                goto loopend
            end

            mod.ItemsVars.activePoopEnts[key].t = value.t-1

            if not cont then goto loopend end

            if Isaac.CountEntities(nil, 1000, EffectVariant.CREEP_LIQUID_POOP) < 100 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_LIQUID_POOP, 0, value.ent.Position, Vector.Zero, value.ent):ToEffect()
				mod:scheduleForUpdate(function()
					if creep then
						creep:Remove()
					end
				end, 30*10)
            end

            ::loopend::
        end

	else
		mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnPoopedUpdate)
    end
end

--CALLBACKS
function mod:AddTUranusCallbacks()

	mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUranusPlayerUpdate, 0)
	mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnUranusHit)

	if mod:SomebodyHasItem(mod.Items.Uranus) then
		mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnUranusPlayerUpdate, 0)
		mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnUranusHit)
	end
end
mod:AddTUranusCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTUranusCallbacks, mod.Items.Uranus)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTUranusCallbacks)