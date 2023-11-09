local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()
local json = require("json")


--JUPITER---------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@&&&&&%%%%%%%(////((((((((((//(@@&&&&&&&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&&&@@%%************************//////&&&&&@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&@@///**********************************/&@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@/@**//((#%%########%%%%(((/*****************//&&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@#####%%%%%%&@@@@@@@@&%%#((((((((///********//****&&@@@@@@@@@@@@
@@@@@@@@@@@@@@@####%&&&&%&%&&&&&&&@@@@&&&%%%####((((((((////////////&&#@@@@@@@@@
@@@@@@@@@@@@&#%%%%%&&&%%%%%%%%%&&&&&&&&&&&&&&%%%%%##((((((((//////////&@@@@@@@@@
@@@@@@@@@@&%########%%#%#%%%%%%%&&&&&&&&&&&&&&&&&&&%%%###((((((((/////#&@@@@@@@@
@@@@@@@@@&#######%%%/*****/****&(***********%&%@@@@@&&&&%%%%%#(((######%@@@@@@@@
@@@@@@@@@%##%%//***&&*//(((((&((((((((((%@/*******(&&&@@&&&&&&&&&&&%%%&&@@@@@@@@
@@@@@@@@%%,***@(((##@@&@&&@@@&&&&&&@@&&#@#####((/*******&@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@%#&&@@@@@&//*****%@@@@&&&&,,,,,#&@@@&%##%@%((***********/&&@@@@@@@@@@@@
@@@@@@@@@##(((//,***(@@@@#,*#/%&@@@@@@@&******/@@@@%%%%%%#((((***********@@@@@@@
@@@@@@@@@********&@@@%    ....,..,/&@@@@@@@@******//&@@@@&&%%%%%%%%%####(@@@@@@@
@@@@@@@@@@****@@@@@@  ,((((   ...%..,&@@@@@@@@@////////////((((&@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@   ((###((  .,....,&@@@@@@@@@@@(///////**********,,*,*@@@@@@@
@@@@@@@@@@@@@@@@@@.(((#@@@@#((  ......(@@@@&&&@@@&&@@@@&#(*****(&&&&&&%#@@@@@@@@
@@@@@@@@@@@/%&&@&@&((#(&&@@#(* ......*%@@&&&&&&&&&&&&&&&&&&&&/*********&@@@@@@@@
@@@@@@@@@@@&#**/%%%%,((((((   ...,..,%@&&&&&&&&&&%%#**************(/(#%&@@@@@@@@
@@@@@@@@@@@@&%/***#%#,,,,,,,,,,,,,,/&&&&&&&&&&%///*******////((######%@@@@@@@@@@
@@@@@@@@@@@@@@%%#(///(##(***(*/(%&&&&&&&&&////*******////%%%%%%%(((%&@@@@@@@@@@@
@@@@@@@@@@@@@@@&%##((((///((####%%%%************//%%%&%%%&##((//*&&@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@&%##((########/////*/**/%%&&@@@@@@%%%********@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@&@@/(%%#(%#%&&&%%%%&&(##%%%@@/*****////@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@//((((#(@(((//*****////*/@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/***/(///(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

mod.JMSState = {
	APPEAR = 0,
	IDLE = 1,
	CHARGE1 = 2,
	CHARGE2 = 3,
	THUNDER = 4,
	SHOT = 5,
	CLOUD = 6,
	LASER = 7
}
mod.chainJ = {
	[mod.JMSState.APPEAR] = 	{0, 1,    0,    0,  0,    0,    0,    0},
	[mod.JMSState.IDLE] = 		{0, 0.2,  0.135, 0,  0.175, 0.2,  0.18, 0.11},
	--[mod.JMSState.IDLE] = 		{0, 0,     1,    0,  0,    0,     0,    0},
	--[mod.JMSState.IDLE] = 		{0, 0,     0,    0,  0,    0,     0,    1},
	[mod.JMSState.CHARGE1] = 	{0, 0,    0,    1,  0,    0,    0,    0},
	[mod.JMSState.CHARGE2] = 	{0, 1,    0,    0,  0,    0,    0,    0},
	[mod.JMSState.THUNDER] = 	{0, 0.75, 0.1,  0,  0,    0.15, 0,    0},
	[mod.JMSState.SHOT] = 		{0, 0.7,  0,    0,  0,    0.2,  0.1,  0},
	[mod.JMSState.CLOUD] = 		{0, 0.75, 0,    0,  0,    0.25, 0,    0},
	[mod.JMSState.LASER] = 		{0, 0.95, 0.05, 0,  0,    0,    0,    0}
	--[mod.JMSState.LASER] = 		{0, 0, 0, 0,  0,    0,    0,    1}
	
}
mod.JConst = {--Some constant variables of Jupiter

	idleTimeInterval = Vector(20,30),
	speed = 1.2,
	goCenterSpeed = 1.75,
	chargeSpeed = 32,
	shotSpeed = 12,
	cloudSpeed = 9,
	
	idleGasTime = 60,
	shotGasTime = 60,
	thunderGasTime = 90,
	laserGasTime = 90,
	cloudTraceGasTime = 50,
	chargeGasTime = 250,
	cloudGasTime = 300,

	laserKnockback = 20,
	cloudKnockback = 10,

	cloudTearScale = 1.6,
	chargeFartScale = 1.5 * 27^2,
	deathFartScale = 3,
	shotTearScale = 1.3,
	laserSpinSpeed = 1.75,
	cloudTraceGasScale = 0.5,
	cloudGasScale = 2,

	cloudDamage = 45,
	cloudExplosionRadius = 60,

	nCloudRndProjectiles = 10,
	nCloudRingProjectiles = 6,
	
	angleList = {-180, -165, -150, -135, -45, -30, -15, 0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180}
}

function mod:JupiterUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Jupiter].VAR and entity.SubType == mod.EntityInf[mod.Entity.Jupiter].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0 

			data.MoveTowards = false 
			data.CurrentAngle = -90 
			data.LaserFlag = false 
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.JMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainJ)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
			
		elseif data.State == mod.JMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				--Poison cloud:
				local angle = 360*rng:RandomFloat()
				local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position + Vector(65,0):Rotated(angle), Vector.Zero, entity):ToEffect()
				gas.Timeout = mod.JConst.idleGasTime
				
				data.State = mod:MarkovTransition(data.State, mod.chainJ)
				data.StateFrame = 0
				
			else
				mod:JupiterMove(entity, data, room, target)
			end
			
		elseif data.State == mod.JMSState.CHARGE1 then
			mod:JupiterCharge1(entity, data, sprite, target,room)
			
		elseif data.State == mod.JMSState.CHARGE2 then
			mod:JupiterCharge2(entity, data, sprite, target,room)
		
		elseif data.State == mod.JMSState.THUNDER then
			mod:JupiterThunder(entity, data, sprite, target,room)
		
		elseif data.State == mod.JMSState.SHOT then
			mod:JupiterShot(entity, data, sprite, target,room)
		
		elseif data.State == mod.JMSState.CLOUD then
			mod:JupiterCloud(entity, data, sprite, target,room)
		
		elseif data.State == mod.JMSState.LASER then
			mod:JupiterLaser(entity, data, sprite, target,room)
		end
		
		if data.MoveTowards then
			mod:MoveTowards(entity, data, room:GetCenterPos(), mod.JConst.goCenterSpeed)
		end
		
		--Eye things
		if data.TargetPosition_aim ~= nil and data.State ~= mod.JMSState.CHARGE1 then
			mod:JupiterLook(entity, data, data.TargetPosition_aim, sprite)
		else
			mod:JupiterLook(entity, data, target.Position, sprite)
		end

		--No poison (Doesnt work lol)
		--if entity:HasEntityFlags(EntityFlag.FLAG_POISON) then
		--	entity:ClearEntityFlags(EntityFlag.FLAG_POISON) 
		--end
	end
end
function mod:JupiterCharge1(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		sprite:Play("Charge1",true)
		sfx:Play(SoundEffect.SOUND_FAMINE_DEATH_2,1)
	elseif sprite:IsFinished("Charge1") then
		entity.Velocity = Vector(0,0)
		data.State = mod:MarkovTransition(data.State, mod.chainJ)
		data.StateFrame = 0
		
	--Set the aim to where its going to charge
	--TargetPosition_aim == some old position of the player
	elseif sprite:IsEventTriggered("SetAim") then
		data.TargetPosition_aim = target.Position
	--Starts charging
	elseif sprite:IsEventTriggered("ChargeStart") then
		entity.Velocity = (data.TargetPosition_aim - entity.Position):Normalized() * mod.JConst.chargeSpeed
		data.TargetPosition_aim = nil
		sfx:Play(SoundEffect.SOUND_WAR_BOMB_HOLD,1)
		
	--Spawns poison clouds
	elseif sprite:GetFrame() % 3 == 0 and sprite:GetFrame() >= 27 then
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, entity):ToEffect()
		gas.Timeout = mod.JConst.chargeGasTime;
	--Spawns fart
	elseif sprite:GetFrame() % 2 == 0 and sprite:GetFrame() >= 27 and sprite:GetFrame() < 40 then
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
		fart:GetSprite().Scale = mod.JConst.chargeFartScale * Vector(1,1)/(sprite:GetFrame()^2)

	end
	
	--Tasty collision with walls
	if entity:CollidesWithGrid() then
		game:ShakeScreen(25);
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE);
	end
end
function mod:JupiterCharge2(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		sprite:Play("Charge2",true)
	elseif sprite:IsFinished("Charge2") then
		data.TargetPosition_aim = nil
		data.State = mod:MarkovTransition(data.State, mod.chainJ)
		data.StateFrame = 0
	
	--Set the aim to where its going to charge
	--TargetPosition_aim == some old position of the player
	elseif sprite:IsEventTriggered("SetAim") then
		data.TargetPosition_aim = target.Position
	--Shot the laser
	elseif sprite:IsEventTriggered("ChargeLaser") then
		local player_direction = data.TargetPosition_aim - (entity.Position-Vector(0,75))
		local brimstone = EntityLaser.ShootAngle(12, entity.Position-Vector(0,75)+player_direction:Normalized()*45 , player_direction:GetAngleDegrees(), 5, Vector.Zero, entity)
		brimstone:GetSprite().Color = mod.Colors.jupiterLaser1
		if target.Position.Y >= entity.Position.Y then
			--This is to make the brimstone render below of above Jupiter
			brimstone.DepthOffset = 100
		end
		--Newton 3rd law
		entity.Velocity = -(player_direction):Normalized() * mod.JConst.laserKnockback
		
	end
	
	--Dont bounce on the walls you trash cow! (It makes the laser hard to predict)
	if entity:CollidesWithGrid() then
		entity.Velocity = Vector.Zero
		game:ShakeScreen(25);
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE);
	end
end
function mod:JupiterThunder(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		sfx:Play(Isaac.GetSoundIdByName("PreThunder"),1);
		sprite:Play("Thunder",true)

		entity.Velocity = Vector.Zero
		local aurora = mod:SpawnEntity(mod.Entity.Aurora, entity.Position + Vector(0,-110), Vector(0,0), entity):ToEffect()
		aurora.SpriteScale = Vector(0.85,0.8)
		aurora.DepthOffset = 300
		aurora:FollowParent (entity)

	elseif sprite:IsFinished("Thunder") then
		data.State = mod:MarkovTransition(data.State, mod.chainJ)
		data.StateFrame = 0
		
	--Summon lightbeams around the player, also fart (gas)
	elseif sprite:IsEventTriggered("Thunder") then
		--Lightbeams:
		for i = 1, 2 do
			local angle = 360*rng:RandomFloat()
			local position_aim = target.Position + Vector(90,0):Rotated(angle)
			--I swear I know whats the difference between thunder and lighting
			local thunder = mod:SpawnEntity(mod.Entity.Thunder,position_aim, Vector(0,0), entity)
			if mod:RandomInt(0,1)==0 then 
				thunder:GetSprite().FlipX = true
			end
			--local randomAnim = mod:RandomInt(1,6)
			--if randomAnim > 1 then
				--Doesnt work lol
				--thunder:GetSprite():Play("SpotlightDelayed"..tostring(randomAnim),true)
			--end
		end
		
		--Poison cloud:
		local angle = 360*rng:RandomFloat()
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position + Vector(95,0):Rotated(angle), Vector.Zero, entity):ToEffect()
		gas.Timeout = mod.JConst.thunderGasTime
		
		game:ShakeScreen(10);
	end
end
function mod:JupiterShot(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		if entity.Position:Distance(target.Position) < 160 then
			data.State = mod:MarkovTransition(data.State, mod.chainJ)
			data.StateFrame = 0
		else
			sprite:Play("Shot",true)
		end
	elseif sprite:IsFinished("Shot") then
		data.State = mod:MarkovTransition(data.State, mod.chainJ)
		data.StateFrame = 0
		
	--Shot and fart
	elseif sprite:IsEventTriggered("Shot") then
		--Fart and Poison cloud:
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
		local angle = 360*rng:RandomFloat()
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position + Vector(65,0):Rotated(angle), Vector.Zero, entity):ToEffect()
		gas.Timeout = mod.JConst.shotGasTime
		
		--Tear shots:
		local player_direction = target.Position - (entity.Position-Vector(0,35))
		for i = 1, 2 do
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position-Vector(0,35)+player_direction:Normalized()*45, player_direction:Rotated((-2*i+3)*23):Normalized()*mod.JConst.shotSpeed, entity)
			tear:GetSprite().Scale = mod.JConst.shotTearScale * Vector(1,1)
			tear:GetSprite().Color = mod.Colors.jupiterShot
		end
		
	end
end
function mod:JupiterCloud(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		if entity.Position:Distance(target.Position) < 135 then
			data.State = mod:MarkovTransition(data.State, mod.chainJ)
			data.StateFrame = 0
		else
			sfx:Play(SoundEffect.SOUND_ANGRY_GURGLE,1);
			sprite:Play("Cloud",true)
		end
	elseif sprite:IsFinished("Cloud") then
		data.State = mod:MarkovTransition(data.State, mod.chainJ)
		data.StateFrame = 0
		
	--Cloud shot
	elseif sprite:IsEventTriggered("Cloud") then
		--Fart:
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
		
		--Cloud projectile:
		local player_direction = target.Position - (entity.Position-Vector(0,75))
		local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position-Vector(0,75)+player_direction:Normalized()*45, player_direction:Normalized()*mod.JConst.cloudSpeed, entity):ToProjectile()
		tear:GetSprite().Scale = mod.JConst.cloudTearScale * Vector(1,1)
		tear:AddProjectileFlags(ProjectileFlags.WIGGLE)
		tear:GetData().cloudJupiterProjectile = true --flag to check in projectile update function
		tear:GetSprite().Color = mod.Colors.boom
		tear.Parent = entity
		
		entity.Velocity = -(target.Position - entity.Position):Normalized() * mod.JConst.cloudKnockback
		
		sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,5);
	end
end
function mod:JupiterLaser(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		sprite:Play("Laser",true)
		sfx:Play(SoundEffect.SOUND_SATAN_CHARGE_UP,1);
	elseif sprite:IsFinished("Laser") then
		data.TargetPosition_aim = nil
		data.LaserFlag=false
		data.State = mod:MarkovTransition(data.State, mod.chainJ)
		data.StateFrame = 0
	
	--Go to the center
	elseif sprite:IsEventTriggered("Jump") then
		data.MoveTowards = true
		entity.CollisionDamage = 0
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	
	--Set the aim to where its going to charge
	--TargetPosition_aim == some old position of the player
	elseif sprite:IsEventTriggered("SetAim") then
        sfx:Play(Isaac.GetSoundIdByName("Slam"), 1, 2, false, 1)

		game:ShakeScreen(35);
		entity.Position = room:GetCenterPos()
		entity.Velocity = Vector.Zero
		data.MoveTowards = false
		data.TargetPosition_aim = target.Position
		entity.CollisionDamage = 1
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		
	--Laser
	elseif sprite:IsEventTriggered("Laser") then
		--Brimstone:
		local player_direction = data.TargetPosition_aim - (entity.Position + Vector(0,-75))
		local superbrimstone = EntityLaser.ShootAngle(14, entity.Position + Vector(0,-75), player_direction:GetAngleDegrees(), 37, Vector.Zero, entity)
		superbrimstone:GetSprite().Color = mod.Colors.jupiterLaser2
		superbrimstone:GetData().JupiterLaser = true
		data.LaserFlag=true
		--Spin direction
		local p1 = target.Position-entity.Position
		local p2 = data.TargetPosition_aim-entity.Position
		local crossproductZ = p1.X * p2.Y - p1.Y * p2.X
		data.Spin = 1
		if crossproductZ > 0 then
			data.Spin = -1
		end
		superbrimstone:SetActiveRotation(0, 99999, data.Spin*mod.JConst.laserSpinSpeed)

		--Move the target a little
		data.TargetPosition_aim = (data.TargetPosition_aim - entity.Position):Rotated(data.Spin*15/2) + entity.Position
		
	elseif sprite:IsEventTriggered("LaserShot") then
		local extra = 0
		if sprite:GetFrame() == 68 then
			extra = 360/8
		end
		
		for i = 1 , 4 do
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position-Vector(0,30), ((Vector(1,0)):Rotated(i*360/4+ extra)):Normalized()*7, entity):ToProjectile()
			tear.FallingSpeed = 0
			tear.FallingAccel = -0.1
			tear:GetSprite().Color = mod.Colors.jupiterShot
		end
		
		local angle = 360*rng:RandomFloat()
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position + Vector(95,0):Rotated(angle), Vector.Zero, entity):ToEffect()
		gas.Timeout = mod.JConst.laserGasTime
	end
	
	if data.LaserFlag then
		data.TargetPosition_aim = (data.TargetPosition_aim - entity.Position):Rotated(data.Spin*mod.JConst.laserSpinSpeed) + entity.Position

		entity.Velocity = Vector.Zero
	end
	
end

--Move
function mod:JupiterMove(entity, data, room, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room
	
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.JConst.idleTimeInterval.X, mod.JConst.idleTimeInterval.Y)
		--V distance of Jupiter from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > 80 then
			data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		--Else, get closer to the player
		else
			data.targetvelocity = ((target.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
		end
	end
	
	--If run out of idle time
	if data.idleTime <= 0 and data.idleTime ~= nil then
		data.idleTime = nil
	else
		data.idleTime = data.idleTime - 1
	end
	
	--Do the actual movement
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.JConst.speed
	data.targetvelocity = data.targetvelocity * 0.99
end

--Move eye
function mod:JupiterLook(entity, data, TargetPosition_aim)
	local angle = -(entity.Position-TargetPosition_aim):GetAngleDegrees()
	if math.abs(angle-data.CurrentAngle)>15/2 then
		local sprite = entity:GetSprite()
		if not (-45 > angle and angle > -135) then
			local new_angle = mod:Takeclosest(mod.JConst.angleList,angle)
			sprite:ReplaceSpritesheet (2, "gfx/bosses/jupiter_eyes/"..tostring(new_angle)..".png")
			sprite:ReplaceSpritesheet (3, "gfx/bosses/jupiter_eyes/"..tostring(new_angle)..".png")
		
		else
			sprite:ReplaceSpritesheet (2, "gfx/bosses/jupiter_eyes/-90.png")
			sprite:ReplaceSpritesheet (3, "gfx/bosses/jupiter_eyes/-90.png")
		end
		sprite:LoadGraphics()
	end
end

--ded
function mod:JupiterDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Jupiter].VAR and entity.SubType == mod.EntityInf[mod.Entity.Jupiter].SUB then
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.boom)
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		bloody:GetSprite().Color = mod.Colors.boom
		--Fart:
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
		fart:GetSprite().Scale = mod.JConst.deathFartScale*Vector(1,1)
		sfx:Play(Isaac.GetSoundIdByName("SuperFart"), 3)
		mod:NormalDeath(entity)
	end
end
--deding
function mod:JupiterDying(entity)
	
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if sprite:IsPlaying("Death") then
		if sprite:GetFrame() == 1 then
			sfx:Play(SoundEffect.SOUND_FAT_GRUNT,2.5,2,false,0.3)
			--Poison cloud:
			local angle = 360*rng:RandomFloat()
			local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position + Vector(65,0):Rotated(angle), Vector.Zero, entity):ToEffect()
			gas.Timeout = mod.JConst.idleGasTime*3
		elseif sprite:IsEventTriggered("Farting") then
			--Poison cloud:
			local angle = 360*rng:RandomFloat()
			local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position + Vector(65,0):Rotated(angle), Vector.Zero, entity):ToEffect()
			gas.Timeout = mod.JConst.idleGasTime*5
		end
	end
end

--CloudJupiterProjectile
function mod:CloudJupiterProjectile(tear,collided)
	local data = tear:GetData()
	local rng = tear:GetDropRNG()
	
	--This leaves a trace of little poison clouds, could be better, but it really doesnt need to
	if(math.floor(tear.Position.X)%5==0) then
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, tear):ToEffect()
		gas.Timeout = mod.JConst.cloudTraceGasTime
		gas:GetSprite().Scale = mod.JConst.cloudTraceGasScale * Vector(1,1)
	end
	
	--If tear collided then
	if tear:IsDead() or collided then
			
		if data.target then
			data.target:Remove()
		end
		
		--Explosion:
		local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, tear.Position, Vector.Zero, tear):ToEffect()
		explode:GetSprite().Color = mod.Colors.boom
		
		--Explosion damage
		for i, entity in ipairs(Isaac.FindInRadius(tear.Position, mod.JConst.cloudExplosionRadius)) do
			if entity.Type ~= EntityType.ENTITY_PLAYER and entity.Type ~= mod.EntityInf[mod.Entity.Jupiter].ID then
				entity:TakeDamage(mod.JConst.cloudDamage, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear), 0)
			end
		end
		
		--Poison cloud:
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, tear):ToEffect()
		gas.Timeout = mod.JConst.cloudGasTime
		gas:GetSprite().Scale = mod.JConst.cloudGasScale * Vector(1,1)
		
		--Splash of projectiles:
		for i=0, mod.JConst.nCloudRingProjectiles do
			--Ring projectiles:
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, Vector(10,0):Rotated(i*360/mod.JConst.nCloudRingProjectiles), tear):ToProjectile()
			tear:GetSprite().Color = mod.Colors.boom
			tear.FallingSpeed = -0.1
			tear.FallingAccel = 0.3
		end
		for i=0, mod.JConst.nCloudRndProjectiles do
			--Random projectiles:
			local angle = mod:RandomInt(0, 360)
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, Vector(7,0):Rotated(angle), tear.Parent):ToProjectile()
			tear:GetSprite().Color = mod.Colors.boom2
			local randomFall = -1 * mod:RandomInt(1, 500) / 1000
			tear.FallingSpeed = randomFall
			tear.FallingAccel = 0.2
		end

		tear:Die()
	end
