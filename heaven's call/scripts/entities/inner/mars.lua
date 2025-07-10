local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@&@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@&&&&&&&&&@@@/@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@&@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&@@*@@@@,@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@&@@&@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&@@%%@@&*@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&&&&&&@@@&&&&&&&&&&&&&&&&&&@@@@%%@@@@@@@@@@@@@@@@@@@@%@@@%@
@@@@@@@@@@@@&&@@@@@@@@@@@&&&@@&&&@&&&&&&&&&&&&&&&&@@&@@@@@@@@@@@@&&&&@@@@#@@#@##
@@@@@@@@@@@&@@@@@@@@@@@@@&&&@&&&@@&&&@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@&&&@@@@#@@@@#
@@@@@@@@@@@@@@@@@@@@@@@@@&&@@&&&@&@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@&@@@@
@@@@@@&@@@@@@@@@@@@@@@@@@&&@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@
@@@@@@@@@@@&@@@@@@@@@@@@@@&%########%&@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&@@@@@@@@@&
@@@@@@@@@&&&&@@@@@@@@/%%(  (#############%#@@@@@@@@@@@@@@@@@&&&&&&&&&&&&@@@@@@@@
@@@@@@@@&&&&&@@@&@@@@@#(###&@@#@@@########@@@@@@@& &@@@@@&&&&&&&&&&&&&&&&&@&@@@@
@@@@@@@@&&&&&&&@@@@@@&  (#@@#&@@@@@@######&&@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&@@@
@@@@@@@@@&&&&&&&&&&&&&###%@@#@&@@&&@######&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@
@@@@@@@@@@&&&&&&&&&&@@&####@@@#@@@%#### ,%@&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@
@@@@@@@@@@@@&&&&&@@#&&@@%###########,  #@@@@&#@@@@&&&&&&&&&&&&&&&&@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@&/&&&&&@@@@@@@@@@@@@@@&&&&@@%(#.&@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@*&&&@@&&&&&&&&&&&&&&&&&&&&&&&@@@//%*@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&&&@@@@@@&&&&&&&&&&@@@@@@@@@&&@@&(%#@&*@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@&@@@(@*@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

mod.MMSState = {
    APPEAR = 0,
    MOVE = 1,
    UP = 2,
    DOWN = 3,
    LEFT = 4,
    RIGHT = 5,
    ATTACK = 6,
    CLOCK = 7,
    LASER = 8,
    MISSILES = 9,
    AIRSTRIKE = 10,
    DRONES = 11,
    CHARGE = 12,
    SHOTS = 13,
    HOMING = 14,
    GUN = 15
}
mod.chainM = {--                 App   Mov    UP     DOWN   LEFT   RIGHT  Atk    Clock  Laser   Miss    Air     Drone   Charge  Shot   Hom      Gun
    [mod.MMSState.APPEAR] =     {0,    1,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.MOVE] =       {0,    0,     0.25,  0.25,  0.25,  0.25,  0,     0,     0,      0,      0,      0,      0,      0,     0,       0},
    --[mod.MMSState.UP] =         {0,    0,     0.18,  0.22,  0.25,  0.25,  0.1,   0,     0,      0,      0,      0,      0,      0,     0,       0},
    --[mod.MMSState.DOWN] =       {0,    0,     0.22,  0.18,  0.25,  0.25,  0.1,   0,     0,      0,      0,      0,      0,      0,     0,       0},
    --[mod.MMSState.LEFT] =       {0,    0,     0.25,  0.25,  0.18,  0.22,  0.1,   0,     0,      0,      0,      0,      0,      0,     0,       0},
    --[mod.MMSState.RIGHT] =      {0,    0,     0.25,  0.25,  0.22,  0.18,  0.1,   0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.UP] =         {0,    0,     0.21,  0.19,  0.19,  0.19,  0.22,  0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.DOWN] =       {0,    0,     0.19,  0.21,  0.19,  0.19,  0.22,  0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.LEFT] =       {0,    0,     0.19,  0.19,  0.21,  0.19,  0.22,  0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.RIGHT] =      {0,    0,     0.19,  0.19,  0.19,  0.21,  0.22,  0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.ATTACK] =     {0,    0,     0,     0,     0,     0,     0,     0.05,  0.12,   0.1,    0.1,    0.1,    0.16,   0.3,   0.07,       0},
    --[mod.MMSState.ATTACK] =     {0,    0,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      1,      0,     0,       0},
    [mod.MMSState.CLOCK] =      {0,    1,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.LASER] =      {0,    0.3,   0,     0,     0,     0,     0,     0,     0.3,    0.3,    0,      0,      0.1,    0,     0,       0},
    [mod.MMSState.MISSILES] =   {0,    0.5,   0,     0,     0,     0,     0,     0,     0,      0.2,    0.2,    0,      0.1,    0,     0,       0},
    [mod.MMSState.AIRSTRIKE] =  {0,    1,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.DRONES] =     {0,    0.5,   0,     0,     0,     0,     0,     0.2,   0,      0,      0,      0,      0,      0.1,   0.2,       0},
    [mod.MMSState.CHARGE] =     {0,    0.2,   0,     0,     0,     0,     0,     0,     0.4,    0.4,    0,      0,      0,      0,     0,       0},
    --[mod.MMSState.CHARGE] =     {0,    0,     0,     0,     0,     0,     0,     0,  0,   0,    0,    0,    1,   0,   1,       0},
    [mod.MMSState.SHOTS] =      {0,    0.15,  0,     0,     0,     0,     0,     0,     0,      0,      0.25,   0,      0,      0.6,   0,       0},
    [mod.MMSState.HOMING] =     {0,    1,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      0,      0,     0,       0},
    [mod.MMSState.GUN] =        {0,    1,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      0,      0,     0,       0},
}
mod.MConst = {
    SPEED = 1.8,

    --babies
    PHOBOS_SHOT_SPEED = 5,
    PHOBOS_PERIOD = 32,
    DEIMOS_PERIOD = 56,

    --charge
    CHARGE_SPEED = 65,
    CHARGE_EXPLOSION_RADIUS = 50,
    EXPLOSION_DAMAGE = 300,

    --laser
    EXTRA_LASER_OFFSET = 130,

    --shots
    N_ROW_SHOTS = 3,
    N_SHOTS = 3,
    SHOT_ANGLE = 35,
    SHOT_SPEED = 6,
    MAX_FOLLOWED_SHOTS = 3,

    --missiles
    MISSILE_PERIOD = 25,
    N_MISSILE_TEARS = 4,
    MISSILE_EXPLOSION_DAMAGE = 50,
    MISSILE_EXPLOSION_RADIUS = 20,
    MISSILE_TEAR_SPEED = 15,
    MISSILE_SPEED = 9,
    MISSILE_TIME = 20,
    N_IDLE_HOMMING = 3,

    --airstrike
    N_TARGETS = 6,
    AIRSTRIKE_EXPLOSION_RADIUS = 70,
    N_IDLE_AIRSTRIKE = 5,

    --sword
    N_MOON_MURDER_TEARS = 10,
    RAGE_SPEED = 22,
    BERSERKER_HP =  0.12,
    LASER_SWORD_RADIUS = 30,
    SWORD_DAMAGE = 20,

    --gun
    N_IDLE_GUN = 15,
    GUN_PERIOD = 10,
    GUN_SHOT_SPEED = 7,
}

function mod:SetMarsDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
        --                                     App   Mov    UP     DOWN   LEFT   RIGHT  Atk    Clock  Laser   Miss    Air     Drone   Charge  Shot   Hom      Gun
        mod.chainM[mod.MMSState.ATTACK] =     {0,    0,     0,     0,     0,     0,     0,     0.05,  0.12,   0.1,    0.1,    0.1,    0.32,   0.3,   0.07,    0}
		--stat changes--------------------------------------------------------------------------------------------------
        --babies
        mod.MConst.PHOBOS_PERIOD = 60
        mod.MConst.DEIMOS_PERIOD = 90
        
        --laser
        mod.MConst.EXTRA_LASER_OFFSET = 130

        --shots
        mod.MConst.N_SHOTS = 3
        mod.MConst.N_ROW_SHOTS = 3

        --missiles
        mod.MConst.MISSILE_PERIOD = 25

        --airstrike
        mod.MConst.N_IDLE_AIRSTRIKE = 5

        --gun
        mod.MConst.N_IDLE_GUN = 15
        mod.MConst.GUN_PERIOD = 10
        mod.MConst.GUN_SHOT_SPEED = 7

	elseif difficulty == mod.Difficulties.ATTUNED then
        --                                     App   Mov    UP     DOWN   LEFT   RIGHT  Atk    Clock  Laser   Miss    Air     Drone   Charge  Shot   Hom      Gun
        mod.chainM[mod.MMSState.ATTACK] =     {0,    0,     0,     0,     0,     0,     0,     0,     0.1,    0.1,    0.1,    0.1,    0.28,   0.3,   0.07,    0.09}
		--stat changes--------------------------------------------------------------------------------------------------
        --babies
        mod.MConst.PHOBOS_PERIOD = 50
        mod.MConst.DEIMOS_PERIOD = 85
        
        --laser
        mod.MConst.EXTRA_LASER_OFFSET = 110

        --shots
        mod.MConst.N_SHOTS = 4
        mod.MConst.N_ROW_SHOTS = 3

        --missiles
        mod.MConst.MISSILE_PERIOD = 14

        --airstrike
        mod.MConst.N_IDLE_AIRSTRIKE = 5

        --gun
        mod.MConst.N_IDLE_GUN = 15
        mod.MConst.GUN_PERIOD = 10
        mod.MConst.GUN_SHOT_SPEED = 7

    elseif difficulty == mod.Difficulties.ASCENDED then
        --                                     App   Mov    UP     DOWN   LEFT   RIGHT  Atk    Clock  Laser   Miss    Air     Drone   Charge  Shot   Hom      Gun
        mod.chainM[mod.MMSState.ATTACK] =     {0,    0,     0,     0,     0,     0,     0,     0,     0.1,    0.1,    0.1,    0.1,    0.28,   0.3,   0.07,    0.09}
		--stat changes--------------------------------------------------------------------------------------------------
        --babies
        mod.MConst.PHOBOS_PERIOD = 40
        mod.MConst.DEIMOS_PERIOD = 60
        
        --laser
        mod.MConst.EXTRA_LASER_OFFSET = 90

        --shots
        mod.MConst.N_SHOTS = 4
        mod.MConst.N_ROW_SHOTS = 4

        --missiles
        mod.MConst.MISSILE_PERIOD = 14

        --airstrike
        mod.MConst.N_IDLE_AIRSTRIKE = 4

        --gun
        mod.MConst.N_IDLE_GUN = 20
        mod.MConst.GUN_PERIOD = 7
        mod.MConst.GUN_SHOT_SPEED = 8.5

    end

    --mod.chainM[mod.MMSState.ATTACK] =     {0,    0,     0,     0,     0,     0,     0,     0,     0,      0,      0,      0,      1,      0,     0,       0}

    mod.chainM = mod:NormalizeTable(mod.chainM)
end

--mod:SetMarsDifficulty(0)
--mod:checkSums(mod.chainM)

local PickedIndexes = {}
local RandomDists = {}
local airstrikesIndexes = { 
    32, 35, 39, 42,  
    --62, 65, 69, 72,  
    92, 95, 99, 102}

function mod:MarsUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Mars].VAR and entity.SubType == mod.EntityInf[mod.Entity.Mars].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()

        --Custom data:
        if data.State == nil then
            data.State = 0
            data.SecondState = 0
            data.StateFrame = 0

            data.TargetPos = Vector.Zero
            data.ExtraLaserCount = 0
            data.ExtraLaserWarningCount = 0
            data.Laser = false
            data.TargetDirection = Vector.Zero
            data.Move = false
            data.IsMartian = true
            data.FollowedShots = 0

            data.SwordFlag = false
            data.Sword = nil
            data.SwordState = 0

			mod:CheckEternalBoss(entity)
        end

        --Frame
        data.StateFrame = data.StateFrame + 1

        if not data.SwordFlag and entity.HitPoints < entity.MaxHitPoints * mod.MConst.BERSERKER_HP and data.State ~= mod.MMSState.LASER and data.State ~= mod.MMSState.AIRSTRIKE then
            data.SwordFlag = true
            data.StateFrame = 0
        end

        if data.SwordFlag then
            mod:MarsRage(entity, data, sprite, target,room)
        else

            if data.State == mod.MMSState.APPEAR then
                if data.StateFrame == 1 then
                    mod:AppearPlanet(entity)
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                    data.State = mod:MarkovTransition(data.State, mod.chainM)
                    data.StateFrame = 0
                elseif sprite:IsEventTriggered("EndAppear") then
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

                    local deimos = mod:SpawnEntity(mod.Entity.Deimos, entity.Position, Vector.Zero, entity)
                    deimos.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    deimos.Parent = entity
                    deimos:GetSprite():Play("Idle",true)
                    deimos:GetSprite().PlaybackSpeed = 0.5
                    local data = deimos:GetData()
                    data.IsMartian = true
                    data.orbitIndex = 0
                    data.orbitTotal = 2
                    data.orbitSpin = 1
                    data.orbitSpeed = 3.1891
                    data.orbitDistance = 23.436
                    
                    local phobos = mod:SpawnEntity(mod.Entity.Phobos, entity.Position, Vector.Zero, entity)
                    phobos.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    phobos.Parent = entity
                    phobos:GetSprite():Play("Idle",true)
                    phobos:GetSprite().PlaybackSpeed = 0.5
                    local data = phobos:GetData()
                    data.IsMartian = true
                    data.orbitIndex = 1
                    data.orbitTotal = 2
                    data.orbitSpin = 1
                    data.orbitSpeed = 12.6244
                    data.orbitDistance = 9.377


                    mod:GenerateMarsGuns(entity)
                end  
            elseif data.State == mod.MMSState.UP or data.State == mod.MMSState.DOWN or data.State == mod.MMSState.LEFT or data.State == mod.MMSState.RIGHT then
                if data.StateFrame == 1 then
                    sprite:Play("Idle",true)
                elseif sprite:IsFinished("Idle") then
                    data.SecondState = data.State
                    data.State = mod:MarkovTransition(data.State, mod.chainM)
                    data.StateFrame = 0
                else
                    mod:MarsMove(entity, data, room, target)
                end
            elseif data.State == mod.MMSState.MOVE or data.State == mod.MMSState.ATTACK then
                data.State = mod:MarkovTransition(data.State, mod.chainM)
                data.StateFrame = 0

            elseif data.State == mod.MMSState.CLOCK then
                mod:MarsClock(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.LASER then
                mod:MarsLaser(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.MISSILES then
                mod:MarsRocket(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.AIRSTRIKE then
                mod:MarsAirstrike(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.DRONES then
                mod:MarsDrones(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.CHARGE then
                mod:MarsCharge(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.SHOTS then
                mod:MarsShots(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.HOMING then
                mod:MarsHoming(entity, data, sprite, target,room)
            elseif data.State == mod.MMSState.GUN then
                mod:MarsGun(entity, data, sprite, target,room)
            end
        end

        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)

        if sprite:IsEventTriggered("Laught") then
            sfx:Play(Isaac.GetSoundIdByName("marsLaught"), 3.5)
        end
    end
end
function mod:MarsCharge(entity, data, sprite, target, room)

    local invf = 25

    if data.StateFrame == 1 then

        if room:IsPositionInRoom(entity.Position, entity.Size * 0.95) then

            sprite:Play("Charge",true)
    
            local angle = (target.Position - entity.Position):GetAngleDegrees()
            local boost = mod:SpawnEntity(mod.Entity.MarsBoost, entity.Position + Vector(0,-50), Vector.Zero, entity):ToEffect()
            boost:FollowParent(entity)
            boost.DepthOffset = -50
            boost:GetSprite().Rotation = angle-180
            data.Boost = boost
            data.Fires = 0
    
            sfx:Play(Isaac.GetSoundIdByName("RocketOpen"), 1, 2, false, 1)
        else
            entity.Velocity = Vector.Zero
            data.IsCharging = false
            data.State = mod:MarkovTransition(data.State, mod.chainM)
            data.StateFrame = 0
        end
        
    elseif sprite:IsFinished("Charge") then
        entity.Velocity = Vector.Zero
        data.IsCharging = false
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0
        
    elseif entity:CollidesWithGrid() and data.StateFrame > invf then
        game:ShakeScreen(35)
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1.5);

		--Explosion:
		local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity):ToEffect()
        explosion.DepthOffset = 10
		--Explosion damage
		for i, e in ipairs(Isaac.FindInRadius(entity.Position, mod.MConst.CHARGE_EXPLOSION_RADIUS)) do
			if e.Type ~= EntityType.ENTITY_PLAYER and not e:GetData().IsMartian then
				e:TakeDamage(mod.MConst.EXPLOSION_DAMAGE, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
			end
		end

        entity.Velocity = Vector.Zero
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0
        
        data.Boost:GetSprite():SetFrame("Idle",48)
        data.IsCharging = false
        
        for i=1, 8 do
            local pos = entity.Position + Vector.FromAngle(i*360/8)*55
            local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, pos, Vector.Zero, entity)
            fire:GetSprite().Color = Color(1,0.75,0.2,1,0.5)
            fire:GetSprite().PlaybackSpeed = 0.8
        end

    elseif sprite:IsEventTriggered("SetAim") then
        data.TargetPos = target.Position
        entity.Velocity = Vector.Zero
    elseif sprite:IsEventTriggered("Attack") then
        data.IsCharging = true
        data.Angle = (data.TargetPos - entity.Position):GetAngleDegrees()

        local angle = data.Angle
        if data.Boost then
            local boost = data.Boost 
            boost:FollowParent(entity)
            boost.DepthOffset = -10
            boost:GetSprite().Rotation = angle-180
        end

        sfx:Play(SoundEffect.SOUND_FAMINE_DASH_START,2,2,false,1.5)
        --sfx:Play(SoundEffect.SOUND_BEAST_GRUMBLE,2,2,false,1.5)
        sfx:Play(SoundEffect.SOUND_GFUEL_EXPLOSION_BIG,1,2,false,2)
    end

    if data.IsCharging and (data.StateFrame > invf or (not entity:CollidesWithGrid())) then
        entity.Velocity = Vector.FromAngle(data.Angle)*mod.MConst.CHARGE_SPEED
            
        mod:MarsCondimentTrace(entity)
        mod:MarsCondimentTrace(entity)

        data.Fires = data.Fires + 1
        
        local fire = mod:SpawnEntity(mod.Entity.Flame, entity.Position, entity.Velocity*0.01, entity):ToProjectile()
        fire:GetData().Mars = true
        fire:GetData().NoRot = true
        fire:GetSprite().Rotation = 90--entity.Velocity:GetAngleDegrees()
        fire.SpriteOffset = Vector(0, 15)
        mod:TearFallAfter(fire, 30 * math.sin(data.Fires/15 * 1.5 * 3.14159)^2)
        fire.SpriteScale = Vector.One * math.sin(data.Fires/15 * 3.14159) * 1.25

        fire:Update()
        fire:Update()
        
        fire:SetColor(Color(1,0.75,0.2,1,1.5), -1, 1, false, false)
    end
end
function mod:MarsLaser(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Laser",true)
        sfx:Play(Isaac.GetSoundIdByName("marsLaserLaught"), 2, 2, false, 1)
    elseif sprite:IsFinished("Laser") then
        data.Laser = false
        data.ExtraLaserCount = 0
        data.ExtraLaserWarningCount = 0

        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("SetAim") then
        sfx:Play(Isaac.GetSoundIdByName("LaserCharge"),5)
        data.TargetPos = target.Position
        entity.Velocity = Vector.Zero
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("LaserShot"),7, 2, false, 1.3)
        data.Laser = true
        data.TargetDirection = (data.TargetPos - entity.Position):Normalized()
        local direction = data.TargetDirection
		local laser = EntityLaser.ShootAngle(LaserVariant.BRIM_TECH, entity.Position + direction*80 , direction:GetAngleDegrees(), 85, Vector.Zero, entity)
        laser:GetData().IsMartian = true
        data.LaserEntity = laser

        --laser:GetData().ForceDefaultColor = true
        --laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

        --local sprite = laser:GetSprite()
        --sprite:ReplaceSpritesheet (0, "hc/gfx/effects/energy_laser.png", true)
        --sprite.Scale = Vector.One*2

        RandomDists = {mod:RandomInt(-30,30), mod:RandomInt(-30,30), mod:RandomInt(-30,30), mod:RandomInt(-30,30)}

        for i=1,2 do
            local var = LaserVariant.THIN_RED
            if i == 2 then var = LaserVariant.BRIM_TECH end
            local ring = Isaac.Spawn(EntityType.ENTITY_LASER, var, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, entity.Position - Vector(0,5), Vector.Zero, entity):ToLaser()
            if ring then
                ring.Timeout = laser.Timeout
                ring.Parent = entity
                ring.Radius = 60
                ring.Shrink = true

                ring.DepthOffset = -200
                if i == 2 then 
                    ring:SetScale(0.5)
                    ring.DepthOffset = -1000
                end
                
                ring.TargetPosition = entity.Position
                ring:GetSprite().Color = Color(1,0.1,0.1,1)
                ring:GetSprite().Rotation = rng:RandomFloat()*360

                mod:scheduleForUpdate(function()
                    sfx:Stop(SoundEffect.SOUND_ANGEL_BEAM)
                end, 2)
            end
        end


    elseif sprite:IsEventTriggered("ExtraLaserWarning") then
        data.ExtraLaserWarningCount = data.ExtraLaserWarningCount + 1
        local distance = mod.MConst.EXTRA_LASER_OFFSET*data.ExtraLaserWarningCount + (RandomDists[data.ExtraLaserWarningCount] or 0)
        local direction = data.TargetDirection
        local position = entity.Position + direction*distance
        if not mod:IsOutsideRoom(position, room) then
            for i = 0, 1 do
                local laser = EntityLaser.ShootAngle(LaserVariant.TRACTOR_BEAM, position, direction:GetAngleDegrees() + 90*(2*i-1), 9, Vector.Zero, entity)

                laser:GetSprite().Color = Color(2,0,0,1)

                --laser:GetData().ForceDefaultColor = true
                --laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
            end
        else
            --sprite:SetFrame("Laser", sprite:GetFrame())
            data.LaserEntity.Timeout = data.LaserEntity.Timeout - 10
        end

    elseif sprite:IsEventTriggered("ExtraLaser") then
        data.ExtraLaserCount = data.ExtraLaserCount + 1
        local distance = mod.MConst.EXTRA_LASER_OFFSET*data.ExtraLaserCount + (RandomDists[data.ExtraLaserCount] or 0)
        local direction = data.TargetDirection
        local position = entity.Position + direction*distance
        if not mod:IsOutsideRoom(position, room) then
            for i = 0, 1 do
                sfx:Play(Isaac.GetSoundIdByName("LaserShotMini"),7, 2, false, 0.75 + 0.35*rng:RandomFloat())
                local laser = EntityLaser.ShootAngle(LaserVariant.BRIM_TECH, position ,direction:GetAngleDegrees() + 90*(2*i-1), 10, Vector.Zero, entity)

                --local sprite = laser:GetSprite()
                --sprite:ReplaceSpritesheet (0, "hc/gfx/effects/energy_laser.png", true)
                
                --laser:GetData().ForceDefaultColor = true
                --laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

                laser:GetData().IsMartian = true
            end
        else
    
        end
    end
    sfx:Stop (SoundEffect.SOUND_BLOOD_LASER)

    if data.Laser then
        data.targetvelocity = -data.TargetDirection
        entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.MConst.SPEED

        if data.LaserEntity and data.LaserEntity.Timeout <= 2 then
            for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
                if e:GetData().IsMartian then
                    e:Die()
                end
            end

            --sprite:SetFrame("Laser", 115)
        end
    end

    if entity:CollidesWithGrid() then
        entity.Velocity = Vector.Zero
    end

    --if sprite:WasEventTriggered("Pinit") and not sprite:WasEventTriggered("Pend") then
    --    local digit = mod:SpawnBinaryParticle(entity.Position + Vector(0,-20), mod:RandomVector(20,5), entity)
    --    digit:GetSprite().PlaybackSpeed = 0.5
    --end
end
function mod:MarsAirstrike(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Airstrike",true)
        
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN,2,2,false,2)
    elseif sprite:IsFinished("Airstrike") then
        data.n_idles = mod.MConst.N_IDLE_AIRSTRIKE
        sprite:Play("Idle", true)
    elseif sprite:IsFinished("Idle") then
        data.n_idles = data.n_idles - 1
        if data.n_idles <= 0 then
            for n,i in pairs(PickedIndexes) do
                PickedIndexes[n] = nil
            end
            data.State = mod:MarkovTransition(data.State, mod.chainM)
            data.StateFrame = 0
    
            data.SecondState = mod.chainM2[mod:RandomInt(1,#mod.chainM2)]
        else
            sprite:Play("Idle", true)
        end
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("Signal"), 1, 2, false, 1)
        --[[
        for i=1, mod.MConst.N_TARGETS do
            --local position = room:GetRandomTileIndex(mod:RandomInt(1,1000))
            local position = mod:RandomInt(16,118)

            local flag = false
            if PickedIndexes[position] == nil then
                PickedIndexes[position]=true
            else
                flag = true
            end

            if position%3 == 0 and not flag then
                local target = mod:SpawnEntity(mod.Entity.MarsTarget, room:GetGridPosition(position), Vector.Zero, entity)
                target.Parent = entity
            end
        end]]
        if room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then
            for n,i in pairs(airstrikesIndexes) do
                local target = mod:SpawnEntity(mod.Entity.MarsTarget, room:GetGridPosition(airstrikesIndexes[n]), Vector.Zero, entity)
                target.Parent = entity
            end
        else
            for n,i in pairs(airstrikesIndexes) do
                local target = mod:SpawnEntity(mod.Entity.MarsTarget, room:GetRandomPosition(0), Vector.Zero, entity)
                target.Parent = entity
            end
        end
        --local target = mod:SpawnEntity(mod.Entity.MarsTarget, room:GetCenterPos(), Vector.Zero, entity)
        --target.Parent = entity
    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(Isaac.GetSoundIdByName("MarsMissile"), 1, 2, false, 1)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN,1,2,false,2)
    end

    if sprite:WasEventTriggered("Pinit") and not sprite:WasEventTriggered("Pend") then
        local pos = {Vector(0,-200), Vector(23, -145), Vector(-30, -160)}
        local vel = {Vector(0,-1), Vector(1,-1):Normalized(), Vector(-1,-1):Normalized()}
        for i, position in ipairs(pos) do
            local digit = mod:SpawnBinaryParticle(entity.Position + position, vel[i]:Rotated(mod:RandomInt(-45,45))*(10*(0.5+0.5*rng:RandomFloat())), entity)
            digit.DepthOffset = 250
            digit:GetSprite().PlaybackSpeed = 0.3
            digit.SpriteScale = digit.SpriteScale * 0.5
        end
    end

    --mod:MarsMove(entity, data, room, target, true)

end
function mod:MarsClock(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0
    end
end
function mod:MarsRocket(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Rocket",true)
        sfx:Play(SoundEffect.SOUND_MOUTH_FULL,2,2,false,0.8)
    elseif sprite:IsFinished("Rocket") or sprite:IsFinished("Rocket") then
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then
        
        data.TargetDir = (target.Position - entity.Position):Normalized()

        local rocketType = mod.Entity.MarsRocket
        if rng:RandomFloat() <= 0.02 then
            rocketType = mod.Entity.MarsGigaRocket
        end

        local rocket = mod:SpawnEntity(rocketType, entity.Position + data.TargetDir*40, data.TargetDir, entity):ToBomb()

        rocket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        rocket.ExplosionDamage = 10
        rocket:GetData().IsDirected_HC = true
        rocket:GetData().Direction = data.TargetDir
        rocket:GetSprite().Rotation = data.TargetDir:GetAngleDegrees()

        if rocketType == mod.Entity.MarsGigaRocket then
            rocket.RadiusMultiplier = 1.75
            rocket:GetData().IsMartian = true

            if rocket:GetData().IsDirected_HC then
                local rocketSprite = rocket:GetSprite()
                rocketSprite:ReplaceSpritesheet (0, "hc/gfx/items/pick ups/mars_explosives_crit.png")
                rocketSprite:LoadGraphics()
            end
        end
        
        sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD,1,2,false,1.)
        sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,2,2,false,1)
    end

    if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
        mod:MarsMove(entity, data, room, target, true)
    end
end
function mod:MarsDrones(entity, data, sprite, target, room)
    if data.StateFrame == 1 then--Now the moons always attack
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0
        --sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0
    end
end
function mod:MarsShots(entity, data, sprite, target, room)
    local gun = entity.Child
    if data.StateFrame == 1 then
        
        if not gun then
            gun, _ = mod:GenerateMarsGuns(entity)
        end

        if (target.Position - entity.Position):Length() >= 200 then
            sprite:Play("Shot",true)
        else
            if true then
                data.State = mod:MarkovTransition(data.State, mod.chainM)
        
                if data.State == mod.MMSState.SHOTS then
                    data.FollowedShots = data.FollowedShots + 1
                else
                    data.FollowedShots = 0
                end
        
                if data.FollowedShots >= mod.MConst.MAX_FOLLOWED_SHOTS then
                    data.FollowedShots = 0
                    data.State = mod.MMSState.MOVE
                end
        
                data.StateFrame = 0
            end
        end
    elseif sprite:IsFinished("Shot") then
        if true then

            data.State = mod:MarkovTransition(data.State, mod.chainM)
    
            if data.State == mod.MMSState.SHOTS then
                data.FollowedShots = data.FollowedShots + 1
            else
                data.FollowedShots = 0
            end
    
            if data.FollowedShots >= mod.MConst.MAX_FOLLOWED_SHOTS then
                data.FollowedShots = 0
                data.State = mod.MMSState.MOVE
            end
    
            data.StateFrame = 0
        end
        
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("EnergyShotTriple"),2)
            
        sfx:Play(SoundEffect.SOUND_BUMBINO_RAM,1,2,false,1)
        sfx:Play(SoundEffect.SOUND_BUMBINO_SLAM,1,2,false,1)
        sfx:Play(SoundEffect.SOUND_BUMBINO_PUNCH,1,2,false,1)
        sfx:Play(SoundEffect.SOUND_BUMBINO_MISC,1,2,false,1)
        
        sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT,2,2,false,1)
        sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SMALL,2,2,false,1)
        sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_LARGE,2,2,false,1)
        sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD,2,2,false,1)

        local gunPos = nil
        if gun then
            gun:GetSprite():Play("Shot", true)
            gunPos = gun.Position + Vector.FromAngle(gun:GetSprite().Rotation+180)*20
        end

        for j=1, mod.MConst.N_ROW_SHOTS do
            local targetAim = target.Position - entity.Position
            for i=0, mod.MConst.N_SHOTS-1 do
                local angle = -mod.MConst.SHOT_ANGLE/2 + mod.MConst.SHOT_ANGLE / (mod.MConst.N_SHOTS-1) * i
                local velocity = targetAim:Normalized():Rotated(angle)*mod.MConst.SHOT_SPEED*(1/(j^0.5))
                local shot = mod:SpawnMarsShot(gunPos or entity.Position, velocity, entity)
                shot:AddProjectileFlags(ProjectileFlags.ACCELERATE)
                shot.Acceleration = 1.02
            end
        end
    end
    
    mod:MarsMove(entity, data, room, target, true)

end
function mod:MarsHoming(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
    
        data.Move = false

        sprite:Play("Homing",true)
        sfx:Play(Isaac.GetSoundIdByName("missileBoxOpen"))
        sfx:Play(Isaac.GetSoundIdByName("MarsMissile"), 1, 2, false, 1)
        
        sfx:Play(Isaac.GetSoundIdByName("marsRocketLaught"), 2, 2, false, 1)
    elseif sprite:IsFinished("Homing") then
        data.n_idles = mod.MConst.N_IDLE_HOMMING
        sprite:Play("Idle", true)
        
        sfx:Play(Isaac.GetSoundIdByName("WeaponSwitch"), 1, 2, false, 1)
    elseif sprite:IsFinished("Idle") then
        data.n_idles = data.n_idles - 1
        if data.n_idles <= 0 then
            data.State = mod:MarkovTransition(data.State, mod.chainM)
            data.StateFrame = 0
            
            data.SecondState = mod.chainM2[mod:RandomInt(1,#mod.chainM2)]
        else
            sprite:Play("Idle", true)
        end
        
    elseif sprite:IsEventTriggered("StartIdle") then
        data.Move = true

    elseif sprite:WasEventTriggered("Attack") and data.StateFrame%mod.MConst.MISSILE_PERIOD == 0 then
        for i=-1, 1, 2 do
            local angle = ((i+1)/2)*180
            local velocity = Vector(1,0):Rotated(angle+mod:RandomInt(-30,30))*mod.MConst.MISSILE_SPEED*(0.5*rng:RandomFloat()+0.5)

            local missile = mod:SpawnEntity(mod.Entity.Missile, entity.Position + Vector(-i, 0)*70, velocity, entity):ToProjectile()
            missile.Parent = entity

            missile:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

            missile:GetData().IsMissile_HC = true
        end
        sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1, 2, false, 2)
    end

    if data.Move then
        mod:MarsMove(entity, data, room, target, true)
    end
end
function mod:MarsRage(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("RageStart",true)

        mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.MarsGun))
        mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.MarsLilGun))

        local sword = mod:SpawnEntity(mod.Entity.LaserSword, entity.Position, Vector.Zero, entity):ToEffect()
        entity.Child = sword
        sword.Parent = entity
        sword:FollowParent(entity)
        sword.DepthOffset = 10
        data.Sword = sword
        sfx:Play(Isaac.GetSoundIdByName("SaberStart"), 1, 2, false, 1)

		game:SpawnParticles (entity.Position, EffectVariant.WOOD_PARTICLE, 25, 12)
		game:SpawnParticles (entity.Position, EffectVariant.WOOD_PARTICLE, 25, 12, Color(0.25,0.25,0.25,1,0.25,0,0))

        sfx:Play(Isaac.GetSoundIdByName("MarsDamage"), 2, 2, false, 1)

    elseif sprite:IsFinished("RageStart") then
        sprite:Play("Rage",true)
    elseif sprite:IsFinished("Rage") then
        if mod.savedatasettings().Difficulty == mod.Difficulties.ASCENDED then
            sfx:Play(SoundEffect.SOUND_MOUTH_FULL,2,2,false,0.8)
            sprite:Play("Bomb",true)
        else
            sprite:Play("Rage",true)
        end
    elseif sprite:IsFinished("Bomb") then
        sprite:Play("Rage",true)
        
    elseif sprite:IsEventTriggered("SetAim") then
        data.TargetPos = target.Position

    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_WAR_GRAB_PLAYER, 0.8, 2, false, 1.3)
        sfx:Play(Isaac.GetSoundIdByName("Saber"), 2, 2, false, 1)
        local angle = (data.TargetPos - entity.Position):GetAngleDegrees()

        --local sword = data.Sword
        local sword = entity.Child
        local swordSprite = sword:GetSprite()

        if data.SwordState == 0 then
            data.SwordState = 1
                
            for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Mars].ID)) do
                if e.Variant ~= mod.EntityInf[mod.Entity.Mars].VAR then
                    
                    --Summon projectile
                    for i=1, mod.MConst.N_MOON_MURDER_TEARS do
                        
                        local angle = mod:RandomInt(0, 359)
                        local speed = mod:RandomInt(mod.SConst.HORF_MURDER_TEAR_SPEED.X, mod.SConst.HORF_MURDER_TEAR_SPEED.Y)
                        local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, e.Position, Vector(1,0):Rotated(angle)*speed, e.Parent):ToProjectile()
                        tear.FallingSpeed = -1 * mod:RandomInt(1, 500) / 1000
                        tear.FallingAccel = mod:RandomInt(1, 30) / 100
                        tear.Height = -1 *  mod:RandomInt(18, 30)
                    end

                    e:Die()
                end
            end

            swordSprite:Play("Spin",true)
            
        else
            entity.Velocity = Vector.FromAngle(angle) * mod.MConst.RAGE_SPEED

            if data.SwordState <= 2 then
                
                if data.SwordState == 1 then
                    swordSprite:Play("AttackCW",true)
                else
                    swordSprite:Play("AttackCCW",true)
                end
                swordSprite.Rotation = angle - 90
                
                data.SwordState = data.SwordState + 1

            elseif data.SwordState == 3 then
                data.SwordState = 1

                swordSprite:Play("Spin",true)
                swordSprite.Rotation = 0
            end
        end

    elseif sprite:IsEventTriggered("EndIdle") then
        local direction = target.Position - entity.Position
        local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, entity.Position, direction/30, entity):ToBomb()
        bomb.ExplosionDamage = 10
        bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        bomb:GetSprite():ReplaceSpritesheet(0, "hc/gfx/items/pick ups/mars_bomb.png", true)
        
        sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD,1,2,false,1.)
        sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,2,2,false,1)
    end
