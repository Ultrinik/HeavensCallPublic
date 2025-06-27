local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/****//*/((&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#/**/*.*,/**/*//((&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&%%%&&&&&%&&&&&&&&&#/(/(#%%#%&%(###%%&#%#%&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&@&%#%#(##(##(*/(*,*/,**(./,***/*/##/####%%%&%%%&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&@@##%##%####(#(((((((%%#####&&&&#%((,/,*/***(*(/((%&%&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&%%%%%%%%#%%%##%%###((%#((////(*(///###%&&%%/(//(/(##&&&&&&&&&&&&&&&&&&&&&
&&&&&&&%%%#%##%%#%(###(%(%#((%##(##(%/%(/((*/*(/***/(&@@&%/(#(#&&&&&&&&&&&&&&&&&
&&&&&&&&&&%##%###(#(/##((((///%//#(**/*#((//((((%(((/((/(//%#(&@@%#&&&&&&&&&&&&&
&&&&&&&&&&&&&&&########&&&@@@@@&&@@&(((/(/**(*/,,*(*/#/((#%##((((((##%@&&&&&&&&&
&&&&&&&&&&&&&&&&&&@&&&&&&&&&%###(###%&&&&%%#(((((//////(////(###########&@&&&&&&
&&&&&&&&&&&&&&&&&&&&&&%%&&&&&#%@&&%##(&@@@#((&&@&%(((((#////(/((((/#%%%(%&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%%@%%&@@@@%&&%&&&%(((#(#(((#&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%%&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
]]

mod.SolarItemsVars.MothershipTargets = {}
mod.SolarItemsVars.InfectedEnts = {}
mod.SolarItemsVars.MothershipNeeds = {[1]=false,[2]=false,[3]=false,[4]=false}
mod.SolarItemsVars.MothershipNeeded = false

mod.MothershipOverwriteChance = 0.04

--INITS-------------------------------------------
function mod:OnMothershipInit(familiar)
    familiar.IsFollower = true
	--familiar:AddToFollowers()

	local sprite = familiar:GetSprite()
	sprite:Play("Idle", true)
	--sprite.PlaybackSpeed = 0.5

	mod:MothershipOnNewRoom()
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnMothershipInit, mod.EntityInf[mod.Entity.Mothership].VAR)