end

--Callbacks
--Jupiter updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.JupiterUpdate, mod.EntityInf[mod.Entity.Jupiter].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.JupiterDeath, mod.EntityInf[mod.Entity.Jupiter].ID)

--Projectile updates
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, tear)
	if tear:GetData().cloudJupiterProjectile then
		mod:CloudJupiterProjectile(tear,false)
	end
end)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().cloudJupiterProjectile and collider.Type == EntityType.ENTITY_PLAYER then
		mod:CloudJupiterProjectile(tear,true)
	end
end)

--Laser updates
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
	if laser:GetData().JupiterLaser then
		laser = laser:ToLaser()
		if laser:GetEndPoint ().Y > game:GetRoom():GetCenterPos(0).Y then
			laser.DepthOffset = 100
		else
			laser.DepthOffset = -100
		end
	end
end)

--SATURN---------------------------------------------------------------------------------------------------

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#********************@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@***,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%%%&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&***,,,,,,,,,,,,,,,,,,,,,,,,,.,,,,,..*********//////((#%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%#(,,......,,,,,,,,,,,,,,,,,,,.......,....     ..%%&%#/.,,****/((*(#&@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%(/#///**..,,,.....,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.......... .... .#&%/,,,***(*/#&@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@&%((///*,,%%%..  ........,,,,,,,,,,,,,***************,,,,,,,,,.****,,......... .%%(.,***(*(%@@@@@
@@@@@@@@@@@@@@@@@@&#/(//**,#&*..............,,,,,,,,,**,,,*******************,,,,,*****@@@&#/***,........ (&#.,**/(/#@@@
@@@@@@@@@@@@@@&#/(//*,#&/.......,**/..,.,,,,,,,,,,,,,,************//***,,*,,,,,,,,,,****@@@@@@@%(**,........,&#.**//*(&@
@@@@@@@@@@&#/(//*,(&#......,,*//%&@*,,,,,,,,,,,/,,,,,*,,******////////*********,,,,,,****@@@@@@@@&#**,........&#.**//*#@
@@@@@@@@%/#//*,#&.......,*//#&@@@@@,,,,,,*///,*,,,,,,,,,****/////////***((((//***,,,,,***@@@@@@@@@@#**,.......%#.**//*(@
@@@@@@#/(/**.#%......,,**(&@@@@@@@#*,,,,*.*//,(*******,,,**///////////(((,,,(////*,,,,,**@@@@@@@@@@#/*,.......&#.*//#/%@
@@@@&((//*,#&.......,**(&@@@@@@@@@@**,,,,**/,,,,,((*(,,,**///(((((////((((((((,****,,,,,*@@@@@@@@@#/*,.......&(,*////&@@
@@@&/(//*.#&.......,*//&@@@@@@@@@@@***,,,,***,,,,,,,******//((((((((**//(((/****,,,,,,,**@@@@@@&#/*,... ...&#.*//#/%@@@@
@@@#*(/**.#% ......,*/*%@@@@@@@@@@@(***,,,,,******///******/((/(/,(((////***/*****,,,,**@@@@&#/*,.......%%,,*///(%@@@@@@
@@@%*(/**./&(.......,***#@@@@@@@@@@@,,,,,,,,,,**************/*///((((//*********,,,,*,,@&#/**,.......&#,**/(/(%@@@@@@@@@
@@@@#*(/**,.%% .......,***(%@@@@@@@@@***,,,,,,,,,,***,,***********/*********,,,,,.,,.***,........%%,**//((#&@@@@@@@@@@@@
@@@@@&(*(/**,.#&*........,,***/(%&@@@@@**,,,,,,,,,,,,,,,,,,,,,,,,****,,,,....,,,,,........ *&#,**//(/(%&@@@@@@@@@@@@@@@@
@@@@@@@@%/*(***,./%%, .........,,,*****//......................,,,,,,,,,,...........*%%*,***/((/#%@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@&#(/(****,,,#%&(. .............,,,,,,,,,,........................&&&/,,**//(((#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%#/*((*****,,,./#%%&%%#..................,&&&&&&#,,.,,,,***/(//(#%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&%#((///////***************************//*,,,,,,(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/****&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

mod.SMSState = {
	APPEAR = 0,
	IDLE = 1,
	HIDERING = 2,
	SUMMONRING = 3,
	SPIN = 4,
	BOMB = 5,
	SUMMON = 6,
	KNIFE = 7,
	SAW = 8
}
mod.chainS = {
	[mod.SMSState.APPEAR] = 	{0, 1,    0,    0,    0,    0,    0,    0  , 0},
	[mod.SMSState.IDLE] = 		{0, 0.2,  0.4,  0,    0,    0,    0,    0.17,0.23},
	--[mod.SMSState.IDLE] = 		{0, 0,    0,    0,    1,    1,    0,    0  , 1},
	[mod.SMSState.HIDERING] = 	{0, 0,    0,    0,    0.35, 0.35,  0.3,0,   0},
	[mod.SMSState.SUMMONRING] = {0, 1,    0,    0,    0,    0,    0,    0  , 0},
	[mod.SMSState.SPIN] = 		{0, 0,    0,    0.55, 0.45, 0,    0,    0  , 0},
	[mod.SMSState.BOMB] = 		{0, 0,    0,    0.7,  0.3,  0,    0,    0  , 0},
	[mod.SMSState.SUMMON] = 	{0, 0,    0,    1,    0,    0,    0,    0  , 0},
	[mod.SMSState.KNIFE] = 		{0, 0,    0,    1,    0,    0,    0,    0  , 0},
	--[mod.SMSState.KNIFE] = 		{0, 0,    0,    0,    0,    0,    0,    1  , 0},
	[mod.SMSState.SAW] = 		{0, 0,    1,    0,    0,    0,    0,    0  , 0}
	--[mod.SMSState.SAW] = 		{0, 0,    0,    0,    0,    0,    0,    0  , 1}
	
}
mod.SConst = {--Some constant variables of Saturn
	goToSideSpeed = 1.6,
	speed = 1.4,
	slowSpeed = 1.3,
	centerDistanceToleration = 70,
	idleTimeInterval = Vector(15,20),

	nHorf = 6,
	nHorfMurderTears = 10,
	horfMurderTearSpeed = Vector(3,7),
	horfOrbitSpeed = 4.5,

	nBombs = 5,
	bombDamage = 30,
	bombCountdown = 55,
	bombSpeed = 30,
	bombOrbitSpeed = 7,
	specialBombChance = 0.2,

	nSpecialKeys = 60,
	nNormalKeys = 15,
	specialKeySpeed = 5,
	normalKeySpeed = 9,
	specialKeysAngle = 120,
	normalKeysAngle = 270,
	keyDestroyDistance = 300,
	keyOrbitSpeed = 10,
	timeStopFrames = 62,
	keyLifespan = 200,

	nAsteroids = Vector(4,6),
	asteroidOrbitSpeed = 500,
	asteroidScale = 1,

	SawSkips = 1,
	HealPerHyper = 10,

	sawDamage = 50,
	sawRadius = 130

}

function mod:SaturnUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Saturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.Saturn].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0

			data.MoveTowards = false 
			data.TimeStoped = false 
			data.HealPerHyper = mod.SConst.HealPerHyper 
			data.SawSkips = 0 
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.SMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainS)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		elseif data.State == mod.SMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainS)
				data.StateFrame = 0
				
			else
				mod:SaturnMove(entity,data,room,target)
			end
		
		--Hide and summon the rings
		elseif data.State == mod.SMSState.HIDERING then
			if data.StateFrame == 1 then
				sprite:Play("HideRings",true)
			elseif sprite:IsFinished("HideRings") then
				data.State = mod:MarkovTransition(data.State, mod.chainS)
				data.StateFrame = 0
			end
		elseif data.State == mod.SMSState.SUMMONRING then
			if data.StateFrame == 1 then
				sprite:Play("SummonRings",true)
			elseif sprite:IsFinished("SummonRings") then
				data.State = mod:MarkovTransition(data.State, mod.chainS)
				data.StateFrame = 0
			end
			
		--Attacks
		elseif data.State == mod.SMSState.SPIN then
			mod:SaturnSpin(entity, data, sprite, target, room)
			
		elseif data.State == mod.SMSState.BOMB then
			mod:SaturnBomb(entity, data, sprite, target, room)
		
		elseif data.State == mod.SMSState.SUMMON then
			mod:SaturnSummon(entity, data, sprite, target, room)
		
		elseif data.State == mod.SMSState.KNIFE then
			mod:SaturnKnife(entity, data, sprite, target, room)
		
		elseif data.State == mod.SMSState.SAW then
			mod:SaturnSaw(entity, data, sprite, target, room)
			
		end
		
		if data.MoveTowards then
			mod:MoveTowards(entity, data, data.MoveObjective, mod.SConst.goToSideSpeed)
		end
	end
end
function mod:SaturnSpin(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--Clockwise or couterclockwise spin
		data.Spin = 2*mod:RandomInt(0, 1) - 1
		if data.Spin == -1 then
			sprite:Play("SpinCW",true)
		else
			sprite:Play("SpinCCW",true)
		end
	elseif sprite:IsFinished("SpinCW") or sprite:IsFinished("SpinCCW") then
		data.State = mod:MarkovTransition(data.State, mod.chainS)
		data.StateFrame = 0
		
	elseif sprite:IsEventTriggered("Spin") then
		
		--Summon the asteroids
		local orbitOffset = 360*rng:RandomFloat()
		local asteroidAmount = mod:RandomInt(mod.SConst.nAsteroids.X,mod.SConst.nAsteroids.Y)
		for i=1, asteroidAmount do
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_COIN, 0, entity.Position, Vector.Zero, entity):ToProjectile()
			tear.Parent = entity

			tear:GetData().orbitingSaturn = true
			tear:GetData().orbitIndex = i
			tear:GetData().orbitTotal = asteroidAmount
			tear:GetData().Spin = data.Spin
			tear:GetData().orbitOffset = orbitOffset

			tear:AddScale(mod.SConst.asteroidScale)

			tear.FallingAccel = -0.1
			tear.FallingSpeed = 0

			local tearSprite = tear:GetSprite()
			tearSprite:ReplaceSpritesheet (0, "gfx/effects/saturn_coin_tears.png")
			tearSprite:LoadGraphics()
		end
		
		sfx:Play(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT,0.9,2,false,0.9)
	end
end
function mod:SaturnBomb(entity, data, sprite, target, room)
	if sprite:IsPlaying("Bomb") or sprite:IsPlaying("BombIdle") then
		mod:SaturnMove(entity,data,room,target)
	end
	if data.StateFrame == 1 then
		sprite:Play("BombIdle",true)
		
	elseif sprite:IsEventTriggered("BombSummon") then
		for i=1, mod.SConst.nBombs do
			local angle = i*360/mod.SConst.nBombs
			local bomb = mod:RandomizeBomb(bomb, entity, false)

			bomb:SetExplosionCountdown(9999)
			bomb:GetData().orbitingSaturn = true
			bomb:GetData().orbitIndex = i
			bomb:GetData().orbitTotal = mod.SConst.nBombs
			bomb:GetData().orbitSpin = 1
			bomb.ExplosionDamage = mod.SConst.bombDamage
			bomb.Parent = entity
			bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

			if bomb.Variant == BombVariant.BOMB_MR_MEGA then
				bomb.RadiusMultiplier = bomb.RadiusMultiplier * 1.5
			end
		end
		
	elseif sprite:IsFinished("BombIdle") then
		sprite:Play("Bomb",true)
	
	elseif sprite:IsEventTriggered("Bomb") then
	
		local bombs = Isaac.FindByType(EntityType.ENTITY_BOMBDROP)
		local saturnBomb = nil
		local minDistance = 99999999
		for i=1, #bombs do
			local bomb = bombs[i]
			if bomb:GetData().orbitingSaturn then
				local distance = target.Position:Distance(bomb.Position)
				if(distance <= minDistance) then
					minDistance = distance
					saturnBomb = bomb
				end
			end
		end
		
		if saturnBomb ~= nil then
			saturnBomb = saturnBomb:ToBomb()
			saturnBomb:SetExplosionCountdown(mod.SConst.bombCountdown)
			saturnBomb:GetData().orbitingSaturn = false
			saturnBomb.Parent = nil
			local player_direction = target.Position - saturnBomb.Position
			saturnBomb.Velocity = player_direction:Normalized()*mod.SConst.bombSpeed
			sfx:Play(Isaac.GetSoundIdByName("Throw"),1)
		end
	
	elseif sprite:IsFinished("Bomb") then
		local count = 0
		local bombs = Isaac.FindByType(EntityType.ENTITY_BOMBDROP)
		for i=1, #bombs do
			if (bombs[i]):GetData().orbitingSaturn then 
				count = count + 1
			end
		end
		if(count > 1) then
			sprite:Play("Bomb",true)
		else
			sprite:Play("BombEnd",true)
		end
	elseif sprite:IsFinished("BombEnd") then
		data.State = mod:MarkovTransition(data.State, mod.chainS)
		data.StateFrame = 0
	end
end
function mod:SaturnSummon(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		
		--If there are horfs alive dont summon more and do another attack
		if #(mod:FindByTypeMod(mod.Entity.Hyperion)) > 0 then
			data.State = mod.SMSState.HIDERING
			data.StateFrame = 1
		else
			sprite:Play("Summon",true)
		end
	elseif sprite:IsFinished("Summon") then
		data.State = mod:MarkovTransition(data.State, mod.chainS)
		data.StateFrame = 0
	
	elseif sprite:IsEventTriggered("Summon") then
		--Summon the sub horfs
		for i=1, mod.SConst.nHorf do
			local horf = mod:SpawnEntity(mod.Entity.Hyperion, entity.Position, Vector(0,0), entity)
			horf:GetData().orbitingSaturn = true
			horf:GetData().orbitIndex = i
			horf:GetData().orbitTotal = mod.SConst.nHorf
			horf:GetData().orbitSpin = -1
			horf.Parent = entity
			horf:GetSprite().Scale =  horf:GetSprite().Scale*1.2
			horf.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		end
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)

		data.SawSkips = mod.SConst.SawSkips
	end
end
function mod:SaturnKnife(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Knife",true)
	elseif sprite:IsFinished("Knife") then
		entity.Friction = 0.9
		data.State = mod:MarkovTransition(data.State, mod.chainS)
		data.StateFrame = 0
	
	elseif sprite:IsEventTriggered("Reposition") then
		local coins = Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_COIN)
		for _, c in ipairs(coins) do
			c:Die()
		end

		local direction = 1
		if entity.Position.X < target.Position.X then
			direction = -1
		end
		data.MoveTowards = true
		data.MoveObjective = Vector(direction*1000,room:GetCenterPos().Y)
	
	elseif sprite:IsEventTriggered("KnifeSpawn") then
		local spin = -1
		local a_i = 1
		local b_i = 2
		if entity.Position.X < room:GetCenterPos().X then
			spin = 1
			a_i = 2
			b_i = 1
		end
		
		--Keys that will change angle
		local angle = spin*90
		local key = mod:SpawnEntity(mod.Entity.KeyKnifeRed, entity.Position, Vector.Zero, entity):ToProjectile()
		key:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
		key:GetSprite().Rotation = angle
		key:GetSprite():Play("SpecialIdle", true)
		key:GetData().isOrbiting = true
		key:GetData().orbitIndex = a_i
		key:GetData().spinDirection = spin
		key.Parent = entity
		key.FallingAccel  = -0.1
		key.FallingSpeed = 0
		
		--Normal keys
		local angle = spin*270
		local key = mod:SpawnEntity(mod.Entity.KeyKnife, entity.Position, Vector.Zero, entity):ToProjectile()
		key:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
		key:GetSprite().Rotation = angle
		key:GetSprite():Play("NormalIdle", true)
		key:GetData().isOrbiting = true
		key:GetData().orbitIndex = b_i
		key:GetData().spinDirection = spin
		key.Parent = entity
		key.FallingAccel  = -0.1
		key.FallingSpeed = 0
		
		sfx:Play(Isaac.GetSoundIdByName("KnifeSummon"),1)
	
	elseif sprite:IsEventTriggered("KnifeThrow1") then
		data.MoveTowards = false
		entity.Friction = 1
		
		local currentSide = "right"
		if entity.Position.X < room:GetCenterPos().X then
			currentSide = "left"
		end
		local keys = mod:FindByTypeMod(mod.Entity.KeyKnifeRed)
		for i, k in ipairs(keys) do
			k:Remove()
		end
		
		--Keys that will change angle
		for i=1, mod.SConst.nSpecialKeys do
			
			local angle = -mod.SConst.specialKeysAngle/2 + i*mod.SConst.specialKeysAngle/mod.SConst.nSpecialKeys
			local pos = 60
			if currentSide == "right" then 
				angle = angle + 180
				pos = -60
			end
			local position = entity.Position + Vector(pos,0)
			local velocity = Vector.FromAngle(angle)*mod.SConst.specialKeySpeed
			
			local key = mod:SpawnEntity(mod.Entity.KeyKnifeRed, position, velocity, entity):ToProjectile()
			key:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
			key:GetSprite().Rotation = angle
			key:GetSprite():Play("BloodIdle", true)
			key.FallingAccel  = -0.1
			key.FallingSpeed = 0
			key.Height = -5
			key:GetData().Lifespan=mod.SConst.keyLifespan
		end
		sfx:Play(Isaac.GetSoundIdByName("KnifeThrow"),1)

		local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, entity.Position + Vector(0,-70), Vector.Zero, entity):ToEffect()
		timestuck:GetSprite().Scale = Vector(1,1)*0.8
		timestuck.DepthOffset = 999
		timestuck:FollowParent (entity)
		
		
	elseif sprite:IsEventTriggered("KnifeThrow2") then
		local currentSide = "right"
		if entity.Position.X < room:GetCenterPos().X then
			currentSide = "left"
		end
		local keys = mod:FindByTypeMod(mod.Entity.KeyKnife)
		for i, k in ipairs(keys) do
			k:Remove()
		end
		
		--Normal keys
		for i=1, mod.SConst.nNormalKeys do
			
			local angle = -mod.SConst.normalKeysAngle/2 + i*mod.SConst.normalKeysAngle/mod.SConst.nNormalKeys
			local pos = 60
			if currentSide == "right" then 
				angle = angle + 180
				pos = -60
			end
			local position = entity.Position + Vector(pos,0)
			local velocity = Vector.FromAngle(angle)*mod.SConst.normalKeySpeed
			local key = mod:SpawnEntity(mod.Entity.KeyKnife, position, velocity, entity):ToProjectile()
			key:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
			key:GetSprite().Rotation = angle
			key:GetSprite():Play("Idle", true)
			key.FallingAccel  = -0.1
			key.FallingSpeed = 0
			key:GetData().Lifespan=mod.SConst.keyLifespan

		end
		sfx:Play(Isaac.GetSoundIdByName("KnifeThrow"),1)

	elseif sprite:IsEventTriggered("TimeStop") then
		--Stop time xd
		data.TimeStoped = true
		mod.ModFlags.globalTimestuck = data.TimeStoped

		sfx:Play(Isaac.GetSoundIdByName("TimeStop"),1)
		sfx:Play(Isaac.GetSoundIdByName("TikTok"),1)

		for i=0, game:GetNumPlayers()-1 do
			local player = Isaac.GetPlayer(i)
			local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, player.Position + Vector(0,-10), Vector.Zero, player)
			timestuck:GetSprite().Scale = Vector(1,1)*0.4
			timestuck.DepthOffset = 999
		end
		
	elseif sprite:IsEventTriggered("KnifeChange") then
		local keys = mod:FindByTypeMod(mod.Entity.KeyKnifeRed)
		for _, k in ipairs(keys) do
			local angle = 360*rng:RandomFloat()
			k:GetSprite().Rotation = angle
			k:GetSprite():Play("BloodChangedTrace", true)
		end
		sfx:Play(Isaac.GetSoundIdByName("KnifeReposition"),1)
		
	elseif sprite:IsEventTriggered("TimeResume") then
		sfx:Play(Isaac.GetSoundIdByName("TimeResume"),1)
		--Un-stop time xd
		data.TimeStoped = false
		mod.ModFlags.globalTimestuck = data.TimeStoped
		mod:SaturnResumeTime()


		local keys = mod:FindByTypeMod(mod.Entity.KeyKnifeRed)
		for _, k in ipairs(keys) do
			local angle = k:GetSprite().Rotation
			k.Velocity = Vector(1,0):Rotated(angle)*(mod.SConst.specialKeySpeed-1)
			k:GetSprite():Play("BloodChanged", true)
		end
	end

	if data.TimeStoped then
		mod:SaturnStopTime()
	end
end
function mod:SaturnSaw(entity, data, sprite, target, room)	
	if data.StateFrame == 1 then
		if data.SawSkips > 0 then
			data.SawSkips = data.SawSkips - 1
			data.State = mod:MarkovTransition(data.State, mod.chainS)
			data.StateFrame = 0
		else
			sprite:Play("Saw",true)
		end
	elseif sprite:IsFinished("Saw") or sprite:IsFinished("SawBlood") then
		data.State = mod:MarkovTransition(data.State, mod.chainS)
		data.StateFrame = 0
	
	--Do the pre saw sounds
	elseif sprite:IsEventTriggered("SawSound") then
		sfx:Play(Isaac.GetSoundIdByName("PreSaw"), 0.5)
	
	
	elseif sprite:IsEventTriggered("Saw") then
	
		--Make Saturn only collide with plater things (so it doesnt collide with it's own rigs) (this is old, but i dont want to remove it xd)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		

		local center = entity.Position + Vector(0,-45)
		--Check damage range v
		--for i=1, 50 do
			--Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, center + Vector(mod.SConst.sawRadius,0):Rotated(i*360/50),Vector.Zero, nil)
		--end

		for i, entity_ in ipairs(Isaac.FindInRadius(center, mod.SConst.sawRadius)) do
			if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Saturn].ID and entity_.Type ~= EntityType.ENTITY_TEAR and entity_.Type ~= EntityType.ENTITY_PROJECTILE then
				entity_:TakeDamage(mod.SConst.sawDamage, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)

				entity_.Velocity = (entity_.Position-entity.Position):Normalized()*10

			elseif entity_.Type == EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Saturn].ID then
				entity_:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)

				
				--Summon projectile
				for i=1, mod.SConst.nHorfMurderTears do
					
					local angle = mod:RandomInt(0, 359)
					local speed = mod:RandomInt(mod.SConst.horfMurderTearSpeed.X, mod.SConst.horfMurderTearSpeed.Y)
					local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity_.Position, Vector(1,0):Rotated(angle)*speed, entity):ToProjectile()
					tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					tear.FallingSpeed = -1 * mod:RandomInt(1, 500) / 1000
					tear.FallingAccel = mod:RandomInt(1, 30) / 100
					tear.Height = -1 *  mod:RandomInt(18, 30)
				end
				entity_.Velocity = (entity_.Position-entity.Position):Normalized()*10

				--Sound
				sfx:Play(Isaac.GetSoundIdByName("SawHit"), 0.4)

				--Heal
				local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, entity.Position + Vector(0,-100), Vector.Zero, entity)
				healHeart.DepthOffset = 200
				sfx:Play(SoundEffect.SOUND_VAMP_GULP,2)
				local frame = sprite:GetFrame()
				sprite:Play("SawBlood", true)
				sprite:SetFrame(frame+1)

				entity:AddHealth(50)
			end
		end

		--Sound
		sfx:Play(Isaac.GetSoundIdByName("Saw"), 0.5)
		
		--Kill the horfs if there are some alive
		--(bug) It kills the horfs of other Saturns too, but I dont care, are you really gonna use Meat cleaver???
		local horfs = mod:FindByTypeMod(mod.Entity.Hyperion)
		
		if #horfs > 0 then
			--Sound
			sfx:Play(Isaac.GetSoundIdByName("SawHit"), 0.4)
		end

		if #horfs > 0 and data.HealPerHyper > 0 then
			local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, entity.Position + Vector(0,-100), Vector.Zero, entity)
			healHeart.DepthOffset = 200
			sfx:Play(SoundEffect.SOUND_VAMP_GULP,2)
			local frame = sprite:GetFrame()
			sprite:Play("SawBlood", true)
			sprite:SetFrame(frame+1)

			entity:AddHealth(#horfs*data.HealPerHyper)
			data.HealPerHyper = data.HealPerHyper - 1

		end

		for i=1, #horfs do
			local horf = horfs[i]
			--Summon projectile
			for i=1, mod.SConst.nHorfMurderTears do
				
				local angle = mod:RandomInt(0, 359)
				local speed = mod:RandomInt(mod.SConst.horfMurderTearSpeed.X, mod.SConst.horfMurderTearSpeed.Y)
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, horf.Position, Vector(1,0):Rotated(angle)*speed, entity):ToProjectile()
				tear.FallingSpeed = -1 * mod:RandomInt(1, 500) / 1000
				tear.FallingAccel = mod:RandomInt(1, 30) / 100
				tear.Height = -1 *  mod:RandomInt(18, 30)
			end
			horf:Die()
		end
		
	--Reset Saturn collisions to the 'normal' one
	elseif sprite:IsEventTriggered("SawEnd") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