end
function mod:MarsGun(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("AngryStart",true)
        data.Move = false
    elseif sprite:IsFinished("AngryStart") then
        data.n_idles = mod.MConst.N_IDLE_GUN
        sprite:Play("Angry",true)
    elseif sprite:IsFinished("Angry") then
        data.n_idles = data.n_idles - 1
        if data.n_idles <= 0 then
            sprite:Play("AngryEnd", true)
        else
            data.Move = true
            sprite:Play("Angry", true)
        end
    elseif sprite:IsFinished("AngryEnd") then
        data.State = mod:MarkovTransition(data.State, mod.chainM)
        data.StateFrame = 0
        
        data.SecondState = mod.chainM2[mod:RandomInt(1,#mod.chainM2)]
    end

    if data.Move then
        mod:MarsMove(entity, data, room, target, true)
        
        local gun = entity.Child
        if not gun then
            mod:GenerateMarsGuns(entity)
        end
        local gun2 = entity.Child.Child
        if not gun2 then
            mod:GenerateMarsGuns(entity)
        end
        gun2 = entity.Child.Child

        if entity.FrameCount % mod.MConst.GUN_PERIOD == 0 then
            local gunPos = nil
            if gun2 then
                gun2:GetSprite():Play("Shot", true)
                gunPos = gun2.Position + Vector.FromAngle(gun2:GetSprite().Rotation+180)*10
            end

            local velocity = (target.Position - gun2.Position):Resized(mod.MConst.GUN_SHOT_SPEED)
            local shot = mod:SpawnMarsShot(gunPos or entity.Position, velocity, entity)
                
            sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT,2,2,false,1)
            sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SMALL,2,2,false,1)
            sfx:Play(Isaac.GetSoundIdByName("EnergyShot"),1)
        end
    end
end

--Move
mod.marsDirections = {
    [mod.MMSState.UP] = Vector(0,1),
    [mod.MMSState.DOWN] = Vector(0,-1),
    [mod.MMSState.RIGHT] = Vector(1,0),
    [mod.MMSState.LEFT] = Vector(-1,0)
}
mod.chainM2 = {
    [1] = mod.MMSState.UP,
    [2] = mod.MMSState.DOWN,
    [3] = mod.MMSState.LEFT,
    [4] = mod.MMSState.RIGHT
}
mod.marsMovesOposites = {
    [mod.MMSState.UP] = mod.MMSState.DOWN,
    [mod.MMSState.DOWN] = mod.MMSState.UP,
    [mod.MMSState.RIGHT] = mod.MMSState.LEFT,
    [mod.MMSState.LEFT] = mod.MMSState.RIGHT
}
function mod:MarsMove(entity, data, room, target, secondState)
    local state = data.State
    if secondState then state = data.SecondState end

    local speed = 1
    local distanceFromPlayer = entity.Position:Distance(target.Position)
    if distanceFromPlayer < 150 then
        local varX = entity.Position.X - target.Position.X
        local varY = entity.Position.Y - target.Position.Y

        if varX > 0 then --player left
            if varY > 0 then--player down
                if math.abs(varX) > math.abs(varY) then
                    state = mod.MMSState.RIGHT
                    --state = mod.MMSState.UP
                else
                    state = mod.MMSState.UP
                    --state = mod.MMSState.RIGHT
                end
            else--player up
                if math.abs(varX) > math.abs(varY) then
                    state = mod.MMSState.RIGHT
                    --state = mod.MMSState.DOWN
                else
                    state = mod.MMSState.DOWN
                    --state = mod.MMSState.RIGHT
                end
            end
        else --player right
            if varY > 0 then--player down
                if math.abs(varX) > math.abs(varY) then
                    state = mod.MMSState.LEFT
                    --state = mod.MMSState.UP
                else
                    state = mod.MMSState.LEFT
                    --state = mod.MMSState.UP
                end
            else--player up
                if math.abs(varX) > math.abs(varY) then
                    state = mod.MMSState.LEFT
                    --state = mod.MMSState.DOWN
                else
                    state = mod.MMSState.DOWN
                    --state = mod.MMSState.LEFT
                end
            end
        end

        if distanceFromPlayer < 80 then
            entity.Velocity = Vector.Zero
            speed = 10
        end
    end

    data.targetvelocity = mod.marsDirections[state]
    if state == mod.MMSState.LEFT or state == mod.MMSState.RIGHT then
        entity.Velocity = Vector(entity.Velocity.X,0)
    else
        entity.Velocity = Vector(0,entity.Velocity.Y*0.95)
    end
    
	--Change direction if collision
	if entity:CollidesWithGrid() then
        entity.Velocity = Vector.Zero
        --state = mod.marsMovesOposites[state]
        state = mod.marsMovesOposites[mod:RandomInt(2,5)]
    end

    --Do the actual movement
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.MConst.SPEED * speed
    if entity.Velocity:Length() > 20 then entity.Velocity = entity.Velocity:Normalized()*20 end

    if secondState then
        data.SecondState = state
    else
        data.State = state
    end

    mod:MarsCondimentTrace(entity)
end

function mod:MarsCondimentTrace(entity)
    local hemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, entity.Position + Vector(0,-50), Vector.Zero, entity)
    hemo:GetSprite().Scale = Vector.One * 0.8
    hemo:GetSprite().PlaybackSpeed = 0.6

    local random = rng:RandomFloat()
    if random <= 0.5 then
        hemo:GetSprite().Color = mod.Colors.superFire
    elseif random <= 0.75 then
        hemo:GetSprite().Color = Color(10,5,0,1)
    else
        hemo:GetSprite().Color = Color(10,0,0,1)
    end
