local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local music = MusicManager()
local sfx = SFXManager()

mod.RSaturnState = {--the state's names make no sense, sorry
	APPEAR = 0,

	IDLE0 = 1,
	IDLE1 = 2,
	IDLE2 = 3,
	IDLE3 = 4,

    --P1
    DART = 5,
    BURST = 6,
    SUMMON = 7,

    --P2
    TELEPORT = 8,
    LICK = 9,
    LANCE = 10,

    --P3
    SHOTS = 11,
    SPIN = 12,
    LASER = 13

}
mod.chainRSaturn = {--               Appear Idle0	Idle1	Idle2	Idle3    Dart    Burst   Summon  Tele    Lick    Lance   Shots   Spin    Laser
    [mod.RSaturnState.APPEAR] =     {0,     1,      0,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
	
    [mod.RSaturnState.IDLE0] =     	{0,     0.52,   0,      0,      0,       0.16,   0.16,   0.16,   0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.IDLE1] =     	{0,     0,      0.4,    0,      0,       0,		 0,      0,   	 0.2,    0.2,    0.2,    0,      0,      0},
    [mod.RSaturnState.IDLE2] =      {0,     0,      0,      0.6,    0,       0,      0,      0,      0,      0,      0,      0.2,    0,     0.2},
    [mod.RSaturnState.IDLE3] =      {0,     1,   0.34,   0.33,   0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
	
    [mod.RSaturnState.DART] =     	{0,     1,      0,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.BURST] =     	{0,     1,      0,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.SUMMON] =     {0,     1,      0,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
	
    [mod.RSaturnState.TELEPORT] =   {0,     0,      1,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.LICK] =   	{0,     0,      1,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.LANCE] =   	{0,     0,      1,      0,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
	
    [mod.RSaturnState.SHOTS] =   	{0,     0,      0,      1,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.SPIN] =   	{0,     0,      0,      1,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
    [mod.RSaturnState.LASER] =   	{0,     0,      0,      1,      0,       0,      0,      0,      0,      0,      0,      0,      0,      0},
	
}

local fullblack = Color(0,0,0,1)
local fullwhite = Color(0,0,0,1,1,1,1)

mod.RSaturnConst = {--Some constant variables of Solar RSaturn
	IDLE_TIME_INTERVAL = Vector(15,20),
	SPEED = 5.4,
	CENTER_DISTANCE_TOLERATION = 70,
	
	UMBRAL_1 = 0.75,
	UMBRAL_2 = 0.55,
	UMBRAL_3 = 0.3,

	RANDOM_SCREEN_CHANCE = 0,

	--P1
	--summon
	MAX_FAKE_TRACES = 5,
	MAX_MAX_FAKE_TRACES = 20,

	--summons
	DRIFTER_N_RING = 5,
	DRIFTER_SHOT_SPEED = 7,

	FROH_SHOT_SPEED = 7,

	WARPER_JUMP_CHANCE = 0.3,
	WARPER_SHOT_SPEED = 7,

	--P2
	--summon
	MAX_FAKE_TRACES_MED = 2,
	MAX_MAX_FAKE_TRACES_MED = 6,

	--P3
	N_MUNCHES = 3,
	PRE_LASER_IDLES = 3,
	N_LASERS = 2,
	LASER_ANGLE_SPEED = 1,
	LASER_DISTANCE_SPEED = 1,
	N_LASER_PROJS = 3,
	LASER_PROJ_SPEED = 5,
	LASER_SHOT_CHANCE = 0.1,

	--P4
	GHOST_SPEED = 6,
}
function mod:SetRSaturnDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
		
		mod.RSaturnConst.RANDOM_SCREEN_CHANCE = 0

		--P1
		mod.RSaturnConst.MAX_FAKE_TRACES = 5
		mod.RSaturnConst.FROH_SHOT_SPEED = 7
		mod.RSaturnConst.WARPER_SHOT_SPEED = 7
		
		--P2
		mod.RSaturnConst.MAX_FAKE_TRACES_MED = 2
		mod.RSaturnConst.MAX_MAX_FAKE_TRACES_MED = 6
		
		--P3
		mod.RSaturnConst.N_LASERS = 2
		mod.RSaturnConst.LASER_ANGLE_SPEED = 1
		mod.RSaturnConst.LASER_DISTANCE_SPEED = 1
		mod.RSaturnConst.N_LASER_PROJS = 3
		mod.RSaturnConst.LASER_PROJ_SPEED = 5
		mod.RSaturnConst.LASER_SHOT_CHANCE = 0.1

		--P4
		mod.RSaturnConst.GHOST_SPEED = 6

	elseif difficulty == mod.Difficulties.ATTUNED then
		
		mod.RSaturnConst.RANDOM_SCREEN_CHANCE = 1/(30*10)
		
		--P1
		mod.RSaturnConst.MAX_FAKE_TRACES = 7
		mod.RSaturnConst.FROH_SHOT_SPEED = 7.5
		mod.RSaturnConst.WARPER_SHOT_SPEED = 7.5
		
		--P2
		mod.RSaturnConst.MAX_FAKE_TRACES_MED = 2
		mod.RSaturnConst.MAX_MAX_FAKE_TRACES_MED = 8
		
		--P3
		mod.RSaturnConst.N_LASERS = 2
		mod.RSaturnConst.LASER_ANGLE_SPEED = 1.3
		mod.RSaturnConst.LASER_DISTANCE_SPEED = 1.3
		mod.RSaturnConst.N_LASER_PROJS = 3
		mod.RSaturnConst.LASER_PROJ_SPEED = 6
		mod.RSaturnConst.LASER_SHOT_CHANCE = 0.1

		--P4
		mod.RSaturnConst.GHOST_SPEED = 7
		

    elseif difficulty == mod.Difficulties.ASCENDED then
		
		mod.RSaturnConst.RANDOM_SCREEN_CHANCE = 1/(30*5)
		
		--P1
		mod.RSaturnConst.MAX_FAKE_TRACES = 9
		mod.RSaturnConst.FROH_SHOT_SPEED = 8
		mod.RSaturnConst.WARPER_SHOT_SPEED = 8
		
		--P2
		mod.RSaturnConst.MAX_FAKE_TRACES_MED = 3
		mod.RSaturnConst.MAX_MAX_FAKE_TRACES_MED = 10
		
		--P3
		mod.RSaturnConst.N_LASERS = 3
		mod.RSaturnConst.LASER_ANGLE_SPEED = 1.5
		mod.RSaturnConst.LASER_DISTANCE_SPEED = 1.5
		mod.RSaturnConst.N_LASER_PROJS = 3
		mod.RSaturnConst.LASER_PROJ_SPEED = 6
		mod.RSaturnConst.LASER_SHOT_CHANCE = 0.067

		--P4
		mod.RSaturnConst.GHOST_SPEED = 8
		
    end
end

local RSaturnSize = {
	SMALL = 0,
	MEDIUM = 1,
	BIG = 2,
	OUROBOROS = 3,
}

function mod:RSaturnUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.RSaturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.RSaturn].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0
            
			data.IsEternal = mod:CheckEternalBoss(entity)

			data.Size = RSaturnSize.SMALL
			data.IsBlack = false
			mod:RSaturnSwitch(entity, data, sprite, true)

			data.phase = 0

			data.GhostFrames = 0

			data.Traces = {}
			data.IsSaturn = true

			entity.SplatColor = fullblack

			data.MoveNodes = {}
			local center = room:GetCenterPos()
			local br = room:GetBottomRightPos()
			local tl = room:GetTopLeftPos()
			local direction = (center - br):Resized(80)
			direction.Y = direction.Y*1.5
			table.insert(data.MoveNodes, center)
			table.insert(data.MoveNodes, br + direction)
			table.insert(data.MoveNodes, tl - direction)
			table.insert(data.MoveNodes, Vector(br.X, tl.Y) + Vector(direction.X, -direction.Y))
			table.insert(data.MoveNodes, Vector(tl.X, br.Y) + Vector(-direction.X, direction.Y))

			data.CurrentNode = data.MoveNodes[mod:RandomInt(1,#data.MoveNodes)]

			--sprite:SetRenderFlags(AnimRenderFlags.STATIC)
			
			data.TargetPosition = room:GetRandomPosition(20)

			mod.ShaderData.ouroborosGhostsSprites = {}

			
			if TheFuture and TheFuture.Stage:IsStage() then
				TheFuture.NevermoreMusicOverride = nil
				--TheFuture.NevermoreMusicOverride = Music.MUSIC_BOSS_OVER
				local flash = mod:SpawnEntity(mod.Entity.ICUP, room:GetCenterPos(), Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.ICUP].SUB+9)
				
				mod:ChangeRoomBackdrop(mod.Backdrops.THEFUTURE)
			end
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.RSaturnState.APPEAR then
			if data.StateFrame == 1 then
				data.NoTrapdoor = true
				mod:AppearPlanet(entity)

				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                
                if mod:IsChallenge(mod.Challenges.BabelTower) then
                    sprite:Play("AppearSlow",true)

					entity.MaxHitPoints = 500
					entity.HitPoints = 500
                else
                    sprite:Play("Appear",true)
                end

			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				mod:RSaturnGrowTo(entity, data, sprite, RSaturnSize.SMALL)
				mod:RSaturnSwitch(entity, data, sprite, true)
				mod:RSaturnStateChange(entity, sprite, data)

				mod:SpawnStevenScreen("fuckStart", 30, 30*4, false, nil)

				if mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_LITTLE_STEVEN) then
					mod:scheduleForUpdate(function ()
						if entity then
							mod:SpawnStevenScreen("fuckPregnant", 30, 30*8, false, nil)
						end
					end, 30*6)
				end
			end
			
		elseif data.State == mod.RSaturnState.IDLE0 then
			mod:RSaturnIdle0(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.IDLE1 then
			mod:RSaturnIdle1(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.IDLE2 then
			mod:RSaturnIdle2(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.IDLE3 then
			mod:RSaturnIdle3(entity, data, sprite, target, room)
			
		elseif data.State == mod.RSaturnState.DART then
			mod:RSaturnDart(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.BURST then
			mod:RSaturnBurst(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.SUMMON then
			mod:RSaturnSummon(entity, data, sprite, target, room)
			
		elseif data.State == mod.RSaturnState.TELEPORT then
			mod:RSaturnTeleport(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.LICK then
			mod:RSaturnLick(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.LANCE then
			mod:RSaturnLance(entity, data, sprite, target, room)
			
		elseif data.State == mod.RSaturnState.SHOTS then
			mod:RSaturnShots(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.SPIN then
			mod:RSaturnSpin(entity, data, sprite, target, room)
		elseif data.State == mod.RSaturnState.LASER then
			mod:RSaturnLaser(entity, data, sprite, target, room)

		end

		
		if data.State ~= mod.RSaturnState.APPEAR then
			if data.GhostFrames > 0 then
				data.GhostFrames = data.GhostFrames - 1
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			else
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end

			if rng:RandomFloat() < mod.RSaturnConst.RANDOM_SCREEN_CHANCE then
				mod:SpawnStevenScreen("fuckRandom", 30, 30*6, false, nil, true)
			end
		end

	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.RSaturnUpdate, mod.EntityInf[mod.Entity.RSaturn].ID)

function mod:RSaturnIdle0(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("IdleSmall",true)

	elseif sprite:IsFinished("IdleSmall") then
		mod:RSaturnStateChange(entity, sprite, data)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnIdle1(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("IdleMed",true)

	elseif sprite:IsFinished("IdleMed") then
		mod:RSaturnStateChange(entity, sprite, data)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnIdle2(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("IdleBig",true)

	elseif sprite:IsFinished("IdleBig") then
		mod:RSaturnStateChange(entity, sprite, data)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnIdle3(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("IdleFinal",true)

		mod.ShaderData.ouroborosGhosts[data.phase+1] = entity

	elseif sprite:IsFinished("IdleFinal") then
		
		mod.ShaderData.ouroborosEnabled = true
		mod.ShaderData.ouroborosGhostsEnabled = true

		mod:RSaturnStateChange(entity, sprite, data)
		entity:Update()
	else
		mod:RSaturnMove(entity,data,room,target)

		--[[
		local direction = (data.TargetPosition - entity.Position):Resized(mod.RSaturnConst.GHOST_SPEED)
		entity.Velocity = mod:Lerp(entity.Velocity, direction, 0.1)
		if entity.Position:Distance(data.TargetPosition) < 20 then
			data.TargetPosition = room:GetRandomPosition(20)
		end
		]]--
	end

	if sprite:GetFrame() == 5 or sprite:GetFrame() == 16 then
		local volume = (target.Position - entity.Position):Length()
		sfx:Play(SoundEffect.SOUND_BONE_BREAK, math.min(2, 100/volume))
		game:ShakeScreen(2)
	end

	--[[
	local angle1 = math.sin(entity.FrameCount / 30)*15
	local angle2 = mod:Lerp(angle1, 1.5*entity.Velocity.X, 0.1)
	for i=4,5 do
		local layer = sprite:GetLayer(i)
		layer:SetRotation(angle1 + angle2)
	end
	]]

	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end

function mod:RSaturnDart(entity, data, sprite, target, room) --actually mini laser
	if data.StateFrame == 1 then
		sprite:Play("LaserStart",true)

		data.TargetLaser = nil
		data.LaserRepeats = 0

		local total = #mod:FindByTypeMod(mod.Entity.Drifter) + #mod:FindByTypeMod(mod.Entity.Froh) + #mod:FindByTypeMod(mod.Entity.Warper)
		if total > 0 then
			local drifter = mod:FindByTypeMod(mod.Entity.Drifter)[1]
			if drifter then
				data.TargetLaser = drifter
			else
				local froh = mod:FindByTypeMod(mod.Entity.Froh)[1]
				if froh then
					data.TargetLaser = froh
				else
					local warper = mod:FindByTypeMod(mod.Entity.Warper)[1]
					if warper then
						data.TargetLaser = warper
					end
				end
			end
			data.LaserRepeats = 5
		end

		if not data.TargetLaser then
			data.TargetLaser = target
			data.LaserRepeats = 5
		end

		local angle = (data.TargetLaser.Position-entity.Position):GetAngleDegrees()
		local laser = EntityLaser.ShootAngle(LaserVariant.TRACTOR_BEAM, entity.Position+Vector(0,1), angle, 120, Vector(0,-35), entity)
		laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
		laser:GetData().ForceDefaultColor = true
		laser:Update()
		laser:GetData().IsBlack = data.IsBlack
		laser:Update()
		data.Laser = laser

		if data.IsSaturn then
			mod:ChanceFakeTracesStates(entity, mod.RSaturnState.DART)
			
			sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_CHARGE, 0.5, 2, false, 2)
		end

	elseif sprite:IsFinished("LaserStart") then
		sprite:Play("LaserIdle",true)
	elseif sprite:IsFinished("LaserIdle") then
		data.LaserRepeats = data.LaserRepeats - 1
		if data.LaserRepeats <= 0 then
			sprite:Play("Laser",true)
		else
			sprite:Play("LaserIdle",true)
		end
	elseif sprite:IsFinished("Laser") then
		sprite:Play("LaserEnd",true)

	elseif sprite:IsFinished("LaserEnd") then
		mod:RSaturnStateChange(entity, sprite, data)


	elseif sprite:IsEventTriggered("Attack") then
		if data.Laser then
			local angle = data.Laser.Angle
			local position = entity.Position + Vector.FromAngle(angle)*(entity.Size+1)
			local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, position, angle, 5, Vector(0,-35), entity)
			laser.CollisionDamage = 20
			laser:SetMultidimensionalTouched(true)
			laser:Update()
			if data.IsBlack ~= nil then
				if data.IsBlack then
					laser:GetSprite().Color = fullwhite
				else
					laser:GetSprite().Color = fullblack
				end
			end

			sfx:Stop(SoundEffect.SOUND_ANGEL_BEAM)
			sfx:Play(Isaac.GetSoundIdByName("stevenLaserMini"), 1.5)
			
			game:GetRoom():DoLightningStrike(entity.FrameCount % 1000 + 1)

			data.Laser:Remove()

			if false and data.TargetLaser and data.IsSaturn then
				local cposition = data.TargetLaser.Position
				mod:scheduleForUpdate(function ()
					if (not data.TargetLaser) or (data.TargetLaser and data.TargetLaser.HitPoints <= 0 and data.TargetLaser:IsDead()) then
						local angleOffset = rng:RandomFloat() * 360
						local n = mod.RSaturnConst.DRIFTER_N_RING
						for i=1, n do
							local angle = angleOffset + 360/n*i
							local velocity = Vector.FromAngle(angle) * mod.RSaturnConst.DRIFTER_SHOT_SPEED
							local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, cposition, velocity, entity):ToProjectile()
							tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
							tear:GetData().ForceDefaultColor = true
							mod:TearFallAfter(tear, 30*2)
						end
					end
				end, 5)
			end
		end
	else
		mod:RSaturnMove(entity,data,room,target)
	end

	if data.Laser and data.TargetLaser then
		local h = 0.1
		if data.TargetLaser.Type == EntityType.ENTITY_PLAYER then h = 0.05 end
		local angle = (data.TargetLaser.Position-entity.Position):GetAngleDegrees()
		local currentAngle = data.Laser.Angle
		local newAngle = mod:AngleLerp(currentAngle, angle, h)
		data.Laser.Angle = newAngle
		
		local layer = sprite:GetLayer("face")
		local offset = layer:GetPos()
		data.Laser.SpriteOffset = offset
		
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnBurst(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		local total = #mod:FindByTypeMod(mod.Entity.Drifter) + #mod:FindByTypeMod(mod.Entity.Froh) + #mod:FindByTypeMod(mod.Entity.Warper)
		if total < 2 then
			sprite:Play("Summon", true)
		else
			mod:RSaturnStateChange(entity, sprite, data)
		end

	elseif sprite:IsFinished("Summon") then
		mod:RSaturnStateChange(entity, sprite, data)
		entity:Update()
		
	elseif sprite:IsEventTriggered("Attack") then
		local velocity = (target.Position - entity.Position):Resized(10)
		local ball = mod:SpawnEntity(mod.Entity.StevenBall, entity.Position, velocity, entity)
		ball:GetData().IsBlack = data.IsBlack
		ball:Update()
		
		sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 2, false, 1)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnSummon(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		local total = #mod:FindByTypeMod(mod.Entity.OuroborosFakeTrace)
		if total < mod.RSaturnConst.MAX_MAX_FAKE_TRACES then
			sprite:Play("Switch", true)
		else
			mod:RSaturnStateChange(entity, sprite, data)
		end

	elseif sprite:IsFinished("Switch") then
		mod:RSaturnSwitch(entity, data, sprite)
		mod:RSaturnStateChange(entity, sprite, data)
		entity:Update()
		
	elseif sprite:IsEventTriggered("Attack") then
		local trace = mod:SpawnEntity(mod.Entity.OuroborosFakeTrace, entity.Position, Vector.Zero, entity)
		trace:GetData().IsTracePhase1 = true
		mod:RSaturnGrowTo(trace, trace:GetData(), trace:GetSprite(), RSaturnSize.SMALL)
		trace.Parent = entity
		table.insert(data.Traces, trace)
		mod:UpdateRSaturnTraces(entity)
		
		sfx:Play(SoundEffect.SOUND_STATIC, 1, 2, false, 1)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end

function mod:RSaturnTeleport(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		local total = #mod:FindByTypeMod(mod.Entity.OuroborosFakeTrace)
		if total < mod.RSaturnConst.MAX_MAX_FAKE_TRACES_MED then
			sprite:Play("Scream",true)
			
			sfx:Play(SoundEffect.SOUND_PESTILENCE_HEAD_DEATH, 0.8, 2, false, 1.5)
		else
			mod:RSaturnStateChange(entity, sprite, data)
		end
	elseif sprite:IsFinished("Scream") then
		sprite:Play("Teleport",true)
	elseif sprite:IsFinished("Teleport") then
		sprite:Play("TeleportEnd",true)

		--summon
		local trace = mod:SpawnEntity(mod.Entity.OuroborosFakeTrace, entity.Position, Vector.Zero, entity)
		trace:GetData().State = mod.RSaturnState.IDLE1
		mod:RSaturnGrowTo(trace, trace:GetData(), trace:GetSprite(), RSaturnSize.MEDIUM)
		trace.Parent = entity
		table.insert(data.Traces, trace)
		mod:UpdateRSaturnTraces(entity)

		mod:RSaturnSwitch(entity, data, sprite)

		local newpos = Vector.Zero
		for i=1,100 do
			newpos = data.MoveNodes[mod:RandomInt(1,#data.MoveNodes)]
			if newpos:Distance(entity.Position) > 20 and newpos:Distance(target.Position) > 120 then break end
		end

		entity.Position = newpos
		
		sfx:Play(SoundEffect.SOUND_STATIC, 1, 2, false, 1)
		
		game:GetRoom():DoLightningStrike(entity.FrameCount % 1000 + 1)


	elseif sprite:IsFinished("TeleportEnd") then
		mod:RSaturnStateChange(entity, sprite, data)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnLick(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Lick",true)
		
		if data.IsSaturn then
			mod:ChanceFakeTracesStates(entity, mod.RSaturnState.LICK)
		end
	elseif sprite:IsFinished("Lick") then
		mod:RSaturnStateChange(entity, sprite, data)

	elseif sprite:IsEventTriggered("Attack") then
		local projectileParams = ProjectileParams()
		projectileParams.Variant = ProjectileVariant.PROJECTILE_FCUK
		projectileParams.Scale = 2
		projectileParams.FallingAccelModifier = 0.1
		projectileParams.DotProductLimit = 0
		projectileParams.BulletFlags = ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT | ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.BOUNCE --| ProjectileFlags.CONTINUUM 
		projectileParams.ChangeFlags = ProjectileFlags.TRACTOR_BEAM
		projectileParams.ChangeTimeout = 30

		local nTraces = 1
		for i, trace in ipairs(mod:FindByTypeMod(mod.Entity.OuroborosFakeTrace)) do
			if not trace:GetData().Inactive then
				nTraces = nTraces + 1
			end
		end
		local n = math.ceil((mod.RSaturnConst.MAX_FAKE_TRACES_MED+1)/nTraces)

		local projectiles = entity:FireBossProjectilesEx(n, target.Position, 0, projectileParams)
		--for i, tear in ipairs(projectiles) do
		--	tear:GetData().ForceDefaultColor = true
		--end
		
		sfx:Play(SoundEffect.SOUND_MEATHEADSHOOT, 1, 2, false, 1)
		sfx:Play(SoundEffect.SOUND_BALL_AND_CHAIN_HIT, 0.5, 2, false, 3)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end
function mod:RSaturnLance(entity, data, sprite, target, room) --summon
	if data.StateFrame == 1 then
		local total = #mod:FindByTypeMod(mod.Entity.Drifter) + #mod:FindByTypeMod(mod.Entity.Froh) + #mod:FindByTypeMod(mod.Entity.Warper)
		if total < 2 then
			if target.Position.X > entity.Position.X then
				sprite:Play("SpinCCW",true)
			else
				sprite:Play("SpinCW",true)
			end
		else
			mod:RSaturnStateChange(entity, sprite, data)
		end
	elseif sprite:IsFinished("SpinCCW") or sprite:IsFinished("SpinCW") then
		sprite:Play("Regrow",true)
		
		sfx:Play(SoundEffect.SOUND_MEGA_BLAST_END, 1, 2, false, 2)

	elseif sprite:IsFinished("Regrow") then
		mod:RSaturnStateChange(entity, sprite, data)
	
	elseif sprite:IsEventTriggered("Attack") then
		local velocity = (target.Position - entity.Position):Resized(10)
		local ball = mod:SpawnEntity(mod.Entity.StevenBall, entity.Position, velocity, entity)
		ball:GetData().IsBlack = data.IsBlack
		ball:GetData().IsHorf = true
		
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 2, false, 1)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end

function mod:RSaturnShots(entity, data, sprite, target, room) --laser
	if data.StateFrame == 1 then
		sprite:Play("MunchStart",true)
		data.nMunches = mod.RSaturnConst.N_MUNCHES
		
		sfx:Play(SoundEffect.SOUND_FAMINE_DASH, 1, 2, false, 2)
	elseif sprite:IsFinished("MunchStart") then
		sprite:Play("MunchIdle",true)

		data.TargetPos = target.Position
		local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, data.TargetPos, Vector.Zero, entity):ToEffect()
		target.Timeout = 30
		if data.IsBlack ~= nil then
			if data.IsBlack then
				target:GetSprite().Color = fullwhite
			else
				target:GetSprite().Color = fullblack
			end
		end
		data.Target = target
	elseif sprite:IsFinished("MunchIdle") then
		data.nMunches = data.nMunches - 1
		if data.nMunches<= 0 then
			sprite:Play("MunchEnd",true)

		else
			sprite:Play("MunchIdle",true)
		end

	elseif sprite:IsFinished("MunchEnd") then
		mod:RSaturnStateChange(entity, sprite, data)

	elseif sprite:IsEventTriggered("Attack") then
		
		local angle = (data.TargetPos - entity.Position):GetAngleDegrees()
		local position = entity.Position + Vector.FromAngle(angle)
		local laser = EntityLaser.ShootAngle(LaserVariant.THICKER_BRIM_TECH, position, angle, 1, Vector(0,-35), entity)
		laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
		laser:GetData().ForceDefaultColor = true
		laser.CollisionDamage = 20
		laser:SetMultidimensionalTouched(true)
		laser:Update()
		if data.IsBlack ~= nil then
			if data.IsBlack then
				laser:GetSprite().Color = fullwhite
			else
				laser:GetSprite().Color = fullblack
			end
		end
		laser:GetData().IsBlack = data.IsBlack
		
		--sfx:Stop(SoundEffect.SOUND_BLOOD_LASER_LARGER)
		sfx:Play(Isaac.GetSoundIdByName("stevenLaser"), 1)
		
		sfx:Play(SoundEffect.SOUND_PESTILENCE_HEAD_DEATH, 0.8, 2, false, 1.5)

	else
		mod:RSaturnMove(entity,data,room,target)
	end

	if data.Target then
		mod:RSaturnMoveFace(entity, data, sprite, data.Target.Position)
	else
		mod:RSaturnMoveFace(entity, data, sprite, target.Position)
	end
end
function mod:RSaturnSpin(entity, data, sprite, target, room) --unused
	if data.StateFrame == 1 then
		sprite:Play("MouthStart",true)
	elseif sprite:IsFinished("MouthStart") then
		sprite:Play("MouthIdle",true)
	elseif sprite:IsFinished("MouthIdle") then
		sprite:Play("MouthEnd",true)

	elseif sprite:IsFinished("MouthEnd") then
		mod:RSaturnStateChange(entity, sprite, data)
	else
		mod:RSaturnMove(entity,data,room,target)
	end
end
function mod:RSaturnLaser(entity, data, sprite, target, room) --summon
	if data.StateFrame == 1 then
		sprite:Play("Jump",true)

	elseif sprite:IsFinished("Jump") then
		mod:RSaturnStateChange(entity, sprite, data)
	
	elseif sprite:IsEventTriggered("Jump") then
		
		mod:RSaturnSwitch(entity, data, sprite)

		for i=1, mod.RSaturnConst.N_LASERS do
			local steven = mod:SpawnEntity(mod.Entity.StevenLaser, entity.Position, Vector.Zero, entity)
			steven.Parent = entity
			steven.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

			local edata = steven:GetData()
			edata.Index = i
			edata.Total = mod.RSaturnConst.N_LASERS

			steven:Update()
		end
		
		sfx:Play(SoundEffect.SOUND_STATIC, 1, 2, false, 1)
	elseif sprite:IsEventTriggered("Land") then
	else
		mod:RSaturnMove(entity,data,room,target)
	end
	mod:RSaturnMoveFace(entity, data, sprite, target.Position)
end

--Move
function mod:RSaturnMove(entity, data, room, target)
	if data.IsTracePhase1 then
		return
	end
	local node = data.CurrentNode or entity.Position
	local speed = mod.RSaturnConst.SPEED
	
	local velocity = (node - entity.Position):Resized(speed)
	entity.Velocity = velocity

	if entity.Position:Distance(node) < 5 then
		for i=1,100 do
			data.CurrentNode = data.MoveNodes[mod:RandomInt(1,#data.MoveNodes)]
			if data.CurrentNode:Distance(node) > 20 then break end
		end
	end

	if data.IsSaturn then
		local parentTrace = entity
		for i, trace in ipairs(data.Traces) do
			if trace:GetData().IsTracePhase1 then
				mod:FamiliarTargetMovement(trace, parentTrace, 10, 1, 10)
				parentTrace = trace
			end
		end
	end
end

function mod:RSaturnMoveFace(entity, data, sprite, targetPosition)
	local phase = data.phase or 0
	if phase == 3 then phase = 1 end
	local layer = sprite:GetLayer("face")
	local direction = (targetPosition - entity.Position):Resized(3*(phase+1))
	data.curretFacePos = data.curretFacePos or Vector.Zero
	data.curretFacePos = mod:Lerp(data.curretFacePos, direction, 0.1)
	layer:SetPos (data.curretFacePos)
end

--State Change
function mod:RSaturnStateChange(entity, sprite, data, forcedState)
	local ogState = data.State

	data.State = forcedState or mod:MarkovTransition(data.State, mod.chainRSaturn)
	data.StateFrame = 0

	local ogPhase = data.phase

	if ogState == mod.RSaturnState.IDLE0 or ogState == mod.RSaturnState.IDLE1 or ogState == mod.RSaturnState.IDLE2 then
		if false and data.phase == 3 then
			data.State = mod:MarkovTransition(mod.RSaturnState.IDLE3, mod.chainRSaturn)
			if ogState ~= mod.RSaturnState.IDLE0 and data.State == mod.RSaturnState.IDLE0 then
				mod:RSaturnGrowTo(entity, data, sprite, RSaturnSize.SMALL)
			elseif ogState ~= mod.RSaturnState.IDLE1 and data.State == mod.RSaturnState.IDLE1 then
				mod:RSaturnGrowTo(entity, data, sprite, RSaturnSize.MEDIUM)
			elseif ogState ~= mod.RSaturnState.IDLE2 and data.State == mod.RSaturnState.IDLE2 then
				mod:RSaturnGrowTo(entity, data, sprite, RSaturnSize.BIG)
			end
		else
			if data.phase == 0 and (entity.HitPoints/entity.MaxHitPoints < mod.RSaturnConst.UMBRAL_1) then
				mod:RSaturnGrowTo(entity, data, sprite, RSaturnSize.MEDIUM)
				data.State = mod.RSaturnState.IDLE1
				data.phase = 1
				mod:KillEntities(mod:FindByTypeMod(mod.Entity.OuroborosFakeTrace))

				mod:SpawnStevenScreen("fuckP1", 30, 30*7, false, nil)
			elseif data.phase == 1 and (entity.HitPoints/entity.MaxHitPoints < mod.RSaturnConst.UMBRAL_2) then
				mod:RSaturnGrowTo(entity, data, sprite, RSaturnSize.BIG)
				data.State = mod.RSaturnState.IDLE2
				data.phase = 2
				mod:KillEntities(mod:FindByTypeMod(mod.Entity.OuroborosFakeTrace))
				
				mod:SpawnStevenScreen("fuckP2", 30, 30*12, false, nil)
			elseif data.phase == 2 and (entity.HitPoints/entity.MaxHitPoints < mod.RSaturnConst.UMBRAL_3) then
				data.phase = 3
				mod:KillEntities(mod:FindByTypeMod(mod.Entity.OuroborosFakeTrace))

				for size=RSaturnSize.SMALL, RSaturnSize.BIG do
					local ghost = mod:SpawnEntity(mod.Entity.SaturnGhost, entity.Position, Vector.Zero, entity)
					ghost.Parent = entity
					local gdata = ghost:GetData()
					gdata.phase = size

					
					local futureFlag = TheFuture and TheFuture.Stage:IsStage()
					if futureFlag then
						ghost:GetSprite():Load("hc/gfx/entity_RetconSaturnGhost.anm2", true)
					else
						ghost:GetSprite():Load("hc/gfx/entity_RetconSaturn.anm2", true)
					end
					
					mod.ShaderData.ouroborosGhosts[size+1] = ghost

					ghost:Update()
				end
				
				mod:SpawnStevenScreen("fuckOuroboros", 30, 30*16, true, nil)
				
				sfx:Play(SoundEffect.SOUND_EDEN_GLITCH, 2, 2, false, 1)
				sfx:Play(SoundEffect.SOUND_STATIC, 1, 2, false, 1)

				game:ShakeScreen(30)
				game:GetRoom():DoLightningStrike(entity.FrameCount % 1000 + 1)
			end
		end
	end

	if data.phase == 3 then
		data.State = mod.RSaturnState.IDLE3
	end

	if data.phase ~= ogPhase then
		
		local sats = Isaac.FindByType(Isaac.GetEntityTypeByName("Ouroboros (Paradox Saturn)"))
		for i, sat in ipairs(sats) do
			if not ((sat.Variant == mod.EntityInf[mod.Entity.RSaturn].VAR and sat.SubType == mod.EntityInf[mod.Entity.RSaturn].SUB) or (sat.Variant == mod.EntityInf[mod.Entity.SaturnGhost].VAR and sat.SubType == mod.EntityInf[mod.Entity.SaturnGhost].SUB)) then
				sat:Die()
			end
		end

		mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Drifter))
		mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Warper))
		mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Froh))
		mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE))
	end

end

function mod:RSaturnSwitch(entity, data, sprite, mute)
	local sheet = "hc/gfx/bosses/saturn retcon/saturn.png"
	local sheet2 = "hc/gfx/bosses/saturn retcon/saturn_face.png"
	entity.SplatColor = fullblack
	if data.IsBlack then
		sheet = "hc/gfx/bosses/saturn retcon/saturn_inverse.png"
		sheet2 = "hc/gfx/bosses/saturn retcon/saturn_face_inverse.png"
		entity.SplatColor = fullwhite

		entity:SetColor(fullblack, 10, 2, true, true)
	else
		entity:SetColor(fullwhite, 10, 2, true, true)
	end

	if data.IsEternal then
		sheet = "hc/gfx/bosses/saturn retcon/saturn_eternal.png"
		sheet2 = "hc/gfx/bosses/saturn retcon/saturn_face_eternal.png"
	end

	data.IsBlack = not data.IsBlack

	sprite:ReplaceSpritesheet(0, sheet)
	sprite:ReplaceSpritesheet(1, sheet)
	sprite:ReplaceSpritesheet(6, sheet2, true)
	
	if not mute then
		sfx:Play(Isaac.GetSoundIdByName("flipsound"))
	end
	
	if data.IsSaturn then
		for i, trace in ipairs(data.Traces) do
			trace:GetData().IsBlack = data.IsBlack
			mod:RSaturnSwitch(trace, trace:GetData(), trace:GetSprite(), true)
		end
	end

	return {sheet, sheet2}
	
end
function mod:RSaturnGrowTo(entity, data, sprite, size)
	if size == RSaturnSize.SMALL then
		sprite:Play("IdleSmall",true)
		entity:SetSize(20, Vector.One, 12)
	elseif size == RSaturnSize.MEDIUM then
		sprite:Play("IdleMed",true)
		entity:SetSize(25, Vector.One, 12)
	elseif size == RSaturnSize.BIG then
		sprite:Play("IdleBig",true)
		entity:SetSize(30, Vector.One, 12)
	elseif size == RSaturnSize.OUROBOROS then
		sprite:Play("IdleFinal",true)
		entity:SetSize(32, Vector.One, 12)
	end

	if data.IsBlack then
		entity:SetColor(fullwhite, 15, 1, true, true)
	else
		entity:SetColor(fullblack, 15, 1, true, true)
	end

	data.Size = size
end

function mod:RSaturnDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.RSaturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.RSaturn].SUB then
		mod:NormalDeath(entity)

		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, fullblack)
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		bloody:GetSprite().Color = fullblack

		
		game:GetRoom():DoLightningStrike(entity.FrameCount % 1000 + 1)

		mod:StevenShutUp()

		
		if not mod:IsChallenge(mod.Challenges.BabelTower) then
			local steven = mod:SpawnEntity(mod.Entity.Steven, entity.Position, Vector.Zero, nil)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.RSaturnDeath, mod.EntityInf[mod.Entity.RSaturn].ID)
function mod:RSaturnDying(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.RSaturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.RSaturn].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if data.deathFrame == nil then data.deathFrame = 1 end

		if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
			data.deathFrame = data.deathFrame + 1
			if sprite:GetFrame() == 1 then
				mod:StevenShutUp()
				sfx:Play(Isaac.GetSoundIdByName("ouroborosDeath"), 2)

				mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.StevenScreen))

			end
			mod.ShaderData.ouroborosEnabled = false
			entity.Visible = true
		end

	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.RSaturnDying, mod.EntityInf[mod.Entity.RSaturn].ID)

--FAKE TRACE
function mod:FakeTraceUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.OuroborosFakeTrace].VAR and entity.SubType == mod.EntityInf[mod.Entity.OuroborosFakeTrace].SUB then
		local parent = entity.Parent and entity.Parent:ToNPC()

		if parent then
			local pdata = parent:GetData()
			local target = parent:GetPlayerTarget()

			local data = entity:GetData()
			local sprite = entity:GetSprite()
			local room = game:GetRoom()

			if not data.Init then
				data.Init = true

				if data.Inactive == nil then
					data.Inactive = true
				end
				
				data.IsBlack = not pdata.IsBlack

				data.State = data.State or mod.RSaturnState.IDLE0
				data.StateFrame = 0
	
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

				data.MoveNodes = pdata.MoveNodes or {room:GetCenterPos()}
				data.CurrentNode = data.MoveNodes[mod:RandomInt(1,#data.MoveNodes)]

				data.GhostFrames = 0
			end
		
			--Frame
			data.StateFrame = data.StateFrame + 1

			if data.Inactive then
				if entity.FrameCount%30==0 then
					entity:SetColor(Color(1,1,1,0.35), 60, 1,true,true)
				end

				if data.State == mod.RSaturnState.IDLE0 then
					if data.StateFrame == 1 or sprite:IsFinished("IdleSmall") then
						sprite:Play("IdleSmall", true)
					end
				elseif data.State == mod.RSaturnState.IDLE1 then
					if data.StateFrame == 1 or sprite:IsFinished("IdleMed") then
						sprite:Play("IdleMed", true)
					end
					mod:RSaturnMove(entity, data, room, target)
				end

				mod:RSaturnMoveFace(entity, data, sprite, target.Position)

				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			else

				if data.State == mod.RSaturnState.IDLE0 then
					if data.StateFrame == 1 or sprite:IsFinished("IdleSmall") then
						sprite:Play("IdleSmall", true)
					end
					mod:RSaturnMoveFace(entity, data, sprite, target.Position)
				elseif data.State == mod.RSaturnState.DART then
					mod:RSaturnDart(entity, data, sprite, target, room)

				elseif data.State == mod.RSaturnState.IDLE1 then
					if data.StateFrame == 1 or sprite:IsFinished("IdleMed") then
						sprite:Play("IdleMed", true)
					end
					mod:RSaturnMoveFace(entity, data, sprite, target.Position)
					mod:RSaturnMove(entity, data, room, target)
				elseif data.State == mod.RSaturnState.LICK then
					mod:RSaturnLick(entity, data, sprite, target, room)
				end
			
				if data.GhostFrames > 0 then
					data.GhostFrames = data.GhostFrames - 1
					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				else
					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				end
			end
		else
			entity:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.FakeTraceUpdate, mod.EntityInf[mod.Entity.OuroborosFakeTrace].ID)

function mod:ChanceFakeTracesStates(parent, newState)
	for i, entity in ipairs(parent:GetData().Traces) do
		local data = entity:GetData()
		if not data.Inactive then
	
			data.State = newState
			data.StateFrame = 0
		end
	end
end

function mod:FakeTraceDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.OuroborosFakeTrace].VAR and entity.SubType == mod.EntityInf[mod.Entity.OuroborosFakeTrace].SUB then
		local parent = entity.Parent
		if parent then
			local targetSeed = entity.InitSeed
			local targetIndex = -1

			--identify and remove
			for i, trace in ipairs(parent:GetData().Traces) do
				if trace.InitSeed == targetSeed then
					targetIndex = i
					break
				end
			end
			if targetIndex >= 0 then
				table.remove(parent:GetData().Traces, targetIndex)
			end

			--update ghosts
			mod:UpdateRSaturnTraces(parent)

			--remove laser
			for i, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER, LaserVariant.TRACTOR_BEAM)) do
				if laser.SpawnerEntity and laser.SpawnerEntity.InitSeed == targetSeed then
					laser:Remove()
					break
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.FakeTraceDeath, mod.EntityInf[mod.Entity.OuroborosFakeTrace].ID)
function mod:UpdateRSaturnTraces(entity)
	local data = entity:GetData()
	for i, trace in ipairs(entity:GetData().Traces) do
		if data.phase == 1 then
			trace:GetData().Inactive = i > mod.RSaturnConst.MAX_FAKE_TRACES_MED
		else
			trace:GetData().Inactive = i > mod.RSaturnConst.MAX_FAKE_TRACES
		end

		trace:GetData().GhostFrames = 30
	end
	
