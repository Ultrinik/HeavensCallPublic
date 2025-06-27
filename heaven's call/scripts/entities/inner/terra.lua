---@diagnostic disable: undefined-field
local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--[[
@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@&%%%%%%@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@############%%%%%%%%&&%&&&@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@%################%%#####%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@
@@@@%################%%%%%%%%%%%%%###&@@@@@@@@@@@@@@@@&@@@@@@@@@@@@&@@@@@@@@@@@@
@@@@%#############%%%%%%%%%%%%###&&%%%&&&@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@%###########%%%%%%%%%%%%%%%#&#((/*****************/((#(%&@@@@@@@@@@@@@@@@@@@@
@@@%##########%%%%%%%%%%%%%%%%(/*,.,,.  ..          ..,,,,,,**(&@@@@@@@@@@@@@@&@
@@@&(#####%##%%%%%%&&&%&&%(/,,,,,,,,                 ..... .,,,,*#&&%@@@@@@@@@@@
@@@#(####%%%%%%%%%&%%&%#(*,....,,,,,,,,,,,                     .,,,*(##&@@@@@@@@
@@%#####%%%%%%&%&&&%%#(*,..........,,,,,,,,,***,*****,            ...*(#%@@@@@@@
@@######%%&&&&&&&&&%#(///*,,,,,,,,,,,,,,,,,,,,,,,*********    .. ,,,,,,*(%@&@@@@
@@@####%%%&&&&&&@%%((/////*,,,***///////***/*****////,,***********.,,,***(@@@@@@
@@@%####%%%&&&&&%/*,,*****//////////////////////((/((((/*******,,***,,****(@@@@@
@@@%####%%%&&&&%/,,****/*//((((//(((((((((((((((((((((((((((((((/*,*****,,*/%@@@
@@@%%%%%%&&&&@&#/*(////(((((((((((((((((((((((((((##############((//////,,,*(#@@
@@@@&&&&&&&&&@%(/((((((#%%&&%((((#######(((((((#(######%%%%%%%#####(//***,,,/#%@
@@@@@@@@%%%@@@#(/###%%&&&&&&@@@@%###############%%@@@@@@@&&&&&%%%%#%(////*,*/(#@
@@@@@@@@@@@@@&#((%&&&&&&@@@@@@@@@@%%%%%%%%%%%%%%@@@@@@@@@@@&&&&%#####/////**/#@@
@@@@@@@@@@@@@&#((%&&&&@@@@&@@@@@@@@%%%%%%%%%%%%@@@@@@@@@@@@@&&&&&%%%#%((((((#@@@
@@@@@@@@@@@@@@#///%&&&&&/(&(*&@@@@&%%%%%%%%%%%%&@@@@((#(&@@@&&&&&#(//((((((#%@@@
@@@@@@@@@@@@@&%/**/(/((#%%#%&&&@@&%%%%%%%%%%%%%%%@@@@#(&@@@&##(#//(((((((((#&@@@
@@@@@@@@@@@@@@&#/**(/.,.,..*(&&%%%%%%%%%%%%%%%%%%%%%@(..,,((/((#((((((((((#&@@@@
@@@@@@@@@@@@@@@@%(///./(((((%%%%%%%%%%%%%%%%%%%%%%%##((*((/(,///////*****/&@@@@@
@@@@@@@@@@@@@@@@&%(***,/,,/((%&&&@@@@@@@&&%&%%&@@@@&#(((////,///********/(&@@@@@
@@@@@@@@@@@@@@@@@@&#**. ,*///##%%&&@@@@@@@@@@@@@@@&%//(/((,*////*****,*/((@@@@@@
@@@@@@@@@@@@@@@@@@@@&(****///*/(%%%%%&&&&@@@@@@@@@/**(#,.(..((//***,*/((@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@#%%(/////////(%%%%&&&&&&&&&(/////##(((/////***(%@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@##(////(((((((((((((((((/////(/(/(///*#&@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#&#((///////(//((//((((((((////((/*@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%###(((((#######%%&%@@&%@@@@@@@@@@@%%@@@%%@%%
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@%@@@@%@@@@
]]--
mod.TConst = {
    
    --Green------------------------------------------------
    -------------------------------------------------------
    IDLE_TIME_INTERVAL1 = Vector(5,10),
    SPEED1 = 1.5,
    
    --leaves
    MAX_LEAVES = 20,
    LEAF_PERIOD = 3,
    LEAF_SPEED = 11,

    --bubbles
    N_BUBBLES = 2,
    BUBBLE_SPEED = 3,
    BUBBLE_PERIOD = 5,

    --magma
    N_COALS = 1,

    --clouds
    N_WAIT_THUNDER = 3,
    N_CLOUDS = 12,
    CLOUD_SPEED = 5,

    --Rock-------------------------------------------------
    -------------------------------------------------------
    SPEED2 = 30,
    CANCER_FRAMES = 60,
    CANCER_RANGE = 100,

    CANCER_TRINKET_CHANCE = 0.05,

    --tar bomb
    TAR_EXPLOSION_RADIUS = 60,
    N_TAR_RING_PROJECTILES = 10,
    N_TAR_RND_PROJECTILES = 8,
    N_TAR_BUBBLES = 8,
    TAR_BOMB_SPEED = 30,

    --meteor impact
    BLAST_ANGLE = 0.1,
    IMPACT_WAIT = 150,
    IMPACT_SPEED = 10,

    --nuke nova
    N_NOVAS = 10,

    --swarm
    N_SWARMS = 10,
    SWARM_PERIOD = 5,
    MAX_LOCUST = 12,
    LOCUST_COLORS = {Color(255/255, 255/255, 255/255, 1, 0/255, 0/255, 0/255), Color(255/255, 255/255, 255/255, 1, 255/255, 255/255, 255/255), Color(1024/255, 768/255, 512/255, 1, 0/255, 0/255, -255/255), Color(512/255, 768/255, 512/255, 1, -255/255, 0/255, -255/255), Color(1024/255, 512/255, 512/255, 1, 0/255, 0/255, -255/255)},


    --Eden-------------------------------------------------
    -------------------------------------------------------
    IDLE_TIME_INTERVAL3 = Vector(5,10),
    SPEED3 = 1.25,

    --laser
    N_LASER_WAITS = 10,
    LASER_ROTATION_SPEED = 5.5,
    N_LASERS_CROSS = 3,


    --nova
    N_NOVA_CHARGES = 3,
    N_NOVA_ATTACKS = 25,
    NOVA_SPIN_SPEED = 1,
    N_LASERS = 6,
    LASER_OFFSET = 12,
    N_NOVA_SPEED = 5,
    N_NOVA_SHOTS = 12,
    NOVA_COLORS = {Color(1,0,0,0.75, 1,0,0), Color(1,1,0,0.75, 1,1,0), Color(0,1,0,0.75, 0,1,0), Color(0,1,1,0.75, 0,1,1), Color(0,0,1,0.75, 0,0,1), Color(1,0,1,0.75, 1,0,1),},

    --meteors
    N_POLLEN = 4,
    N_METEORS_IDLES = 7,
    METEOR_TIMEOUT = 50,
    METEOR_EXPLOSION_RADIUS = 80,
    DEBREE_SPEED = 15,

    --shots
    N_TEARS = 8,
    TEAR_SPEED = 8,
    N_BULLET_HELL = 15,
    BULLET_HELL_PERIOD = 4,
    EDEN_COLORS = {Color(1, 0.75, 0.75), Color(1, 1, 0.75), Color(0.75, 1, 0.75), Color(0.75, 1, 1), Color(0.75, 0.75, 1), Color(1, 0.75, 1)},
    HELL_IDLES = 7,

    --summon
    HORSEMEN_SPEED = 15,
    FAMINE_SHOT_SPEED = 12,
    FAMINE_SHOT_ANGLE = 20,
    PERTILENCE_GAS_TIME = 100,
    HORSEMEN_IDLES = 7,

    --dash
    N_DASH = 7,

}

function mod:SetTerraDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
        --                                      App   Id    Bub   Emb   Seed   Cloud
        mod.chainT1[mod.T1MSState.IDLE] =      {0,    40,   15,   15,   15,    0}
        --                                      App     idle    shot    burst   laser   nova    horse   meteor  dash
        mod.chainT3[mod.T3MSState.IDLE] =      {0,      8,      0.4,    1,      1,      1.5,      1,      1,      0}

        --Green------------------------------------------------
        -------------------------------------------------------
        --leaves
        mod.TConst.LEAF_PERIOD = 3
        mod.TConst.LEAF_SPEED = 8

        --bubbles
        mod.TConst.N_BUBBLES = 2
        mod.TConst.BUBBLE_SPEED = 3
        mod.TConst.BUBBLE_PERIOD = 5

        --magma
        mod.TConst.N_COALS = 1

        --clouds
        mod.TConst.N_CLOUDS = 10

        --Rock-------------------------------------------------
        -------------------------------------------------------

        --tar bomb
        mod.TConst.N_TAR_BUBBLES = 8

        --meteor impact
        mod.TConst.BLAST_ANGLE = 0.1

        --swarm
        mod.TConst.N_SWARMS = 8
        mod.TConst.SWARM_PERIOD = 5
        mod.TConst.MAX_LOCUST = 12

        --nuke
        mod.TConst.N_NOVA_SHOTS = 12

        --Eden-------------------------------------------------
        -------------------------------------------------------
        
        --laser
        mod.TConst.N_LASERS_CROSS = 3

        --nova
        mod.TConst.LASER_OFFSET = 10

        --meteors
        mod.TConst.N_POLLEN = 4
        mod.TConst.DEBREE_SPEED = 12

        --shots
        mod.TConst.N_TEARS = 6
        mod.TConst.BULLET_HELL_PERIOD = 6

        --summon
        mod.TConst.HORSEMEN_SPEED = 14

	elseif difficulty == mod.Difficulties.ATTUNED then
        --                                      App   Id    Bub   Emb   Seed   Cloud
        mod.chainT1[mod.T1MSState.IDLE] =      {0,    40,   15,   15,   15,    15}
        --                                      App     idle    shot    burst   laser   nova    horse   meteor  dash
        mod.chainT3[mod.T3MSState.IDLE] =      {0,     8,      0.4,    1,      1,      1.5,      1,      1,      1.5}

        --Green------------------------------------------------
        -------------------------------------------------------
        --leaves
        mod.TConst.LEAF_PERIOD = 3
        mod.TConst.LEAF_SPEED = 10

        --bubbles
        mod.TConst.N_BUBBLES = 2
        mod.TConst.BUBBLE_SPEED = 4
        mod.TConst.BUBBLE_PERIOD = 4

        --magma
        mod.TConst.N_COALS = 1

        --clouds
        mod.TConst.N_CLOUDS = 10

        --Rock-------------------------------------------------
        -------------------------------------------------------

        --tar bomb
        mod.TConst.N_TAR_BUBBLES = 10

        --meteor impact
        mod.TConst.BLAST_ANGLE = 0.15

        --swarm
        mod.TConst.N_SWARMS = 10
        mod.TConst.SWARM_PERIOD = 5
        mod.TConst.MAX_LOCUST = 14

        --nuke
        mod.TConst.N_NOVA_SHOTS = 14

        --Eden-------------------------------------------------
        -------------------------------------------------------
        
        --laser
        mod.TConst.N_LASERS_CROSS = 4

        --nova
        mod.TConst.LASER_OFFSET = 13

        --meteors
        mod.TConst.N_POLLEN = 5
        mod.TConst.DEBREE_SPEED = 14

        --shots
        mod.TConst.N_TEARS = 7
        mod.TConst.BULLET_HELL_PERIOD = 5

        --summon
        mod.TConst.HORSEMEN_SPEED = 15

    elseif difficulty == mod.Difficulties.ASCENDED then
        --                                      App   Id    Bub   Emb   Seed   Cloud
        mod.chainT1[mod.T1MSState.IDLE] =      {0,    40,   15,   15,   15,    15}
        --                                      App     idle    shot    burst   laser   nova    horse   meteor  dash
        mod.chainT3[mod.T3MSState.IDLE] =      {0,     8,      0.4,    1,      1,      1.5,      1,      1,      1.5}

        --Green------------------------------------------------
        -------------------------------------------------------
        --leaves
        mod.TConst.LEAF_PERIOD = 2
        mod.TConst.LEAF_SPEED = 10

        --bubbles
        mod.TConst.N_BUBBLES = 3
        mod.TConst.BUBBLE_SPEED = 4
        mod.TConst.BUBBLE_PERIOD = 4

        --magma
        mod.TConst.N_COALS = 2

        --clouds
        mod.TConst.N_CLOUDS = 13

        --Rock-------------------------------------------------
        -------------------------------------------------------

        --tar bomb
        mod.TConst.N_TAR_BUBBLES = 12

        --meteor impact
        mod.TConst.BLAST_ANGLE = 0.2

        --swarm
        mod.TConst.N_SWARMS = 12
        mod.TConst.SWARM_PERIOD = 4
        mod.TConst.MAX_LOCUST = 16

        --nuke
        mod.TConst.N_NOVA_SHOTS = 17

        --Eden-------------------------------------------------
        -------------------------------------------------------
        
        --laser
        mod.TConst.N_LASERS_CROSS = 5

        --nova
        mod.TConst.LASER_OFFSET = 16

        --meteors
        mod.TConst.N_POLLEN = 5
        mod.TConst.DEBREE_SPEED = 16

        --shots
        mod.TConst.N_TEARS = 8
        mod.TConst.BULLET_HELL_PERIOD = 4

        --summon
        mod.TConst.HORSEMEN_SPEED = 16

    end
    
    --                                      App     idle    shot    burst   laser   nova    horse   meteor  dash
    --mod.chainT3[mod.T3MSState.IDLE] =      {0,      0,        0,    0,      0,      0,      0,      0,      1}

    mod.chainT1 = mod:NormalizeTable(mod.chainT1)
    mod.chainT3 = mod:NormalizeTable(mod.chainT3)
end


mod.T1MSState = {
    APPEAR = 0,
    IDLE = 1,
    BUBBLES = 2,
    EMBERS = 3,
    LEAFS = 4,
    CLOUD = 5
}
mod.chainT1 = {--               App   Id    Bub Emb  Seed   Cloud
    [mod.T1MSState.APPEAR] =    {0,    1,   0,  0,   0,     0},
    [mod.T1MSState.IDLE] =      {0,    40,  15, 15, 15,     15},
    [mod.T1MSState.BUBBLES] =   {0,    8,   0,  1,  1,      0},
    [mod.T1MSState.EMBERS] =    {0,    8,   1,  0,  1,      0},
    [mod.T1MSState.LEAFS] =     {0,    8,   1,  1,  0,      0},
    [mod.T1MSState.CLOUD] =     {0,    1,   0,  0,  0,      0},
}
mod.chainT1 = mod:NormalizeTable(mod.chainT1)

function mod:Terra1Update(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Terra1].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra1].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()
        
        --Custom data:
        if data.State == nil then
            data.State = 0
            data.StateFrame = 0

            data.LeafCount = 0

            if mod.savedatasettings().Difficulty == mod.Difficulties.ATTUNED then
                entity.MaxHitPoints = 1.5*entity.MaxHitPoints
            elseif mod.savedatasettings().Difficulty == mod.Difficulties.ASCENDED then
                entity.MaxHitPoints = 2*entity.MaxHitPoints
            end
            entity.HitPoints = entity.MaxHitPoints
        end
        
        --Frame
        data.StateFrame = data.StateFrame + 1
        
        if data.State == mod.T1MSState.APPEAR then
            if data.StateFrame == 1 then
                mod:AppearPlanet(entity)
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                data.State = mod:MarkovTransition(data.State, mod.chainT1)
                data.StateFrame = 0
            elseif sprite:IsEventTriggered("EndAppear") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            
        elseif data.State == mod.T1MSState.IDLE then
            if data.StateFrame == 1 then
                sprite:Play("Idle",true)
            elseif sprite:IsFinished("Idle") then
                data.State = mod:MarkovTransition(data.State, mod.chainT1)
                data.StateFrame = 0
                
            else
                mod:Terra1Move(entity, data, room, target)
            end
            
        elseif data.State == mod.T1MSState.BUBBLES then
            mod:Terra1Bubbles(entity, data, sprite, target,room)
        elseif data.State == mod.T1MSState.EMBERS then
            mod:Terra1Ember(entity, data, sprite, target,room)
        elseif data.State == mod.T1MSState.LEAFS then
            mod:Terra1Leafs(entity, data, sprite, target,room)
        elseif data.State == mod.T1MSState.CLOUD then
            mod:Terra1Cloud(entity, data, sprite, target,room)
        end

        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 7.5*xvel, 0.1)

        mod:Terra1Look(entity, sprite, data, room, target)
    end
end
function mod:Terra1Ember(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        
        local coals = Isaac.FindByType(EntityType.ENTITY_FIREPLACE, 11)
        if #coals > 3 then
            for i=1, 3 do
                --coals[i]:Die()
                for i=1,5 do
                    if coals[i] then
                        coals[i]:TakeDamage(1, 0, EntityRef(entity), 0)
                    end
                end
            end
        end
        sprite:Play("Ember",true)
        
        --sfx:Play(SoundEffect.SOUND_WAR_FLAME, 1, 2, false ,1)
        sfx:Play(SoundEffect.SOUND_MOTHER_FISTULA, 0.8, 2, false, 0.7)
        

    elseif sprite:IsFinished("Ember") then
        data.State = mod:MarkovTransition(data.State, mod.chainT1)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_BEAST_LAVA_BALL_SPLASH, 0.8, 2, false, 0.5)


    elseif sprite:IsEventTriggered("Shot") then

        sfx:Play(SoundEffect.SOUND_WAR_LAVA_DASH, 0.8, 2, false ,1)

        for i=1, mod.TConst.N_COALS do
            local coalboy = Isaac.Spawn(EntityType.ENTITY_DANNY, 1, 0, entity.Position, Vector.Zero, entity):ToNPC()
            coalboy.Visible = false
            coalboy.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            coalboy:GetSprite():SetFrame("Attack" ,12)
            coalboy.State = 8

            mod:scheduleForUpdate(function()
                sfx:Stop(SoundEffect.SOUND_MONSTER_GRUNT_2)
                coalboy:Remove()
            end,2)
        end
        mod:scheduleForUpdate(function()
            for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_ROCK_SPIDER, 2)) do
                e:Remove()
            end
        end,3)

        local direction = (target.Position - entity.Position):Normalized()
        local pos = entity.Position+Vector(0,20)
        game:SpawnParticles(pos, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 20, 12, mod.Colors.superFire)
        mod:scheduleForUpdate(function ()
            for i, cloud in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE)) do
                if cloud.Position:Distance(pos) < 12 then
                    cloud.Velocity = cloud.Velocity + direction*15
                end
            end
        end,1)

        for i=1, 8 do
            local pos = entity.Position + Vector.FromAngle(i*360/8)*60
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, pos, Vector.Zero, entity)
        end
    end
end
function mod:Terra1Bubbles(entity, data, sprite, target,room)
    
    if data.StateFrame > 1 then
        local animation
        if target.Position.X < entity.Position.X and not sprite:IsPlaying("BubblesL") then
            animation = "BubblesL"
        elseif target.Position.X > entity.Position.X and not sprite:IsPlaying("BubblesR") then
            animation = "BubblesR"
        end
        
        if animation then
            local frame = sprite:GetFrame()
            sprite:Play(animation, true)
            sprite:SetFrame(frame)
        end
        
    end
    if data.StateFrame == 1 then
        if target.Position.X < entity.Position.X then
            sprite:Play("BubblesL",true)
        else
            sprite:Play("BubblesR",true)
        end
        
        --sfx:Play(Isaac.GetSoundIdByName("terra_gasp"), 2, 2, false, 3)
        sfx:Play(SoundEffect.SOUND_LOW_INHALE, 0.7, 2, false, 2.5)
        sfx:Play(SoundEffect.SOUND_THE_STAIN_BURST, 1, 2, false, 1)
        
    elseif sprite:IsFinished() or sprite:GetFrame() >= 42 then
        data.State = mod:MarkovTransition(data.State, mod.chainT1)
        data.StateFrame = 0

    elseif (sprite:WasEventTriggered("Shot") or sprite:GetFrame() > 19) and entity.FrameCount % mod.TConst.BUBBLE_PERIOD == 0 then
        sfx:Play(Isaac.GetSoundIdByName("Bubbles"), 2, 2, false, 1)
        local direction = (target.Position - entity.Position):Normalized()
        for i=1, mod.TConst.N_BUBBLES do
            local bubble = mod:SpawnEntity(mod.Entity.Bubble, entity.Position, direction:Rotated(mod:RandomInt(-30,30)) * mod.TConst.BUBBLE_SPEED, entity)
            bubble.DepthOffset = 60
            
            sfx:Play(SoundEffect.SOUND_PLOP, 0.5, 2, false, 2)
        end
    end
end
function mod:Terra1Leafs(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("LeafStart",true)
        data.MAX_LEAVES = mod.TConst.MAX_LEAVES
        
        --sfx:Play(Isaac.GetSoundIdByName("terra_prespin"), 1, 2, false, 0.3)
        sfx:Play(Isaac.GetSoundIdByName("terra_gasp"), 1, 2, false, 1)
        
    elseif sprite:IsFinished("LeafStart") then
        sprite:Play("LeafSpin",true)
        
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 1, 2, false, 0.8)

    elseif sprite:IsFinished("LeafSpin") then
        data.MAX_LEAVES = data.MAX_LEAVES - 1
        if data.MAX_LEAVES == 0 then
            sprite:Play("LeafEnd",true)
            sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
            sfx:Play(Isaac.GetSoundIdByName("terra_dizzy"), 2, 2, false, 1)
        else
            sprite:Play("LeafSpin",true)
            --entity:Update()
        end

    elseif sprite:IsFinished("LeafEnd") then
        data.StateFrame = 0
        data.State = mod:MarkovTransition(data.State, mod.chainT1)

    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_MOTHER_ANGER_SHAKE, 1, 2, false, 2)
    elseif sprite:IsEventTriggered("Sound2") then
        sfx:Play(SoundEffect.SOUND_THUMBSUP)
    
    elseif sprite:IsPlaying("LeafSpin") then

        entity.Velocity = mod:RandomVector(5,2.5)

        if entity.FrameCount % mod.TConst.LEAF_PERIOD == 0 then
    
            --local direction = (target.Position - entity.Position):Normalized()
            local direction = Vector.FromAngle(360*rng:RandomFloat())
    
            local leaf = mod:SpawnEntity(mod.Entity.Leaf, entity.Position, direction * mod.TConst.LEAF_SPEED, entity):ToProjectile()
            mod:TearFallAfter(leaf, 45)
        end

        if entity.FrameCount % 3 == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Leafs"), 2, 2, false, 0.8 + 0.4*rng:RandomFloat())
        end
    end
end
function mod:Terra1Cloud(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        
        sprite:Play("Cloud",true)
        
        sfx:Play(Isaac.GetSoundIdByName("terra_gasp"), 2, 2, false, 1)
        sfx:Play(SoundEffect.SOUND_MONSTER_YELL_B, 1, 2, false, 1.2)
        

    elseif sprite:IsFinished("Cloud") then
        data.N_WAIT_THUNDER = mod.TConst.N_WAIT_THUNDER
        sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        data.N_WAIT_THUNDER = data.N_WAIT_THUNDER - 1
        if data.N_WAIT_THUNDER <= 0 then
            data.State = mod:MarkovTransition(data.State, mod.chainT1)
            data.StateFrame = 0
        else
            sprite:Play("Idle",true)
        end

    elseif sprite:IsEventTriggered("Sound") then
        --sfx:Play(SoundEffect.SOUND_BEAST_LAVA_BALL_SPLASH, 1, 2, false, 0.5)


    elseif sprite:IsEventTriggered("Shot") then

        sfx:Play(SoundEffect.SOUND_WHEEZY_COUGH, 1, 2, false, 0.76)
        sfx:Play(SoundEffect.SOUND_SUMMON_POOF, 2, 2, false, 0.76)
        sfx:Play(SoundEffect.SOUND_BEAST_GHOST_DASH, 2, 2, false, 0.76)

        local offset = 360*rng:RandomFloat()
        for i=1, mod.TConst.N_CLOUDS do
            local angle = i*360/mod.TConst.N_CLOUDS + offset + mod:RandomInt(-15,15)

            local velocity = Vector.FromAngle(angle) * mod.TConst.CLOUD_SPEED * (1 + 0.5*rng:RandomFloat())
            local cloud = mod:SpawnEntity(mod.Entity.Cloud, entity.Position, velocity, entity):ToProjectile()
            cloud:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            cloud.Parent = entity
            cloud:GetData().Deacceleration = 0.95 + 0.05*rng:RandomFloat()
            mod:TearFallAfter(cloud, 90 * (0.8 + 0.4*rng:RandomFloat()))

            if rng:RandomFloat() < 0.5 then
                cloud:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
            else
                cloud:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
            end
            cloud.CurvingStrength = 0.01 * rng:RandomFloat()
        end

        game:SpawnParticles(entity.Position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 20, 12, Color(1,1,1,1,1,1,1))
    end
end

function mod:Terra1Look(entity, sprite, data, room, target)
	local layer = sprite:GetLayer(4)
	if (not entity:IsDead()) and data.State ~= mod.T1MSState.EMBER then
		local direction = (target.Position - (entity.Position + Vector(0,20))):Normalized()
        direction.Y = direction.Y * 0.25
		local final_direction = mod:Lerp(layer:GetPos(), direction*5, 0.05)
		layer:SetPos(final_direction)
    elseif data.State == mod.T1MSState.EMBER then
		layer:SetPos(Vector.Zero)
	else
		local final_direction = mod:Lerp(layer:GetPos(), Vector.Zero, 0.5)
		layer:SetPos(final_direction)
	end
end


mod.T2MSState = {
    APPEAR = 0,
    IDLE = 1,
    MOVE = 2,

    FROG = 3,
    METEOR = 4,
    TONGUE = 5,
    NOVA = 6,
    ANNOYED = 7,
    SWARM = 8,

    DEFEATED = 9,
}

function mod:Terra2Update(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Terra2].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra2].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()
        
        --Custom data:
        if data.State == nil then
            data.State = 0
            data.StateFrame = 0

            data.IsDead = false

            
            sprite:SetCustomShader("hc/shaders/irradiated_big")
        end
        
        if (mod.savedatasettings().Difficulty >= mod.Difficulties.ASCENDED) and not (sprite:IsPlaying("Above") or sprite:GetAnimation() == "Defeat") then
            if true then--data.State == mod.T2MSState.IDLE then
                local f = 0.05
                local r = rng:RandomFloat()
                if r < 0.1*f then
                    entity:SetColor(Color(0,0,0,1, 0.05, 0.95, 0.05), 3, 1, false, false)
                elseif r < 0.2*f then
                    entity:SetColor(Color(0,0,0,1, 0.85, 0.95, 0.05), 3, 1, false, false)
                elseif r < 0.3*f then
                    entity:SetColor(Color(0,0,0,1, 0,1,0), 3, 1, false, false)
                elseif r < 0.4*f then
                    entity:SetColor(Color(0,10,0,1, 10,10,0), 3, 1, false, false)
                elseif r < 0.42*f then
                    sprite:PlayOverlay("Radiation", true)
                end

            end
                
            local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, entity.Position + Vector(0,-40) + mod:RandomVector(10,5), mod:RandomVector(10,5), entity)
            shine:SetColor(Color(1,1,1,1,0,1,0), -1, 99, true, true)
            shine.DepthOffset = -200
             
            local max_cancer = 0
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                            
                if not (player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM)) then
                    local player_data = player:GetData()

                    player_data.Cancer = player_data.Cancer or 0
                    if player.Position:Distance(entity.Position) < mod.TConst.CANCER_RANGE then
                        player_data.Cancer = player_data.Cancer + 1

                        if #mod:FindByTypeMod(mod.Entity.Debuff) == 0 then
                            mod:AddDebuffOverlay('Cancer', player)
                        end

                        player:SetColor(Color(1,1,1,1, 0, player_data.Cancer/mod.TConst.CANCER_FRAMES,0), 1, 1, false, false)

                        if player_data.Cancer > mod.TConst.CANCER_FRAMES then
                            player_data.Cancer = 0

                            player:TakeDamage(1, 0, EntityRef(player), 0)
                            if rng:RandomFloat() < mod.TConst.CANCER_TRINKET_CHANCE and not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_CANCER) then
                                local cancer = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_CANCER, player.Position, Vector.Zero, nil)
                            end
                        end
                    else
                        player_data.Cancer = math.max(0, player_data.Cancer - 1)
                    end
                    max_cancer = math.max(max_cancer, player_data.Cancer)

                end
            end
            if entity.FrameCount%9 == 0 then
                sfx:Play(Isaac.GetSoundIdByName("geiger_loop"), 4*max_cancer/mod.TConst.CANCER_FRAMES)
            end
        end
        --entity:SetColor(Color(1,1,1,1, 0.85, 0.95, 0.005), 2, 1, false, false)

        data.Inmovible = true
        --print(data.State, data.StateFrame, sprite:GetAnimation())
        --Frame
        data.StateFrame = data.StateFrame + 1
        
        if data.State == mod.T2MSState.APPEAR then
            if data.StateFrame == 1 then
                --local flag = "AppearSlow" == sprite:GetAnimation()

                mod:AppearPlanet(entity, true)
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
                
                --if flag then
                --    sprite:Play("AppearSlow", true)
                --end

            elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                data.State = mod.T2MSState.IDLE
                data.StateFrame = 0

            elseif sprite:IsEventTriggered("Attack") then

                local eden = mod:SpawnEntity(mod.Entity.Terra3, entity.Position, Vector.Zero, nil)
                eden:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                eden.Parent = entity
                entity.Child = eden

                if sprite:IsPlaying("AppearSlow") then
                    eden:GetSprite():Play("AppearSlow", true)

                    local velocity = (target.Position - entity.Position):Normalized()*5
                    eden.Velocity = velocity
                
                    sfx:Play(Isaac.GetSoundIdByName("burp"))
                    
                    game:SpawnParticles (entity.Position+Vector(0,10), EffectVariant.POOP_PARTICLE, 20, 13, mod.Colors.black)
                    local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position+Vector(0,-5), Vector.Zero, entity)
                    bloody:GetSprite().Color = mod.Colors.black
                else
                    eden:GetSprite():Play("Appear", true)
                end

                if mod.savedatarun().planetAlive then
                    eden.HitPoints = mod.savedatarun().planetHP
                end

            elseif sprite:IsEventTriggered("EndAppear") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            end
            
        elseif data.State == mod.T2MSState.IDLE then
            if data.StateFrame == 1 then
                sprite:Play("Idle",true)
            elseif sprite:IsFinished("Idle") then
                if rng:RandomFloat() < 0.05 then
                    data.State = mod.T2MSState.MOVE
                else
                    data.State = mod.T2MSState.IDLE
                end
                data.StateFrame = 0
            end
            
        elseif data.State == mod.T2MSState.MOVE then
            data.Inmovible = false
            mod:Terra2Move(entity, data, sprite, target,room)

        elseif data.State == mod.T2MSState.FROG then
            mod:Terra2Frog(entity, data, sprite, target,room)
        elseif data.State == mod.T2MSState.METEOR then
            mod:Terra2Meteor(entity, data, sprite, target,room)
        elseif data.State == mod.T2MSState.TONGUE then
            mod:Terra2Tongue(entity, data, sprite, target,room)
        elseif data.State == mod.T2MSState.NOVA then
            mod:Terra2Nova(entity, data, sprite, target,room)
        elseif data.State == mod.T2MSState.ANNOYED then
            mod:Terra2Annoyed(entity, data, sprite, target,room)
        elseif data.State == mod.T2MSState.DEFEATED then
            mod:Terra2Defeated(entity, data, sprite, target,room)
        elseif data.State == mod.T2MSState.SWARM then
            mod:Terra2Swarm(entity, data, sprite, target,room)
        end

        if data.Inmovible then
            entity.Velocity = Vector.Zero
        end

        if data.State ~= mod.T2MSState.METEOR then
            if entity.FrameCount % 20 == 0 and not data.IsDead then
                
                local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, Vector.Zero, entity):ToEffect()
                tar.Timeout = 60
                tar.SpriteScale = Vector.One*3
            end
            
            if entity.FrameCount % 2 == 0 and not data.IsDead then
                local bubble = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TAR_BUBBLE, 0, entity.Position + RandomVector() * ( 40 * rng:RandomFloat() + 25 ), Vector.Zero, entity):ToEffect()
            end
        end

        mod:Terra2Look(entity, sprite, data, room, target)

        --entity.Position = room:GetCenterPos()
    end
end
function mod:Terra2Frog(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Frog",true)
        sfx:Play(Isaac.GetSoundIdByName("Frog"), 1, 2, false, 0.67)
    elseif sprite:IsFinished("Frog") then
        data.State = mod.T2MSState.IDLE
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then

        local direction = (target.Position - entity.Position):Normalized()

        local bomb = mod:SpawnEntity(mod.Entity.TarBomb, entity.Position, direction * mod.TConst.TAR_BOMB_SPEED, entity)
        bomb.Parent = entity
        bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        
        sfx:Play(Isaac.GetSoundIdByName("burp"))
        
        game:SpawnParticles (entity.Position+Vector(0,10), EffectVariant.POOP_PARTICLE, 20, 13, mod.Colors.black)
        local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position+Vector(0,-5), Vector.Zero, entity)
        bloody:GetSprite().Color = mod.Colors.black
    end
end
function mod:Terra2Meteor(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Jump",true)
    elseif sprite:IsFinished("Jump") then
        sprite:Play("Above",true)
    elseif sprite:IsPlaying("Above") then
        if data.StateFrame < mod.TConst.IMPACT_WAIT then
            data.Inmovible = false
            local direction = (target.Position - entity.Position):Normalized()
            local velocity = direction * mod.TConst.IMPACT_SPEED

            entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.1)
        else
            entity.Velocity = Vector.Zero
            sprite:Play("Land",true)
        end
    elseif sprite:IsFinished("Land") then
        data.State = mod.T2MSState.IDLE
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_BOSS_LITE_ROAR)
    elseif sprite:IsEventTriggered("Attack") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

		sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH, 1, 2, false, 2)
        sfx:Play(SoundEffect.SOUND_BEAST_LAVABALL_RISE, 1, 2, false, 1)

        game:SpawnParticles(entity.Position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 30, 20, mod.Colors.tar)

    elseif sprite:IsEventTriggered("Land") then
        data.Inmovible = true
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        game:ShakeScreen(50)

        for i=1, 4 do
            local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ROCK_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
            local rockData = rock:GetData()
            rockData.Direction = Vector(1,0):Rotated(i*360/4)
            rockData.IsActive_HC = true
            rockData.HeavensCall = true
        end
        for i=1,10 do
            local position = entity.Position + Vector(40,0):Rotated(i*360/10)
            local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ROCK_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
        end

        for i, fracture in ipairs(mod:FindByTypeMod(mod.Entity.GlassFracture)) do
            fracture:Remove()
        end
        local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
		sfx:Play(SoundEffect.SOUND_MOTHER_LAND_SMASH, 1, 2, false, 1.2)
    end
