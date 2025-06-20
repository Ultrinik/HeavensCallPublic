local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

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
	SAW = 8,
	TRACE = 9,
	SUPERSAW = 10,
	SURPRISE = 11,
}
mod.chainS = {				--   Ap Id    HR    SR    Spin  Bomb  Summ  Knif  Saw   Trac  SSaw
	[mod.SMSState.APPEAR] = 	{0, 1,    0,    0,    0,    0,    0,    0 ,   0,    0,    0},
	[mod.SMSState.IDLE] = 		{0, 0.2,  0.4,  0,    0,    0,    0,    0.17, 0.23, 0,    0},
	[mod.SMSState.HIDERING] = 	{0, 0,    0,    0,    0.35, 0.35, 0.3,  0,    0,    0,    0},
	--[mod.SMSState.HIDERING] = 	{0, 0,    0,    0,    0,    0,    0,    0  ,  0,    1,    1},
	[mod.SMSState.SUMMONRING] = {0, 1,    0,    0,    0,    0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.SPIN] = 		{0, 0,    0,    0.55, 0.45, 0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.BOMB] = 		{0, 1,    0,    0,    0,    0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.SUMMON] = 	{0, 0,    0,    1,    0,    0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.KNIFE] = 		{0, 0,    0,    1,    0,    0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.SAW] = 		{0, 1,    0,    0,    0,    0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.TRACE] = 		{0, 0.2,  0.8,  0,    0,    0,    0,    0  ,  0,    0,    0},
	[mod.SMSState.SUPERSAW] = 	{0, 1,    0,    0,    0,    0,    0,    0  ,  0,    0,    0}
	
}
mod.SConst = {--Some constant variables of Saturn
	GO_TO_SIDE_SPEED = 1.6,
	SPEED = 1.4,
	SLOW_SPEED = 1.3,
	CENTER_DISTANCE_TOLERATION = 70,
	IDLE_TIME_INTERVAL = Vector(15,20),

	N_HORF = 6,
	N_HORF_MURDER_TEARS = 10,
	HORF_MURDER_TEAR_SPEED = Vector(3,7),
	HORF_ORBIT_SPEED = 4.5,

	N_BOMBS = 5,
	BOMB_DAMAGE = 15,
	BOMB_COUNTDOWN = 80,
	BOMB_SPEED = 30,
	BOMB_ORBIT_SPEED = 7,
	SPECIAL_BOMB_CHANCE = 0.35,
	BOMB_THROWN_OFFSET = -80,
	RADIUS_BOMB_DEFENSE = 80,

	N_SPECIAL_KEYS = 45,
	N_NORMAL_KEYS = 15,
	SPECIAL_KEY_SPEED = 5,
	NORMAL_KEY_SPEED = 9,
	SPECIAL_KEY_ANGLE = 120,
	NORMAL_KEY_ANGLE = 270,
	KEY_DESTROY_DISTANCE = 300,
	KEY_ORBIT_SPEED = 10,
	TIME_STOP_FRAMES = 62,
	KEY_LIFESPAN = 200,
	N_IDLE_PRE_TIME_STOP = 1,
	N_IDLE_POST_TIME_STOP = 4,


	N_ASTEROIDS = Vector(4,6),
	ASTEROID_ORBIT_SPEED = 500,
	ASTEROID_SCALE = 1,

	SAW_SKIPS = 1,
	HEAL_PER_HYPER = 5,

	SAW_DAMAGE = 50,
	SAW_RADIUS = 100,

	N_SAWS = 10,
	SAW_SPEED = 1.5,

	N_TRACES = 10,
	TRACE_PERIOD = 30,
	TRACE_TRIGGER = 60,

}
function mod:SetSaturnDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
		--   							 Ap Id    HR    SR    Spin  Bomb  Summ  Knif  Saw   Trac  SSaw
		mod.chainS[mod.SMSState.IDLE] = {0, 0.2,  0.4,  0,    0,    0,    0,    0.17, 0.23, 0,    0}
		
		--stat changes--------------------------------------------------------------------------------------------------
		--hearts
		mod.SConst.N_HORF = 6
		mod.SConst.N_HORF_MURDER_TEARS = 10
		mod.SConst.HORF_ORBIT_SPEED = 4.5

		--bombs
		mod.SConst.N_BOMBS = 5
		mod.SConst.BOMB_COUNTDOWN = 80
		mod.SConst.SPECIAL_BOMB_CHANCE = 0.35

		--keys
		mod.SConst.N_SPECIAL_KEYS = 45
		mod.SConst.N_NORMAL_KEYS = 15
		mod.SConst.SPECIAL_KEY_SPEED = 5
		mod.SConst.N_IDLE_POST_TIME_STOP = 4

		--coins
		mod.SConst.N_ASTEROIDS = Vector(4,5)
		mod.SConst.ASTEROID_ORBIT_SPEED = 500

		--saw

		--trace

	elseif difficulty == mod.Difficulties.ATTUNED then
		--   							 Ap Id    HR    SR    Spin  Bomb  Summ  Knif  Saw   Trac  SSaw
		mod.chainS[mod.SMSState.IDLE] = {0, 0.2,  0.4,  0,    0,    0,    0,    0.17, 0.23, 0,    0}

		--stat changes--------------------------------------------------------------------------------------------------
		--hearts
		mod.SConst.N_HORF = 7
		mod.SConst.N_HORF_MURDER_TEARS = 12
		mod.SConst.HORF_ORBIT_SPEED = 5

		--bombs
		mod.SConst.N_BOMBS = 6
		mod.SConst.BOMB_COUNTDOWN = 75
		mod.SConst.SPECIAL_BOMB_CHANCE = 0.45

		--keys
		mod.SConst.N_SPECIAL_KEYS = 50
		mod.SConst.N_NORMAL_KEYS = 17
		mod.SConst.SPECIAL_KEY_SPEED = 6
		mod.SConst.N_IDLE_POST_TIME_STOP = 3

		--coins
		mod.SConst.N_ASTEROIDS = Vector(5,7)
		mod.SConst.ASTEROID_ORBIT_SPEED = 550

		--saw
		mod.SConst.N_SAWS = 10
		mod.SConst.SAW_SPEED = 1.5

		--trace

    elseif difficulty == mod.Difficulties.ASCENDED then
		--   							 Ap Id    HR    SR    Spin  Bomb  Summ  Knif  Saw   Trac  SSaw
		mod.chainS[mod.SMSState.IDLE] = {0, 0.2,  0.32, 0,    0,    0,    0,    0.15, 0.23, 0.1,   0}

		--stat changes--------------------------------------------------------------------------------------------------
		--hearts
		mod.SConst.N_HORF = 8
		mod.SConst.N_HORF_MURDER_TEARS = 15
		mod.SConst.HORF_ORBIT_SPEED = 5.5

		--bombs
		mod.SConst.N_BOMBS = 7
		mod.SConst.BOMB_COUNTDOWN = 70

		--keys
		mod.SConst.N_SPECIAL_KEYS = 55
		mod.SConst.N_NORMAL_KEYS = 20
		mod.SConst.SPECIAL_KEY_SPEED = 7
		mod.SConst.N_IDLE_POST_TIME_STOP = 2

		--coins
		mod.SConst.N_ASTEROIDS = Vector(6,7)
		mod.SConst.ASTEROID_ORBIT_SPEED = 600

		--saw
		mod.SConst.N_SAWS = 12
		mod.SConst.SAW_SPEED = 1.5

		--trace

    end