--UPDATES------------------------------------------
function mod:MothershipUpdate(familiar)
	if familiar.SubType == 0 then
		local sprite = familiar:GetSprite()
		local data = familiar:GetData()
		local room = game:GetRoom()

		familiar:PickEnemyTarget(1000, 13, 1+2+16)
		local target = familiar.Target

		if not data.Init then
			data.Init = true

			data.targetvelocity = Vector.Zero
			data.TargetPosition = Vector.Zero
			data.idlePos = familiar.Player.Position + mod:RandomVector(40,120)

			data.Charges = 0
			data.Shields = 0

		end

		if sprite:IsEventTriggered("finished") or sprite:IsFinished() then
			data.idlePos = familiar.Player.Position + mod:RandomVector(40,120)

			sprite:Play("Attack", true)

				
			if data.ModuleLevel>2 and data.PistolEnabled and target and not mod:IsOutsideRoom(familiar.Position, room) then

				local direction = (target.Position - familiar.Position):Normalized()

				--local rocket = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_ROCKET, 0, familiar.Position, direction*5, familiar):ToBomb()
				local rocket = mod:SpawnEntity(mod.Entity.MarsRocket, familiar.Position, direction*5, familiar):ToBomb()
				rocket.ExplosionDamage = 0
				rocket.RadiusMultiplier = 0.75757575

				rocket:GetData().IsDirected_HC = true
				rocket:GetData().Direction = direction
				if direction.X > 0 then 
					rocket:GetSprite().FlipX = true 
				end
			end
		end

		if sprite:IsEventTriggered("attack") then
			
			if data.PistolEnabled then
				local flag = data.ModuleLevel>1 or familiar.FrameCount%2==0
				
				if flag and target then
					if target.Position:Distance(familiar.Position) < 500 then

						local direction = (target.Position - familiar.Position):Normalized()
						local speed = 6
						local damage = 2
						local flags = TearFlags.TEAR_NORMAL
						if data.ModuleLevel>1 then 
							speed = 9
							damage = 4
							flags = TearFlags.TEAR_SPECTRAL
						end

						local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position + Vector(-15,-15), direction*speed, familiar):ToTear()
						if tear then
							tear.Color = mod.Colors.red

							tear.CollisionDamage = damage
							tear.Velocity = tear.Velocity:Rotated(mod:RandomInt(-5,5))*(0.8 + rng:RandomFloat()*0.6)
							tear:AddTearFlags(flags)
							
							local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, tear.Position, tear.Velocity, nil):ToEffect()
							if energy then
								energy.LifeSpan = 1000
								energy.Parent = tear
								energy.DepthOffset = 5
								--energy:GetSprite().Color = mod.Colors.greenEden
								energy:GetData().HeavensCall = true
								energy:GetData().MarsShot_HC = true
								energy:FollowParent(tear)
							end
						end
					end
				end

			end

		end

		if data.InceminatorEnabled then
			familiar:PickEnemyTarget(1000, 13, 1+2+8+16)
			target = familiar.Target

			if target and target.HitPoints > 7 and sprite:IsPlaying("Attack") and sprite:GetFrame()==1 and rng:RandomFloat() < 0.5 and #mod:FindByTypeMod(mod.Entity.AlienCharger) < 12 then
				
				local someInfected = false

				for _, ent in ipairs(Isaac.GetRoomEntities()) do
					if ent and mod.SolarItemsVars.InfectedEnts[ent.InitSeed] then
						someInfected = true
						break
					end
				end

				if not someInfected then
					local direction = (target.Position+ Vector(0,-15)) - familiar.Position

					local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, familiar.Position + Vector(15,-15), direction:GetAngleDegrees(), 1, Vector.Zero, familiar)
					laser.MaxDistance = direction:Length()
					--laser:GetSprite().Color = mod.Colors.greenEden
					laser.CollisionDamage = 3.5


					mod.SolarItemsVars.InfectedEnts[target.InitSeed] = { ent = target, play = familiar.Player, lev = data.ModuleLevel }

					if target:IsBoss() then
						target:SetColor(mod.Colors.infected, 300, 99, true, true)
						mod:scheduleForUpdate(function()
							if not target then return end
							mod.SolarItemsVars.InfectedEnts[target.InitSeed] = nil
						end, 300)
					else
						target:SetColor(mod.Colors.infected, -1, 99, true, true)
					end

					if data.ModuleLevel>=2 then
						--laser:AddTearFlags(TearFlags.TEAR_CHARM)
						target:AddEntityFlags(EntityFlag.FLAG_CHARM)
					end
				end
			end
		end
		if data.PenetratorEnabled then
			if data.AbleToChange then
				data.AbleToChange = false
				if data.CurrentIndex ~= (data.FinalIndex+1) then
					data.TargetPosition = mod.SolarItemsVars.MothershipTargets[data.CurrentIndex]
					data.CurrentIndex = data.CurrentIndex + 1
				else
					data.TargetPosition = Vector.Zero
				end
				
			end
		end
		if data.ProtectorEnabled then
			if data.ModuleLevel == 1 then
				if data.Charges >= 5 and data.Shields < 1 then
					data.Charges = data.Charges - 5
					data.Shields = math.min(1,data.Shields+1)
				end
			elseif data.ModuleLevel == 2 then
				if data.Charges >= 3 and data.Shields < 1 then
					data.Charges = data.Charges - 3
					data.Shields = math.min(1,data.Shields+1)
				end
			else
				if data.Charges >= 3 and data.Shields < 2 then
					data.Charges = data.Charges - 3
					data.Shields = math.min(2,data.Shields+1)
				end
			end
		end

		mod:MothershipMove(familiar, data, room, data.idlePos, target)
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.MothershipUpdate, mod.EntityInf[mod.Entity.Mothership].VAR)