end
function mod:Terra2Tongue(entity, data, sprite, target,room)

    if data.StateFrame == 1 then
        sprite:Play("Prepare",true)
        sfx:Play(SoundEffect.SOUND_MONSTER_YELL_B, 1, 2, false, 1.2)
        --sfx:Play(SoundEffect.SOUND_MOTHER_FISTULA, 0.8, 2, false, 0.7)
        
        data.Worm = nil
        data.Tonguecord = nil
        data.PosOffset = nil
        data.TargetPosition = nil
        

    elseif sprite:IsFinished("Prepare") then

        local angle = (data.TargetPosition - entity.Position):GetAngleDegrees()
        
        if 90 >= angle and angle >= 0 then
            sprite:Play("TongueQ4",true)
            data.Direction = Vector(1,1)
            
            data.PosOffset = Vector(15,-8)
            entity.Position = entity.Position + data.PosOffset
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE

        elseif 0 >= angle and angle >= -90 then
            sprite:Play("TongueQ1",true)
            data.Direction = Vector(1,-1)
        elseif 180 >= angle and angle >= 90 then
            sprite:Play("TongueQ3",true)
            data.Direction = Vector(-1,1)
            
            data.PosOffset = Vector(-15,-8)
            entity.Position = entity.Position + data.PosOffset
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE

        elseif -90 >= angle and angle >= -180 then
            sprite:Play("TongueQ2",true)
            data.Direction = Vector(-1,-1)
        end
        entity:Update()

    elseif sprite:IsFinished("Collision") then
        if data.Tonguecord then data.Tonguecord:Remove() end
        
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER

        data.State = mod.T2MSState.IDLE
        data.StateFrame = 0
        
        data.Worm = nil
        data.Tonguecord = nil

        return

    elseif sprite:IsEventTriggered("Aim") then
        data.TargetPosition = target.Position

    elseif sprite:IsEventTriggered("Attack") then

        sfx:Play(Isaac.GetSoundIdByName("Elastic"), 2, 2, false, 1)
        local direction = (data.TargetPosition - entity.Position):Normalized()

        --Better vanilla monsters was of help here
        local worm = mod:SpawnEntity(mod.Entity.Tongue, entity.Position + 50*data.Direction, direction * 25, entity)
        worm.Parent = entity
        worm.DepthOffset = entity.DepthOffset + 100*data.Direction.Y
		worm.Mass = 0
		worm:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		worm:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		worm.MaxHitPoints = 0
        worm:Update()
        worm.SplatColor = Color(0,0,0,0)

        data.Worm = worm

        local cord = mod:SpawnEntity(mod.Entity.TongueCord, entity.Position + 100*data.Direction, Vector.Zero, entity)
        cord.Parent = worm
        cord.Target = entity
        cord.DepthOffset = worm.DepthOffset + 100*data.Direction.Y
        cord:Update()
        cord.SplatColor = Color(0,0,0,0)

        data.Tonguecord = cord

        
        sfx:Play(Isaac.GetSoundIdByName("burp"))
        
        game:SpawnParticles (entity.Position+20*data.Direction+Vector(0,10), EffectVariant.POOP_PARTICLE, 20, 13, mod.Colors.black)
        local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position+20*data.Direction+Vector(0,-5), Vector.Zero, entity)
        bloody:GetSprite().Color = mod.Colors.black

    elseif not sprite:IsPlaying("Collision") then

        local worm_distance_flag = data.Worm and data.Worm.Position:Distance(entity.Position) < 20
        local no_worm_flag = not data.Worm
        if (worm_distance_flag or no_worm_flag) and data.StateFrame > 60 or data.StateFrame > 90 then

            if data.Worm then
                data.Worm:Remove()
            end
            if data.Tonguecord then
                data.Tonguecord:Remove()
            end
        
            data.Worm = nil
            data.Tonguecord = nil
    
            entity.SpriteOffset = Vector.Zero
            sprite:Play("Collision",true)
            
            sfx:Play(Isaac.GetSoundIdByName("frog_gulp"))

            if data.PosOffset then
                entity.Position = entity.Position - data.PosOffset
            end
        end
    end