end
--mod:SetSaturnDifficulty(mod.savedatasettings().Difficulty)

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
			data.Timestop_inmune = 2

			data.MoveTowards = false
			data.TimeStoped = false
			data.HealPerHyper = mod.SConst.HEAL_PER_HYPER
			data.SawSkips = 0

			data.robocat = 0
            
			mod:CheckEternalBoss(entity)
		end
		data.robocat = data.robocat - 1
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.SMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				mod:SaturnStateChange(entity, sprite, data)
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		elseif data.State == mod.SMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				mod:SaturnStateChange(entity, sprite, data)
				
			else
				mod:SaturnMove(entity,data,room,target)
			end
		
		--Hide and summon the rings
		elseif data.State == mod.SMSState.HIDERING then
			if data.StateFrame == 1 then
				sprite:Play("HideRings",true)
			elseif sprite:IsFinished("HideRings") then
				mod:SaturnStateChange(entity, sprite, data)
			end
		elseif data.State == mod.SMSState.SUMMONRING then
			if data.StateFrame == 1 then
				sprite:Play("SummonRings",true)
			elseif sprite:IsFinished("SummonRings") then
				mod:SaturnStateChange(entity, sprite, data)
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
		elseif data.State == mod.SMSState.SUPERSAW then
			mod:SaturnSuperSaw(entity, data, sprite, target, room)
		elseif data.State == mod.SMSState.TRACE then
			mod:SaturnTrace(entity, data, sprite, target, room)
		elseif data.State == mod.SMSState.SURPRISE then
			mod:SaturnSurprise(entity, data, sprite, target, room)
			
		end

        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)
		
		if data.MoveTowards then
			mod:MoveTowards(entity, data, data.MoveObjective, mod.SConst.GO_TO_SIDE_SPEED)
		end

		if sprite:IsEventTriggered("HideSFX") then
			sfx:Play(Isaac.GetSoundIdByName("clockwork1"))
		elseif sprite:IsEventTriggered("SummonSFX") then
			sfx:Play(Isaac.GetSoundIdByName("clockwork2"))
		elseif sprite:IsEventTriggered("bagSFX") then
			sfx:Play(Isaac.GetSoundIdByName("bagsound"))
		elseif sprite:IsEventTriggered("bagcloseSFX") then
			sfx:Play(Isaac.GetSoundIdByName("bagclose"))
		elseif sprite:IsEventTriggered("robocatSFX") and rng:RandomFloat() < 0.5 then
			if data.robocat < 0 then
				data.robocat = 15
				sfx:Play(Isaac.GetSoundIdByName("robocat"))
			end
		end

		mod:SaturnLook(entity, sprite, data, room, target)
	end
end
function mod:SaturnSpin(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--Clockwise or couterclockwise spin
		data.Spin = 2*mod:RandomInt(0, 1) - 1
		if data.Spin == 1 then
			sprite:Play("SpinCW",true)
		else
			sprite:Play("SpinCCW",true)
		end
	elseif sprite:IsFinished("SpinCW") or sprite:IsFinished("SpinCCW") then
		mod:SaturnStateChange(entity, sprite, data)
		
	elseif sprite:IsEventTriggered("Summon") then
		
		--Summon the asteroids
		local orbitOffset = 360*rng:RandomFloat()
		local asteroidAmount = mod:RandomInt(mod.SConst.N_ASTEROIDS.X,mod.SConst.N_ASTEROIDS.Y)
		for i=1, asteroidAmount do
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_COIN, 0, entity.Position, Vector.Zero, entity):ToProjectile()
			if tear then
				tear.Parent = entity

				tear:GetData().orbitingSaturn = true
				tear:GetData().orbitIndex = i
				tear:GetData().orbitTotal = asteroidAmount
				tear:GetData().Spin = data.Spin
				tear:GetData().orbitOffset = orbitOffset

				tear:AddScale(mod.SConst.ASTEROID_SCALE)

				tear.FallingAccel = -0.1
				tear.FallingSpeed = 0

				local tearSprite = tear:GetSprite()
				tearSprite:ReplaceSpritesheet (0, "hc/gfx/projectiles/saturn_coin_tears.png")
				tearSprite:LoadGraphics()
			end
		end
		
		--sfx:Play(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT,0.9,2,false,0.9)
		sfx:Play(Isaac.GetSoundIdByName("coins"))
	end