end

--Move
function mod:SaturnMove(entity, data,room, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.SConst.idleTimeInterval.X, mod.SConst.idleTimeInterval.Y)
		--distance of Saturn from the center of the room
		local distance = 0.95*(room:GetCenterPos().X-entity.Position.X)^2 + 2*(room:GetCenterPos().Y-entity.Position.Y)^2
		
		--If its too far away, return to the center
		if distance > mod.SConst.centerDistanceToleration^2 then
			data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		--Else, get closer to the player
		else
			data.targetvelocity = ((target.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
		end
	end

	--If run out of idle time
	if data.idleTime <= 0 and data.idleTime ~= nil then
		data.idleTime = nil
	else
		data.idleTime = data.idleTime - 1
	end

	--Do the actual movement
	local speed = mod.SConst.speed
	if(#( mod:FindByTypeMod(mod.Entity.Hyperion)) > 0) then--Find by type on upate? nide
		speed = mod.SConst.slowSpeed
	end
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * speed
	data.targetvelocity = data.targetvelocity * 0.99
end


--TimeThings
--The XXI. The World mod by Roary was usefull here, the original Dio mod was made by rand, Badass Physicist and Bagre
function mod:Freeze(entity)
	if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
		entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
	end
end
function mod:SaturnStopTime(fromPlayer)
	--print("a")
	local entities = Isaac.GetRoomEntities()
	--print("b")
	for index, entity in ipairs(entities) do
		--print(index)
		local data = entity:GetData()

		local isSaturn = entity.Type == mod.EntityInf[mod.Entity.Saturn].ID
		local isTimestuck = (entity.Type == EntityType.ENTITY_EFFECT) and (entity.Variant == mod.EntityInf[mod.Entity.TimeFreezeObjective].VAR)

		if entity and entity:Exists() and (not entity:IsDead()) and data and (not isSaturn) and (not isTimestuck) then

			if entity.Type == EntityType.ENTITY_PROJECTILE then
				entity = entity:ToProjectile()

				if not data.Frozen then
					data.StoredVel = entity.Velocity
					data.StoredPos = entity.Position
					data.StoredHeight = entity.Height
					data.Frozen = true
				else
					entity.Velocity = Vector.Zero
					entity.Position = data.StoredPos 
					entity.Height = data.StoredHeight
				end
			elseif entity.Type == EntityType.ENTITY_PLAYER then
				entity = entity:ToPlayer()

				local isInmune = fromPlayer and entity.ControllerIndex and mod.ItemsVars.timeStops and mod.ItemsVars.timeStops[entity.ControllerIndex]
				if not isInmune then
					entity.Velocity = Vector.Zero
					entity:ToPlayer().ControlsCooldown = 49
				end
			elseif entity.Type == EntityType.ENTITY_FAMILIAR then
				entity = entity:ToFamiliar()

				local inmune = fromPlayer and entity.Player and entity.Player.ControllerIndex and mod.ItemsVars.timeStops and mod.ItemsVars.timeStops[entity.Player.ControllerIndex]
				if not inmune then
					if not data.Frozen then
						data.Frozen = true

						data.StoredPos = entity.Position
						data.StoredVel = entity.Velocity
						data.CollisDam = entity.CollisionDamage
					else
						entity.Position = data.StoredPos
						entity.Velocity = Vector.Zero
						entity.CollisionDamage = 0
					end
					mod:Freeze(entity)
				else
					if not data.Frozen then
						data.Frozen = true
						data.CollisDam = entity.CollisionDamage
					else
						entity.CollisionDamage = data.CollisDam/3
					end
				end

			elseif entity.Type == EntityType.ENTITY_TEAR then
				entity = entity:ToTear()

				local inmune = fromPlayer and entity.SpawnerEntity and entity.SpawnerEntity.ControllerIndex and mod.ItemsVars.timeStops and mod.ItemsVars.timeStops[entity.SpawnerEntity.ControllerIndex]
				if not inmune then
					if not data.Frozen then
						--Dont know whats the deal with antigravity
						if entity.Velocity ~= Vector.Zero or (entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() and not entity.SpawnerEntity:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY)) then
							data.Frozen = true
							data.StoredVel = entity.Velocity
							data.StoredPos = entity.Position
							data.StoredFall = entity.FallingSpeed
							data.StoredAcc = entity.FallingAcceleration
						
						else
							entity.FallingSpeed = 0
						end
					else
						entity.Velocity = Vector.Zero
						entity.Position = data.StoredPos
						entity.FallingAcceleration = -0.1
						entity.FallingSpeed = 0
					end
				end

			elseif entity.Type == EntityType.ENTITY_LASER then
				entity = entity:ToLaser()

				local inmune = fromPlayer and entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() and entity.SpawnerEntity:ToPlayer().ControllerIndex and mod.ItemsVars.timeStops and mod.ItemsVars.timeStops[entity.SpawnerEntity:ToPlayer().ControllerIndex]
				if not inmune then
					if not data.Frozen then
						data.Frozen = true

						entity.DisableFollowParent = true

						data.StoredVel = entity.Velocity
						data.StoredPos = entity.Position
						data.StoredAngle = entity.Angle
						data.StoredCurveStrength = entity.CurveStrength
						data.StoredDamage = entity.CollisionDamage
						data.StoredTimeout = entity.Timeout
					else
						entity.Velocity = Vector.Zero
						entity.Position = data.StoredPos 
						entity.Angle = data.StoredAngle 
						entity.CurveStrength = data.StoredCurveStrength
						entity.CollisionDamage = data.StoredDamage
						entity:SetTimeout(data.StoredTimeout)
					end

				else
					if not data.Frozen then
						data.Frozen = true
						
						local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, entity.Position, Vector.Zero, nil):ToEffect()
						timestuck:FollowParent(entity)
						timestuck:GetSprite().Scale = Vector.One*0.2
						timestuck.DepthOffset = -50

						entity:AddTearFlags(TearFlags.TEAR_WAIT)
						entity:GetSprite().Color = mod.Colors.timeChanged
						
						data.StoredTimeout = entity.Timeout
					else
						entity:AddTearFlags(TearFlags.TEAR_WAIT)
						entity:SetTimeout(data.StoredTimeout)-- + 15)
					end
				end

			elseif entity.Type == EntityType.ENTITY_BOMBDROP then
				entity = entity:ToBomb()

				if not data.Frozen then
					data.Frozen = true

					local inmune = entity.Variant ~= BombVariant.BOMB_ROCKET and entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() and mod.ItemsVars.timeStops and mod.ItemsVars.timeStops[entity.SpawnerEntity:ToPlayer().ControllerIndex]
					if inmune then
						
						local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, entity.Position, Vector.Zero, entity.SpawnerEntity):ToEffect()
						timestuck:FollowParent(entity)
						timestuck:GetSprite().Scale = Vector.One*0.3
						timestuck.DepthOffset = -50

						entity:GetSprite().Color = mod.Colors.timeChanged

						entity:SetExplosionCountdown(5)
					end
					data.StoredVel = entity.Velocity
				else
					entity.Velocity = Vector.Zero
				end
				mod:Freeze(entity)
			elseif entity.Type == EntityType.ENTITY_EFFECT then
				entity = entity:ToEffect()

				if entity.Variant == EffectVariant.LASER_IMPACT then entity:Remove() end

				if not data.Frozen then
					data.Frozen = true

					data.StoredVel = entity.Velocity
					data.StoredPos = entity.Position
					data.StoredTimeout = entity.Timeout
					data.StoredLifespan = entity.LifeSpan
				else
					entity.Velocity = Vector.Zero
					entity.Position = data.StoredPos 
					--e.Timeout = data.StoredTimeout
					entity:SetTimeout(data.StoredTimeout)
					entity.LifeSpan = data.StoredLifespan
				end
				mod:Freeze(entity)
			elseif entity.Type == EntityType.ENTITY_KNIFE then
				entity = entity:ToKnife()
				
				local inmune = fromPlayer and entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() and mod.ItemsVars.timeStops and mod.ItemsVars.timeStops[entity.SpawnerEntity:ToPlayer().ControllerIndex]
				if not inmune then
					if not data.Frozen then
						data.Frozen = true

						data.StoredPos = entity.Position
						data.StoredVel = entity.Velocity
						data.StoredCharge = entity.Charge
						data.StoredRotation = entity.Rotation
						data.CollisDam = entity.CollisionDamage
					else
						entity.Position = data.StoredPos
						entity.Velocity = Vector.Zero
						entity.CollisionDamage = 0
					end
					mod:Freeze(entity)
				else
					if not data.Frozen then
						data.Frozen = true
						data.CollisDam = entity.CollisionDamage
					else
						entity.CollisionDamage = data.CollisDam/2
					end

				end

			else
				if not data.Frozen then
					data.StoredPos = entity.Position
					data.StoredVel = entity.Velocity
					data.Frozen = true
				else
					entity.Position = data.StoredPos
					entity.Velocity = Vector.Zero
				end
				mod:Freeze(entity)
			end
		end
	end
