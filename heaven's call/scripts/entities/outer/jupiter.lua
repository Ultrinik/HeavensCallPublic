local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

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
	LASER = 7,

	TELEPORT = 8,
	WAVE = 9,
}
mod.chainJ = {
							--   app    idle  chr1      chr2	thund   shot  cloud laser	tele  wave					
	[mod.JMSState.APPEAR] = 	{0, 	1,    0,    	0,  	0,    	0,    0,    0,    	0,    0},
	[mod.JMSState.IDLE] = 		{0, 	0.2,  0.135, 	0,  	0.175, 	0.2,  0.18, 0.11,   0,    0},		
	--[mod.JMSState.IDLE] = 		{0, 	0,    0,    	0,  	0,    	0,    0,    0,    	0,    1},
	[mod.JMSState.CHARGE1] = 	{0, 	0,    0,    	1,  	0,    	0,    0,    0,    	0,    0},
	[mod.JMSState.CHARGE2] = 	{0, 	1,    0,    	0,  	0,    	0,    0,    0,    	0,    0},
	[mod.JMSState.THUNDER] = 	{0, 	0.75, 0,    	0,  	0,    	0.25, 0,    0,    	0,    0},
	[mod.JMSState.SHOT] = 		{0, 	0.7,  0,    	0,  	0,    	0.2,  0.1,  0,    	0,    0},
	[mod.JMSState.CLOUD] = 		{0, 	0.75, 0,    	0,  	0,    	0.25, 0,    0,    	0,    0},
	[mod.JMSState.LASER] = 		{0, 	0.95, 0.05, 	0,  	0,    	0,    0,    0,    	0,    0},					
	[mod.JMSState.TELEPORT] = 	{0, 	0.67, 0,    	0,  	0,    	0.33, 0,    0,    	0,    0},					
	[mod.JMSState.WAVE] = 		{0, 	1,    0,    	0,  	0,    	0,    0,    0,    	0,    0}
	
}
mod.JConst = {

	IDLE_TIME_INTERVAL = Vector(20,30),
	SPEED = 1.2,
	IDLE_GAS_TIME = 60,
	GO_CENTER_SPEED = 1.75,

	DEATH_FART_SCALE = 3,
	GAS_TIME_MULTIPLIER = 1,

	--charge
	CHARGE_SPEED = 32,
	CHARGE_FAST_SCALE = 1.5 * 27^2,
	CHARGE_GAS_TIME = 250,
	LASER_KNOCKBACK = 20,
	N_CHARGE_PROJS = 5,
	CHARGE_SHOT_SPEED = 15,
	N_CHARGE_PROJECTILE_ANGLE = 5,

	--lightnings
	N_THUNDER = 2,
	THUNDER_GAS_TIME = 90,

	--v shot
	SHOT_SPEED = 12,
	SHOT_TEAR_SCALE = 1.3,
	SHOT_GAS_TIME = 60,

	--callisto eye (cloud)
	CALLISTO_SHOT_SPEED = 9,
	CALLISTO_KNOCKBACK = 10,
	CALLISTO_TRACE_PERIOD = 5,
	CALLISTO_TRACE_GAS_SCALE = 0.5,
	CALLISTO_TRACE_GAS_TIME = 90,
	CALLISTO_GAS_SCALE = 2,
	CALLISTO_GAS_TIME = 300,
	CALLISTO_DAMAGE = 45,
	CALLISTO_EXPLOSION_RADIUS = 60,
	N_CALLISTO_CLOUD_PROJECTILES = 16,
	CALLISTO_SHOT_EXPLOSION_SPEED = 7,

	--laser
	LASER_VARIANT = LaserVariant.THICKER_BRIM_TECH,
	LASER_PLAYBACK = 1,
	LASER_GAS_TIME = 90,
	LASER_SPIN_SPEED = 1.75,
	LASER_SHOT_SPEED = 7,
	LASER_SHOT_PERIOD = 20,

	--teleport
	TELE_DISTANCE = 120,
	MIN_TELE_DIST = 180,
	N_WISPS = 4,
	WISP_SPEED = 5,
	WISP_HOMING = 1.1,

	--others
	ANGLE_LIST_KEYS = {-180, -165, -150, -135, -45, -30, -13, 0, 9, 16, 26, 40, 48, 90, 128, 141, 151, 159, 168, 180},
	ANGLE_LIST = 	{["-180"]=180, ["-165"]=-165, ["-150"]=-150, ["-135"]=-135, ["-45"]=-45, ["-30"]=-30, ["-13"]=-15, ["0"]=0, ["9"]=15, ["16"]=30, ["26"]=45, ["40"]=60, ["48"]=75, ["90"]=90, ["128"]=105, ["141"]=120, ["151"]=135, ["159"]=150, ["168"]=165, ["180"]=180},

	COLORS = {Color.ProjectileCorpseClusterDark, Color.ProjectileCorpseClusterLight, Color.ProjectileCorpseGreen, Color.ProjectileCorpsePink, Color.ProjectileCorpseWhite, Color.ProjectileCorpseYellow},

}