end

--STEVENS
function mod:StevenUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Steven].VAR and entity.SubType == mod.EntityInf[mod.Entity.Steven].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		local r = 20
		if not data.Init then
			data.Init = true
			data.Repeats = r

			sfx:Play(Isaac.GetSoundIdByName("timeFcuk1"), 1, 30, true)
			
			entity.SplatColor = fullblack

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("Idle1", true)
		end

		if entity.FrameCount > 300 and sprite:GetAnimation() ~= "Idle4" then
			entity:SetColor(Color(1,1,1,1,1,1,1), 30, 1, true, true)
			sprite:Play("Idle4", true)

			sfx:Stop(Isaac.GetSoundIdByName("timeFcuk1"))
			sfx:Stop(Isaac.GetSoundIdByName("timeFcuk2"))
			sfx:Stop(Isaac.GetSoundIdByName("timeFcuk3"))
		
			sfx:Play(Isaac.GetSoundIdByName("fuckSpare"), 3)
			sfx:Play(SoundEffect.SOUND_THUMBSUP)
			
		end

		if sprite:IsFinished("Idle1") then
			data.Repeats = data.Repeats - 1
			if data.Repeats <= 0 then
				data.Repeats = r
				sprite:Play("Idle12", true)
			end

		elseif sprite:IsFinished("Idle2") then
			data.Repeats = data.Repeats - 1
			if data.Repeats <= 0 then
				data.Repeats = r
				sprite:Play("Idle23", true)
			end

		elseif sprite:IsFinished("Idle3") then
			sprite:Play("Idle3", true)
			

		elseif sprite:IsFinished("Idle12") then
			sprite:Play("Idle2", true)
		elseif sprite:IsFinished("Idle23") then
			sprite:Play("Idle3", true)
			
		elseif sprite:IsFinished("Idle4") then
			sprite:Play("Idle4", true)
			if entity.FrameCount > 800 or not sfx:IsPlaying(Isaac.GetSoundIdByName("fuckSpare")) then
				entity:Die()
			end


		elseif sprite:IsEventTriggered("Switch") then
			if sprite:IsPlaying("Idle12") and not data.s12 then
				data.s12 = true
				sfx:Play(Isaac.GetSoundIdByName("timeFcuk2"), 1.5, 60, true)

			elseif sprite:IsPlaying("Idle23") and not data.s23 then
				data.s23 = true
				sfx:Play(Isaac.GetSoundIdByName("timeFcuk3"), 2, 90, true)
			end
		end

		local offset = Vector(1 - 2*(entity.FrameCount % 2), 0)
		sprite.Offset = offset

		entity.Velocity = Vector.Zero

	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.StevenUpdate, mod.EntityInf[mod.Entity.Steven].ID)