end
function mod:GenerateMarsGuns(entity)

    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.MarsGun))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.MarsLilGun))

    local gun = mod:SpawnEntity(mod.Entity.MarsGun, entity.Position, Vector.Zero, entity)
    gun.Parent = entity
    entity.Child = gun

    if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
        local gun2 = mod:SpawnEntity(mod.Entity.MarsLilGun, entity.Position, Vector.Zero, entity)
        gun2.Parent = entity
        gun.Child = gun2

        gun:GetData().Double = true
        gun2:GetData().Double = true

        return gun, gun2
    end
    return gun, nil
end
function mod:SpawnBinaryParticle(postion, velocity, source)
    local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, postion, velocity, source)
    local sprite = particle:GetSprite()

    local file = "hc/gfx/effects/binary_trail0.png"
    if rng:RandomFloat() < 0.5 then file = "hc/gfx/effects/binary_trail1.png" end
    sprite:ReplaceSpritesheet(0, file, true)

    return particle
end

--ded
function mod:MarsDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Mars].VAR and entity.SubType == mod.EntityInf[mod.Entity.Mars].SUB then

        for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Mars].ID)) do
            if e.Variant ~= mod.EntityInf[mod.Entity.Mars].VAR then
                e:Die()
            end
        end
        
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)

        if entity.Child and entity.Child.Type == EntityType.ENTITY_EFFECT then entity.Child:Remove() end

        --Fart:
        mod:NormalDeath(entity, false, true)
    end