function mod:SetJupiterDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
		--   									 app    idle  chr1      chr2	thund   shot  cloud laser	tele  	wave
		mod.chainJ[mod.JMSState.IDLE] = 		{0, 	0.2,  0.135, 	0,  	0.175, 	0.2,  0.18, 0.11,   0,     	0}
		mod.chainJ[mod.JMSState.LASER] = 		{0, 	0.95, 0.05, 	0,  	0,    	0,    0,    0,    	0,     	0}

		--stat changes--------------------------------------------------------------------------------------------------
		mod.JConst.GAS_TIME_MULTIPLIER = 1
		--charge
		mod.JConst.N_CHARGE_PROJS = 5
		mod.JConst.CHARGE_SHOT_SPEED = 12
		mod.JConst.N_CHARGE_PROJECTILE_ANGLE = 5

		--lightnings
		mod.JConst.N_THUNDER = 2

		--v shot
		mod.JConst.SHOT_SPEED = 12

		--callisto eye (cloud)
		mod.JConst.CALLISTO_SHOT_SPEED = 7.5
		mod.JConst.CALLISTO_TRACE_PERIOD = 5
		mod.JConst.CALLISTO_EXPLOSION_RADIUS = 60
		mod.JConst.N_CALLISTO_CLOUD_PROJECTILES = 16
		mod.JConst.CALLISTO_SHOT_EXPLOSION_SPEED = 7

		--laser
		mod.JConst.LASER_PLAYBACK = 1
		mod.JConst.LASER_SPIN_SPEED = 1.75
		mod.JConst.LASER_SHOT_SPEED = 6.5
		mod.JConst.LASER_SHOT_PERIOD = 20

		--teleport
		mod.JConst.N_WISPS = 4
		mod.JConst.WISP_SPEED = 5
		mod.JConst.WISP_HOMING = 1.1
		
		
	elseif difficulty == mod.Difficulties.ATTUNED then
		--   									 app    idle  chr1      chr2	thund   shot  cloud laser	tele  	wave
		mod.chainJ[mod.JMSState.IDLE] = 		{0, 	0.2,  0.12,  	0,  	0.15, 	0.2,  0.15, 0.1,    0.08,  	0}
		mod.chainJ[mod.JMSState.LASER] = 		{0, 	0.95, 0.05, 	0,  	0,    	0,    0,    0,    	0,     	0}

		--stat changes--------------------------------------------------------------------------------------------------
		mod.JConst.GAS_TIME_MULTIPLIER = 1.25
		--charge
		mod.JConst.N_CHARGE_PROJS = 7
		mod.JConst.CHARGE_SHOT_SPEED = 14
		mod.JConst.N_CHARGE_PROJECTILE_ANGLE = 6

		--lightnings
		mod.JConst.N_THUNDER = 3

		--v shot
		mod.JConst.SHOT_SPEED = 14

		--callisto eye (cloud)
		mod.JConst.CALLISTO_SHOT_SPEED = 8
		mod.JConst.CALLISTO_TRACE_PERIOD = 3
		mod.JConst.CALLISTO_EXPLOSION_RADIUS = 65
		mod.JConst.N_CALLISTO_CLOUD_PROJECTILES = 20
		mod.JConst.CALLISTO_SHOT_EXPLOSION_SPEED = 8

		--laser
		mod.JConst.LASER_PLAYBACK = 0.67
		mod.JConst.LASER_SPIN_SPEED = 2
		mod.JConst.LASER_SHOT_SPEED = 7
		mod.JConst.LASER_SHOT_PERIOD = 18

		--teleport
		mod.JConst.N_WISPS = 4
		mod.JConst.WISP_SPEED = 5
		mod.JConst.WISP_HOMING = 1.1
		

    elseif difficulty == mod.Difficulties.ASCENDED then
		--   									 app    idle  chr1      chr2	thund   shot  cloud laser	tele  	wave
		mod.chainJ[mod.JMSState.IDLE] = 		{0, 	0.2,  0.12,  	0,  	0.12, 	0.2,  0.12, 0.1,    0.08,  	0.06}
		mod.chainJ[mod.JMSState.LASER] = 		{0, 	0.85,  0.05, 	0,  	0,    	0,    0,    0,    	0,    	0.1}

		--stat changes--------------------------------------------------------------------------------------------------
		mod.JConst.GAS_TIME_MULTIPLIER = 1.5
		--charge
		mod.JConst.N_CHARGE_PROJS = 9
		mod.JConst.CHARGE_SHOT_SPEED = 16
		mod.JConst.N_CHARGE_PROJECTILE_ANGLE = 7

		--lightnings
		mod.JConst.N_THUNDER = 4

		--v shot
		mod.JConst.SHOT_SPEED = 16

		--callisto eye (cloud)
		mod.JConst.CALLISTO_SHOT_SPEED = 8.5
		mod.JConst.CALLISTO_TRACE_PERIOD = 2
		mod.JConst.CALLISTO_EXPLOSION_RADIUS = 70
		mod.JConst.N_CALLISTO_CLOUD_PROJECTILES = 24
		mod.JConst.CALLISTO_SHOT_EXPLOSION_SPEED = 9

		--laser
		mod.JConst.LASER_PLAYBACK = 0.33
		mod.JConst.LASER_SPIN_SPEED = 2.25
		mod.JConst.LASER_SHOT_SPEED = 7.5
		mod.JConst.LASER_SHOT_PERIOD = 16

		--teleport
		mod.JConst.N_WISPS = 5
		mod.JConst.WISP_SPEED = 4
		mod.JConst.WISP_HOMING = 1.2

    end