function mod:StevenDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Steven].VAR and entity.SubType == mod.EntityInf[mod.Entity.Steven].SUB then
		sfx:Stop(Isaac.GetSoundIdByName("timeFcuk1"))
		sfx:Stop(Isaac.GetSoundIdByName("timeFcuk2"))
		sfx:Stop(Isaac.GetSoundIdByName("timeFcuk3"))

		for j=1, 2 do
			for i=1, 8 do
				local angle = i*360/8
				local velocity = Vector.FromAngle(angle) * 4 * j
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, entity.Position, velocity, nil):ToProjectile()
				tear:AddProjectileFlags(ProjectileFlags.CONTINUUM | ProjectileFlags.ACCELERATE)
				tear:GetData().ForceDefaultColor = true
				tear.Scale = 2
				tear.Acceleration = 1.005
				mod:TearFallAfter(tear, 60)
			end
		end
		if game:GetRoom():GetType() == RoomType.ROOM_BOSS and not mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_LITTLE_STEVEN) then
			local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LITTLE_STEVEN, entity.Position, Vector.Zero, nil)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.StevenDeath, mod.EntityInf[mod.Entity.Steven].ID)

--WARPERS
--DRIFTER
function mod:DrifterUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Drifter].VAR and entity.SubType == mod.EntityInf[mod.Entity.Drifter].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()

		if not data.Init then
			data.Init = true
			data.Flaged = false

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("Appear")

			if data.IsBlack == nil then
				data.IsBlack = true
			end

			data.IsBlack = not data.IsBlack
			mod:DrifterSwitch(entity, data, sprite)
			
			entity.SplatColor = fullblack
		end

		if sprite:IsFinished("Appear") then

			sprite:PlayOverlay("Head"..tostring(mod:RandomInt(1,3)), true)
			sprite:SetOverlayRenderPriority(false)
		end

		if not sprite:IsPlaying("Appear") then

			sprite.FlipX = false
			if entity.Velocity:Length() <= 0 then
				sprite:Play("WalkV", true)
				sprite:Stop()
			else
				if entity.Velocity.X > 0 then
					if not sprite:IsPlaying("WalkR") then
						sprite:Play("WalkR", true)
					end
				elseif entity.Velocity.X < 0 then
					if not sprite:IsPlaying("WalkL") then
						sprite:Play("WalkL", true)
					end
				else
					if not sprite:IsPlaying("WalkV") then
						sprite:Play("WalkV", true)
					end
				end
			end
		end

	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.DrifterUpdate, mod.EntityInf[mod.Entity.Drifter].ID)