end
function mod:SaturnBomb(entity, data, sprite, target, room)
	if sprite:IsPlaying("Bomb") or sprite:IsPlaying("IdleRingless") then
		mod:SaturnMove(entity,data,room,target)
	end
	if data.StateFrame == 1 then
		if #mod:FindByTypeMod(mod.Entity.SaturnTrace) > 0 and rng:RandomFloat() < 0.5 then
			data.State = mod.SMSState.HIDERING
			mod:SaturnStateChange(entity, sprite, data)
		else
			sprite:Play("Summon",true)
		end
	elseif sprite:IsFinished("Summon") then
		sprite:Play("IdleRingless",true)
		
	elseif sprite:IsEventTriggered("Summon") then
		for i=1, mod.SConst.N_BOMBS do
			local angle = i*360/mod.SConst.N_BOMBS
			local bomb = mod:RandomizeBomb(entity)

			bomb:SetExplosionCountdown(9999)
			bomb:GetData().orbitingSaturn = true
			bomb:GetData().fromSaturn = true
			bomb:GetData().orbitIndex = i
			bomb:GetData().orbitTotal = mod.SConst.N_BOMBS
			bomb:GetData().orbitSpin = 1
			bomb.ExplosionDamage = mod.SConst.BOMB_DAMAGE
			bomb.Parent = entity
			bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

			bomb.RadiusMultiplier = bomb.RadiusMultiplier * 0.67
			if bomb.Variant == BombVariant.BOMB_MR_MEGA then
				bomb.RadiusMultiplier = bomb.RadiusMultiplier * 1.5
			end
		end
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
		
	elseif sprite:IsFinished("IdleRingless") then
		sprite:Play("Bomb",true)
	
	elseif sprite:IsEventTriggered("Bomb") then
		if sprite:IsPlaying("Bomb") or sprite:IsPlaying("SummonRings") then
			local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
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
				if saturnBomb then
					saturnBomb:SetExplosionCountdown(mod.SConst.BOMB_COUNTDOWN)
					saturnBomb.SpriteOffset.Y = mod.SConst.BOMB_THROWN_OFFSET
					saturnBomb:GetData().orbitingSaturn = false
					saturnBomb.Parent = nil
					local player_direction = target.Position - saturnBomb.Position
					saturnBomb.Velocity = player_direction:Normalized()*mod.SConst.BOMB_SPEED
					sfx:Play(mod.SFX.Throw, 1)
				end
			end

		elseif sprite:IsPlaying("FastSpin") then
			local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
			local saturnBomb = nil
			
			for i=1, #bombs do
				local bomb = bombs[i]
				if not bomb:GetData().orbitingSaturn and bomb.Position:Distance(entity.Position) < mod.SConst.RADIUS_BOMB_DEFENSE and bomb.SpriteOffset.Y > -10 then
					saturnBomb = bomb
					break
				end
			end
			
			if saturnBomb ~= nil then
				saturnBomb = saturnBomb:ToBomb()

				local velocity = (saturnBomb.Position - entity.Position):Normalized()*mod.SConst.BOMB_SPEED
				saturnBomb.Velocity = saturnBomb.Velocity + velocity

				entity.Velocity = entity.Velocity - velocity/4

				local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, saturnBomb.Position, Vector.Zero, entity)
				impact.DepthOffset = 10
				
			end

			
			sfx:Play(Isaac.GetSoundIdByName("parry"))
		end
	
	elseif sprite:IsFinished("FastSpin") then
		sprite:Play("Bomb",true)

	elseif sprite:IsFinished("Bomb") then
		local rethrowBomb = false

		local count = 0
		local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
		
		for i=1, #bombs do
			local bomb = bombs[i]
			if not bomb:GetData().orbitingSaturn and bomb.Position:Distance(entity.Position) < mod.SConst.RADIUS_BOMB_DEFENSE and bomb.SpriteOffset.Y > -10 and mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
				rethrowBomb = true
				break
			end
		end
		if not rethrowBomb then
			for i=1, #bombs do
				local bomb = bombs[i]
				if bomb:GetData().orbitingSaturn then 
					count = count + 1
				end
			end
		end

		if rethrowBomb then
			sprite:Play("FastSpin",true)
		else
			if count > 1 then
				sprite:Play("Bomb",true)
			else
				sprite:Play("SummonRings",true)
			end
		end
	elseif sprite:IsFinished("SummonRings") then
		mod:SaturnStateChange(entity, sprite, data)
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
		mod:SaturnStateChange(entity, sprite, data)
	
	elseif sprite:IsEventTriggered("Summon") then
		--Summon the sub horfs
		for i=1, mod.SConst.N_HORF do
			local horf = mod:SpawnEntity(mod.Entity.Hyperion, entity.Position, Vector.Zero, entity)
			horf:GetData().orbitingSaturn = true
			horf:GetData().orbitIndex = i
			horf:GetData().orbitTotal = mod.SConst.N_HORF
			horf:GetData().orbitSpin = -1
			horf.Parent = entity
			horf:GetSprite().Scale =  horf:GetSprite().Scale*1.2
			horf.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		end
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)

		data.SawSkips = mod.SConst.SAW_SKIPS
	end