end
function mod:Terra2Nova(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("NukeStart",true)
        data.N_NOVAS = mod.TConst.N_NOVAS
        
        sfx:Play(mod.SFX.Geiger, 1, 2, false, 1)

    elseif sprite:IsFinished("NukeStart") then
        sprite:Play("NukeIdle",true)

    elseif sprite:IsFinished("NukeIdle") then
        data.N_NOVAS = data.N_NOVAS - 1
        if data.N_NOVAS <= 0 then
            sprite:Play("NukeEnd",true)
            data.Nova:GetData().Gone = true

            local offset = 360*rng:RandomFloat()
            for i=0, mod.TConst.N_NOVA_SHOTS-1 do
                local angle = i*360/mod.TConst.N_NOVA_SHOTS + offset
                local velocity = Vector(mod.TConst.N_NOVA_SPEED, 0):Rotated(angle)
                local shot = mod:SpawnMarsShot(entity.Position, velocity, entity, nil, Color(0,1,0, 1))--, 0,0.8,0))
                shot:AddProjectileFlags(ProjectileFlags.ACCELERATE)
                shot.Acceleration = 1.02
            end

        else
            if data.N_NOVAS == 3 then
                sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_OPEN,1,2,false,2)
            end
            sprite:Play("NukeIdle",true)
        end

    elseif sprite:IsFinished("NukeEnd") then
        data.State = mod.T2MSState.IDLE
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then
        local nova = mod:SpawnEntity(mod.Entity.TerraNova, entity.Position - Vector(0,40), Vector.Zero, entity):ToEffect()
        nova.Parent = entity
        nova:FollowParent(entity)
        data.Nova = nova
        nova:Update()
        
        sfx:Play(SoundEffect.SOUND_SIREN_SCREAM_ATTACK,1,2,false, 1.25)

    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_SIREN_LUNGE,1,2,false, 0.75)
        
    end
