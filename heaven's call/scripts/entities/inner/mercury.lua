---@diagnostic disable: undefined-field
local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@&%###&&@&@@@@@&@@@@@@@@@@@&@@@@@@@@@
@@@@@@@&@@@@@@@@@@@@@@@@@#(((((((((((((((((((((((%@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@%(((///(##(((((((((((((((//////(((@&@@&@@@@@@@@@@@
@@@@@@@@@@@@@@@@@((((///*/(###(//(/((((((/(((((//////////%@@@@@@@@@@@@
@@@@@@@@@@@@@@%((///***//((#((**//////(/..(((((///*/////////@@@@@@@@@@
@@@@@@@@@@@@%(///********/(((***//////((((((//////****////////@@@@@@@@
@@@@@@@@@@@#(/#%*&&******////*****///(//((((%%%%%%%%%%%%*//////(@@@@&@
@@@@@@@@@%(//#%%%&&//*..*///**,**//(((((((%&&&&&&&%%&&%%%%#//////@@@@@
@@@@@@@@%(((/%%%&&&((/%&%/%%%#,///(((((((%%&&&%%%%%%%%&%%%%%(/////@@@@
@@@@@@@&(((//%%%&&%((&&&%(%&&&*%%((((((#(%%&&%%((((((/%%%%%%%//////@@@
@@@@@@@#((///(&%%%#(%&&&(((&%(*&&%((((((/%%&&%/(##/(&(/%%%%%%%/////%@@
@@@@@@@((((#//#&%%*/&&&((((&&&&&&&%#((((//%%%%%((#@&((#%%%%%%%//////@@
@@@@@@(((#&&///////(((((#&&&%&&&&&&#(((////%%%%%%%%%%%%%%%%%%///////@@
@@@@@@(((%&%//%#///(@%&@((&&&&&&&&&%((((////(%%%%%%%%%%%%%%%////////@@
@@@@@@%((%%#(#&%#(((#@@#(%&&&&&&&&&&((#%%(///*//%%%%%&%&%(//(///////@@
@@@@@@@((/&&&&&&&(/#&%%%&&&&&&&&&&&%(%&&&%#//////////////*((((/////@@@
@@@@@@@#((/&&&%&&%(#&&&&&&&&&&&&&&&##(%&&#(((/((/((((/////((#(////#@@@
@@@@@@@@((((&&&&&&(#%&&&&&&&%&&&&&&######((((((((((((////((((////(@@@@
@@@@@@@@#((/(&&&&&%##&&&&&&&%&&&&&%/(##%%&&&&%((((////%%%%((////&@@@@@
@@@@@@@%#(@&/(&&&&###(&&&&&%%%&&%%%//%%&&&%&&%((&&&&&&%%%%(////@@@@@@@
@@@@@@@(((@@@#/(((##(((%&&&&%%&&%%///&&%&&&&&&&&&&&&&&%%%(///@@@@@@@@@
@@@@@@(///@@&@@@/###(((((&&&&&%%%///*#&&%&&&&&&&&%%%&%%(///@@@@@@@@@@@
@@@@@@////&@@@@@@%####(((((((((////////&&%&&%%%%////////@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@##%@%(((((((((/////////(((////////@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@##@@@((@@@%(///////////////(@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@#(@@@((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/
@@@@@@@@@@@@@@@@@@((@@#((#@@@@@@&@@@@@@@@@@@@@@@@@@%@@@@@@@@///@@@/&@@
@@@@@@@@@@@@@@@@@((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/(///(@@/(@@@@@@((@
@@@@@@@@@@@@@@@@%((//@@@@@@@@&@@@@//@@@@@@@/////@@@@/%@@@@@/(@@@@@@@@@
@@@@@@@@@@@@@@@@@/***@@@@@@@%//(@(/(/@@@@#/#(//(%@@@&/&@@@@@//#(/#@@@@
]]--
  
mod.MRMSState = {
    APPEAR = 0,
    IDLE = 1,
    CIRCLE = 2,
    EGG = 3,
    SPINDASH = 4,
    DOUBLESPINDASH = 5,
    HORN = 6,
    SIDEJUMPS = 7,
    DRILL = 8,
    BIRDS = 9,
    SPINJUMPS = 10,
}
mod.chainMR = {--                        A     I      Circ    Egg   Spin   DSpin   Horn   Side   Drill  Brid
    [mod.MRMSState.APPEAR] = 	        {0,     1,     0,     0,     0,     0,      0,     0,     0,     0},
    [mod.MRMSState.IDLE] = 	            {0, 	0.709, 0.025, 0.02,	 0.058,	0.058,	0.04,  0.035, 0.04,	 0.015},
    --[mod.MRMSState.IDLE] = 	            {0,     0,     0,     0,     0,     0,      1,     0,     0,     1},
    --[mod.MRMSState.IDLE] = 	            {0,     1,     0,     0,     0,     0,      0,     0,     0,     0},
    --[mod.MRMSState.IDLE] = 	            {0,     0,     0,     0,     0.5,     0.5,      0,     0,     0,     1},
    [mod.MRMSState.CIRCLE] = 	        {0,	    0.7,   0,	  0,	 0.15,	0.15,	0,	   0,	  0,	 0},
    [mod.MRMSState.EGG] = 	            {0,	    0.64,  0.,    0.14,	 0.05,	0.05,	0.12,  0,	  0,	 0},
    [mod.MRMSState.SPINDASH] = 	        {0,	    0.4,   0,	  0,	 0.3,	0.3,    0,	   0,	  0,	 0},
    --[mod.MRMSState.SPINDASH] = 	            {0,     1,     0,     0,     0,     0,      0,     0,     0,     0},
    [mod.MRMSState.DOUBLESPINDASH] = 	{0,	    0.4,   0,	  0,	 0.3,	0.3,    0,	   0,	  0,	 0},
    --[mod.MRMSState.DOUBLESPINDASH] = 	            {0,     1,     0,     0,     0,     0,      0,     0,     0,     0},
    [mod.MRMSState.HORN] = 	            {0,	    0.7,   0,	  0,	 0.15,	0.15,	0,	   0,	  0,	 0},
    [mod.MRMSState.SIDEJUMPS] = 	    {0,	    0.7,   0,	  0,	 0,	    0,	    0,	   0,	  0.2,	 0.1},
    [mod.MRMSState.DRILL] = 	        {0,	    0.5,   0,	  0,	 0,	    0,	    0.4,   0,	  0,	 0.1},
    [mod.MRMSState.BIRDS] = 	        {0,	    1,	   0,	  0,	 0,	    0,	    0,	   0,	  0,	 0},
    [mod.MRMSState.SPINJUMPS] = 	    {0,	    1,	   0,	  0,	 0,	    0,	    0,	   0,	  0,	 0,     0}
    
}
mod.MRConst = {--Some constant variables of Mercury
    IDLE_TIME_INTERVAL = Vector(20,30),
    SPEED = 1.65,--1.7,

    --jumps
    N_JUMPS = 3,
    JUMP_SPEED = 45,
    N_JUMP_PROJS = 8,

    --drill
    N_DRILLS = 14,
    N_DRILL_PROJS = 13,
    DRILL_ROCK_SPEED = 12,
    DRILL_SHOT_SPEED = 9,
    N_NORMAL_DRILL_PROJS = 8,
    N_TRUE_DRILL_PROJS = 4,

    --spindash
    SPINDASH_SPEED = 75,
    MAX_BOUNCES = 3,
	ANGLE_LIST = {0, 45, 90, 135, 180, -45, -90, -135, -180},

    --birds
    N_BIRDS = 10,
    IDLE_BIRD_TIME_INTERVAL = Vector(10,20),
    BIRD_SHOT_SPEED = 10,
    BIRD_SPEED = 1.45,
    BIRD_FRAMES = 180,

    --line
    N_LINES = 4,
    LINE_SPEED = 70,
    N_LINE_SHOTS = 4,
    LIVE_SHOT_SPEED = 13,

    --circle
    N_CIRCLES = 10,
    CIRCLE_SPEED = 100,
    CIRCLING_DISTANCE = 650,
    ANGLE_SPEED = 20,
    CIRCLE_SHOT_SPEED = 8,
    CIRCLE_PERIOD = 12,

    --horn
    BISMUTH_SPEED = 3,
    N_HORN_DIVISIONS = 10,
    N_BISMUTH_DIVISIONS = 3,
    BISMUTH_DIVISION_SPEED = 1,

    --train
    TRAIN_SPEED = 70,
    HP_TRAIN = 0.15,

    --spin jump
    SPIN_JUMP_COUNT = 10,
    N_SPIN_PROJECTILES = 10,
    SPIN_PROJECTILE_SPEED = 3,

    --eggs
    EGG_SPEED = 15,
    N_EGG_FEATHERS = 3,
    EGG_FEATHER_ANGLE = 30,
    EGG_FEATHER_SPEED = 10,

}
function mod:SetMercuryDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
        --                                 A    I      Circ   Egg   Spin   DSpin   Horn   Side   Drill  Brid    bounces
        mod.chainMR[mod.MRMSState.IDLE] = {0, 	0.709, 0.025, 0.0,	 0.058,	0.058,	0.04,  0.035, 0.04,	 0.015,  0}

        mod.MRConst.SPEED = 1.65

        --jumps
        mod.MRConst.N_JUMPS = 3
        mod.MRConst.N_JUMP_PROJS = 8

        --drill
        mod.MRConst.N_DRILLS = 14
        mod.MRConst.N_DRILL_PROJS = 12
        mod.MRConst.DRILL_ROCK_SPEED = 8
        mod.MRConst.DRILL_SHOT_SPEED = 9
        mod.MRConst.N_NORMAL_DRILL_PROJS = 8
        mod.MRConst.N_TRUE_DRILL_PROJS = 4

        --spindash
        mod.MRConst.SPINDASH_SPEED = 75
        mod.MRConst.MAX_BOUNCES = 3

        --birds
        mod.MRConst.N_BIRDS = 10
        mod.MRConst.BIRD_SHOT_SPEED = 10
        mod.MRConst.BIRD_FRAMES = 180

        --line
        mod.MRConst.N_LINES = 4
        mod.MRConst.N_LINE_SHOTS = 4
        mod.MRConst.LINE_SHOT_SPEED = 13

        --circle
        mod.MRConst.N_CIRCLES = 10
        mod.MRConst.CIRCLING_DISTANCE = 650
        mod.MRConst.CIRCLE_SHOT_SPEED = 8
        mod.MRConst.CIRCLE_PERIOD = 7

        --horn
        mod.MRConst.BISMUTH_SPEED = 3
        mod.MRConst.N_HORN_DIVISIONS = 10
        mod.MRConst.N_BISMUTH_DIVISIONS = 3
        mod.MRConst.BISMUTH_DIVISION_SPEED = 1

        --eggs
        mod.MRConst.EGG_SPEED = 18
        mod.MRConst.N_EGG_FEATHERS = 3
        mod.MRConst.EGG_FEATHER_ANGLE = 30
        mod.MRConst.EGG_FEATHER_SPEED = 10

    elseif difficulty == mod.Difficulties.ATTUNED then
        --                                 A    I      Circ   egg   Spin   DSpin   Horn   Side   Drill  Brid    bounces
        mod.chainMR[mod.MRMSState.IDLE] = {0, 	0.707, 0.023, 0.008, 0.054,	0.054,	0.035,  0.035, 0.04, 0.0175, 0.0175}

        mod.MRConst.SPEED = 1.7

        --jumps
        mod.MRConst.N_JUMPS = 4
        mod.MRConst.N_JUMP_PROJS = 10
        
        --drill
        mod.MRConst.N_DRILLS = 17
        mod.MRConst.N_DRILL_PROJS = 14
        mod.MRConst.DRILL_ROCK_SPEED = 10
        mod.MRConst.DRILL_SHOT_SPEED = 10
        mod.MRConst.N_NORMAL_DRILL_PROJS = 9
        mod.MRConst.N_TRUE_DRILL_PROJS = 5
        
        --spindash
        mod.MRConst.SPINDASH_SPEED = 85
        mod.MRConst.MAX_BOUNCES = 4
        
        --birds
        mod.MRConst.N_BIRDS = 13
        mod.MRConst.BIRD_SHOT_SPEED = 12
        mod.MRConst.BIRD_FRAMES = 200
        
        --line
        mod.MRConst.N_LINES = 5
        mod.MRConst.N_LINE_SHOTS = 5
        mod.MRConst.LINE_SHOT_SPEED = 14
        
        --circle
        mod.MRConst.N_CIRCLES = 13
        mod.MRConst.CIRCLING_DISTANCE = 600
        mod.MRConst.CIRCLE_SHOT_SPEED = 8
        mod.MRConst.CIRCLE_PERIOD = 6
        
        --horn
        mod.MRConst.BISMUTH_SPEED = 4
        mod.MRConst.N_HORN_DIVISIONS = 12
        mod.MRConst.N_BISMUTH_DIVISIONS = 4
        mod.MRConst.BISMUTH_DIVISION_SPEED = 1.5

        --eggs
        mod.MRConst.EGG_SPEED = 18
        mod.MRConst.N_EGG_FEATHERS = 3
        mod.MRConst.EGG_FEATHER_ANGLE = 30
        mod.MRConst.EGG_FEATHER_SPEED = 15
        
    elseif difficulty == mod.Difficulties.ASCENDED then
        --                                 A    I      Circ   egg   Spin   DSpin   Horn   Side   Drill  Brid    bounces
        mod.chainMR[mod.MRMSState.IDLE] = {0, 	0.707, 0.023, 0.017, 0.054,	0.054,	0.035,  0.035, 0.04, 0.0175, 0.0175}

        mod.MRConst.SPEED = 1.75

        --jumps
        mod.MRConst.N_JUMPS = 5
        mod.MRConst.N_JUMP_PROJS = 12

        --drill
        mod.MRConst.N_DRILLS = 20
        mod.MRConst.N_DRILL_PROJS = 16
        mod.MRConst.DRILL_ROCK_SPEED = 12
        mod.MRConst.DRILL_SHOT_SPEED = 11
        mod.MRConst.N_NORMAL_DRILL_PROJS = 10
        mod.MRConst.N_TRUE_DRILL_PROJS = 8

        --spindash
        mod.MRConst.SPINDASH_SPEED = 90
        mod.MRConst.MAX_BOUNCES = 5
        mod.MRConst.N_BIRDS = 16
        mod.MRConst.BIRD_SHOT_SPEED = 14
        mod.MRConst.BIRD_FRAMES = 230

        --line
        mod.MRConst.N_LINES = 6
        mod.MRConst.N_LINE_SHOTS = 6
        mod.MRConst.LINE_SHOT_SPEED = 15

        --circle
        mod.MRConst.N_CIRCLES = 16
        mod.MRConst.CIRCLING_DISTANCE = 600
        mod.MRConst.CIRCLE_SHOT_SPEED = 8
        mod.MRConst.CIRCLE_PERIOD = 5

        --horn
        mod.MRConst.BISMUTH_SPEED = 5
        mod.MRConst.N_HORN_DIVISIONS = 14
        mod.MRConst.N_BISMUTH_DIVISIONS = 5
        mod.MRConst.BISMUTH_DIVISION_SPEED = 2
        
        --eggs
        mod.MRConst.EGG_SPEED = 18
        mod.MRConst.N_EGG_FEATHERS = 5
        mod.MRConst.EGG_FEATHER_ANGLE = 30
        mod.MRConst.EGG_FEATHER_SPEED = 15
    end
    mod.chainMR = mod:NormalizeTable(mod.chainMR)
end
mod.chainMR = mod:NormalizeTable(mod.chainMR)
--mod:scheduleForUpdate(function () mod:SetMercuryDifficulty(mod.Difficulties.ASCENDED) end,1)

function mod:MercuryUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Mercury].VAR and entity.SubType == mod.EntityInf[mod.Entity.Mercury].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()
        
        --Custom data:
        if data.State == nil then 
            data.State = 0 
            data.StateFrame = 0
            data.CrashDelay = 0

            data.JumpCount = 0
            data.DrillCount = 0
            data.TargetPos = target.Position
            data.TargetVel = target.Velocity
            data.IsSpindashing = false
            data.BounceCount = 0
            data.IsLining = false
            data.LineCount = 0
            data.IsCircling = false
            data.CircleCount = 0
            data.IsExploded = false
            data.Regen = false
            data.SpinJumpCount = 0
            
            data.TrainFlag = false
            data.TrainReady = false
            data.TrainDirection = -1

            entity.SplatColor = mod.Colors.mercury
            
			mod:CheckEternalBoss(entity)
        end
        
        --Frame
        data.StateFrame = data.StateFrame + 1
        data.CrashDelay = data.CrashDelay - 1
        
        if not data.TrainFlag and entity.HitPoints < entity.MaxHitPoints * mod.MRConst.HP_TRAIN and data.State ~= mod.MRMSState.BIRDS then
            music:ResetPitch()
            data.TrainFlag = true
            data.StateFrame = 0

            sprite.Rotation = 0
        end

        if data.TrainFlag then
            mod:MercuryTrain(entity, data, sprite, target,room)
        else
            if data.State == mod.MRMSState.APPEAR then
                if data.StateFrame == 1 then
                    mod:AppearPlanet(entity)
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                    data.State = mod:MarkovTransition(data.State, mod.chainMR)
                    data.StateFrame = 0
                elseif sprite:IsEventTriggered("EndAppear") then
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
                
            elseif data.State == mod.MRMSState.IDLE then
                if data.StateFrame == 1 then
                    sprite:Play("Idle",true)
                elseif sprite:IsFinished("Idle") or sprite:IsFinished("CrashR") or sprite:IsFinished("CrashL") then
                    data.State = mod:MarkovTransition(data.State, mod.chainMR)
                    --data.State = mod.MRMSState.CIRCLE
                    data.StateFrame = 0
                    
                elseif sprite:IsPlaying("Idle") then
                    mod:MercuryMove(entity, data, room, target)
                end
                
                if entity:CollidesWithGrid() and entity.Velocity:Length() > 17 then
                    if data.CrashDelay < 0 then
                        if entity.Velocity.X > 0 then
                            sprite:Play("CrashR", true)
                        else
                            sprite:Play("CrashL", true)
                        end
                        data.CrashDelay = 60
    
                        entity.Velocity = Vector.Zero
                        sfx:Play(Isaac.GetSoundIdByName("mercury_ouch"), 3)
                    end
                end
                
            elseif data.State == mod.MRMSState.CIRCLE then
                mod:MercuryCircle(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.EGG then
                mod:MercuryEggs(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.SPINDASH then
                mod:MercurySpindash(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.DOUBLESPINDASH then
                mod:MercuryDoubleSpindash(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.HORN then
                mod:MercuryHorn(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.SIDEJUMPS then
                mod:MercurySideJumps(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.DRILL then
                mod:MercuryDrill(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.BIRDS then
                mod:MercuryBirds(entity, data, sprite, target,room)
            elseif data.State == mod.MRMSState.SPINJUMPS then
                mod:MercuryBounce(entity, data, sprite, target,room)
            end
        
            local xvel = entity.Velocity.X / 30
            sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)
        end

        mod:MercuryColor(entity, sprite, room)

    end
end
function mod:MercuryCircle(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Rainbow",true)
		sfx:Play(SoundEffect.SOUND_POWERUP1)
		sfx:Play(Isaac.GetSoundIdByName("mercury_happy"))
    elseif sprite:IsFinished("Rainbow") then
        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        data.IsCircling = true
        music:PitchSlide(3.5)
        sprite:Play("Circle",true)
    elseif sprite:IsFinished("Circle") then
        if data.CircleCount >= mod.MRConst.N_CIRCLES then
            entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            data.IsCircling = false
			sprite:Play("RainbowEnd", true)

            mod:KillEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0))
        else
            data.CircleCount = data.CircleCount + 1
            sprite:Play("Circle",true)
		end
		
    elseif sprite:IsFinished("RainbowEnd") then
            data.MercuryTargetVector = nil
            data.CircleCount = 0
            music:ResetPitch()
			
            data.State = mod:MarkovTransition(data.State, mod.chainMR)
            data.StateFrame = 0
			
    elseif sprite:IsPlaying("Circle") and data.StateFrame % mod.MRConst.CIRCLE_PERIOD == 0 then

            local direction = (target.Position - entity.Position):Normalized()

            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction*mod.MRConst.CIRCLE_SHOT_SPEED, entity):ToProjectile()
            tear:GetSprite().Color = mod.Colors.mercury
            tear.Height = -30

            if data.StateFrame < 60 then
                tear.CollisionDamage = 0
                tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            end
    end

    local player = Isaac.GetPlayer(0)
    if data.IsCircling then

        if data.MercuryTargetVector == nil then
            data.MercuryTargetVector = (entity.Position - player.Position):Normalized() * mod.MRConst.CIRCLING_DISTANCE
            data.MercuryTargetAngle = 0
        end
        
        data.MercuryTarget = player.Position + data.MercuryTargetVector:Rotated(data.MercuryTargetAngle)
        data.MercuryTargetAngle = (data.MercuryTargetAngle + mod.MRConst.ANGLE_SPEED)%360


        data.targetvelocity = ((data.MercuryTarget - entity.Position):Normalized()):Rotated(mod:RandomInt(-10, 10))

		--Do the actual movement
		entity.Velocity = data.targetvelocity * mod.MRConst.CIRCLE_SPEED
        
        if data.StateFrame % 2 == 0 then
            local trace = mod:SpawnEntity(mod.Entity.MercuryTrace, entity.Position, entity.Velocity/8, entity)
            trace:GetSprite().PlaybackSpeed = 5
        end

    end
end
function mod:MercuryLines(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Rainbow",true)
		sfx:Play(SoundEffect.SOUND_POWERUP1)
		sfx:Play(Isaac.GetSoundIdByName("mercury_happy"))
    elseif sprite:IsFinished("Rainbow") then
        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS_X
        data.IsLining = true
        music:PitchSlide(3.5)
        sprite:Play("Lines",true)
    elseif sprite:IsFinished("Lines") then
        if data.LineCount >= mod.MRConst.N_LINES then
            entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            data.IsLining = false
			
			sprite:Play("RainbowEnd", true)
        else
            data.LineCount = data.LineCount + 1
            sprite:Play("Lines",true)


            for i=0, mod.MRConst.N_LINE_SHOTS-1 do
                mod:scheduleForUpdate(function()
                    local direction = (target.Position - entity.Position):Normalized()
                    local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction*mod.MRConst.LIVE_SHOT_SPEED, entity):ToProjectile()
                    tear:GetSprite().Color = mod.Colors.mercury
                end,i*5)
            end
        end
	
	elseif sprite:IsFinished("RainbowEnd") then
            data.LineCount = 0
            music:ResetPitch()

            data.State = mod:MarkovTransition(data.State, mod.chainMR)
            data.StateFrame = 0

    end

    if data.IsLining then

        entity.Velocity = Vector(0, -mod.MRConst.LINE_SPEED)

        if entity.Position.Y < room:GetCenterPos().Y and mod:IsOutsideRoom(entity.Position + Vector(0,100), room) then
            if room:GetRoomShape() >= RoomShape.ROOMSHAPE_2x2 or room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2 or room:GetRoomShape() == RoomShape.ROOMSHAPE_IIV then
                entity.Position = Vector(entity.Position.X, 696+ 300)
            else
                entity.Position = Vector(entity.Position.X, 417 + 300)
            end
        end

        if data.StateFrame % 2 == 0 then
            local trace = mod:SpawnEntity(mod.Entity.MercuryTrace, entity.Position, entity.Velocity/8, entity)
            trace:GetSprite().PlaybackSpeed = 5
        end
    end

end
function mod:MercurySpindash(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Spindash",true)
    elseif sprite:IsFinished("Spindash") or data.BounceCount >= mod.MRConst.MAX_BOUNCES then
        data.IsSpindashing = false
        data.BounceCount = 0
        entity.CollisionDamage = 0
        data.State = mod:MarkovTransition(data.State, mod.chainMR)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("StartSpin") then
        entity.Velocity = Vector.Zero
        sfx:Play(mod.SFX.Spindash, 1)
        data.TargetPos = target.Position
		mod:MercurySpindashAngle(entity, data, target.Position)

    elseif sprite:IsEventTriggered("ReleaseSpin") then
        sfx:Play(Isaac.GetSoundIdByName("SpindashRelease"),1)
        data.IsSpindashing = true
        entity.CollisionDamage = 1

        local direction = (data.TargetPos - entity.Position):Normalized()
        entity.Velocity = direction * mod.MRConst.SPINDASH_SPEED

        local sonicBoom = mod:SpawnEntity(mod.Entity.SonicBoom, entity.Position + Vector(0,-40), Vector.Zero, entity):ToEffect()
        sonicBoom:FollowParent(entity)
        sonicBoom:GetSprite().Rotation = direction:GetAngleDegrees() - 180
        sonicBoom.DepthOffset = 60

    elseif sprite:IsEventTriggered("Spin") then
        mod:MercurySplash(entity, 2, 2, (-data.TargetPos + entity.Position):GetAngleDegrees())
    end

    if data.IsSpindashing and entity:CollidesWithGrid() then
        entity.CollisionDamage = 0
        data.BounceCount = data.BounceCount + 1
        entity.Velocity = entity.Velocity:Normalized() * (mod.MRConst.SPINDASH_SPEED) * (mod.MRConst.MAX_BOUNCES - data.BounceCount) / mod.MRConst.MAX_BOUNCES
		mod:MercurySpindashAngle(entity, data, entity.Velocity + entity.Position)
    end

end
function mod:MercuryDoubleSpindash(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Spindash",true)
    elseif sprite:IsFinished("Spindash2") or sprite:IsFinished("CrashR") or sprite:IsFinished("CrashL") then
        data.IsSpindashing = false
        entity.CollisionDamage = 0
        data.State = mod:MarkovTransition(data.State, mod.chainMR)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("StartSpin") then
        entity.Velocity = Vector.Zero
        sfx:Play(Isaac.GetSoundIdByName("Spindash"),1)
        data.TargetPos = target.Position
		mod:MercurySpindashAngle(entity, data, target.Position)

        
        --local laser = EntityLaser.ShootAngle(2,entity.Position , (target.Position - entity.Position):GetAngleDegrees(), 120, Vector.Zero, entity)

    elseif sprite:IsEventTriggered("ReleaseSpin") and sprite:GetAnimation() == "Spindash" then
        sprite:Play("Spindash2",true)
        entity.Velocity = Vector.Zero
        sfx:Play(Isaac.GetSoundIdByName("Spindash"),1)
        data.TargetPos2 = target.Position

        local a = data.TargetPos - entity.Position
        local b = data.TargetPos2 - entity.Position

        local cross = a:Cross(b)
        local extraAngle = math.asin( math.abs(cross) / (a:Length() * b:Length()) )
        extraAngle = extraAngle * 180 / math.pi
        if cross < 0 then extraAngle = - extraAngle end
        data.ExtraAngle = extraAngle
        
        --local laser = EntityLaser.ShootAngle(2,entity.Position , (target.Position - entity.Position):GetAngleDegrees(), 120, Vector.Zero, entity)
		mod:MercurySpindashAngle(entity, data, (data.TargetPos2 - entity.Position):Normalized():Rotated(data.ExtraAngle) + entity.Position)

    elseif sprite:IsEventTriggered("ReleaseSpin") and sprite:GetAnimation() == "Spindash2" then
        data.IsSpindashing = true
        sfx:Play(Isaac.GetSoundIdByName("SpindashRelease"),1)
        entity.CollisionDamage = 1


        local direction = (data.TargetPos2 - entity.Position):Normalized():Rotated(data.ExtraAngle)

        --local laser = EntityLaser.ShootAngle(2,entity.Position , direction:GetAngleDegrees(), 120, Vector.Zero, entity)

        entity.Velocity = direction * mod.MRConst.SPINDASH_SPEED

        local sonicBoom = mod:SpawnEntity(mod.Entity.SonicBoom, entity.Position + Vector(0,-40), Vector.Zero, entity):ToEffect()
        sonicBoom:FollowParent(entity)
        sonicBoom:GetSprite().Rotation = direction:GetAngleDegrees() - 180
        sonicBoom.DepthOffset = 60

    elseif sprite:IsEventTriggered("Spin") and sprite:GetAnimation() == "Spindash" then
        mod:MercurySplash(entity, 2, 2, (-data.TargetPos + entity.Position):GetAngleDegrees())
    elseif sprite:IsEventTriggered("Spin") and sprite:GetAnimation() == "Spindash2" then
        mod:MercurySplash(entity, 2, 2, (- (data.TargetPos2 - entity.Position):Rotated(data.ExtraAngle)):GetAngleDegrees())

    end

    if data.IsSpindashing and entity:CollidesWithGrid() then
        if data.CrashDelay < 0 then
            if entity.Velocity.X > 0 then
                sprite:Play("CrashR", true)
            else
                sprite:Play("CrashL", true)
            end
            data.CrashDelay = 60

            mod:MercurySplash(entity, 4, 0.8)
            entity.Velocity = Vector.Zero
            game:ShakeScreen(20)
            
		    sfx:Play(Isaac.GetSoundIdByName("mercury_ouch"), 2.5)
        end
    end

end
function mod:MercuryHorn(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Horn",true)
		--sfx:Play(Isaac.GetSoundIdByName("mercury_laught"))
    elseif sprite:IsFinished("Horn") then
        data.State = mod:MarkovTransition(data.State, mod.chainMR)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Shot") then
        local horn = mod:SpawnEntity(mod.Entity.Horn, target.Position, Vector.Zero, entity)
        horn.Parent = entity

    elseif sprite:IsEventTriggered("Sound") then
		sfx:Play(SoundEffect.SOUND_BULLET_SHOT,1.5)
    end

end
function mod:MercurySideJumps(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        data.JumpCount = data.JumpCount + 1
        sprite:Play("Jumps",true)
		--sfx:Play(Isaac.GetSoundIdByName("mercury_super_happy"))
    elseif sprite:IsFinished("Jumps") then
        data.StateFrame = 0
        if data.JumpCount > mod.MRConst.N_JUMPS then
            data.JumpCount = 0
            data.State = mod:MarkovTransition(data.State, mod.chainMR)
        end
    
    elseif sprite:IsEventTriggered("StartInvulnerable") then
        local direction = (target.Position - entity.Position):Normalized()
        entity.Velocity = direction * mod.MRConst.JUMP_SPEED
        sfx:Play(Isaac.GetSoundIdByName("Spring"),0.5, 2,false, 1 + 0.5*rng:RandomFloat())
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        
    elseif sprite:IsEventTriggered("EndInvulnerable") then
        entity.Velocity = Vector.Zero
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        if data.JumpCount > 1 then
            game:ShakeScreen(10)
            mod:MercurySplash(entity, 2, 0.75)
        end
    end

end
function mod:MercuryDrill(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        sprite:Play("DrillStart",true)
		sfx:Play(Isaac.GetSoundIdByName("mercury_laught"))
    elseif sprite:IsFinished("DrillStart") then
        sprite:Play("Drill",true)

        local isGlassRoom = mod:IsGlassRoom(game:GetLevel():GetCurrentRoomDesc())
        if isGlassRoom then
            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
        end

        sfx:Play(Isaac.GetSoundIdByName("Drill"), 3, 2, false, 1)

        for i = 1, mod.MRConst.N_DRILL_PROJS do
            mod:scheduleForUpdate(function()
                if entity:Exists() then
                    local offset = i*180/mod.MRConst.N_DRILL_PROJS
                    for j = 1, mod.MRConst.N_TRUE_DRILL_PROJS do
                        local angle = j*360/mod.MRConst.N_TRUE_DRILL_PROJS + offset
                        local tear
                        if isGlassRoom then
                            tear = mod:SpawnEntity(mod.Entity.GlassShard, entity.Position, Vector.FromAngle(angle)*mod.MRConst.DRILL_ROCK_SPEED, entity):ToProjectile()
                        else
                            tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, Vector.FromAngle(angle)*mod.MRConst.DRILL_ROCK_SPEED, entity):ToProjectile()
                        end

                    end
                end
            end, i*6)

        end

    elseif sprite:IsFinished("Drill") then
        if data.DrillCount < mod.MRConst.N_DRILLS then
            sprite:Play("Drill",true)
            data.DrillCount = data.DrillCount + 1
        else
            sprite:Play("DrillEnd",true)
        end

        if data.DrillCount % 3 == 0 then
            for i = 1, mod.MRConst.N_NORMAL_DRILL_PROJS do
                local angle = i*360/mod.MRConst.N_NORMAL_DRILL_PROJS
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector.FromAngle(angle)*mod.MRConst.DRILL_SHOT_SPEED, entity):ToProjectile()
                tear:GetSprite().Color = mod.Colors.mercury

            end
        end
    elseif sprite:IsFinished("DrillEnd") then
        data.DrillCount = 0
        data.State = mod:MarkovTransition(data.State, mod.chainMR)
        data.StateFrame = 0


    end

end
function mod:MercuryBirds(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Bird",true)
    elseif sprite:IsFinished("Bird") then

        entity.Visible = true
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        data.IsExploded = false
        data.Regen = false

        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.MercuryBird)) do
            e:Remove()
        end

        data.State = mod:MarkovTransition(data.State, mod.chainMR)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Explosion") then
        
        sfx:Play(Isaac.GetSoundIdByName("Birds"), 6, 2, false, 1)

        data.IsExploded = true
        data.StateFrame = 2
        entity.Visible = false
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        --Tear explosion
        local bouncer = Isaac.Spawn(EntityType.ENTITY_BOUNCER, 0, 0, entity.Position, Vector.Zero, entity):ToNPC()
        bouncer.SplatColor = mod.Colors.mercury
        bouncer.SpriteScale = Vector.Zero
        bouncer.Visible = false
        bouncer.State = 16
        bouncer:GetSprite().Color = mod.Colors.mercury
        bouncer:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        bouncer:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)
        bouncer:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS)
        bouncer:Die()
        
		mod:scheduleForUpdate(function()
            for _, t in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL)) do
                t:GetSprite().Color = mod.Colors.mercury
            end
		end, 3)

		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.mercury)
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		bloody:GetSprite().Color = mod.Colors.mercury

        for i=1, mod.MRConst.N_BIRDS do
            local velocity = Vector(0.25 + 0.5*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())
            local bird = mod:SpawnEntity(mod.Entity.MercuryBird, entity.Position+3*velocity, velocity, entity)
            bird.Parent = entity
            bird:GetSprite():Play("Flying")
        end

    elseif sprite:IsEventTriggered("Regen") then
        entity.Velocity = Vector.Zero
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        entity.Visible = true
        data.Regen = true

        for _, t in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL)) do
            t:Die()
        end

    end

    if data.IsExploded then
        sprite:SetFrame(41)
        mod:MercuryMove(entity, data, room, target)

        if data.StateFrame > mod.MRConst.BIRD_FRAMES then
            data.IsExploded = false
        end
    end
    if data.Regen then
        entity.Velocity = Vector.Zero
    end

end
function mod:MercuryTrain(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("MorphingTime",true)
    elseif sprite:IsFinished("MorphingTime") then
        entity.Position = Vector(-100, target.Position.Y)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        entity.CollisionDamage = 1
        data.TrainReady = true
        
		sprite:Load("hc/gfx/entity_TankEngine.anm2", true)
		sprite:LoadGraphics()
		sprite:Play("Train", true)

        
        sfx:Play(Isaac.GetSoundIdByName("TrainStart"), 1, 2, false, 1)

    elseif sprite:IsEventTriggered("Jump") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        entity.Velocity = Vector(mod.MRConst.JUMP_SPEED*2, 0)

        sfx:Play(Isaac.GetSoundIdByName("Spring"),1, 2,false, 1 + 0.5*rng:RandomFloat())
    elseif sprite:IsFinished("Train") then
        
		sprite:Play("Train", true)

    end

    if data.TrainDirection == 1 then
        if (room:GetRoomShape() >= RoomShape.ROOMSHAPE_2x1 and entity.Position.X > 1900) or (room:GetRoomShape() < RoomShape.ROOMSHAPE_2x1 and entity.Position.X > 1500) then
            
            sfx:Play(Isaac.GetSoundIdByName("Train"), 6, 2, false, 1.2)

            data.TrainDirection = - data.TrainDirection
            sprite.FlipX = true
            entity.Position = Vector(entity.Position.X, target.Position.Y)

            entity.HitPoints = entity.HitPoints - 5
        end
    else
        if entity.Position.X < -641 then

            sfx:Play(Isaac.GetSoundIdByName("Train"), 6, 2, false, 1.2)

            data.TrainDirection = - data.TrainDirection
            sprite.FlipX = false
            entity.Position = Vector(entity.Position.X, target.Position.Y)

            entity.HitPoints = entity.HitPoints - 5
        end
    end

    if data.TrainReady then
        entity.Velocity = Vector(mod.MRConst.TRAIN_SPEED * data.TrainDirection, 0)

        mod:MercurySplash(entity, 2, 2, (-entity.Velocity):GetAngleDegrees())
        
        local posOffset = Vector(80,-120)
        if sprite.FlipX then
            posOffset = Vector(-posOffset.X, posOffset.Y)
        end

		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, entity.Position + posOffset, Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Scale = 0.8*Vector(1,1)
		cloud:GetSprite().Color = Color(10,10,10,1)

        game:ShakeScreen(10)
    end

end
function mod:MercuryBounce(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        sprite:Play("AngryJump",true)
		sfx:Play(Isaac.GetSoundIdByName("mercury_uff"))
        if data.CurrentAim then
            local pos = entity.Position - (data.CurrentAim-entity.Position)
            mod:MercurySpindashAngle(entity, data, pos)
        end
    elseif sprite:IsFinished("AngryJump") then
        sprite:Play("Spinjump",true)


    elseif sprite:IsFinished("Spinjump") then
        if data.SpinJumpCount < mod.MRConst.SPIN_JUMP_COUNT then

            if data.CurrentAim then
                local pos = entity.Position - (data.CurrentAim-entity.Position)
                mod:MercurySpindashAngle(entity, data, pos)
            end
            sprite:Play("Spinjump",true)
            data.SpinJumpCount = data.SpinJumpCount + 1
        else
            data.CurrentAim = nil
            data.SpinJumpCount = 0
            data.State = mod:MarkovTransition(data.State, mod.chainMR)
            data.StateFrame = 0
        end

    elseif sprite:IsEventTriggered("StartInvulnerable") then
        sfx:Play(Isaac.GetSoundIdByName("Spring"),1, 2,false, 1 + 0.5*rng:RandomFloat())
        entity.Velocity = Vector.Zero
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        if data.SpinJumpCount < mod.MRConst.SPIN_JUMP_COUNT then
            local position = target.Position + target.Velocity*30
            local c = 0
            while mod:IsOutsideRoom(position, room) do
                c = c+1
                position = target.Position + (target.Velocity*30):Rotated(mod:RandomInt(-90,90))
                if c>100 then break end
            end
            local marker = mod:SpawnEntity(mod.Entity.MercuryTarget, position, Vector.Zero, entity):ToEffect()
            marker.Timeout = 45
            marker:GetSprite().Color = Color.Default
        end

    elseif sprite:IsEventTriggered("EndInvulnerable") then
        entity.Velocity = Vector.Zero
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        game:ShakeScreen(10)
        for i=1, mod.MRConst.N_SPIN_PROJECTILES do
            mod:MercurySplash(entity, 1, mod.MRConst.SPIN_PROJECTILE_SPEED*0.15, 360*rng:RandomFloat())
        end

    elseif sprite:IsEventTriggered("MaxJump") then

        local min_distance = 9999
        local min_marker
        for i, marker in ipairs(mod:FindByTypeMod(mod.Entity.MercuryTarget)) do
            local distance = marker.Position:Distance(target.Position)
            if distance < min_distance then
                min_distance = distance
                min_marker = marker
            end
        end
        if min_marker then
            data.CurrentAim = min_marker.Position
        end

        if data.SpinJumpCount < mod.MRConst.SPIN_JUMP_COUNT then
            local position = target.Position + target.Velocity*30
            local c = 0
            while mod:IsOutsideRoom(position, room) do
                c = c+1
                position = target.Position + (target.Velocity*30):Rotated(mod:RandomInt(-90,90))
                if c>100 then break end
            end
            local marker = mod:SpawnEntity(mod.Entity.MercuryTarget, position, Vector.Zero, entity):ToEffect()
            marker.Timeout = 45
            marker:GetSprite().Color = Color.Default
        end

    elseif sprite:WasEventTriggered("MaxJump") and data.CurrentAim then
        local position = data.CurrentAim
        entity.Position = mod:Lerp(entity.Position, position, 0.2)
        local direction = position - entity.Position
        entity.Velocity = mod:Lerp(entity.Velocity, direction, 0.2)

    end

end
function mod:MercuryEggs(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Egg",true)
		--sfx:Play(SoundEffect.SOUND_POWERUP1)
		--sfx:Play(Isaac.GetSoundIdByName("mercury_happy"))

    elseif sprite:IsFinished("Egg") then
        data.State = mod:MarkovTransition(data.State, mod.chainMR)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Shot") then
        local direction = (target.Position - entity.Position):Normalized()
        local egg = mod:SpawnEntity(mod.Entity.MercuryBird, entity.Position, direction*mod.MRConst.EGG_SPEED, entity)
        egg:GetData().IsEgg = true
        egg.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        sfx:Play(SoundEffect.SOUND_PESTILENCE_MAGGOT_POPOUT)
    end

end

function mod:MercuryColor(entity, sprite, room)
    local blue = Color( 76/255, 179/255, 255/255)
    local yell = Color( 255/255, 222/255, 91/255)
    local pink = Color( 255/255, 77/255, 211/255)
    local gren = Color( 155/255, 255/255, 100/255)

    local met10 = Color( 146/255, 67/255, 118/255)
    local met11 = Color( 97/255, 40/255, 91/255)
    local met12 = Color( 66/255, 9/255, 71/255)

    local met20 = Color( 77/255, 71/255, 208/255)
    local met21 = Color( 55/255, 44/255, 110/255)
    local met22 = Color( 41/255, 34/255, 99/255)

    local px = room:GetCenterPos().X
    local py = room:GetCenterPos().Y

    local x1 = room:GetBottomRightPos().X
    local y1 = room:GetBottomRightPos().Y
    local x2 = room:GetTopLeftPos().X
    local y2 = room:GetTopLeftPos().Y
    local m1 = (y2-y1)/(x2-x1)
    local f1 = function(x) return m1*(x-x1)+y1 end
    local m2 = (y1-y2)/(x1-x2)
    local f2 = function(x) return m2*(x-x2)+y2 end


    local layer
    local h
    --Blue
    layer = sprite:GetLayer("blue")
    if layer then
        h = (entity.Position.X -x2)/(x1 -x2)
        h = math.min(1, math.max(0, (1-h)*1.5))
        layer:SetColor(Color.Lerp(yell, blue, h))
    end

    --Yellow
    layer = sprite:GetLayer("yellow")
    if layer then
        h = (entity.Position.Y -y2)/(y1 -y2)
        h = math.min(1, math.max(0, (1-h)*1.5))
        layer:SetColor(Color.Lerp(blue, yell, h))
    end

    --Pink
    layer = sprite:GetLayer("pink")
    if layer then
        --h = (f1(entity.Position.X) -y2)/(y1 -y2)
        --h = math.min(1, math.max(0, h*1.5))
        --layer:SetColor(Color.Lerp(gren, pink, h))
        h = math.sin(entity.Position.X/170)
        h = math.abs(h)
        layer:SetColor(Color.Lerp(pink, gren, h))
    end

    --Metal-------------
    --metal 1
    layer = sprite:GetLayer("metal1")
    if layer then
        h = (f2(entity.Position.X) -y2)/(y1 -y2)
        h = math.min(1, math.max(0, h*1.5))
        local c = Color.Lerp(met10, met20, h)
        layer:SetColor(c)
        layer = sprite:GetLayer("spinmetal1")
        if layer then
            layer:SetColor(c)
        end
    end
    --metal 2
    local p = 200
    layer = sprite:GetLayer("metal2")
    if layer then
        h = math.sin(entity.Position.Y/(p*math.pi))*math.cos(entity.Position.X/(p*math.pi))
        h = math.abs(h)
        local c = Color.Lerp(met11, met21, h)
        layer:SetColor(c)
        layer = sprite:GetLayer("spinmetal2")
        if layer then
            layer:SetColor(c)
        end
    end
    --metal 3
    layer = sprite:GetLayer("metal3")
    if layer then
        h = math.cos(entity.Position.Y/(p*math.pi))*math.sin(entity.Position.X/(p*math.pi))
        h = math.abs(h)
        local c = Color.Lerp(met12, met22, h)
        layer:SetColor(c)
        layer = sprite:GetLayer("spinmetal3")
        if layer then
            layer:SetColor(c)
        end
    end



end

--Move
function mod:MercuryMove(entity, data, room, target)   
    --idle move taken from 'Alt Death' by hippocrunchy
    
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.MRConst.IDLE_TIME_INTERVAL.X, mod.MRConst.IDLE_TIME_INTERVAL.Y)
		--V distance of Jupiter from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > 40 then
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
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.MRConst.SPEED
    data.targetvelocity = data.targetvelocity * 0.99
end

--Splash
function mod:MercurySplash(entity, amount, range, angle)
    local projectileParams = ProjectileParams()
    projectileParams.Variant = ProjectileVariant.PROJECTILE_NORMAL
    projectileParams.Color = mod.Colors.mercury
    projectileParams.FallingAccelModifier = 1/range

    amount = math.ceil(amount*0.5)

    if angle == nil then
        local offset = 360*rng:RandomFloat()
        for i = 1, mod.MRConst.N_JUMP_PROJS do
            local newAngle = i*360/mod.MRConst.N_JUMP_PROJS + offset
            entity:FireBossProjectiles (amount, entity.Position + Vector(1,0):Rotated(newAngle), 0, projectileParams)
        end
    else
        entity:FireBossProjectiles (amount, entity.Position + Vector(1,0):Rotated(angle), 0, projectileParams)
    end

end

--Spindash angle
function mod:MercurySpindashAngle(entity, data, TargetPosition, sprite)
	local angle = (TargetPosition-entity.Position):GetAngleDegrees()
	local new_angle = mod:Takeclosest(mod.MRConst.ANGLE_LIST,angle)
	local sprite = sprite or entity:GetSprite()
	sprite:ReplaceSpritesheet (6, "hc/gfx/bosses/mercury/spindashes/"..tostring(new_angle)..".png")
    for i=1, 3 do
        sprite:ReplaceSpritesheet (10+i, "hc/gfx/bosses/mercury/spindashes/metal"..tostring(i).."/"..tostring(new_angle)..".png")
    end
	sprite:LoadGraphics()
end

--ded
function mod:MercuryDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Mercury].VAR and entity.SubType == mod.EntityInf[mod.Entity.Mercury].SUB then
        for _, e in ipairs(mod:GetCandles()) do
            e:Die()
        end

        --Fart:
        mod:NormalDeath(entity, false, true)
    end
end
--deding
function mod:MercuryDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Mercury].VAR and entity.SubType == mod.EntityInf[mod.Entity.Mercury].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
    
            if sprite:GetFrame() == 1 then
                sprite.Rotation = 0
                sfx:Play(Isaac.GetSoundIdByName("TrainCrash"), 2, 2, false, 1)
            elseif sprite:IsEventTriggered("Explosion") then
                local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
            end
            
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        end
    end
end


--Callbacks
--Mercury updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MercuryUpdate, mod.EntityInf[mod.Entity.Mercury].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.MercuryDeath, mod.EntityInf[mod.Entity.Mercury].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.MercuryDying, mod.EntityInf[mod.Entity.Mercury].ID)

--OTHERS--------------------------------------------

--Mercury Bird
function mod:BirdUpdate(entity)
	if mod.EntityInf[mod.Entity.MercuryBird].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local parent = entity.Parent
		local data = entity:GetData()

		if data.Init == nil then
			data.Init = true

			entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)
			entity:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS)
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            if data.IsEgg then
                data.Velocity = entity.Velocity
                sprite:Play("Egg", true)

                entity.SpriteOffset = Vector(0,-10)

                entity.CollisionDamage = 1
            else
                sprite:Play("Flying", true)

                sprite:SetFrame(mod:RandomInt(1,10))

                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                --entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            end

		end
        
        if data.IsEgg then
            if data.Newborn then
                sprite.Rotation = 0

                if entity.Position.X > target.Position.X then
                    sprite.FlipX = true
                else
                    sprite.FlipX = false
                end
                
                entity.Velocity = Vector.Zero

                if sprite:IsEventTriggered("Shot") then
                    sfx:Play(SoundEffect.SOUND_ANGEL_WING)

                    local n = mod.MRConst.N_EGG_FEATHERS
                    local offset = mod.MRConst.EGG_FEATHER_ANGLE
                    for i=0, n-1 do
                        local direction = (target.Position - entity.Position):Normalized()
                        local angle = i*offset - (n-1)*offset*0.5
                        local velocity = direction:Rotated(angle) * mod.MRConst.EGG_FEATHER_SPEED

                        local feather = mod:SpawnEntity(mod.Entity.Bismuth, entity.Position, velocity, entity, nil, mod.EntityInf[mod.Entity.Bismuth].SUB+1)
                    end

                elseif sprite:IsFinished("Attack") then
                    entity:Die()
                end
            else
                sprite.Rotation = entity.Velocity:GetAngleDegrees()
                entity.Velocity = data.Velocity

                if entity:CollidesWithGrid() or data.BrokenEgg then
                    sprite.Rotation = 0
                    sprite:Play("Attack", true)
                    data.Newborn = true
                    sfx:Play(SoundEffect.SOUND_BONE_BREAK)
                    
                    game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 5, 3, mod.Colors.deep_mercury)
                end
            end
        else
            if parent == nil then
                entity:Die()
                return
            end

            if sprite:IsEventTriggered("Shot") then

                if (target.Position - entity.Position):Length() >= 150 then

                    local direction = (target.Position - entity.Position):Normalized()

                    local feather = mod:SpawnEntity(mod.Entity.Bismuth, entity.Position, direction*mod.MRConst.BIRD_SHOT_SPEED, entity, nil, mod.EntityInf[mod.Entity.Bismuth].SUB+1)
                    --local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction*mod.MRConst.BIRD_SHOT_SPEED, entity):ToProjectile()
                    --tear:GetSprite().Color = mod.Colors.mercury

                end

            end

            if entity.Velocity.X > 0 then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end

            --Movement--------------
            --idle move taken from 'Alt Death' by hippocrunchy
            --It just basically stays around a something

            --idleTime == frames moving in the same direction
            if parent and parent:GetData().Regen then
                data.idleTime = 1
                data.targetvelocity = ((parent.Position - entity.Position):Normalized()*10)
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
            else
                if not data.idleTime then 
                    data.idleTime = mod:RandomInt(mod.MRConst.IDLE_BIRD_TIME_INTERVAL.X, mod.MRConst.IDLE_BIRD_TIME_INTERVAL.Y)
                    if parent then
                        data.targetvelocity = ((parent.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-30, 30))
                    end
                end
            end

            --If run out of idle time
            if data.idleTime and data.idleTime <= 0 then
                data.idleTime = nil
            else
                data.idleTime = data.idleTime - 1
            end

            --Do the actual movement
            entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.MRConst.BIRD_SPEED
            data.targetvelocity = data.targetvelocity * 0.99
        end
		
        mod:MercuryColor(entity, sprite, game:GetRoom())
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.BirdUpdate, mod.EntityInf[mod.Entity.MercuryBird].ID)
function mod:BirdMercuryCollision(entity, collider)
	if collider.Type == mod.EntityInf[mod.Entity.Mercury].ID then
		if collider:GetData().Regen then
			entity:Remove()
		end

    elseif collider.Type == EntityType.ENTITY_PLAYER then
        entity:GetData().BrokenEgg = true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.BirdMercuryCollision, mod.EntityInf[mod.Entity.MercuryBird].ID)
function mod:OnBirdDamage(entity, amount, flags, source, frames)
	if entity.Variant == mod.EntityInf[mod.Entity.MercuryBird].VAR then
		if entity.Parent then
			entity.Parent:TakeDamage(amount/3, flags, source, frames)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnBirdDamage, mod.EntityInf[mod.Entity.MercuryBird].ID)

--Horn
function mod:HornUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Horn].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
    
        if sprite:IsFinished("Idle") then
            
            sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 4, 2, false, 1)
    
            for i=1, mod.MRConst.N_HORN_DIVISIONS do
                local angle = 360 * rng:RandomFloat()
                local speed = Vector.FromAngle(angle) * ( mod.MRConst.BISMUTH_SPEED * rng:RandomFloat() + 2 )
                local shot
                if entity.Parent and entity.Parent:ToPlayer() then
                    if i%2==0 then
                        shot = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, entity.Position, speed, entity.Parent):ToTear()
                        
                        shot:GetData().MercuriusTear = true
                        shot:GetData().MercuriusTearFlag = true
                        shot.Scale = 0.5 + 0.5*rng:RandomFloat()
                        
                        shot:GetSprite():Play(shot:GetSprite():GetDefaultAnimation(), true)
                        mod:ChangeSpriteToBismuth(shot)
                        
                        shot.FallingAcceleration = 1.5
                        shot.FallingSpeed = -20
                        shot.Parent = entity.Parent
                        shot.CollisionDamage = 7
                    end
                else
                    shot = mod:SpawnEntity(mod.Entity.Bismuth, entity.Position, speed, entity.Parent):ToProjectile()
                    shot.FallingAccel = 1.5
                    shot.FallingSpeed = -20
                    shot.Parent = entity.Parent
                end
            end
    
            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.HornUpdate, mod.EntityInf[mod.Entity.Horn].VAR)

--Bismuth
function mod:BismuthUpdateProjectile(tear, collider, collided)
    if tear.SubType == mod.EntityInf[mod.Entity.Bismuth].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()
    
        if data.Init == nil then
            sprite:Play("Rotate"..tostring(mod:RandomInt(0,2)), true)
            data.Init = true
        end
    
        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
    
            for i=1, mod.MRConst.N_BISMUTH_DIVISIONS do
                local angle = 360 * rng:RandomFloat()
                local speed = Vector.FromAngle(angle) * ( mod.MRConst.BISMUTH_DIVISION_SPEED * rng:RandomFloat() + 5 )
                local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, speed, tear.Parent):ToProjectile()
                shot.FallingSpeed = -10;
                shot.FallingAccel = 1.5;
                shot:GetSprite().Color = mod.Colors.mercury
            end
    
            tear:Die()
        end
    elseif tear.SubType == mod.EntityInf[mod.Entity.Bismuth].SUB+1 then
        mod:BismuthFeatherUpdateProjectile(tear, collider, collided)
    end
end
function mod:BismuthFeatherUpdateProjectile(tear, collider, collided)
    local sprite = tear:GetSprite()
    local data = tear:GetData()

    if data.Init == nil then
        data.Init = true
        sprite:Play("Idle", true)
    end
    sprite.Rotation = tear.Velocity:GetAngleDegrees()

    --If tear collided then
    if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
        sfx:Play(SoundEffect.SOUND_TEARIMPACTS)
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0, tear.Position, Vector.Zero, nil)

        poof:GetSprite().Color = mod.Colors.deep_mercury
        tear:Die()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.BismuthUpdateProjectile, mod.EntityInf[mod.Entity.Bismuth].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.BismuthUpdateProjectile, mod.EntityInf[mod.Entity.Bismuth].VAR)

--Dash
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DissapearAfterIdle, mod.EntityInf[mod.Entity.SonicBoom].VAR)

--Trace
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DissapearAfterIdle, mod.EntityInf[mod.Entity.MercuryTrace].VAR)