end
function mod:SaturnKnife(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("HideRingsRed", true)
		data.IdlesPostTimeStop = nil
		
		data.knifeDirection = "Right"
		if entity.Position.X < target.Position.X then
			data.knifeDirection = "Left"
		end

		--knife spawn
		if true then
			local spin = -1
			local a_i = 1
			local b_i = 2
			
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
			local angle = -spin*90
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
			
			sfx:Play(mod.SFX.KnifeSummon, 1)
		end
	elseif sprite:IsFinished("HideRingsRed") then
		sprite:Play("IdleRed", true)

	elseif sprite:IsFinished("IdleRed") then
		sprite:Play("SpinCCWRed", true)

	elseif sprite:IsFinished("SpinCCWRed") then
		sprite:Play("KnifeRed", true)

		local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, entity.Position + Vector(0,-70), Vector.Zero, entity):ToEffect()
		timestuck:GetSprite().Scale = Vector(1,1)*0.8
		timestuck.DepthOffset = 999
		timestuck:FollowParent (entity)
    	timestuck:GetData().Timestop_inmune = 2
		
	elseif sprite:IsFinished("KnifeRed") then
		data.IdlesPreTimeStop = 0
		sprite:Play("Angry"..data.knifeDirection, true)
	elseif sprite:IsFinished("Angry"..data.knifeDirection) then
		data.IdlesPreTimeStop = data.IdlesPreTimeStop + 1
		if data.IdlesPreTimeStop >= mod.SConst.N_IDLE_PRE_TIME_STOP then
			if data.IdlesPostTimeStop then
				data.IdlesPostTimeStop = data.IdlesPostTimeStop + 1
				if data.IdlesPostTimeStop >= mod.SConst.N_IDLE_POST_TIME_STOP then
					sprite:Play("KnifeRed2", true)
				else
					sprite:Play(sprite:GetAnimation(), true)
				end
			else
				data.AngryAttack = 0
				sprite:Play("Angry"..data.knifeDirection.."Attack", true)
			end
			sprite:Play(sprite:GetAnimation(), true)
		else
		end
	elseif sprite:IsFinished("Angry"..data.knifeDirection.."Attack") then
		data.AngryAttack = data.AngryAttack + 1
		if data.AngryAttack == 1 then
			sprite:Play("Angry"..data.knifeDirection.."Attack", true)
		else
			data.IdlesPostTimeStop = 0
			sprite:Play("Angry"..data.knifeDirection, true)
		end
	elseif sprite:IsFinished("KnifeRed2") then
		entity.Friction = 0.9
		mod:SaturnStateChange(entity, sprite, data)

		-- retrieve knives
		if (mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL) then
			mod:scheduleForUpdate(function()
				local keys = mod:FindByTypeMod(mod.Entity.KeyKnife)
				for i, k in ipairs(keys) do
					local spriteKey = k:GetSprite()
					spriteKey.Color = mod.Colors.timeChanged2
		
					k.Velocity = -k.Velocity
				end
				if #keys > 0 then
					sfx:Play(mod.SFX.AshTime2, 1.2)
				end
	
				mod:scheduleForUpdate(function()
					for i, k in ipairs(keys) do
						if k then k:Remove() end
					end
				end, 45)
			end, 25)
		end
	
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
	
	elseif sprite:IsEventTriggered("KnifeThrow1") then
		data.MoveTowards = false
		entity.Friction = 1
		
		local currentSide = "Right"
		if entity.Position.X < room:GetCenterPos().X then
			currentSide = "Left"
		end

		local keys = mod:FindByTypeMod(mod.Entity.KeyKnifeRed)
		for i, k in ipairs(keys) do
			k:Remove()
		end
		
		--Keys that will change angle
		for i=1, mod.SConst.N_SPECIAL_KEYS do
			
			local angle = -mod.SConst.SPECIAL_KEY_ANGLE/2 + i*mod.SConst.SPECIAL_KEY_ANGLE/mod.SConst.N_SPECIAL_KEYS
			local pos = 60
			if currentSide == "Right" then 
				angle = angle + 180
				pos = -60
			end
			local position = entity.Position + Vector(pos,0)
			local velocity = Vector.FromAngle(angle)*mod.SConst.SPECIAL_KEY_SPEED
			
			local key = mod:SpawnEntity(mod.Entity.KeyKnifeRed, position, velocity, entity):ToProjectile()
			key:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
			key:GetSprite().Rotation = angle
			key:GetSprite():Play("BloodIdle", true)
			key.FallingAccel  = -0.1
			key.FallingSpeed = 0
			key.Height = -5
			key:GetData().Lifespan=mod.SConst.KEY_LIFESPAN
		end
		sfx:Play(mod.SFX.KnifeThrow, 1)
		
		
	elseif sprite:IsEventTriggered("KnifeThrow2") then
		
		
		local currentSide = "Right"
		if entity.Position.X < room:GetCenterPos().X then
			currentSide = "Left"
		end

		local keys = mod:FindByTypeMod(mod.Entity.KeyKnife)
		for i, k in ipairs(keys) do
			k:Remove()
		end
		
		--Normal keys
		for i=1, mod.SConst.N_NORMAL_KEYS do
			
			local angle = -mod.SConst.NORMAL_KEY_ANGLE/2 + i*mod.SConst.NORMAL_KEY_ANGLE/mod.SConst.N_NORMAL_KEYS
			local pos = 60
			if currentSide == "Right" then 
				angle = angle + 180
				pos = -60
			end
			local position = entity.Position + Vector(pos,0)
			local velocity = Vector.FromAngle(angle)*mod.SConst.NORMAL_KEY_SPEED
			local key = mod:SpawnEntity(mod.Entity.KeyKnife, position, velocity, entity):ToProjectile()
			key:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
			key:GetSprite().Rotation = angle
			key:GetSprite():Play("Idle", true)
			key.FallingAccel  = -0.1
			key.FallingSpeed = 0
			key:GetData().Lifespan=mod.SConst.KEY_LIFESPAN

		end
		sfx:Play(mod.SFX.KnifeThrow,1)

	elseif sprite:IsEventTriggered("TimeStop") and (data.AngryAttack and data.AngryAttack==0) then
		--Stop time
		mod:StopTime(90)
		mod:EnableWeather(mod.WeatherFlags.TIMESTUCK, 1)

		sfx:Play(mod.SFX.TimeStop, 1)
		sfx:Play(mod.SFX.TikTok, 1)

		for i=0, game:GetNumPlayers()-1 do
			local player = Isaac.GetPlayer(i)
			local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, player.Position + Vector(0,-10), Vector.Zero, player)
			timestuck:GetSprite().Scale = Vector(1,1)*0.4
			timestuck:GetData().Timestop_inmune = 2
			timestuck.DepthOffset = 999
		end
		
	elseif sprite:IsEventTriggered("KnifeChange") and (data.AngryAttack and data.AngryAttack==1) then
		local keys = mod:FindByTypeMod(mod.Entity.KeyKnifeRed)
		for _, k in ipairs(keys) do
			local angle = 360*rng:RandomFloat()
			k:GetSprite().Rotation = angle
			k:GetData().Stored_vel = k:GetData().Stored_vel:Rotated(-k:GetData().Stored_vel:GetAngleDegrees()+angle)

			k:GetSprite():Play("BloodChangedTrace", true)
		end
		sfx:Play(mod.SFX.KnifeReposition, 2)
		
	elseif sprite:IsEventTriggered("TimeResume") then
		sfx:Play(mod.SFX.TimeResume, 1)

		mod:DisableWeather(mod.WeatherFlags.TIMESTUCK, 1)
		mod:ResumeTime()

		local keys = mod:FindByTypeMod(mod.Entity.KeyKnifeRed)
		for _, k in ipairs(keys) do
			k:GetSprite():Play("BloodChanged", true)
		end
	end