end
function mod:Terra2Annoyed(entity, data, sprite, target,room)

    if sprite:IsPlaying("Move") then
        data.Inmovible = false
    end

    if sprite:IsFinished() then
        if entity.Child:GetData().State ~= mod.T3MSState.NOVA then
            data.State = mod.T2MSState.IDLE
            data.StateFrame = 0
            return
        end
    end

    if data.StateFrame == 1 then
        sprite:Play("Move",true)
        sfx:Play(mod.SFX.CorpsePush, 1, 2,false, 1.5)
    elseif sprite:IsFinished("Move") then
        sprite:Play("Idle",true)

    elseif sprite:IsFinished("Idle") then
        sprite:Play("Idle",true)

    elseif sprite:IsFinished("Annoyed") then
        sprite:Play("Idle",true)
    end

    if sprite:IsEventTriggered("Sound") then
        sfx:Play(Isaac.GetSoundIdByName("ugh"))
    elseif sprite:IsEventTriggered("Move") then
        local direction = (room:GetCenterPos() - entity.Position):Normalized()
        entity.Velocity = direction * mod.TConst.SPEED2
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("annoyed"))
    end

    if entity.Position:Distance(target.Position) < 120 and (not sprite:IsPlaying("Annoyed")) then
        sprite:Play("Annoyed",true)
    end
end
function mod:Terra2Defeated(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        entity:GetSprite():Play("Defeat", true)

    elseif sprite:IsFinished("Defeat") then
        local terra = mod:SpawnEntity(mod.Entity.Terra2, entity.Position, Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.Terra2].SUB + 1)
        
        terra:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        terra:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
        terra:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        terra:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
        --terra:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        --terra:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        terra:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        terra:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

        terra:GetSprite():Play("Defeat", true)
        terra:GetSprite():SetFrame(99)

        terra.HitPoints = 999999

        entity:Remove()
    end
end
function mod:Terra2Swarm(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("SummonStart",true)
        data.N_SWARMS = mod.TConst.N_SWARMS
    elseif sprite:IsFinished("SummonStart") then
        sprite:Play("SummonIdle",true)
        

    elseif sprite:IsFinished("SummonIdle") then
        data.N_SWARMS = data.N_SWARMS - 1
        if data.N_SWARMS <= 0 then
            sprite:Play("SummonEnd",true)
        else
            sprite:Play("SummonIdle",true)
        end
    elseif sprite:IsFinished("SummonEnd") then
        data.State = mod.T2MSState.IDLE
        data.StateFrame = 0

        
    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(SoundEffect.SOUND_BEAST_DEATH_2, 1.5, 2, false, 0.8)
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_HUSH_ROAR, 1, 2, false, 1.1)
    end

    if sprite:IsPlaying("SummonIdle") then
        if entity.FrameCount % mod.TConst.SWARM_PERIOD == 0 then
            if #Isaac.FindByType(EntityType.ENTITY_ATTACKFLY, 0, 0) < mod.TConst.MAX_LOCUST then
                local position = entity.Position + mod:RandomVector(60,40)
                local locust = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, position, Vector.Zero, entity)
                locust:Update()
                locust:GetSprite():Load("gfx/003.231_abyss_locust.anm2", true)
                locust:GetSprite():Play("Idle", true)
                locust:SetColor(mod.TConst.LOCUST_COLORS[mod:RandomInt(1,#mod.TConst.LOCUST_COLORS)], 0, 99, true, true)
                locust.MaxHitPoints = 8
                locust.HitPoints = locust.MaxHitPoints

                locust:SetSize(10, Vector.One, 12)
    
                sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)
    
                --locust.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            end
        end
    end
end

function mod:Terra2Look(entity, sprite, data, room, target)
	local layer = sprite:GetLayer(3)
	if (not entity:IsDead()) and data.State ~= mod.T2MSState.NOVA then
		local direction = (target.Position - (entity.Position + Vector(0,20))):Normalized()
        direction.Y = direction.Y * 0.25
		local final_direction = mod:Lerp(layer:GetPos(), direction*5, 0.05)
		layer:SetPos(final_direction)
    elseif data.State == mod.T2MSState.NOVA then
		layer:SetPos(Vector.Zero)
	else
		local final_direction = mod:Lerp(layer:GetPos(), Vector.Zero, 0.5)
		layer:SetPos(final_direction)
	end
end

mod.T3MSState = {
    APPEAR = 0,
    IDLE = 1,

    SHOT = 2,
    BURST = 3,
    LASER = 4,
    NOVA = 5,
    HORSEMEN = 6,
    METEORS = 7,
    DASH = 8,

}
mod.chainT3 = {--               App     idle    shot    burst   laser   nova    horse   meteor  dash
    [mod.T3MSState.APPEAR] =    {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.IDLE] =      {0,     8,      0.4,    1,      1,      2,      1,      1,      1.5},
    [mod.T3MSState.SHOT] =      {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.BURST] =     {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.LASER] =     {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.NOVA] =      {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.HORSEMEN] =  {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.METEORS] =   {0,     1,      0,      0,      0,      0,      0,      0,      0},
    [mod.T3MSState.DASH] =      {0,     1,      0,      0,      0,      0,      0,      0,      0},
}
mod.chainT3 = mod:NormalizeTable(mod.chainT3)

local AddTerraRoots = function (entity, data)
    data.EnabledTrains = true

    data.TrailPos = Vector(10,0)
    data.Trails = {}
    for i=1, 4 do
        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, entity.Position, Vector.Zero, nil):ToEffect()
        --trail:FollowParent(entity)
        trail.Color = Color(0.5,0.5,0.5,1,0,0.1+i*0.1,0)
        trail.MinRadius = 0.05

        trail:Update()

        trail.DepthOffset = 180

        table.insert(data.Trails, trail)
    end
end
function mod:Terra3Update(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Terra3].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra3].SUB then
        --if true then return end
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()
        
        --Custom data:
        if data.State == nil then
            data.State = 0
            data.StateFrame = 0

            data.TearFlag = 0
            data.TearCount = 0

            --entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE
        end
        
        --Frame
        data.StateFrame = data.StateFrame + 1

        if data.State == mod.T3MSState.APPEAR then
            if data.StateFrame == 1 then
                entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                
                local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, entity.Position, Vector.Zero, entity):ToEffect()
                if glow then
                    glow:FollowParent(entity)
                    glow.SpriteScale = Vector.One*2
                    glow:GetSprite().Color = mod.Colors.fire
                end

            elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                data.State = mod:MarkovTransition(data.State, mod.chainT3)
                data.StateFrame = 0

                AddTerraRoots(entity, data)

            elseif sprite:IsEventTriggered("EndAppear") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            
        elseif data.State == mod.T3MSState.IDLE then
            if data.StateFrame == 1 then
                sprite:Play("Idle",true)
            elseif sprite:IsFinished("Idle") then
                mod:ChangeEdenTerraState(data, entity.Parent)
            else
                mod:Terra3Move(entity, data, room, target)
            end
            
        elseif data.State == mod.T3MSState.HORSEMEN then
            mod:Terra3Horsemen(entity, data, sprite, target,room)
        elseif data.State == mod.T3MSState.METEORS then
            mod:Terra3Meteors(entity, data, sprite, target,room)
        elseif data.State == mod.T3MSState.BURST then
            mod:Terra3Burst(entity, data, sprite, target,room)
        elseif data.State == mod.T3MSState.LASER then
            mod:Terra3Laser(entity, data, sprite, target,room)
        elseif data.State == mod.T3MSState.SHOT then
            mod:Terra3Shot(entity, data, sprite, target,room)
        elseif data.State == mod.T3MSState.NOVA then
            mod:Terra3Nova(entity, data, sprite, target,room)
        elseif data.State == mod.T3MSState.DASH then
            mod:Terra3Dash(entity, data, sprite, target,room)
        end

        if data.StateFrame % 2 == 0 then
            local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ULTRA_GREED_BLING, 0, entity.Position + Vector(0,0)  + RandomVector() * ( 20 * rng:RandomFloat() + 25 ), Vector.Zero, entity)
            shine.DepthOffset = 50
        end
        
        if data.TrailPos then
            data.TrailPos = data.TrailPos:Rotated(20)
            for i, trail in ipairs(data.Trails) do
                --trail.Position = entity.Position + mod:RandomVector(10,10)
                trail.Position = entity.Position + data.TrailPos:Rotated(i*90) + mod:RandomVector(3,3)
            end    
        end
    end