function mod:MothershipCollision(familiar, collider, collision)
	local data = familiar:GetData()
	if data.ProtectorEnabled and data.ModuleLevel >= 2 then
		mod:FamiliarProtection(familiar, collider, collision)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.MothershipCollision, mod.EntityInf[mod.Entity.Mothership].VAR)
--Move
function mod:MothershipMove(entity, data, room, idlePos, target)

	local actualTarget = data.TargetPosition and data.TargetPosition:Length() > 0
	local speed = 1

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = 1
		
		if actualTarget then
			data.targetvelocity = (data.TargetPosition - entity.Position):Normalized()*2
			if data.TargetPosition:Distance(entity.Position) < 5 then
				data.AbleToChange = true
				game:BombExplosionEffects ( entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.25, true, false, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_FAKE )
			end
			speed = 1.5

		else
			data.idleTime = mod:RandomInt(45, 90)

			--distance of Saturn from the center of the room
			local distance = 0.95*(room:GetCenterPos().X-entity.Position.X)^2 + 2*(room:GetCenterPos().Y-entity.Position.Y)^2
			--If its too far away, return to the center
			if distance > 200^2 and not target then
				data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
			--Else, get closer to the player
			else
				local pos = idlePos
				if target then
					speed = 2.5
					pos = target.Position
				end
				data.targetvelocity = ((pos - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
			end
		end
	end

	--If run out of idle time
	if data.idleTime <= 0 and data.idleTime ~= nil then
		data.idleTime = nil
	else
		data.idleTime = data.idleTime - 1
	end

	--Do the actual movement

	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * speed
	data.targetvelocity = data.targetvelocity * 0.99
end

--CACHE---------------------------------------------------
function mod:OnMotherShipCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		local numItem = math.min(1, player:GetCollectibleNum(mod.SolarItems.Mothership_01)+player:GetCollectibleNum(mod.SolarItems.Mothership_02)+player:GetCollectibleNum(mod.SolarItems.Mothership_03)+player:GetCollectibleNum(mod.SolarItems.Mothership_04))
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)

		player:CheckFamiliar(mod.EntityInf[mod.Entity.Mothership].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Mothership_01), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Mothership_01))
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Mothership].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Mothership_02), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Mothership_02))
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Mothership].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Mothership_03), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Mothership_03))
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Mothership].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Mothership_04), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Mothership_04))

		mod:scheduleForUpdate(function()
			if not player then return end

			for _, mother in ipairs(mod:FindByTypeMod(mod.Entity.Mothership)) do
				mother = mother:ToFamiliar()
				local sprite = mother:GetSprite()

				for i=2, 6 do
					sprite:ReplaceSpritesheet(i, "")
				end

				if player:GetCollectibleRNG(1):GetSeed() == mother.Player:GetCollectibleRNG(1):GetSeed() then
					local level = 0
					local changeFlag = false
					if mod:GetSomeMothership(player, mod.SolarItems.Mothership_01) then
						ogVal = mother:GetData().InceminatorEnabled
						mother:GetData().InceminatorEnabled = true
						if ogVal ~= mother:GetData().InceminatorEnabled then changeFlag = true end
						level = level+1
						sprite:ReplaceSpritesheet(5, "hc/gfx/familiar/mothership_ufo.png")
					else
						mother:GetData().InceminatorEnabled = false
					end
					if mod:GetSomeMothership(player, mod.SolarItems.Mothership_02) then
						ogVal = mother:GetData().PistolEnabled
						mother:GetData().PistolEnabled = true
						if ogVal ~= mother:GetData().PistolEnabled then changeFlag = true end
						level = level+1
						sprite:ReplaceSpritesheet(2, "hc/gfx/familiar/mothership_ufo.png")
					else
						mother:GetData().PistolEnabled = false
					end
					if mod:GetSomeMothership(player, mod.SolarItems.Mothership_03) then
						ogVal = mother:GetData().PenetratorEnabled
						mother:GetData().PenetratorEnabled = true
						if ogVal ~= mother:GetData().PenetratorEnabled then changeFlag = true end
						level = level+1
						sprite:ReplaceSpritesheet(4, "hc/gfx/familiar/mothership_ufo.png")
					else
						mother:GetData().PenetratorEnabled = false
					end
					if mod:GetSomeMothership(player, mod.SolarItems.Mothership_04) then
						ogVal = mother:GetData().ProtectorEnabled
						mother:GetData().ProtectorEnabled = true
						if ogVal ~= mother:GetData().ProtectorEnabled then changeFlag = true end
						level = level+1
						sprite:ReplaceSpritesheet(3, "hc/gfx/familiar/mothership_ufo.png")
					else
						mother:GetData().ProtectorEnabled = false
					end

					mother:GetData().ModuleLevel = level
					if level == 4  then
						sprite:ReplaceSpritesheet(6, "hc/gfx/familiar/mothership_ufo.png")
					end
					if changeFlag then
						mother:SetColor(mod.Colors.hyperred, 10, 1, true, true)
						sfx:Play(Isaac.GetSoundIdByName("missileBoxOpen"))
					end
					level = math.min(3,level)
				end
				sprite:LoadGraphics()

				mod:FillMothershipRequierements()
			end	
		end,1)
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnMotherShipCache)