end
function mod:SaturnResumeTime(fromPlayer)
	local entities = Isaac.GetRoomEntities()
	for _, e in ipairs(entities) do
		local data = e:GetData()
		
		if e and data then

			if e:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
				e:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
			end
			data.Frozen = nil

			if e.Type == EntityType.ENTITY_PLAYER then
				e = e:ToPlayer()
				if not (fromPlayer and e.ControllerIndex and mod.ItemsVars.timeStops[e.ControllerIndex]) then
					e:ToPlayer().ControlsCooldown = 0
				end
			elseif e.Type == EntityType.ENTITY_FAMILIAR then
				e = e:ToFamiliar()
				if not (fromPlayer and e.Player and e.Player.ControllerIndex and mod.ItemsVars.timeStops[e.Player.ControllerIndex]) then
					e.Velocity = data.StoredVel
					e.CollisionDamage = data.CollisDam
				end

			elseif e.Type == EntityType.ENTITY_TEAR then
				tear = e:ToTear()
				e = e:ToTear()
				if not (fromPlayer and e.SpawnerEntity and e.SpawnerEntity.ControllerIndex and mod.ItemsVars.timeStops[e.SpawnerEntity.ControllerIndex]) then
					e.Velocity = data.StoredVel
					tear.FallingSpeed = data.StoredFall
					tear.FallingAcceleration = data.StoredAcc
				end

			elseif e.Type == EntityType.ENTITY_PROJECTILE then
				e.Velocity = data.StoredVel 
				e.Position = data.StoredPos
			elseif e.Type == EntityType.ENTITY_BOMBDROP then
				e.Velocity = data.StoredVel
			elseif e.Type == EntityType.ENTITY_LASER then
				e = e:ToLaser()
				if not (fromPlayer and e.SpawnerEntity and e.SpawnerEntity:ToPlayer() and e.SpawnerEntity:ToPlayer().ControllerIndex and mod.ItemsVars.timeStops[e.SpawnerEntity:ToPlayer().ControllerIndex]) then
					e.Velocity = data.StoredVel
					e.CurveStrength = data.StoredCurveStrength
					e.CollisionDamage = data.StoredDamage
				else
					e:ClearTearFlags(TearFlags.TEAR_WAIT)
				end

			elseif e.Type == EntityType.ENTITY_KNIFE then
				e = e:ToKnife()
				if not (fromPlayer and e.SpawnerEntity and e.SpawnerEntity:ToPlayer() and mod.ItemsVars.timeStops[e.SpawnerEntity:ToPlayer().ControllerIndex]) then
					e.Velocity = data.StoredVel
					e.Charge = data.StoredCharge
					e.Rotation = data.StoredRotation
					e.CollisionDamage = data.CollisDam
				else
					e.CollisionDamage = data.CollisDam
				end
			else
				if data.StoredVel then e.Velocity = data.StoredVel end
				if data.StoredPos then e.Position = data.StoredPos end
				
			end
		end
	end