end
function mod:Terra3Horsemen(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        if #mod:FindByTypeMod(mod.Entity.Horsemen) == 0 then
            sprite:Play("Summon",true)
        else
            mod:ChangeEdenTerraState(data, entity.Parent)
        end

        data.HORSEMEN_IDLES = mod.TConst.HORSEMEN_IDLES
    elseif sprite:IsFinished("Summon") then
        sprite:Play("Idle",true)

    elseif sprite:IsFinished("Idle") then
        data.HORSEMEN_IDLES = data.HORSEMEN_IDLES - 1
        if data.HORSEMEN_IDLES <= 0 then
            mod:ChangeEdenTerraState(data, entity.Parent)
        else
            sprite:Play("Idle",true)
        end

    elseif sprite:IsEventTriggered("Sound") then

        sfx:Play(Isaac.GetSoundIdByName("Horn"), 2.3, 2, false, 1)

    elseif sprite:IsEventTriggered("Attack") then

        local margen = -900
        for i=0, 2 do
            local position = Vector(margen*i, room:GetCenterPos().Y + mod:RandomInt(-150,150))
            local horsemen = mod:SpawnEntity(mod.Entity.Horsemen, position, Vector.Zero, entity):ToNPC()
            horsemen:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            horsemen.I1 = i
            horsemen.I2 = 0
        end

        local position = Vector(margen*2, room:GetCenterPos().Y + mod:RandomInt(-50,50))
        for i=-1, 1, 2 do
            local horsemen = mod:SpawnEntity(mod.Entity.Horsemen, Vector(position.X, position.Y + 150*i), Vector.Zero, entity):ToNPC()
            horsemen:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            horsemen.I1 = i/2 + 7/2
            horsemen.I2 = 0

            if mod.savedatasettings().Difficulty == mod.Difficulties.NORMAL then
                horsemen.Position = Vector(horsemen.Position.X, room:GetCenterPos().Y)
                break
            end
        end
    end
end
function mod:Terra3Meteors(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        sprite:Play("Meteors",true)
        
        sfx:Play(Isaac.GetSoundIdByName("Leafs"), 2, 2, false, 1)
        
    elseif sprite:IsFinished("Meteors") then
        sprite:Play("Idle",true)
        data.N_METEORS_IDLES = mod.TConst.N_METEORS_IDLES
    elseif sprite:IsFinished("Idle") then
        data.N_METEORS_IDLES = data.N_METEORS_IDLES - 1
        if data.N_METEORS_IDLES <= 0 then
            mod:ChangeEdenTerraState(data, entity.Parent)
        else
            sprite:Play("Idle",true)
        end

    elseif sprite:IsEventTriggered("Attack") then
        for i=1, mod.TConst.N_POLLEN do
            local velocity = mod:RandomVector(7,3)

            local pollen = mod:SpawnEntity(mod.Entity.Pollen, entity.Position, velocity, entity)
            pollen.Parent = entity
            pollen.DepthOffset = 200
            
        end

        game:SpawnParticles(entity.Position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 20, 12, mod.Colors.fire)

        sfx:Play(Isaac.GetSoundIdByName("dust"), 1)
    end
end
function mod:Terra3Burst(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        sprite:Play("Attack",true)
        entity.Velocity = Vector.Zero

        data.HELL_IDLES = mod.TConst.HELL_IDLES
    elseif sprite:IsFinished("Attack") then
        sprite:Play("AttackFast",true)
        data.N_BULLET_HELL = mod.TConst.N_BULLET_HELL
    elseif sprite:IsFinished("AttackFast") then
        data.N_BULLET_HELL = data.N_BULLET_HELL - 1
        if data.N_BULLET_HELL <= 0 then
            data.TearFlag = 0
            sprite:Play("Idle",true)
        else
            sprite:Play("AttackFast",true)
        end
    elseif sprite:IsFinished("Idle") then
        data.HELL_IDLES = data.HELL_IDLES - 1
        if data.HELL_IDLES <= 0 then
            mod:ChangeEdenTerraState(data, entity.Parent)
        else
            sprite:Play("Idle",true)
        end

    elseif sprite:IsEventTriggered("Attack") or (sprite:IsPlaying("AttackFast") and sprite:GetFrame() % mod.TConst.BULLET_HELL_PERIOD == 0) then
        data.TearFlag = (data.TearFlag + 1)%3
    end

    if sprite:IsPlaying("AttackFast") then
        --Isaac from Hard mode major boss patters was of big help here
        if data.TearFlag == 0 and game:GetFrameCount() % 4 == 0 then --Pretty circle

            local params = ProjectileParams()
            params.Variant = ProjectileVariant.PROJECTILE_HUSH
            params.FallingSpeedModifier = 0

            params.BulletFlags = ProjectileFlags.CURVE_LEFT | ProjectileFlags.NO_WALL_COLLIDE
            params.CurvingStrength = 0.014
            params.FallingAccelModifier = -0.16
            params.Color = mod.TConst.EDEN_COLORS[data.TearCount%(#mod.TConst.EDEN_COLORS)+1]
            data.TearCount = data.TearCount + 1

            for i=1, mod.TConst.N_TEARS do
                local angle = i*360/mod.TConst.N_TEARS
                entity:FireProjectiles(entity.Position + Vector(0,20), Vector.FromAngle(angle)*mod.TConst.TEAR_SPEED, 0, params)
            end

            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
        elseif data.TearFlag == 1 and game:GetFrameCount() % 5 == 0 then

            local params = ProjectileParams()
            params.Variant = ProjectileVariant.PROJECTILE_HUSH
            params.FallingSpeedModifier = 0

            params.BulletFlags = 1 << (18 + entity.FrameCount % 2) | ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT | ProjectileFlags.ACCELERATE
            params.CurvingStrength = 0.014
            params.Acceleration = 0.98
            params.FallingAccelModifier = -0.165
            params.ChangeTimeout = 60
            params.ChangeFlags = 0
            params.Color = mod.TConst.EDEN_COLORS[data.TearCount%(#mod.TConst.EDEN_COLORS)+1]
            data.TearCount = data.TearCount + 1

            for i=1, mod.TConst.N_TEARS do
                local angle = i*360/mod.TConst.N_TEARS
                entity:FireProjectiles(entity.Position + Vector(0,20), Vector.FromAngle(angle+entity.ProjectileCooldown*3)*mod.TConst.TEAR_SPEED*9/7, 0, params)
            end

            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
        elseif data.TearFlag == 2 and game:GetFrameCount() % 5 == 0 then
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
        end
    end
end
function mod:Terra3Laser(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("FastIdle", true)
        data.N_LASER_WAITS = mod.TConst.N_LASER_WAITS
        data.TargetPosition = nil
        
        local direction = (entity.Position - target.Position):Normalized()
        data.AimPosition = direction*100

        entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE

    elseif sprite:IsFinished("FastIdle") then
        if room:IsPositionInRoom(entity.Position, entity.Size) or data.TargetPosition then
            data.N_LASER_WAITS = data.N_LASER_WAITS - 1
            if data.N_LASER_WAITS <= 0 then
                data.TargetPosition = data.TargetPosition or target.Position
                sprite:Play("Laser", true)
                entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
            else
                if data.N_LASER_WAITS == 1 then
                    data.TargetPosition = target.Position
                    entity.Velocity = Vector.Zero

                    sfx:Play(SoundEffect.SOUND_THUMBSUP)
                    entity:SetColor(Color(1,1,1,1,0.5,0.5,0), 20, 1, true, true)
                end
                sprite:Play("FastIdle", true)
            end
        else
            sprite:Play("FastIdle", true)
        end

    elseif sprite:IsFinished("Laser") then
        mod:ChangeEdenTerraState(data, entity.Parent)

    elseif sprite:IsEventTriggered("Attack") then
        local direction = data.TargetPosition - entity.Position
        local n = mod.TConst.N_LASERS_CROSS
        for i=0,n-1 do
            local angle = direction:GetAngleDegrees() + i*360/n
            local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, entity.Position + Vector(15,0):Rotated(angle), angle, 1, Vector(0,-5), entity)
            laser.DepthOffset = 20
            laser:GetSprite().Color = mod.Colors.ghost
        end
    end

    if sprite:IsPlaying("FastIdle") then
        if not data.TargetPosition then
            data.AimPosition = data.AimPosition:Rotated(mod.TConst.LASER_ROTATION_SPEED)

            local aim_position = target.Position + data.AimPosition
            local velocity = (aim_position - entity.Position)*0.3

            entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.5)
        end
    elseif sprite:WasEventTriggered("Attack") then
        local direction = data.TargetPosition - entity.Position
        local velocity = Vector(15,0):Rotated(direction:GetAngleDegrees() + 180)

        --entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.05)
        entity.Velocity = Vector.Zero
    end
end
function mod:Terra3Shot(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        sprite:Play("Attack",true)
        entity.Velocity = Vector.Zero
    elseif sprite:IsFinished("Attack") then
        mod:ChangeEdenTerraState(data, entity.Parent)

    elseif sprite:IsEventTriggered("Attack") then
                    
        local color = mod.TConst.EDEN_COLORS[mod:RandomInt(1,#mod.TConst.EDEN_COLORS)]
        for i=1, 8 do
            local angle = i*360/8
            local velocity = Vector(4,0):Rotated(angle)
            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH, 0, entity.Position, velocity, entity):ToProjectile()
            if tear then
                tear.Scale = 1.5
                tear:GetSprite().Color = color
            end
        end

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
    end
end
function mod:Terra3Nova(entity, data, sprite, target,room)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        entity.Parent = mod:FindByTypeMod(mod.Entity.Terra2)[1]
        if room:IsPositionInRoom(entity.Parent.Position, 80) and entity.Position:Distance(entity.Parent.Position) < 5.5*40 and entity.Position:Distance(entity.Parent.Position) > 60 and not (entity.Parent:GetData().State == mod.T2MSState.NOVA) then

            sfx:Play(Isaac.GetSoundIdByName("bagsound"),1,2,false,2)
            sprite:Play("NovaStart",true)
            entity.Velocity = Vector.Zero
        else
            mod:ChangeEdenTerraState(data, entity.Parent)
        end
    elseif sprite:IsFinished("NovaStart") then
        sfx:Play(Isaac.GetSoundIdByName("bagclose"),1,2,false,2)

        sfx:Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 1,2, false, 0.5)
        sprite:Play("NovaCharge",true)
        data.N_NOVA_CHARGES = mod.TConst.N_NOVA_CHARGES
    elseif sprite:IsFinished("NovaCharge") then
        data.N_NOVA_CHARGES = data.N_NOVA_CHARGES - 1
        if data.N_NOVA_CHARGES <= 0 then
            sprite:Play("NovaAttack",true)
        else
            sprite:Play("NovaCharge",true)
        end
    elseif sprite:IsFinished("NovaAttack") then
        sprite:Play("NovaLaser",true)
        data.N_NOVA_ATTACKS = mod.TConst.N_NOVA_ATTACKS

        local rock = entity.Parent
        if rock then
            --Spin direction
            local p1 = target.Position-entity.Position
            local p2 = rock.Position-entity.Position
            local crossproductZ = p1.X * p2.Y - p1.Y * p2.X
            local spin = 1
            if crossproductZ > 0 then
                spin = -spin
            end

            data.Lasers = {}
            for j=-0,1 do
                local offset = 180*j
                local n = mod.TConst.N_LASERS
                for i=1, n do
                    local direction = rock.Position - entity.Position
                    local angle = direction:GetAngleDegrees() + 2*(0.5 - i/n)*mod.TConst.LASER_OFFSET + offset - 90
                    local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_RING, entity.Position, angle, -1, Vector(0,-10), entity)
                    --laser:GetSprite():Load("gfx/007.005_lightbeam.anm2", true)
                    laser.DepthOffset = 100
                    --laser:SetScale(laser:GetScale()*2)
                    
                    laser.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                    
                    laser:GetData().IsFlower = true
                    laser:GetData().Index = i
                    laser:SetActiveRotation(0, 99999, spin*mod.TConst.NOVA_SPIN_SPEED, false)

                    --laser:SetColor(mod.TConst.NOVA_COLORS[i], 9999, 99, true, true)
                    --laser:SetColor(Color(1,1,1,1,0.5,0.5,0), 9999, 99, true, true)

                    local color = Color.Lerp(Color(1,1,1,1,0.5,0.5,0),mod.TConst.NOVA_COLORS[i],0.5)
                    laser:SetColor(color, 9999, 99, true, true)

                    laser:AddTearFlags(TearFlags.TEAR_WIGGLE)
                    laser:AddTearFlags(TearFlags.TEAR_RAINBOW)

                    --laser.Angle = laser.Angle - 90

                    table.insert(data.Lasers, laser)

                                
                    for i=1,2 do
                        game:SpawnParticles(entity.Position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 1, 12, color)
                    end
                end
            end

            mod:scheduleForUpdate(function ()
                sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
            end,2)
            sfx:Play(SoundEffect.SOUND_ANGEL_BEAM)
            
            sfx:Play(SoundEffect.SOUND_MEGA_BLAST_START,1,0,false,2)
            sfx:Play(mod.SFX.LightBeam, 1, 2, true)
        end

    elseif sprite:IsFinished("NovaLaser") then
        data.N_NOVA_ATTACKS = data.N_NOVA_ATTACKS - 1
        if data.N_NOVA_ATTACKS <= 0 then
            sprite:Play("NovaEnd",true)
            
            for i, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
                if laser:GetData().IsFlower then
                    laser:Remove()
                end
            end
            sfx:StopLoopingSounds()
            sfx:Play(SoundEffect.SOUND_MEGA_BLAST_END,1,0,false,2)
            sfx:Play(mod.SFX.LightBeamEnd)

            sprite.Color = Color.Default
        else
            sprite:Play("NovaLaser",true)
        end
    elseif sprite:IsFinished("NovaEnd") then
        mod:ChangeEdenTerraState(data, entity.Parent)

    end

    if sprite:IsPlaying("NovaLaser") and entity.Parent and data.Lasers then
        local rock = entity.Parent
        local lasers = data.Lasers
        local smokeFlag = entity.FrameCount%2==0

        for i, laser in ipairs(lasers) do
            if laser then
                local distance = rock.Position:Distance(entity.Position)
                local laser_angle = laser.Angle
                local laser_direction = Vector(distance, 0):Rotated(laser_angle)
                
                if rock.Position:Distance(entity.Position + laser_direction) < 50 then
                    
                    laser.MaxDistance = distance-rock.Size

                    if target.Position:Distance(entity.Position) > rock.Position:Distance(entity.Position) then
                        laser.CollisionDamage = 0
                    else
                        laser.CollisionDamage = 1
                    end

                    local rs = laser.RotationSpd
                    laser.RotationSpd = 0
                    laser.IsActiveRotating = false
                    for i=1,5 do laser:Update() end
                    laser.RotationSpd = rs
                    laser.IsActiveRotating = true
                else
                    laser.CollisionDamage = 1
                    laser.MaxDistance = 0
                end

                local sign = (laser.RotationSpd/math.abs(laser.RotationSpd))
                if laser.FrameCount > 5 then
                    local position = laser.EndPoint
                    local velocity = Vector(laser.RotationSpd,0):Rotated(laser.Angle + sign*90)
                    if smokeFlag then
                        local scale = Vector.One * (0.4 + 0.3*rng:RandomFloat())

                        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, position + velocity, velocity, laser)
                        dust:GetSprite().Color = laser:GetSprite().Color
                        dust.SpriteScale = scale
                        
                        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, position + velocity, velocity, laser)
                        dust:GetSprite().Color = laser:GetSprite().Color
                        dust.SpriteScale = scale
                    end
                        
                end

                laser.RotationSpd = laser.RotationSpd + 0.0155 * sign * laser:GetData().Index
            end
        end

        
        local rColor = mod:rainbowCycle(entity.FrameCount*15)
        sprite.Color = Color(rColor[1], rColor[2], rColor[3])
    end

end
function mod:Terra3Dash(entity, data, sprite, target,room)
        
    if data.StateFrame == 1 then
        data.ColFrames = 10

        entity.Parent = mod:FindByTypeMod(mod.Entity.Terra2)[1]
        if not room:IsPositionInRoom(entity.Parent.Position, 75) then
        
            sprite:Play("FastIdle",true)
            entity.Velocity = Vector.Zero
            data.N_DASH = mod.TConst.N_DASH
            data.TargetDir = nil
        else
            mod:ChangeEdenTerraState(data, entity.Parent)
        end
    elseif sprite:IsFinished("FastIdle") then
        if data.N_DASH <= 0 then
            --entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
            mod:ChangeEdenTerraState(data, entity.Parent)
            entity.CollisionDamage = 0
            return
        else
            sprite:Play("FastIdle",true)
        end
    end

    if data.StateFrame > 45 then
        entity.CollisionDamage = 1
        if data.TargetDir then
            local frames = data.StateFrame - data.TargetFrame
            local velocity = data.TargetDir * 20

            entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.05)

            if frames > 30 then
                data.TargetDir = nil
            end
        else
            data.TargetDir = (target.Position - entity.Position):Normalized()
            data.TargetFrame = data.StateFrame
            data.N_DASH = data.N_DASH - 1
            
            local velocity = data.TargetDir * 20
            entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.5)

            sfx:Play(Isaac.GetSoundIdByName("Throw"),1,2,false, 1.5+rng:RandomFloat())
            
            local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, entity.Position, Vector.Zero, nil)
            impact.SpriteScale = Vector.One*1.25
        end
    end

    data.ColFrames = data.ColFrames - 1
    if entity:CollidesWithGrid() and data.ColFrames < 0 then
        data.ColFrames = 10
        data.TargetDir = nil
        entity.Velocity = Vector.Zero
    end

    if entity.Velocity:Length() > 5 and entity.FrameCount % 2 == 0 then
        local trace = mod:SpawnEntity(mod.Entity.MercuryTrace, entity.Position, -entity.Velocity * 0.1, entity, nil, mod.EntityInf[mod.Entity.MercuryTrace].SUB+1)
        trace.Parent = entity
    end
    