function mod:DrifterDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Drifter].VAR and entity.SubType == mod.EntityInf[mod.Entity.Drifter].SUB then
		
		local isBlack = #entity:GetSprite():GetLayer(0):GetSpritesheetPath() == 41

		local froh = mod:SpawnEntity(mod.Entity.Froh, entity.Position, Vector.Zero, nil)
		froh:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		froh:GetSprite():Play("Appear", true)
		froh:GetData().IsBlack = isBlack
		froh.HitPoints = 9999
		
		local warper = mod:SpawnEntity(mod.Entity.Warper, entity.Position, Vector.Zero, nil)
		warper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		warper:GetSprite():Play("Appear", true)
		warper:GetData().IsBlack = isBlack
		warper.HitPoints = 9999

		
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.DrifterDeath, mod.EntityInf[mod.Entity.Drifter].ID)

function mod:DrifterSwitch(entity, data, sprite)
	local sheet1 = "hc/gfx/monsters/warper/monster_bodies.png"
	local sheet2 = "hc/gfx/monsters/warper/monster_gaper.png"
	local sheet3 = "hc/gfx/monsters/warper/drifter_spawn.png"
	entity.SplatColor = fullblack
	if data.IsBlack then
		sheet1 = "hc/gfx/monsters/warper/monster_bodies_inverse.png"
		sheet2 = "hc/gfx/monsters/warper/monster_gaper_inverse.png"
		sheet3 = "hc/gfx/monsters/warper/drifter_spawn_inverse.png"
		entity.SplatColor = fullwhite
		
		entity:SetColor(fullblack, 10, 2, true, true)
	else
		entity:SetColor(fullwhite, 10, 2, true, true)
	end

	data.IsBlack = not data.IsBlack

	sprite:ReplaceSpritesheet(0, sheet1)
	sprite:ReplaceSpritesheet(1, sheet2)
	sprite:ReplaceSpritesheet(2, sheet3, true)

	sfx:Play(Isaac.GetSoundIdByName("flipsound"))
