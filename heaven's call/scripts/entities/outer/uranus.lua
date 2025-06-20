local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

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
	SPIN = 7,
	SNEEZE = 8,
	SUMMON = 9,
}
mod.chainU = {
	--							 appear idle    turd    shot    fart    hail    pee     spin    sneze   summon
	[mod.UMSState.APPEAR] = 	{0, 	0,    	0,    	0,      0,      1,    	0,   	0,    	0,   	0},
	[mod.UMSState.IDLE] = 	    {0, 	0.2,  	0.1, 	0.22,  	0.15,   0.2, 	0.13, 	0,    	0,   	0},
	--[mod.UMSState.IDLE] = 		{0, 	0,    	0,    	0,      0,     	0,     	0,   	0,    	1,   	0},
	[mod.UMSState.TURD] = 	    {0, 	1,    	0,    	0,      0,      0,    	0,   	0,    	0,   	0},
	[mod.UMSState.PROJECTILE] = {0, 	0.7,  	0.15, 	0,      0.15,   0,    	0,   	0,    	0,   	0},
	[mod.UMSState.FARTING] = 	{0, 	0.5,  	0.3,  	0,      0.1,    0,    	0.1, 	0,    	0,   	0},
	[mod.UMSState.HAIL] = 	    {0, 	1,    	0,    	0,      0,      0,    	0,   	0,    	0,   	0},
	[mod.UMSState.PEE] = 	    {0, 	0.6,  	0.1,  	0,      0.2,    0,    	0.1, 	0,    	0,   	0},
	[mod.UMSState.SPIN] = 	    {0, 	0,    	0,    	0,      0,     	0,     	0,   	1,    	0,   	0},
	[mod.UMSState.SNEEZE] = 	{0, 	0.2,   	0,    	0,      0,     	0.3,   	0.3,   	0,    	0.2,   	0},
	[mod.UMSState.SUMMON] = 	{0, 	1,    	0,    	0,      0,     	0,     	0,   	0,    	0,   	0},
	
}
mod.UConst = {--Some constant variables of Uranus
	SPEED = 1.3,
	CENTER_DISTANCE_TOLERATION = 87,
	IDLE_TIME_INTERVAL = Vector(20,30),
	IDLE_ICE_SIZE = 2,
	ICE_TIMEOUT = 15,

	--ice turd
	MAX_TURDS = 5,
	TURD_ICE_SIZE = 3,
	TURD_DAMAGE = 40,
	TURD_RADIUS = 20,
	TURD_ICICLE_ICE_SIZE = 1,
	TURD_ICICLE_SPEED = 9,
	N_TURD_ICICLES = 8,
	TASTY_TURD_CHANCE = 0.15,

	--farting
	N_FARTS = 5,
	MIN_DISTANCE_TO_FART = 175,
	POOP_SPEED = 10,
	CORN_CHANCE = 1, --/5
	POOP_DENSITY = 5,

	--pee
	SUPER_PEE = true,
	N_PEE = 6,
	PEE_CREEP_TIME = 25,
	PEE_MELT_RADIUS = 50,
	PEE_PERIOD = 4,

	--blizzard
	N_BLIZZARDS = 3,
	N_HAILS = 17,
	HAIL_ICE_SIZE = 1,
	N_CRYSTALS = 6,
	MAX_CRYSTALS = 12,

	--shot
	SHOT_SPEED = 7,
	SHOT_ICE_SIZE = 2,
	SHOT_SCALE = 0.5,
	SHOT_TRACE_ICE_SIZE = 1,
	SHOT_ICICLE_ICE_SIZE = 1,
	N_SHOT_ICICLES = 8,
	SHOT_ICICLE_SPEED = 11,

	--sneeze
	SNEEZE_KNOCKBACK = 6,
	N_BOOGERS = 10,

	--moons
	MOON_DISTANCE = 100,
	MOON_ROTATION_SPEED = 2,
	MOON_SPEED = 15,
	MOON_SMASH_RADIUS = 45,
	MOON_IDLES = 10,

	--spare
	N_POOP_SPINS = 3
}
function mod:SetUranusDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
		--					 					appear  idle    turd    shot    fart    hail    pee     spin    sneze   summon
		mod.chainU[mod.UMSState.IDLE] = 		{0,		0.4,  	0.06, 	0.18,  	0.11,   0.16, 	0.09, 	0,    	0,   	0}
		mod.chainU[mod.UMSState.HAIL] = 	    {0, 	1,    	0,    	0,      0,      0,    	0,   	0,    	0,   	0}
		--stat changes--------------------------------------------------------------------------------------------------
		--ice turd
		mod.UConst.MAX_TURDS = 4
		mod.UConst.TURD_ICICLE_SPEED = 9
		mod.UConst.TASTY_TURD_CHANCE = 0.15

		--farting
		mod.UConst.N_FARTS = 5
		mod.UConst.POOP_SPEED = 10
		mod.UConst.CORN_CHANCE = 1 --/5
		mod.UConst.POOP_DENSITY = 5

		--pee
		mod.UConst.SUPER_PEE = false
		mod.UConst.N_PEE = 4
		mod.UConst.PEE_CREEP_TIME = 30
		mod.UConst.PEE_PERIOD = 4

		--blizzard
		mod.UConst.N_BLIZZARDS = 3
		mod.UConst.N_HAILS = 14
		mod.UConst.N_CRYSTALS = 5
		mod.UConst.MAX_CRYSTALS = 8

		--shot
		mod.UConst.SHOT_SPEED = 7
		mod.UConst.SHOT_ICICLE_SPEED = 11

		--sneeze
		mod.UConst.SNEEZE_KNOCKBACK = 3
		mod.UConst.N_BOOGERS = 10

	elseif difficulty == mod.Difficulties.ATTUNED then
		--							 			appear  idle    turd    shot    fart    hail    pee     spin    sneze   summon
		mod.chainU[mod.UMSState.IDLE] = 		{0,		0.4,  	0.07, 	0.17,  	0.09,   0.13, 	0.07, 	0,    	0.07,   	0}
		mod.chainU[mod.UMSState.HAIL] = 	    {0, 	0.75,    	0,    	0,      0,      0,    	0,   	0,    	0.25,   	0}
		--stat changes--------------------------------------------------------------------------------------------------
		--ice turd
		mod.UConst.MAX_TURDS = 5
		mod.UConst.TURD_ICICLE_SPEED = 10
		mod.UConst.TASTY_TURD_CHANCE = 0.2

		--farting
		mod.UConst.N_FARTS = 6
		mod.UConst.POOP_SPEED = 11
		mod.UConst.CORN_CHANCE = 1 --/5
		mod.UConst.POOP_DENSITY = 7

		--pee
		mod.UConst.SUPER_PEE = true
		mod.UConst.N_PEE = 5
		mod.UConst.PEE_CREEP_TIME = 40
		mod.UConst.PEE_PERIOD = 3

		--blizzard
		mod.UConst.N_BLIZZARDS = 3
		mod.UConst.N_HAILS = 17
		mod.UConst.N_CRYSTALS = 7
		mod.UConst.MAX_CRYSTALS = 9

		--shot
		mod.UConst.SHOT_SPEED = 8
		mod.UConst.SHOT_ICICLE_SPEED = 13

		--sneeze
		mod.UConst.SNEEZE_KNOCKBACK = 5
		mod.UConst.N_BOOGERS = 12

    elseif difficulty == mod.Difficulties.ASCENDED then
		--							 			appear  idle    turd    shot    fart    hail    pee     spin    sneze   summon
		mod.chainU[mod.UMSState.IDLE] = 		{0,		0.41,  	0.07, 	0.17,  	0.09,   0.07, 	0.07, 	0,    	0.07,   0.05}
		--mod.chainU[mod.UMSState.IDLE] = 	    {0, 	0,    	0,    	0,      0,      0,    	0,   	0,    	0,   	1}
		mod.chainU[mod.UMSState.HAIL] = 	    {0, 	0.5,    	0,    	0,      0,      0,    	0,   	0,    	0.25,   	0.25}
		--stat changes--------------------------------------------------------------------------------------------------
		--ice turd
		mod.UConst.MAX_TURDS = 6
		mod.UConst.TURD_ICICLE_SPEED = 11
		mod.UConst.TASTY_TURD_CHANCE = 0.25

		--farting
		mod.UConst.N_FARTS = 7
		mod.UConst.POOP_SPEED = 13
		mod.UConst.CORN_CHANCE = 2 --/5
		mod.UConst.POOP_DENSITY = 10

		--pee
		mod.UConst.SUPER_PEE = true
		mod.UConst.N_PEE = 6
		mod.UConst.PEE_CREEP_TIME = 50
		mod.UConst.PEE_PERIOD = 2

		--blizzard
		mod.UConst.N_BLIZZARDS = 4
		mod.UConst.N_HAILS = 20
		mod.UConst.N_CRYSTALS = 9
		mod.UConst.MAX_CRYSTALS = 10

		--shot
		mod.UConst.SHOT_SPEED = 9
		mod.UConst.SHOT_ICICLE_SPEED = 15

		--sneeze
		mod.UConst.SNEEZE_KNOCKBACK = 7
		mod.UConst.N_BOOGERS = 15

    end