end

function mod:ChangeEdenTerraState(data, rockTerra)
    data.State = mod:MarkovTransition(data.State, mod.chainT3)
    data.StateFrame = 0

    local new_flower_state = data.State

    if rockTerra then
        local rockData = rockTerra:GetData()

        if rockData and rockData.State and rockData.State == mod.T2MSState.IDLE or rockData.State == mod.T2MSState.MOVE then

            if new_flower_state == mod.T3MSState.BURST then
                rockData.State = mod.T2MSState.FROG
            elseif new_flower_state == mod.T3MSState.LASER then
                rockData.State = mod.T2MSState.TONGUE
            elseif new_flower_state == mod.T3MSState.NOVA then
                rockData.State = mod.T2MSState.ANNOYED
            elseif new_flower_state == mod.T3MSState.HORSEMEN then
                rockData.State = mod.T2MSState.SWARM
            elseif new_flower_state == mod.T3MSState.METEORS then
                rockData.State = mod.T2MSState.METEOR
            elseif new_flower_state == mod.T3MSState.DASH then
                rockData.State = mod.T2MSState.NOVA
            end

            if not (mod.T2MSState.IDLE == rockData.State or mod.T2MSState.MOVE == rockData.State) then
                rockData.StateFrame = 0
            end

        else
            data.State = mod.T3MSState.IDLE
        end

    end

end

--Move
function mod:Terra1Move(entity, data, room, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room
	
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.TConst.IDLE_TIME_INTERVAL1.X, mod.TConst.IDLE_TIME_INTERVAL1.Y)
		--V distance of Terra from the center of the room
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.TConst.SPEED1
	data.targetvelocity = data.targetvelocity * 0.99
end
function mod:Terra2Move(entity, data, sprite, target,room)
    if data.StateFrame == 1 then
        sprite:Play("Move",true)
        sfx:Play(mod.SFX.CorpsePush, 1, 2,false, 1.5)
    elseif sprite:IsFinished("Move") then
        data.State = mod.T2MSState.IDLE
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Move") then
        local direction
        if room:IsPositionInRoom(entity.Position, 80) then
            direction = (target.Position - entity.Position):Normalized()
        else
            direction = (room:GetCenterPos() - entity.Position):Normalized()
        end
        entity.Velocity = direction * mod.TConst.SPEED2
        
    end
end
function mod:Terra3Move(entity, data, room, target)
	--idle move taken from 'Alt Death' by hippocrunchy
	--It just basically stays around the center of the room

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
        data.idleTime = mod:RandomInt(mod.TConst.IDLE_TIME_INTERVAL3.X, mod.TConst.IDLE_TIME_INTERVAL3.Y)

        local antipode = (target.Position - room:GetCenterPos()):Rotated(180):Normalized()*150 + room:GetCenterPos()
        --V distance of Eden from the oposite place of the player
        local distance = antipode:Distance(entity.Position)
        
        --If its too far away, return to the center
        if distance > 80 then
            data.targetvelocity = ((antipode - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-25, 25))
        end

        --Not that close to the plater
        if target.Position:Distance(entity.Position) < 100 or data.targetvelocity == nil then
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.TConst.SPEED3
	data.targetvelocity = data.targetvelocity * 0.99
end