end

--FROH
function mod:FrohPreUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Froh].VAR and entity.SubType == mod.EntityInf[mod.Entity.Froh].SUB then

		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if not data.Init then
			data.Init = true

			entity.SplatColor = fullblack

			
			if data.IsBlack == nil then
				data.IsBlack = true
			end

			data.IsBlack = not data.IsBlack
			mod:FrohSwitch(entity, data, sprite)

		end
		if entity.FrameCount == 2 then entity.HitPoints = entity.MaxHitPoints end


		if sprite:IsEventTriggered("Shoot") then
			local target = entity:GetPlayerTarget()
			local velocity = (target.Position - entity.Position):Normalized() * mod.RSaturnConst.FROH_SHOT_SPEED
			for i=-1, 1, 2 do
				local finalVelocity = velocity:Rotated(40*i)
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, entity.Position, finalVelocity, entity):ToProjectile()
				tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
				tear:GetData().ForceDefaultColor = true
				mod:TearFallAfter(tear, 75)
			end
			
			sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_LARGE, 1, 2, false, 2)
			sfx:Play(Isaac.GetSoundIdByName("touhouBullet"), 0.8, 2, false, 2)

			sfx:Play(Isaac.GetSoundIdByName("flipsound"))
			return true
		end

		if sprite:IsFinished("Attack") then
			mod:FrohSwitch(entity, data, sprite)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.FrohPreUpdate, mod.EntityInf[mod.Entity.Froh].ID)

function mod:FrohSwitch(entity, data, sprite)
	local sheet = "hc/gfx/monsters/warper/monster_horf.png"
	entity.SplatColor = fullblack
	if data.IsBlack then
		sheet = "hc/gfx/monsters/warper/monster_horf_inverse.png"
		entity.SplatColor = fullwhite
		
		entity:SetColor(fullblack, 10, 2, true, true)
	else
		entity:SetColor(fullwhite, 10, 2, true, true)
	end

	data.IsBlack = not data.IsBlack

	sprite:ReplaceSpritesheet(0, sheet, true)
end