end

--The different things that orbit Saturn
function mod:OrbitHorf(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Hyperion].VAR then
		local data = entity:GetData()
		if entity.Parent ~= nil then
			if not data.orbitAngle then
			  data.orbitAngle = data.orbitIndex*360/data.orbitTotal
			end
			if not data.orbitIndex then
				data.orbitIndex = 1
			end
			local angle = data.orbitAngle*math.pi/180
			local distance = math.sqrt(100000/(20*math.cos(angle)^2+60*math.sin(angle)^2))
					
			if not data.orbitDistance then
				data.orbitDistance = 0
			end
			data.orbitDistance = math.min(distance, data.orbitDistance + 5)
			
			entity.Position  = entity.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(data.orbitDistance)
			data.orbitAngle = (data.orbitAngle + data.orbitSpin*mod.SConst.horfOrbitSpeed) % 360
		end
	end
end
function mod:OrbitBomb(entity)
	local data = entity:GetData()
	if (not data.orbitAngle) then
	  data.orbitAngle = data.orbitIndex*360/data.orbitTotal
	end

	if not data.orbitDistance then
		data.orbitDistance = 0
	end
	data.orbitDistance = math.min(50, data.orbitDistance + 3)

	if entity.Parent==nil then
		entity:SetExplosionCountdown(90)
	else
		entity.Position  = entity.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(data.orbitDistance)
		data.orbitAngle = (data.orbitAngle + data.orbitSpin*mod.SConst.bombOrbitSpeed) % 360
	end

end
function mod:OrbitRing(tear)
	local data = tear:GetData()
	if (not data.orbitAngle) then
	  data.orbitAngle = data.orbitIndex*360/data.orbitTotal + data.orbitOffset
	  data.orbitDistance = 1
	end
	if tear.Parent==nil then
		tear:Die()
	else
		if tear.FrameCount >= 350 then tear:Die() end

		tear.Position  = tear.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(data.orbitDistance)
		data.orbitAngle = (data.orbitAngle + data.Spin*mod.SConst.asteroidOrbitSpeed/data.orbitDistance) % 360
		data.orbitAngle = data.orbitAngle 
		data.orbitDistance = data.orbitDistance + 2
	end
	

end
function mod:OrbitKey(entity)
	local data = entity:GetData()
	if (not data.orbitAngle) then
	  data.orbitAngle = data.orbitIndex*360/2
	end
	if data.isOrbiting and entity.Parent then
		entity.Position  = entity.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(60)
		local angleStep = data.spinDirection*mod.SConst.keyOrbitSpeed
		data.orbitAngle = (data.orbitAngle + angleStep) % 360
		entity:GetSprite().Rotation = (entity:GetSprite().Rotation + angleStep) % 360
	end

end

--ded
function mod:SaturnDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Saturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.Saturn].SUB then

		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.IMPACT, 20, 25, Color(3,0,0,1))
		local ring = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SIREN_RING, 0, entity.Position, Vector.Zero, entity)
		ring:GetSprite().Color = Color(0.5,0,0,1)

		--remaining bombs
		for _,b in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMBDROP)) do
			if b:GetData().orbitingSaturn then
				b = b:ToBomb()
				b.ExplosionDamage = 0
				b:SetExplosionCountdown(0)
			end
		end

		sfx:Play(Isaac.GetSoundIdByName("TouhouDeath"), 0.05)
		mod:NormalDeath(entity)

		
		for i=0, game:GetNumPlayers()-1 do
			local player = Isaac.GetPlayer(i)
			player.ControlsCooldown = 2
		end
		mod.ModFlags.globalTimestuck = false

		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.KeyKnife)) do
			i:Remove()
		end
		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.KeyKnifeRed)) do
			i:Remove()
		end
	end
end
--deding
function mod:SaturnDying(entity)
	
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if data.deathFrame == nil then data.deathFrame = 1 end
	if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
		if sprite:GetFrame() == 1 then 
			--sfx:Play(Isaac.GetSoundIdByName("TimeStop"),1)
			sfx:Play(Isaac.GetSoundIdByName("TikTok"),10)
			sfx:Play(SoundEffect.SOUND_MOM_VOX_HURT,1,2,false,1.2)
		elseif sprite:GetFrame() == 20 then 
			local time = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, entity.Position, Vector.Zero, entity)
			time:GetSprite().Scale = 0.55*Vector(1,1)
		end
	end
end

--Special bomb
function mod:RandomizeBomb(bomb, entity, hardmode)
	local bomb = nil

	if not hardmode then
		if rng:RandomFloat() < mod.SConst.specialBombChance then
			local random = mod:RandomInt(1,4)

			if random == 1 then
				bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector.Zero, entity):ToBomb()
				bomb:AddTearFlags(TearFlags.TEAR_SCATTER_BOMB)
			elseif random == 2 then
				bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_MR_MEGA, 0, entity.Position, Vector.Zero, entity):ToBomb()
			elseif random == 3 then
				bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_SAD_BLOOD, 0, entity.Position, Vector.Zero, entity):ToBomb()
				bomb:AddTearFlags(TearFlags.TEAR_SAD_BOMB)
			elseif random == 4 then
				bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_THROWABLE, 0, entity.Position, Vector.Zero, entity):ToBomb()
				local bombSprite = bomb:GetSprite()
				bombSprite:ReplaceSpritesheet (0, "gfx/effects/saturn_creep_bomb.png")
				bombSprite:LoadGraphics()
				bomb:GetData().saturnCreep = true
			end
		else
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector.Zero, entity):ToBomb()
		end
	else
		--Not yet
	end

	return bomb
end

--Callbacks
--Saturn updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SaturnUpdate, mod.EntityInf[mod.Entity.Saturn].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.SaturnDeath, mod.EntityInf[mod.Entity.Saturn].ID)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, _, _, _, _)
	if entity:GetData().TimeStoped then
		return false
	end
end)

--Orbit things updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.OrbitHorf, EntityType.ENTITY_SUB_HORF)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if bomb:GetData().orbitingSaturn then
		mod:OrbitBomb(bomb)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, tear)
	if tear:GetData().orbitingSaturn then
		mod:OrbitRing(tear,false)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if bomb:GetData().saturnCreep and bomb:GetSprite():IsPlaying("Explode") then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_STATIC, 0, bomb.Position, Vector.Zero, entity):ToEffect()
		creep.Timeout = 180
		creep.SpriteScale = Vector.One*3
		creep:GetSprite().Color = Color(1,0,0,1)
	end
end)