--ded
function mod:TerraDeath(entity)
    local data = entity:GetData()
    local room = game:GetRoom()

    if entity.Variant == mod.EntityInf[mod.Entity.Terra1].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra1].SUB then

        local rock = mod:SpawnEntity(mod.Entity.Terra2, entity.Position, Vector.Zero, nil)
        rock:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        rock:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
        rock:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        rock:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
        rock:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        rock:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        rock:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        rock:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

        rock:GetSprite():Play("AppearSlow",true)
        rock:GetData().State = mod.T2MSState.APPEAR
        rock:GetData().StateFrame = 0
        rock:GetData().SlowSpawn = true
        rock.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        local flash = mod:SpawnEntity(mod.Entity.ICUP, room:GetCenterPos(), Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.ICUP].SUB+9)

        --local eden = mod:SpawnEntity(mod.Entity.Terra3, entity.Position, RandomVector()*7, nil)
        --eden.Parent = rock
        --rock.Child = eden

        --Save things
        if mod.savedatarun().planetAlive then
            mod.savedatarun().planetNum = mod.Entity.Terra2
            mod.savedatarun().planetHP = 1150
        end

        game:BombExplosionEffects ( entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
		sfx:Play(Isaac.GetSoundIdByName("doom_explosion"), 1)
        game:ShakeScreen(60)

        local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
        fracture.SpriteScale = Vector.One * 1.2

        if mod:IsChallenge(mod.Challenges.BabelTower) then
            mod:ChangeRoomBackdrop(mod.Backdrops.DOOM_FOREST, nil, room:GetDecorationSeed())
        end

    elseif entity.Variant == mod.EntityInf[mod.Entity.Terra2].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra2].SUB then

        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Horsemen)) do
            e:Remove()
        end

        mod:NormalDeath(entity)

        if entity.Child then
            entity.Child:Die()
        end
        local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_EDENS_BLESSING, entity.Position, Vector.Zero, nil)
        
    elseif entity.Variant == mod.EntityInf[mod.Entity.Terra3].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra3].SUB then
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Horsemen)) do
            e:Remove()
        end
        for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT)) do
            e:Remove()
        end

        if entity.Parent then
            local rockTerra = entity.Parent
            rockTerra:GetData().State = mod.T2MSState.DEFEATED
            rockTerra:GetData().StateFrame = 0
            rockTerra:GetData().IsDead = true
        end

        mod:NormalDeath(entity, false, true)
    end
end
--deding
function mod:TerraDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Terra1].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra1].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if data.deathFrame == nil then data.deathFrame = 1 end
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if sprite:GetFrame() == 1 and entity.Variant == mod.EntityInf[mod.Entity.Terra1].VAR then

                sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)

                sfx:Play(Isaac.GetSoundIdByName("Ow"), 1, 2, false, 1)
            end
        end

    elseif entity.Variant == mod.EntityInf[mod.Entity.Terra3].VAR and entity.SubType == mod.EntityInf[mod.Entity.Terra3].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if data.deathFrame == nil then data.deathFrame = 1 end
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if sprite:GetFrame() == 1 and entity.Variant == mod.EntityInf[mod.Entity.Terra1].VAR then
                for i, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
                    if laser:GetData().IsFlower then
                        laser:Die()
                    end
                end

            elseif sprite:IsEventTriggered("Sound") then
                sfx:Play(SoundEffect.SOUND_THUMBSUP)
            end
        end
    end
end

--Callbacks
--Terra updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.Terra1Update, mod.EntityInf[mod.Entity.Terra1].ID)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.Terra2Update, mod.EntityInf[mod.Entity.Terra2].ID)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.Terra3Update, mod.EntityInf[mod.Entity.Terra3].ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.TerraDeath, mod.EntityInf[mod.Entity.Terra1].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.TerraDying, mod.EntityInf[mod.Entity.Terra1].ID)

--Laser
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_,entity)
    if entity:GetData().FromEden_HC then
        if entity:GetData().Countdown_HC < 20 then
            entity.IsActiveRotating = true
            entity:GetData().FromEden_HC = false
        else
            entity:GetData().Countdown_HC = entity:GetData().Countdown_HC - 1
        end
    end
end)

--OTHERS-----------------------------------------------
--Horsemen---------------------------------------------------------------------------------------------------------------------
function mod:HorsemenUpdate(entity)
	if mod.EntityInf[mod.Entity.Horsemen].VAR == entity.Variant or mod.EntityInf[mod.Entity.AltHorsemen].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local parent = entity.Parent
		local data = entity:GetData()

		if mod.EntityInf[mod.Entity.AltHorsemen].VAR == entity.Variant then
			entity.I2 = 1
		else
			entity.I2 = 0
		end

		if entity.I1 == 0 or entity.I1 == nil then --Famine

			if data.Init == nil then
				data.Init = true
	
				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
				sprite:Play("Famine", true)
				sprite:SetFrame(100)
	
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				
				data.Speed = mod.TConst.HORSEMEN_SPEED

				entity.CollisionDamage = 0
	
			end
	
	
			if sprite:IsEventTriggered("Attack") then
				local direction = (target.Position - entity.Position):Normalized()

				if entity.I2 == 0 then
					for i=-1, 1 do
						local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, direction:Rotated(i*mod.TConst.FAMINE_SHOT_ANGLE)*mod.TConst.FAMINE_SHOT_SPEED, entity):ToProjectile()
					end
				else
					local waterParams = ProjectileParams()
					waterParams.Variant = ProjectileVariant.PROJECTILE_TEAR
					entity:FireBossProjectiles (5, target.Position + direction*100, 0, waterParams )
				end

				sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0)
			end
			
			if sprite:IsFinished("Famine") then
				entity:Remove()
			end

		elseif entity.I1 == 1 then --Pestilence

				if data.Init == nil then
					data.Init = true
		
					entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
					entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
		
					sprite:Play("Pestilence", true)
					sprite:SetFrame(50)

					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

					data.Speed = mod.TConst.HORSEMEN_SPEED
					data.Farting = false
		
					entity.CollisionDamage = 0
				end
		
		
				if sprite:IsEventTriggered("Attack") then
					sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_5)

					data.Speed = mod.TConst.HORSEMEN_SPEED*2
					data.Farting = true
				end
				
				if data.Farting then
					if entity.FrameCount % 3 == 0 then
						local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, entity):ToEffect()
						gas.Timeout = mod.TConst.PERTILENCE_GAS_TIME
						
						local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 2, entity.Position, Vector.Zero, entity)
					end

					if entity.I2 == 1 and entity.FrameCount % 5 == 0 then
						for i=-1,1,2 do
							local velocity = entity.Velocity:Rotated(i*90)/4
							local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity):ToProjectile()
							tear:GetSprite().Color = mod.Colors.boom
							tear.Scale = 1.5
						end
					end
				end

				if sprite:IsFinished("Pestilence") then
					entity:Remove()
				end
		elseif entity.I1 == 2 then --War

			if data.Init == nil then
				data.Init = true
	
				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
				sprite:Play("War", true)
				sprite:SetFrame(24)
	
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

				data.Speed = 15--mod.TConst.HORSEMEN_SPEED
				if entity.I2 == 0 then
					data.Speed = data.Speed + 5
				end
	
				entity.CollisionDamage = 0
			end

			if sprite:IsEventTriggered("Attack") then

				sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_4)

				local direction = (target.Position - entity.Position):Normalized()

				if entity.I2 == 0 then
					entity.Velocity = Vector(direction.X, -direction.Y) * data.Speed*2
					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

					local rocket = mod:SpawnEntity(mod.Entity.MarsRocket, entity.Position + direction*100, direction, entity):ToBomb()
					rocket:GetData().IsDirected_HC = true
					rocket:GetData().Direction = direction
					rocket:GetSprite().Rotation = direction:GetAngleDegrees()

                    rocket.ExplosionDamage = 10
				else
					for i=1,3 do
						local velocity = (15 + rng:RandomFloat()*15) * direction * 10
						velocity = velocity:Rotated(mod:RandomInt(-45,45))
						local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, entity.Position, velocity, entity):ToBomb()
						bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						bomb:SetExplosionCountdown(60)
                        
                        bomb.ExplosionDamage = 10

						bomb:GetSprite():ReplaceSpritesheet(0, "hc/gfx/items/pick ups/mars_bomb.png", true)
					end	
				end
			end

			if sprite:IsFinished("War") then
				entity:Remove()
			end

		elseif entity.I1 >= 3 then --Death

			if data.Init == nil then
				data.Init = true

				entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)

				sprite:Play("Death", true)
				if entity.I1 == 4 then sprite:Play("Conquest", true) end
				sprite:SetFrame(mod:RandomInt(0,20))

				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

				data.Speed = mod.TConst.HORSEMEN_SPEED + 2

			end


			if sprite:IsEventTriggered("Attack") then
		
				sfx:Play(Isaac.GetSoundIdByName("Slash"), 1, 2, false, 1)

				local sing = 1
				if entity.Position.Y > target.Position.Y then sing = -1 end

                
                if mod.savedatasettings().Difficulty == mod.Difficulties.NORMAL then
                    entity.Velocity =  Vector(data.Speed, data.Speed*sing*0.7)
                else
                    entity.Velocity =  Vector(data.Speed, data.Speed*sing*1.4)
                end
			end

			if sprite:IsFinished("Death") or sprite:IsFinished("Conquest") then
				entity:Remove()
			end
		end

		local direction = 1
		if entity.I2 and entity.I2 == 1 then
			direction = -1
		end

		entity.Velocity =  Vector(direction * data.Speed, entity.Velocity.Y)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.HorsemenUpdate, mod.EntityInf[mod.Entity.Horsemen].ID)

--TarBomb-----------------------------------------------------------------------------------------------------------------------
function mod:TarBombUpdate(entity)
	if mod.EntityInf[mod.Entity.TarBomb].VAR == entity.Variant then
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local parent = entity.Parent
		local data = entity:GetData()

		if data.Init == nil then
			data.Init = true

			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			sprite:Play("Idle"..tostring(mod:RandomInt(1,3)), true)

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

		end

		if sprite:IsFinished("Idle1") or sprite:IsFinished("Idle2") or sprite:IsFinished("Idle3") then
			--Explosion:
			local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity.Parent)
			explode:GetSprite().Color = mod.Colors.tar
			
			--Explosion damage
			for i, e in ipairs(Isaac.FindInRadius(entity.Position, mod.TConst.TAR_EXPLOSION_RADIUS)) do
				if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
					e:TakeDamage(100, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity.Parent), 0)
				end
			end
			
			--Creep
			local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
            if tar then
			    tar.Timeout = 150
			    tar:GetSprite().Scale = 3 * Vector(1,1)
            end
			
			--[[Splash of projectiles:
			for i=0, mod.TConst.N_TAR_RING_PROJECTILES do
				--Ring projectiles:
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector(10,0):Rotated(i*360/mod.TConst.N_TAR_RING_PROJECTILES), entity.Parent):ToProjectile()
				tear:GetSprite().Color = mod.Colors.tar
				tear.FallingSpeed = -0.1
				tear.FallingAccel = 0.3
			end
			for i=0, mod.TConst.N_TAR_RND_PROJECTILES do
				--Random projectiles:
				local angle = mod:RandomInt(0, 360)
				local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector(7,0):Rotated(angle), entity.Parent):ToProjectile()
				tear:GetSprite().Color = mod.Colors.tar
				local randomFall = -1 * mod:RandomInt(1, 500) / 1000
				tear.FallingSpeed = randomFall
				tear.FallingAccel = 0.2
			end]]
			
			for i=1, mod.TConst.N_TAR_BUBBLES do
				local bubble = mod:SpawnEntity(mod.Entity.Bubble, entity.Position, Vector.Zero, entity)
				bubble:GetData().IsTar_HC = true
			end

			
			game:SpawnParticles (entity.Position, EffectVariant.POOP_PARTICLE, 20, 13, mod.Colors.black)
			local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
			bloody:GetSprite().Color = mod.Colors.black

			entity:Remove()
		end

		if entity.FrameCount % 3 == 0 then
			local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
			tar.Timeout = 60
			--tar:GetSprite().Scale = Vector.One
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.TarBombUpdate, mod.EntityInf[mod.Entity.TarBomb].ID)