end
--deding
function mod:MarsDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Mars].VAR and entity.SubType == mod.EntityInf[mod.Entity.Mars].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 1 then
				sprite.Rotation = 0
			elseif sprite:IsEventTriggered("Sound") then
                sfx:Play(SoundEffect.SOUND_WAR_DEATH,1,2,false, 1.5)
            end
        end
    end
end

function mod:RocketDirected(bomb)
    local data = bomb:GetData()
    if data.IsDirected_HC then--From Samael mod

        if data.Engine_HC then
            local player = bomb.SpawnerEntity and (bomb.SpawnerEntity:ToPlayer() or (bomb.SpawnerEntity:ToFamiliar() and bomb.SpawnerEntity:ToFamiliar().Player))
            if player and not data.EngineInit then
                data.EngineInit = true
                local laser = EntityLaser.ShootAngle(mod.EntityInf[mod.Entity.EngineLaser].VAR, bomb.Position, data.Direction:GetAngleDegrees()+180, 30, Vector(0,-15), player)
                laser.MaxDistance = 30
                laser.Parent = bomb
                laser.TearFlags = laser.TearFlags | player.TearFlags
            end
        end


        bomb:GetSprite().Rotation = bomb.Velocity:GetAngleDegrees()
        local targetVel = 20 * data.Direction
        local startVel = targetVel*0.25
        local framesUntilFullSpeed = 15
        local counter = bomb.FrameCount
        local percent = math.min(counter / framesUntilFullSpeed, 1)
        bomb.Velocity = mod:Lerp(startVel,targetVel,percent)
        bomb.SpriteRotation = targetVel:GetAngleDegrees()
        
    end