--NEW ROOM-------------------------------------
function mod:MothershipOnNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()

	local mothers = mod:FindByTypeMod(mod.Entity.Mothership)
	if not mothers[1] then return end

	local mother = mothers[1]

	mod.SolarItemsVars.InfectedEnts = {}

	if mother:GetData().PenetratorEnabled then
		local size = room:GetGridSize()
		local index = 0
		local data = mother:GetData()

        mod.SolarItemsVars.MothershipTargets = {}

		--Spiked rocks
		if data.ModuleLevel >= 2 then

			for i = 0, size do
				local grid = room:GetGridEntity(i)
				if grid then
					if grid:GetType() == GridEntityType.GRID_ROCK_SPIKED  and grid.State~=2 then

						index = index + 1
						mod.SolarItemsVars.MothershipTargets[index] = grid.Position

					end
				end
			end

		end

		--Cool rocks
		if data.ModuleLevel >= 1 then

			for i = 0, size do
				local grid = room:GetGridEntity(i)
				if grid then
					if grid.State~=2 and (grid:GetType() == GridEntityType.GRID_ROCKT or 
					grid:GetType() == GridEntityType.GRID_ROCK_ALT2 or 
					grid:GetType() == GridEntityType.GRID_ROCK_GOLD or 
					grid:GetType() == GridEntityType.GRID_ROCK_SS) then

						index = index + 1
						mod.SolarItemsVars.MothershipTargets[index] = grid.Position

					end
					
					if grid:GetType() == GridEntityType.GRID_ROCK_SS then

						index = index + 1
						mod.SolarItemsVars.MothershipTargets[index] = grid.Position

					end
				end
			end

		end

		if data.ModuleLevel >= 2 then

			local room = game:GetRoom()
			local level = game:GetLevel()

			for i = 0, DoorSlot.NUM_DOOR_SLOTS-1 do
				local door = room:GetDoor(i)
				if door then
					if (door:GetSprite():GetAnimation() == "Hidden") and ((door.TargetRoomType == RoomType.ROOM_SECRET or door.TargetRoomType == RoomType.ROOM_SUPERSECRET) or
					(room:GetType() == RoomType.ROOM_SECRET or room:GetType() == RoomType.ROOM_SUPERSECRET)) then
						index = index + 1
						mod.SolarItemsVars.MothershipTargets[index] = door.Position

					end
				end
			end

			local currentroomdesc = level:GetCurrentRoomDesc()
			if not (currentroomdesc.Data and currentroomdesc.Data.Type == RoomType.ROOM_CHALLENGE) then
				
				for _, bishop in ipairs(Isaac.FindByType(EntityType.ENTITY_BISHOP)) do
					index = index + 1
					mod.SolarItemsVars.MothershipTargets[index] = bishop.Position
				end

				for _, chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMBCHEST, ChestSubType.CHEST_CLOSED)) do
					index = index + 1
					mod.SolarItemsVars.MothershipTargets[index] = chest.Position
				end
			end
			

		end

		if data.ModuleLevel >= 3 then
			local grid = room:GetGridEntity(room:GetDungeonRockIdx())
			if grid and grid:GetType() == GridEntityType.GRID_ROCK and grid.State~=2 then
				index = index + 1
				mod.SolarItemsVars.MothershipTargets[index] = grid.Position
			end
			
			
			for _, carpet in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ISAACS_CARPET)) do
				index = index + 1
				mod.SolarItemsVars.MothershipTargets[index] = carpet.Position
			end

		end

		local initIndex = 1
		if index == 0 then initIndex = 0 end
		data.CurrentIndex = initIndex
		data.FinalIndex = index
		data.AbleToChange = true

	end

	for index, maggot in ipairs(mod:FindByTypeMod(mod.Entity.AlienCharger)) do
		if maggot:GetData().Level and ((index > 3 and maggot:GetData().Level < 3) or (index > 5 and maggot:GetData().Level >= 3)) then
			maggot:Remove()
		end
	end

	mod:FillMothershipRequierements()
	mod.SolarItemsVars.MothershipNeeded = false
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player and mod:HasMotherModule(player) and not mod:HasAllMotherModule(player) then
			mod.SolarItemsVars.MothershipNeeded = true
			break
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.MothershipOnNewRoom)