end
function mod:SaturnSaw(entity, data, sprite, target, room)	
	if data.StateFrame == 1 then
		if data.SawSkips > 0 then
			data.SawSkips = data.SawSkips - 1
			mod:SaturnStateChange(entity, sprite, data)
		else
			sprite:Play("SawStart",true)
		end

	elseif sprite:IsFinished("SawStart") then
		sprite:Play("Saw",true)
	elseif sprite:IsFinished("Saw") then
		mod:SaturnStateChange(entity, sprite, data)
	
	--Do the pre saw sounds
	elseif sprite:IsEventTriggered("SawSound") then
		sfx:Play(mod.SFX.PreSaw, 0.5)
	
	
	elseif sprite:IsEventTriggered("Saw") then
		
		mod:SaturnSawAttack(entity, data, sprite, target, room)

		--Sound
		sfx:Play(mod.SFX.Saw, 0.5)
	end
end
function mod:SaturnSuperSaw(entity, data, sprite, target, room)	
	if data.StateFrame == 1 then
		sprite:Play("SawStart",true)
		data.nSaws = 0
		data.sawVector = (target.Position - entity.Position):Normalized()

		local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()
		if tracer then
			tracer.DepthOffset = 45

			tracer.LifeSpan = 25
			tracer.Timeout = tracer.LifeSpan
			tracer.TargetPosition = data.sawVector
		end

	elseif sprite:IsFinished("SawStart") or sprite:IsFinished("SawIdleLeft") or sprite:IsFinished("SawIdleRight") then

		if target.Position.X > entity.Position.X then
			sprite:Play("SawIdleLeft",true)
		elseif target.Position.X <= entity.Position.X then
			sprite:Play("SawIdleRight",true)
		end

		data.nSaws = data.nSaws + 1
		if data.nSaws > mod.SConst.N_SAWS then
			sprite:Play("SawEnd",true)

		end
		
		if data.nSaws+1 < mod.SConst.N_SAWS then
			--Sound
			sfx:Play(mod.SFX.Saw, 0.5)
		end
	
	elseif sprite:IsFinished("SawEnd") then
		mod:SaturnStateChange(entity, sprite, data)
		
	elseif sprite:IsEventTriggered("SawSound") then
		sfx:Play(mod.SFX.PreSaw, 0.5)

	elseif sprite:IsEventTriggered("Saw") then
		
		local hit = mod:SaturnSawAttack(entity, data, sprite, target, room)
		if hit then
			data.nSaws = 999
		end
	end
	
	if sprite:IsPlaying("SawIdleLeft") or sprite:IsPlaying("SawIdleRight") then
		local frame = sprite:GetFrame()

		local svec = data.sawVector:Normalized()
		local tpos = (target.Position - entity.Position):Normalized()
		local dot = svec.X*tpos.X + svec.Y*tpos.Y
		dot = math.abs(dot)

		--local a1 = data.sawVector:GetAngleDegrees()
		--local a2 = tpos:GetAngleDegrees()
		--local a3 = mod:AngleLerp(a1,a2,0.1)

		data.sawVector = mod:Lerp(data.sawVector, tpos*dot * mod.SConst.SAW_SPEED, 0.01)
		--data.sawVector = mod:Lerp(data.sawVector, Vector.FromAngle(a3) * mod.SConst.SAW_SPEED, 0.01)

		entity.Velocity = entity.Velocity + data.sawVector

		if entity:CollidesWithGrid() then
			data.sawVector = (target.Position - entity.Position):Normalized()
		end
	end

	if mod.ShaderData.globalTimestuck then
		data.nSaws = 999
	end