end
--mod:SetUranusDifficulty(mod.savedatasettings().Difficulty)

--mod:TestChain(mod.UMSState, mod.chainU, {{"TURD",2},{"PROJECTILE",3},{"FARTING",4},{"HAIL",5},{"PEE",6},{"SNEEZE",8},{"SUMMON",9}})

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
			data.SpinCount = 0

			
            data.LookingAt = 'l'
            
			mod:CheckEternalBoss(entity)
		end
        
        if target.Position.X > entity.Position.X then
            data.TargetAt = 'r'
        else
            data.TargetAt = 'l'
        end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.UMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				mod:UranusStateChange(entity, sprite, data)
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

				mod:EnableWeather(mod.WeatherFlags.BLIZZARD)
			end
		elseif data.State == mod.UMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("IdleAss",true)
			elseif sprite:IsFinished("IdleAss") or sprite:IsFinished("IdleFlip") then
				mod:UranusStateChange(entity, sprite, data)
				mod:SpawnIceCreep(entity.Position, mod.UConst.IDLE_ICE_SIZE, entity)
				

                if sprite:IsFinished("IdleFlip") then
                    if data.LookingAt == 'l' then 
                        data.LookingAt = 'r'
                        sprite.FlipX = true
                    elseif data.LookingAt == 'r' then
                        data.LookingAt = 'l'
                        sprite.FlipX = false
                    end
                    sprite:Play("IdleAss",true)
                end
			else
                if not sprite:IsPlaying("IdleFlip") then
                    if data.LookingAt ~= data.TargetAt then
                        --local frame = sprite:GetFrame()
                        sprite:Play("IdleFlip", true)
                        --sprite:SetFrame(frame)
                    end
                end


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
		elseif data.State == mod.UMSState.SNEEZE then
			mod:UranusSneeze(entity, data, sprite, target, room)
		elseif data.State == mod.UMSState.SUMMON then
			mod:UranusSummon(entity, data, sprite, target, room)
		end
        
        --local xvel = entity.Velocity.X / 10
        --sprite.Rotation = mod:Lerp(sprite.Rotation, 20*xvel, 0.1)

		if (not mod.CriticalState) then
			mod:SpawnSnowflake(entity,room)
		end
	end