--WARPER
function mod:WarperPreUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Warper].VAR and entity.SubType == mod.EntityInf[mod.Entity.Warper].SUB then

		local sprite = entity:GetSprite()
		local data = entity:GetData()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()

		if not data.Init then
			data.Init = true

			if data.IsBlack == nil then
				data.IsBlack = true
			end

			data.IsBlack = not data.IsBlack
			mod:WarperSwitch(entity, data, sprite)
			
			entity.SplatColor = fullblack

		end
		if entity.FrameCount == 2 then entity.HitPoints = entity.MaxHitPoints end

		if (sprite:IsPlaying("Idle")) and (not room:IsPositionInRoom(entity.Position, 60)) then--and rng:RandomFloat() < mod.RSaturnConst.WARPER_JUMP_CHANCE then
			local ex = entity.Position.X
			local ey = entity.Position.Y
			local tx = target.Position.X
			local ty = target.Position.Y
	
			local u = 40
			local v = 100
			if math.abs(ex-tx) < u or math.abs(ey-ty) < u then
				local cx = room:GetCenterPos().X
				local cy = room:GetCenterPos().Y

				if ((math.abs(ey-ty) < u) and ((math.abs(ex-room:GetBottomRightPos().X) < v) or (math.abs(ex-room:GetTopLeftPos().X) < v)) and ((ex > tx and ex > cx) or (ex < tx and ex < cx))) or
				 ((math.abs(ex-tx) < u) and ((math.abs(ey-room:GetBottomRightPos().Y) < v) or (math.abs(ey-room:GetTopLeftPos().Y) < v)) and ((ey > ty and ey > cy) or (ey < ty and ey < cy))) then

					data.ShouldWarp = true
	
					if math.abs(ey-ty) < u then
						if ex>tx then
							data.Direction = Vector(1,0)
						else
							data.Direction = Vector(-1,0)
						end
					else
						if ey>ty then
							data.Direction = Vector(0,1)
						else
							data.Direction = Vector(0,-1)
						end
					end
	
					sprite:Play("Hop", true)
				end
			end
		end

		if data.ShouldWarp then

			if sprite:WasEventTriggered("Jump") and not sprite:WasEventTriggered("Land") then
				entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE

				local velocity = data.Direction * 50
				entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.05)

				local testPosition = entity.Position - data.Direction * 50
				if not data.Warped and not room:IsPositionInRoom(testPosition, 0) then
					data.Warped = true
					mod:WarperSwitch(entity, data, sprite)
					local direction = entity.Position - room:GetCenterPos()
					if data.Direction.X == 0 then
						direction.Y = -direction.Y
					else
						direction.X = -direction.X
					end

					entity.Position = room:GetCenterPos() + direction
				end
			end

			if sprite:IsEventTriggered("Land") then
				entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
				data.ShouldWarp = false

				for i=0,3 do
					local angle = 45 + 90*i
					local velocity = Vector.FromAngle(angle) * mod.RSaturnConst.WARPER_SHOT_SPEED
					local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, entity.Position, velocity, entity):ToProjectile()
					tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
					tear:GetData().ForceDefaultColor = true
				end
				data.Warped = false

				sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS)
			end

			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.WarperPreUpdate, mod.EntityInf[mod.Entity.Warper].ID)

function mod:WarperSwitch(entity, data, sprite)
	local sheet = "hc/gfx/monsters/warper/monster_hopperleaper.png"
	entity.SplatColor = fullblack
	if data.IsBlack then
		sheet = "hc/gfx/monsters/warper/monster_hopperleaper_inverse.png"
		entity.SplatColor = fullwhite
	end

	data.IsBlack = not data.IsBlack

	sprite:ReplaceSpritesheet(0, sheet, true)
	
	sfx:Play(Isaac.GetSoundIdByName("flipsound"))
end

--BALL
function mod:StevenBallUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.StevenBall].VAR and entity.SubType == mod.EntityInf[mod.Entity.StevenBall].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if not data.Init then
			data.Init = true
			
			data.Velocity = -15
			data.Acceleration = 1

			entity.SplatColor = fullblack

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("Idle", true)

			if data.IsHorf == nil then data.IsHorf = false end

			mod:StevenBallSwitch(entity, data, sprite)
			mod:StevenBallSwitch(entity, data, sprite)
		end

		data.Velocity = data.Velocity + data.Acceleration

		sprite.Offset.Y = sprite.Offset.Y + data.Velocity
		if sprite.Offset.Y > 0 then
			local summon
			if data.IsHorf then
				local froh = mod:SpawnEntity(mod.Entity.Froh, entity.Position, Vector.Zero, nil)
				froh:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				froh:GetSprite():Play("Appear", true)
				froh:GetData().IsBlack = data.IsBlack

				summon = froh
				
				sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 2, false, 1)
			else
				local drifter = mod:SpawnEntity(mod.Entity.Drifter, entity.Position, Vector.Zero, nil)
				drifter:GetData().IsBlack = data.IsBlack
				
				summon = drifter

				sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 2, false, 1)
			end

			if summon then
				local room = game:GetRoom()
				if not room:IsPositionInRoom(summon.Position, summon.Size) then
					local direction = (room:GetCenterPos() - summon.Position):Normalized()
					summon.Position = summon.Position + direction*20
				end
			end

			entity:Die()
		end

	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.StevenBallUpdate, mod.EntityInf[mod.Entity.StevenBall].ID)

function mod:StevenBallSwitch(entity, data, sprite)

	local sheet = ""
	
	if data.IsHorf then
		sheet = "hc/gfx/monsters/warper/gutball_gaper.png"
		if data.IsBlack then
			sheet = "hc/gfx/monsters/warper/gutball_gaper_inverse.png"
		end
	else
		sheet = "hc/gfx/monsters/warper/gutball.png"
		if data.IsBlack then
			sheet = "hc/gfx/monsters/warper/gutball_inverse.png"
		end
	end
	
	entity.SplatColor = fullblack
	if data.IsBlack then
		entity.SplatColor = fullwhite
	end

	data.IsBlack = not data.IsBlack

	sprite:ReplaceSpritesheet(0, sheet, true)
end

--LASER
function mod:StevenLaserUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.StevenLaser].VAR and entity.SubType == mod.EntityInf[mod.Entity.StevenLaser].SUB then
		local parent = entity.Parent and entity.Parent:ToNPC()

		if parent then
			local data = entity:GetData()
			local sprite = entity:GetSprite()
			local room = game:GetRoom()
			local target = parent:GetPlayerTarget()
			local pdata = parent:GetData()
	
			if not data.Init then
				data.Init = true
	
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear", true)
	
				data.State = 0
				data.StateFrame = 0

				data.Index = data.Index or 1
				data.Total = data.Total or 1

				data.Angle = 360*data.Index/data.Total

				data.Distance = 50
				
				data.IsBlack = not pdata.IsBlack
				mod:SteveLaserSwitch(entity, data, sprite)
				mod:SteveLaserSwitch(entity, data, sprite)
				
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			data.StateFrame = data.StateFrame + 1
	
			if data.State == 0 then
				if sprite:IsFinished() then
					if rng:RandomFloat() < mod.RSaturnConst.LASER_SHOT_CHANCE then
						data.State = 1
						data.StateFrame = 0
					else
						sprite:Play("Idle", true)
					end
				end
			else
				if data.StateFrame == 1 then
					if entity.Position:Distance(target.Position) > 60 then
						data.Idles = 0--mod.RSaturnConst.PRE_LASER_IDLES
						sprite:Play("Idle", true)
					else
						data.State = 0
						data.StateFrame = 0
					end
	
				elseif sprite:IsFinished("Idle") then
					data.Idles = data.Idles - 1
					if data.Idles <= 0 then
						sprite:Play("Attack", true)
					else
						sprite:Play("Idle", true)
					end
	
				elseif sprite:IsFinished("Attack") then
					data.State = 0
					data.StateFrame = 0
					
				elseif sprite:IsEventTriggered("Attack") then
					if false and room:IsPositionInRoom(entity.Position, 20) then
						local angle = (parent.Position - entity.Position):GetAngleDegrees()
						local position = entity.Position + Vector.FromAngle(angle)
						local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, position, angle, 5, Vector(0,-35), entity)
						laser.CollisionDamage = 20
						laser:SetMultidimensionalTouched(true)
						laser:Update()
						if data.IsBlack ~= nil then
							if data.IsBlack then
								laser:GetSprite().Color = fullwhite
							else
								laser:GetSprite().Color = fullblack
							end
						end
					end
					if true then
						local targetPos = target.Position
						if rng:RandomFloat() < 0.5 then
							targetPos = parent.Position
						end
						for i=1, mod.RSaturnConst.N_LASER_PROJS do
							local angle = (targetPos - entity.Position):GetAngleDegrees()
							local velocity = Vector.FromAngle(angle) * mod.RSaturnConst.LASER_PROJ_SPEED * (0.7 + 0.3*i/mod.RSaturnConst.N_LASER_PROJS)
										
							local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FCUK, 0, entity.Position, velocity, entity):ToProjectile()
							tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
							tear:GetData().ForceDefaultColor = true
							mod:TearFallAfter(tear, 75)

							if i==mod.RSaturnConst.N_LASER_PROJS then
								tear.Scale = 2
							end
						end
						
						sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_LARGE, 1, 2, false, 2)
						sfx:Play(Isaac.GetSoundIdByName("touhouBullet"), 0.8, 2, false, 1.2)
					end
				end
			end


			data.Distance = data.Distance + mod.RSaturnConst.LASER_DISTANCE_SPEED
			data.Angle = data.Angle + mod.RSaturnConst.LASER_ANGLE_SPEED
			if data.Distance > 450 then
				entity:Die()
			end

			local targetPos = parent.Position + Vector.FromAngle(data.Angle) * data.Distance
			local velocity = targetPos - entity.Position
			entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.02)

			--mod:RSaturnMoveFace(entity, data, sprite, target.Position)
		else
			entity:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.StevenLaserUpdate, mod.EntityInf[mod.Entity.StevenLaser].ID)

function mod:SteveLaserSwitch(entity, data, sprite)

	local sheet = "hc/gfx/monsters/warper/laser_steven.png"
	if data.IsBlack then
		sheet = "hc/gfx/monsters/warper/laser_steven_inverse.png"
		
		entity:SetColor(fullblack, 10, 2, true, true)
	else
		entity:SetColor(fullwhite, 10, 2, true, true)
	end
	
	entity.SplatColor = fullblack
	if data.IsBlack then
		entity.SplatColor = fullwhite
	end

	data.IsBlack = not data.IsBlack

	sprite:ReplaceSpritesheet(0, sheet, true)
