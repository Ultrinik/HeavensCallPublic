local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%&@@@@@@@&%%%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.ItemsVars.jupiterSets = {}
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ItemsVars.jupiterSets", {})
mod.ModFlags.jupiterLocked = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ModFlags.jupiterLocked", false)

mod.TjupiterConsts = {

    ZAP_MIN_DISTANCE = 30
}

--Updates------------------------------------------
function mod:OnJupiterPlayerUpdate(player)
	if player:HasCollectible(mod.Items.Jupiter) then

		if Input.GetActionValue(ButtonAction.ACTION_BOMB, player.ControllerIndex) > 0 and not mod.ModFlags.jupiterLocked then
			mod.ModFlags.jupiterLocked = true
			mod:scheduleForUpdate(function()
				mod.ModFlags.jupiterLocked = false

				mod.ItemsVars.jupiterSets[mod:PlayerId(player)] = {}
			end, 30)

			mod:JupiterContact(player, #mod.ItemsVars.jupiterSets[mod:PlayerId(player)], true)
		end

		if game:GetFrameCount() % 6 == 0 then

			if mod.ModFlags.jupiterLocked then return end

			mod.ItemsVars.jupiterSets[mod:PlayerId(player)] = mod.ItemsVars.jupiterSets[mod:PlayerId(player)] or {}

			--Crate new laser
			mod:CreateNewJupiterLaser(player)

			local jupiterSets = mod.ItemsVars.jupiterSets[mod:PlayerId(player)]
			local nLasers = #jupiterSets

			if nLasers > 3 then

				local contactFlag = false
				local index_contacted_volt

				local segment1A = jupiterSets[nLasers - 1]
				local segment1B = jupiterSets[nLasers - 0]
				for i = 2, nLasers - 2 do

					local segment2A = jupiterSets[i - 0]
					local segment2B = jupiterSets[i - 1]

					contactFlag = mod:intersect(segment1A, segment1B, segment2A, segment2B)
					if contactFlag then
						index_contacted_volt = i-1
						break
					end
				end

				if contactFlag then
					mod:JupiterContact(player, index_contacted_volt)
				end
			end
		end
	end
end

--Main stuff-------------------------------------
function mod:DistanceFromLastVolt(player, playerPos)
    
    local laserSet = mod.ItemsVars.jupiterSets[mod:PlayerId(player)]
    local nLasers = #laserSet

	if nLasers == 0 then return 999 end

	local lastVoltPos = laserSet[nLasers]

	return lastVoltPos:Distance(playerPos)
end

function mod:CreateNewJupiterLaser(player)
	local playerPos = player.Position

	if mod:DistanceFromLastVolt(player, playerPos) > mod.TjupiterConsts.ZAP_MIN_DISTANCE then

        local laserSet = mod.ItemsVars.jupiterSets[mod:PlayerId(player)]

		table.insert(laserSet, playerPos)
        local nLasers = #laserSet

		if nLasers > 1 then
			local laserPos = laserSet[nLasers - 1]
			local laserAngle = (laserPos - playerPos):GetAngleDegrees()
			local laser = EntityLaser.ShootAngle(mod.EntityInf[mod.Entity.JupiterLaser].VAR, playerPos, laserAngle, 120, Vector.Zero, player)
			laser.MaxDistance = playerPos:Distance(laserPos)
			laser.DisableFollowParent = true
			laser.CollisionDamage = 0
			laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			laser:SetOneHit(true)
			laser.EndPoint = laser.Position

		end
	end
end

function mod:JupiterContact(player, index_contacted_volt, fromBomb)

	for _, laser in ipairs(mod:FindByTypeMod(mod.Entity.JupiterLaser)) do
		if laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer() and mod:ComparePlayer(player, laser.SpawnerEntity:ToPlayer()) then
			laser:Remove()
		end
	end

    local laserSet = mod.ItemsVars.jupiterSets[mod:PlayerId(player)] or {}
    local nLasers = #laserSet

	if not fromBomb then
		sfx:Play(SoundEffect.SOUND_LASERRING_STRONG)

		for i=2, nLasers-1 do
			local point1 = laserSet[i]
			local point2 = laserSet[i%nLasers+1]

			local angle = (point1 - point2):GetAngleDegrees()
			local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, point2, angle, 10, Vector.Zero, player)
			laser.MaxDistance = (point1 - point2):Length()
			laser.DisableFollowParent = true
			laser:GetSprite().Color = mod.Colors.jupiterLaser2

		end
		
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			local tipo = entity.Type
			if (tipo ~= EntityType.ENTITY_EFFECT) and ((EntityType.ENTITY_PICKUP <= tipo and tipo <= EntityType.ENTITY_SLOT) or tipo >= EntityType.ENTITY_GAPER) then
				local isInside = mod:PointInPoly(laserSet, entity.Position, index_contacted_volt)
				if isInside then
					mod:ElectrifyEntity(entity, player)
				end
			end
		end

		local p1 = laserSet[nLasers-1]
		local p2 = laserSet[nLasers-2]

		mod.ItemsVars.jupiterSets[mod:PlayerId(player)] = {}
		table.insert(mod.ItemsVars.jupiterSets[mod:PlayerId(player)], p2)
		table.insert(mod.ItemsVars.jupiterSets[mod:PlayerId(player)], p1 + Vector(0.1,0))

	else
		sfx:Play(SoundEffect.SOUND_BATTERYDISCHARGE, 2,2,false, 2)
	end