--Meteor target
function mod:MeteorTargetUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.TerraTarget].SUB then
		effect.DepthOffset = -50
		if effect.Timeout <= 1 then
			local meteor = mod:SpawnEntity(mod.Entity.Meteor, effect.Position, Vector.Zero, effect.Parent)
			meteor.Parent = effect.Parent

			effect:Remove()
		end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.MeteorTargetUpdate, mod.EntityInf[mod.Entity.TerraTarget].VAR)

--Meteors
function mod:MeteorUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Meteor].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if data.Init == nil then
            data.Init = true

            if rng:RandomFloat() < 0.01 then
                sprite:Play("Type3",true)
            else
                sprite:Play("Type"..tostring(mod:RandomInt(1,2)),true)
            end
        end

        if sprite:IsFinished("Type1") or sprite:IsFinished("Type2") then
            --Explosion:
            local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, nil):ToEffect()
            explosion:GetSprite().Scale = Vector.One*1.5
            explosion:GetSprite().Color = mod.Colors.hot
            --Explosion damage
            for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.TConst.METEOR_EXPLOSION_RADIUS)) do
                if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
                    entity_:TakeDamage(mod.MConst.EXPLOSION_DAMAGE, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity.Parent), 0)
                elseif entity_.Type == EntityType.ENTITY_PLAYER then
                    entity_:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity.Parent), 0)
                end
            end

            for i = 1, 4 do
                local velocity = Vector.FromAngle(i*360/4)*mod.TConst.DEBREE_SPEED
                local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, velocity, entity.Parent):ToProjectile()
                rock.FallingSpeed = 2
                rock:GetSprite().Color = mod.Colors.hot
            end

            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.5

            entity:Remove()
            
        elseif sprite:IsFinished("Type3") then
            
            --Explosion:
            local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, nil):ToEffect()
            explosion:GetSprite().Scale = Vector.One*1.5
            explosion:GetSprite().Color = Color(2,0,0,1)
            --Impact damage
            for i, entity_ in ipairs(Isaac.FindInRadius(entity.Position, mod.TConst.METEOR_EXPLOSION_RADIUS)) do
                if entity_.Type ~= EntityType.ENTITY_PLAYER and entity_.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
                    entity_:TakeDamage(100, DamageFlag.DAMAGE_CRUSH, EntityRef(entity.Parent), 0)
                elseif entity_.Type == EntityType.ENTITY_PLAYER then
                    entity_:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity.Parent), 0)
                end
            end

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position, Vector.Zero, entity.Parent):ToEffect()
            creep.SpriteScale = Vector.One*3
            creep:SetTimeout(45)

            for i=1, mod:RandomInt(2,3) do
                local leech = Isaac.Spawn(EntityType.ENTITY_SMALL_LEECH, 0, 0, entity.Position, RandomVector()*50, entity.Parent)
            end

            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.MeteorUpdate, mod.EntityInf[mod.Entity.Meteor].VAR)

--Rockblast
function mod:RockblastUpdate(entity)
	local data = entity:GetData()
	if data.IsActive_HC and entity:GetSprite():GetFrame() == 1 then
		local position = entity.Position + data.Direction * 50

		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, position, Vector.Zero, entity):ToEffect()
		creep.Timeout = 30
		creep.SpriteScale = Vector.One * 2


	elseif data.IsActive_HC and entity:GetSprite():GetFrame() == 3 then
		local position = entity.Position + data.Direction * 40
		if not mod:IsOutsideRoom(position, game:GetRoom()) then
			local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ROCK_EXPLOSION, 0, position, Vector.Zero, entity):ToEffect()
			local rockData = rock:GetData()
			rockData.Direction = data.Direction:Rotated(mod.TConst.BLAST_ANGLE * 2 * rng:RandomFloat() - mod.TConst.BLAST_ANGLE)
			rockData.IsActive_HC = true
			rockData.HeavensCall = true

            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.5

			if fracture then fracture.Position = position end
			
            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 2, false, 1)
		end
		--Damage
		for i, e in ipairs(Isaac.FindInRadius(entity.Position, 30)) do
			if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= mod.EntityInf[mod.Entity.Terra1].ID then
				e:TakeDamage(50, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
			elseif e.Type == EntityType.ENTITY_PLAYER then
					e:TakeDamage(2, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
			end
		end
		data.IsActive_HC = false
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.RockblastUpdate, EffectVariant.BIG_ROCK_EXPLOSION)

--Nuke
function mod:NovaUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.TerraNova].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if not data.Init then
            data.Init = true

            data.InitSpeed = data.InitSpeed or 1.05
            entity.SpriteScale = Vector.One*0.25

            data.Gone = false
            
            local center = game:GetRoom():GetCenterPos()
            local distance = math.min(300, center:Distance(entity.Position))/300
            data.MaxSize = 155-- + 45*distance

            sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_CLOSE,1,2,false,2)
            sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_LOOP,1,2,true,2)
        end

        local max_size = data.MaxSize/155
        local size = entity.SpriteScale.X
        local sprite_size = size * data.MaxSize

        --local danger_size = 155 -> 1; 200 -> 0.7
        local danger_size = sprite_size * (-0.006667 * data.MaxSize + 2.0333) * 0.85

        --print(max_size, size, sprite_size, danger_size)

        if data.Gone then
            entity.SpriteScale = entity.SpriteScale * 0.8
            if sprite_size < 1 then
                entity:Remove()
                sfx:Stop(SoundEffect.SOUND_DOGMA_BLACKHOLE_LOOP)
            end
        else
            if size < max_size then
                entity.SpriteScale = entity.SpriteScale * data.InitSpeed
            end

            if entity.FrameCount > 300 then
                data.Gone = true
            end
        end

        local parent = entity.Parent
        if parent then
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                if player and player.Position:Distance(entity.Position) < danger_size then
                    player:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(entity), 0)
			        player.Velocity = (player.Position-entity.Position):Normalized()*10
                end
            end

            for i=1, 20 do
                --local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, entity.Position + Vector(danger_size, 0):Rotated(i*360/20), Vector.Zero, nil):ToTear();tear.CollisionDamage = 0;tear.Height = 0
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.NovaUpdate, mod.EntityInf[mod.Entity.TerraNova].VAR)

--Pollen
function mod:PollenUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Pollen].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if not data.Init then
            data.Init = true

            local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, entity.Position, Vector.Zero, nil):ToEffect()
            trail:FollowParent(entity)
            trail.Color = Color(1,1,0,1)
            trail.MinRadius = 0.05
    
            trail:GetData().HC = true
            trail:Update()

            trail.DepthOffset = 180

            data.X = mod:RandomInt(10,40)

        end

        if entity.FrameCount > 30 then
            entity.Velocity = mod:Lerp(entity.Velocity, Vector(-data.X,-30), 0.1)

            if entity.Position.Y < -1000 then
                entity:Remove()

                        
                local meteor = mod:SpawnEntity(mod.Entity.TerraTarget, game:GetRoom():GetRandomPosition(0), Vector.Zero, entity):ToEffect()
                meteor:GetSprite().Color = Color.Default
                meteor:SetTimeout(mod.TConst.METEOR_TIMEOUT)
                
                meteor.Parent = entity.Parent
            end
        else
            entity.Velocity = entity.Velocity * 0.99
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.PollenUpdate, mod.EntityInf[mod.Entity.Pollen].VAR)

--Leaf
function mod:LeafUpdate(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.Leaf].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        if data.Init == nil then
            data.Init = true

            sprite:Play("Idle", true)
            sprite.Rotation = tear.Velocity:GetAngleDegrees()
        end

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then

            game:SpawnParticles (tear.Position, EffectVariant.NAIL_PARTICLE, 9, 5, Color(0.6,1,0.6,1))
            tear:Die()
        end

        if tear.Height >= -33 and tear.FallingAccel > 0 then
            tear.FallingSpeed = 0.05
            tear.Height = -35
            tear.FallingAccel = 0
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.LeafUpdate, mod.EntityInf[mod.Entity.Leaf].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.LeafUpdate, mod.EntityInf[mod.Entity.Leaf].VAR)

--Bubble
function mod:BubbleUpdate(tear, collider, collided)
        if tear.SubType == mod.EntityInf[mod.Entity.Bubble].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        if data.Init == nil then
            if data.IsTar_HC then
                sprite:Play("IdleTar"..tostring(mod:RandomInt(1,3)))
            else
                sprite:Play("Idle"..tostring(mod:RandomInt(1,3)))
            end
            --sprite:Play("Idle")
            data.Init = true

            local velocity = (rng:RandomFloat() + 0.5) * tear.Velocity
            local hemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, tear.Position, velocity, nil):ToEffect()
            hemo.Visible = false
            hemo:GetSprite().PlaybackSpeed = 0.1
            hemo.LifeSpan = 300
            
            tear.Parent = hemo
            tear.Velocity = Vector.Zero

            sprite.Rotation = mod:RandomInt(-15,15)
            sprite.Scale = sprite.Scale * (0.8 + 0.4*rng:RandomFloat())
        end

        if tear.Parent then
            tear.Position = tear.Parent.Position
        end

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) or tear.Parent == nil then

            local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)

            if data.IsTar_HC then
                local tar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, tear.Position, Vector.Zero, tear.Parent):ToEffect()
                tar.Timeout = 30

            else
                impact.Color = Color(0.3,0.3,1,1)
            end

            tear:Die()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.BubbleUpdate, mod.EntityInf[mod.Entity.Bubble].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.BubbleUpdate, mod.EntityInf[mod.Entity.Bubble].VAR)

--Cloud
function mod:CloudUpdate(tear, collider, collided)
        if tear.SubType == mod.EntityInf[mod.Entity.Cloud].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        local dark = sprite:GetLayer(1)
        if data.Init == nil then
            data.Init = true

            sprite:Play("Idle")

            data.ColorSpeed = 0.01 + 0.01 * rng:RandomFloat()
            dark:SetColor(Color(1,1,1,0))
        end
        local color =  dark:GetColor()
        color.A = math.min(1, color.A + data.ColorSpeed)
        color.R = math.max(0, color.R - data.ColorSpeed)
        dark:SetColor(Color(color.R,color.R,color.R,color.A))
        
        local a = color.A
        if color.A >= 1 then

            local parent = tear.Parent
            if parent then
                local aimDirection = parent.Position - tear.Position
                local laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC, tear.Position, aimDirection:GetAngleDegrees(), 1, Vector(0,-10), parent)
                laser.MaxDistance = aimDirection:Length()
            end

            tear:Die()
        end

        tear.Velocity = tear.Velocity * data.Deacceleration

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) or tear.Parent == nil then
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, Vector.Zero, nil):ToEffect()
            cloud.SpriteScale = Vector.One * 1
            cloud:GetSprite().Color = Color(1,1,1,1,1-a,1-a,1-a)
            
            a = a * 0.5
            local cloud2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector.Zero, nil):ToEffect()
            cloud2:Update()
            cloud2:GetSprite().Color = Color(1-a,1-a,1-a,1,1-a,1-a,1-a)
            cloud2.SpriteScale = Vector.One * 0.5
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.CloudUpdate, mod.EntityInf[mod.Entity.Cloud].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.CloudUpdate, mod.EntityInf[mod.Entity.Cloud].VAR)



function mod:SpeedTraceUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.MercuryTrace].SUB+1 then
        local direction = effect.Parent.Position - effect.Position
        effect.Velocity = mod:Lerp(effect.Velocity, direction*0.1, 0.05)
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SpeedTraceUpdate, mod.EntityInf[mod.Entity.MercuryTrace].VAR)