--UTILS---------------------------------------------------
--Get if the player has some mothership module
function mod:HasMotherModule(player)
	return player:HasCollectible(mod.SolarItems.Mothership_01) or player:HasCollectible(mod.SolarItems.Mothership_02) or player:HasCollectible(mod.SolarItems.Mothership_03) or player:HasCollectible(mod.SolarItems.Mothership_04)
end
--Get if the player has all mothership modules
function mod:HasAllMotherModule(player)
	return player:HasCollectible(mod.SolarItems.Mothership_01) and player:HasCollectible(mod.SolarItems.Mothership_02) and player:HasCollectible(mod.SolarItems.Mothership_03) and player:HasCollectible(mod.SolarItems.Mothership_04)
end

--Count how many motherships have x module
function mod:CountMothersWithModule(player, module)
	local count = 0
	for _, mother in ipairs(mod:FindByTypeMod(mod.Entity.Mothership)) do
		mother:ToFamiliar()
		if mother and mother.Player and mod:ComparePlayer(player, mother.Player) then
			local valid = ((module == 1) and mother:GetData().InceminatorEnabled) or ((module == 2) and mother:GetData().PistolEnabled) or ((module == 3) and mother:GetData().PenetratorEnabled) or ((module == 4) and mother:GetData().ProtectorEnabled)
			if valid then
				count = count + 1
			end
		end
	end
	return count
end

--Gets the requested mothership part or anyone if not
function mod:GetSomeMothership(player, item)
	local flag = false
	if not item then
		flag = true
	end

	if player:HasCollectible(mod.SolarItems.Mothership_01) and (flag or (item == mod.SolarItems.Mothership_01)) then
		return mod.SolarItems.Mothership_01
	elseif player:HasCollectible(mod.SolarItems.Mothership_02) and (flag or (item == mod.SolarItems.Mothership_02)) then
		return mod.SolarItems.Mothership_02
	elseif player:HasCollectible(mod.SolarItems.Mothership_03) and (flag or (item == mod.SolarItems.Mothership_03)) then
		return mod.SolarItems.Mothership_03
	elseif player:HasCollectible(mod.SolarItems.Mothership_04) and (flag or (item == mod.SolarItems.Mothership_04)) then
		return mod.SolarItems.Mothership_04
	end
	return false