end

function mod:SpawnMarsShot(position, velocity, origin, fall, color)
    local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, position, velocity, origin):ToProjectile()
    if shot then
        if fall == nil then
            shot.FallingSpeed = 0
            shot.FallingAccel = -0.1
        else
            shot.Velocity = velocity*1.2
        end

        local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, shot.Position, Vector.Zero, origin):ToEffect()
        if energy then
            energy.LifeSpan = 1000
            energy.Parent = shot
            energy.DepthOffset = 5
            energy:GetData().HeavensCall = true
            energy:GetData().MarsShot_HC = true
            energy:FollowParent(shot)
        end
        
        if color then
            shot:GetSprite().Color = color
            energy:GetSprite().Color = color
        end

        return shot
    end
end

--Callbacks
--Mars updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MarsUpdate, mod.EntityInf[mod.Entity.Mars].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.MarsDeath, mod.EntityInf[mod.Entity.Mars].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.MarsDying, mod.EntityInf[mod.Entity.Mars].ID)

--Rocket
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.RocketDirected, BombVariant.BOMB_ROCKET)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
   if bomb.SubType == mod.EntityInf[mod.Entity.MarsGigaRocket].SUB then
    
        if bomb.FrameCount == 1 then
            sfx:Play(Isaac.GetSoundIdByName("Crit"), 2, 2, false, 1)
        end

        local hemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, bomb.Position + Vector(0,-20), Vector.Zero, bomb)
        hemo:GetSprite().Scale = Vector.One * 0.8
        hemo:GetSprite().PlaybackSpeed = 0.6
        hemo:GetSprite().Color = Color(10,0,0,1)
        hemo.DepthOffset = -50
        
        local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ULTRA_GREED_BLING, 0, bomb.Position + RandomVector() * ( 20 * rng:RandomFloat() + 25 ), Vector.Zero, bomb)
        shine:GetSprite().Color = Color(1,0,0,1)
        shine.SpriteScale = Vector.One * 2
        shine.DepthOffset = 50
   end
    