end
function mod:UranusShot(entity, data, sprite, target, room)
	--mod:FaceTarget(entity, target)
	if data.StateFrame == 1 then
		sprite:Play("ShotAss",true)
	elseif sprite:IsFinished("ShotAss") then
		mod:UranusStateChange(entity, sprite, data)
		
	elseif sprite:IsEventTriggered("Shot") then
		local player_direction = target.Position - entity.Position
		local hail = mod:SpawnEntity(mod.Entity.BigIcicle, entity.Position, player_direction:Normalized()*mod.UConst.SHOT_SPEED, entity):ToProjectile()
		hail:GetSprite().Rotation = player_direction:GetAngleDegrees()
		hail.FallingAccel  = -0.1
		hail.FallingSpeed = 0
		hail:AddScale(mod.UConst.SHOT_SCALE)
		--hail:GetSprite().Color = mod.Colors.hailColor
		hail:GetData().iceSize = mod.UConst.SHOT_ICE_SIZE
		hail:GetData().hailTrace = true
		hail:GetData().hailSplash = true
		hail.Parent = entity
		
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
	end
end
function mod:UranusTurd(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--If there are to many turds, dont summon more
		local turds = #mod:FindByTypeMod(mod.Entity.IceTurd) + #mod:FindByTypeMod(mod.Entity.Turd)
		if(turds < mod.UConst.MAX_TURDS) then
			--mod:FaceTarget(entity, target)
			if rng:RandomFloat() < mod.UConst.TASTY_TURD_CHANCE then
				sprite:Play("TurdTasty",true)
			else
				sprite:Play("TurdNormal",true)
			end
		else
			mod:UranusStateChange(entity, sprite, data)
		end
	elseif sprite:IsFinished("TurdNormal") or sprite:IsFinished("TurdTasty") then
		mod:UranusStateChange(entity, sprite, data)
		
	elseif sprite:IsEventTriggered("Turd1") then
		--Peek a boo
		sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE,1);
	elseif sprite:IsEventTriggered("Turd2") then
		--Begin rotation
	elseif sprite:IsEventTriggered("Turd3") then
		--Tactical nuke in comming
		sfx:Play(SoundEffect.SOUND_BULLET_SHOT,4);
		local iceTurd = nil
		if sprite:IsPlaying("TurdNormal") then
			iceTurd = mod:SpawnEntity(mod.Entity.IceTurd, target.Position, Vector.Zero, entity)
		else
			iceTurd = mod:SpawnEntity(mod.Entity.Turd, target.Position, Vector.Zero, entity)
		end
		mod:IceTurdInit(iceTurd)
	
	end
	
	if not sprite:WasEventTriggered("Turd1") then
		mod:UranusMove(entity, data, room, target)
	else
		entity.Velocity = Vector.Zero
	end
end
function mod:UranusFarting(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--Dont fart to close to the player
		if (entity.Position):Distance(target.Position) < mod.UConst.MIN_DISTANCE_TO_FART then
			sprite:Play("FartingBegin",true)
			--mod:FaceTarget(entity, target)
			data.fartCount = 0
		else
			mod:UranusStateChange(entity, sprite, data)
		end
		data.nFarts = 0
	elseif sprite:IsFinished("FartingBegin") then
		sprite:Play("Farting",true)
	elseif sprite:IsFinished("Farting") then
		data.nFarts = data.nFarts + 1
		if data.nFarts > mod.UConst.N_FARTS then
			sprite:Play("FartingEnd",true)
		else
			sprite:Play("Farting",true)
		end
	elseif sprite:IsFinished("FartingEnd") then
		data.fartTarget = nil
		data.fartCount = 0
		mod:UranusStateChange(entity, sprite, data)
		
	elseif sprite:IsEventTriggered("Fart") then
		if data.fartTarget == nil then
			data.fartTarget = target.Position
			sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE,1)
		end
		data.fartCount = data.fartCount + 1
		
		local poopParams = ProjectileParams()
		
		
		poopParams.Color = mod.Colors.poop
		sfx:Play(SoundEffect.SOUND_FART,4)
		
		entity:FireBossProjectiles (mod.UConst.POOP_DENSITY, data.fartTarget, 8-data.fartCount, poopParams )
		
	elseif sprite:IsEventTriggered("Dip") then
		
		--Dip summon things
		if data.fartCount%3 == 0 then
			local poops1 = Isaac.FindByType(EntityType.ENTITY_DIP,-1,-1,false,true)
			local poops2 = Isaac.FindByType(EntityType.ENTITY_DIP,3,-1,false,true)
			if(#poops1+#poops2<=5) then
				local poopAim = (data.fartTarget-entity.Position):Normalized()*mod.UConst.POOP_SPEED
				if mod:RandomInt(1,5)<=mod.UConst.CORN_CHANCE then
					local poop = Isaac.Spawn(EntityType.ENTITY_DIP, 3, 0, entity.Position, poopAim, entity)
					poop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					
				else
					local poop = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, entity.Position, poopAim, entity)
					poop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

				end
			end
		end
	end