end
--mod:SetJupiterDifficulty(mod.savedatasettings().Difficulty)


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
            
			mod:CheckEternalBoss(entity)
		end
		--data.State = 1
		--entity.Position = room:GetCenterPos()
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.JMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				mod:JupiterStateChange(entity, sprite, data)
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
			
		elseif data.State == mod.JMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				--Poison cloud:
				local position = entity.Position + mod:RandomVector(65,45)
				local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, Vector.Zero, entity):ToEffect()
				gas.Timeout = math.ceil(mod.JConst.IDLE_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
				
				mod:JupiterStateChange(entity, sprite, data)
				
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
		elseif data.State == mod.JMSState.TELEPORT then
			mod:JupiterTeleport(entity, data, sprite, target,room)
		elseif data.State == mod.JMSState.WAVE then
			mod:JupiterWave(entity, data, sprite, target,room)
		end
        
        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 10*xvel, 0.1)
		
		if data.MoveTowards then
			mod:MoveTowards(entity, data, room:GetCenterPos(), mod.JConst.GO_CENTER_SPEED)
		end
		
		--Eye things
		--data.LockEye = true
		if data.TargetPosition_aim ~= nil and data.State ~= mod.JMSState.CHARGE1 then
			mod:JupiterLook(entity, data, data.TargetPosition_aim, sprite)
		elseif data.LockEye then
			mod:JupiterLook(entity, data, entity.Position+Vector(0,10), sprite)
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
		mod:JupiterStateChange(entity, sprite, data)
		
	--Set the aim to where its going to charge
	--TargetPosition_aim == some old position of the player
	elseif sprite:IsEventTriggered("SetAim") then
		data.TargetPosition_aim = target.Position
	--Starts charging
	elseif sprite:IsEventTriggered("ChargeStart") then
		entity.Velocity = (data.TargetPosition_aim - entity.Position):Normalized() * mod.JConst.CHARGE_SPEED
		data.TargetPosition_aim = nil
		sfx:Play(SoundEffect.SOUND_WAR_BOMB_HOLD,1)
		
	--Spawns poison clouds
	elseif sprite:GetFrame() % 3 == 0 and sprite:GetFrame() >= 27 then
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, entity):ToEffect()
		gas.Timeout = math.ceil(mod.JConst.CHARGE_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
	--Spawns fart
	elseif sprite:GetFrame() % 2 == 0 and sprite:GetFrame() >= 27 and sprite:GetFrame() < 40 then
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
		fart:GetSprite().Scale = Vector.One * mod.JConst.CHARGE_FAST_SCALE / (sprite:GetFrame()^2)

	end
	
	--Tasty collision with walls
	if entity:CollidesWithGrid() then
		game:ShakeScreen(25)
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)
	end