end
function mod:SaturnTrace(entity, data, sprite, target, room)	
	if data.StateFrame == 1 then
		if #mod:FindByTypeMod(mod.Entity.SaturnTrace) > 0 then
			data.State = mod.SMSState.KNIFE
			data.StateFrame = 0
		else
			sprite:Play("HideRingsRed",true)
			data.nTraces = 0

			local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, entity.Position + Vector(0,-70), Vector.Zero, entity):ToEffect()
			timestuck:GetSprite().Scale = Vector(1,1)*0.8
			timestuck.DepthOffset = 999
			timestuck:FollowParent (entity)
    		timestuck:GetData().Timestop_inmune = 2

		end
	elseif sprite:IsFinished("HideRingsRed") then
		sprite:Play("IdleTrace",true)
	elseif sprite:IsFinished("IdleTrace") then
		data.nTraces = data.nTraces + 1
		if data.nTraces > mod.SConst.N_TRACES then
			mod:SaturnStateChange(entity, sprite, data)
		else
			sprite:Play("IdleTrace",true)
		end
	end

	if sprite:IsPlaying("IdleTrace") then
		mod:SaturnMove(entity, data, room, target, 1.05)

		if entity.FrameCount % mod.SConst.TRACE_PERIOD == 0 then
			local trace = mod:SpawnEntity(mod.Entity.SaturnTrace, entity.Position, entity.Velocity/4, entity)
			trace:GetSprite():SetFrame(mod:RandomInt(0,2))
			trace.DepthOffset = -1
		end
	end
end
function mod:SaturnSurprise(entity, data, sprite, target, room)	
	if data.StateFrame == 1 then
		sprite:Play("SawSurprise",true)

	elseif sprite:IsFinished("SawSurprise") then
		data.State = mod.SMSState.SUMMONRING
		data.StateFrame = 0
	end

	if sprite:IsEventTriggered("Saw") then
		mod:SaturnSawAttack(entity, data, sprite, target, room)

		--Sound
		sfx:Play(mod.SFX.Saw, 0.5)
	end
end

--State Change
function mod:SaturnStateChange(entity, sprite, data)
	local ogState = data.State

	data.State = mod:MarkovTransition(data.State, mod.chainS)
	data.StateFrame = 0

	if data.State == mod.SMSState.SAW and entity:GetPlayerTarget().Position:Distance(entity.Position) > 180 then
		if mod.savedatasettings().Difficulty == mod.Difficulties.ATTUNED then
			if rng:RandomFloat() < 0.67 then
				data.State = mod:MarkovTransition(mod.SMSState.IDLE, mod.chainS)
			else
				data.State = mod.SMSState.SUPERSAW
			end
		elseif mod.savedatasettings().Difficulty == mod.Difficulties.ASCENDED then
			if rng:RandomFloat() < 0.33 then
				data.State = mod:MarkovTransition(mod.SMSState.IDLE, mod.chainS)
			else
				data.State = mod.SMSState.SUPERSAW
			end
		end
	end

	if data.State == mod.SMSState.SPIN then
		sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/saturn/eyes_coins.png", true)
	elseif data.State == mod.SMSState.BOMB then
		sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/saturn/eyes_bomb.png", true)
	elseif data.State == mod.SMSState.KNIFE then
		sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/saturn/eyes_keys.png", true)
	else
		sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/saturn/eyes.png", true)
	end
end

--Move
function mod:SaturnMove(entity, data, room, target, speedMult)
	speedMult = speedMult or 1
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.SConst.IDLE_TIME_INTERVAL.X, mod.SConst.IDLE_TIME_INTERVAL.Y)
		--distance of Saturn from the center of the room
		local distance = 0.95*(room:GetCenterPos().X-entity.Position.X)^2 + 2*(room:GetCenterPos().Y-entity.Position.Y)^2
		
		--If its too far away, return to the center
		if distance > mod.SConst.CENTER_DISTANCE_TOLERATION^2 then
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
	local speed = mod.SConst.SPEED
	if(#( mod:FindByTypeMod(mod.Entity.Hyperion)) > 0) then--Find by type on upate? nide
		speed = mod.SConst.SLOW_SPEED
	end
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * speed * speedMult
	data.targetvelocity = data.targetvelocity * 0.99
end

function mod:SaturnLook(entity, sprite, data, room, target)
	local layer = sprite:GetLayer(5)
	if (not entity:IsDead()) or data.State == mod.SMSState.IDLE or data.State == mod.SMSState.TRACE or data.State == mod.SMSState.BOMB or data.State == mod.SMSState.KNIFE then
		local direction = (target.Position - (entity.Position + Vector(0,20))):Normalized()
		local final_direction = mod:Lerp(layer:GetPos(), direction*5, 0.1)
		layer:SetPos(final_direction)
	else
		local final_direction = mod:Lerp(layer:GetPos(), Vector.Zero, 0.1)
		layer:SetPos(final_direction)
	end
end

function mod:SaturnSawAttack(entity, data, sprite, target, room)
	local center = entity.Position + Vector(0,-45)
	--Check damage range v
	--for i=1, 50 do
		--Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, center + Vector(mod.SConst.SAW_RADIUS,0):Rotated(i*360/50),Vector.Zero, nil)
	--end

	for i, entity_ in ipairs(Isaac.FindInRadius(center, mod.SConst.SAW_RADIUS)) do
		if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Saturn].ID and entity_.Type ~= EntityType.ENTITY_TEAR and entity_.Type ~= EntityType.ENTITY_PROJECTILE then
			entity_:TakeDamage(mod.SConst.SAW_DAMAGE, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)

			entity_.Velocity = (entity_.Position-entity.Position):Normalized()*10

		elseif entity_.Type == EntityType.ENTITY_PLAYER then
			
			local player = entity_:ToPlayer()
			if player and player:GetDamageCooldown() <= 0 then
				entity_:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
				
				--Summon projectile
				for i=1, mod.SConst.N_HORF_MURDER_TEARS do
					
					local angle = mod:RandomInt(0, 359)
					local speed = mod:RandomInt(mod.SConst.HORF_MURDER_TEAR_SPEED.X, mod.SConst.HORF_MURDER_TEAR_SPEED.Y)
					local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity_.Position, Vector(1,0):Rotated(angle)*speed, entity):ToProjectile()
					tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					tear.FallingSpeed = -1 * mod:RandomInt(1, 500) / 1000
					tear.FallingAccel = mod:RandomInt(1, 30) / 100
					tear.Height = -1 *  mod:RandomInt(18, 30)
				end
				entity_.Velocity = (entity_.Position-entity.Position):Normalized()*10
	
				--Sound
				sfx:Play(mod.SFX.SawHit, 0.4)
	
				--Heal
				local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, entity.Position + Vector(0,-100), Vector.Zero, entity)
				healHeart.DepthOffset = 200
				sfx:Play(SoundEffect.SOUND_VAMP_GULP,2)
	
				entity:AddHealth(50)
	
				return true
			end
		end
	end
	
	--Kill the horfs if there are some alive
	local horfs = mod:FindByTypeMod(mod.Entity.Hyperion)
	
	if #horfs > 0 then
		--Sound
		sfx:Play(mod.SFX.SawHit, 0.4)
	end

	if #horfs > 0 and data.HealPerHyper > 0 then
		local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, entity.Position + Vector(0,-100), Vector.Zero, entity)
		healHeart.DepthOffset = 200
		sfx:Play(SoundEffect.SOUND_VAMP_GULP,2)

		entity:AddHealth(#horfs*data.HealPerHyper)
		data.HealPerHyper = data.HealPerHyper - 1

	end

	for i=1, #horfs do
		local horf = horfs[i]
		if horf.Parent == entity then
			--Summon projectile
			for i=1, mod.SConst.N_HORF_MURDER_TEARS do
				
				local angle = mod:RandomInt(0, 359)
				local speed = mod:RandomInt(mod.SConst.HORF_MURDER_TEAR_SPEED.X, mod.SConst.HORF_MURDER_TEAR_SPEED.Y)
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, horf.Position, Vector(1,0):Rotated(angle)*speed, entity):ToProjectile()
				tear.FallingSpeed = -1 * mod:RandomInt(1, 500) / 1000
				tear.FallingAccel = mod:RandomInt(1, 30) / 100
				tear.Height = -1 *  mod:RandomInt(18, 30)
			end
			horf:Die()
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
			data.orbitAngle = (data.orbitAngle + data.orbitSpin*mod.SConst.HORF_ORBIT_SPEED) % 360
		end
	end