end
function mod:UranusHail(entity, data, sprite, target, room)

	if data.HailCount>1 then
		if not mod.CriticalState then
			for i=1, 4 do
				mod:SpawnSnowflake(entity,room,3, 2)
			end
		end
	end

	if data.StateFrame == 1 then
		sprite:Play("Twerk",true)

		if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
			sfx:Play(Isaac.GetSoundIdByName("IceGrow"))
			for i=1, mod.UConst.N_CRYSTALS do
				local point = entity.Position
				local velocity = mod:RandomVector(20,20)
				while room:IsPositionInRoom(point, 0) do
					point = point + velocity
				end
				point = point - velocity/2

				local iceFlag = false
				for i, crystal in ipairs(mod:FindByTypeMod(mod.Entity.IceCrystal)) do
					if crystal.Position:Distance(point) < 20 then
						iceFlag = true
						break
					end
				end

				if not iceFlag then
					local crystal = mod:SpawnEntity(mod.Entity.IceCrystal, point, Vector.Zero, entity)
					crystal:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				end

			end
		end

		mod.ShaderData.intensity = 5

	elseif sprite:IsFinished("Twerk") and data.HailCount < mod.UConst.N_BLIZZARDS then
		
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
		
		for i = 1,mod.UConst.N_HAILS do
			
			local position = room:GetRandomPosition(0)

			local hail = mod:SpawnEntity(mod.Entity.Hail, position, Vector.Zero, entity):ToProjectile()
			
			local randSize = mod:RandomInt(2,3)
			hail:GetSprite():Play("Rotate"..tostring(randSize))
			
			hail.FallingAccel = 2
			hail.ChangeTimeout = 3
			hail.Height = -mod:RandomInt(380,840)
			hail.Scale = mod:RandomInt(16,20)/20
			--hail.Color = mod.Colors.hailColor

			hail:Update()

			hail:GetData().iceSize = mod.UConst.HAIL_ICE_SIZE
			hail:GetData().hailTrace = false
			hail:GetData().hailSplash = false
			
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.OCCULT_TARGET, 0, position, Vector.Zero, entity):ToEffect()
			target.Color = mod.Colors.hail
			target.Timeout = 10
		end
	
		data.HailCount = data.HailCount + 1
		sprite:Play("Twerk", true)
		
	elseif sprite:IsFinished("Twerk") then
		mod.ShaderData.intensity = 1
		mod:UranusStateChange(entity, sprite, data)
		data.HailCount = 0
	end

	if data.StateFrame%10 == 0 then
		sfx:Play(SoundEffect.SOUND_CLAP,1);
	end
end
function mod:UranusPee(entity, data, sprite, target, room)
	--mod:FaceTarget(entity, target)
	if data.StateFrame == 1 then
		sprite:Play("PeeAss",true)
	elseif sprite:IsFinished("PeeAss") then
		mod:UranusStateChange(entity, sprite, data)
		
	elseif sprite:IsEventTriggered("Shot") then
		
		local peeParams = ProjectileParams()
		
		peeParams.Color = mod.Colors.pee
		sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 5)
		--sfx:Play(70,5)
		peeParams.Acceleration = 0.00001
		
		local pees = entity:FireBossProjectilesEx(mod.UConst.N_PEE, target.Position, -1, peeParams )
		for i, pee in ipairs(pees) do
			pee:GetData().peeHC = true
		end
		

	elseif sprite:WasEventTriggered("Pee") and not sprite:WasEventTriggered("Shot") then

		if mod.UConst.SUPER_PEE and entity.FrameCount%mod.UConst.PEE_PERIOD == 0 then
			sfx:Play(SoundEffect.SOUND_MEATHEADSHOOT, 5, 2, false, 3)
			
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector.Zero, entity):ToProjectile()
			if tear then
				tear:GetData().peeHC = true
				tear:GetSprite().Color = mod.Colors.pee

				local dest = target.Position + mod:RandomVector(30)
				mod:ArchProjectile(tear, dest, 30, 1)
			end
		end
	end