end
function mod:JupiterCharge2(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		sprite:Play("Charge2",true)
		data.ChargeLaser = false

	elseif sprite:IsFinished("Charge2") then
		data.TargetPosition_aim = nil
		data.ChargeLaser = false
		mod:JupiterStateChange(entity, sprite, data)
	
	--Set the aim to where its going to charge
	--TargetPosition_aim == some old position of the player
	elseif sprite:IsEventTriggered("SetAim") then
		data.TargetPosition_aim = target.Position
	--Shot the laser
	elseif sprite:IsEventTriggered("ChargeLaser") then
		local player_direction = data.TargetPosition_aim - (entity.Position-Vector(0,75))
		local position = entity.Position - Vector(0,75) + player_direction:Normalized()*45

		--local brimstone = EntityLaser.ShootAngle(12,  position, player_direction:GetAngleDegrees(), 5, Vector.Zero, entity)
		--brimstone:GetSprite().Color = mod.Colors.jupiterLaser1
		--if target.Position.Y >= entity.Position.Y then brimstone.DepthOffset = 100 end

		data.ChargeLaser = true
		sfx:Play(SoundEffect.SOUND_BEAST_SUCTION_START, 0.5, 2, false, 1.25)
		sfx:Play(SoundEffect.SOUND_WAR_LAVA_DASH, 1.5, 2, false, 1.5)
		sfx:Play(SoundEffect.SOUND_PESTILENCE_PUKE_START, 1.2, 2, false, 1.5)

		--Newton 3rd law
		entity.Velocity = -(player_direction):Normalized() * mod.JConst.LASER_KNOCKBACK
	end

	if data.ChargeLaser then
		local player_direction = data.TargetPosition_aim - (entity.Position-Vector(0,75))
		local position = entity.Position - Vector(0,35) + player_direction:Normalized()*60

		local angle = mod.JConst.N_CHARGE_PROJECTILE_ANGLE
		for i=1, mod.JConst.N_CHARGE_PROJS do
			local speed = mod.JConst.CHARGE_SHOT_SPEED * (0.25 + 2.5*rng:RandomFloat())
			local velocity = player_direction:Rotated(angle * (1 - 2*rng:RandomFloat())):Normalized() * speed

			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, position, velocity, entity):ToProjectile()
			if tear then
				tear:SetColor(mod.JConst.COLORS[mod:RandomInt(1,#mod.JConst.COLORS, rng)], -1, 1, true, true)
				
				tear:AddProjectileFlags(ProjectileFlags.DECELERATE)
				tear:AddProjectileFlags(ProjectileFlags.WIGGLE)
				tear:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
				tear.WiggleFrameOffset = math.floor(10 * speed)

				tear.Acceleration = 1 + 0.25*rng:RandomFloat()
				tear.Height = tear.Height*(1.5 - rng:RandomFloat())
				
				tear.SpriteScale = Vector.One * (0.75 + rng:RandomFloat())
			end
		end
	end
	
	--Dont bounce on the walls you trash cow! (It makes the laser hard to predict)
	if entity:CollidesWithGrid() then
		entity.Velocity = Vector.Zero
		game:ShakeScreen(25)
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)
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

		data.LockEye = true

	elseif sprite:IsFinished("Thunder") then
		mod:JupiterStateChange(entity, sprite, data)
		
		data.LockEye = false
		
	--Summon lightbeams around the player, also fart (gas)
	elseif sprite:IsEventTriggered("Thunder") then
		--Lightbeams:
		for i = 1, mod.JConst.N_THUNDER do
			local angle = 360*rng:RandomFloat()
			local position_aim = target.Position + Vector(90,0):Rotated(angle)
			
			local thunder = mod:SpawnEntity(mod.Entity.Thunder,position_aim, Vector(0,0), entity)
			if mod:RandomInt(0,1)==0 then 
				thunder:GetSprite().FlipX = true
			end
		end
		
		--Poison cloud:
		local position = entity.Position + mod:RandomVector(95, 45)
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, Vector.Zero, entity):ToEffect()
		gas.Timeout = math.ceil(mod.JConst.THUNDER_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
		
		game:ShakeScreen(10);
	end
end
function mod:JupiterShot(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		if entity.Position:Distance(target.Position) < 160 then
			mod:JupiterStateChange(entity, sprite, data)

		else
			sprite:Play("Shot",true)
		end
	elseif sprite:IsFinished("Shot") then
		mod:JupiterStateChange(entity, sprite, data)
		
	--Shot and fart
	elseif sprite:IsEventTriggered("Shot") then
		
		--Tear shots:
		local player_direction = target.Position - (entity.Position-Vector(0,35))
		local position = entity.Position - Vector(0,25) + player_direction:Normalized()*45
		for i = 1, 2 do
			local velocity = player_direction:Rotated((-2*i+3)*23):Normalized()*mod.JConst.SHOT_SPEED
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, position, velocity, entity)
			tear:SetColor(Color.ProjectileCorpseWhite, -1, 1, true, true)
			tear:GetSprite().Scale = Vector.One * mod.JConst.SHOT_TEAR_SCALE
		end

		--Fart and Poison cloud:
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, position, Vector.Zero, entity)
		local position = entity.Position + mod:RandomVector(95, 45)
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, Vector.Zero, entity):ToEffect()
		gas.Timeout = math.ceil(mod.JConst.SHOT_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
		
	end
end
function mod:JupiterCloud(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		if entity.Position:Distance(target.Position) < 135 then
			mod:JupiterStateChange(entity, sprite, data)

		else
			sfx:Play(SoundEffect.SOUND_ANGRY_GURGLE,1);
			sprite:Play("Cloud",true)
		end
	elseif sprite:IsFinished("Cloud") then
		mod:JupiterStateChange(entity, sprite, data)
		
	--Cloud shot
	elseif sprite:IsEventTriggered("Cloud") then
		
		--Cloud projectile:
		local player_direction = target.Position - (entity.Position-Vector(0,75))
		local position = entity.Position - Vector(0,25) + player_direction:Normalized()*45
		local velocity = player_direction:Normalized()*mod.JConst.CALLISTO_SHOT_SPEED
		local tear = mod:SpawnEntity(mod.Entity.CallistoEye, position, velocity, entity):ToProjectile()

		--tear:AddProjectileFlags(ProjectileFlags.WIGGLE)
		
		entity.Velocity = -(target.Position - entity.Position):Normalized() * mod.JConst.CALLISTO_KNOCKBACK
		
		--Fart:
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, position, Vector.Zero, entity)

		sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,5);
	end