end

--In circle stuff-----------------------
function mod:ccw(A,B,C)
    return (C.Y-A.Y) * (B.X-A.X) > (B.Y-A.Y) * (C.X-A.X)
end

-- Return true if line segments AB and CD intersect
function mod:intersect(A,B,C,D)
    return mod:ccw(A,C,D) ~= mod:ccw(B,C,D) and mod:ccw(A,B,C) ~= mod:ccw(A,B,D)
end

function mod:PointInPoly(full_polygon, position, start_point)
	local polygon = {}
	for index, t in ipairs(full_polygon) do
		if index >= start_point then
			table.insert(polygon, full_polygon[index])
		end
	end
	table.remove(polygon, #polygon)

	local nPoints = #polygon
    local isInside = false
    local prevIndex = nPoints

    for i = 1, nPoints do
        local pi = polygon[i]
        local pj = polygon[prevIndex]
        if ((pi.Y > position.Y) ~= (pj.Y > position.Y)) and
           (position.X < (pj.X - pi.X) * (position.Y - pi.Y) / (pj.Y - pi.Y) + pi.X) then
            isInside = not isInside
        end
        prevIndex = i
    end

    return isInside
end

function mod:JupiterLaserUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.JupiterLaser].SUB then

		entity:SetDamageMultiplier(0.001)

		if entity.Timeout == 1 then
			entity.Timeout = 0
			entity:Remove()

			local player = entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer()
			if player then
				table.remove(mod.ItemsVars.jupiterSets[mod:PlayerId(player)], 1)
			end
		end
	end
end