end, BombVariant.BOMB_ROCKET)

--OTHERS-------------------------------------------
--Deimos & Phobos-------------------------------------------------------------------------------------------------------------------
mod.martiansConsts = {
    SPEED = 1.35,
    CENTER_DISTANCE_TOLERATION = 50,
    IDLE_TIME_INTERVAL = Vector(30,60),
}

function mod:MartiansInit(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Deimos].VAR and entity.SubType == mod.EntityInf[mod.Entity.Deimos].SUB or entity.Variant == mod.EntityInf[mod.Entity.Phobos].VAR and entity.SubType == mod.EntityInf[mod.Entity.Phobos].SUB then
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        entity:GetSprite():Play("Idle", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.MartiansInit, mod.EntityInf[mod.Entity.Mars].ID)
function mod:MartiansUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()

    if entity.Variant == mod.EntityInf[mod.Entity.Deimos].VAR and entity.SubType == mod.EntityInf[mod.Entity.Deimos].SUB then

        if not data.Init then
            data.Init = true

            data.Timeout = 0

            sprite:Stop()
        end

        local orphan = not mod:OrbitParentMartians(entity, data, sprite, target)
        
        local targetAim = target.Position - entity.Position

		if (sprite:IsEventTriggered("SetAim") or entity.FrameCount%mod.MConst.DEIMOS_PERIOD==0) and entity.Parent:GetData().State ~= mod.MMSState.AIRSTRIKE and entity.Parent:GetData().State ~= mod.MMSState.LASER and entity.Parent:GetData().State ~= mod.MMSState.CHARGE then
			data.targetAim = target.Position

			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, target.Position, Vector.Zero, entity):ToEffect()
            data.Target = target
            data.Timeout = 38
            if target then
                target.Timeout = data.Timeout

                local targetSprite = target:GetSprite()
                targetSprite:ReplaceSpritesheet (0, "hc/gfx/effects/deimos_target.png")
                targetSprite:LoadGraphics()
            end

		elseif (sprite:IsEventTriggered("Shot") or data.Timeout==0) and data.targetAim then
			local distance = data.targetAim:Distance(entity.Position)
			if distance >= 75 then
				local direction = data.targetAim - entity.Position
				local laser = EntityLaser.ShootAngle(2, entity.Position + Vector(0,-10), direction:GetAngleDegrees(), 1, Vector.Zero, entity)
				data.targetAim = nil
			end
		end

        data.Timeout = data.Timeout - 1

        if orphan then
            local angle = -((targetAim:GetAngleDegrees() + 360) + 90 + 180) % 360

            local frame = math.floor( (angle) * 12 / 360) % 12
            sprite:SetFrame(frame)

        else
            local t = target.Position
            if data.targetAim then t = data.targetAim end

            local direction = t - entity.Position
            local angle = (direction:GetAngleDegrees() + 360)%360
            local frame = math.floor(angle/360 * 12)
            sprite:SetFrame(11-frame)
        end

		if (orphan and entity.FrameCount%4==0) then
            if data.targetAim then
				local direction = data.targetAim - entity.Position
				local laser = EntityLaser.ShootAngle(2, entity.Position + Vector(0,-10), direction:GetAngleDegrees(), 1, Vector.Zero, entity)
				data.targetAim = nil

            else
                data.targetAim = target.Position
            end
		end

	elseif entity.Variant == mod.EntityInf[mod.Entity.Phobos].VAR and entity.SubType == mod.EntityInf[mod.Entity.Phobos].SUB then

        if not data.Init then
            data.Init = true
            sprite:Stop()
        end

        local orphan = not mod:OrbitParentMartians(entity, data, sprite, target)

        local targetAim = target.Position - entity.Position

        if orphan then
            local angle = ((targetAim:GetAngleDegrees() + 360)-90) % 360

            local frame = math.floor( (angle) * 12 / 360) % 12
            sprite:SetFrame(frame)

        else

            local direction = target.Position - entity.Position
            local angle = (direction:GetAngleDegrees() + 360)%360
            local frame = math.floor(angle/360 * 12)
            sprite:SetFrame(frame)
        end

		if (orphan and entity.FrameCount%3==0) or ((sprite:IsEventTriggered("Shot") or entity.FrameCount%mod.MConst.PHOBOS_PERIOD==0) and entity.Parent and entity.Parent:GetData().State ~= mod.MMSState.CHARGE) then
            sfx:Play(Isaac.GetSoundIdByName("EnergyShot"),1)
			local velocity = targetAim:Normalized() * (mod.MConst.PHOBOS_SHOT_SPEED + ( (orphan and 10) or 0) )
            velocity = velocity + ( (orphan and entity.Velocity) or Vector.Zero)
			local shot =  mod:SpawnMarsShot(entity.Position, velocity, entity, true)

		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MartiansUpdate, mod.EntityInf[mod.Entity.Mars].ID)