end
function mod:JupiterLaser(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		sprite:Play("Laser1",true)
		sfx:Play(SoundEffect.SOUND_SATAN_CHARGE_UP,1)

		data.nLaserShots = 0
		
		--data.LockEye = true
	elseif sprite:IsFinished("Laser1") then
		data.Laser2Frame = data.StateFrame
		data.LaserShotState = 0
		
		sprite.PlaybackSpeed = mod.JConst.LASER_PLAYBACK

		sprite:Play("Laser2",true)

	elseif sprite:IsFinished("Laser2") then
		data.TargetPosition_aim = nil
		data.LaserFlag=false
		mod:JupiterStateChange(entity, sprite, data)
	
	--Go to the center
	elseif sprite:IsEventTriggered("Jump") then
		data.MoveTowards = true
		entity.CollisionDamage = 0
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	
	--Set the aim to where its going to charge
	--TargetPosition_aim == some old position of the player
	elseif sprite:IsEventTriggered("EndIdle") then
		--data.LockEye = false

	elseif sprite:IsEventTriggered("SetAim") then
        sfx:Play(Isaac.GetSoundIdByName("Slam"), 1, 2, false, 1)

		game:ShakeScreen(35);
		entity.Position = room:GetCenterPos()
		entity.Velocity = Vector.Zero
		data.MoveTowards = false
		data.TargetPosition_aim = target.Position
		entity.CollisionDamage = 1
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		
	
	elseif sprite:IsEventTriggered("Land") then
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player then
				mod:MakePlayerJump(player, 60, 15, false, true)
			end
		end
		game:ShakeScreen(15)
		sfx:Play(SoundEffect.SOUND_MOTHER_LAND_SMASH, 1, 2, false, 1.2)
	--Laser
	elseif sprite:IsEventTriggered("Laser") then
        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST,1)
		
		--Spin direction
		local p1 = target.Position-entity.Position
		local p2 = data.TargetPosition_aim-entity.Position
		local crossproductZ = p1.X * p2.Y - p1.Y * p2.X
		data.Spin = 1
		if crossproductZ > 0 then
			data.Spin = -1
		end

		--Brimstone:
		local player_direction = data.TargetPosition_aim - (entity.Position + Vector(0,-75))
		local time = math.floor(37/mod.JConst.LASER_PLAYBACK)
		local angle = player_direction:GetAngleDegrees()
		local superbrimstone = EntityLaser.ShootAngle(mod.JConst.LASER_VARIANT, entity.Position + Vector(0,-75), angle, time, Vector(0,-35), entity)
		superbrimstone.DisableFollowParent = true

		superbrimstone:SetColor(mod.Colors.jupiterLaser2, -1,1,true,true)

		data.LaserFlag=true
		data.Laser = superbrimstone

		superbrimstone:SetActiveRotation(0, 99999, data.Spin*mod.JConst.LASER_SPIN_SPEED, false)

		--Move the target a little
		data.TargetPosition_aim = (data.TargetPosition_aim - entity.Position):Rotated(data.Spin*15/2) + entity.Position
		
	end

	if sprite:IsPlaying("Laser2") and (data.StateFrame-data.Laser2Frame)%mod.JConst.LASER_SHOT_PERIOD == 0 and data.nLaserShots < 3 then
		data.nLaserShots = data.nLaserShots + 1

		local extra = data.LaserShotState * 360/8
		data.LaserShotState = (data.LaserShotState+1)%2
		
		for i = 1 , 4 do
			local position = entity.Position-Vector(0,30)
			local velocity = Vector.FromAngle(i*360/4 + extra) * mod.JConst.LASER_SHOT_SPEED
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, position, velocity, entity):ToProjectile()
			if tear then
				tear.FallingSpeed = 0
				tear.FallingAccel = -0.1
				tear:GetSprite().Color = mod.Colors.jupiterShot
			end
		end
		
		local position = entity.Position + mod:RandomVector(95, 45)
		local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, Vector.Zero, entity):ToEffect()
		gas.Timeout = math.ceil(mod.JConst.LASER_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
	end
	
	if data.LaserFlag then


		data.TargetPosition_aim = (data.TargetPosition_aim - entity.Position):Rotated(data.Spin*mod.JConst.LASER_SPIN_SPEED) + entity.Position

		if data.Laser then
			local laser = data.Laser
			local direction = (data.TargetPosition_aim - entity.Position):Normalized()
			local angle = direction:GetAngleDegrees() % 360
			local rangle = angle*3.14159/180

			local increase = 15*(math.sin(rangle)^2 + 4*math.cos(rangle)^2)
			
			laser.Position = entity.Position + direction*increase
			laser.Angle = angle - data.Spin*mod.JConst.LASER_SPIN_SPEED*7

			if angle >= 0 and angle <= 180 then
				laser.DepthOffset = 100
			else
				laser.DepthOffset = -100
			end
		end

		entity.Velocity = Vector.Zero
	end
	
end
function mod:JupiterTeleport(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		if entity.Position:Distance(target.Position) < mod.JConst.MIN_TELE_DIST then
			mod:JupiterStateChange(entity, sprite, data)
		else
			sprite:Play("Teleport",true)
		end
	elseif sprite:IsFinished("Teleport") then
		mod:JupiterStateChange(entity, sprite, data)

	elseif sprite:IsEventTriggered("EndIdle") then
		local offset = 360*rng:RandomFloat()
		for i=1, mod.JConst.N_WISPS do
			local angle = i*360/mod.JConst.N_WISPS + offset
			local velocity = Vector.FromAngle(angle)*mod.JConst.WISP_SPEED

			local wisp = mod:SpawnEntity(mod.Entity.ElectricWisp, entity.Position, velocity, entity):ToProjectile()
		end
		
		local newPos = nil
		if target.Velocity:Length() > 2 then
			newPos = target.Position + target.Velocity:Normalized()*mod.JConst.TELE_DISTANCE
		else
			newPos = target.Position + mod:RandomVector(mod.JConst.TELE_DISTANCE, mod.JConst.TELE_DISTANCE)
		end
		for i=1, 100 do
			if room:IsPositionInRoom(newPos, 0) then break end
			newPos = target.Position + mod:RandomVector(mod.JConst.TELE_DISTANCE, mod.JConst.TELE_DISTANCE)
		end

		
		local thunder = mod:SpawnEntity(mod.Entity.InstantThunder, entity.Position, Vector.Zero, entity)
		entity.Position = newPos
		local thunder = mod:SpawnEntity(mod.Entity.InstantThunder, entity.Position, Vector.Zero, entity)

		entity:SetColor(mod.Colors.jupiterLaser2, 30, 1, true, false)
		sfx:Play(SoundEffect.SOUND_LASERRING_STRONG)
	end
end
function mod:JupiterWave(entity, data, sprite, target,room)
	if data.StateFrame == 1 then
		data.nJumps = 0
		sprite:Play("Jump",true)
	elseif sprite:IsFinished("Jump") then
		data.nJumps = data.nJumps + 1
		if data.nJumps == 1 then
			sprite:Play("Jump",true)
		else
			mod:JupiterStateChange(entity, sprite, data)

					
			if data.Ring1 then
				data.Ring1:Die()
				data.Ring1 = nil
			end
			if data.Ring2 then
				data.Ring2:Die()
				data.Ring2 = nil
			end
		end
		
	elseif sprite:IsEventTriggered("Land") then
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player then
				mod:MakePlayerJump(player, 40, 20, true, true)
			end
		end
		game:ShakeScreen(25)
		sfx:Play(SoundEffect.SOUND_MOTHER_LAND_SMASH, 1, 2, false, 1.2)

		if data.nJumps==0 then
			
			for i=1,2 do
				local var = LaserVariant.THIN_RED
				if i == 2 then var = LaserVariant.LIGHT_BEAM end
				local ring = Isaac.Spawn(EntityType.ENTITY_LASER, var, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, entity.Position - Vector(0,5), Vector.Zero, entity):ToLaser()
				ring.Parent = entity
				ring.Radius = 0
				ring.Shrink = true

				ring.DepthOffset = -200
				if i == 2 then
					ring:SetScale(0.5)
					ring.DepthOffset = -1000
				end

				ring.TargetPosition = entity.Position
				ring:GetSprite().Color = mod.Colors.jupiterLaser2
				ring:GetSprite().Rotation = rng:RandomFloat()*360

				mod:scheduleForUpdate(function()
					if ring then
						ring:Die()
					end	
				end, 150)

				data["Ring"..tostring(i)] = ring

				mod:scheduleForUpdate(function()
					sfx:Stop(SoundEffect.SOUND_ANGEL_BEAM)
				end, 2)
			end

			sfx:Play(SoundEffect.SOUND_LASERRING_STRONG)
		end

		game:SpawnParticles (entity.Position, EffectVariant.TECH_DOT, 25, 12, mod.Colors.jupiterLaser2)
		for i, _dot in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT)) do
			local dot = _dot:ToEffect()
			if dot and dot.FrameCount < 1 then
				dot.Timeout = mod:RandomInt(1,5)
			end
		end
		
	end

	local function ringFunc(ring)
		ring.Position = ring.TargetPosition
		ring.Velocity = Vector.Zero

		ring.Radius = ring.Radius + 5
		if ring.Radius > 1600 then
			ring:Die()
		end
	end
	if data.Ring1 then
		ringFunc(data.Ring1)
	end
	if data.Ring2 then
		ringFunc(data.Ring2)
	end
