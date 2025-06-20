---@diagnostic disable: undefined-field
local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()


--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&%#((((((((((((((((##%&@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%((/////((((((((((((((((((((((#&@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%(((//////,,,,,,,*************/(((((((#%&@@@@@@@@@@@@@
@@@@@@@@@@@@&#((((///,,,,,,,,,,,,,,,,,,,,,,********(((((((#%@@@@@@@@@@
@@@@@@@@@@%((((((*,,,,,,,,,,,,,,,,,,,,,,,,,***********((((((%@@@@@@@@@
@@@@@@@@&#(((((***********,,,,,,,,,,,,,,,,,,*,***********(((((&@@@@@@@
@@@@@@@%(((((********,,,,,,,,,,,,,,,,,,,,,,,,***,,,********((((#@@@@@@
@@@@@@%((((******,,,,,,,,,,,,,,,,,,,,,,**,,,,,,,,,,*********((((#&@@@@
@@@@@%((((,***********/****,,,,,,,,,,,,,,(*******************/((((%@@@
@@@@%((((*******((//*,,,,,,,,,,,,,,,,,,,,,,********(*****,,,,,/(((#&@@
@@@&#(((/*//***/(((((*,,,,,,,,,,,,,,,,,,,/(((((((((/,,,*,......///(&@@
@@@%((((**/((#####(/(#/,,(,,,,,,,,,,*,,,*##*/(#((/#(((((,....,,*(((%@@
@@@%(((((((,*##*.  ,##,,,,,,,,,,,,,,*,,,,(##,../##*,,,((((,,,,,,(((#@@
@@@&#(((((,,,,,*##/#,,,,,,,,,,,,,,,*,,,,,,*/#(#/*,,,,,,((((,,,,,(((#@@
@@@@#(((((((,,,,/(*,,,/,,,,,/,,,,*,,,,,,,,,,*/,,,,,,,*(((,..,,,//((%@@
@@@@&((((,,,/,,,,*,,,*,,,,,/,,,,/,,,,,,/,,,,,/,,,,((((,,,,,,,,,((((@@@
@@@@@%((((,,,,,,,,,,,,,,,,*,,,,/,,,,,,/,,,,,*,,,,*,,,,,,,,,,,,((((%@@@
@@@@@@#(((/,,,*,,,*,,,,,,/(((((((((//*,,,,*,,,,*,,,,,,,,,,,,,((((&@@@@
@@@@@@@#((((,,,,,*,,,**((////(////////(*,,,,,,,,,,,,,,,,,,,*((((&@@@@@
@@@@@@@@#((((/,,,,,,,,,//////(/////(///,,,,,,,,,,,,,,,,***((((#@@@@@@@
@@@@@@@@@&#((((/*,,,,,,,(#(((*##(##(//,,,,,,**,,,,,*****((((#&@&@@@@@@
@@@@@@@@@@@@%(((((***,,,*(((((((((##*,,***,,,,,,,,,,,/((((#@@@@@@@@@@@
@@@@@@@@@@@@@@@%((((((*,,(#((((((((,,,,,,,,,,,,,,*////((&@@@@@@@@@@@@@
@@@@@@@@@&@@@@@@@@%#(((((((((((##*,,,,,,,,,/((((((((%&@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@%#(((((((((((((((((((((#%&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&@@@@@@@@&@@@&@&#%@@@@@@@@@@@@@
]]--
    
mod.VMSState = {
    APPEAR = 0,
    IDLE = 1,
    FLAME = 2,
    SUMMON = 3,
    IPECAC = 4,
    BALL = 5,
    BLAZE = 6,
    KISS = 7,
    SWARM = 8,
    SLAM = 9,
    LIT = 10
}
mod.chainV = {--                 A    I     F     S     Ip    Bll   B     K     Sw   Sl   Lit 
    [mod.VMSState.APPEAR] = 	{0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   0},
    --[mod.VMSState.IDLE] = 	    {0,   0,    0,    0,    0,    1,    0,    0,    0,   1,   0},
    [mod.VMSState.IDLE] = 	    {0,	  30,   1,    5,	3,    2,	3,    10,   2,   2, 20},
    [mod.VMSState.FLAME] =  	{0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   0},
    [mod.VMSState.SUMMON] = 	{0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   9},
    [mod.VMSState.IPECAC] = 	{0,   3,    0,    0,    0,    0,    0,    0,    1,   0,   0},
    [mod.VMSState.BALL] =  	    {0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   0},
    [mod.VMSState.BLAZE] =  	{0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   0},
    [mod.VMSState.KISS] = 	    {0,   1,    2,    0,    0,    0,    4,    0,    0,   1,   0},
    [mod.VMSState.SWARM] =  	{0,   2,    0,    0,    1,    1,    0,    0,    0,   0,   0},
    [mod.VMSState.SLAM] =   	{0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   0},
    [mod.VMSState.LIT] =    	{0,   1,    0,    0,    0,    0,    0,    0,    0,   0,   0}
}
mod.chainV = mod:NormalizeTable(mod.chainV)

mod.VConst = {--Some constant variables of Venus
    --GENERAL
    IDLE_TIME_INTERVAL = Vector(5,10),
    SPEED = 1.5,

	BURNINGS_FRAMES = 200,

    --FIREBALLS
    N_BLAZES_FAST = 2,
    BLAZE_ANGLE_FAST = 20,
    BLAZE_SPEED_FAST = 10.5,
    N_BLAZES_SLOW = 2,
    BLAZE_ANGLE_SLOW = 25,
    BLAZE_SPEED_SLOW = 7.5,

    --FLAMETHROWER
    N_FLATHROWER = 10,
    FLAME_PERIOD = 10,
    FLAME_ANGLE = 20,
    FLAME_ANGLE_START = 80,
    FLAME_SPEED = 6,

    --KISS
    KISS_SPEED = 35,
    KISS_HOMMING = 0.7,

    --EXPLOSION
    N_SLAM_FIRE_RING = 12,
    N_SLAM_FIREBALL = 8,

    --CANDLESTUFF
    SIREN_RESUMON_RATE = 7,
    SIREN_SUMMONS = 3,
    COLO_JUMPS_SPEED = 15,
    COLO_BOMB_TIME = 80,

    --RAGE
    N_RAGE_FIRE = 10,
    RAGE_FIRE_SPEED = 5,
    RAGE_FIRE_ANGLE = 12,
    RAGE_HP = 0.18,
    RAGE_COUNTER = 3,

}
function mod:SetVenusDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
        --                               A    I     F     S     Ip    Bll   B     K     Sw   Sl   Lit 
        mod.chainV[mod.VMSState.IDLE] = {0,	  40,   1,    5,	3,    0,	3,    10,   1,   1,   20}

        --GENERAL
        mod.VConst.BURNINGS_FRAMES = 100

        --FIREBALLS
        mod.VConst.N_BLAZES_FAST = 2
        mod.VConst.BLAZE_ANGLE_FAST = 10
        mod.VConst.N_BLAZES_SLOW = 1
        mod.VConst.BLAZE_ANGLE_SLOW = 12

        --FLAMETHROWER
        mod.VConst.FLAME_PERIOD = 15
        mod.VConst.FLAME_ANGLE = 40
        mod.VConst.FLAME_ANGLE_START = 110

        --EXPLOSION
        mod.VConst.N_SLAM_FIRE_RING = 3
        mod.VConst.N_SLAM_FIREBALL = 4

        --RAGE
        mod.VConst.RAGE_FIRE_ANGLE = 10

	elseif difficulty == mod.Difficulties.ATTUNED then
        --                               A    I     F     S     Ip    Bll   B     K     Sw   Sl   Lit 
        mod.chainV[mod.VMSState.IDLE] = {0,	  40,   1,    3,	3,    2,	3,    10,   1,   1,   20}

        --GENERAL
        mod.VConst.BURNINGS_FRAMES = 150

        --FIREBALLS
        mod.VConst.N_BLAZES_FAST = 2
        mod.VConst.BLAZE_ANGLE_FAST = 12
        mod.VConst.N_BLAZES_SLOW = 2
        mod.VConst.BLAZE_ANGLE_SLOW = 14

        --FLAMETHROWER
        mod.VConst.FLAME_PERIOD = 13
        mod.VConst.FLAME_ANGLE = 35
        mod.VConst.FLAME_ANGLE_START = 100

        --EXPLOSION
        mod.VConst.N_SLAM_FIRE_RING = 4
        mod.VConst.N_SLAM_FIREBALL = 5

        --RAGE
        mod.VConst.RAGE_FIRE_ANGLE = 12

    elseif difficulty == mod.Difficulties.ASCENDED then
        --                               A    I     F     S     Ip    Bll   B     K     Sw   Sl   Lit 
        mod.chainV[mod.VMSState.IDLE] = {0,	  40,   1,    0,	3,    5,	3,    10,   1,   1,   20}

        --GENERAL
        mod.VConst.BURNINGS_FRAMES = 200

        --FIREBALLS
        mod.VConst.N_BLAZES_FAST = 2
        mod.VConst.BLAZE_ANGLE_FAST = 14
        mod.VConst.N_BLAZES_SLOW = 2
        mod.VConst.BLAZE_ANGLE_SLOW = 16

        --FLAMETHROWER
        mod.VConst.FLAME_PERIOD = 11
        mod.VConst.FLAME_ANGLE = 30
        mod.VConst.FLAME_ANGLE_START = 90

        --EXPLOSION
        mod.VConst.N_SLAM_FIRE_RING = 5
        mod.VConst.N_SLAM_FIREBALL = 6

        --RAGE
        mod.VConst.RAGE_FIRE_ANGLE = 14

    end
    mod.chainV = mod:NormalizeTable(mod.chainV)
end

function mod:VenusUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Venus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Venus].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()
        
        --Custom data:
        if data.State == nil then 
            data.State = 0 
            data.StateFrame = 0

            data.Flamethrower = false
            data.FireWaveType = 0

            data.RageFlag = false
        end
        
        --Frame
        data.StateFrame = data.StateFrame + 1
        --data.State = 1
        
        if not data.RageFlag and entity.HitPoints < entity.MaxHitPoints * mod.VConst.RAGE_HP then
            data.RageFlag = true
            data.StateFrame = 0
        end

        if data.RageFlag then
            mod:VenusFire(entity, data, sprite, target, room)
        else
                
            if data.State == mod.VMSState.APPEAR then
                if data.StateFrame == 1 then
                    mod:AppearPlanet(entity)
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    
                    local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, entity.Position, Vector.Zero, entity):ToEffect()
                    glow:FollowParent(entity)
                    glow.SpriteScale = Vector.One*2
                    glow:GetSprite().Color = mod.Colors.fire

                elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                    data.State = mod:MarkovTransition(data.State, mod.chainV)
                    data.StateFrame = 0
                elseif sprite:IsEventTriggered("EndAppear") then
                    sfx:Play(Isaac.GetSoundIdByName("that_fucking_laught"), 1, 2, false, 1)
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
                
            elseif data.State == mod.VMSState.IDLE then
                if data.StateFrame == 1 then
                    sprite:Play("Idle",true)
                    for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE, 10)) do
                        e:Die()
                    end
                elseif sprite:IsFinished("Idle") then
                    data.State = mod:MarkovTransition(data.State, mod.chainV)
                    data.StateFrame = 0
                    
                else
                    mod:VenusMove(entity, data, room, target)
                end
                
            elseif data.State == mod.VMSState.KISS then
                mod:VenusKiss(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.FLAME then
                mod:VenusFlamethrower(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.IPECAC then
                mod:VenusIpecac(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.BLAZE then
                mod:VenusBlaze(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.SWARM then
                mod:VenusSwarm(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.SLAM then
                mod:VenusSlam(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.LIT then
                mod:VenusLit(entity, data, sprite, target,room)
            elseif data.State == mod.VMSState.BALL then
                mod:VenusBall(entity, data, sprite, target,room) --Too many attacks, need to make space for the summons
            elseif data.State == mod.VMSState.SUMMON then
                mod:VenusSummon(entity, data, sprite, target,room)
            end
        end

        --sfx:Stop(SoundEffect.SOUND_INSECT_SWARM_LOOP)
        --if game:GetFrameCount()%3==0 then
        --	game:SpawnParticles (entity.Position + Vector(0,-100), EffectVariant.EMBER_PARTICLE, 9, 5)
        --end
        
        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)
        for _, i in ipairs({3,6,7}) do
            local layer = sprite:GetLayer(i)
            layer:SetRotation(-sprite.Rotation*0.5)
        end
        local direction = target.Position - entity.Position
        if (direction.X < 0 and entity.Velocity.X > 0) or (direction.X > 0 and entity.Velocity.X < 0) then
            local layer = sprite:GetLayer(6)
            local rotation = mod:Lerp(layer:GetRotation(), -2*sprite.Rotation, 0.3)
            layer:SetRotation(rotation)
        end
    end
end
function mod:VenusFlamethrower(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("FlameStart",true)
        data.nFlamethrower = 0
        data.FlameAngle = mod.VConst.FLAME_ANGLE_START
        
        sfx:Play(Isaac.GetSoundIdByName("that_fucking_laught"), 1, 2, false, 1)
        --sfx:Play(Isaac.GetSoundIdByName("venus_angry"), 1, 2, false, 1)
        sfx:Play(SoundEffect.SOUND_DEATH_REVERSE,1)
        --sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE,1)
        
    elseif sprite:IsFinished("FlameStart") then

        if target.Position.X < entity.Position.X then
            sprite:Play("FlameRIdle",true)
        else
            sprite:Play("FlameLIdle",true)
        end
        sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/venus/venus_fire_side.png", true)

    elseif sprite:IsFinished("FlameRIdle") or sprite:IsFinished("FlameLIdle") then
        data.nFlamethrower = data.nFlamethrower + 1
        if data.nFlamethrower >= mod.VConst.N_FLATHROWER then
            if sprite:IsFinished("FlameRIdle") then
                sprite:Play("FlameREnd",true)
            else
                sprite:Play("FlameLEnd",true)
            end
        else
            if target.Position.X < entity.Position.X then
                sprite:Play("FlameRIdle",true)
            else
                sprite:Play("FlameLIdle",true)
            end
        end
        
    elseif sprite:IsFinished("FlameREnd") or sprite:IsFinished("FlameLEnd") then
        sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/venus/venus_fire.png", true)
        data.Flamethrower = false
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("SetAim") then
        entity.Velocity = Vector.Zero

        local y = room:GetCenterPos().Y
        if target.Position.X > entity.Position.X then -- to the left
            local x = room:GetTopLeftPos().X
            
            data.TargetPos = Vector(x,y)
        else -- to the right
            local x = room:GetBottomRightPos().X
            
            data.TargetPos = Vector(x,y)
        end

    elseif sprite:IsEventTriggered("FlameStart") then
        data.Flamethrower = true
        sfx:Play(Isaac.GetSoundIdByName("Flames"),4)
        
    end

    if data.Flamethrower then
        data.FlameAngle = data.FlameAngle - 1
        if data.FlameAngle < mod.VConst.FLAME_ANGLE then data.FlameAngle = mod.VConst.FLAME_ANGLE end

        local og_pos = entity.Position + Vector(0,-35) + Vector((target.Position - entity.Position).X, 0):Normalized()*40

        local velocity = Vector.Zero
        for i=0, 1 do
            if data.StateFrame%3 == 0 then
                
                velocity = (target.Position - og_pos):Normalized()*mod.VConst.FLAME_SPEED
                velocity = velocity:Rotated((data.FlameAngle + 10*rng:RandomFloat())*(2*i-1))
                local flame = mod:SpawnEntity(mod.Entity.Flame, og_pos, velocity, entity):ToProjectile()

                flame.FallingAccel  = -0.1
                flame.FallingSpeed = 0
                flame.Height = -7.5

                flame:AddProjectileFlags(ProjectileFlags.ACCELERATE)
                flame:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            end
        end
        
        --Do the actual movement
        entity.Velocity = (data.TargetPos - entity.Position)*0.05

        if data.StateFrame % mod.VConst.FLAME_PERIOD == 0 then
            local player_direction = target.Position - og_pos
            local velocity = player_direction:Normalized()*mod.VConst.FLAME_SPEED*1.5
            local flame = mod:SpawnEntity(mod.Entity.Flame, og_pos, velocity, entity):ToProjectile()

            flame.FallingAccel  = -0.1
            flame.FallingSpeed = 0
            flame.Height = -7.5
            flame.Scale = 2

            flame:GetData().EmberPos = -20 
    
            sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING,1,2,false,1)
        end
    end

end
function mod:VenusSummon(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        if #mod:GetCandles() == 0 then
            sprite:Play("Summon",true)

            sfx:Play(Isaac.GetSoundIdByName("venus_cought"), 1)
        else
            data.State = mod.VMSState.IDLE
            data.StateFrame = 0
        end
    elseif sprite:IsFinished("Summon") then
        sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        if data.StateFrame > 90 then
            data.State = mod:MarkovTransition(data.State, mod.chainV)
            data.StateFrame = 0
        else
            sprite:Play("Idle",true)
        end
    
    elseif sprite:IsEventTriggered("Summon") and #mod:GetCandles() == 0 then
        local candle = mod:SpawnEntity(mod.Entity.Candle, game:GetRoom():GetRandomPosition(0), Vector.Zero, entity)
        candle.Parent = entity
        
    elseif sprite:IsEventTriggered("Sound") then
    end
    mod:VenusMove(entity, data, room, target, 0.8)
end
function mod:VenusBlaze(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Blaze",true)
        sfx:Play(Isaac.GetSoundIdByName("venus_evil_laught"), 1, 2, false, 0.85 + 0.3*rng:RandomFloat())
    elseif sprite:IsFinished("Blaze") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then
        for i=1, mod.VConst.N_BLAZES_SLOW do
            local targetPos = target.Position:Rotated((2*rng:RandomFloat()-1)*mod.VConst.BLAZE_ANGLE_SLOW)
            local velocity = (targetPos - entity.Position):Normalized()*mod.VConst.BLAZE_SPEED_SLOW*(0.6 + 0.7*rng:RandomFloat())
            local fireball = mod:SpawnEntity(mod.Entity.Fireball, entity.Position, velocity, entity):ToProjectile()
            
            fireball.FallingSpeed = -10
            fireball.FallingAccel = 1.5
            
            fireball:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
        end
        
        for i=1, mod.VConst.N_BLAZES_FAST do
            local targetPos = target.Position:Rotated((2*rng:RandomFloat()-1)*mod.VConst.BLAZE_ANGLE_FAST)
            local velocity = (targetPos - entity.Position):Normalized()*mod.VConst.BLAZE_SPEED_FAST*(0.5 + 0.7*rng:RandomFloat())
            local fireball = mod:SpawnEntity(mod.Entity.Fireball, entity.Position, velocity, entity):ToProjectile()

            fireball.FallingSpeed = -10
            fireball.FallingAccel = 1.5
            
            fireball:AddProjectileFlags(ProjectileFlags.DECELERATE)
            fireball:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
        end
        
        sfx:Play(Isaac.GetSoundIdByName("Fireball"),2)

        for i=1, 3 do
            mod:scheduleForUpdate(function ()
        	    sfx:Play(Isaac.GetSoundIdByName("FireballBit"), 0.5)
            end, i*2)
        end
    end
end
function mod:VenusIpecac(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Ipecac",true)
    elseif sprite:IsFinished("Ipecac") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0
        data.FireWaveType = 1 - data.FireWaveType

    elseif sprite:IsEventTriggered("Attack") then

        local variance = (Vector(mod:RandomInt(-15, 15),mod:RandomInt(-15, 15))*0.03)
        local vector = (target.Position-entity.Position)*0.028 + variance
        
        local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, vector, entity):ToProjectile()
        if tear then
            tear.DepthOffset = 100

            tear:GetSprite().Color = mod.Colors.fire
            tear.Scale = 2
            tear.FallingSpeed = -45
            tear.FallingAccel = 1.5

            tear:AddProjectileFlags(ProjectileFlags.EXPLODE)
            tear:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
        
            local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, target.Position + variance, Vector.Zero, entity):ToEffect()
            if target then
                local targetSprite = target:GetSprite()
                target.Timeout = 20
    
                if data.FireWaveType == 1 then
                    targetSprite:ReplaceSpritesheet (0, "hc/gfx/effects/venus_target_+.png")
                    targetSprite:LoadGraphics()
                    tear:AddProjectileFlags(ProjectileFlags.FIRE_WAVE)
                else
                    targetSprite:ReplaceSpritesheet (0, "hc/gfx/effects/venus_target_X.png")
                    targetSprite:LoadGraphics()
                    tear:AddProjectileFlags(ProjectileFlags.FIRE_WAVE_X)
                end
                targetSprite.Color = Color.Default
            end
        end
        
        sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING,1,2,false,1)

    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,1,2,false,0.8)
    end
end
function mod:VenusBall(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        if #mod:GetCandles() == 0 then
            sprite:Play("Smash",true)
            sfx:Play(Isaac.GetSoundIdByName("venus_angry"),2, 2, false, 1+0.5*rng:RandomFloat())
        else
            data.State = mod.VMSState.IDLE
            data.StateFrame = 0
        end

    elseif sprite:IsFinished("Smash") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0
    
    elseif sprite:IsEventTriggered("Slam") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        
        sfx:Play(Isaac.GetSoundIdByName("Slam"), 1, 2, false, 1)
        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1)
        sfx:Play(SoundEffect.SOUND_HEARTOUT,1)

        local direction = target.Position - entity.Position
        local ball = mod:SpawnEntity(mod.Entity.CandleBall, entity.Position, direction, entity)
        ball.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        ball.Parent = entity
        ball:Update()
        

        local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
        bloody:GetSprite().Color = mod.Colors.wax
        
        game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.wax)

    elseif sprite:IsEventTriggered("Jump") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    end
end
function mod:VenusKiss(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        if mod:GetUnburnedPlayer() ~= nil then
            sfx:Play(Isaac.GetSoundIdByName("Kiss"), 3, 2, false, 1)
            sprite:Play("Kiss",true)
            
		    sfx:Play(Isaac.GetSoundIdByName("venus_giggle"),1,0,false,1);
        else
            data.State = mod:MarkovTransition(data.State, mod.chainV)
            data.StateFrame = 0
        end
    elseif sprite:IsFinished("Kiss") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then
        local target = mod:GetUnburnedPlayer()
        if target == nil then target = game:GetPlayer(0) end

		local player_direction = target.Position - entity.Position
        local velocity = player_direction:Normalized()*mod.VConst.KISS_SPEED
        local kiss = mod:SpawnEntity(mod.Entity.Kiss, entity.Position, velocity, entity):ToProjectile()
		kiss.FallingAccel  = -0.1
		kiss.FallingSpeed = 0
        kiss.HomingStrength = mod.VConst.KISS_HOMMING

        kiss:AddProjectileFlags(ProjectileFlags.SMART)
        --kiss:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)

        kiss:GetData().IsKiss_HC = true

    end
end
function mod:VenusSwarm(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        if #(mod:FindByTypeMod(mod.Entity.Ulcers)) >= 4 then
            data.State = mod:MarkovTransition(data.State, mod.chainV)
            data.StateFrame = 0
        else
            sprite:Play("Swarm",true)
        
            sfx:Play(Isaac.GetSoundIdByName("venus_angry"),2, 2, false, 1+0.5*rng:RandomFloat())
        end
    elseif sprite:IsFinished("Swarm") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Summon") then
        for i=1, 4 do
            if #(mod:FindByTypeMod(mod.Entity.Ulcers))<4 then
                local butter = mod:SpawnEntity(mod.Entity.Ulcers, entity.Position + mod:RandomVector(20,20), Vector.Zero, entity)
            end
        end
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE,2)

        game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.wax)
        
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		bloody:GetSprite().Color = mod.Colors.wax

    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_DEATH_REVERSE,2)
    end
end
function mod:VenusSlam(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Slam",true)
        sfx:Play(Isaac.GetSoundIdByName("venus_laught"), 1, 2, false, 1)
        
    elseif sprite:IsFinished("Slam") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Slam") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        sfx:Play(Isaac.GetSoundIdByName("Slam"), 1, 2, false, 1)

        local flame = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, 0, entity.Position, Vector.Zero, entity):ToProjectile()
        flame:AddProjectileFlags(ProjectileFlags.FIRE_WAVE)
        flame:Die()
        
        local flame = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, 0, entity.Position, Vector.Zero, entity):ToProjectile()
        flame:AddProjectileFlags(ProjectileFlags.FIRE_WAVE_X)
        flame:Die()

        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1)
        sfx:Play(SoundEffect.SOUND_HEARTOUT,1)
        sfx:Play(Isaac.GetSoundIdByName("Fireball"),2)
        game:ShakeScreen(20)

    elseif sprite:IsEventTriggered("Slam2") then
        local offset = rng:RandomFloat()*360
        for i=1, mod.VConst.N_SLAM_FIRE_RING do
            local angle = i*360/mod.VConst.N_SLAM_FIRE_RING + offset
            local velocity = Vector(1,0):Rotated(angle)*mod.VConst.FLAME_SPEED*1.5
            local flame = mod:SpawnEntity(mod.Entity.Flame, entity.Position, velocity, entity):ToProjectile()
            flame.FallingAccel  = -0.1
            flame.FallingSpeed = 0
            flame.Scale = 2
    
            flame:GetData().NoGrow = true
            flame:GetData().EmberPos = -20
        end
    elseif sprite:IsEventTriggered("Slam3") then
        local offset = rng:RandomFloat()*360
        for i=1, mod.VConst.N_SLAM_FIREBALL do
            local angle = i*360/mod.VConst.N_SLAM_FIREBALL + offset
            local velocity = Vector(1,0):Rotated(angle)*mod.VConst.BLAZE_SPEED_SLOW
            local fireball = mod:SpawnEntity(mod.Entity.Fireball, entity.Position, velocity, entity):ToProjectile()
            
            fireball.FallingSpeed = -20
            fireball.FallingAccel = 1.5
            
            fireball:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
        end

    elseif sprite:IsEventTriggered("Jump") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(SoundEffect.SOUND_ANGRY_GURGLE,1)
    end
end
function mod:VenusLit(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        local candleList = Isaac.FindByType(mod.EntityInf[mod.Entity.Candle].ID,mod.EntityInf[mod.Entity.Candle].VAR,mod.EntityInf[mod.Entity.Candle].SUB)
        if #(candleList) > 0 and not candleList[1]:GetSprite():IsPlaying("IdleLit") then
            sfx:Play(Isaac.GetSoundIdByName("Kiss"), 3, 2, false, 1)
            sprite:Play("Kiss",true)
        else
            data.State = mod.VMSState.IDLE
            data.State = mod:MarkovTransition(data.State, mod.chainV)
            data.StateFrame = 0
        end
    elseif sprite:IsFinished("Kiss") then
        data.State = mod:MarkovTransition(data.State, mod.chainV)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") and #mod:GetCandles() > 0 then
		local candle_direction = mod:GetCandles()[1].Position - entity.Position
        local velocity = candle_direction:Normalized()*mod.VConst.KISS_SPEED
        local kiss = mod:SpawnEntity(mod.Entity.Kiss, entity.Position+velocity*2, velocity, entity):ToProjectile()
		kiss.FallingAccel  = -0.1
		kiss.FallingSpeed = 0

        kiss:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)

        kiss:GetData().IsKiss_HC = true
    end
end
function mod:VenusFire(entity, data, sprite, target, room)

    if data.StateFrame == 1 then
        sprite:ReplaceSpritesheet(5, "hc/gfx/bosses/venus/venus_fire.png", true)
        sprite:Play("RageStart", true)
        data.RageCounter = 0

    elseif sprite:IsFinished("RageStart") then
        sprite:Play("RageIdle", true)

    elseif sprite:IsFinished("RageIdle") then
        data.RageCounter = data.RageCounter + 1
        if data.RageCounter >= mod.VConst.RAGE_COUNTER then
            data.RageCounter = 0
            sprite:Play("RageAttack", true)
        else
            sprite:Play("RageIdle", true)
        end

    elseif sprite:IsFinished("RageAttack") then
        sprite:Play("RageIdle", true)

    elseif sprite:IsEventTriggered("Attack") then
        local direction = (target.Position - entity.Position):Normalized()

        for i=1, mod.VConst.N_RAGE_FIRE do
            local newDirection = direction:Rotated( (2*rng:RandomFloat() - 1) * mod.VConst.RAGE_FIRE_ANGLE )
            local speed = (3 * rng:RandomFloat() + 1) * mod.VConst.RAGE_FIRE_SPEED

            local fire = mod:SpawnEntity(mod.Entity.Flame, entity.Position, newDirection * speed, entity):ToProjectile()
            fire:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)

            if rng:RandomFloat() <= 0.3 then
                fire:AddProjectileFlags(ProjectileFlags.DECELERATE)
            end
            if rng:RandomFloat() <= 0.1 then
                fire:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            end
        end

        for i=0, game:GetNumPlayers ()-1 do
            local player = game:GetPlayer(i)
            mod:BurnPlayer(player, 1000)
        end

        for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE, 10)) do
            e:Die()
        end

        sfx:Play(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,1,2,false,0.95)

        entity.HitPoints = entity.HitPoints - 10
        
        if mod.savedatasettings().Difficulty == mod.Difficulties.ASCENDED then
            local velocity = (target.Position - entity.Position):Normalized()*mod.VConst.BLAZE_SPEED_SLOW
            local fireball = mod:SpawnEntity(mod.Entity.Fireball, entity.Position, velocity, entity):ToProjectile()
            
            fireball.FallingSpeed = -10
            fireball.FallingAccel = 1.5
            
            fireball:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
        end

    elseif sprite:IsEventTriggered("Slam") then
        
        data.ExplosionDone = true

		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		bloody:GetSprite().Color = mod.Colors.wax
		local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
		explosion:GetSprite().Color = mod.Colors.fire
        
	    game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.wax)

        for i=1, 5 do
            local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, entity.Position, Vector.Zero, entity):ToEffect()
            glow:FollowParent(entity)
            glow.SpriteScale = Vector.One*3.5
            glow:GetSprite().Color = Color(1,0.3,0,1)
        end

        --local flower = mod:SpawnEntity(mod.Entity.ICUP, entity.Position + Vector(0,-40), Vector.Zero, entity):ToEffect()
        --flower.SpriteScale = Vector.One * 1.3
        --flower.DepthOffset = -50
        --flower:FollowParent(entity)
        --flower:GetSprite():Play("FlowerStart", true)


        local flame = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, 0, entity.Position, Vector.Zero, entity):ToProjectile()
        flame:AddProjectileFlags(ProjectileFlags.FIRE_WAVE)
        flame:Die()
        
        local flame = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, 0, entity.Position, Vector.Zero, entity):ToProjectile()
        flame:AddProjectileFlags(ProjectileFlags.FIRE_WAVE_X)
        flame:Die()

        game:ShakeScreen(20)

        for i=1, mod.VConst.N_SLAM_FIRE_RING do
            local angle = i*360/mod.VConst.N_SLAM_FIRE_RING
            local velocity = Vector(1,0):Rotated(angle)*mod.VConst.FLAME_SPEED*1.5
            local flame = mod:SpawnEntity(mod.Entity.Flame, entity.Position, velocity, entity):ToProjectile()
            flame.FallingAccel  = -0.1
            flame.FallingSpeed = 0
            flame.Scale = 2
    
            flame:GetData().NoGrow = true
            flame:GetData().EmberPos = -20
        end
        
        sfx:Play(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,1,2,false,0.8)
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE,2)
        
        for _, e in ipairs(mod:GetCandles()) do
            e:Die()
        end

        mod:EnableWeather(mod.WeatherFlags.HEAT)

    elseif sprite:IsEventTriggered("Sound") then
		--sfx:Play(Isaac.GetSoundIdByName("Chomp"),1,0,false,0.7);
        sfx:Play(SoundEffect.SOUND_DEATH_REVERSE,2)
    end

    if data.ExplosionDone then
        
    end

    mod:VenusMove(entity, data, room, target, 0.9)
end

--Move
function mod:VenusMove(entity, data, room, target, speed)   
    if speed == nil then speed = 1 end
    --idle move taken from 'Alt Death' by hippocrunchy
    --It just basically stays around a something
    
    --idleTime == frames moving in the same direction
    if not data.idleTime then 
        data.idleTime = mod:RandomInt(mod.VConst.IDLE_TIME_INTERVAL.X, mod.VConst.IDLE_TIME_INTERVAL.Y)

        local antipode = (target.Position - room:GetCenterPos()):Rotated(180):Normalized()*150 + room:GetCenterPos()
        --V distance of Venus from the oposite place of the player
        local distance = antipode:Distance(entity.Position)
        
        --If its too far away, return to the center
        if distance > 40 then
            data.targetvelocity = ((antipode - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
        end

        --Not that close to the plater
        if target.Position:Distance(entity.Position) < 100  or data.targetvelocity == nil then
            data.targetvelocity = (-(target.Position - entity.Position):Normalized()*6):Rotated(mod:RandomInt(-45, 45))
        end
    end
    
    --If run out of idle time
    if data.idleTime <= 0 and data.idleTime ~= nil then
        data.idleTime = nil
    else
        data.idleTime = data.idleTime - 1
    end
    
    --Do the actual movement
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.VConst.SPEED * speed
    data.targetvelocity = data.targetvelocity * 0.99
end

--ded
function mod:VenusDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Venus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Venus].SUB then
        for _, e in ipairs(mod:GetCandles()) do
            e:Die()
        end
        for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT)) do
            e:Remove()
        end
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.ICUP)) do
            e:Remove()
        end

        for i=0, game:GetNumPlayers ()-1 do
            local player = game:GetPlayer(i)
            mod:BurnPlayer(player, 0)
        end

        mod:DisableWeather(mod.WeatherFlags.HEAT)
        mod:NormalDeath(entity, false, true)
    end
end
--deding
function mod:VenusDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Venus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Venus].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
        
        if data.deathFrame == nil then data.deathFrame = 1 end
    
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            mod.ShaderData.venusCounter = (mod.ShaderData.venusCounter and (mod.ShaderData.venusCounter - 10)) or 0

            if data.deathFrame == 2 then
                sfx:Play(Isaac.GetSoundIdByName("venus_pain"), 1, 2, false, 2)
            end
        end
    end
end

--Get random player thats not burning
function mod:GetUnburnedPlayer()
    local unburnedPlayers = {}
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if not mod:IsPlayerBurning(player) then 
			unburnedPlayers[#unburnedPlayers+1]=player
		end
	end
    if #unburnedPlayers > 0 then
        local player = unburnedPlayers[mod:RandomInt(1,#unburnedPlayers)]
        return player
    end
    return nil
end

--Get candle summons
function mod:GetCandles()
    local candles = Isaac.FindByType(mod.EntityInf[mod.Entity.Candle].ID)
    return candles
end

--Callbacks
--Venus updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.VenusUpdate, mod.EntityInf[mod.Entity.Venus].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.VenusDeath, mod.EntityInf[mod.Entity.Venus].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.VenusDying, mod.EntityInf[mod.Entity.Venus].ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, _, flags, _, _)
	if entity.Variant == mod.EntityInf[mod.Entity.Venus].VAR and entity.SubType == mod.EntityInf[mod.Entity.Venus].SUB and (flags & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE) then
		return false
	end
end)

--OTHERS--------------------------------------------
--Ulcers
function mod:UlcersUpdate(entity)
	if mod.EntityInf[mod.Entity.Ulcers].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()

		if sprite:IsPlaying("Attack") and sprite:GetFrame() == 1 and rng:RandomFloat() < 0.67 then
			sprite:Play("Fly",true)
		end

		if sprite:IsEventTriggered("Fireball") then
			local velocity = (target.Position - entity.Position):Normalized()*mod.VConst.BLAZE_SPEED_SLOW*(0.3 + 0.6*rng:RandomFloat())
			local fireball = mod:SpawnEntity(mod.Entity.Fireball, entity.Position, velocity, entity):ToProjectile()

			fireball:GetSprite().Scale = Vector(1,1)*0.75
			
			fireball.FallingSpeed = -20
			fireball.FallingAccel = 1.5
			
			fireball:AddProjectileFlags(ProjectileFlags.FIRE_SPAWN)
			
        	sfx:Play(Isaac.GetSoundIdByName("FireballBit"),1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UlcersUpdate, mod.EntityInf[mod.Entity.Ulcers].ID)

--Candles
mod.CandleGirs = {
	[1] = mod.Entity.CandleSiren,
	[2] = mod.Entity.CandleGurdy,
	[3] = mod.Entity.CandleColostomia,
	[4] = mod.Entity.CandleMist
}
if BossButch then
    table.insert(mod.CandleGirs, mod.Entity.CandleDevil)
end

--States and matrix
mod.SirenMSTATE = {
	APPEAR = 0,
	SING = 1,
	ANNOYED = 2,
	AMBUSH = 3
}
mod.chainSiren = {          
	[mod.SirenMSTATE.APPEAR] = 	{0,  1,  0,  0},
	[mod.SirenMSTATE.SING] = 	{0,  1,  0,  0},
	[mod.SirenMSTATE.ANNOYED] = {0,  0,  0,  1},--This last two does nothing, I know why they do nothing, I just dont care anymore
	[mod.SirenMSTATE.AMBUSH] = 	{0,  1,  0,  0}
}

mod.GurdyMSTATE = {
	APPEAR = 0,
	TAUNT = 1,
	SUMMON = 2
}
mod.chainGurdy = {          
	[mod.GurdyMSTATE.APPEAR] = 	{0,  1,   0},
	[mod.GurdyMSTATE.TAUNT] = 	{0,  0.60,0.40},
	[mod.GurdyMSTATE.SUMMON] = 	{0,  1,   0}
}

mod.ColostomiaMSTATE = {
	APPEAR = 0,
	IDLE = 1,
	JUMP = 2,
	BOMB = 3
}
mod.chainColostomia = {
	[mod.ColostomiaMSTATE.APPEAR] = {0,  1,    0,    0},
	[mod.ColostomiaMSTATE.IDLE] = 	{0,  0.6,  0.20, 0.20},
	[mod.ColostomiaMSTATE.JUMP] = 	{0,  1,    0,    0},
	[mod.ColostomiaMSTATE.BOMB] = 	{0,  1,    0,    0}
}

mod.MaidMSTATE = {
	APPEAR = 0,
	IDLE = 1,
	ATTACK = 2
}
mod.chainMaid = {
	[mod.MaidMSTATE.APPEAR] = 	{0,  1,    0},
	[mod.MaidMSTATE.IDLE] = 	{0,  0.80, 0.20},
	[mod.MaidMSTATE.ATTACK] = 	{0,  1,    0}
}

mod.DevilMSTATE = {
	APPEAR = 0,
	IDLE = 1,
	ATTACK = 2
}
mod.chainDevil = {
	[mod.DevilMSTATE.APPEAR] = 	{0,  1,    0},
	[mod.DevilMSTATE.IDLE] = 	{0,  0.8, 0.2},
	[mod.DevilMSTATE.ATTACK] = 	{0,  1,    0}
}

function mod:CandleUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	local target = entity:GetPlayerTarget()
	local room = game:GetRoom()

	if data.State == nil then
        data.State = 0
        
        entity.SplatColor = mod.Colors.wax
    end
	if data.StateFrame == nil then data.StateFrame = 0 end

	--Frame
	data.StateFrame = data.StateFrame + 1

	if data.GlowInit == nil and entity.Variant ~= mod.EntityInf[mod.Entity.Candle].VAR then
		data.GlowInit = true
		local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, entity.Position, Vector.Zero, entity):ToEffect()
		glow:FollowParent(entity)
		glow.SpriteScale = Vector.One*1.5
		glow:GetSprite().Color = mod.Colors.fire
	end

	if mod.EntityInf[mod.Entity.Candle].VAR == entity.Variant then

		if data.Init == nil then
			data.Init = true

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		
			if not mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
				entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			end

			sprite:Play("Appear", true) 
			mod:scheduleForUpdate(function()
			sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1.2,2,false,0.5)
			end, 20)
		end

		entity.Velocity = Vector.Zero

		if sprite:IsFinished("Appear") then 
			sprite:Play("Idle", true) 
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		elseif sprite:IsFinished("IdleLit") then 
			sprite:Play("Transform", true)
		elseif sprite:IsFinished("Transform") then

			mod:SpawnCandleGirlSummon(entity)
            entity:Remove()
		end
		
	elseif mod.EntityInf[mod.Entity.CandleSiren].VAR == entity.Variant then
		if data.SirenResummonCount == nil then data.SirenResummonCount = 0 end
		sfx:Stop (SoundEffect.SOUND_SIREN_SING_STAB)

		if data.State == mod.SirenMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.SirenMSTATE.SING then

            local spawnSirens = function ()
                for i, siren in ipairs(Isaac.FindByType(EntityType.ENTITY_SIREN)) do
                    if siren:GetData().IsRagdoll then
                        siren:Remove()
                    end
                end

				for i=1, mod.VConst.SIREN_SUMMONS do
					local sirenRag = mod:SpawnEntity(mod.Entity.SirenRag, entity.Position, Vector.Zero, entity)
                    sirenRag:GetData().IsRagdoll = true
					sirenRag.Parent = entity
					mod:SirenRagSprite(sirenRag)
				end
            end

			if data.StateFrame == 1 then
				sprite:Play("SingStart",true)
                spawnSirens()

			elseif sprite:IsFinished("SingStart") then
				sprite:Play("SingLoop",true)
                data.SirenResummonCount = 0

			elseif sprite:IsFinished("SingLoop") then
				local sirenRags = mod:FindByTypeMod(mod.Entity.SirenRag)
				if data.SirenResummonCount < 8 and #(sirenRags)>0 then
					sprite:Play("SingLoop",true)
					data.SirenResummonCount = data.SirenResummonCount + 1
				else
					sprite:Play("SingEnd",true)
				end

			elseif sprite:IsFinished("SingEnd") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
				
			elseif sprite:IsEventTriggered("Sing") then
				sfx:Play(SoundEffect.SOUND_SIREN_SING)

			end

			--Movement
			if entity.Parent then
				local parent = entity.Parent
				--idleTime == frames moving in the same direction
				if not data.idleTime then 
					data.idleTime = mod:RandomInt(mod.VConst.IDLE_TIME_INTERVAL.X, mod.VConst.IDLE_TIME_INTERVAL.Y)

					if parent.Position:Distance(entity.Position) < 100 then
						data.targetvelocity = (-(parent.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-45, 45))
					else
						data.targetvelocity = ((parent.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
					end
				end
				
				--If run out of idle time
				if data.idleTime <= 0 and data.idleTime ~= nil then
					data.idleTime = nil
				else
					data.idleTime = data.idleTime - 1
				end
				
				--Do the actual movement
				entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * 1.2
				data.targetvelocity = data.targetvelocity * 0.99
			end

		elseif data.State == mod.SirenMSTATE.ANNOYED then
			if data.StateFrame == 1 then
				sprite:Play("Teleport",true)
				entity.Velocity = Vector.Zero
				entity.CollisionDamage = 0
			elseif sprite:IsFinished("Teleport") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
			end

		elseif data.State == mod.SirenMSTATE.AMBUSH then
			if data.StateFrame == 1 then
				sprite:Play("Revive",true)
				entity.Velocity = Vector.Zero
				entity.Position = target.Position
			elseif sprite:IsFinished("Revive") then
				data.State = mod:MarkovTransition(data.State, mod.chainSiren)
				data.StateFrame = 0
			
			elseif sprite:IsEventTriggered("Reappear") then
				entity.CollisionDamage = 1

			end

		end

	elseif mod.EntityInf[mod.Entity.CandleGurdy].VAR == entity.Variant then
		entity.Velocity = Vector.Zero
		if data.State == mod.GurdyMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
				entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
				entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainGurdy)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.GurdyMSTATE.TAUNT then
			if data.StateFrame == 1 then
				sprite:Play("Idle"..tostring(mod:RandomInt(1,3)),true)

				if tostring(mod:RandomInt(2,3)) == 2 then
					sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,0.8,2,false,2)
				else
					sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_4,0.8,2,false,2)
				end
				
			elseif sprite:IsFinished("Idle1") or sprite:IsFinished("Idle2") or sprite:IsFinished("Idle3") then
				data.State = mod:MarkovTransition(data.State, mod.chainGurdy)
				data.StateFrame = 0
				
			end
			
		elseif data.State == mod.GurdyMSTATE.SUMMON then
			if data.StateFrame == 1 then
				sprite:Play("Attack"..tostring(mod:RandomInt(1,3)),true)
			elseif sprite:IsFinished("Attack1") or sprite:IsFinished("Attack2") or sprite:IsFinished("Attack3") then
				data.State = mod:MarkovTransition(data.State, mod.chainGurdy)
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("Summon") then
				if #mod:FindByTypeMod(mod.Entity.Ulcers) < 4 then
					local butter = mod:SpawnEntity(mod.Entity.Ulcers, entity.Position, Vector.Zero, entity)
					sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
				end
				
			end

		end
	elseif mod.EntityInf[mod.Entity.CandleColostomia].VAR == entity.Variant then
		if data.State == mod.ColostomiaMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.ColostomiaMSTATE.IDLE then

			entity.Velocity = entity.Velocity / 2

			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0
				
			end
			
		elseif data.State == mod.ColostomiaMSTATE.JUMP then
			if data.StateFrame == 1 then
				sprite:Play("Jump",true)
			elseif sprite:IsFinished("Jump") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("Land") then
				game:ShakeScreen(10)
				entity.Velocity = Vector.Zero

			elseif sprite:IsEventTriggered("Jump") then
				local direction = target.Position - entity.Position
                if entity.Parent then
                    direction = entity.Parent.Position - entity.Position
                end
				local velocity = direction:Normalized()*mod.VConst.COLO_JUMPS_SPEED
				entity.Velocity = velocity
				
				sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,2,false,0.5)
				
			end
			
		elseif data.State == mod.ColostomiaMSTATE.BOMB then
			if data.StateFrame == 1 then
				
				if target.Position.X - entity.Position.X > 0 then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end

				sprite:Play("Attack",true)
			elseif sprite:IsFinished("Attack") then
				data.State = mod:MarkovTransition(data.State, mod.chainColostomia)
				data.StateFrame = 0
				
			elseif sprite:IsEventTriggered("Bomb") then
				
				if target.Position.X - entity.Position.X > 0 then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end
				
				local target_pos = target.Position - entity.Position
				local velocity = target_pos:Normalized()*15

				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_BUTT, 0, entity.Position + velocity, velocity, entity):ToBomb()
                if bomb then
                    bomb:GetSprite().Color = mod.Colors.buttFire
                    bomb:SetExplosionCountdown(mod.VConst.COLO_BOMB_TIME)
                    bomb:AddTearFlags(TearFlags.TEAR_BURN)

                    bomb.ExplosionDamage = 10
                    
                    sfx:Play(SoundEffect.SOUND_FART,1)
                end
			end

		end
	elseif mod.EntityInf[mod.Entity.CandleMist].VAR == entity.Variant then
		if data.State == mod.MaidMSTATE.APPEAR then
			if data.StateFrame == 1 then
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.MaidMSTATE.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0
				
			end

			--Movement
			if entity.Parent then
				local parent = entity.Parent
				--idleTime == frames moving in the same direction
				if not data.idleTime then 
					data.idleTime = mod:RandomInt(mod.VConst.IDLE_TIME_INTERVAL.X, mod.VConst.IDLE_TIME_INTERVAL.Y)

					if parent.Position:Distance(entity.Position) < 75 then
						data.targetvelocity = (-(parent.Position - entity.Position):Normalized()*3):Rotated(mod:RandomInt(-45, 45))
					else
						data.targetvelocity = ((parent.Position - entity.Position):Normalized()):Rotated(mod:RandomInt(-10, 10))
					end
				end
				
				--If run out of idle time
				if data.idleTime <= 0 and data.idleTime ~= nil then
					data.idleTime = nil
				else
					data.idleTime = data.idleTime - 1
				end
				
				--Do the actual movement
				entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * 1.2
				data.targetvelocity = data.targetvelocity * 0.99
			end
			
		elseif data.State == mod.MaidMSTATE.ATTACK then
			if data.StateFrame == 1 then
				if target.Position.X - entity.Position.X > 0 then
					sprite:Play("AttackR",true)
				else
					sprite:Play("AttackL",true)
				end
			elseif sprite:IsFinished("AttackL") or sprite:IsFinished("AttackR") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("Attack") then

				local direction = (data.TargetPos - entity.Position):Normalized()
				local velocity = direction*mod.VConst.FLAME_SPEED*1.5
				local number = direction.X
				local sign = number > 0 and 1 or (number == 0 and 0 or -1)
				local flame = mod:SpawnEntity(mod.Entity.Flame, entity.Position + Vector(sign * 10,0), velocity, entity):ToProjectile()
				flame.FallingAccel  = -0.1
				flame.FallingSpeed = 0
				flame.Scale = 2
		
				flame:GetData().NoGrow = true
				flame:GetData().EmberPos = -20
				
				sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING,1,2,false,1)

			elseif sprite:IsEventTriggered("SetAim") then

				data.TargetPos = target.Position
				
				if data.TargetPos.X - entity.Position.X > 0 then
					sprite:SetAnimation ("AttackR",false)
				else
					sprite:SetAnimation ("AttackL",false)
				end
			end

		end
    elseif mod.EntityInf[mod.Entity.CandleDevil].VAR == entity.Variant then

        local distance = 120

        if not data.Init then
            data.Init = true

            local layer = sprite:GetLayer(1)
            layer:SetPos(Vector(0,15))

            
            local layer = sprite:GetLayer(2)
            layer:SetPos(Vector(0,-10))
        end

		if data.State == mod.DevilMSTATE.APPEAR then
			if data.StateFrame == 1 then
                data.FirstAttack = true
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear",true)
			elseif sprite:IsFinished("Appear") then
				data.State = mod:MarkovTransition(data.State, mod.chainMaid)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.DevilMSTATE.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
                if target.Position:Distance(entity.Position) < distance*2 then
                    data.State = mod:MarkovTransition(data.State, mod.chainMaid)
                    data.StateFrame = 0
                else
                    sprite:Play("Idle",true)
                end
			end

            if target.Position:Distance(entity.Position) > distance then
                local direction = target.Position - entity.Position
                entity.Velocity = mod:Lerp(entity.Velocity, direction/30, 0.03)
            else
                entity.Velocity = entity.Velocity * 0.9
            end
			
		elseif data.State == mod.DevilMSTATE.ATTACK then
			if data.StateFrame == 1 then
                sprite:Play("Angry",true)
                data.FirstAttack = true
                sfx:Play(SoundEffect.SOUND_MOUTH_FULL, 0.5)
                
			elseif sprite:IsFinished("Angry") then
                sprite:Play("Attack",true)
                data.TargetDirection = (target.Position - entity.Position):Normalized()
                entity.Velocity = -data.TargetDirection * 5
                
			elseif sprite:IsFinished("Attack") then
                if data.FirstAttack then
                    data.FirstAttack = false
                    sprite:Play("AttackIdle",true)
                    sfx:Play(SoundEffect.SOUND_GHOST_ROAR, 0.8)
                else
                    data.State = mod:MarkovTransition(data.State, mod.chainMaid)
                    data.StateFrame = 0
                end
                
			elseif sprite:IsFinished("AttackIdle") then
                if true or data.StateFrame > 60 or (not room:IsPositionInRoom(entity.Position, 0)) then
                    sprite:Play("Attack",true)
                    entity.Velocity = entity.Velocity*0.5
                    sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 0.8)
                else
                    sprite:Play("AttackIdle",true)
                end
			end

            
			if sprite:IsPlaying("AttackIdle") then
                entity.Velocity = mod:Lerp(entity.Velocity, data.TargetDirection*25, 0.25)

                if entity.FrameCount % 2 == 0 then
                    local fire = mod:SpawnEntity(mod.Entity.Flame, entity.Position, Vector.Zero, entity)
                    fire:GetData().NoRot = true
                    fire:GetSprite().Rotation = 90
                end
            elseif not sprite:IsPlaying("Attack") then
                entity.Velocity = entity.Velocity * 0.8
            end

		end

        for i=1, 2 do
            local layer = sprite:GetLayer(i)

            if false and entity.Velocity:Length() < 2 then
                layer:SetRotation(mod:AngleLerp(layer:GetRotation(), 0, 0.05))
            else
                        
                --local xvel = entity.Velocity.X * 10
                --layer:SetRotation(mod:Lerp(layer:GetRotation(), -xvel, 0.1))
    
                layer:SetRotation(mod:AngleLerp(layer:GetRotation(), entity.Velocity:GetAngleDegrees()-90, 0.2))
            end
        end
                        
        if entity.FrameCount%3==0 then
            --For tracing
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, entity.Position + Vector(0,-40), Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Scale = 2*Vector(1,1)
            if entity.FrameCount%2==0 then
                cloud:GetSprite().Color = mod.Colors.lesbian
            else
                cloud:GetSprite().Color = mod.Colors.superFire
            end
        end
    elseif mod.EntityInf[mod.Entity.CandleBall].VAR == entity.Variant then
        mod:CandleBallUpdate(entity, sprite, data, room)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CandleUpdate, mod.EntityInf[mod.Entity.Candle].ID)

function mod:CandleBallUpdate(entity, sprite, data, room)

    if not data.Init then
        data.Init = true
        data.CollisionCount = 0

        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        sprite:Play("Idle",true)
    
        data.Direction = data.Direction or entity.Velocity:Normalized()
    end
    
    if entity.Velocity.X > 0 and not sprite:IsPlaying("Idle") then
        sprite:Play("Idle",true)
    elseif entity.Velocity.X <= 0 and not sprite:IsPlaying("Idle2") then
        sprite:Play("Idle2",true)
    end

    entity.Velocity = data.Direction * 8

    entity.SpriteOffset = Vector(0, -math.abs(math.sin(entity.FrameCount*0.25))*40)
    if entity.SpriteOffset.Y > -5 then
        sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1)
        
        local fire = mod:SpawnEntity(mod.Entity.Flame, entity.Position, Vector.Zero, entity):ToProjectile()
        fire:GetData().NoRot = true
        fire:GetSprite().Rotation = 90
        fire.SpriteOffset = Vector(0, 15)
        mod:TearFallAfter(fire, 60)

        
		local wax = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, entity.Position, Vector.Zero, nil):ToEffect()
		if wax then
			wax:Update()
			local sprite = wax:GetSprite()
            
			wax.CollisionDamage = 0
			wax.Timeout = 60
			local color = Color(1,1,1,1, mod.Colors.wax.RO, mod.Colors.wax.GO, mod.Colors.wax.BO*0.75)
			color.A = color.A*0.5
			wax:SetColor(color, -1, 1, false, false)
		end
    end

    if entity:CollidesWithGrid() then
        if data.CollisionCount > 3 then
            mod:SpawnCandleGirlSummon(entity)
            entity:Die()
        else
            data.CollisionCount = data.CollisionCount + 1
            sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1)
            mod:scheduleForUpdate(function()
                data.Direction = entity.Velocity:Normalized():Rotated(mod:RandomInt(-5,5))
            end, 2)
        end
    end
end

local chosenCandles = {}
function mod:SpawnCandleGirlSummon(entity)
    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil):ToEffect()
    sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)

    local entity2Transform = mod.CandleGirs[mod:RandomInt(1,#mod.CandleGirs)]
    --Dont spawn Siren if theres a Lilith or there are no familiars
    for i=1, 20 do
        if mod:IsThereLilith() or (#Isaac.FindByType(EntityType.ENTITY_FAMILIAR)==0) or chosenCandles[mod.EntityInf[entity2Transform].VAR] then
            entity2Transform = mod.CandleGirs[mod:RandomInt(2,#mod.CandleGirs)]
        end
        if i == 20 then
            chosenCandles = {}
        end
    end
    
    local candleGirl = mod:SpawnEntity(entity2Transform, entity.Position, Vector.Zero, entity.Parent)
    candleGirl.Parent = entity.Parent

    chosenCandles[candleGirl.Variant] = true
end

function mod:OnCandleDeath(entity)
	for _, e in ipairs(mod:FindByTypeMod(mod.Entity.SirenRag)) do
		e:Remove()
	end

	local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
	bloody:GetSprite().Color = mod.Colors.wax
	
	game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 20, 13, mod.Colors.wax)

	if entity.Child then entity.Child:Die() end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnCandleDeath, mod.EntityInf[mod.Entity.Candle].ID)
function mod:CandleLit(tear, collider)
	if collider.Type == mod.EntityInf[mod.Entity.Candle].ID and collider.Variant == mod.EntityInf[mod.Entity.Candle].VAR then
		collider:GetSprite():Play("IdleLit",true)
		collider:GetData().GlowInit = true
		local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, collider.Position, Vector.Zero, collider):ToEffect()
		glow:FollowParent(collider)
		glow.SpriteScale = Vector.One*1.5
		glow:GetSprite().Color = mod.Colors.fire
		collider.Child = glow

		local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector.Zero, nil):ToEffect()
		cloud:GetSprite().Color = mod.Colors.fire
		tear:Remove()
		
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.CandleLit, mod.EntityInf[mod.Entity.Kiss].VAR)


--Siren rag doll (I just tought it was a good name)---------------------------------------------------------------------------------
function mod:SirenRagSprite(entity)
	local sprite = entity:GetSprite()
	sprite.Scale = Vector.Zero
	sprite:ReplaceSpritesheet (0, "hc/gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (1, "hc/gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (2, "hc/gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (3, "hc/gfx/effects/empty.png")
	sprite:ReplaceSpritesheet (4, "hc/gfx/effects/empty.png")
	sprite:LoadGraphics()
end
function mod:SirenRagUpdate(entity)
	if mod.EntityInf[mod.Entity.SirenRag].VAR == entity.Variant and mod.EntityInf[mod.Entity.SirenRag].SUB == entity.SubType  then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		local animName = sprite:GetAnimation()
		
		if data.Init == nil then
			sprite:Play("Attack2BStart", true)
			entity.State = 10
			data.Init = true
			
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod:SirenRagSprite(entity)
			sprite:Play("Attack2BStart")

			
			for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT)) do
				if e.Parent == entity then
					e:Remove()
				end
			end
		end

		
		if entity.Parent then
			entity.Position = entity.Parent.Position
			entity.Velocity = Vector.Zero
		end

		entity.State = 10
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SirenRagUpdate, mod.EntityInf[mod.Entity.SirenRag].ID)


--Flame
function mod:FireUpdate(tear, collider, collided)
    if tear.SubType == mod.EntityInf[mod.Entity.Flame].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        if data.Init == nil then
            sprite:Play("Appear")
            data.Init = true
            data.IsFlamethrower_HC = true

            if data.EmberPos == nil then data.EmberPos = -10 end
            
            if not data.NoRot then sprite.Rotation = 90 end

            if data.Mars then
                sprite.Color = Color(1,0.5,-0.5,1)
                sprite:Play("Flickering", true)
            end
        end

        if sprite:IsFinished("Appear") then sprite:Play("Flickering",true) end

        if not data.NoRot then sprite.Rotation = tear.Velocity:GetAngleDegrees() end

        --if not data.NoGrow then sprite.Scale = sprite.Scale + 0.018*Vector(1,1) end
        

        if (not data.Mars) and tear.FrameCount%3==0 then
            --For tracing
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position + Vector(0,data.EmberPos), Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Scale = 0.8*Vector(1,1)
            if tear.FrameCount%2==0 then
                cloud:GetSprite().Color = mod.Colors.lesbian
            else
                cloud:GetSprite().Color = mod.Colors.superFire
            end
        end

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
            
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Scale = 1*Vector(1,1)
            if data.Mars then
                cloud:GetSprite().Color = sprite.Color
            else
                cloud:GetSprite().Color = mod.Colors.lesbian
            end

            tear:Die()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.FireUpdate, mod.EntityInf[mod.Entity.Flame].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.FireUpdate, mod.EntityInf[mod.Entity.Flame].VAR)

--Fireball
function mod:FireballUpdate(tear, collider, collided)
    if tear.SubType == mod.EntityInf[mod.Entity.Fireball].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        if data.Init == nil then
            data.Init = true
            
            sprite:Play("Idle")
            sprite:SetFrame(mod:RandomInt(1,12))
            sprite.PlaybackSpeed = 1.5
            data.Lifespan = mod:RandomInt(40,90)
            data.IsFireball_HC = true

            if tear.Velocity.X < 0 then
                sprite.FlipX = true
            end
            
            tear:AddProjectileFlags(ProjectileFlags.BOUNCE)
            tear:AddProjectileFlags (ProjectileFlags.BOUNCE_FLOOR)
        end

        data.Lifespan = data.Lifespan - 1
        
        if tear.Height >= 1 then
            tear.FallingSpeed = -5;
            tear.FallingAccel = 1.5;
            tear.Height = -23
            tear:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
        end

        if game:GetFrameCount()%15==0 then
            --For tracing
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Scale = 0.4*Vector(1,1)
            cloud:GetSprite().Color = mod.Colors.superFire
            
            game:SpawnParticles (tear.Position, EffectVariant.EMBER_PARTICLE, 3, 2)
        end

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) or data.Lifespan <= 0 then
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Scale = 0.8*Vector(1,1)
            cloud:GetSprite().Color = mod.Colors.superFire

            tear:Die()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.FireballUpdate, mod.EntityInf[mod.Entity.Fireball].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.FireballUpdate, mod.EntityInf[mod.Entity.Fireball].VAR)

--Kiss
function mod:KissUpdate(tear, collider, collided)
    if tear.SubType == mod.EntityInf[mod.Entity.Kiss].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        if data.Init == nil then
            sprite:Play("Idle")
            data.Init = true
        end

        if sprite:IsFinished("Appear") then sprite:Play("Idle",true) end

        sprite.Color = Color.Default

        if tear.FrameCount % 2==0 then
            --For tracing
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position + Vector(0,-23), Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Scale = 1*Vector.One
            cloud:GetSprite().Color = mod.Colors.superFire
            
            game:SpawnParticles (tear.Position, EffectVariant.EMBER_PARTICLE, 3, 2)
        end

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector.Zero, nil):ToEffect()
            cloud:GetSprite().Color = mod.Colors.fire

            tear:Die()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.KissUpdate, mod.EntityInf[mod.Entity.Kiss].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.KissUpdate, mod.EntityInf[mod.Entity.Kiss].VAR)

--Player
function mod:OnPlayerDamageVenus(player, amount, damageFlags, source, frames)
    local fireFlag = false
    if source:GetData().IsFlamethrower_HC or source:GetData().IsFireball_HC or source.Type == mod.EntityInf[mod.Entity.Venus].ID then
        sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
        fireFlag = true

    elseif source.Type == EntityType.ENTITY_PROJECTILE and source.Variant == mod.EntityInf[mod.Entity.Kiss].VAR and source.SubType == mod.EntityInf[mod.Entity.Kiss].SUB then
        mod:BurnPlayer(player, mod.VConst.BURNINGS_FRAMES)

        return true
    end
end