end
--GHOST TIMELINE PHASE
function mod:OuroborosGhostUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.SaturnGhost].VAR and entity.SubType == mod.EntityInf[mod.Entity.SaturnGhost].SUB then

		local parent = entity.Parent and entity.Parent:ToNPC()

		if parent then
			local data = entity:GetData()
			local sprite = entity:GetSprite()
			local room = game:GetRoom()
			local target = parent:GetPlayerTarget()
			local pdata = parent:GetData()

			if not data.Init then
				data.Init = true
				data.phase = data.phase or 0

				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

				data.TargetPosition = room:GetRandomPosition(20)

				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_HIDE_HP_BAR)
				mod:RSaturnGrowTo(entity, data, sprite, data.phase)
				
				mod.ShaderData.ouroborosGhosts[data.phase+1] = entity

				data.IsBlack = pdata.IsBlack
				mod:RSaturnSwitch(entity, data, sprite, true)

				mod:OuroborosGhostDamage(entity, 0, 0, nil, 0)
				
			end

			if sprite:IsFinished() then
				sprite:Play(sprite:GetAnimation(), true)
			end

			local direction = (data.TargetPosition - entity.Position):Resized(mod.RSaturnConst.GHOST_SPEED)
			entity.Velocity = mod:Lerp(entity.Velocity, direction, 0.1)
			if entity.Position:Distance(data.TargetPosition) < 10 then
				data.TargetPosition = room:GetRandomPosition(20)
			end

			mod:RSaturnMoveFace(entity, data, sprite, target.Position)
				
			local r = 10 / (target.Position - entity.Position):Length()
			r = r^2
			if rng:RandomFloat() < r then
				room:DoLightningStrike(entity.FrameCount % 1000 + 1)
			end
		else
			entity:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.OuroborosGhostUpdate, mod.EntityInf[mod.Entity.SaturnGhost].ID)
function mod:OuroborosGhostDamage(entity, amount, flags, source, frames)
	if entity.Variant == mod.EntityInf[mod.Entity.SaturnGhost].VAR and entity.SubType == mod.EntityInf[mod.Entity.SaturnGhost].SUB then

		local parent = entity.Parent and entity.Parent:ToNPC()

		if parent then
			if mod.savedatasettings().Difficulty < mod.Difficulties.ATTUNED then
				if amount > 0 then
					parent:TakeDamage(amount, flags, source, frames)
				end
			else
				for i, saturn in ipairs(Isaac.FindByType(Isaac.GetEntityTypeByName("Ouroboros (Paradox Saturn)"))) do
					if (saturn.Variant == mod.EntityInf[mod.Entity.SaturnGhost].VAR and saturn.SubType == mod.EntityInf[mod.Entity.SaturnGhost].SUB) or (saturn.Variant == mod.EntityInf[mod.Entity.RSaturn].VAR and saturn.SubType == mod.EntityInf[mod.Entity.RSaturn].SUB) and saturn:GetData().phase then
	
						local sprite = mod.ShaderData.ouroborosGhostsSprites[saturn:GetData().phase+1]
						if sprite then
							local sheets = mod:RSaturnSwitch(saturn, saturn:GetData(), saturn:GetSprite())
	
							local sheet = sheets[1]
							local sheet2 = sheets[2]
						
							sprite:ReplaceSpritesheet(0, sheet)
							sprite:ReplaceSpritesheet(1, sheet)
							sprite:ReplaceSpritesheet(6, sheet2, true)
						end
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OuroborosGhostDamage, mod.EntityInf[mod.Entity.SaturnGhost].ID)

--STEVEN SCREEN
function mod:StevenShutUp()
	local audios = {"timeFcuk1", "timeFcuk2", "timeFcuk3", "fuckStart", "fuckP1", "fuckP2", "fuckOuroboros", "fuckSpare", "fuckCritical", "fuckPregnant", "fuckRandom", "fuckSkillIssue", "ouroborosDeath"}	
	for sound in ipairs(audios) do
		sfx:Stop(Isaac.GetSoundIdByName(sound))
	end
end
function mod:StevenScreenUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.StevenScreen].VAR and entity.SubType == mod.EntityInf[mod.Entity.StevenScreen].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if not data.Init then
			data.Init = true

			mod:StevenShutUp()

			data.State = 0
			data.Audio = data.Audio or ""
			data.AudioFrames = data.AudioFrames or 1
			data.AudioLenght = data.AudioLenght or 1


			if data.Ouroboros then
				mod.ShaderData.ouroborosScreen = entity
				entity.Position = -200 * Vector.One
			end

			sprite.Scale = Vector.One * 0.75
			entity.DepthOffset = 1000

			sprite:SetRenderFlags(AnimRenderFlags.STATIC)
		end

		if data.State == 0 then--idle
			if sprite:IsFinished() then
				sprite:Play("Idle", true)
			end
		elseif data.State == 1 then--talk
			if sprite:IsFinished() or sprite:GetAnimation() ~= "Talk" then
				sprite:Play("Talk", true)
			end
		elseif data.State == 2 then--death
			if sprite:IsFinished("Dissapear") then
				entity:Remove()
			elseif sprite:IsFinished() then
				sprite:Play("Dissapear", true)
			end
		elseif data.State == 3 then--ouroboros
			if sprite:IsFinished() then
				sprite:Play("Idle", true)
			end
		end

		if not data.Ouroboros then
			local angle = 5*math.sin(entity.FrameCount/5)
			sprite.Rotation = angle
		end
		
		if data.Ouroboros and entity.FrameCount > 30 and data.State == 3 and rng:RandomFloat() < 0.1 then
			data.Audio = "fuckRandom"
			data.State = 0
			data.AudioFrames = 1
			data.AudioLenght = 30*6
		end

		local audio = Isaac.GetSoundIdByName(data.Audio)

		data.AudioFrames = data.AudioFrames - 1
		if data.AudioFrames == 0 then
			sfx:Play(audio, 5)
			data.State = 1
		elseif data.AudioFrames < 0 then
			data.AudioLenght = data.AudioLenght - 1
			if data.AudioLenght == 0 or not sfx:IsPlaying(audio) then
				if data.Ouroboros then
					data.State = 3
				else
					data.State = 2
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.StevenScreenUpdate, mod.EntityInf[mod.Entity.StevenScreen].VAR)

function mod:SpawnStevenScreen(audioName, audioFrames, audioLenght, isFinal, position, isRandom)

	if isRandom then
		if #mod:FindByTypeMod(mod.Entity.StevenScreen) > 0 then return end
	end

	if position == nil then
		position = game:GetRoom():GetRandomPosition(48)
	end

	local steven = mod:SpawnEntity(mod.Entity.StevenScreen, position, Vector.Zero, nil)
	local data = steven:GetData()
	
	data.Audio = audioName
	data.AudioFrames = audioFrames
	data.AudioLenght = audioLenght
	data.Ouroboros = isFinal
	
end

--BABY STEVEN
function mod:BabyStevenUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.LilSteven].VAR and entity.SubType == mod.EntityInf[mod.Entity.LilSteven].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if not data.Init then
			data.Init = true
			
			entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_HIDE_HP_BAR)
			sprite:Play("Idle0")

			entity.SplatColor = fullblack
		end

		if sprite:IsFinished("Idle4") then
			entity:Die()
		end

		if TheFuture and entity.FrameCount > 30 then
			local nTumor = #Isaac.FindByType(Isaac.GetEntityTypeByName("Future Tumor Small"), Isaac.GetEntityVariantByName("Future Tumor Small"), Isaac.GetEntitySubTypeByName("Future Tumor Small"))
			if nTumor <= 0 then
				entity:Die()
			end

			if entity.FrameCount % mod:RandomInt(5, 25) == 0 then
				local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, entity.Position, mod:RandomVector(2,2), entity):ToEffect()
				trail.Color = TheFuture.ColorStevenBlood
				trail.SpriteOffset = Vector(0, -17)
				trail.SpriteScale = Vector(0.5,0.5)
				trail.DepthOffset = -15
				trail:Update()
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.BabyStevenUpdate, mod.EntityInf[mod.Entity.LilSteven].ID)
function mod:BabyStevenDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.LilSteven].VAR and entity.SubType == mod.EntityInf[mod.Entity.LilSteven].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		local ouroboros = mod:SpawnEntity(mod.Entity.RSaturn, entity.Position, Vector.Zero, nil)
		music:ResetPitch()
		if mod.savedatarun().ouroborosEnabled then
			TheFuture.Stage:SetBossMusic(mod.Music.OUROBOROS, Music.MUSIC_BOSS_OVER, Music.MUSIC_JINGLE_BOSS, TheFuture.Tracks.NEVERMORE_OUTRO)
		end
		
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.BabyStevenDeath, mod.EntityInf[mod.Entity.LilSteven].ID)

function mod:StevenBoxUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.StevenBox].VAR and entity.SubType == mod.EntityInf[mod.Entity.StevenBox].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()
		local target = entity:GetPlayerTarget()

		if not data.Init then
			data.Init = true

			data.State = 0

			if TheFuture and TheFuture.Stage:IsStage() then
				TheFuture.NevermoreMusicOverride = Music.MUSIC_BOSS_OVER
			end

			entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_HIDE_HP_BAR)
		end

		entity.Velocity = Vector.Zero

		if data.State == 0 and (target.Position:Distance(entity.Position) < 30 or entity.FrameCount > 150)  then
			data.State = 1
			sprite:Play("Open")
		elseif data.State == 1 and entity.FrameCount > 150+90 then
			data.State = 2
			sprite:Play("Dissapear", true)
		elseif data.State == 2 and sprite:IsFinished("Dissapear") then
			entity:Remove()
		end

		if sprite:IsEventTriggered("Open") then
			sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			local mn = 1
			local mx = 5

			local steven = mod:SpawnEntity(mod.Entity.LilSteven, entity.Position, Vector.Zero, nil)
			steven:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			steven:Update()
			steven.Velocity = mod:RandomVector(mx, mn)
			
			if TheFuture then
				local tumors = Isaac.FindByType(Isaac.GetEntityTypeByName("Future Tumor Small"), Isaac.GetEntityVariantByName("Future Tumor Small"), Isaac.GetEntitySubTypeByName("Future Tumor Small"))
				for i, tumor in ipairs(tumors) do
					tumor.CollisionDamage = 0
					tumor:Update()
                    tumor:GetData().DisableTumorSlowdown = true
				end
				for i=1,4-#tumors do
					local tumor = Isaac.Spawn(Isaac.GetEntityTypeByName("Future Tumor Small"), Isaac.GetEntityVariantByName("Future Tumor Small"), Isaac.GetEntitySubTypeByName("Future Tumor Small"), entity.Position, Vector.Zero, nil)
					tumor:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					tumor.CollisionDamage = 0
					tumor:Update()
                    tumor:GetData().DisableTumorSlowdown = true
					tumor.Velocity = mod:RandomVector(mx, mn)
				end
			end
		end

	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.StevenBoxUpdate, mod.EntityInf[mod.Entity.StevenBox].ID)