end
function mod:OrbitBomb(entity, orbitingSaturn)
	local data = entity:GetData()
	local sprite = entity.Sprite

	if orbitingSaturn then
		data.orbitOffset = data.orbitAngle or (360*rng:RandomFloat())
		if (not data.orbitAngle) then
		data.orbitAngle = data.orbitIndex*360/data.orbitTotal
		end

		entity.SpriteOffset.Y = mod:Lerp(entity.SpriteOffset.Y, 10*(-1 - 2*math.sin(2*(data.orbitOffset+data.orbitAngle)*3.14159/180)), 0.1)

		if not data.orbitDistance then
			data.orbitDistance = 0
		end
		data.orbitDistance = math.min(50, data.orbitDistance + 3)

		if entity.Parent==nil then
			entity:SetExplosionCountdown(mod.SConst.BOMB_COUNTDOWN)
			entity.SpriteOffset.Y = mod.SConst.BOMB_THROWN_OFFSET
		else
			entity.Position  = entity.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(data.orbitDistance)
			data.orbitAngle = (data.orbitAngle + data.orbitSpin*mod.SConst.BOMB_ORBIT_SPEED) % 360
		end
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	else
		entity.SpriteOffset.Y = math.min(0, entity.SpriteOffset.Y + 4)
		if entity.SpriteOffset.Y > -1 then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		end
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
		data.orbitAngle = (data.orbitAngle + data.Spin*mod.SConst.ASTEROID_ORBIT_SPEED/data.orbitDistance) % 360
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
		local angleStep = data.spinDirection*mod.SConst.KEY_ORBIT_SPEED
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

		sfx:Play(mod.SFX.TouhouDeath, 0.05)
		mod:NormalDeath(entity)

		mod:DeactivateSaturnStuff()
	end
end
function mod:DeactivateSaturnStuff()
		
	for i=0, game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		player.ControlsCooldown = 2
	end
	mod.ShaderData.globalTimestuck = false

	--remaining bombs
	for _, _b in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMB)) do
		local b = _b:ToBomb()
		if b and b:GetData().orbitingSaturn then
			b:Remove()
			b.ExplosionDamage = 0
			b:SetExplosionCountdown(0)
		end
	end
	
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, mod.EntityInf[mod.Entity.KeyKnife].VAR, mod.EntityInf[mod.Entity.KeyKnife].SUB))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, mod.EntityInf[mod.Entity.KeyKnifeRed].VAR, mod.EntityInf[mod.Entity.KeyKnifeRed].SUB))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, mod.EntityInf[mod.Entity.SaturnTrace].VAR, mod.EntityInf[mod.Entity.SaturnTrace].SUB))
end

--deding
function mod:SaturnDying(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Saturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.Saturn].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if data.deathFrame == nil then data.deathFrame = 1 end
		if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
			data.deathFrame = data.deathFrame + 1
			if sprite:GetFrame() == 1 then
				sprite.Rotation = 0

				mod:DeactivateSaturnStuff()
						
				local layer = sprite:GetLayer(5)
				layer:SetPos(Vector.Zero)

				--sfx:Play(Isaac.GetSoundIdByName("TimeStop"),1)
				sfx:Play(mod.SFX.TikTok, 10)
				sfx:Play(Isaac.GetSoundIdByName("angryrobocat"))
			end
		end
	end