end
function mod:UranusSneeze(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		--sprite.FlipX = false
		sprite:Play("Switch",true)
	elseif sprite:IsFinished("Switch") then
		sprite:Play("Sneeze",true)
	elseif sprite:IsFinished("Sneeze") then
		sprite:Play("UnSwitch",true)
	elseif sprite:IsFinished("UnSwitch") then
		mod:UranusStateChange(entity, sprite, data)

		
	elseif sprite:IsEventTriggered("Shot") then
		sfx:Play(Isaac.GetSoundIdByName("Sneeze"), 3)

		game:ShakeScreen(15)
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player then
				local direction = (player.Position - entity.Position)/100 * mod.UConst.SNEEZE_KNOCKBACK
				--player:AddKnockback(EntityRef(entity), direction, 15, false)
				player.Velocity = player.Velocity + direction
			end
		end

		--projectiles
		local params = ProjectileParams()
		params.Variant = ProjectileVariant.PROJECTILE_TEAR
		--params.FallingAccelModifier = 1
		params.Color = Color.TearCommonCold
		params.BulletFlags = ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
		params.ChangeFlags = ProjectileFlags.TRACTOR_BEAM
		params.ChangeTimeout = 60

		local projectiles = entity:FireBossProjectilesEx (mod.UConst.N_BOOGERS, entity.Position, 0, params)

	elseif sprite:IsEventTriggered("Scream") then
		sfx:Play(SoundEffect.SOUND_PESTILENCE_MAGGOT_START, 0.25, 2, false, 1.5)
		--sfx:Play(SoundEffect.SOUND_PESTILENCE_COUGH, 1, 2, false, 1.5)
		sfx:Play(Isaac.GetSoundIdByName("PreSneeze"), 1)
	end
end
function mod:UranusSummon(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		if #Isaac.FindByType(mod.EntityInf[mod.Entity.Oberon].ID, mod.EntityInf[mod.Entity.Oberon].VAR) == 0 then
			sprite:Play("Sing",true)
			data.moonsIdles = 0
		else
			mod:UranusStateChange(entity, sprite, data)
		end
	elseif sprite:IsFinished("Sing") then
		sprite:Play("IdleAss",true)
	elseif sprite:IsFinished("IdleAss") then
		data.moonsIdles = data.moonsIdles + 1
		if data.moonsIdles >= mod.UConst.MOON_IDLES then
			mod:UranusStateChange(entity, sprite, data)
		else
			sprite:Play("IdleAss",true)
		end

		
	elseif sprite:IsEventTriggered("Fart") then
		sfx:Play(SoundEffect.SOUND_FART, 2, 2, false, 2)
		sfx:Play(SoundEffect.SOUND_POOP_LASER, 2, 2, false, 3)
		sfx:Play(SoundEffect.SOUND_FART_MEGA, 2, 2, false, 3)

		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, entity.Position, Vector.Zero, entity)
		fart.DepthOffset = 10
		fart:GetSprite().Color = Color.TearChocolate

	elseif sprite:IsEventTriggered("Dip") then
		local values = {0, 1, 2}
		values = mod:Shuffle(values)

		for i = 1, #values do
			local id = values[i]

			mod:scheduleForUpdate(function ()
				if entity then
					local position = target.Position + Vector.FromAngle(id*120)*mod.UConst.MOON_DISTANCE
					local moon = mod:SpawnEntity(mod.Entity.Oberon, position, Vector.Zero, entity, nil, mod.EntityInf[mod.Entity.Oberon].SUB + id)
					moon:GetData().Countdown = 60*(i)
				end
			end, (i-1)*15)
		end
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
		if data.SpinCount < mod.UConst.N_POOP_SPINS then
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

--State Change
function mod:UranusStateChange(entity, sprite, data)
	local ogState = data.State

	data.State = mod:MarkovTransition(data.State, mod.chainU)
	data.StateFrame = 0
end

--Move
function mod:UranusMove(entity, data, room, target)
	--mod:FaceTarget(entity, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room
	
	--idleTime == frames moving in the same direction
	if not data.idleTime then
		data.idleTime = mod:RandomInt(mod.UConst.IDLE_TIME_INTERVAL.X, mod.UConst.IDLE_TIME_INTERVAL.Y)
		--distance of Uranus from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > mod.UConst.CENTER_DISTANCE_TOLERATION then
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.UConst.SPEED
	data.targetvelocity = data.targetvelocity * 0.99
end

--ded
function mod:UranusPoopExplosion(entity)

	--Poops
	for i=1,15 do
		poop = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, mod:RandomInt(0,1), entity.Position + Vector(0.1,0):Rotated(rng:RandomFloat()*360), Vector((rng:RandomFloat() * 8) + 3.5,0):Rotated(rng:RandomFloat()*360), entity)
	end

	--Poop rain
	for i=1, 350 do
		local angle = 360*rng:RandomFloat()
		local position = entity.Position + Vector(math.sqrt(mod:RandomInt(0,(mod.NConst.RAIN_DROP_RADIUS/2)^2)),0):Rotated(angle)
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
	local position = entity.Position + Vector(math.sqrt(mod:RandomInt(0,(mod.NConst.RAIN_DROP_RADIUS/2)^2)),0):Rotated(angle)
	--Poop rain projectiles:
	local poopParams = ProjectileParams()
	poopParams.Scale = 2
	poopParams.FallingAccelModifier = 2
	poopParams.ChangeTimeout = 3
	poopParams.HeightModifier = -7000
	poopParams.Color = mod.Colors.poop
	
	entity:FireProjectiles(position, Vector.Zero, 0, poopParams)
	
end
function mod:UranusDeath(entity)
	
	if entity.Variant == mod.EntityInf[mod.Entity.Uranus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Uranus].SUB then

		mod:NormalDeath(entity)

		--Relaxed
		mod:scheduleForUpdate(function()
			sfx:Play(Isaac.GetSoundIdByName("UranusRelax"), 0.6)
		end, 25)

		--Poops
		if not mod.CriticalState then
			mod:UranusPoopExplosion(entity)
		end


		--Clean room
		
		for _, i in ipairs(Isaac.FindByType(EntityType.ENTITY_DIP)) do
			i:Die()
		end
		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.IceTurd)) do
			if i.Child then i.Child:Remove() end
			i:Remove()
			sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
			game:SpawnParticles(i.Position, EffectVariant.DIAMOND_PARTICLE, 50, 9)
		end
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.Turd)) do
			if i.Child then i.Child:Remove() end
			i:Remove()
			sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
			game:SpawnParticles(i.Position, EffectVariant.DIAMOND_PARTICLE, 50, 9)
		end
		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.IceCrystal)) do
			i:Die()
		end

		
		mod:DisableWeather(mod.WeatherFlags.BLIZZARD)
	end
end
--deding
function mod:UranusDying(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Uranus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Uranus].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if data.deathFrame == nil then data.deathFrame = 1 end

		if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
			data.deathFrame = data.deathFrame + 1
			if data.deathFrame == 1 then
				sprite.Rotation = 0
			elseif sprite:IsEventTriggered("Scream") then
				sfx:Play(Isaac.GetSoundIdByName("UranusScream"), 1)
			end
		end
	end
end

--Ice
function mod:SpawnIceCreep(position, size, tear)

	local maxIces = 25

	if mod.CriticalState then
		maxIces = 5
	end

	local ices = mod:FindByTypeMod(mod.Entity.IceCreep)
	if #ices <= maxIces then
		mod:SpawnIceCreepSingular(position, tear)
		
		for i=0, size-2 do
			local density = 3*i
			for j=1, density+1 do
				local extraPosition = position + Vector(i*20,0):Rotated(j*360/density)
				mod:SpawnIceCreepSingular(extraPosition, tear)
			end
		end
		
	end