--URANUS---------------------------------------------------------------------------------------------------

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@%             /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@                  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@      .......        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@     ..@@@.......      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@    .@@@@@@@@@@,....      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@  .@@@@@@@@@@@@@@@....     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@  .@@@@@@@@@@@@@@@@@%  .     @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@  %@@@@@@@@@@@@@@@@@@@   .    @@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@,       &@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@#       @@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@. @@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@. @@@@@@@@@@@@@@@@@@@@@@@@@@ .     @@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@.%@@@@@@@@#******************       @@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@ @@@@***,*,,,,*,,,,,,,,,,,,,,, .     @@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@ *****,,*,.,*,,,,,***,,,,,,,,,.      ,**@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@*******,,,,,,,,,,,,,,,,,.....,,,,..     ,,,,*@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@**********,,,,,,,,,,,,,............. .     ,,,,**@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@*****,,****,,,,,,,,,,,,,,,,,,.........,      .*,,,***@@@@@@@@@@@
@@@@@@@@@@@@@@(******,,,,,******,,*******,,,,,,,,,,.....      ,,,.,****@@@@@@@@@
@@@@@@@@@@@@@********************,******,,,,,,,,,,,......      .,,,,,***@@@@@@@@
@@@@@@@@@@@@******,,,,,*******/*****,,,,,,,,..,,,,,.......     .,,,,,,***@@@@@@@
@@@@@@@@@@@**,,,,,,,,***************,,.,,.,  . .,,,,.....       ,,.,,,,*,*@@@@@@
@@@@@@@@@***,,.,,. ,,,,**********,,,.,,,.,.... .....,,...       ,,,.,*,,,*@@@@@@
@@@@@@@@*,,,,....,...,,,,*******,,...........,,.....,,.....      .....,,,*/@@@@@
@@@@@@@/*,,.,...,,,,.,*,,******,.,... ........  ,.,,,.....       ,,*,,*,,,*@@@@@
@@@@@@@/**,,.,. ,,.,,,,,,*****,, ,,,,........,,.,,,,.,.....      ,,,*,*,,**@@@@@
@@@@@@/**,,..,,...,.,,,,******,,..,..........*,,,.,,*,....,       ,,.,*,**/@@@@@
@@@@@@/*,,,....,,,,,,**,/****,,,... ..,,..... ,,*..,.....**.      ,,,,*,**@@@@@@
@@@@@@&***,,,..,,...,,**//***,..,... ..,,........,,,,...,,,..     *,,,***@@@@@@@
@@@@@@@/**,,,,,,....,,,,******,,........,,... .,,..,,,,,..,,       *****#@@@@@@@
@@@@@@@@/**,,,,,,.,,,,,,,*****,,,,,..,,,,.. .... .,*...,,,,,       ,***%@@@@@@@@
@@@@@@@@@**,..,,..,,.,,,,**.***,,,,,,,*,., ........,,,,,*,**       ,**@@@@@@@@@@
@@@@@@@@@@#*,,,*,*,**,*************,.,,,,.,..,..,,,,,,,,,***       ,&@@@@@@@@@@@
@@@@@@@@@@@@*,,**************************,,,,,,,,,,***,*****       @@@@@@@@@@@@@
@@@@@@@@@@@@***@******,,***/////*********,*,,,,,,,,*********       @@@@@@@@@@@@@
@@@@@@@@@@@@&,*@@@@@@@@*(****,,,****************,,*****,****       @@@@@@@@@@@@@
@@@@@@@@@@@@@,*@@@@@@@@*@@@@@,,.,,,,,,,,,******,,*,****.*/@@       @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. @@@@/*********/,*(@@@@**/@@  .    @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.(@@@@@@@@@@@@@@**%@@@%@@@@@       @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %@@@@@@@@@@@@@**@@@@@@@@@ ..     @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@.,@@@@@@@@@@@@@@@@@@@@@@@  .     @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@#.. .    @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@.....   (@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@  .@@@@@@@@@@@@@@@@@...      @@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   &@@@@@@@@@@@@@@...       @@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*   .@@@@@@@@@@#...       @@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@..           @@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(                    .@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  ,@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,              @@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--]]

mod.UMSState = {
	APPEAR = 0,
	IDLE = 1,
	TURD = 2,
	PROJECTILE = 3,
	FARTING = 4,
	HAIL = 5,
	PEE = 6,
	SPIN = 7
}
mod.chainU = {
	[mod.UMSState.APPEAR] = 	{0, 0,    0,    0,      0,      1,    0,   0},
	[mod.UMSState.IDLE] = 	    {0, 0.2,  0.12, 0.2,  	0.16,   0.12, 0.2, 0},
	[mod.UMSState.TURD] = 	    {0, 1,    0,    0,      0,      0,    0,   0},
	[mod.UMSState.PROJECTILE] = {0, 0.7,  0.15, 0,      0.15,   0,    0,   0},
	[mod.UMSState.FARTING] = 	{0, 0.5,  0.2,  0,      0.1,    0,    0.2, 0},
	[mod.UMSState.HAIL] = 	    {0, 1,    0,    0,      0,      0,    0,   0},
	[mod.UMSState.PEE] = 	    {0, 0.5,  0.1,  0,      0.1,    0,    0.3, 0},
	[mod.UMSState.SPIN] = 	    {0, 0,    0,    0,      0,     0,     0,   1}
	
}
mod.UConst = {--Some constant variables of Uranus
	speed = 1.3,
	centerDistanceToleration = 87,
	idleTimeInterval = Vector(20,30),
	idleIceSize = 2,

	maxTurds = 5,
	turdIceSize = 3,
	turdDamage = 40,
	turdRadius = 20,
	turdIcicleIceSize = 1,
	turdIcicleSpeed = 9,
	nTurdIcicles = 8,

	minDistanceToFart = 175,
	poopSpeed = 10,
    cornChance = 1, --/5
	poopDensity = 5,

	nPee = 3,
	peeCreepTime = 25,
	peeMeltRadius = 50,

	nBlizzards = 3,
	nHails = 17,
	hailIceSize = 1,

	shotSpeed = 7,
	shotIceSize = 5,
	shotScale = 0.5,
	shotTraceIceSize = 1,
	shotIcicleIceSize = 1,
	nShotIcicles = 8,
	shotIcicleSpeed = 11,

	nPoopSpins = 3
}

function mod:UranusUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Uranus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Uranus].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0 

			data.HailCount = 0 
			data.fartCount = 0
			data.SpinCount = 0 
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.UMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

				if mod.ModConfigs.altUranus then
					local animation = sprite:GetAnimation()
					sprite:Load("gfx/entity_UranusAlt.anm2", true)
					sprite:LoadGraphics()
					sprite:Play(animation, true)
				end

			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainU)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		elseif data.State == mod.UMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainU)
				data.StateFrame = 0
				mod:SpawnIceCreep(entity.Position, mod.UConst.idleIceSize, entity)
			else
				mod:UranusMove(entity, data, room, target)
			end
			
		
		elseif data.State == mod.UMSState.TURD then
			mod:UranusTurd(entity, data, sprite, target, room)
			
		elseif data.State == mod.UMSState.PROJECTILE then
			mod:UranusShot(entity, data, sprite, target, room)
			
		elseif data.State == mod.UMSState.FARTING then
			mod:UranusFarting(entity, data, sprite, target, room)
		
		elseif data.State == mod.UMSState.HAIL then
			mod:UranusHail(entity, data, sprite, target, room)
			
		elseif data.State == mod.UMSState.PEE then
			mod:UranusPee(entity, data, sprite, target, room)

		elseif data.State == mod.UMSState.SPIN then
			mod:UranusThank(entity, data, sprite, target, room)
		end

		mod:SpawnSnowflake(entity,room)
	end
end
function mod:UranusShot(entity, data, sprite, target, room)
	mod:FaceTarget(entity, target)
	if data.StateFrame == 1 then
		sprite:Play("Shot",true)
		entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	elseif sprite:IsFinished("Shot") then
		data.State = mod:MarkovTransition(data.State, mod.chainU)
		data.StateFrame = 0
		
	elseif sprite:IsEventTriggered("Shot") then
		local player_direction = target.Position - entity.Position
		local hail = mod:SpawnEntity(mod.Entity.BigIcicle, entity.Position, player_direction:Normalized()*mod.UConst.shotSpeed, entity):ToProjectile()
		hail:GetSprite().Rotation = player_direction:GetAngleDegrees()
		hail.FallingAccel  = -0.1
		hail.FallingSpeed = 0
		hail:AddScale(mod.UConst.shotScale)
		--hail:GetSprite().Color = mod.Colors.hailColor
		hail:GetData().IsIcicle_HC = true
		hail:GetData().iceSize = mod.UConst.shotIceSize
		hail:GetData().hailTrace = true
		hail:GetData().hailSplash = true
		hail.Parent = entity
		
		if mod.ModConfigs.altUranus then
			sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1, 2, false, 2)
		else
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
		end
	end
end
function mod:UranusTurd(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--If there are to many turds, dont summon more
		local turds = mod:FindByTypeMod(mod.Entity.IceTurd)
		if(#turds<mod.UConst.maxTurds) then
			mod:FaceTarget(entity, target)
			if rng:RandomFloat() < 0.1 then
				sprite:Play("Turd2",true)
			else
				sprite:Play("Turd",true)
			end
		else
			data.State = mod:MarkovTransition(data.State, mod.chainU)
			data.StateFrame = 0
		end
	elseif sprite:IsFinished("Turd") or sprite:IsFinished("Turd2") then
		data.State = mod:MarkovTransition(data.State, mod.chainU)
		data.StateFrame = 0
		
	elseif sprite:IsEventTriggered("Turd1") then
		--Peek a boo
		sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE,1);
	elseif sprite:IsEventTriggered("Turd2") then
		--Begin rotation
	elseif sprite:IsEventTriggered("Turd3") then
		--Tactical nuke in comming
		sfx:Play(SoundEffect.SOUND_BULLET_SHOT,4);
		local iceTurd = nil
		if sprite:IsPlaying("Turd") then
			iceTurd = mod:SpawnEntity(mod.Entity.IceTurd, target.Position, Vector.Zero, entity)
		else
			iceTurd = mod:SpawnEntity(mod.Entity.Turd, target.Position, Vector.Zero, entity)
		end
		mod:IceTurdInit(iceTurd)
	
	--Move a little
	elseif data.StateFrame >= 16 and data.StateFrame < 60 then
		mod:UranusMove(entity, data, room, target)
	end
end
function mod:UranusFarting(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--Dont fart to close to the player
		if (entity.Position):Distance(target.Position) < mod.UConst.minDistanceToFart then
			sprite:Play("Farting",true)
			mod:FaceTarget(entity, target)
			if mod.ModConfigs.altUranus then
				sfx:Play(Isaac.GetSoundIdByName("NoseBlowing"), 2, 2, false, 1)
			end
		else
			data.State = mod:MarkovTransition(data.State, mod.chainU)
			data.StateFrame = 0
		end
	elseif sprite:IsFinished("Farting") then
		data.fartTarget = nil
		data.fartCount = 0
		data.State = mod:MarkovTransition(data.State, mod.chainU)
		data.StateFrame = 0
		
	elseif sprite:IsEventTriggered("Fart") then
		if data.fartTarget == nil then
			data.fartTarget = target.Position 
			sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE,1);
		end
		data.fartCount = data.fartCount + 1
		
		--Dip summon things
		if data.fartCount%3 == 0 then
			local poops1 = Isaac.FindByType(EntityType.ENTITY_DIP,-1,-1,false,true)
			local poops2 = Isaac.FindByType(EntityType.ENTITY_DIP,3,-1,false,true)
			if(#poops1+#poops2<=5) then
				local poopAim = (data.fartTarget-entity.Position):Normalized()*mod.UConst.poopSpeed
				if mod:RandomInt(1,5)<=mod.UConst.cornChance then
					local poop = Isaac.Spawn(EntityType.ENTITY_DIP, 3, 0, entity.Position, poopAim, entity)
					poop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					
					if mod.ModConfigs.altUranus then
						local sprite = poop:GetSprite()
						sprite:ReplaceSpritesheet (0, "gfx/monsters/snow_big_corn.png")
						sprite:LoadGraphics()
					end
				else
					local poop = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, entity.Position, poopAim, entity)
					poop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

					if mod.ModConfigs.altUranus then
						local sprite = poop:GetSprite()
						sprite:ReplaceSpritesheet (0, "gfx/monsters/snow_dip.png")
						sprite:LoadGraphics()
					end
				end
			end
		end
		
		local poopParams = ProjectileParams()
		
		
		poopParams.Color = mod.Colors.poop
		if mod.ModConfigs.altUranus then
			poopParams.Color = mod.Colors.booger
		else
			sfx:Play(SoundEffect.SOUND_FART,4)
		end
		
		entity:FireBossProjectiles (mod.UConst.poopDensity, data.fartTarget, 8-data.fartCount, poopParams )
		
	end
end
function mod:UranusHail(entity, data, sprite, target, room)

	if data.HailCount>1 then
		for i=1, 4 do
			mod:SpawnSnowflake(entity,room,3)
		end
	end

	--Why do the animations dont work if there is a 360 rotation????????
	if data.StateFrame == 1 then
		sprite:Play("Twerk",true)

		if mod.ModConfigs.altUranus and data.HailCount == 0 then
			sfx:Play(Isaac.GetSoundIdByName("Shivering"), 1, 2, false, 1)
		end

	elseif sprite:IsFinished("Twerk") and data.HailCount < mod.UConst.nBlizzards then
		
		--Freeze dips cuz they are annoying
		if data.HailCount == 1 then
			local poops = Isaac.FindByType(EntityType.ENTITY_DIP)
			if #poops > 0 then
				for _, p in ipairs(poops) do
					sfx:Play(SoundEffect.SOUND_FREEZE,1);
					p:AddEntityFlags(EntityFlag.FLAG_ICE_FROZEN)
					p.CollisionDamage = 0
					p:GetSprite():Stop()
					p:GetSprite().Color = mod.Colors.frozen
					p.HitPoints = 0
				end
			end
		end
		
		for i = 1,mod.UConst.nHails do
		
			--Silly thing to make the hail not spawn on top of a player because I dont know how to modify the tear created by FireProjectiles()
			local position = nil
			local flagSafe = false
			while not flagSafe do
				flagSafe = true
				position = Isaac.GetRandomPosition(0)
				for i=0, game:GetNumPlayers ()-1 do
					local player = game:GetPlayer(i)
					while position:Distance(player.Position) < 25 do
						flagSafe = false
						break
					end
					if not flagSafe then break end
				end
			end
			
			local hail = mod:SpawnEntity(mod.Entity.Hail, position, Vector.Zero, entity):ToProjectile()
			
			local randSize = mod:RandomInt(2,3)
			hail:GetSprite():Play("Rotate"..tostring(randSize))
			
			hail.FallingAccel = 2
			hail.ChangeTimeout = 3
			hail.Height = -mod:RandomInt(380,840)
			hail.Scale = mod:RandomInt(16,20)/20
			--hail.Color = mod.Colors.hailColor

			hail:GetData().IsIcicle_HC = true
			hail:GetData().iceSize = mod.UConst.hailIceSize
			hail:GetData().hailTrace = false
			hail:GetData().hailSplash = false
			
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.OCCULT_TARGET, 0, position, Vector.Zero, entity):ToEffect()
			target.Color = mod.Colors.hail
			target.Timeout = 10
		end
	
		data.HailCount = data.HailCount + 1
		sprite:Play("Twerk",true)
		
	elseif sprite:IsFinished("Twerk") then
		data.State = mod:MarkovTransition(data.State, mod.chainU)
		data.HailCount = 0
		data.StateFrame = 0
	end

	if data.StateFrame%10 == 0 and not mod.ModConfigs.altUranus then
		sfx:Play(SoundEffect.SOUND_CLAP,1);
	end
end
function mod:UranusPee(entity, data, sprite, target, room)
	mod:FaceTarget(entity, target)
	if data.StateFrame == 1 then
		sprite:Play("Pee",true)
	elseif sprite:IsFinished("Pee") then
		data.State = mod:MarkovTransition(data.State, mod.chainU)
		data.StateFrame = 0
		
	elseif sprite:IsEventTriggered("Pee") then
		
		local peeParams = ProjectileParams()
		
		peeParams.Color = mod.Colors.pee
		if mod.ModConfigs.altUranus then
			peeParams.Color = mod.Colors.booger
			sfx:Play(Isaac.GetSoundIdByName("Sneeze"), 2, 2, false, 1)
		else
			--sfx:Play(Isaac.GetSoundIdByName("SOUND_V2/MEAT_IMPACTS"),5)
			sfx:Play(70,5)
		end
		peeParams.Acceleration = 0.00001
		
		entity:FireBossProjectiles (mod.UConst.nPee, target.Position, -1, peeParams )
		
	end