--PROJECTILE STUFF
function mod:ResetToDefaultColorValue(entity)
    local data = entity:GetData()

    if data.ForceDefaultColor then
        entity:GetSprite().Color = Color.Default

		if data.IsBlack ~= nil then
			if entity.Type == EntityType.ENTITY_LASER then
				if data.IsBlack then
					entity:GetSprite().Color = fullwhite
				else
					entity:GetSprite().Color = fullblack
				end
			else
				if data.IsBlack then
					entity:GetSprite().Color = fullblack
				else
					entity:GetSprite().Color = fullwhite
				end
			end
		end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.ResetToDefaultColorValue, ProjectileVariant.PROJECTILE_FCUK)
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.ResetToDefaultColorValue, LaserVariant.TRACTOR_BEAM)
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.ResetToDefaultColorValue, LaserVariant.THICKER_BRIM_TECH)
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.ResetToDefaultColorValue, LaserVariant.THICK_RED)

-- STEVEN SCREEN SUMMON TIME FCUK THING LOL
mod.ModFlags.FUTUREUPDATED = false
local frameCount = 0
function mod:OnFcukScreenRender()
	if not mod.FcukScreen then
		local sprite = Sprite()
		sprite:Load("hc/gfx/screen_Steven.anm2", true)
		sprite:Play("Idle", true)

		mod.FcukScreen = sprite

		ItemOverlay.Show(Isaac.GetGiantBookIdByName("The Hyperdice"))
		--ItemOverlay.Show(Giantbook.D100)

		sfx:Play(Isaac.GetSoundIdByName("fuckScreen"))
	end
	local sprite = mod.FcukScreen

	local hScreenSize = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())*0.5
	sprite:Render(hScreenSize)

	sprite:Update()

	if sprite:IsFinished() then
		mod.FcukScreen = nil
		frameCount = frameCount + 1
		if frameCount == 2 then

			if TheFuture and TheFuture.Stage:IsStage() then
				mod:ReplaceNevermore()
			end

			mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnFcukScreenRender)
			frameCount = 0
			if not mod.ModFlags.FUTUREUPDATED then
				if TheFuture then
					local t_info = {Isaac.GetEntityVariantByName("Future Tumor Small"), Isaac.GetEntitySubTypeByName("Future Tumor Small")}
					function mod:OnFutureTumorDeath(entity)
						if entity.Variant == t_info[1] and entity.SubType == t_info[2] then
							local steven = mod:FindByTypeMod(mod.Entity.LilSteven)[1]
							if steven then
								local sprite = steven:GetSprite()
								for i=0, 3 do
									if sprite:IsPlaying("Idle"..tostring(i)) then
										local frame = sprite:GetFrame()
										sprite:Play("Idle"..tostring(i+1), true)
										sprite:SetFrame(frame, "Idle"..tostring(i+1))
										break
									end
								end
							end
						end
					end
					mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnFutureTumorDeath, Isaac.GetEntityTypeByName("Future Tumor Small"))
	
					local n_info = {Isaac.GetEntityVariantByName("Nevermore"), Isaac.GetEntitySubTypeByName("Nevermore")}
					function mod:OnNevermoreUpdate(entity)
						if entity.Variant == n_info[1] and entity.SubType == n_info[2] then
							if mod.savedatarun().ouroborosEnabled then
								entity.Visible = false
								if entity.FrameCount == 1 then
									--music:PitchSlide(0)
								elseif entity.FrameCount > 2 then
									entity:Remove()
								end
								return false
							end
						end
					end
					mod:AddPriorityCallback(ModCallbacks.MC_NPC_UPDATE, CallbackPriority.EARLY, mod.OnNevermoreUpdate, Isaac.GetEntityTypeByName("Nevermore"))
					function mod:OnNevermoreInit(entity)
						if entity.Variant == n_info[1] and entity.SubType == n_info[2] then
							if mod.savedatarun().ouroborosEnabled then
								entity.Color = Color(0,0,0,0)
								entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
								entity.Visible = false
								local ouroboros = mod:SpawnEntity(mod.Entity.StevenBox, entity.Position, Vector.Zero, nil)

								mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01))

								return false
							end
						end
					end
					mod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.EARLY, mod.OnNevermoreInit, Isaac.GetEntityTypeByName("Nevermore"))
				end
			end
			mod.ModFlags.FUTUREUPDATED = true
		end
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnFcukScreenRender)

function mod:ReplaceNevermore()
	local level = game:GetLevel()

	mod.savedatarun().ouroborosEnabled = true
	mod.ModFlags.ouroborosEnabled = true
	
		
	--TheFuture.Stage:SetBossMusic(mod.Music.OUROBOROS, Music.MUSIC_BOSS_OVER, Music.MUSIC_JINGLE_BOSS, TheFuture.Tracks.NEVERMORE_OUTRO)
	TheFuture.Stage:SetBossMusic(Music.MUSIC_BOSS_OVER, Music.MUSIC_BOSS_OVER, Music.MUSIC_JINGLE_BOSS, TheFuture.Tracks.NEVERMORE_OUTRO)

	if false then
		TheFuture.StageAPIBosses = {
			Ouroboros_HC = StageAPI.AddBossData("Ouroboros_HC", {
				Name = "Ouroboros_HC",
				Portrait = "hc/gfx/ui/vs/portrait_ouroboros.png",
				Bossname = "hc/gfx/ui/vs/bossname_ouroboros.png",
				Rooms = StageAPI.RoomsList("Ouroboros_HC_Rooms", include("resources.hc.luarooms.future_ouroboros_hc")),
				Entity = {Type = mod.EntityInf[mod.Entity.RSaturn].ID, Variant = mod.EntityInf[mod.Entity.RSaturn].VAR},
				Offset = Vector(8, -16),
			}),
		}
		
		TheFuture.StageBosses = {
			"Ouroboros_HC",
		}
	
		TheFuture.Stage:SetBosses(TheFuture.StageBosses, true, true, false)

	elseif false then
		TheFuture.StageAPIBosses = {
			Nevermore = StageAPI.AddBossData("Nevermore", {
				Name = "Nevermore",
				Portrait = "hc/gfx/ui/vs/portrait_ouroboros.png",
				Bossname = "hc/gfx/ui/vs/bossname_ouroboros.png",
				Rooms = StageAPI.RoomsList("Ouroboros_HC_Rooms", include("resources.hc.luarooms.future_ouroboros_hc")),
				Entity = {Type = mod.EntityInf[mod.Entity.RSaturn].ID, Variant = mod.EntityInf[mod.Entity.RSaturn].VAR},
				Offset = Vector(8, -16),
			}),
		}
		
		TheFuture.StageBosses = {
			"Nevermore",
		}
	
		TheFuture.Stage:SetBosses(TheFuture.StageBosses, true)

	else
		StageAPI.GetBossData("Nevermore").Portrait = "hc/gfx/ui/vs/portrait_ouroboros.png"
		StageAPI.GetBossData("Nevermore").Bossname = "hc/gfx/ui/vs/bossname_ouroboros.png"
	end

end
function mod:RestoreNevermore()
	--pls ultrinik dont fuck up pls ultrinik dont fuck up, i dont want to savotage anything
	if mod.savedatarun().ouroborosEnabled or mod.ModFlags.ouroborosEnabled then
		mod.savedatarun().ouroborosEnabled = false
		mod.ModFlags.ouroborosEnabled = false
		
		print("nevermore restored")
		
		TheFuture.Stage:SetBossMusic(TheFuture.Tracks.NEVERMORE, Music.MUSIC_BOSS_OVER, Music.MUSIC_JINGLE_BOSS, TheFuture.Tracks.NEVERMORE_OUTRO)

		if false then
			TheFuture.StageAPIBosses = {
				Nevermore = StageAPI.AddBossData("Nevermore", {
					Name = "Nevermore",
					Portrait = "gfx/bosses/nevermore/nevermoreportrait.png",
					Bossname = "gfx/bosses/nevermore/nevermorebossname2.png",
					Rooms = StageAPI.RoomsList("NevermoreRooms", include("resources.luarooms.future_nevermore")),
					Entity = {Type = TheFuture.Monsters.Nevermore.ID, Variant = TheFuture.Monsters.Nevermore.Var},
					Offset = Vector(8, -16),
				}),
			}
			
			TheFuture.StageBosses = {
				"Nevermore",
			}
			
			TheFuture.Stage:SetBossMusic(TheFuture.Tracks.NEVERMORE, Music.MUSIC_BOSS_OVER, Music.MUSIC_JINGLE_BOSS, TheFuture.Tracks.NEVERMORE_OUTRO)
	
			TheFuture.Stage:SetBosses(TheFuture.StageBosses, true)
		elseif false then

			Isaac.ExecuteCommand("luamod thefuture")
			Isaac.ExecuteCommand("luamod thefuture_2993558907")
		else

			StageAPI.GetBossData("Nevermore").Portrait = "gfx/bosses/nevermore/nevermoreportrait.png"
			StageAPI.GetBossData("Nevermore").Bossname = "gfx/bosses/nevermore/nevermorebossname2.png"
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.RestoreNevermore)

function mod:NevermoreDeath(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Nevermore") and entity.SubType == Isaac.GetEntitySubTypeByName("Nevermore") then
		local sprite = entity:GetSprite()
		local data = entity:GetData()
		if sprite:GetAnimation() == 'killed' or sprite:GetAnimation() == 'spared' then
			mod.savedatarun().nevermoreDefeated = true
		end
	end
end
if TheFuture then
	mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.NevermoreDeath, Isaac.GetEntityTypeByName("Nevermore"))
end