end
function mod:SpawnIceCreepSingular(position, tear)
	if not mod:IsOutsideRoom(position, game:GetRoom()) then
		local ice = mod:SpawnEntity(mod.Entity.IceCreep, position, Vector.Zero, tear):ToEffect()
		ice:Update()
		ice:SetColor(Color.Default, -1, 99, true, true)

		ice:GetData().iceCount = 2
		ice.Timeout = mod.UConst.ICE_TIMEOUT
	end
end


--Callbacks
--Uranus updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UranusUpdate, mod.EntityInf[mod.Entity.Uranus].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.UranusDeath, mod.EntityInf[mod.Entity.Uranus].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.UranusDying, mod.EntityInf[mod.Entity.Uranus].ID)

--Pee updates
function mod:PeeProjectile(tear, collider, collided)
	local data = tear:GetData()
	
	--If tear collided then
	if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
		if data.target then
			data.target:Remove()
		end
		
		--Spawn pee
		local pee = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_YELLOW, 0, tear.Position, Vector.Zero, tear):ToEffect()
		pee.Timeout = mod.UConst.PEE_CREEP_TIME
		
		--Melt the ice
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.CREEP_SLIPPERY_BROWN then
			if  (entity.Position):Distance(tear.Position) < mod.UConst.PEE_MELT_RADIUS then
				entity:Die()
			end
			end
		end
		
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, tear)
	if tear:GetData().peeHC then
		mod:PeeProjectile(tear,false)
	end
end)

--OTHERS--------------------------
--Ice turd
function mod:IceTurdInit(entity)
	entity:GetData().Init = true
	
	entity.CollisionDamage = 0
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

	--Mom's knife cant damage FLAG_NO_TARGET entities (Which is something good, but I dont care), probably not the only item with that side effect
	if not mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
		entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end

	entity:GetSprite():Play("Appear",true)
end
function mod:IceTurdUpdate(entity)
	if (mod.EntityInf[mod.Entity.IceTurd].VAR == entity.Variant or mod.EntityInf[mod.Entity.Turd].VAR == entity.Variant) and (mod.EntityInf[mod.Entity.IceTurd].SUB == entity.SubType or mod.EntityInf[mod.Entity.Turd].SUB == entity.SubType ) then
		--Dont freeze the ice duh
		entity:ClearEntityFlags(EntityFlag.FLAG_ICE_FROZEN)
		entity:ClearEntityFlags(EntityFlag.FLAG_ICE)
		entity.Velocity = Vector.Zero

		local data = entity:GetData()
		if not data.Init then
			mod:IceTurdInit(entity)
		end

		if(entity:GetSprite():IsFinished("Appear")) then
			game:ShakeScreen(10);
			sfx:Play(Isaac.GetSoundIdByName("IceCrash"),1);
			mod:SpawnIceCreep(entity.Position, mod.UConst.TURD_ICE_SIZE, entity)
			mod:IceTurdFinishedAppear(entity)
		elseif entity:GetSprite():IsEventTriggered("Crack") then
			sfx:Play(Isaac.GetSoundIdByName("IceCrack"), 1, 2, false, 1)
		end

		if mod.EntityInf[mod.Entity.IceTurd].SUB == entity.SubType then
			mod:IceTurd1Update(entity)
		else
			mod:IceTurd2Update(entity)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.IceTurdUpdate, mod.EntityInf[mod.Entity.IceTurd].ID)
function mod:IceTurdFinishedAppear(entity)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

	--Crash damage
	for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.UConst.TURD_RADIUS)) do
		if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Uranus].ID then
			entity_:TakeDamage(mod.UConst.TURD_DAMAGE, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
		elseif entity_.Type == EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Uranus].ID then
			entity_:TakeDamage(1, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
		end
	end

	--Sprite
	local roomdesc = game:GetLevel():GetCurrentRoomDesc()
	entity:GetSprite():Play("Idle", true)
	if entity.SubType == mod.EntityInf[mod.Entity.IceTurd].SUB then
		entity:GetSprite():SetFrame(mod:RandomInt(0,40))
		entity:GetSprite().PlaybackSpeed = 0.2
	end
	if roomdesc and mod:IsGlassRoom(roomdesc) then
		local reflection = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 0, entity.Position, Vector.Zero, entity)
		local refSprite = reflection:GetSprite()
		refSprite:Load("hc/gfx/entity_IceTurdGlass.anm2", true)
		refSprite:LoadGraphics()
		refSprite:Play("Idle", true)
		entity.Child = reflection
		
		
		local fractures = mod:FindByTypeMod(mod.Entity.GlassFracture)
		if #fractures > 5 then
			fractures[1]:Remove()
		end
		local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
	end

end
function mod:IceTurdDeath(entity)
	if (mod.EntityInf[mod.Entity.IceTurd].VAR == entity.Variant or mod.EntityInf[mod.Entity.Turd].VAR == entity.Variant) and (mod.EntityInf[mod.Entity.IceTurd].SUB == entity.SubType or mod.EntityInf[mod.Entity.Turd].SUB == entity.SubType ) then
		sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
		game:SpawnParticles(entity.Position, EffectVariant.DIAMOND_PARTICLE, 50, 9)

		if mod.EntityInf[mod.Entity.IceTurd].VAR == entity.Variant and mod.EntityInf[mod.Entity.IceTurd].SUB == entity.SubType then
			for i=0, mod.UConst.N_TURD_ICICLES do
				local angle = i*360/mod.UConst.N_TURD_ICICLES
				--Ring projectiles:
				local hail = mod:SpawnEntity(mod.Entity.Icicle, entity.Position, Vector(1,0):Rotated(angle)*mod.UConst.TURD_ICICLE_SPEED, entity):ToProjectile()

				--hail:GetSprite().Color = Colors.hailColor
				hail:GetData().iceSize = mod.UConst.TURD_ICICLE_ICE_SIZE
				hail:GetData().hailTrace = false
				hail:GetData().hailSplash = false
				
			end
		end

		if entity.Child then entity.Child:Remove() end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.IceTurdDeath, mod.EntityInf[mod.Entity.IceTurd].ID)