end

--Special bomb
function mod:RandomizeBomb(entity)

	local bomb
	if rng:RandomFloat() < mod.SConst.SPECIAL_BOMB_CHANCE then
		local random = mod:RandomInt(1,4+mod.savedatasettings().Difficulty)

		if random == 1 then
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector.Zero, entity):ToBomb()
			if bomb then bomb:AddTearFlags(TearFlags.TEAR_SCATTER_BOMB) end
		elseif random == 2 then
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_MR_MEGA, 0, entity.Position, Vector.Zero, entity)
		elseif random == 3 then
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_SAD_BLOOD, 0, entity.Position, Vector.Zero, entity):ToBomb()
			if bomb then bomb:AddTearFlags(TearFlags.TEAR_SAD_BOMB) end
		elseif random == 4 then
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_POISON, 0, entity.Position, Vector.Zero, entity)
			bomb:GetData().LunaBomb = true
			bomb:GetData().LunaIpecac = true
		elseif random == 5 then
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_THROWABLE, 0, entity.Position, Vector.Zero, entity)
			local bombSprite = bomb:GetSprite()
			bombSprite:ReplaceSpritesheet (0, "hc/gfx/effects/saturn_creep_bomb.png")
			bombSprite:LoadGraphics()
			bomb:GetData().saturnCreep = true
		elseif random == 6 then
			bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector.Zero, entity):ToBomb()
            if bomb then bomb:AddTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB) end
		end
	else
		bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, entity.Position, Vector.Zero, entity)
	end

	if bomb and bomb:ToBomb() then
		return bomb:ToBomb()
	else
		print("ERROR: NO BOMB")
	end
end

--Callbacks
--Saturn updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SaturnUpdate, mod.EntityInf[mod.Entity.Saturn].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.SaturnDeath, mod.EntityInf[mod.Entity.Saturn].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.SaturnDying, mod.EntityInf[mod.Entity.Saturn].ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, _, _, _, _)
	if entity:GetData().TimeStoped then
		return false
	end
end)

--Orbit things updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.OrbitHorf, EntityType.ENTITY_SUB_HORF)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if bomb:GetData().fromSaturn then
		mod:OrbitBomb(bomb, bomb:GetData().orbitingSaturn)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, tear)
	if tear:GetData().orbitingSaturn then
		mod:OrbitRing(tear)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if bomb:GetData().saturnCreep and bomb:GetSprite():IsPlaying("Explode") then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, bomb.Position, Vector.Zero, bomb):ToEffect()
		creep.Timeout = 180
		creep.SpriteScale = Vector.One*3
	end
end)

--Saturn damage
function mod:OnSatrunDamage(entity, amount, damageFlags, sourceRef, frames)
	if entity.Variant == mod.EntityInf[mod.Entity.Saturn].VAR and entity.SubType == mod.EntityInf[mod.Entity.Saturn].SUB then
		if (damageFlags & DamageFlag.DAMAGE_LASER) and (sourceRef and sourceRef.Type == mod.EntityInf[mod.Entity.Saturn].ID) then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnSatrunDamage, mod.EntityInf[mod.Entity.Saturn].ID)

--OTHERS-----------------------------------------------
--Timestuck
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DissapearAfterIdle, mod.EntityInf[mod.Entity.TimeFreezeSource].VAR)
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DissapearAfterIdle, mod.EntityInf[mod.Entity.TimeFreezeObjective].VAR)

--Trace
function mod:SaturnTraceUpdate(effect)
	if effect.SubType == mod.EntityInf[mod.Entity.SaturnTrace].SUB then
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player and player.Position:Distance(effect.Position) < mod.SConst.TRACE_TRIGGER then 
				
				for i, saturn in ipairs(mod:FindByTypeMod(mod.Entity.Saturn)) do
					
					saturn.Position = effect.Position
					saturn.Velocity = Vector.Zero

					local data = saturn:GetData()
					data.StateFrame = 0
					data.State = mod.SMSState.SURPRISE

					
					saturn:SetColor(mod.Colors.red, 15, 1, true, true)

					sfx:Play(Isaac.GetSoundIdByName("angryrobocat"))

					break
				end

				mod:DeactivateSaturnStuff()
			end
		end

		if effect.FrameCount > 30*6.5 then
			effect:GetSprite().Color.A = effect:GetSprite().Color.A - 0.06
		end

		if effect.FrameCount > 30*7 then
			effect:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SaturnTraceUpdate, mod.EntityInf[mod.Entity.SaturnTrace].VAR)

--Key
function mod:KeyUpdate(key, collider, collided)
	if key.SubType == mod.EntityInf[mod.Entity.KeyKnife].SUB or key.SubType == mod.EntityInf[mod.Entity.KeyKnifeRed].SUB then
		local data = key:GetData()
		if data.isOrbiting then
			mod:OrbitKey(key)
		elseif data.Lifespan < 0 then
			key:Remove()
		else
			data.Lifespan = data.Lifespan-1
		end

		if key:IsDead() or (collided ~= nil and collider and collider.Type == EntityType.ENTITY_PLAYER) then
			if  key.SubType == mod.EntityInf[mod.Entity.KeyKnife].SUB then
				game:SpawnParticles (key.Position, EffectVariant.NAIL_PARTICLE, 3, 9)
			else
				game:SpawnParticles (key.Position, EffectVariant.TOOTH_PARTICLE, 3, 9)
			end
			key:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.KeyUpdate, mod.EntityInf[mod.Entity.KeyKnife].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.KeyUpdate, mod.EntityInf[mod.Entity.KeyKnife].VAR)