end

--State Change
function mod:JupiterStateChange(entity, sprite, data)
	local ogState = data.State

	sprite.PlaybackSpeed = 1

	data.State = mod:MarkovTransition(data.State, mod.chainJ)
	data.StateFrame = 0
end

--Move
function mod:JupiterMove(entity, data, room, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room
	
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.JConst.IDLE_TIME_INTERVAL.X, mod.JConst.IDLE_TIME_INTERVAL.Y)
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.JConst.SPEED
	data.targetvelocity = data.targetvelocity * 0.99
end

--Move eye
function mod:JupiterLook(entity, data, TargetPosition_aim, sprite)
	local angle = -(entity.Position-TargetPosition_aim):GetAngleDegrees()
	if math.abs(angle-data.CurrentAngle)>15/2 then
		if not (-45 > angle and angle > -135) then
			data.CurrentAngle = mod:AngleLerp(data.CurrentAngle, angle, 0.5)

			local new_angle = mod:Takeclosest(mod.JConst.ANGLE_LIST_KEYS,data.CurrentAngle)
			local new_angle_str = mod.JConst.ANGLE_LIST[tostring(new_angle)]
			if new_angle >= 0 or new_angle == -180 then
				sprite:ReplaceSpritesheet (2, "hc/gfx/bosses/jupiter/jupiter_eyes/"..tostring(new_angle_str)..".png")
				sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/nothingmdnouihsdka.png")
			else
				sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/jupiter/jupiter_eyes/"..tostring(new_angle_str)..".png")
				sprite:ReplaceSpritesheet (2, "hc/gfx/bosses/nothingmdnouihsdka.png")
			end
		else
			data.CurrentAngle = -90
			sprite:ReplaceSpritesheet (2, "hc/gfx/bosses/nothingmdnouihsdka.png")
			sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/nothingmdnouihsdka.png")
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
		fart:GetSprite().Scale = mod.JConst.DEATH_FART_SCALE*Vector(1,1)
		sfx:Play(Isaac.GetSoundIdByName("SuperFart"), 3)
		mod:NormalDeath(entity)
	end