function mod:MartiansDeath(entity)
	if entity.Variant ~= mod.EntityInf[mod.Entity.Mars].VAR then
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13)
		if entity.Variant ~= mod.EntityInf[mod.Entity.Mars].VAR then
			sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 2, false, 1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.MartiansDeath, mod.EntityInf[mod.Entity.Mars].ID)

function mod:OrbitParentMartians(entity, data, sprite, target)
    local r = mod:OrbitParent(entity)
    if not r then

        mod:ChaoticMartiansMove(entity, data, game:GetRoom(), target)
    end

    return r
end
function mod:ChaoticMartiansMove(entity, data, room, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.martiansConsts.IDLE_TIME_INTERVAL.X, mod.martiansConsts.IDLE_TIME_INTERVAL.Y)
		--distance of Saturn from the center of the room
		local distance = 0.95*(room:GetCenterPos().X-entity.Position.X)^2 + 2*(room:GetCenterPos().Y-entity.Position.Y)^2
		
		--If its too far away, return to the center
		if distance > mod.martiansConsts.CENTER_DISTANCE_TOLERATION^2 then
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.martiansConsts.SPEED
	data.targetvelocity = data.targetvelocity * 0.99
end

--Rocket boost
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DissapearAfterIdle, mod.EntityInf[mod.Entity.MarsBoost].VAR)

--Airstrike
function mod:AirstrikeUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.MarsTarget].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if data.Init == nil then
			data.Init = true
			sprite:Play("Blink",true)
			sprite:SetFrame(mod:RandomInt(1,90))
			entity.DepthOffset = -100
		end

		if sprite:IsFinished("Blink") then

			local airstrike = mod:SpawnEntity(mod.Entity.MarsAirstrike, entity.Position, Vector.Zero, entity.Parent)

			entity:Remove()
		end

	elseif entity.SubType == mod.EntityInf[mod.Entity.MarsAirstrike].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if sprite:IsFinished("Falling") then

			--Explosion:
			local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
			explosion.SpriteScale = Vector.One*1.5
			--Explosion damage
			for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.MConst.AIRSTRIKE_EXPLOSION_RADIUS)) do
				if entity_.Type ~= EntityType.ENTITY_PLAYER and not entity_:GetData().IsMartian then
					entity_:TakeDamage(mod.MConst.EXPLOSION_DAMAGE/2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
				elseif entity_.Type == EntityType.ENTITY_PLAYER then
					entity_:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
				end
			end

            for i, fracture in ipairs(mod:FindByTypeMod(mod.Entity.GlassFracture)) do
                if fracture.Position:Distance(entity.Position) < 10 then
                    fracture:Remove()
                end
            end
            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.5
            
			entity:Remove()
		end

	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.AirstrikeUpdate, mod.EntityInf[mod.Entity.MarsTarget].VAR)

--Laser sword
function mod:LaserSwordSpin(entity)
	local sprite = entity:GetSprite()

	local distance = 70
	local center1 = Vector(0, distance)
	local center2 = Vector(0, distance)

	if sprite:IsEventTriggered("Hit1") then
		center1 = entity.Position + center1:Rotated(0)
		center2 = entity.Position + center2:Rotated(45)
	elseif sprite:IsEventTriggered("Hit2") then
		center1 = entity.Position + center1:Rotated(90)
		center2 = entity.Position + center2:Rotated(90+45)
	elseif sprite:IsEventTriggered("Hit3") then
		center1 = entity.Position + center1:Rotated(180)
		center2 = entity.Position + center2:Rotated(180+45)
	elseif sprite:IsEventTriggered("Hit4") then
		center1 = entity.Position + center1:Rotated(270)
		center2 = entity.Position + center2:Rotated(270+45)
	end

	mod:LaserSwordDamage(entity,center1)
	mod:LaserSwordDamage(entity,center2)
end
function mod:LaserSwordAttack(entity)
	local sprite = entity:GetSprite()

	local center_ = Vector(71,0)
	local center = nil
	local angle = sprite.Rotation + 90
	
	if sprite:IsEventTriggered("Hit1") then
		center = entity.Position + center_:Rotated(angle-30)
	elseif sprite:IsEventTriggered("Hit2") then
		center = entity.Position + center_:Rotated(angle)
	elseif sprite:IsEventTriggered("Hit3") then
		center = entity.Position + center_:Rotated(angle+30)
	end

	mod:LaserSwordDamage(entity,center)