function mod:IceTurd2Update(entity)
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()

	entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	if sprite:IsFinished("Idle") then
		sprite:Play("Attack", true)
	elseif sprite:IsFinished("Attack") then
		sprite:Play("Idle", true)
	elseif sprite:IsEventTriggered("Attack") then
		local direction = (target.Position - entity.Position):Normalized()

		local poop = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position + Vector(0,1), direction * 8, entity):ToProjectile()
		if poop then
			poop:GetSprite().Color = mod.Colors.poop
			poop.Height = -40
			poop.FallingAccel = 1
		end
	end
end

function mod:IceTurd1Update(entity)
	if entity:GetSprite():IsFinished("Idle") then
		entity:Die()
	end
end

--ICE Crystal
function  mod:IceCrystalUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.IceCrystal].SUB and entity.Variant == mod.EntityInf[mod.Entity.IceCrystal].VAR then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		--Dont freeze the ice duh
		entity:ClearEntityFlags(EntityFlag.FLAG_ICE_FROZEN)
		entity:ClearEntityFlags(EntityFlag.FLAG_ICE)

		if not data.Init then
			data.Init = true

			--remove?
			local crystals = mod:FindByTypeMod(mod.Entity.IceCrystal)
			for i, crystal in ipairs(crystals) do
				if crystal.DropSeed ~= entity.DropSeed and crystal.Position:Distance(entity.Position) < 20 then
					entity:Remove()
					return
				end
			end
			if (#crystals - 1) >= mod.UConst.MAX_CRYSTALS then
				entity:Remove()
				return
			end
					
			entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

			sprite:Play(tostring(mod:RandomInt(1,4)), true)
			if data.Instant then
				sprite:SetLastFrame()
			end

			local room = game:GetRoom()

			local position = entity.Position
			local x_p, y_p = position.X, position.Y

			local c1 = room:GetBottomRightPos()
			local c3 = room:GetTopLeftPos()

			local x_a, y_a = c1.X, c1.Y
			local x_b, y_b = c3.X, c3.Y
			
			local cross = (x_b - x_a) * (y_p - y_a) - (y_b - y_a) * (x_p - x_a)

			local c2 = Vector(c1.X, c3.Y)
			local c4 = Vector(c3.X, c1.Y)

			local xx_a, yy_a = c2.X, c2.Y
			local xx_b, yy_b = c4.X, c4.Y
			
			local cross2 = (xx_b - xx_a) * (y_p - yy_a) - (yy_b - yy_a) * (x_p - xx_a)

			if cross > 0 then
				if cross2 > 0 then
					sprite.Rotation = 180
				else
					sprite.Rotation = 270
				end
			else
				if cross2 > 0 then
					sprite.Rotation = 90
				else
					sprite.Rotation = 0
				end
			end
		end

		if sprite:IsFinished() then
			entity.CollisionDamage = 1
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		end

		entity.Velocity = Vector.Zero
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.IceCrystalUpdate, mod.EntityInf[mod.Entity.IceCrystal].ID)
function  mod:IceCrystalDeath(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.IceCrystal].SUB and entity.Variant == mod.EntityInf[mod.Entity.IceCrystal].VAR then
		sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1)
		
		game:SpawnParticles(entity.Position, EffectVariant.DIAMOND_PARTICLE, 10, 9)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.IceCrystalDeath, mod.EntityInf[mod.Entity.IceCrystal].ID)

--Snowflake
function mod:SpawnSnowflake(entity, room, speed, size)
	if true then return end
	if mod.savedatasettings().weather or mod.savedatasettings().weather == 1 then
		size = size or 1
		speed = speed or 1
		if rng:RandomFloat() < 0.6 then
			local position = room:GetRandomPosition(0)-Vector(room:GetCenterPos().X*3.1,0)
			position = position + position*(1-2*rng:RandomFloat())/2 + (speed-1)*Vector(speed*160,speed*85)
			local velocity = Vector(10*speed,rng:RandomFloat())
			local snowflake = mod:SpawnEntity(mod.Entity.Snowflake, position, velocity, entity)

			local sprite = snowflake:GetSprite()
			local randomAnim = tostring(mod:RandomInt(1,4))
			sprite:Play("Drop0"..randomAnim,true)

			sprite:Update()

			sprite.Scale = Vector.One*size
		end
	end
end
function mod:SnowflakeDisappear(effect)
    local sprite = effect:GetSprite()
	if effect.SubType == mod.EntityInf[mod.Entity.Snowflake].SUB then
		local finished = sprite:IsFinished("Drop01") or sprite:IsFinished("Drop02") or sprite:IsFinished("Drop03") or sprite:IsFinished("Drop04")
		if finished then
			effect:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SnowflakeDisappear, mod.EntityInf[mod.Entity.Snowflake].VAR)