end
--deding
function mod:JupiterDying(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Jupiter].VAR and entity.SubType == mod.EntityInf[mod.Entity.Jupiter].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if data.deathFrame == nil then data.deathFrame = 1 end
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
			sprite.PlaybackSpeed = 1

			if not sprite:WasEventTriggered("EndIdle") then
				if data.deathFrame%4 == 0 then
					sfx:Play(SoundEffect.SOUND_MEATY_DEATHS)
				end

				if data.deathFrame%3 == 0 then
					--Poison cloud:
					local velocity = mod:RandomVector(30)
					local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, velocity, entity):ToEffect()
					gas.Timeout = math.ceil(mod.JConst.IDLE_GAS_TIME*5*mod.JConst.GAS_TIME_MULTIPLIER)

					

					local position = entity.Position + Vector(0,-60) + mod:RandomVector(120)
					local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF04, 0, position, Vector.Zero, entity)
					poof:GetSprite().Color = mod.Colors.boom
					poof.DepthOffset = 200
					poof.SpriteScale = Vector.One * 1.5
				end
			end

			if sprite:GetFrame() == 1 then
				sprite.Rotation = 0

				sfx:Play(SoundEffect.SOUND_FAT_GRUNT,2.5,2,false,0.3)
				--Poison cloud:
				local position = entity.Position + mod:RandomVector(65,45)
				local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, Vector.Zero, entity):ToEffect()
				gas.Timeout = math.ceil(mod.JConst.IDLE_GAS_TIME*3*mod.JConst.GAS_TIME_MULTIPLIER)
			elseif sprite:IsEventTriggered("EndIdle") then
				--Particles
				game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 40, 13, mod.Colors.boom)
				local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
				bloody:GetSprite().Color = mod.Colors.boom
				
				sfx:Play(SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 2, false, 0.5)
				sfx:Play(SoundEffect.SOUND_LASERRING_STRONG, 1, 2, false, 2)


			elseif sprite:IsEventTriggered("Farting") then
				--Poison cloud:
				local position = entity.Position + mod:RandomVector(65,45)
				local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, Vector.Zero, entity):ToEffect()
				gas.Timeout = math.ceil(mod.JConst.IDLE_GAS_TIME*5*mod.JConst.GAS_TIME_MULTIPLIER)
			end
		end
	end
end


--Callbacks
--Jupiter updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.JupiterUpdate, mod.EntityInf[mod.Entity.Jupiter].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.JupiterDeath, mod.EntityInf[mod.Entity.Jupiter].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.JupiterDying, mod.EntityInf[mod.Entity.Jupiter].ID)