end
function mod:UranusThank(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Spin",true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	elseif sprite:IsPlaying("Spin") then
		if rng:RandomFloat() < 0.3 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, mod:RandomInt(0,1), entity.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)
		sfx:Play(SoundEffect.SOUND_FART,1)
		end
	elseif sprite:IsFinished("Spin") then
		if data.SpinCount < mod.UConst.nPoopSpins then
			data.SpinCount = data.SpinCount + 1
			sprite:Play("Spin",true)
		else
			sprite:Play("Thanks",true)
		end
		
	elseif sprite:IsFinished("Thanks") then
		
		local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.Moons.Uranus, entity.Position, Vector.Zero, nil)
		mod:NormalDeath(entity, true)
		entity:Remove()
	end
end

--Move
function mod:UranusMove(entity, data, room, target)
	mod:FaceTarget(entity, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room
	
	--idleTime == frames moving in the same direction
	if not data.idleTime then
		data.idleTime = mod:RandomInt(mod.UConst.idleTimeInterval.X, mod.UConst.idleTimeInterval.Y)
		--distance of Uranus from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > mod.UConst.centerDistanceToleration then
			data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		--Else, get closer to the player
		else
			data.targetvelocity = ((target.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
		end
	end
	
	--If run out of idle time
	if data.idleTime <= 0 and data.idleTime ~= nil then
		data.idleTime = nil
	else
		data.idleTime = data.idleTime - 1
	end
	
	--Do the actual movement
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.UConst.speed
	data.targetvelocity = data.targetvelocity * 0.99
end


--ded
function mod:UranusDeath(entity)
	
	if entity.Variant == mod.EntityInf[mod.Entity.Uranus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Uranus].SUB then
		--Relaxed
		mod:scheduleForUpdate(function()
			sfx:Play(Isaac.GetSoundIdByName("UranusRelax"), 0.6)
		end, 25)

		--Poops
		for i=1,15 do
			local poop = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, mod:RandomInt(0,1), entity.Position + Vector(0.1,0):Rotated(rng:RandomFloat()*360), Vector((rng:RandomFloat() * 8) + 3.5,0):Rotated(rng:RandomFloat()*360), entity)
		end

		mod:NormalDeath(entity)

		--Poop rain
		for i=1, 350 do
			local angle = 360*rng:RandomFloat()
			local position = entity.Position + Vector(math.sqrt(mod:RandomInt(0,(mod.NConst.rainDropRadius/2)^2)),0):Rotated(angle)
			--Poop rain projectiles:
			local poopParams = ProjectileParams()
			poopParams.Scale = mod:RandomInt(1,100)/100
			poopParams.FallingAccelModifier = 2
			poopParams.ChangeTimeout = 3
			--poopParams.HeightModifier = -mod:RandomInt(150,6000)
			poopParams.FallingSpeedModifier = -mod:RandomInt(10,600)
			poopParams.Color = mod.Colors.poop
			
			entity:FireProjectiles(position, Vector.Zero, 0, poopParams)
		end
		local angle = 360*rng:RandomFloat()
		local position = entity.Position + Vector(math.sqrt(mod:RandomInt(0,(mod.NConst.rainDropRadius/2)^2)),0):Rotated(angle)
		--Poop rain projectiles:
		local poopParams = ProjectileParams()
		poopParams.Scale = 2
		poopParams.FallingAccelModifier = 2
		poopParams.ChangeTimeout = 3
		poopParams.HeightModifier = -7000
		poopParams.Color = mod.Colors.poop
		
		entity:FireProjectiles(position, Vector.Zero, 0, poopParams)


		--Clean room
		
		for _, i in ipairs(Isaac.FindByType(EntityType.ENTITY_DIP)) do
			i:Die()
		end
		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.IceTurd)) do
			if i.Child then i.Child:Remove() end
			i:Remove()
			sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
			game:SpawnParticles (i.Position, EffectVariant.DIAMOND_PARTICLE, 50, 9)
		end
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.Turd)) do
			if i.Child then i.Child:Remove() end
			i:Remove()
			sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
			game:SpawnParticles (i.Position, EffectVariant.DIAMOND_PARTICLE, 50, 9)
		end
	end
end
--deding
function mod:UranusDying(entity)
	
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if data.deathFrame == nil then data.deathFrame = 1 end

	if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
		if sprite:IsEventTriggered("Scream") then
			sfx:Play(Isaac.GetSoundIdByName("UranusScream"), 1)
		end
	end
end

--Ice
function mod:SpawnIceCreep(position, size, tear)
	--For some reason spawning this creep makes the FPS slowly die, so my solution is to tell you to not take to much time in the fight
	local ices = mod:FindByTypeMod(mod.Entity.IceCreep)
	if #ices <= 150 then
		mod:SpawnIceCreepSingular(position, tear)
		
		for i=1, size-1 do
			local density = i*3
			for j=1, density do
				local extraPosition = position + Vector(i*20,0):Rotated(j*360/density)
				mod:SpawnIceCreepSingular(extraPosition, tear)
			end
		end
	end
end
function mod:SpawnIceCreepSingular(position, tear)
	if not mod:IsOutsideRoom(position, game:GetRoom()) then
		local ice = mod:SpawnEntity(mod.Entity.IceCreep, position, Vector.Zero, tear):ToEffect()
		ice:GetData().isIce = true
		ice:GetData().iceCount = 2
		ice.Timeout = 500
	end
end

--Pee
function mod:PeeProjectile(tear,collided)
	local data = tear:GetData()
	
	--If tear collided then
	if tear:IsDead() or collided then
		if data.target then
			data.target:Remove()
		end
		
		--Spawn pee
		local pee = nil

		if mod.ModConfigs.altUranus then
			pee = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0, tear.Position, Vector.Zero, tear):ToEffect()
		else
			pee = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_YELLOW, 0, tear.Position, Vector.Zero, tear):ToEffect()
		end
		pee.Timeout = mod.UConst.peeCreepTime
		
		--Melt the ice
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.CREEP_SLIPPERY_BROWN then
			if  (entity.Position):Distance(tear.Position) < mod.UConst.peeMeltRadius then
				entity:Die()
			end
			end
		end
		
	end
end

--Callbacks
--Uranus updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UranusUpdate, mod.EntityInf[mod.Entity.Uranus].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.UranusDeath, mod.EntityInf[mod.Entity.Uranus].ID)

--Pee updates
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, tear)
	if tear.Acceleration <= 0.00001 then
		mod:PeeProjectile(tear,false)
	end
end)



--NEPTUNE---------------------------------------------------------------------------------------------------

--[[
/*//**/**//*//**/**//*//**/**//*//**/**//**/**/**//**/**//*//**/**//*//**/**//*/
/*//**/**//*//**/**//*/###%##(/*//**/**//**/**/**//**/**//*//**/**//*//**/**//*/
********************/#&%%%%%%%&&%(**********************************************
*/**//*//**/**//*//**&%%#/*//#&@@@@@@@@@@@@&&@@@&**/**//**/**//*//**/**//*//**/*
*/**//*//**/**//*//**%%%%@@@@@@@@@@@@@@@@@@@@@&&&@@@@@@/**/**//*//**/**//*//**/*
/*//**/**//*//**/**//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%//**/**//*//**/**//*/
/*//**/**//*//**/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(*/**//*//**/**//*/
*/**//*//**/**/&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//**/**//*//**/*
*/**//%%%#(#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@**/**//*//**/*
/*//*(%%&#/#@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/*//**/**//*/
/*//*(%%&&(@@@@@@@@&(#(((#((&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%#(/(/*/
*/**//*#%&@@@@@@@@&(#@(@(@#(%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#####%%(/(*
*/**//*//@@@&@@@@@@&(#(@@##%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/##%%///*
/*//**/**@@@(&@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(####*/(*/
/*//**/*&@@@@@((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((#**//*/
*/**/#%%@@@@@@@@@(&@&(&@@(&@((&&((&((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//*//**/*
*/*%&%###@@@@@@@@@@@@@@@@(@@@@@@@@@@@%((@@@@@@@&&%%#%&&@@@@@@@@@@@@@@@@//*//**/*
/*%%%#/**&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@&(#@@@@(#%&@@@@@@@@@@@@@&&&%**//*/
/*%&%##**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#(@(@(@##&@@@@@@@@@@@@@&&&%**//*/
/*#%&&%#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(%@@@@&&##((##%&@@@@@@@@@@@@@&%((/**//*/
*/**##%&&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((&@@@@@&&@@@@@@@@@@@@@@@@/**//*//**/*
*/**//*//**/%@@@@@@@((&@@@@@@@@@@@@@@@@@@@@@&(%@(@@@@@@@@@@@@@@@@@@*/**//*//**/*
/*//**/**//*//@@@@@@&(&@@@@@@@@@@@@@@@@@@@@@@@@@#@@((@((@%(@@@@@@#//*//**/**//*/
/*//**/**//*//**@@@@@@@@@@%((&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%*//**/**//*/
*/**//*//**/**//*/#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//*%&%#%(*//*//**/*
*/**//*//**/**//*//**(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%&%%&@&#%(*//*//**/*
/*//**/**//*//**/**//*//**@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@&&&&&%%%##(///**/**//*/
/*//**/**//*//**/**//*//**/**//*/@@@@@@@@@@@@@/**//**/**//(#(/*/**//*//**/**//*
/*//**/**//*//**/**//*//**/**//*//**/**//**/**/**//**/**//*//**/**//*//**/**//*/
]]--

mod.NMSState = {
	APPEAR = 0,
	IDLE = 1,
	DEIDLE = 2,
	REIDLE = 3,
	SHOT = 4,
	ABSORB = 5,
	RAIN = 6,
	BUBBLE = 7,
	DOWN = 8,
	UP = 9,
	AMBUSH = 10,
	REAPPEAR = 11,
	NOAMBUSHXD = 12
}
mod.chainN = {
	[mod.NMSState.APPEAR] = 	{0,   1,    0,    0,      0,     0,    0,     0,     0,    0,    0,    0, 0},
	[mod.NMSState.IDLE] = 		{0,   0.2,  0.8,  0,      0,     0,    0,     0,     0,    0,    0,    0, 0},
	[mod.NMSState.DEIDLE] = 	{0,   0,    0,    0,      0.28,  0,    0.27,  0,     0.45, 0,    0,    0, 0},
	[mod.NMSState.REIDLE] = 	{0,   1,    0,    0,      0,     0,    0,     0,     0,    0,    0,    0, 0},
	[mod.NMSState.SHOT] = 		{0,   0,    0,    0.44,   0.13,  0,    0.13,  0,     0.3,  0,    0,    0, 0},
	[mod.NMSState.ABSORB] = 	{0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 0},
	--[mod.NMSState.ABSORB] = 	{0,   0,    0,    0,      0,     1,    0,     0,     0,    0,    0,    0, 0},
	[mod.NMSState.RAIN] = 		{0,   0,    0,    0.35,   0.15,  0,    0.25,  0,     0.25, 0,    0,    0, 0},
	[mod.NMSState.BUBBLE] = 	{0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 0},
	--[mod.NMSState.BUBBLE] = 	{0,   0,    0,    0,      0,     0,  0,     1,   0,    0,    0,    0, 0},
	[mod.NMSState.DOWN] = 		{0,   0,    0,    0,      0,     0,    0,     0,     0,    0.6,  0.4,  0, 0},
	[mod.NMSState.UP] = 		{0,   0,    0,    0,      0,     0.5,  0,     0.5,   0,    0,    0,    0, 0},
	--[mod.NMSState.UP] = 		{0,   0,    0,    0,      0,     0,  0,     1,   0,    0,    0,    0, 0},
	[mod.NMSState.AMBUSH] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0,    1, 0},
	[mod.NMSState.REAPPEAR] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0.65, 0, 0.35},
	--[mod.NMSState.REAPPEAR] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    1, 0, 0},
	[mod.NMSState.NOAMBUSHXD] = {0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 0},
	
}
mod.NConst = {--Some constant variables of Neptune
	speed = 2,

	nUpDownSpash = 2,
	upDownSpashFall = 0.7,
	minDistanceToReappear = 50,

	nShots = 4,
	normalShotSpeed = 9,
	normalShotAngle = 90,
	specialShotSpeed = 13,
	specialShotScale = 0.5, --+1

	nAbsorbs = 33,

	nRainDrop = 24,
	rainDropRadius = 120,

	nBubbleSplash = 2,
	bubbleSplashFall = 0.9,
	nBubbleRing = 8,
	bubbleSpeed = 7,
	nBubbleEndSplash = 3,
	bubbleEndSplashFall = 0.7,

	nFakers = 4,
	nAmbushSpash = 2,
	ambushSplashFall = 2,
	ambushSpeed = 60,

	nSplash = 8
}

function mod:NeptuneUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR and entity.SubType == mod.EntityInf[mod.Entity.Neptune].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0

			data.AbsorbCount = 0 
		end
		
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.NMSState.APPEAR then
			if data.StateFrame == 1 then
				--KILL
				if apocrypha then
					apocrypha:RemoveCallback(ModCallbacks.MC_NPC_UPDATE, apocrypha.hangingSpider)
				end
				mod:AppearPlanet(entity)

				data.Blood = false
				data.Tear = ProjectileVariant.PROJECTILE_TEAR
				if game:GetLevel():GetStage()==LevelStage.STAGE4_1 or game:GetLevel():GetStage()==LevelStage.STAGE4_2 then
					data.Blood = true
					data.Tear = ProjectileVariant.PROJECTILE_NORMAL
				end

				if data.Blood then
					sprite:ReplaceSpritesheet (0, "gfx/bosses/neptune_shiny.png")
					sprite:ReplaceSpritesheet (3, "gfx/bosses/neptune_shiny.png")
					sprite:ReplaceSpritesheet (4, "gfx/bosses/neptune_shiny_eyes.png")
					sprite:LoadGraphics()
				end

				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		elseif data.State == mod.NMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle1",true)
				data.CurrentTargetPosition = target.Position
				entity:PlaySound(SoundEffect.SOUND_HEARTIN,1,0,false,mod:RandomInt(198,202)/1000);
			elseif sprite:IsFinished("Idle1") then
				sprite:Play("Idle2",true)
				data.CurrentTargetPosition = target.Position
				sfx:Play(SoundEffect.SOUND_HEARTIN,1,0,false,mod:RandomInt(198,202)/1000);
			elseif sprite:IsFinished("Idle2") then
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
				
			elseif sprite:GetFrame() < 15 then
				mod:NeptuneMove(entity, data, room, data.CurrentTargetPosition)
			end
		
		elseif data.State == mod.NMSState.DEIDLE then
			if data.StateFrame == 1 then
				sprite:Play("Derotate",true)
			elseif sprite:IsFinished("Derotate") then
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
				
			end
		elseif data.State == mod.NMSState.REIDLE then
			if data.StateFrame == 1 then
				sprite:Play("Rerotate",true)
			elseif sprite:IsFinished("Rerotate") then
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
				
			end
		elseif data.State == mod.NMSState.DOWN then
			if data.StateFrame == 1 then
				sprite:Play("Down",true)
				entity.CollisionDamage = 0
			elseif sprite:IsFinished("Down") then
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
				
				entity.Position = room:GetCenterPos()
			
			elseif sprite:IsEventTriggered("HideShadow") then
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
				sfx:Play(SoundEffect.SOUND_BOSS2_DIVE,1);
				mod:SpawnSplash(entity, mod.NConst.nUpDownSpash, mod.NConst.upDownSpashFall)
			
			end
		elseif data.State == mod.NMSState.UP then
			if data.StateFrame == 1 then
				sprite:Play("Up",true)
			elseif sprite:IsFinished("Up") then
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
				entity.CollisionDamage = 1
				mod:SpawnSplash(entity, mod.NConst.nUpDownSpash, mod.NConst.upDownSpashFall)
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1);
			end
		
		elseif data.State == mod.NMSState.SHOT then
			mod:NeptuneShot(entity, data, sprite, target, room)
		
		elseif data.State == mod.NMSState.ABSORB then
			mod:NeptuneAbsorb(entity, data, sprite, target, room)
		
		elseif data.State == mod.NMSState.RAIN then
			mod:NeptuneRain(entity, data, sprite, target, room)
			
		elseif data.State == mod.NMSState.BUBBLE then
			mod:NeptuneBubble(entity, data, sprite, target, room)
		
		elseif data.State == mod.NMSState.AMBUSH then
			mod:NeptuneAmbush(entity, data, sprite, target, room)

		elseif data.State == mod.NMSState.NOAMBUSHXD then
			if data.StateFrame == 1 then
				sprite:Play("Up",true)
				entity.CollisionDamage = 0
				local position = Isaac.GetRandomPosition(0)
				while position:Distance(target.Position) < mod.NConst.minDistanceToReappear do
					position = Isaac.GetRandomPosition(0)
				end
				entity.Position = position
			elseif sprite:IsFinished("Up") then
				sprite:Play("Bounce",true)
				entity.CollisionDamage = 1
				mod:SpawnSplash(entity, mod.NConst.nUpDownSpash, mod.NConst.upDownSpashFall)
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1);
			elseif sprite:IsFinished("Bounce") then
				data.State = mod:MarkovTransition(data.State, mod.chainN)
				data.StateFrame = 0
			end
		elseif data.State == mod.NMSState.REAPPEAR then
			data.State = mod:MarkovTransition(data.State, mod.chainN)
			data.StateFrame = 0
			
		end

		if not mod.ModConfigs.noRain then
			local rain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RAIN_DROP, 0, room:GetRandomPosition(0), Vector(0,0), entity):ToEffect()
		end
	end
	
end
function mod:NeptuneShot(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Shot",true)
	elseif sprite:IsFinished("Shot") then
		data.State = mod:MarkovTransition(data.State, mod.chainN)
		data.StateFrame = 0
	
	elseif sprite:IsEventTriggered("Shot") then
		local targetAim = target.Position - entity.Position
		for i=0, mod.NConst.nShots-1 do
			local angle = -mod.NConst.normalShotAngle/2 + mod.NConst.normalShotAngle / (mod.NConst.nShots-1) *i
			local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, targetAim:Normalized():Rotated(angle)*mod.NConst.normalShotSpeed, entity):ToProjectile()
			water.FallingSpeed = 0
			water.FallingAccel = -0.1
		end
		local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, targetAim:Normalized()*mod.NConst.specialShotSpeed, entity):ToProjectile()
		water:AddScale(mod.NConst.specialShotScale)				
		water.FallingSpeed = 0
		water.FallingAccel = -0.1
		sfx:Play(SoundEffect.SOUND_PING_PONG,2)
	end
end
function mod:NeptuneAbsorb(entity, data, sprite, target, room)
	entity.Position = room:GetCenterPos(0)
	entity.Velocity = Vector.Zero
	if data.StateFrame == 1 then
		sprite:Play("AbsorbBegin",true)
		sfx:Play(SoundEffect.SOUND_BOSS2_WATERTHRASHING,1);
		
		entity.Friction = 1
		entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

		
		for _, i in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, data.Tear)) do
			i:Remove()
		end

	elseif sprite:IsFinished("AbsorbBegin") then
		
		sprite:Play("Absorb",true)
		local tornado = mod:SpawnEntity(mod.Entity.Tornado, entity.Position+Vector(0,1), Vector.Zero, entity)
		tornado:GetData().Lifespan = 9
		tornado:GetData().Height = 7
		tornado:GetData().Scale = 0.9
		tornado:GetData().FastSpawn = true
		
	elseif sprite:IsFinished("Absorb") then
	
		if data.AbsorbCount < mod.NConst.nAbsorbs then
			data.AbsorbCount = data.AbsorbCount + 1
			sprite:Play("Absorb",true)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WHIRLPOOL, 1, entity.Position, Vector(0,0), entity):ToEffect()
			if data.StateFrame%20==0 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOGMA_BLACKHOLE, 2, entity.Position, Vector(0,0), entity):ToEffect()
			end
			
			--Tears
			for i=1,8 do
				if mod:RandomInt(0,20)<=2 then
					local velocity = mod:RandomInt(5,55)/10
					local targetAim = target.Position-entity.Position
					local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, targetAim:Normalized()*velocity, entity):ToProjectile()
					water.Scale = mod:RandomInt(1,120)/100
					water.FallingSpeed = 0
					water.FallingAccel = -0.1
				end
				
			end
		else
			data.AbsorbCount = 0
			data.State = mod:MarkovTransition(data.State, mod.chainN)
			data.StateFrame = 0
			entity.Friction = 0.8
			entity:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			
		end
		
	end
	if sprite:IsPlaying("Absorb") then
		
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if not player.CanFly then
				local spinVector = player.Position - entity.Position
				player.Velocity = player.Velocity + Vector(-0.016*spinVector.Y, 0.008*spinVector.X-0.008*spinVector.Y)
			end
		end
		
	end