--Others---------------------------------
function mod:ElectrifyEntity(entity, player)
	local function SpawnThunder(position)
		position = position or entity.Position
		local thunder = mod:SpawnEntity(mod.Entity.Thunder, position, Vector.Zero, player)
		thunder:GetSprite().PlaybackSpeed = 2
		thunder.CollisionDamage = 100

		return thunder
	end

	if mod:IsVulnerableEnemy(entity) then
		SpawnThunder()
		for i=1, 5 do
			local position = entity.Position + Vector(rng:RandomFloat()*100, 0):Rotated(rng:RandomFloat() * 360)
			SpawnThunder(position)
		end

	elseif entity.Type == EntityType.ENTITY_SLOT then
		local valid = mod:IsSlotAMachine(entity)
		if valid then
			SpawnThunder():GetSprite().PlaybackSpeed = 4

			if rng:RandomFloat() < 0.25 then
				entity.Velocity = Vector(rng:RandomFloat()*10, 0):Rotated(rng:RandomFloat() * 360)
				game:BombExplosionEffects (entity.Position, 0, TearFlags.TEAR_NORMAL, mod.Colors.jupiterLaser2, nil, 1, true, false, DamageFlag.DAMAGE_EXPLOSION )
			else
				mod:TriggerSlotMachine(entity, player)
			end
		end

	elseif entity.Type == EntityType.ENTITY_SHOPKEEPER then
		SpawnThunder():GetSprite().PlaybackSpeed = 4

		mod:scheduleForUpdate(function()
			if not entity then return end
			local keeper
			if rng:RandomFloat() < 0.5 then
				keeper = Isaac.Spawn(EntityType.ENTITY_KEEPER, 0, 0, entity.Position, Vector.Zero, player)
				keeper:AddCharmed(EntityRef(player), -1)
			else
				keeper = Isaac.Spawn(EntityType.ENTITY_HANGER, 0, 0, entity.Position, Vector.Zero, player)
				keeper:AddCharmed(EntityRef(player), -1)

			end

			mod:scheduleForUpdate(function()
				if not keeper then return end
				for _, f in ipairs(Isaac.FindByType(EntityType.ENTITY_ETERNALFLY)) do
					if f.Parent == keeper then
						f:Die()
					end
				end
			end, 2)

			entity:Die()
		end, 5)

		
	elseif entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_LIL_BATTERY then
		SpawnThunder():GetSprite().PlaybackSpeed = 4

		mod:scheduleForUpdate(function()
			if not entity then return end
			local random = rng:RandomFloat()
			entity = entity:ToPickup()

			if entity.SubType == BatterySubType.BATTERY_MICRO and random < 0.80 then
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL, true, true)
			elseif entity.SubType == BatterySubType.BATTERY_NORMAL and random < 0.40 then
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MEGA, true, true)
			elseif entity.SubType == BatterySubType.BATTERY_MEGA and random < 0.20 then
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_GOLDEN, true, true)
			elseif entity.SubType == BatterySubType.BATTERY_GOLDEN and random < 0.10 then
				local items = {CollectibleType.COLLECTIBLE_9_VOLT, CollectibleType.COLLECTIBLE_CAR_BATTERY, CollectibleType.COLLECTIBLE_BATTERY, CollectibleType.COLLECTIBLE_BATTERY_PACK, CollectibleType.COLLECTIBLE_4_5_VOLT, CollectibleType.COLLECTIBLE_CHARGED_BABY, mod.SolarItems.Battery}
				local item = items[mod:RandomInt(1, #items)]
				local position = entity.Position
				entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, true, true)
				entity.Position = position
			else
				entity:Remove()
				game:BombExplosionEffects (entity.Position, 0, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.6, true, false, DamageFlag.DAMAGE_EXPLOSION)
			end
		end, 5)
	end
end

function mod:TriggerSlotMachine(slot, player)

	mod.ModFlags.jupiterLocked = true
	mod:scheduleForUpdate(function()
		mod.ModFlags.jupiterLocked = false
		mod.ItemsVars.jupiterSets[mod:PlayerId(player)] = {}
	end, 5)


	local coins = player:GetNumCoins()
	player:AddCoins(5)

	local oldPos = player.Position
	player:GetData().Invulnerable_HC = true

	player.Position = slot.Position

	mod:scheduleForUpdate(function()
		player.Position = oldPos
		player:AddCoins(-999)
		player:AddCoins(coins)
		player:GetData().Invulnerable_HC = false
	end, 2)

end

--CALLBACKS
function mod:AddTJupiterCallbacks()

	mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnJupiterPlayerUpdate, 0)
	mod:RemoveCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.JupiterLaserUpdate, mod.EntityInf[mod.Entity.JupiterLaser].VAR)

	if mod:SomebodyHasItem(mod.Items.Jupiter) then
		mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnJupiterPlayerUpdate, 0)
		mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.JupiterLaserUpdate, mod.EntityInf[mod.Entity.JupiterLaser].VAR)
	end
end
mod:AddTJupiterCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTJupiterCallbacks, mod.Items.Jupiter)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTJupiterCallbacks)