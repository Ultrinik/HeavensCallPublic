---@diagnostic disable: undefined-field
local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

mod.KConst = {
    HEALTH_FACTOR_A = 0.9,
    HEALTH_FACTOR_B = 0.8,

	PLUTO_IDLE_TIME_INTERVAL = Vector(20,30),
	PLUTO_SPEED = 1.3,
    PLUTO_DISTANCE_TOLERATION = 150,

    PLUTO_PROJECTILE_SPEED = 8,
    PLUTO_N_BONES = 5+1,
    PLUTO_BONE_ANGLE = 15,

    CHARON_UNANCHOR_CHANCE = 0.002,

    HAUMEA_CHARON_DISTANCE = 0.5,
    ERIS_CHARON_CHANCE = 0.5,

    HAUMEA_CREEP_SIZE = 1,
    HAUMEA_CREEP_TIMER = 45,
    HAUMEA_N_SPLASH = 4,

    MAKEMAKE_SPEED = 2.5,

    ERIS_DAMAGE = 3.5,
}
function mod:SetKuiperDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
		
        mod.KConst.HEALTH_FACTOR_A = 0.9
        mod.KConst.HEALTH_FACTOR_B = 0.8

        mod.KConst.PLUTO_N_BONES = 5+1

        mod.KConst.CHARON_UNANCHOR_CHANCE = 0.002

	elseif difficulty == mod.Difficulties.ATTUNED then
		
        mod.KConst.HEALTH_FACTOR_A = 0.95
        mod.KConst.HEALTH_FACTOR_B = 0.85

        mod.KConst.PLUTO_N_BONES = 6+1
		
        mod.KConst.CHARON_UNANCHOR_CHANCE = 0.003
        
        mod.KConst.HAUMEA_CREEP_SIZE = 1
        mod.KConst.HAUMEA_CREEP_TIMER = 30
		

    elseif difficulty == mod.Difficulties.ASCENDED then
		
        mod.KConst.HEALTH_FACTOR_A = 1
        mod.KConst.HEALTH_FACTOR_B = 0.95

        mod.KConst.PLUTO_N_BONES = 8+1
		
        mod.KConst.CHARON_UNANCHOR_CHANCE = 0.005
        
        mod.KConst.HAUMEA_CREEP_SIZE = 2
        mod.KConst.HAUMEA_CREEP_TIMER = 60
		
    end
end