--CloudJupiterProjectile (Callisto eye)
function mod:CloudJupiterProjectile(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.CallistoEye].SUB then
		local data = tear:GetData()
		local rng = tear:GetDropRNG()
		local sprite = tear:GetSprite()

		if not data.Init then
			data.Init = true
			sprite:Play("Idle", true)

			data.Tears = {}
			for i=1, mod.JConst.N_CALLISTO_CLOUD_PROJECTILES do
				local velocity = mod:RandomVector(12,5) + tear.Velocity 
				local cloud = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, velocity, tear.SpawnerEntity):ToProjectile()
				if cloud then
					cloud:SetColor(mod.JConst.COLORS[mod:RandomInt(1,#mod.JConst.COLORS, rng)], -1, 1, true, true)

					cloud.SpriteScale = Vector.One * (1.5 - rng:RandomFloat())

					cloud:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.CANT_HIT_PLAYER)
					--cloud:AddProjectileFlags(ProjectileFlags.ORBIT_PARENT)

					cloud.Parent = tear

					table.insert(data.Tears, cloud)
				end
			end
		end

		sprite.Rotation = tear.Velocity:GetAngleDegrees()
		
		--gas trace
		if(math.floor(tear.Position.X)%mod.JConst.CALLISTO_TRACE_PERIOD==0) then
			local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, tear):ToEffect()
			gas.Timeout = math.ceil(mod.JConst.CALLISTO_TRACE_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
			gas.SpriteScale = Vector.One * mod.JConst.CALLISTO_TRACE_GAS_SCALE
		end

		--cloud
		for i, cloud in ipairs(data.Tears) do
			if cloud then
				local direction = (tear.Position - cloud.Position):Normalized()*2

				cloud.Velocity = cloud.Velocity + direction
				cloud.Height = mod:Lerp(cloud.Height, mod:RandomInt(-25,-15), 0.1)
			end
		end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then

			--cloud
			for i, cloud in ipairs(data.Tears) do
				if cloud then
					cloud:ClearProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)

					local direction = (cloud.Position-tear.Position):Normalized() * (mod.JConst.CALLISTO_SHOT_EXPLOSION_SPEED * (0.5 + 0.5*rng:RandomFloat()))
					cloud.Velocity = direction
					cloud.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				end
			end
			
			--Explosion:
			local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, tear.Position, Vector.Zero, tear)
			explode:GetSprite().Color = mod.Colors.boom
			--Explosion damage
			for i, entity in ipairs(Isaac.FindInRadius(tear.Position, mod.JConst.CALLISTO_EXPLOSION_RADIUS)) do
				if entity.Type ~= EntityType.ENTITY_PLAYER and entity.Type ~= mod.EntityInf[mod.Entity.Jupiter].ID then
					entity:TakeDamage(mod.JConst.CALLISTO_DAMAGE, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear), 0)
				end
			end
			
			--Poison cloud:
			local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, tear):ToEffect()
			gas.Timeout = math.ceil(mod.JConst.CALLISTO_GAS_TIME*mod.JConst.GAS_TIME_MULTIPLIER)
			gas.SpriteScale = Vector.One * mod.JConst.CALLISTO_GAS_SCALE

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.CloudJupiterProjectile, mod.EntityInf[mod.Entity.CallistoEye].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.CloudJupiterProjectile, mod.EntityInf[mod.Entity.CallistoEye].VAR)

--ElectricWisp
function mod:ElectricWispProjectile(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.ElectricWisp].SUB then
		local data = tear:GetData()
		local rng = tear:GetDropRNG()
		local sprite = tear:GetSprite()

		if not data.Init then
			data.Init = true
			sprite:Play("Idle", true)

			tear:AddProjectileFlags(ProjectileFlags.SMART)
			--tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

			mod:TearFallAfter(tear, 90)

			tear.HomingStrength = mod.JConst.WISP_HOMING
			--tear:SetColor(Color.Default, -1, 1, false, false)

		end
		sprite.Color = mod.Colors.jupiterLaser2
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then

			if game:GetRoom():IsPositionInRoom(tear.Position, 0) then
				sfx:Play(SoundEffect.SOUND_LASERRING_WEAK)
			end

			game:SpawnParticles (tear.Position, EffectVariant.TECH_DOT, 5, 3, mod.Colors.jupiterLaser2)
			for i, _dot in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT)) do
				local dot = _dot:ToEffect()
				if dot and dot.FrameCount < 1 then
					dot.Timeout = mod:RandomInt(1,5)
				end
			end

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.ElectricWispProjectile, mod.EntityInf[mod.Entity.ElectricWisp].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.ElectricWispProjectile, mod.EntityInf[mod.Entity.ElectricWisp].VAR)

--OTHER ENTITIES--------------------------------------------------------------------------------------
--Aurora
function mod:AuroraUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Aurora].SUB then
		local sprite = effect:GetSprite()
		if sprite:IsFinished() then
			effect:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.AuroraUpdate, mod.EntityInf[mod.Entity.Aurora].VAR)

--Thunder
function mod:ThunderUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.Thunder].SUB then
		if effect:GetSprite():IsEventTriggered("Hit") then
			sfx:Play(Isaac.GetSoundIdByName("Thunder"),1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ThunderUpdate, mod.EntityInf[mod.Entity.Thunder].VAR)

--Instant Thunder
function mod:InstantThunderUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.InstantThunder].SUB then
		local data = effect:GetData()
		local sprite = effect:GetSprite()

		if not data.Init then
			data.Init = true

			local animation = "SpotlightDelayed"
			local r = mod:RandomInt(1,6)
			if r > 1 then animation = animation..tostring(r) end

			sprite:Play(animation, true)
			sprite:SetFrame(24)
			sprite.Color = mod.Colors.jupiterLaser2
			
			sfx:Play(Isaac.GetSoundIdByName("Thunder"),1)
		end

		if sprite:IsFinished() then
			effect:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.InstantThunderUpdate, mod.EntityInf[mod.Entity.InstantThunder].VAR)