end
function mod:LaserSwordUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.LaserSword].SUB or entity.SubType == mod.EntityInf[mod.Entity.ErisNaue].SUB then
        local sprite = entity:GetSprite()

        if sprite:IsPlaying("Spin") then
            mod:LaserSwordSpin(entity)
        elseif sprite:IsPlaying("AttackCW") or sprite:IsPlaying("AttackCCW") then
            mod:LaserSwordAttack(entity)
        end

        if not entity.Parent then
            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.LaserSwordUpdate, mod.EntityInf[mod.Entity.LaserSword].VAR)

function mod:LaserSwordDamage(entity,center)
	if center then
		--Damage
		for i, e in ipairs(Isaac.FindInRadius(center, mod.MConst.LASER_SWORD_RADIUS)) do

            if e.Type == EntityType.ENTITY_PLAYER or e.Type == EntityType.ENTITY_FAMILIAR then
				e:TakeDamage(1, 0, EntityRef(entity.Parent), 0)

            elseif not (e:GetData().IsMartian) then

                if entity.Parent and entity.Parent:GetData().IsDwaft then--eris
                    e:TakeDamage(mod.KConst.ERIS_DAMAGE, 0, EntityRef(entity.Parent), 0)
                else--mars
					e:TakeDamage(mod.MConst.SWORD_DAMAGE, 0, EntityRef(entity.Parent), 0)
                end

				if e.Type == mod.EntityInf[mod.Entity.Charon2].ID then
					e.Velocity = (e.Position - entity.Position):Normalized()*15
				end
			end

			
			if e.Type == EntityType.ENTITY_TEAR then

                local tear = e:ToTear()
                if tear then
                    local projectile = nil
                    if tear.Variant == TearVariant.CHAOS_CARD then
                        projectile = mod:SpawnEntity(mod.Entity.ChaosCard, tear.Position, tear.Velocity, entity.Parent):ToProjectile()
                    else
                        projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, tear.Velocity, entity.Parent):ToProjectile()
                    end
    
                    projectile.Velocity = -tear.Velocity*1.5
                    if tear.Height then projectile.Height = tear.Height end
                    if tear.FallingAcceleration then projectile.FallingAccel = tear.FallingAcceleration end
                    if tear.FallingSpeed then projectile.FallingSpeed = tear.FallingSpeed end
                    
                    e:Remove()
    
                    sfx:Play(Isaac.GetSoundIdByName("SaberReflect"), 1, 2, false, 1)
                end

			elseif e.Type == EntityType.ENTITY_BOMB then
				local direction = Vector.FromAngle((center - entity.Position):GetAngleDegrees())
				e.Velocity = 40 * direction

				if e.Variant == BombVariant.BOMB_ROCKET then
					e:GetData().IsDirected_HC = true
					e:GetData().Direction = direction
					if direction.X > 0 then 
						e:GetSprite().FlipX = true 
					end
				end
			end
		end
	end
end

--Laser gun
function mod:LaserGunUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.MarsGun].SUB or entity.SubType == mod.EntityInf[mod.Entity.MarsLilGun].SUB then
        local parent = entity.Parent and entity.Parent:ToNPC()
        if parent then
            local sprite = entity:GetSprite()
            local data = entity:GetData()
            local target = parent:GetPlayerTarget()

            if not data.Init then
                data.Init = true

                entity.DepthOffset = -80
            end

            if sprite:IsFinished("Shot") then
                sprite:Play("Idle", true)
            end

            local onRight = target.Position.X > parent.Position.X
            local angoff = 0
            local s = 1
            if onRight then
                angoff = 0
                s = -1
                
                sprite.FlipX = true
                sprite.FlipY = false
            else
                angoff = 180

                sprite.FlipX = false
                sprite.FlipY = false
            end

            --[[
            local onRight = target.Position.X > parent.Position.X
            local offset = Vector(50,0)
            if onRight then 
                sprite.FlipX = false
                sprite.FlipY = false
            else
                offset.X = -offset.X
                
                sprite.FlipX = true
                sprite.FlipY = true
            end
            local targetPos = parent.Position + offset
            ]]
            local offset = Vector(-s*30, 0)
            if data.Double then
                if entity.SubType == mod.EntityInf[mod.Entity.MarsGun].SUB then
                    offset = Vector(30, 0)
                else
                    offset = Vector(-50, -20)
                end
            end
            local targetPos = parent.Position + offset

            entity.Velocity = (targetPos - entity.Position)/3

            local direction = target.Position - entity.Position
            sprite.Rotation = sprite.Rotation - angoff
            sprite.Rotation = mod:AngleLerp(sprite.Rotation, s*direction:GetAngleDegrees(), 0.1)
            sprite.Rotation = sprite.Rotation + angoff
        else
            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.LaserGunUpdate, mod.EntityInf[mod.Entity.MarsGun].VAR)

--Missile
function mod:MissileUpdate(tear, collider, collided)
    if tear.SubType == mod.EntityInf[mod.Entity.Missile].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()
    
        if data.Init == nil then
            data.Trigger = false
    
            sprite:Play("Idle", true)
            tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
            tear.FallingSpeed = 0
            tear.FallingAccel = -0.1
    
            data.Init = true
            data.Counter = 0
            data.Flag = false
    
            data.OldAngle = sprite.Rotation
        end
    
        sprite.Rotation = mod:AngleLerp(sprite.Rotation, tear.Velocity:GetAngleDegrees(), 0.5)
    
        data.OldAngle = sprite.Rotation
        data.Counter = data.Counter + 1
    
        if data.Counter >= mod.MConst.MISSILE_TIME and not data.Flag then
            data.Flag = true
            tear:AddProjectileFlags(ProjectileFlags.SMART_PERFECT)
        end
    
        --To near!
        if game:GetFrameCount()%4==0 and not data.Trigger then
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                if tear.Position:Distance(player.Position) < 70 then
                    sprite.Rotation = 0
                    sprite:Play("Explosion", true)
                    data.Trigger = true
                    tear:ClearProjectileFlags (ProjectileFlags.SMART_PERFECT)
                    tear:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
                    tear.Velocity = Vector.Zero
                    break
                end
            end
        end
    
    
        if sprite:IsFinished("Explosion") then
            --Explosion:
            local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, tear.Position, Vector.Zero, tear.Parent):ToEffect()
            --Explosion damage
            for i, entity in ipairs(Isaac.FindInRadius(tear.Position, mod.MConst.MISSILE_EXPLOSION_RADIUS)) do
                if entity.Type ~= EntityType.ENTITY_PLAYER and not entity:GetData().IsMartian then
                    entity:TakeDamage(mod.MConst.MISSILE_EXPLOSION_DAMAGE, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear.Parent), 0)
                elseif entity.Type == EntityType.ENTITY_PLAYER then
                    entity:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear.Parent), 0)
                end
            end
    
            --Projectile ring
            for i=1, mod.MConst.N_MISSILE_TEARS do
                local angle = i*360/mod.MConst.N_MISSILE_TEARS
                
                local shot = mod:SpawnMarsShot(tear.Position, Vector(1,0):Rotated(angle)*mod.MConst.MISSILE_TEAR_SPEED, tear.Parent)
            end
    
            tear:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.MissileUpdate, mod.EntityInf[mod.Entity.Missile].VAR)

--ChaosCard
function mod:ChaosCardUpdate(tear, collider, collided)
    if tear.SubType == mod.EntityInf[mod.Entity.ChaosCard].SUB then
        local data = tear:GetData()
        
        if not data.Init then
            data.Init = true
            
            tear:GetSprite():Load("gfx/002.009_Chaos Card Tear.anm2", true)
            tear:GetSprite():Play("Rotate",true)
            tear:AddProjectileFlags(ProjectileFlags.EXPLODE)  
        end

        if collider.Type == EntityType.ENTITY_PLAYER then
            collider:Kill()
    
            
            local projectile = mod:SpawnEntity(mod.Entity.ChaosCard, tear.Position, tear.Velocity, nil):ToProjectile()
            projectile:GetSprite():Play("Rotate",true)
            projectile:AddProjectileFlags(ProjectileFlags.EXPLODE)
            
            if tear.Height then projectile.Height = tear.Height end
            if tear.FallingAcceleration then projectile.FallingAccel = tear.FallingAcceleration end
            if tear.FallingSpeed then projectile.FallingSpeed = tear.FallingSpeed end
    
            tear:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.ChaosCardUpdate, mod.EntityInf[mod.Entity.ChaosCard].VAR)