--PLUTO--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*******************/&@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@(********************************%@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@/****************************************#@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@***********************************************/@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@(/////***********************************************&@@@@@@@@@@@
@@@@@@@@@@@@@///////******/*******************************************#@@@@@@@@@
@@@@@@@@@@@(**//*******///**********************************************@@@@@@@@
@@@@@@@@@@****************************************************************@@@%/(
@@@@@@@@%*********,,,,,,,,**********,,,,,,*********************************@(##&
@@@@@@@%*****,,,,,......,,,,,***,,,,,,....,,,,,,,,**************************#%%%
@@@@@@@//*(,,,..        ..,,,,,......     .. .../,,,************/***//*****//&&&
@@@@@@///*%&@@@@@@@@@*     .....              .&@@@@@@@@&&&*****//////*/*/*//#@@
@@@@@&//&&&@@@@@@@@@@@@@                    &@@@@@@@@@@@@&&&&(////////*/*/*//(@@
@@@@@((&&&&@@@@@@@@@@@@@@                  @@@@@@@@@@@@@@&&&&&////((///////(((@@
@@@@@((&&&&@@@@@@@@@@@@@@                 *@@@@@@@@@@@@@@&&&&&#((((((((((/((##@@
@@@@@##&&&&&@@@@@@@@@@@@@                 /@@@@@@@@@@@@@@&&&&&((#(((#(((((####@@
@@@@@&#&&&&&@@@@@@@@@@@@                  .@@@@@@@@@@@@@@&&&&&####(##((#((###%@@
@@@@@@%#&&&&@@@@@@@@@@(          %         *@@@@@@@@@@@@&&&&&#######%%%#%####%@@
@@@@@@&%#(&&&@@@@@@@.       @@@@@@       ....%@@@@@@@@@@&&&%#%%&%%%%%%%%%%%%%@@@
@@@@@@@%%###(//*,,..         %@@.      ....,**///#&&&@%%%%%@@@@@&&&%%%%%%%%%@@@@
@@@@@@@@@@@@#((///,,,..              ....**/(((##%%%%%%%%@@@@@@&&&&&%%%%%%%@@@@@
@@@@@@@@@@@@@&#&((((,#,...     &  ...,,,/(((##%%%%%%%%%%@@@@@@@&&&&&%%%%%%@@@@@@
@@@@@@@@@@@@@@@@@@%##@%,,...  .@ . ,**/(((%@%%%%%%&@@@@@@@@@@@@&&&&%%%%%%@@@@@@@
@@@@@@@@@@@@&%%%@@@@@@@%/**...#@#,**/((####@@&@@@@@@%%%%%%@@@@@&&##%###@@@@@@@@@
@@@@@@@@@@@@@@@%%&##%@@@@@@@@@@@@&@@@@@@@@@@@@@%###@%%%#%%%##%#######@@@@@@@@@@@
@@@@@@@@@@@@@@@@@%%###@@%%%#((#&@&&&%%%####@&######%%#############%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@############%%####%####@#############(##(((#@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@####(((###((########((((#######((#(#@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#((((((((((((((((((((((((%@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

mod.PMSState = {
	APPEAR = 0,
	IDLE = 1,
    ATTACK = 2,
    SNAP = 3,
}
mod.chainP = {
	[mod.PMSState.APPEAR] = 	{0,   1,   0,   0},
	[mod.PMSState.IDLE] = 	    {0,   0.5, 0.3, 0.2},
	--[mod.PMSState.IDLE] = 	{0,   0,   0,   1},
	[mod.PMSState.ATTACK] = 	{0,   1,   0,   0},
	[mod.PMSState.SNAP] = 	    {0,   1,   0,   0},
	
}

function mod:PlutoUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR and entity.SubType == mod.EntityInf[mod.Entity.Pluto].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0
            data.IsDwaft = true
            entity.I2 = 1

            data.ObjectivePosition = room:GetCenterPos()

            data.FlagCharon = false
            data.FlagEris = false
            data.FlagMakemake = false
            data.FlagHaumea = false

			mod:CheckEternalBoss(entity)

            if (mod.savedatarun().planetAlive or mod:IsChallenge(mod.Challenges.BabelTower)) and mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
                local watcher = mod:SpawnEntity(mod.Entity.CeresWatch, Vector.Zero, Vector.Zero, entity)
            end
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.PMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
                if mod.savedatarun().planetAlive then
                    mod.savedatarun().planetAlive1 = true
                    mod.savedatarun().planetKilled11 = false
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainP)
				data.StateFrame = 0

                --Tail spawn
                local parent = entity
                --print("b1", mod.KConst.PLUTO_N_BONES)
                for i=1,mod.KConst.PLUTO_N_BONES do 
                    local bone = mod:SpawnEntity(mod.Entity.PlutoBone, entity.Position, Vector.Zero, entity):ToNPC()
                    bone:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    bone:GetSprite():Play("Normal", true)
                    bone.CollisionDamage = 0
                    bone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    parent.Child = bone
                    bone.Parent = parent
                    bone.I1 = i
                    bone:GetSprite().Offset = Vector(0,-math.max(0,math.min(2*(mod.KConst.PLUTO_N_BONES/2-i+1), 2)))
                    bone.DepthOffset = -10
                    
                    parent = bone

                    if i==mod.KConst.PLUTO_N_BONES then
                        bone:GetSprite():Play("Spike", true)
                        bone:GetSprite().Offset = Vector(0,-3)
                    end
                end
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			
		elseif data.State == mod.PMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainP)
				data.StateFrame = 0

                if rng:RandomFloat() < 0.3 then
                    data.ObjectivePosition = room:GetRandomPosition(0)
                end
				
			else
				mod:PlutoMove(entity, data, room, target)
			end
			
		elseif data.State == mod.PMSState.ATTACK then
			mod:PlutoAttack(entity, data, sprite, target, room)
			
		elseif data.State == mod.PMSState.SNAP then
			mod:PlutoSnap(entity, data, sprite, target, room)
		
		end
        
        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)


        local yourBattle = mod.savedatarun().planetNum == mod.Entity.Pluto
        if yourBattle and mod.savedatarun().planetAlive and (entity.FrameCount + 5) % 10 == 0 then
            if not data.FlagCharon and mod:KuiperHealtFraction() < mod.KConst.HEALTH_FACTOR_A and (#mod:FindByTypeMod(mod.Entity.Charon1) + #mod:FindByTypeMod(mod.Entity.Charon2)) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Charon1, position, Vector.Zero, nil)
                data.FlagCharon = true
                planet:GetSprite():Play("AppearSlow", true)


            elseif not data.FlagEris and not mod.savedatarun().planetKilled12 and mod:KuiperHealtFraction() < mod.KConst.HEALTH_FACTOR_B and #mod:FindByTypeMod(mod.Entity.Eris) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Eris, position, Vector.Zero, nil)
                data.FlagEris = true
                mod.savedatarun().planetHP2 = planet.HitPoints
                planet:GetSprite():Play("AppearSlow", true)

                mod.savedatarun().planetAlive2 = true

            elseif not data.FlagMakemake and not mod.savedatarun().planetKilled13 and mod:KuiperHealtFraction() < mod.KConst.HEALTH_FACTOR_B and #mod:FindByTypeMod(mod.Entity.Makemake) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Makemake, position, Vector.Zero, nil)
                data.FlagMakemake = true
                mod.savedatarun().planetHP3 = planet.HitPoints
                planet:GetSprite():Play("AppearSlow", true)
                
                mod.savedatarun().planetAlive3 = true

            elseif not data.FlagHaumea and not mod.savedatarun().planetKilled14 and mod:KuiperHealtFraction() < mod.KConst.HEALTH_FACTOR_B and #mod:FindByTypeMod(mod.Entity.Haumea) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Haumea, position, Vector.Zero, nil)
                data.FlagHaumea = true
                mod.savedatarun().planetHP4 = planet.HitPoints
                planet:GetSprite():Play("AppearSlow", true)
                
                mod.savedatarun().planetAlive4 = true

            end

            if not data.FlagCharon and (#mod:FindByTypeMod(mod.Entity.Charon1) + #mod:FindByTypeMod(mod.Entity.Charon2)) > 0 then
                data.FlagCharon = true

            elseif not data.FlagEris and #mod:FindByTypeMod(mod.Entity.Eris) > 0 then
                data.FlagEris = true

            elseif not data.FlagMakemake and #mod:FindByTypeMod(mod.Entity.Makemake) > 0 then
                data.FlagMakemake = true

            elseif not data.FlagHaumea and #mod:FindByTypeMod(mod.Entity.Haumea) > 0 then
                data.FlagHaumea = true

            end

        end

	end
end
function mod:PlutoAttack(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Attack",true)
    elseif sprite:IsFinished("Attack") then
        data.State = mod:MarkovTransition(data.State, mod.chainP)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 1.25)

        local velocity = (target.Position - entity.Position):Normalized():Rotated(mod:RandomInt(-mod.KConst.PLUTO_BONE_ANGLE,mod.KConst.PLUTO_BONE_ANGLE))*mod.KConst.PLUTO_PROJECTILE_SPEED
        local bone = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_BONE, 0, entity.Position, velocity, entity):ToProjectile()
    end
end
function mod:PlutoSnap(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        
        local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
        if charon and charon:GetData().Locked == "Pluto" then
            data.State = mod:MarkovTransition(data.State, mod.chainP)
            data.StateFrame = 0
        else
            data.TargetPosition = target.Position
            sprite:Play("Snap",true)
        end
    elseif sprite:IsFinished("Snap") then
        data.State = mod:MarkovTransition(data.State, mod.chainP)
        data.StateFrame = 0

        local spike = entity.Child
        --print("b2", mod.KConst.PLUTO_N_BONES)
        for i=1,mod.KConst.PLUTO_N_BONES-1 do
            spike = spike.Child
        end
        spike.Velocity = (target.Position - entity.Position):Normalized() * 20
        spike:GetData().Launch = false
        spike.CollisionDamage = 0
        spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    elseif sprite:IsEventTriggered("Attack") then

        local spike = entity.Child
        
        --print("b3", mod.KConst.PLUTO_N_BONES)
        for i=1,mod.KConst.PLUTO_N_BONES-1 do
            spike = spike.Child
        end

        local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
        if charon then
            if not charon:GetData().Locked then
                spike.Velocity = (charon.Position - spike.Position):Normalized() * 20
                spike:GetData().Launch = true
                spike.CollisionDamage = 1
                spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                
                sfx:Play(SoundEffect.SOUND_WHIP, 1.25)
            end

        else
            spike.Velocity = (data.TargetPosition - entity.Position):Normalized() * 20
            spike:GetData().Launch = true
            spike.CollisionDamage = 1
            spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            
            sfx:Play(SoundEffect.SOUND_WHIP, 1.25)
        end
    end
end


--Move
function mod:PlutoMove(entity, data, room, target)

    local objectibe = data.ObjectivePosition

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.KConst.PLUTO_IDLE_TIME_INTERVAL.X, mod.KConst.PLUTO_IDLE_TIME_INTERVAL.Y)
		--distance of Saturn from the center of the room
		local distance = 0.95*(objectibe.X-entity.Position.X)^2 + 2*(objectibe.Y-entity.Position.Y)^2
		
		--If its too far away, return to the center
		if distance > mod.KConst.PLUTO_DISTANCE_TOLERATION then
			data.targetvelocity = ((objectibe - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.KConst.PLUTO_SPEED
	data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:PlutoDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR and entity.SubType == mod.EntityInf[mod.Entity.Pluto].SUB then

        mod.savedatarun().planetAlive1 = false
        mod.savedatarun().planetKilled11 = true
        local allDead = (mod.savedatarun().planetKilled11 and mod.savedatarun().planetKilled12 and mod.savedatarun().planetKilled13 and mod.savedatarun().planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, true, false, true)
        else
            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.67

            game:BombExplosionEffects ( entity.Position, 5, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.5, true, false, DamageFlag.DAMAGE_EXPLOSION )
        end

    end
end
--deding
function mod:PlutoDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR and entity.SubType == mod.EntityInf[mod.Entity.Pluto].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
    
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 1 then
                sprite.Rotation = 0
            end
        end
    end
end

--Tail
function mod:TailUpdate(entity)--This is such a convoluted way to create a chain
    if entity.Variant == mod.EntityInf[mod.Entity.PlutoBone].VAR and entity.SubType == mod.EntityInf[mod.Entity.PlutoBone].SUB then
        if entity.Parent then
            local sprite = entity:GetSprite()


            sprite.Rotation = mod:AngleLerp(sprite.Rotation, ( - entity.Parent.Position + entity.Position):GetAngleDegrees(), 0.5)

            local proportion = (1 - entity.I1/mod.KConst.PLUTO_N_BONES)
            sprite.Scale = Vector.One * (0.8 + 0.2*proportion)
            entity.Scale = sprite.Scale.X

            sprite.Offset = Vector(0, - 10 * (0.6 + 0.4*proportion))
            entity.DepthOffset = -40

            if sprite:GetAnimation() == "Spike" then
                local data = entity:GetData()

                if data.Launch then
                    sprite.Rotation = entity.Velocity:GetAngleDegrees()

                    if entity:CollidesWithGrid() then
                        data.Launch = false
                        entity.CollisionDamage = 0
                        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    end

                    return
                end
            end

            mod:FamiliarParentMovement(entity, 2, 1.5, 15)

            local child = entity.Child
            if child then

                local spike = child
                --print("b4", mod.KConst.PLUTO_N_BONES)
                for i=entity.I1+1,mod.KConst.PLUTO_N_BONES-1 do
                    spike = spike.Child
                end

                if spike and spike:GetData().Launch then

                    local parent = entity.Parent
                    entity.Parent = child
                    mod:FamiliarParentMovement(entity, 10, 2, 10)
                    entity.Parent = parent

                end
            end
        else
            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.TailUpdate, mod.EntityInf[mod.Entity.PlutoBone].ID)

--Kuiper health
function mod:KuiperHealtFraction()
    local p = mod:FindByTypeMod(mod.Entity.Pluto)
    local e = mod:FindByTypeMod(mod.Entity.Eris)
    local m = mod:FindByTypeMod(mod.Entity.Makemake)
    local h = mod:FindByTypeMod(mod.Entity.Haumea)

    local maxHp = 0
    local currentHp = 0

    for _, entity in ipairs(p) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end
    for _, entity in ipairs(e) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end
    for _, entity in ipairs(m) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end
    for _, entity in ipairs(h) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end

    if currentHp == 0 then
        return 0
    end

    return currentHp / maxHp
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.PlutoUpdate, mod.EntityInf[mod.Entity.Pluto].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.PlutoDeath, mod.EntityInf[mod.Entity.Pluto].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.PlutoDying, mod.EntityInf[mod.Entity.Pluto].ID)

--CHARON--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%##%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%#####%%%###########&#####%@@&@@@@@@@@@@@@@@@@&@@@
@@@@@@@@@@@@@@@@@@@@@@@%########%%%###############@@%########%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&########%#####################@@@%###((####(#@@@@@@@@@@@@@@@
@@@@@@@@&@@@@@@@@######%%#############%&@@@@@@@@@@@@@@@@@%###((((((#@@@@@@@@@@@@
@@@@@@@@@@@@@@&%#################################(#@@@@@@@@@@@@&((////@@@@@@@@@@
@@@@@@@@@@@@&%%%%#############################((((((&@@#((((((((#%&&(///@@@@@@@@
@@@@@@@@@@@%%%#############%###############((((((((((@@&((((((((///////((%@@@@@@
@@@@@@@@@@%###############%#################((((((((((@@(((((////////((((((@@@@@
@@@@@@@@@##################%#######@####((((((((((((((&@(((////////(((((((((@@@@
@@@@@@@@%%#################&######%&((#((((((((((((((((@#(//(////((((((((((((@@@
@@@@@@@%####%##############@#####(@@#%((((((((((((((((((((((((((((((((((&@&&&&@@
@@@@@@&#########%#%########@@@#(#@@@%(((((((((#@@@@@%((((((((((@#((#&@@@@@@&&%@@
@@@@@@#############&##%####@@@@@@@@@@@&((///(((@@(((((((/((((((&@@@@@#////(/(/&@
@@@@@@###############&@@@@&%&@@@@@@@@@@((////(((((((&%#((((((@@@@%@@//////((//%@
@@@@@@############((((%%%%&&&@@@@@@@@@@&((((((((((((///%@@@@@@@/(#//@(//((///*%@
@@@@@@%(((((((((((((#(%%&&&@@@@@@@@@@@@#((((((((((////#&#@@@@@(//////(//(/////@@
@@@@@@@(////(((######%%%%&&&&&@@@@@@@@@@&((((//////////@@@&///(@@////////(////@@
@@@@@@@(//##%%&%##%%%%%%%&&&&@@@@@@@@@@@@(#&&((#&&%%#%@@@/////////%(/((((///*@@@
@@@@@@@@(###%%//(####&&(((&&&@@@@@@@@@@@(((/////////@@@&&@@%//////////((((((%@@@
/(((#####%%%%%%%%%%&&&(((#&#((&%&@@(((##((/////////&@@&(////////(((((((((((%@@@@
%%#######%%&&&&&&&%(((((((((((((((#%////#///#/////(@@(///////((((((((((((#@@@@@@
@@####%&&@@@((((///((((////(((//////(//////**/(%@@@@@@((/((((((((((((((##@@@@@@@
&%%%%&&@@@@@@%**////////////////******/***///////#@@@&(((((((((((((((##@@@@@@@@@
&&&&@@@@@@@@@@@%******,,****,,,,,,,,,,***********////((((((((((((####@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@*,,,,,,,,,,,,,,,,,,***********///((((((((((((((#&@@@@@@@@@@@@@
@@@@@@@@@@@@&@@@@@@@@/,,,,,,,,,,,,,,,*********///(((((((((((###&@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@(,,,,******/////////((((((((######&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@&(*****/////((((((((###&@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
function mod:CharonUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Charon1].VAR and entity.SubType == mod.EntityInf[mod.Entity.Charon1].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0

            entity:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            
			mod:CheckEternalBoss(entity)
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == 0 then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == mod.Music.PLANET or music:GetCurrentMusicID() == mod.Music.PLANET_INTRO then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = 1
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("EndAppear") then
                local charon = mod:SpawnEntity(mod.Entity.Charon2, entity.Position, Vector.Zero, entity)
                charon:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                entity:Remove()
			end

		end
        
        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)
	end
end

function mod:Charon2Update(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Charon2].VAR and entity.SubType == mod.EntityInf[mod.Entity.Charon2].SUB then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        local data = entity:GetData()
		local sprite = entity:GetSprite()

        if not data.Init then
            data.Init = true

            mod:scheduleForUpdate(function()
                for _, b in ipairs(mod:FindByTypeMod(mod.Entity.PlutoBone)) do
                    if b:GetSprite():GetAnimation()=="Spike" then
                        entity.Parent = b
                        break
                    end
                end
            end, 30)

            entity:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            
			mod:CheckEternalBoss(entity)
        end

        if entity.Parent then

            local spikeData = entity.Parent:GetData()
            if spikeData.Launch then
                if entity.Parent.Position:Distance(entity.Position) < 20 and not data.Locked then
                    data.Locked = "Pluto"
                end
            end

            if data.Locked == "Pluto" then
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                --entity.Position = entity.Parent.Position

                if rng:RandomFloat() < mod.KConst.CHARON_UNANCHOR_CHANCE then
                    data.Locked = nil
                end

            elseif data.Locked == "Eris" or data.Locked == "Haumea" then
                data.Counter = data.Counter or 60
                data.Counter = data.Counter - 1
                if data.Counter <= 0 then
                    data.Locked = nil
                end
            else
                data.Counter = nil
            end
        
            local xvel = entity.Velocity.X / 10
            sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)
        end

    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CharonUpdate, mod.EntityInf[mod.Entity.Charon1].ID)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.Charon2Update, mod.EntityInf[mod.Entity.Charon2].ID)
--ERIS--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#.*@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. .***@
@@@@@@@@@@@@@@@@@@@@/,,,,,,,************(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. .***@@
@@@@@@@@@@@@@@@%**,,,,,,,,*******************%@@@@@@@@@@@@@@@@@@@@@@@@@. .***@@@
@@@@@@@@@@@@(/*********,,,*********,************#@@@@@@@@@@@@@@@@@@@@@, .***@@@@
@@@@@@@@@@//////***(**,,,,,,**#&*,,,,,,,***********@@@@@@@@@@@@@@@@@@, .**(@@@@@
@@@@@@@@///%**//*******&*%&*,,,,,,...,&,,,,(*,,,*,***@@@@@@@@@@@@@@@, .**#@@@@@@
@@@@@@&/(&*#*********&#*,,#/,,,,,,...,,.,@%.&,&/*%/,,*@@@@@@@@@@@@@, .**%@@@@@@@
@@@@@#(/&%*@******&****,,,,*,&,.......@..@/@.&,((,,(*,*%@@@@@@@@@@* .**@@@@@@@@@
@@@@@(*****,*,,,**********,***,,,,,,.#.......,@&%,,*#,**& .(##/***..**@@@@@@@@@@
@@@@*#%%%%%&&&#,****************,**,,,*%&%%%#,,,&******####(@@@#(((**@@@@@@@@@@@
@@@@/%%%%%&&&&&&&/******///******&&&&&&&&%%%%%%*&*****###(@@@@@*.#(*@@@@@@@@@@@@
@@@%,%%%%&&&&&&&&&&/**////////&&&&&&&&&&&&%%%%%**/*/*.(#(%###(((((*%(@@@@@@@@@@@
@@@@../%%&&&&&&&&&&&&***////&&&&&&&&&&&&&&%%%%//////,.##/@@@@@#####%(/@&%%@@@@@@
@@@@.....%&&&&&&&&&&&*/*///#&&&&&&&&&&&&&%%%////////.##(/@@@@@@@@@@@@*%(@@@@@&@@
@@@@&,@.......(&&(,,,,*****/#&&&&&&&&&&%////////////,##(@@@@@@@@@@@@@(@@@@@@@@@@
@@@@@/&...........,,,,,,*****////////////////@////%//(##@@@###(%@@@@%(@@@@@@@@@@
@@@@@@#.............,,,,,,*****/*///*////////@/%//&//..,#@@@@@@@@@@@,/@@@@@@@@@@
@@@@@@@@.&,&*...../&&&&&&&&#***********#(////&///////@..*((@@@@@@@&(*@@@@@@@@@@@
@@@@@@@@@@..(.....(&&&&&&&&&&&*******(&***(//&/////@@@@@.(((((%#(*./@@@@@@@@@@@@
@@@@@@@@@@@@*...........,.,,,,,,,*,,,,&,,**/&///(@@@@@@@@@(./.,(,/@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@/...........,,,,,,,,,,,,,*/***#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&,.....,,,.,,,.,,,,,**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
mod.EMSState = {
	APPEAR = 0,
	IDLE = 1,
    CHARGE = 2,
}
mod.chainE = {
	[mod.EMSState.APPEAR] = 	{0,   1,   0},
	[mod.EMSState.IDLE] = 	    {0,   0.9, 0.1},
	--[mod.EMSState.IDLE] = 	{0,   0,   1},
	[mod.EMSState.CHARGE] = 	{0,   1,   0},
	
}
mod.EConst = {--Some constant variables of Eris

	idleTime = 2,
	speed = 1.35,
    distanceToleration = 15,

    chargeSpeed = 50,

}

function mod:ErisUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR and entity.SubType == mod.EntityInf[mod.Entity.Eris].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0
            data.IsDwaft = true
            entity.I2 = 1

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
		
		if data.State == mod.EMSState.APPEAR then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == mod.Music.PLANET or music:GetCurrentMusicID() == mod.Music.PLANET_INTRO then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainE)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			elseif sprite:IsEventTriggered("SpawnSword") then
                local naue = mod:SpawnEntity(mod.Entity.ErisNaue, entity.Position, Vector.Zero, entity):ToEffect()
                naue.DepthOffset = -5
                naue:FollowParent(entity)
                naue.Parent = entity
                entity.Child = naue
            elseif sprite:IsEventTriggered("Sound") then
                sfx:Play(mod.SFX.DrawSword, 1)
            end
			
		elseif data.State == mod.EMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") or sprite:IsFinished("IdleFlip") then
				data.State = mod:MarkovTransition(data.State, mod.chainE)
				data.StateFrame = 0

                if sprite:IsFinished("IdleFlip") then
                    if data.LookingAt == 'l' then 
                        data.LookingAt = 'r'
                        sprite.FlipX = true
                    elseif data.LookingAt == 'r' then
                        data.LookingAt = 'l'
                        sprite.FlipX = false
                    end
                    sprite:Play("Idle",true)
                end
				
			else
                if not sprite:IsPlaying("IdleFlip") then
                    if data.LookingAt ~= data.TargetAt then
                        --local frame = sprite:GetFrame()
                        sprite:Play("IdleFlip", true)
                        --sprite:SetFrame(frame)
                    end
                end

				mod:ErisMove(entity, data, room, target)
			end
			
		elseif data.State == mod.EMSState.CHARGE then
			mod:ErisCharge(entity, data, sprite, target, room)
		end
        
        --local xvel = entity.Velocity.X / 10
        --sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)

        if entity.Child and not sprite:IsPlaying("Spin") and not sprite:IsPlaying("Prepare") then
            local naue = entity.Child
            local naueSprite = naue:GetSprite()
            local amount = 0.1
            if sprite:IsPlaying("Attack") then amount = 0.5 end

            local nvelocity = -entity.Velocity
            naueSprite.Rotation = mod:AngleLerp(naueSprite.Rotation, nvelocity:GetAngleDegrees(), amount)

            if naueSprite:IsFinished("Spin") then
                naueSprite:Play("Idle", true)

            end
        end
	end
end
function mod:ErisCharge(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Prepare",true)
        data.TargetPos = target.Position
        data.StandStill = true
        --mod:FaceTarget(entity, target)
        
        sfx:Play(mod.SFX.Shine, 1)

        if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL and rng:RandomFloat() < mod.KConst.ERIS_CHARON_CHANCE then
            local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
            if charon and not charon:GetData().Locked and not room:IsPositionInRoom(charon.Position, 30) then
                charon:GetData().Locked = "Eris"
                data.TargetPos = charon.Position
            end
        end

        local direction = (data.TargetPos - entity.Position)
        local angulo = direction:GetAngleDegrees()

        local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()
        if tracer then
            tracer:FollowParent(entity)
            tracer.LifeSpan = 25
            tracer.Timeout = tracer.LifeSpan
            tracer.TargetPosition = Vector.FromAngle(angulo)
        end

    elseif sprite:IsFinished("Prepare") then
        sprite:Play("Attack",true)
        data.StandStill = false
        entity.Velocity = (data.TargetPos - entity.Position):Normalized()*mod.EConst.chargeSpeed
        --mod:FaceTarget(entity, target)
        data.Charged = true
        
        sfx:Play(SoundEffect.SOUND_MOTHER_CHARGE1, 1.5, 2, false, 3)

    elseif sprite:IsFinished("Attack") or (entity:CollidesWithGrid() and data.Charged) then
        data.Charged = false
        entity.Velocity = Vector.Zero
        sprite:Play("Spin",true)

        --Spin sword
        if entity.Child then
            local naue = entity.Child
            --naue:GetSprite().Rotation = 0
            naue:GetSprite():Play("Spin", true)
        end

        local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
        if charon and charon.Position:Distance(entity.Position) < 20 then
            charon:GetData().Locked = nil
            charon.Velocity = (charon.Position - entity.Position):Normalized()*15
        end
        
        sfx:Play(SoundEffect.SOUND_SWORD_SPIN, 1.5)

    elseif sprite:IsFinished("Spin") then
        data.State = mod:MarkovTransition(data.State, mod.chainE)
        data.StateFrame = 0
    end

    if data.StandStill then
        entity.Velocity = Vector.Zero
    end
end


--Move
function mod:ErisMove(entity, data, room, target)
	--mod:FaceTarget(entity, target)
    --idle move taken from 'Alt Death' by hippocrunchy
    --It just basically stays around a something
    
    --idleTime == frames moving in the same direction
    if not data.idleTime then 
        data.idleTime = mod.EConst.idleTime

        local localAntipode = (target.Position - room:GetCenterPos()):Rotated(180)
        local antipode = localAntipode + room:GetCenterPos()
        if localAntipode:Length() < 100 then
            antipode = localAntipode:Normalized()*100 + room:GetCenterPos()
        end
        -- distance of Eris from the oposite place of the player
        local distance = antipode:Distance(entity.Position)
        
        --If its too far away, return to the center
        if distance > mod.EConst.distanceToleration then
            data.targetvelocity = ((antipode - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
        end

    end

    --Not that close to the plater
    if target.Position:Distance(entity.Position) < 100  or data.targetvelocity == nil then
        local direction = (entity.Position - target.Position):Normalized()
        data.targetvelocity = (direction*6):Rotated(mod:RandomInt(-45, 45))
    end
    
    --If run out of idle time
    if data.idleTime <= 0 and data.idleTime ~= nil then
        data.idleTime = nil
    else
        data.idleTime = data.idleTime - 1
    end
    
    --Do the actual movement
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.EConst.speed
    data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:ErisDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR and entity.SubType == mod.EntityInf[mod.Entity.Eris].SUB then
        
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 10, 6, Color(0.8,0.8,1,1))
        
        mod.savedatarun().planetAlive2 = false
        mod.savedatarun().planetKilled12 = true
        local allDead = (mod.savedatarun().planetKilled11 and mod.savedatarun().planetKilled12 and mod.savedatarun().planetKilled13 and mod.savedatarun().planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]

        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, true, false, true)
        else
            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.67

            game:BombExplosionEffects ( entity.Position, 5, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.5, true, false, DamageFlag.DAMAGE_EXPLOSION )
        end

    end
end
--deding
function mod:ErisDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR and entity.SubType == mod.EntityInf[mod.Entity.Eris].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
    
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 1 then
                sprite.Rotation = 0
            end
        end
    end
end


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ErisUpdate, mod.EntityInf[mod.Entity.Eris].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ErisDeath, mod.EntityInf[mod.Entity.Eris].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.ErisDying, mod.EntityInf[mod.Entity.Eris].ID)

--OTHERS----
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.LaserSwordUpdate, mod.EntityInf[mod.Entity.ErisNaue].VAR)

--MAKEMAKE--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@##@@
#@@@@@@@@@@@@@@@@@@@@@@@/@@@%%((((((((((((((((((((((%%@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@%@@@@@@@@@@@@@@&#(((((((((((((((((((((((((((((((((((//////(@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@%####((((((((((((((((((((((((((((((((((((((((//////////@@@@@@@@@@@@
@@@@@@@@@########((((((((((((((((((((((((((((((((((((////////////////@@@@@@@@@@@
@@@@@@@#############(((((((((((((((((((((((((((((/////////////////////@@@@@@@@@@
@@@@@@#############################(#((((((((((((((///////////////////#@@@@@@@@@
@@@@@@###################################((((((((((((((((//////////////@@@@@@@@@
@@@@@@###############################((((((((((/////////((//////////////@@@@@@@@
@@@@@@################################((((((((((((((((((((((((//////////(@@@@@@@
@@@@@@%##############################((((((%&&&&&&&&&&&&&&&&%%(((((((/////@@@@@@
@@@@@@@###%%%%%&&&&&&&&&&#############(((#&&&&&&&&&&&&&&&&&&%%(((((((//////@@@@@
@@@@@@####%%&&&&&&&&&&&&&#############(###&&&&&&&&&&&&&&&&&&%%((((((((//////@@@@
@@@@@#####%&&&&&&&&&&&&&##################(&&&&&&&&&&&&&&&&&#(((((((((((/////@@@
@@@@&############&&&##%%##################(((###&&%##(((((((((((((((((((/////(@@
@@@@#################%%%##########################(((((((((((((((((((((((/////@@
@@@@##############%%%#############################((((((((((((((((((((((((////@@
@@@@############%%%%#######################%%(####(#####(((#######(#((((((///(@@
@@@@############%%%%######################%%%(((((#######(###########((((((/((@@
@@@@###########%%%%%######################%%%((###################(#((((((/(((@@
@@@@@##########%%%%#######################%%%#((#################((((((((((((&@@
@@@@@%#########%%%%######################%%%%%(((#(#############(((((((((((((@@@
@@@@@@#########%%%%######################%%%%%##(###(###############((((((((@@@@
@@@@@@@########%%%%%##################%%%%%%%%######################(((((((@@@@@
@@@@@@@@@######%%%%%%###########%%%%%%%%%%%%%%################((((###((((#@@@@@@
@@@@@@@@@@######%%%%%%%%###%%%%%%%%%%%%%%%%%%###########################@@@@@@@@
@@@@@@@@@@@@#######%%%%%%%%%%%%((((###################################@@@@@@@@@@
@@@@@@@@@@@@@@######################################################@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#############%%##################################@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@#####(#(((((((#############################@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@((((((((((########################@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&((##################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

function mod:MakemakeUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR and entity.SubType == mod.EntityInf[mod.Entity.Makemake].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0
            data.IsDwaft = true
            entity.I2 = 1
            
            data.Direction = Vector(1,0):Rotated(360*rng:RandomFloat())
            
			mod:CheckEternalBoss(entity)
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == 0 then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == mod.Music.PLANET or music:GetCurrentMusicID() == mod.Music.PLANET_INTRO then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = 1
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			
		elseif data.State == 1 then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			else
				mod:MakemakeMove(entity, data, room)
			end

		end

        local xvel = entity.Velocity.X
        xvel = xvel/mod.KConst.MAKEMAKE_SPEED
        local m = 10 + 10 * math.sin(entity.FrameCount/10)
        sprite.Rotation = mod:Lerp(sprite.Rotation, m*xvel, 0.2)


	end
end

function mod:MakemakeMove(entity, data, room)
    entity.Velocity = data.Direction * mod.KConst.MAKEMAKE_SPEED

    if entity:CollidesWithGrid() then
        sfx:Play(Isaac.GetSoundIdByName("SOUND_STONE_IMPACT"), 1)
        mod:scheduleForUpdate(function()
            data.Direction = entity.Velocity:Normalized()
        end, 2)
    end
end
--ded
function mod:MakemakeDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR and entity.SubType == mod.EntityInf[mod.Entity.Makemake].SUB then
        
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 10, 6)

        mod.savedatarun().planetAlive3 = false
        mod.savedatarun().planetKilled13 = true
        local allDead = (mod.savedatarun().planetKilled11 and mod.savedatarun().planetKilled12 and mod.savedatarun().planetKilled13 and mod.savedatarun().planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, true, false, true)
        else
            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.67

            game:BombExplosionEffects ( entity.Position, 5, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.5, true, false, DamageFlag.DAMAGE_EXPLOSION )
        end

    end
end
--deding
function mod:MakemakeDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR and entity.SubType == mod.EntityInf[mod.Entity.Makemake].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
    
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then

            sprite.Rotation = 0

            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 1 then
                sprite.Rotation = 0
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MakemakeUpdate, mod.EntityInf[mod.Entity.Makemake].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.MakemakeDeath, mod.EntityInf[mod.Entity.Makemake].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.MakemakeDying, mod.EntityInf[mod.Entity.Makemake].ID)

--HAUMEA--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@&(@@*@@@@**@@@#**@@@*&@@**@@@@#@@@@@@@@@@@#@@@@@@@@@@@
@@@@@@/@@@@@@*@@@@@@@@%*@@@**@@*@@@@**@@@**@@@@@@@@@@#@@@@&/*********/@@@@@@@@@@
@@@@@@/*@@@@@@*@@@@@@@@**@@@**@**@@@@*&@@@@@&@@@@@@@@@/////////////********@@@@@
@@@@@@@**@@@%***@@@@****/@@@@@/**@@@@@@@@@@@@@@@@@@@///////////////***********@@
@@@@@@@@*#@@@@@@*@@@***@@@@@@@(@@@@@@@@@@@@@@@@@@@//////////((//(//////****@&@@@
@@@@@@@#@*%@@@@@@*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/**//////((##@####((((@(/#@@@@@
@@@@@@@@@@*@@@@@#@&@@@@@@@@@&@@@@@@@@@@@&@@@@@@@////////(###@%@. ###%@@@&@&@@@@@
@@@@@@@@@@@*@@@@@@@@@@@@@@@@@@@@@@*********,,,,*/@/////               #@@@&@@@@@
@@@@@@@@@@&@@@@@@@@&@@@@@@@/////************//*,     /                  *@@@@@@@
@@@&@@@@@@@@@@@@@@@@@@@////////////////////((          ,                ..  #@@@
@@@@%@@@@@@@@@@@@@@@*****//////////////(((###%%( ,..,**,,,,,,      @@@ ....   @@
@@@@@@@@@@@@@@@@@@*******//////////////((####%%%%%,,,*,*,,,,.,     @@@@ ..... @@
@@@@@@@@@@@@@@@&********//////////***///((#%%%##.,,,,,,,,,,,,,,      @@@.... @@@
@@@&@@@@@@@@@@@*******//////////******//((#%%%%####%#,,,,*,,,,,      @@@....@@@@
@@@@&@@@@@@@@@******////////////*****///((#%%%%#%%,,,,,,,,,,,,.      @@....@@@@@
@@@@@@@@@@@@@&*****////////////////*///((##%%%%%%#,,,,,,,,,,,          ... @@@@@
@@@@@@@@@@@...****/////////////////////((####%%%###*,,,,,,.          ...  @@@@@@
@@@@@@@@@...../////////(((((////////////((((#######(.              .... @@@@@@@@
@@@#@@@@.,,,,,*///////((((((((((//////////////((((///***     ((   .....@@@#@@@@@
@@@@@@,,,,,,,,,,///////((((((((//////////////***********  @@@@   ....(%@@@@@@@@@
@@@@@..,,,,,,,,@@(//////////////*/////////////////*****@@@@@@ ......#@@@@@@@@@@@
@@@@...,,,,,,,*@@@@@////////////***********/////////@&@@@#, .......@@@@@@@@@@@@@
@@@....,,,,,,@@@#@@@@@@@/******************////@@@@@&@@   ......@@@@@@#@@@@@@@@@
@@@ ....,,,@@@@@@&@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@(  .......  @@@@@@@@@@@@@&@&@@
@@@ .......@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@(%................@@@@@@@@@@@@@@@@@@@@
@@@. .........,.,.,,,,,.........&@@@@...................@@@@@@@@@@@@@@@@@@@@@@@@
@@@   ........,,,,,,,,,,,,,,,,..........,,,,,,,,,.....*@@@&@@#@@@@@@@@@@@@@@@@@@
@@@@.  .......,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,,....@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@*  ......,,,,,,,,,,,,,,,,,,,,,,...*@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,....@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&....&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
mod.HMSState = {
	APPEAR = 0,
	IDLE = 1,
    JUMP = 2,
}
mod.chainH = {
	[mod.HMSState.APPEAR] = 	{0,   1,   0},
	[mod.HMSState.IDLE] = 	    {0,   0.75, 0.25},
	--[mod.HMSState.IDLE] = 	{0,   0,   1},
	[mod.HMSState.JUMP] = 	    {0,   1,   0},
	
}

function mod:HaumeaUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR and entity.SubType == mod.EntityInf[mod.Entity.Haumea].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0
            data.IsDwaft = true
            entity.I2 = 1
            
			mod:CheckEternalBoss(entity)
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.HMSState.APPEAR then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == mod.Music.PLANET or music:GetCurrentMusicID() == mod.Music.PLANET_INTRO then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainH)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			
		elseif data.State == mod.HMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainH)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.HMSState.JUMP then
			mod:HaumeaJump(entity, data, sprite, target, room)
		end

        entity.Velocity = Vector.Zero
	end
end
function mod:HaumeaJump(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Jump",true)
    elseif sprite:IsFinished("Jump") then
        entity.Position = data.TargetPos
        sprite:Play("Land",true)
        entity.Visible = true
    elseif sprite:IsFinished("Land") then
        data.State = mod:MarkovTransition(data.State, mod.chainH)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Out") then
        entity.Visible = false
    elseif sprite:IsEventTriggered("Jump") then
        sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1)

        data.TargetPos = target.Position

        if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL and rng:RandomFloat() < mod.KConst.HAUMEA_CHARON_DISTANCE then
            local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
            if charon and not charon:GetData().Locked then
                charon:GetData().Locked = "Haumea"
                data.TargetPos = charon.Position
            end
        end

        local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, data.TargetPos, Vector.Zero, entity):ToEffect()
        if target then
            target:SetTimeout(45)
        end

        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    elseif sprite:IsEventTriggered("Land") then
        sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE, 1)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        for i=1,mod.KConst.HAUMEA_N_SPLASH do
            local waterParams = ProjectileParams()
            waterParams.Variant = ProjectileVariant.PROJECTILE_NORMAL
            waterParams.FallingAccelModifier = 2.5
            local angle = i*360/mod.KConst.HAUMEA_N_SPLASH
            entity:FireBossProjectiles (3, entity.Position + Vector(1,0):Rotated(angle), 0, waterParams)
        end

        if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position, Vector.Zero, entity):ToEffect()
            creep.Timeout = mod.KConst.HAUMEA_CREEP_TIMER
            creep.SpriteScale = Vector.One * mod.KConst.HAUMEA_CREEP_SIZE
        end
        
        local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
        if charon and charon.Position:Distance(entity.Position) < 20 then
            local velocity = Vector.FromAngle(rng:RandomFloat()*360)*10
            charon.Velocity = velocity
            if charon:GetData().Locked == "Haumea" then
                charon:GetData().Locked = nil
            end
        end
    end
end

--ded
function mod:HaumeaDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR and entity.SubType == mod.EntityInf[mod.Entity.Haumea].SUB then
        
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 10, 6)
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
        
        mod.savedatarun().planetAlive4 = false
        mod.savedatarun().planetKilled14 = true
        local allDead = (mod.savedatarun().planetKilled11 and mod.savedatarun().planetKilled12 and mod.savedatarun().planetKilled13 and mod.savedatarun().planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, true, false, true)
        else
            local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
            fracture.SpriteScale = Vector.One * 0.67

            game:BombExplosionEffects ( entity.Position, 5, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.5, true, false, DamageFlag.DAMAGE_EXPLOSION )
        end

    end
end
--deding
function mod:HaumeaDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR and entity.SubType == mod.EntityInf[mod.Entity.Haumea].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
    
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 1 then
                sprite.Rotation = 0
            end
        end
    end
end


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.HaumeaUpdate, mod.EntityInf[mod.Entity.Haumea].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.HaumeaDeath, mod.EntityInf[mod.Entity.Haumea].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.HaumeaDying, mod.EntityInf[mod.Entity.Haumea].ID)

--CERES--------------------------------------------------------------------------------------------------

function mod:CeresUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Ceres].VAR and entity.SubType == mod.EntityInf[mod.Entity.Ceres].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
            data.Shield = 0
            data.IsDwaft = true

            data.ObjectivePosition = room:GetCenterPos()

            data.Mode = data.Mode or 0 --0 == wanderer, 1 == healer

            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            entity:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

            sprite:Play("TeleportDown", true)
            sfx:Play(SoundEffect.SOUND_HELL_PORTAL1)
            
			mod:CheckEternalBoss(entity)
		end

        if data.State == 0 then --APPEAR
            if sprite:IsFinished("TeleportDown") then
                sprite:Play("Idle", true)
                data.State = 1
            end
        elseif data.State == 1 then --IDLE
            if data.Mode == 0 then--wanderer
                if sprite:IsFinished("Idle") then
                    if data.ForceHeal or rng:RandomFloat() < 0.2 and mod:CeresShouldHeal() then
                        data.ForceHeal = false
                        sprite:Play("Spell", true)
                        data.State = 2
                    elseif (entity.HitPoints/entity.MaxHitPoints < 0.75) and rng:RandomFloat() < 0.3 and data.Shield <= 0 then
                        sprite:Play("Spell", true)
                        data.State = 3
                    else
                        sprite:Play("Idle", true)
                        mod:CeresCheckHeal(entity)
                    end
                end
            elseif data.Mode == 1 then--healer
                if sprite:IsFinished("Idle") then
                    sprite:Play("Spell", true)
                    data.State = 2
                end
            end
            mod:PlutoMove(entity, data, room, target)

        elseif data.State == 2 then --HEAL
            if sprite:IsFinished("Spell") then
                sprite:Play("SpellEnd", true)
            elseif sprite:IsFinished("SpellEnd") then
                sprite:Play("Idle", true)
                if data.Mode == 0 then--wanderer
                    data.State = 1
                elseif data.Mode == 1 then--healer
                    data.State = 4
                end
            end
            entity.Velocity = Vector.Zero

        elseif data.State == 3 then --SHIELD
            if sprite:IsFinished("Spell") then
                sprite:Play("SpellEnd", true)
            elseif sprite:IsFinished("SpellEnd") then
                sprite:Play("Idle", true)
                data.State = 1
            end
            entity.Velocity = Vector.Zero
            
        elseif data.State == 4 then --EXIT
            
            sprite:RemoveOverlay()
            if sprite:IsFinished("TeleportUp") then
                entity:Remove()
            elseif sprite:IsFinished() then 
                sprite:Play("TeleportUp", true)
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL2)
            end
            entity.Velocity = Vector.Zero

        end
        
        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 10*xvel, 0.1)

        if sprite:IsEventTriggered("Spell") then
            entity:SetColor(Color(1,1,1,1, 1,1,1), 30, 1, true, true)
            game:SpawnParticles (entity.Position, EffectVariant.ULTRA_GREED_BLING, 15, 9, Color(1,1,1,1,1,1,1))

            sfx:Play(SoundEffect.SOUND_BABY_BRIM, 1, 2, false, 2)
            if data.State == 2 then --heal
                mod:CeresHeal(entity)
            elseif data.State == 3 then --shield
                data.Shield = 30*10
                sfx:Play(SoundEffect.SOUND_THUMBSUP)
            end
        end

        if data.Shield > 0 then
            data.Shield = data.Shield - 1
            if not sprite:IsOverlayPlaying("Shield") then
                sprite:PlayOverlay("Shield", true)
                sprite:SetOverlayRenderPriority(false)
            end
        else
            sprite:RemoveOverlay()
        end
	end
end

function mod:CeresHeal(ceres)
    
    local r = mod:GetMeanStdKuiper()
    local mean = r[1]
    local std = r[2]
    local entities = r[3]

    for i=1, #entities do
        local entity = entities[i]
        if entity then 
                
            local ogHp = entity.HitPoints
            entity.HitPoints = entity.MaxHitPoints*mean

            if ogHp ~= entity.HitPoints then
                entity:SetColor(Color(1,1,1,1, 1,1,1), 30, 1, true, true)

                local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, entity.Position, Vector.Zero, nil)

                local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, entity.Position + Vector(0,-60), Vector.Zero, entity):ToEffect()
                if healHeart then
                    healHeart.DepthOffset = 200
                    healHeart:FollowParent(entity)
                    if ogHp > entity.HitPoints then
                        healHeart:GetSprite():ReplaceSpritesheet(0, "hc/gfx/effects/unhearteffect.png", true)
                    end
                end
                
		        game:SpawnParticles (entity.Position, EffectVariant.ULTRA_GREED_BLING, 15, 9, Color(1,1,1,1,1,1,1))
            end
        end
    end
    sfx:Play(SoundEffect.SOUND_VAMP_GULP)
end

function mod:CeresCheckHeal(ceres)

    local r = mod:GetMeanStdKuiper()
    local std = r[2]
    local entities = r[3]

    local n = 0
    for i=1, #entities do
        if entities[i] then n=n+1 end
    end

    if n < 2 then
        ceres:GetData().State = 4
    end

    if std >= 0.15 then
        ceres:GetData().ForceHeal = true
    end
end

function mod:CeresShouldHeal()

    local r = mod:GetMeanStdKuiper()
    local std = r[2]
    local entities = r[3]

    if std > 0.05 then
        return true
    end
    return false
end


--ded
function mod:CeresDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Ceres].VAR and entity.SubType == mod.EntityInf[mod.Entity.Ceres].SUB then
        
        local fracture = mod:SpawnEntity(mod.Entity.GlassFracture, entity.Position, Vector.Zero, nil)
        fracture.SpriteScale = Vector.One * 0.67

        game:BombExplosionEffects ( entity.Position, 5, TearFlags.TEAR_NORMAL, Color.Default, nil, 0.5, true, false, DamageFlag.DAMAGE_EXPLOSION )

        mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.CeresWatch))
    end
end
--deding
function mod:CeresDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Ceres].VAR and entity.SubType == mod.EntityInf[mod.Entity.Ceres].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
    
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 1 then
                sprite.Rotation = 0
                sfx:Play(SoundEffect.SOUND_BEAST_GHOST_DASH, 2)
            end
        end
    end
end

function mod:CeresDamage(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Ceres].VAR and entity.SubType == mod.EntityInf[mod.Entity.Ceres].SUB then
        if entity:GetData().Shield and entity:GetData().Shield > 0 then
            sfx:Play(SoundEffect.SOUND_BISHOP_HIT)
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CeresDamage, mod.EntityInf[mod.Entity.Ceres].ID)


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CeresUpdate, mod.EntityInf[mod.Entity.Ceres].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.CeresDeath, mod.EntityInf[mod.Entity.Ceres].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.CeresDying, mod.EntityInf[mod.Entity.Ceres].ID)

function mod:CeresWatchUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.CeresWatch].SUB then
        if entity.FrameCount % 30 == 0 and # mod:FindByTypeMod(mod.Entity.Ceres) == 0 then
            
            local r = mod:GetMeanStdKuiper()
            local mean = r[1]
            local std = r[2]
            local entities = r[3]
        
            local n = 0
            for i=1, #entities do
                if entities[i] then n=n+1 end
            end

            if n > 1 then
                if mean < 0.4 and mod.savedatasettings().Difficulty > mod.Difficulties.ATTUNED then
                    local ceres = mod:SpawnEntity(mod.Entity.Ceres, mod:GetSafeRandomRoomPos(120), Vector.Zero, nil)
                    ceres:GetData().Mode = 0
                else
                    if std >= 0.25 then
                        local ceres = mod:SpawnEntity(mod.Entity.Ceres, mod:GetSafeRandomRoomPos(120), Vector.Zero, nil)
                        ceres:GetData().Mode = 1
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.CeresWatchUpdate, mod.EntityInf[mod.Entity.CeresWatch].VAR)

function mod:GetMeanStdKuiper()
    local hps = {}

    local plutos = mod:FindByTypeMod(mod.Entity.Pluto)
    local plutoHp = plutos[1] and plutos[1].HitPoints / plutos[1].MaxHitPoints or -1
    if plutoHp > 0 then table.insert(hps, plutoHp) end
    
    local eris = mod:FindByTypeMod(mod.Entity.Eris)
    local erisHp = eris[1] and eris[1].HitPoints / eris[1].MaxHitPoints or -1
    if erisHp > 0 then table.insert(hps, erisHp) end
    
    local makemakes = mod:FindByTypeMod(mod.Entity.Makemake)
    local makemakeHp = makemakes[1] and makemakes[1].HitPoints / makemakes[1].MaxHitPoints or -1
    if makemakeHp > 0 then table.insert(hps, makemakeHp) end
    
    local haumeas = mod:FindByTypeMod(mod.Entity.Haumea)
    local haumeaHp = haumeas[1] and haumeas[1].HitPoints / haumeas[1].MaxHitPoints or -1
    if haumeaHp > 0 then table.insert(hps, haumeaHp) end

    local mean = mod:mean(hps)
    local std = mod:standard_deviation(hps)

    local entities = {plutos[1], eris[1], makemakes[1], haumeas[1]}

    return {mean, std, entities}
end