end
function mod:GetSomeMissingMothership()
	for i=1, 10 do
		local r = mod:RandomInt(1,4)
		if r == 1 and not mod:SomebodyHasItem(mod.SolarItems.Mothership_01) then return mod.SolarItems.Mothership_01
		elseif r == 2 and not mod:SomebodyHasItem(mod.SolarItems.Mothership_02) then return mod.SolarItems.Mothership_02
		elseif r == 3 and not mod:SomebodyHasItem(mod.SolarItems.Mothership_03) then return mod.SolarItems.Mothership_03
		elseif r == 4 and not mod:SomebodyHasItem(mod.SolarItems.Mothership_04) then return mod.SolarItems.Mothership_04
		end
	end
end

--Get which parts are missing
function mod:FillMothershipRequierements()
	mod.SolarItemsVars.MothershipNeeds = {[1]=false,[2]=false,[3]=false,[4]=false}

    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
        if mod:HasMotherModule(player) then
            if not player:HasCollectible(mod.SolarItems.Mothership_01) then
                mod.SolarItemsVars.MothershipNeeds[1] = true
            end
            if not player:HasCollectible(mod.SolarItems.Mothership_02) then
                mod.SolarItemsVars.MothershipNeeds[2] = true
            end
            if not player:HasCollectible(mod.SolarItems.Mothership_03) then
                mod.SolarItemsVars.MothershipNeeds[3] = true
            end
            if not player:HasCollectible(mod.SolarItems.Mothership_04) then
                mod.SolarItemsVars.MothershipNeeds[4] = true
            end
        end
	end
end

--OTHERS------------------------------------------------
function mod:MothershipChargeProtector()
	for _, mother in ipairs(mod:FindByTypeMod(mod.Entity.Mothership)) do
		local data = mother:GetData()
		if data.ProtectorEnabled then
			if data.ModuleLevel == 1 and data.Shields < 1 then
				data.Charges = math.min(5, data.Charges+1)
			elseif data.ModuleLevel == 2 and data.Shields < 1 then
				data.Charges = math.min(3, data.Charges+1)
			elseif data.ModuleLevel >= 3 and data.Shields < 2 then
				data.Charges = math.min(3, data.Charges+1)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.MothershipChargeProtector)

function mod:OnInfectedDeath(entity)
	local dic = mod.SolarItemsVars.InfectedEnts[entity.InitSeed]
	if dic then
		if dic.play then
			for i=1, dic.lev do
				local velocidad = Vector(15*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())
				local maggot = mod:SpawnEntity(mod.Entity.AlienCharger, entity.Position, velocidad, dic.play)
				maggot:AddCharmed(EntityRef(dic.play), -1)

				maggot.SpawnerEntity = dic.play

				maggot:GetData().Level = dic.lev
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnInfectedDeath)

function mod:MothershipMissileExplosion(effect)
	mod:scheduleForUpdate(function()
		if( (0.75757574 < effect.SpriteScale.X) and (effect.SpriteScale.X <  0.75757576)) then
			--effect:GetSprite().Color = mod.Colors.greenEden
			
			--Explosion damage
			for i, e in ipairs(Isaac.FindInRadius(effect.Position, 30)) do
				if not ((e.Type == EntityType.ENTITY_PLAYER) or (e.Type == mod.EntityInf[mod.Entity.AlienCharger].ID and e.Variant == mod.EntityInf[mod.Entity.AlienCharger].VAR and e.SubType == mod.EntityInf[mod.Entity.AlienCharger].SUB)) then
					e:TakeDamage(50, DamageFlag.DAMAGE_EXPLOSION, EntityRef(effect), 0)
				end
			end
		end
	end, 1)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.MothershipMissileExplosion, EffectVariant.BOMB_EXPLOSION)

--include("scripts.slots.mothershipslots")