--Hail
function mod:HailProjectileUpdate(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.Icicle].SUB or tear.SubType == mod.EntityInf[mod.Entity.BigIcicle].SUB or tear.SubType == mod.EntityInf[mod.Entity.Hail].SUB then
		local data = tear:GetData()
		local sprite = tear:GetSprite()
		if data.Init == nil then
			data.Init = true
			--Sprite
			if not (tear.Variant == mod.EntityInf[mod.Entity.Hail].VAR and tear.SubType == mod.EntityInf[mod.Entity.Hail].SUB) then
				sprite:Play("Idle", true)
				sprite.Rotation = tear.Velocity:GetAngleDegrees()
			end
		end
	
		--This leaves a trace of slippery ice
		if data.hailTrace and tear.FrameCount % 5 == 0 then
			--Spawn ice creep
			mod:SpawnIceCreep(tear.Position, mod.UConst.SHOT_TRACE_ICE_SIZE, tear)
		end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			
			
            if (not mod.CriticalState) then
				game:SpawnParticles(tear.Position, EffectVariant.DIAMOND_PARTICLE, 1, 9)
			end
			
			--Spawn ice creep
			mod:SpawnIceCreep(tear.Position, tear:GetData().iceSize, tear)
			
			--Splash of projectiles:
			if data.hailSplash then
				for i=0, mod.UConst.N_SHOT_ICICLES do
					local angle = i*360/mod.UConst.N_SHOT_ICICLES
					--Ring projectiles:
					local hail = mod:SpawnEntity(mod.Entity.Icicle, tear.Position, Vector(1,0):Rotated(angle)*mod.UConst.SHOT_ICICLE_SPEED, tear.Parent):ToProjectile()
	
					--hail:GetSprite().Color = mod.Colors.hailColor
					hail:GetData().iceSize = mod.UConst.SHOT_ICICLE_ICE_SIZE
					hail:GetData().hailTrace = false
					hail:GetData().hailSplash = false
					
				end

				--ice crystal
				if not data.iceCrystalFlag and mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
					data.iceCrystalFlag = true
					if not game:GetRoom():IsPositionInRoom(tear.Position, 10) then
						local crystal = mod:SpawnEntity(mod.Entity.IceCrystal, tear.Position, Vector.Zero, nil)
						crystal:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						crystal:GetData().Instant = true
					end
				end
				
				sfx:Play(Isaac.GetSoundIdByName("IceBreak"),1);
			else
				
				sfx:Play(Isaac.GetSoundIdByName("HailBreak"),1);
			end
			
			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.HailProjectileUpdate, mod.EntityInf[mod.Entity.Icicle].VAR)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.HailProjectileUpdate, mod.EntityInf[mod.Entity.Hail].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.HailProjectileUpdate, mod.EntityInf[mod.Entity.Icicle].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.HailProjectileUpdate, mod.EntityInf[mod.Entity.Hail].VAR)

--MOONS----------------------------------------
function mod:UranusMoonUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Oberon].VAR then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()

		if not data.Init then
			data.Init = true

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			data.Offset = Vector.FromAngle(entity.SubType*120)*mod.UConst.MOON_DISTANCE
			data.Countdown = data.Countdown or (60*(1+entity.SubType))

			data.Attacking = false
			data.Moving = false

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("Appear", true)
			
			sfx:Play(SoundEffect.SOUND_DERP, 1, 2, false, 1+(2-entity.SubType))
		end
		data.Offset = data.Offset:Rotated(mod.UConst.MOON_ROTATION_SPEED)
		data.Countdown = data.Countdown - 1

		if not data.Attacking and data.Countdown <= 0 then
			data.Attacking = true
			sprite:Play("Attack", true)
			
			local direction = (target.Position - entity.Position):Normalized()
			direction = direction*mod.UConst.MOON_SPEED
			entity.Velocity = direction
		end

		if data.Attacking then

		elseif data.Moving then
			local direction = ((target.Position + data.Offset) - entity.Position)*0.2
			entity.Velocity = mod:Lerp(entity.Velocity, direction, 0.05)
		end

		if sprite:IsFinished("Appear") then
			data.Moving = true

			sprite:Play("GoingUp", true)

		elseif sprite:IsFinished("GoingUp") then
			sprite:Play("IdleUp", true)
			
		elseif sprite:IsFinished("Attack") then
			sprite:Play("Out", true)
			
		elseif sprite:IsFinished("Out") then
			entity:Remove()
		end

		if sprite:IsEventTriggered("Fly") then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		elseif sprite:IsEventTriggered("Land") then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

			if sprite:IsPlaying("Attack") then
				mod:UranusMoonAttack(entity, entity.SubType, sprite, data, target)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UranusMoonUpdate, mod.EntityInf[mod.Entity.Oberon].ID)

function mod:UranusMoonAttack(entity, subType, sprite, data, target)
	entity.Velocity = Vector.Zero
	
	game:ShakeScreen(5)
	sfx:Play(SoundEffect.SOUND_MOTHER_LAND_SMASH, 1, 2, false, 1.5)
	sfx:Play(SoundEffect.SOUND_PLOP, 1)

	local fall_speed = 4
	if subType == Isaac.GetEntitySubTypeByName(" Oberon ") then
		mod:SpawnSplash(entity, 3, fall_speed, 8, Color.TearNumberOne)
	elseif subType == Isaac.GetEntitySubTypeByName(" Titania ") then
		mod:SpawnSplash(entity, 3, fall_speed, 8, Color.Default, ProjectileVariant.PROJECTILE_NORMAL)
		--mod:SpawnSplash(entity, 3, 2, 8, Color(1,0,0,1))
	elseif subType == Isaac.GetEntitySubTypeByName(" Umbriel ") then
		mod:SpawnSplash(entity, 3, fall_speed, 8, mod.Colors.poop2)
	end
	
	--Crash damage
	for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.UConst.MOON_SMASH_RADIUS)) do
		if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Uranus].ID then
			entity_:TakeDamage(mod.UConst.TURD_DAMAGE, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
		elseif entity_.Type == EntityType.ENTITY_PLAYER then
			entity_:TakeDamage(1, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
		end
	end
end