end
function mod:NeptuneRain(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Rain",true)
	elseif sprite:IsFinished("Rain") then
		data.State = mod:MarkovTransition(data.State, mod.chainN)
		data.StateFrame = 0
	
	elseif sprite:IsEventTriggered("Rain") then
		game:ShakeScreen(15)
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)

		for i=0, mod.NConst.nRainDrop do
			local angle = 360*rng:RandomFloat()
			local position = target.Position + Vector(math.sqrt(mod:RandomInt(0,mod.NConst.rainDropRadius^2)),0):Rotated(angle)
			--Rain projectiles:
			local dropParams = ProjectileParams()
			dropParams.Scale = mod:RandomInt(1,100)/100
			dropParams.FallingAccelModifier = 2
			dropParams.ChangeTimeout = 3
			dropParams.HeightModifier = -mod:RandomInt(380,1200)
			dropParams.Variant = data.Tear
			
			entity:FireProjectiles(position, Vector.Zero, 0, dropParams)
		end
		sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH,1)
	end
end
function mod:NeptuneBubble(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Bounce",true)
	elseif sprite:IsFinished("Bounce") then
		sprite:Play("Bubble",true)
		sfx:Play(Isaac.GetSoundIdByName("Inflation"),1)
		data.StateFrame = 1
		entity.Friction = 1
	elseif sprite:IsFinished("Bubble") then
		data.State = mod:MarkovTransition(data.State, mod.chainN)
		data.StateFrame = 0
		entity.Friction = 0.8
		mod:SpawnSplash(entity, mod.NConst.nBubbleEndSplash, mod.NConst.bubbleEndSplashFall)
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1,2,false,2.4);
	
	elseif data.StateFrame <= 90 and data.StateFrame%25==0 then
		local offset = 360*rng:RandomFloat()
		for i=1, mod.NConst.nBubbleRing do
			local angle = i*360/mod.NConst.nBubbleRing + offset
			local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, Vector(1,0):Rotated(angle)*mod.NConst.bubbleSpeed, entity):ToProjectile()
			water.FallingSpeed = 0
			water.FallingAccel = -0.1
		end
		mod:SpawnSplash(entity, mod.NConst.nBubbleSplash, mod.NConst.bubbleSplashFall)
		
	elseif sprite:IsEventTriggered("BubbleWave") then
		sfx:Play(SoundEffect.SOUND_BOSS2_WATERTHRASHING,1,2,false,1);
	end

end
function mod:NeptuneAmbush(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Up",true)
		entity.CollisionDamage = 0
		local position = Isaac.GetRandomPosition(0)
		while position:Distance(target.Position) < mod.NConst.minDistanceToReappear do
			position = Isaac.GetRandomPosition(0)
		end
		entity.Position = position
		
		for i=1,mod.NConst.nFakers do
			local faker = mod:SpawnEntity(mod.Entity.NeptuneFaker, Isaac.GetRandomPosition(0), Vector.Zero, entity)
			local fpsrite = faker:GetSprite()
			
			if data.Blood then
			
				fpsrite:ReplaceSpritesheet (0, "gfx/bosses/neptune_shiny.png")
				fpsrite:LoadGraphics()
			end
			fpsrite:Play("Up",true)
			faker.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			faker:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
		
		game:Darken(1,60)

	elseif sprite:IsFinished("Up") then
		sprite:Play("Waiter",true)
		entity.CollisionDamage = 1
		data.AimPosition = target.Position
	elseif sprite:IsFinished("Waiter") then
		data.State = mod:MarkovTransition(data.State, mod.chainN)
		data.StateFrame = 0
		entity.CollisionDamage = 0
	
	elseif sprite:IsEventTriggered("Ambush") then
		mod:SpawnSplash(entity, mod.NConst.nAmbushSpash, mod.NConst.ambushSplashFall)
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
		entity.Velocity = (data.AimPosition - entity.Position):Normalized()*mod.NConst.ambushSpeed
		
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1);
		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.NeptuneFaker)) do
			i:Remove()
		end
	elseif sprite:IsEventTriggered("Chomp") then
		sfx:Play(Isaac.GetSoundIdByName("Chomp"),2,0,false,0.7);
		
	end
end

--Move
function mod:NeptuneMove(entity, data, room, targetPosition)
	--If Neptune is slowed down, it moves ridiculously fast
	if not (entity:HasEntityFlags(EntityFlag.FLAG_SLOW)) then 
		data.targetvelocity = ((targetPosition - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
		
		--Do the actual movement
		entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.NConst.speed
		data.targetvelocity = data.targetvelocity * 0.9
	end
	
	--I dont know how to check if the hourglass effect is active, so the next if solves it 😎
	if entity.Velocity:Length() > 40 then
		entity.Velocity = Vector.Zero
	end
end

--ded
function mod:NeptuneDeath(entity)
	
	if entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR and entity.SubType == mod.EntityInf[mod.Entity.Neptune].SUB then

		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.NeptuneFaker)) do
			i:Remove()
		end
		
		sfx:Play(Isaac.GetSoundIdByName("Pop"),100);

		mod:NormalDeath(entity)
		
		mod:SpawnSplash(entity, 5, mod.NConst.upDownSpashFall*1.5)
	end

end
--deding
function mod:NeptuneDying(entity)
	
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	if data.deathFrame == nil then data.deathFrame = 1 end

	if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
		if sprite:IsEventTriggered("DeathSplash") then 
			mod:DyingSplash(entity)
			
		elseif sprite:IsEventTriggered("DeathCry") then
			sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,2,2,false,2)
			if #(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER))==0 and not data.Blood then
				water = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER, 0, entity.Position, Vector.Zero, entity)
			end
		end
	end
end
function mod:DyingSplash(entity)
	local waterParams = ProjectileParams()
	waterParams.Variant = entity:GetData().Tear
	waterParams.FallingAccelModifier = mod.NConst.upDownSpashFall*3.5
	for i = 1, 5 do
		local angle = 360*rng:RandomFloat()
		entity:FireBossProjectiles (3, entity.Position + Vector(1,0):Rotated(angle), 0, waterParams )
	end
end

--Do a splash of water
function mod:SpawnSplash(entity, amount, falling)
	for i=1,mod.NConst.nSplash do
		local waterParams = ProjectileParams()
		waterParams.Variant = ProjectileVariant.PROJECTILE_TEAR
		if game:GetLevel():GetStage()==LevelStage.STAGE4_1 or game:GetLevel():GetStage()==LevelStage.STAGE4_2 then
			waterParams.Variant = ProjectileVariant.PROJECTILE_NORMAL
		end
		waterParams.FallingAccelModifier = falling
		local angle = i*360/mod.NConst.nSplash
		entity:FireBossProjectiles (amount, entity.Position + Vector(1,0):Rotated(angle), 0, waterParams )
	end
end

--Callbacks
--Neptune updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.NeptuneUpdate, mod.EntityInf[mod.Entity.Neptune].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.NeptuneDeath, mod.EntityInf[mod.Entity.Neptune].ID)
