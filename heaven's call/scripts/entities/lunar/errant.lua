---@diagnostic disable: assign-type-mismatch
local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()
local persistentData = Isaac.GetPersistentGameData()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&%&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%%############%%##%%%&@@@ ,@@@@@@@@@@@@@@@@@ @@@@@
@@@@@@@@@@@@@@@@@@@@@&&&&%#############(###(((((((######%%%%&@@@@@ @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@&%%&###/(////(((((######(((((((/((((((((((###%@@@@@@@@@@@@.@@@@
@@@@@@@@@@@@@@%###(((/%///////////////%(/((((((/////((((((((((###%&@@@@@@@@@@@@@
@@@@@@@@@@@&%#//*******##,***********/%////////((((((%((((####((((#%@@@@@@@@@@@@
@@@@@@@@@%%#((/**********##(*****////%%////((((###&%%###(((((((//////(#%@@@@@@@@
@@@@@@@&%%#(,***,,,*****##(*****//**/##///%((//(##((((((((///////*#///((#@@@@@@@
@@@@@@&%#((///**,,,,,,##,*,***,,####/*****#//%%/(//(((((((((///#%///*///(%@@@@@@
@@@@@@&%##((/////****//%#****/,,,(,###/**#*///#//((/(#(((((((%%(//////((((%&@@@@
@@@@@(((((((((((//(/%///(##/*/###*******##///%/////%((((((%%((((((#(#((//(%&@@@@
@@@&%##(%((/////////%///**####**********///%%////#(/////%%(////////(/////(#%%@@@
@@@#((///*#******/*/##****#*****,,,**,,,**,,*(###****###**********///////((((#@@
@&(((//*****#,,,,,,**,((#,,,,,,,,#((,,,.,,,,..,,((,((,,.......,,*,,,,,**//(*(#%@
@@%(///**,,,*,####/**##,,,,((,...,....,,(/,,,,,,,.((,.,.,/(...,*,,,****//(((((%@
@@&##((/***,,,,****##*,,,,*##,,(##(///.(((,,,,,,,,..(/(*..,(,,,/*,((,,*/////(((%
@@@%###(///*****,,#**,,*,,,,,*#####////********,,,,,,,(..,,,///****,,,,*******/&
@@&%####(((/////*/****,,******(#####///.**********,,,,,.........*/..,,,,,***/(%,
@@&%%##((((((/%////#*/****###**######**(##(*****,*,*(,,.//......*.....,,,*//(#&@
@@@###/(/////%%/*/*/##,********,*##***********,**#(,,,,./*....*...,,,,,,*/*(#%@@
@%@@#((/**********#(***#,,*,,,.,,##*,,*,,,,***##/*,,,,,.,//./,...,,,****//(#%@ @
@@@&&##(/********#*****#,#/**.,****,,*,****##***##,,,**../,,,,,,,,,**//(##%%&&@@
@@@@&&%%(//**,**/***********((*********###************,#(,,,,,******//(###&&&@@@
@@@@@&&%%((/*,*,,,,,,,,***#(***######****#**,,*,,,,*****,(*********/(((##%%@@@@@
@@@@@@@@&%#(//**,,,,*******#////////#////#///*******///****(******/(((((#%@@@@@@
@@@@@@@@@#&(##((////*/***(#*///***(//////##//******/**/******#**//(((((#@@@@@@@@
@@@@@@@@@@@@@&,%#(((////#/**/***,,,(*,,,#,****************,,**/#(((##&@@@@@@@@@@
@@@/@ @@@@@@@@&&%&(#((%//////////////****/****************///(##((%&@@@@@@@@%@@@
@@@@@@@@@@@@@@@@@@@@#&##((((/////////////#****///****/((((##%%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&%%%###(#####(((((((########%%%%%%#&@@%@@%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@ @@(@@@@@@&&&&&&%(%%&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@ @@@@@@@@@@
]]--
mod.QMSState = {
	APPEAR = 0,
	IDLE = 1,
    ATTACK1 = 2,
    ATTACK2 = 3,
    STILL = 4,
}

mod.QForms = {
    THE_EYE = 0,
    EMBER_TWIN = 1,
    ASH_TWIN = 2,
    TIMBER_HEART = 3,
    BRITTLE_HOLLOW = 4,
    DEEPS_GIANT = 5,
    DARK_BRAMBLE = 6,
}

mod.chainTransformQ = {
    [mod.QForms.THE_EYE] =          {0,   0.2, 0,   0.2, 0.2, 0.2, 0.2},
    [mod.QForms.EMBER_TWIN] =       {0,   0,   0,   0.25,0.25,0.25,0.25},
    [mod.QForms.ASH_TWIN] =         {1,   0,   0,   0,   0,   0,   0},
    [mod.QForms.TIMBER_HEART] =     {0,   0.25,0,   0,   0.25,0.25,0.25},
    [mod.QForms.BRITTLE_HOLLOW] =   {0,   0.25,0,   0.25,0,   0.25,0.25},
    [mod.QForms.DEEPS_GIANT] =      {0,   0.25,0,   0.25,0.25,0,   0.25},
    [mod.QForms.DARK_BRAMBLE] =     {0,   0.25,0,   0.25,0.25,0.25,0},
}

mod.QConst = {
    SPEED = 1.3,--1.3
    IDLE_TIME_INTERVAL = Vector(10,20),

    ATTLEROCK_SPEED = 13,
    MOON_ORBIT_DISTANCE = 14,

    ABSORB_SPEED = 15,
    
	N_RAIN_DROP = 6,
	RAIN_DROP_RADIUS = 80,

    N_ELECTRICITIES = 9,
    ELECTRICITY_DIST = 60,
    ELECTRICITY_ANGLE = 90,
    ELECTRICITY_TIMEOUT = 30,--Even

    N_SPIKES = 32,

    N_CHAINS = 7,

    ROCK_SPEED = 6,
    N_ROCK1 = 15,
    N_ROCK2 = 12,
    N_ROCK3 = 8,
    ROCK_ANGLE = 30,

}

mod.QProjectiles = {}
mod.QTears = {}
mod.QEntities = {}
mod.QFamiliars = {}

function mod:ErrantUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR and entity.SubType == mod.EntityInf[mod.Entity.Errant].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0
            data.StateAttack = 1
            data.Form = mod.QForms.THE_EYE
            data.ForceTransform = true
            data.EmberLaunched = false
            data.AttleLaunched = false

            sprite:SetOverlayRenderPriority(true)
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.QMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod.QMSState.IDLE
				data.StateFrame = 0
                --sprite:SetRenderFlags(AnimRenderFlags.GLITCH)
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			elseif sprite:GetFrame()==40 and sprite:IsPlaying("AppearSlow") then--Turn black
                if not mod:IsChallenge(mod.Challenges.BabelTower) then
                    game:SetColorModifier(ColorModifier(0,0,0,1),false)
                end
            elseif sprite:GetFrame()==75 and sprite:IsPlaying("AppearSlow") then--Turn no black
                if not mod:IsChallenge(mod.Challenges.BabelTower) then
                    game:SetColorModifier(ColorModifier(1,1,1,0),false)
                end
            elseif sprite:GetFrame()==60 and sprite:IsPlaying("AppearSlow") then--backgorund
            
                if not mod:IsChallenge(mod.Challenges.BabelTower) then
                    for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
                        e:Remove()
                    end
                    mod:ChangeRoomBackdrop(mod.Backdrops.QUANTUM)
                end

                mod.ModFlags.ErrantTriggered = true

                --Re-close doors
                for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                    local door = room:GetDoor(i)
                    if door then
                        door:Close()
                        door:GetSprite():Play("Closed")
                    end
                end
            end
			
		elseif data.State == mod.QMSState.IDLE then
			if data.StateFrame == 1 then
                if data.EmberLaunched then
                    sprite:Play("Idle1",true)
                else
                    sprite:Play("Idle",true)
                end
			elseif sprite:IsFinished("Idle") or sprite:IsFinished("Idle1") then
				if data.ForceTransform then
                    mod:ChangeForm(entity, sprite, data)
                else
                    if rng:RandomFloat() < 0.5 then
                        data.State = mod.QMSState.IDLE
                    else
                        if rng:RandomFloat() < 0.5 then
                            data.State = mod.QMSState.ATTACK1
                        else
                            data.State = mod.QMSState.ATTACK2
                        end
                    end
                end
				data.StateFrame = 0
                if data.Form == mod.QForms.BRITTLE_HOLLOW then
                    sprite:Play("Idle",true)
                end
			end
            mod:ErrantMove(entity, data, room, target)
			
		elseif data.Form == mod.QForms.EMBER_TWIN  and (data.State == mod.QMSState.ATTACK1 or data.State == mod.QMSState.ATTACK2) then
            if not data.EmberLaunched then
                mod:EmberLaunch(entity, data, sprite, target, room)
            else
                mod:EmberBlast(entity, data, sprite, target, room)
            end

        elseif data.Form == mod.QForms.TIMBER_HEART then
            if data.State == mod.QMSState.ATTACK1 then
                mod:TimberWater(entity, data, sprite, target, room)
            else
                if data.AttleLaunched then
                    mod:TimberWater(entity, data, sprite, target, room)
                else
                    mod:TimberAttleThrow(entity, data, sprite, target, room)
                end
            end

		elseif data.State == mod.QMSState.ATTACK1 then    
        
            if data.Form == mod.QForms.BRITTLE_HOLLOW then
                mod:BrittleTeleport(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DEEPS_GIANT then
                mod:GiantTornado(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DARK_BRAMBLE then
                mod:BrambleBite(entity, data, sprite, target, room)
            end

		elseif data.State == mod.QMSState.ATTACK2 then    
        
            if data.Form == mod.QForms.BRITTLE_HOLLOW then
                mod:BrittleAbsorb(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DEEPS_GIANT then
                mod:GiantElectricity(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DARK_BRAMBLE then
                mod:BrambleSeed(entity, data, sprite, target, room)
            end
		end

        if data.Form == mod.QForms.BRITTLE_HOLLOW then

            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                local dist = player.Position:Distance(entity.Position)
                if dist < 75 then
                    local direction = (player.Position - entity.Position)
                    player.Velocity = player.Velocity - direction:Length()/75 * direction:Normalized() / 2
                end
            end
            for _, t in ipairs(mod.QProjectiles) do
                if t then
                    local dist = t.Position:Distance(entity.Position)
                    if t:GetData().NoAbsorb and dist < 100 then
                        local direction = (t.Position - entity.Position)
                        t.Velocity = t.Velocity - direction:Length()/100 * direction:Normalized()/2
                    end
                end
            end
            for _, t in ipairs(mod.QTears) do
                if t then
                    local dist = t.Position:Distance(entity.Position)
                    if dist < 100 then
                        local direction = (t.Position - entity.Position)
                        t.Velocity = t.Velocity - direction:Length()/100 * direction:Normalized()*2
                    end
                end
            end

            if entity.FrameCount % 2 == 0 then
                mod.QProjectiles = Isaac.FindByType(EntityType.ENTITY_PROJECTILE)
                mod.QTears = Isaac.FindByType(EntityType.ENTITY_TEAR)
            end
	        
            mod.ShaderData.blackHolePosition = entity.Position + Vector(0,-40)+ entity.Velocity

        elseif data.Form == mod.QForms.EMBER_TWIN then
            local ash = entity.Parent
            if ash then
                local ashData = ash:GetData()
                local ashSprite = ash:GetSprite()

                if not ashData.StateFrame then
                    ashData.State = mod.QMSState.IDLE
                    ashData.StateFrame = 0
                    ashData.StateAttack = 1
                end

                ashData.StateFrame = ashData.StateFrame + 1

                if ashData.State == mod.QMSState.IDLE then
                    mod:ErrantMove(ash, ashData, room, target)
                elseif ashData.State == mod.QMSState.ATTACK1 then
                    mod:AshTime(entity, ash, ashData, ashSprite, target, room)
                elseif ashData.State == mod.QMSState.ATTACK2 then
                    mod:AshColumn(entity, ash, ashData, ashSprite, target, room)
                end
            end

        end
	end
end
--EmberTwin twin
function mod:EmberLaunch(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Launch",true)
    elseif sprite:IsFinished("Launch") then
        mod:ErrantEndAttack(entity, data, sprite)
        data.StateAttack = 1
        data.EmberLaunched = true
        --[[sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        sprite:Play("Idle",true)]]

    elseif sprite:IsEventTriggered("Launch") then
        
        --sfx:Play(Isaac.GetSoundIdByName("TwinLaunch"),1)
        sfx:Play(SoundEffect.SOUND_CHAIN_BREAK,2)

        --Ash spawn
        local parent = entity
        for i=1,mod.QConst.N_CHAINS do
            local chain = mod:SpawnEntity(mod.Entity.TwinChain, entity.Position, Vector.Zero, entity):ToNPC()
            chain:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            chain:GetSprite():Play("Normal", true)
            chain.CollisionDamage = 0
            chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            parent.Child = chain
            chain.Parent = parent
            chain.I1 = i
            chain.DepthOffset = -15
            
            parent = chain
        end
        local ash = mod:SpawnEntity(mod.Entity.AshTwin, entity.Position, Vector.Zero, entity):ToNPC()
        ash:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        ash:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
        ash:GetSprite():Play("Idle", true)
        ash.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        parent.Child = ash
        ash.Parent = parent
        ash.I1 = mod.QConst.N_CHAINS+1

        entity.Parent = ash

        ash.Velocity = (target.Position - entity.Position):Normalized()*15

    end
        
end
function mod:EmberBlast(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero
    local n
    if data.StateFrame == 1 then
        sprite:Play("Rocks",true)
        sfx:Play(Isaac.GetSoundIdByName("Crumbling"),2)

        local ash = entity.Parent
        if ash then
            local ashData = ash:GetData()
            local ashSprite = ash:GetSprite()

            if not ashSprite:IsPlaying("Time") then
                ashData.StateFrame = 0
                if ashData.StateAttack == 1 then
                    ashData.StateAttack = 2
                    ashData.State = mod.QMSState.ATTACK1
                else
                    ashData.State = mod.QMSState.ATTACK2
                end
            end
        end
    elseif sprite:IsFinished("Rocks") then
        sfx:Stop(Isaac.GetSoundIdByName("Crumbling"))
        mod:ErrantEndAttack(entity, data, sprite)
        
    elseif sprite:IsEventTriggered("Attack1") then
        n = mod.QConst.N_ROCK1
        local direction = (target.Position - entity.Position):Normalized()
        data.TargetDirection = direction
    elseif sprite:IsEventTriggered("Attack2") then
        n = mod.QConst.N_ROCK2
    elseif sprite:IsEventTriggered("Attack3") then
        n = mod.QConst.N_ROCK3
    end

    if sprite:IsEventTriggered("Attack1") or sprite:IsEventTriggered("Attack2") or sprite:IsEventTriggered("Attack3") then
        local a = -(n-1)*mod.QConst.ROCK_ANGLE/2
        local b = (n-1)*mod.QConst.ROCK_ANGLE/2
        for angle = a, b, mod.QConst.ROCK_ANGLE do
            local velocity = data.TargetDirection:Rotated(angle)*mod.QConst.ROCK_SPEED
            local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, velocity, entity):ToProjectile()
            rock:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            mod:TearFallAfter(rock, 30*10)
            rock:GetSprite().Color = mod.Colors.ember
        end
    end
        
end
--AshTwin twin
function mod:AshTime(ember, ash, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Time",true)
    elseif sprite:IsFinished("Time") then
        data.State = mod.QMSState.IDLE
        data.StateFrame = 0
        sprite:Play("Idle",true)

    elseif sprite:IsEventTriggered("TimeSave") then
        sfx:Play(Isaac.GetSoundIdByName("AshTime1"),5)
        mod:SaveTime()

    elseif sprite:IsEventTriggered("TimeLoad") then
        if not mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
            mod:LoadTime()
        end
        
    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(Isaac.GetSoundIdByName("AshTime2"),1.2)
    end
        
end
function mod:AshColumn(ember, ash, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Sand",true)
    elseif sprite:IsFinished("Sand") then
        data.State = mod.QMSState.IDLE
        data.StateFrame = 0
        sprite:Play("Idle",true)

    elseif sprite:IsEventTriggered("Summon") then
        sfx:Play(Isaac.GetSoundIdByName("Earthquake"),2)
        local pillar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, 0, ash.Position, Vector.Zero, ash):ToEffect()
        --pillar:GetSprite():ReplaceSpritesheet(2, "hc/gfx/effects/static_laser.png")
        pillar:GetSprite():LoadGraphics()
        pillar.Parent = ash
        pillar.Timeout = 60
        pillar:GetData().HeavensCall = true
        pillar:GetSprite().Color = mod.Colors.sand
    end
        
end

function mod:SaveTime()

    local count = 1
    for i, f in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
        mod.QFamiliars[count] = f
        mod.QFamiliars[count+1] = f.Position
        mod.QFamiliars[count+2] = f.Velocity
        mod.QFamiliars[count+3] = f:GetSprite():GetAnimation()
        mod.QFamiliars[count+4] = f:GetSprite():GetFrame()

        count = count + 5
    end
    local count = 1
    for i, _p in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
        local p = _p:ToProjectile()
        if p then
            mod.QProjectiles[count] = p
            mod.QProjectiles[count+1] = p.Position
            mod.QProjectiles[count+2] = p.Velocity
            mod.QProjectiles[count+3] = p.Height
    
            p:GetData().Saved = true
    
            count = count + 4
        end
    end
    local count = 1
    for i, _t in ipairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
        local t = _t:ToTear()
        if t then
            mod.QTears[count] = t
            mod.QTears[count+1] = t.Position
            mod.QTears[count+2] = t.Velocity
            mod.QTears[count+3] = t.Height
            
            t:GetData().Saved = true
    
            count = count + 4
        end
    end

    local count = 1
    for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Errant].ID)) do
        mod.QEntities[count] = e
        mod.QEntities[count+1] = e.Position
        mod.QEntities[count+2] = e.Velocity
        mod.QEntities[count+3] = e.HitPoints
        mod.QEntities[count+4] = e:GetSprite():GetAnimation()
        mod.QEntities[count+5] = e:GetSprite():GetFrame()

        count = count + 6
    end
    for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.TwinChain].ID, mod.EntityInf[mod.Entity.TwinChain].VAR, mod.EntityInf[mod.Entity.TwinChain].SUB)) do
        mod.QEntities[count] = e
        mod.QEntities[count+1] = e.Position
        mod.QEntities[count+2] = e.Velocity
        mod.QEntities[count+3] = e.HitPoints
        mod.QEntities[count+4] = e:GetSprite():GetAnimation()
        mod.QEntities[count+5] = e:GetSprite():GetFrame()

        count = count + 6
    end
    for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
        mod.QEntities[count] = e
        mod.QEntities[count+1] = e.Position
        mod.QEntities[count+2] = e.Velocity
        mod.QEntities[count+3] = e.HitPoints
        mod.QEntities[count+4] = e:GetSprite():GetAnimation()
        mod.QEntities[count+5] = e:GetSprite():GetFrame()

        count = count + 6
    end

end
function mod:LoadTime()

    for i=1, #mod.QFamiliars, 5 do
        if mod.QFamiliars[i] then
            local entity = mod.QFamiliars[i]
            entity.Position = mod.QFamiliars[i+1]
            entity.Velocity = mod.QFamiliars[i+2]
            entity:GetSprite():Play(mod.QFamiliars[i+3], true)
            entity:GetSprite():SetFrame(mod.QFamiliars[i+4])
        end
    end
    for i=1, #mod.QProjectiles, 4 do
        if mod.QProjectiles[i] then
            local entity = mod.QProjectiles[i]:ToProjectile()
            
            entity.Position = mod.QProjectiles[i+1]
            entity.Velocity = mod.QProjectiles[i+2]
            entity.Height = mod.QProjectiles[i+3]

            if entity.ChangeTimeout and entity.ChangeTimeout > 0 then
                entity.ChangeTimeout = 30*10
            end
        end
    end
    for i=1, #mod.QTears, 4 do
        if mod.QTears[i] then
            local entity = mod.QTears[i]:ToTear()
            
            entity.Position = mod.QTears[i+1]
            entity.Velocity = mod.QTears[i+2]
            entity.Height = mod.QTears[i+3]
        end
    end
    for i=1, #mod.QEntities, 6 do
        if mod.QEntities[i] then
            local entity = mod.QEntities[i]

            entity.Position = mod.QEntities[i+1]
            entity.Velocity = mod.QEntities[i+2]
            entity.HitPoints = mod.QEntities[i+3]

            if not (entity.Type == mod.EntityInf[mod.Entity.Errant].ID or entity.Type == EntityType.ENTITY_PLAYER) then
                entity:GetSprite():Play(mod.QEntities[i+4], true)
                entity:GetSprite():SetFrame(mod.QEntities[i+5])
            end
        end
    end

    --Destroy new
    mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE))
    mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_TEAR))
end

--Timber Heart
function mod:TimberAttleThrow(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Throw",true)
        local attlerock = entity.Child
        if attlerock then
            attlerock:GetData().orbitSpeed = attlerock:GetData().orbitSpeed*2
        end
    elseif sprite:IsFinished("Throw") then
        data.AttleLaunched = true
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        
        sfx:Play(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,1)

        local attlerock = entity.Child
        if attlerock then
            entity.Child = nil
            attlerock.Parent = nil
            attlerock.Velocity = (target.Position - attlerock.Position):Normalized()*mod.QConst.ATTLEROCK_SPEED
            attlerock:GetSprite():Play("Spin", true)
        end
    end 
end
function mod:TimberWater(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Water",true)
    elseif sprite:IsFinished("Water") then
        data.Geyser = false
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("Geyser"),1.8)

        data.Geyser = true

        local waterParams = ProjectileParams()
		waterParams.Variant = ProjectileVariant.PROJECTILE_TEAR
		waterParams.FallingAccelModifier = 0.5
		local angle = 180
        if sprite.FlipX then
            angle = 0
        end
		entity:FireBossProjectiles (7, entity.Position + Vector(5,0):Rotated(angle), 0, waterParams)

        local n = mod:RandomInt(1,4)
        for i=1, 4 do
            local bubble = mod:SpawnEntity(mod.Entity.Bubble, entity.Position, Vector(10,0):Rotated(angle), entity)
            bubble:GetData().IsBubble_HC = true
        end

        entity.Velocity = Vector(20,0):Rotated(180-angle)

    end

    if data.Geyser then
        if entity:CollidesWithGrid() then
            game:ShakeScreen(30)
            game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 10, 5)
        end
    end
end
--Brittle Hollow
function mod:BrittleTeleport(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Out",true)
        sfx:Play(Isaac.GetSoundIdByName("Warp"),1)
    elseif sprite:IsFinished("Out") then
        entity.Position = mod:GetRandomPosition(entity.Position, 200, target.Position)
        sprite:Play("In",true)
    elseif sprite:IsFinished("In") then
        local lantern = entity.Child
        if lantern then
            lantern:GetData().orbitDistance = mod.QConst.MOON_ORBIT_DISTANCE
            lantern.SpriteScale = Vector.One
        end
        mod:ErrantEndAttack(entity, data, sprite)

    elseif sprite:IsPlaying("In") then
        local lantern = entity.Child
        if lantern then
            lantern:GetData().orbitDistance = math.min(mod.QConst.MOON_ORBIT_DISTANCE, lantern:GetData().orbitDistance + 0.5) 
            lantern.SpriteScale = lantern.SpriteScale*2
        end
    elseif sprite:IsPlaying("Out") then
        local lantern = entity.Child
        if lantern then
            lantern:GetData().orbitDistance = math.max(0, lantern:GetData().orbitDistance - 0.5) 
            lantern.SpriteScale = lantern.SpriteScale*0.5
        end

    end 
end
function mod:BrittleAbsorb(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Absorb",true)
        if entity.Parent then
            entity.Parent:GetData().Queue = 0
        end
    elseif sprite:IsFinished("Absorb") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:WasEventTriggered("Attack") then
        
        for _,r in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0)) do
            if not r:GetData().NoAbsorb then
                r.Velocity = (-r.Position + entity.Position):Normalized() * mod.QConst.ABSORB_SPEED
            end
            if r.Position:Distance(entity.Position) < 250 and not r:GetData().Marked then
                r:GetData().Marked = true
                entity.Parent:GetData().Queue = entity.Parent:GetData().Queue + 1
                
                if not entity.Parent:GetSprite():IsPlaying("Attack") then
                    entity.Parent:GetSprite():Play("Attack", true)
                end

            elseif r.Position:Distance(entity.Position) < 10 then
                r:Remove()
            end
        end
    end
end
--Giant's Deep
function mod:GiantElectricity(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Jump",true)
    elseif sprite:IsFinished("Jump") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Jump") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(Isaac.GetSoundIdByName("Electricity"),1)
    elseif sprite:IsEventTriggered("Land") then
        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST,1)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        for i=1, mod.QConst.N_ELECTRICITIES do
            local angle = i*360/mod.QConst.N_ELECTRICITIES
            local position = entity.Position + Vector(20,0):Rotated(angle)

            local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, position, Vector.Zero, entity):ToEffect()
            glow:GetSprite().Color = mod.Colors.red
            glow.Parent = entity
            glow.Timeout = mod.QConst.ELECTRICITY_TIMEOUT
			glow.SpriteScale = Vector.One*0.5

            local glowData = glow:GetData()
            glowData.HeavensCall = true
            glowData.Direction = Vector(1,0):Rotated(angle)
            glowData.IsActive_HC = true
        end
    end
        
end
function mod:GiantTornado(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Tornado",true)
    elseif sprite:IsFinished("Tornado") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        
        sfx:Play(Isaac.GetSoundIdByName("GiantsTornado"),1)

        local velocity = (target.Position - entity.Position):Normalized()*3

		local tornado = mod:SpawnEntity(mod.Entity.Tornado, entity.Position+Vector(0,1), Vector.Zero, entity)
        tornado.Parent = entity
        tornado:GetSprite().Color = mod.Colors.giant
		tornado:GetData().Lifespan = 8
		tornado:GetData().Height = 6
		tornado:GetData().Scale = 0.75
		tornado:GetData().FastSpawn = true
		tornado:GetData().Velocity = velocity
		tornado:GetData().Rain = true
		tornado:GetData().IsGiants = true
    end
end
--Dark Bramble
function mod:BrambleBite(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Bite",true)
    elseif sprite:IsFinished("Bite") then
        mod:ErrantEndAttack(entity, data, sprite)

    elseif sprite:IsEventTriggered("Spawn") then
        sfx:Play(SoundEffect.SOUND_ANGRY_GURGLE,1)

        local spikes = {}
        for i=1, mod.QConst.N_SPIKES do
            local direction = mod.RoomWalls.UP
            if i<mod.QConst.N_SPIKES/2 then
                direction = mod.RoomWalls.DOWN
            end
            
            local position, rotation = mod:RandomUpDown(direction)
            local spike = mod:SpawnEntity(mod.Entity.BrambleSpike, position, Vector.Zero, entity)
            spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            if direction == mod.RoomWalls.DOWN then
                spike:GetSprite().FlipY = true
            end

            spikes[i] = spike

            for j, s in ipairs(spikes) do
                if j~=i and s.Position:Distance(spike.Position) < 60 then
                    i = i - 1
                    spike:Remove()
                end
            end
        end
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("Chomp"),1)

    end 
end
function mod:BrambleSeed(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Seed",true)
    elseif sprite:IsFinished("Seed") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,1)

        local velocity = (target.Position-entity.Position):Normalized()*20
        local seed = mod:SpawnEntity(mod.Entity.BrambleSeed, entity.Position, velocity, entity)
        seed:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        seed:GetSprite():Play("Appear", true)
        seed.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end

--Move
function mod:ErrantMove(entity, data, room, target)
    if not (data.Form == mod.QForms.DARK_BRAMBLE or data.Form == mod.QForms.BRITTLE_HOLLOW) then
        mod:FaceTarget(entity, target)
    else
        entity:GetSprite().FlipX = false
    end
    --idle move taken from 'Alt Death' by hippocrunchy
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.QConst.IDLE_TIME_INTERVAL.X, mod.QConst.IDLE_TIME_INTERVAL.Y)
		--V distance of Jupiter from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > 100 then
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
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.QConst.SPEED
    data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:ErrantDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR and entity.SubType == mod.EntityInf[mod.Entity.Errant].SUB then
        mod.savedatarun().errantKilled = true

        mod:ClearEntities()

        if mod.savedatarun().errantAlive then
            local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,  2^32-2, entity.Position, Vector.Zero, nil)
            reward:AddEntityFlags(EntityFlag.FLAG_GLITCH)

            local shard = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.Trinkets.Shard, entity.Position, mod:RandomVector(4, 3.5), nil)

            if game:GetLevel():GetCurrentRoomDesc().Data.Type == RoomType.ROOM_ERROR then
                local v = Vector(25,0)
                local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, game:GetRoom():GetCenterPos()+v, Vector.Zero, nil)
                local trapdoor = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, game:GetRoom():GetCenterPos()-v, true)
            end
            
            if not mod.savedatarun().planetSol1 then
                mod.savedatarun().planetSol1 = true
            else
                mod.savedatarun().planetSol2 = true
            end
        end
        mod.savedatarun().errantAlive = false

        if game:IsGreedMode() then
            persistentData:TryUnlock(Isaac.GetAchievementIdByName("titan (HC)"), false)

            mod:scheduleForUpdate(function ()
                mod:LunarPactDoomSpawn(nil,nil,true)
            end, 12)
        end

        music:Crossfade(Music.MUSIC_DARK_CLOSET, 0.003)
    end
end
--deding
function mod:ErrantDying(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR and entity.SubType == mod.EntityInf[mod.Entity.Errant].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
    
        if data.deathFrame == nil then data.deathFrame = 1 end
        if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
            data.deathFrame = data.deathFrame + 1
            if data.deathFrame == 2 then
                mod:ClearEntities()
                sprite:Load("hc/gfx/entity_Errant.anm2", true)
                sprite:PlayOverlay("", true)
                sprite:LoadGraphics()
                sprite:Play("Death", true)
                
                mod:UpdateDefeat(entity)
            end
    
            if sprite:IsEventTriggered("Sound") then
                sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1)
            end
        end
    end
end

--State switch things
function mod:ErrantEndAttack(entity, data, sprite)
    if data.StateAttack == 1 then
        data.StateAttack = 2
    elseif data.StateAttack == 2 then
        data.StateAttack = 1
        data.ForceTransform = true
    end
    data.State = mod.QMSState.IDLE
    data.StateFrame = 0
end
function mod:ChangeForm(entity, sprite, data)

	mod.ShaderData.blackHole = false

    --Datas
    data.StateAttack = 1
    data.ForceTransform = false
    data.EmberLaunched = false
    data.AttleLaunched = false

    local form = mod:MarkovTransition(data.Form, mod.chainTransformQ)
    data.Form = mod.QForms.THE_EYE
    --data.Form = mod.QForms.EMBER_TWIN

    mod.QProjectiles = {}
    mod.QTears = {}
    mod.QEntities = {}
    mod.QFamiliars = {}

    sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1.3)

    --Entities
    mod:ClearEntities()


    sprite:PlayOverlay("", true)
    --Switch Animation
    sprite:Load("hc/gfx/entity_Errant.anm2", true)
    sprite:LoadGraphics()
    sprite:Play("Switch", true)
    sprite:SetFrame(mod:RandomInt(0, sprite:GetFrame(sprite:SetLastFrame())-1))
    data.State = mod.QMSState.STILL

    mod:scheduleForUpdate(function()
        if not entity then return end
        sfx:Play(SoundEffect.SOUND_EDEN_GLITCH,1)

        data.State = mod.QMSState.IDLE
        data.Form = form
        --Sprites

        if data.Form == mod.QForms.EMBER_TWIN then
            sprite:Load("hc/gfx/entity_ErrantEmber.anm2", true)

        elseif data.Form == mod.QForms.TIMBER_HEART then
            sprite:Load("hc/gfx/entity_ErrantTimber.anm2", true)
            
        elseif data.Form == mod.QForms.BRITTLE_HOLLOW then
            sprite:Load("hc/gfx/entity_ErrantBrittle.anm2", true)
            mod:EnableBlackHole(entity.Position + Vector(0,-40), 0.25)
            
        elseif data.Form == mod.QForms.DEEPS_GIANT then
            sprite:Load("hc/gfx/entity_ErrantGiant.anm2", true)
            
        elseif data.Form == mod.QForms.DARK_BRAMBLE then
            sprite:Load("hc/gfx/entity_ErrantBramble.anm2", true)

            sprite:PlayOverlay("Brambles", true)

        end
        sprite:LoadGraphics()
        sprite:Play("Idle", true)
        
        if data.Form == mod.QForms.TIMBER_HEART then
            local orbitDistance = mod.QConst.MOON_ORBIT_DISTANCE
            local position = entity.Position + Vector(orbitDistance,0)
            local attlerock = mod:SpawnEntity(mod.Entity.Attlerock, position, Vector.Zero, entity)
            attlerock:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
            attlerock:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            attlerock:GetSprite():Play("Idle", true)
            attlerock.Parent = entity
            entity.Child = attlerock
            
            local arData = attlerock:GetData()
            arData.orbitIndex = 1
            arData.orbitTotal = 1
            arData.orbitDistance = orbitDistance
            arData.orbitSpin = 1
            arData.orbitSpeed = 4

            attlerock.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        elseif data.Form == mod.QForms.BRITTLE_HOLLOW then
            local orbitDistance = mod.QConst.MOON_ORBIT_DISTANCE
            local position = entity.Position + Vector(orbitDistance,0)
            local lantern = mod:SpawnEntity(mod.Entity.HollowsLantern, position, Vector.Zero, entity)
            lantern:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
            lantern:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            lantern:GetSprite():Play("Idle", true)
            lantern.Parent = entity
            entity.Child = lantern
            
            local lanternData = lantern:GetData()
            lanternData.orbitIndex = 1
            lanternData.orbitTotal = 1
            lanternData.orbitDistance = orbitDistance
            lanternData.orbitSpin = 1
            lanternData.orbitSpeed = 4

            lantern.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

            
            local whitehole = mod:SpawnEntity(mod.Entity.WhiteHole, position, Vector.Zero, entity)
            whitehole:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
            whitehole:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            whitehole:GetSprite():Play("Idle", true)
            whitehole.Parent = entity
            whitehole.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            entity.Parent = whitehole

        end

    end, 15)

end
function mod:ClearEntities()
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Attlerock))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.WhiteHole))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.HollowsLantern))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.AshTwin))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.TwinChain))
    mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE), true)
end
function mod:DeleteEntities(list, forced)
    for i=1, #list do
        local v = list[i]

        if (not v:GetData().Saved) or forced then
            v:Remove()
        end
    end
end


function mod:FamiliarParentMovement2(entity, distance, speed, stopness, offset) --srsl... stopness??
    if not entity.Parent then
        entity:Remove()
    else
        local parent = entity.Parent
        local originalVel = entity.Velocity

        entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, speed)

        local direction = parent.Position+offset - entity.Position

        if parent.Position:Distance(entity.Position) > distance then
            entity.Velocity = mod:Lerp(entity.Velocity, direction / stopness, speed)
        end

        local newVel = entity.Velocity

        entity.Velocity = originalVel
        return newVel
    end

end
function mod:ChainUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.TwinChain].VAR and entity.SubType == mod.EntityInf[mod.Entity.TwinChain].SUB then
        if entity.Parent then
            local parent = entity.Parent
            local sprite = entity:GetSprite()

            local v1 = mod:FamiliarParentMovement2(entity, 2, 1.5, 15, Vector.Zero)
            local v2 = Vector.Zero

            local child = entity.Child
            entity.Parent = child
            v2 = mod:FamiliarParentMovement2(entity, 2, 1.5, 15, parent:GetData().ChainOffset or Vector.Zero)
            entity.Parent = parent

        --[[if v1:Length() > v2:Length() then
                entity.Velocity = v1
            else
                entity.Velocity = v2
            end]]
            if v1 and v2 then
                entity.Velocity = v1 and v2 and (v1+v2)*1.65
            end

        else
            entity:Remove()
        end

        if entity:GetData().Glued then
            entity.Velocity = Vector.Zero
            if entity.Child then
                entity.Position = entity.Child.Position
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ChainUpdate, mod.EntityInf[mod.Entity.TwinChain].ID)


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ErrantUpdate, mod.EntityInf[mod.Entity.Errant].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ErrantDeath, mod.EntityInf[mod.Entity.Errant].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.ErrantDying, mod.EntityInf[mod.Entity.Errant].ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)

    if entity:GetData().Form == mod.QForms.BRITTLE_HOLLOW then
		game:MakeShockwave(entity.Position + Vector(0,-45), -0.075, 0.00025, 2)
		--game:MakeShockwave(entity.Position + Vector(0,-45), 0.175, 0.005, 2)
        --game:MakeShockwave(entity.Position + Vector(0,-45), -0.05, 0.00000001, 30)
        --game:MakeShockwave(entity.Position + Vector(0,-45), -0.01, 0.01, 30)
    elseif entity.Variant == mod.EntityInf[mod.Entity.WhiteHole].VAR and entity.SubType == mod.EntityInf[mod.Entity.WhiteHole].SUB then
		--game:MakeShockwave(entity.Position + Vector(0,-15), -0.25, 0.01, 2)
		--game:MakeShockwave(entity.Position + Vector(0,-15), 0.175, 0.005, 2)
        --game:MakeShockwave(entity.Position + Vector(0,-15), -0.05, 0.00000001, 60)
        game:MakeShockwave(entity.Position + Vector(0,-45), 0.04, 0.01, 2)
    end
end, mod.EntityInf[mod.Entity.Errant].ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
    if entity.Variant == mod.EntityInf[mod.Entity.AshTwin].VAR and entity.SubType == mod.EntityInf[mod.Entity.AshTwin].SUB then
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Errant)) do
            e:TakeDamage(amount, flags, source, frames)
        end
        if not entity.Parent then
            entity:Remove()
        end
    end
end, mod.EntityInf[mod.Entity.AshTwin].ID)


function mod:ClearErrantFlagsOnNewStage()
	if mod.savedatarun().errantAlive then
		mod.ModFlags.ErrantRoomSpawned = true
    else
		mod.ModFlags.ErrantRoomSpawned = false
		mod.savedatarun().errantHP = 1
	end

    mod.savedatarun().errantKilled = false
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ClearErrantFlagsOnNewStage)

--OTHERS-------------------------------------
--Mini Errants
function mod:MiniErrantsUpdate(entity)
	local data = entity:GetData()
	local sprite = entity:GetSprite()

	if entity.Variant == mod.EntityInf[mod.Entity.Attlerock].VAR and entity.SubType == mod.EntityInf[mod.Entity.Attlerock].SUB then
        mod:OrbitParent(entity)
		if not entity.Parent then
			entity.Velocity = entity.Velocity:Normalized()*mod.QConst.ATTLEROCK_SPEED

			if entity:CollidesWithGrid() then
				
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1)

				game:ShakeScreen(10)
				game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 6, 3)
			end
		end
	elseif entity.Variant == mod.EntityInf[mod.Entity.WhiteHole].VAR and entity.SubType == mod.EntityInf[mod.Entity.WhiteHole].SUB then

		if not data.Init then
			data.Init = true
			data.Queue = 0
		end

		if entity.Parent then
			local direction = entity.Parent.Position - game:GetRoom():GetCenterPos()
			entity.Position = game:GetRoom():GetCenterPos() - direction
		else
			entity:Remove()
		end

		if sprite:IsEventTriggered("Attack") then

			for i=1, data.Queue do
				local angle = rng:RandomFloat()*360
				local velocity = 5 + rng:RandomFloat()*10

				local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, Vector(1,0):Rotated(angle)*velocity, entity):ToProjectile()
				rock:GetSprite().Color = mod.Colors.hot
				rock:GetData().NoAbsorb = true
				mod:TearFallAfter(rock, 15)
			end
			data.Queue = 0

		elseif sprite:IsFinished("Attack") then
			sprite:Play("Idle", true)
		end

		
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			local dist = player.Position:Distance(entity.Position)
			if dist < 75 then
				local direction = (player.Position - entity.Position)
				player.Velocity = player.Velocity + direction:Length()/75 * direction:Normalized()
			end
		end
		
		for _, t in ipairs(mod.QProjectiles) do
			if t then
				local dist = t.Position:Distance(entity.Position)
				if not t:GetData().NoAbsorb and dist < 100 then
					local direction = (t.Position - entity.Position)
					t.Velocity = t.Velocity + direction:Length()/100 * direction:Normalized()*2
				end
			end
		end
		for _, t in ipairs(mod.QTears) do
			if t then
				local dist = t.Position:Distance(entity.Position)
				if dist < 100 then
					local direction = (t.Position - entity.Position)
					t.Velocity = t.Velocity + direction:Length()/100 * direction:Normalized()*2
				end
			end
		end

	elseif entity.Variant == mod.EntityInf[mod.Entity.HollowsLantern].VAR and entity.SubType == mod.EntityInf[mod.Entity.HollowsLantern].SUB then
        mod:OrbitParent(entity)
		if sprite:IsFinished("Idle") then
			sprite:Play("Attack", true)
		elseif sprite:IsFinished("Attack") then
				sprite:Play("Idle", true)

		elseif sprite:IsEventTriggered("Attack") then
			sfx:Play(Isaac.GetSoundIdByName("HollowMeteor"),2)

			local n = mod:RandomInt(2,5)
			for i=1, n do
				local angle = rng:RandomFloat()*360
				local velocity = 1 + rng:RandomFloat()*2
	
				local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, Vector(1,0):Rotated(angle)*velocity, entity):ToProjectile()
				rock:GetSprite().Color = mod.Colors.hot
				mod:TearFallAfter(rock, 300)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MiniErrantsUpdate, mod.EntityInf[mod.Entity.Errant].ID)

--Brable Seed
function mod:BrambleSeedUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.BrambleSeed].VAR then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
    
        if not data.Init then
            data.Init = true
            entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
        end
        if data.Stop then
            entity.Velocity = Vector.Zero
        end
    
        if sprite:IsFinished("Appear") then
            data.Stop = true
            sprite:Play("Spikes", true)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            sprite.Rotation = 360*rng:RandomFloat()
        elseif sprite:IsFinished("Spikes") then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Death", true)
        elseif sprite:IsFinished("Death") then
            entity:Remove()
            
        elseif sprite:IsEventTriggered("Attack") then
            local offset = sprite.Rotation
            for i=1, 5 do
                local angle = offset + i*360/5
                local velocity = Vector(40,0):Rotated(angle)
                
                --Better vanilla monsters was of help here
                local worm = mod:SpawnEntity(mod.Entity.MiniBranbleSeed, entity.Position, velocity, entity)
                worm.Parent = entity
                worm.DepthOffset = entity.DepthOffset - 50
                worm.Mass = 0
                worm:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_DEATH_TRIGGER)
                worm:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                worm.MaxHitPoints = 0
    
                local cord = mod:SpawnEntity(mod.Entity.BrambleCord, entity.Position, Vector.Zero, entity)
                cord.Parent = worm
                cord.Target = entity
                cord.DepthOffset = worm.DepthOffset - 125
                data.Tonguecord = cord
                cord:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_BLOOD_SPLASH)
    
            end
        else
    
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.BrambleSeedUpdate, mod.EntityInf[mod.Entity.Errant].ID)

--Brable Spike
function mod:BrambleSpikeUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.BrambleSpike].VAR then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
    
        if not data.PosX then
            data.PosX = entity.Position.X 
            data.PosY = entity.Position.Y
        end
    
        if math.abs(entity.Position.Y - data.PosY) > 175 then
            data.Stop = true
        end
        if data.Stop then
            entity.Velocity = Vector.Zero
        else
            entity.Velocity = Vector(0, entity.Velocity.Y)
            entity.Position = Vector(data.PosX, entity.Position.Y)
        end
    
        if not data.Init then
            data.Init = true
            entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    
            sprite:Play("Idle"..tostring(mod:RandomInt(1,3)))
        end
    
        if sprite:IsFinished("Idle1") or sprite:IsFinished("Idle2") or sprite:IsFinished("Idle3") then
            entity:Remove()
            
        elseif sprite:IsEventTriggered("Ready") then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    
        elseif sprite:IsEventTriggered("Push") then
            local direction = 1
            if sprite.FlipY then
                direction = -1
            end
            entity.Velocity = Vector(0, direction * 40)
    
        elseif sprite:IsEventTriggered("End") then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.BrambleSpikeUpdate, mod.EntityInf[mod.Entity.Errant].ID)

--Electric Glow
function mod:ElectricGlowUpdate(entity)
	local data = entity:GetData()
	if data.IsActive_HC and entity.Timeout == mod.QConst.ELECTRICITY_TIMEOUT/2 then
		local position = entity.Position + data.Direction * mod.QConst.ELECTRICITY_DIST
		data.NextPosition = position
		if not mod:IsOutsideRoom(position, game:GetRoom()) then
			local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, position, Vector.Zero, entity):ToEffect()
            glow:GetSprite().Color = mod.Colors.red
            glow.Parent = entity.Parent
            glow.Timeout = mod.QConst.ELECTRICITY_TIMEOUT
			glow.SpriteScale = Vector.One*0.5

            local glowData = glow:GetData()
            glowData.Direction = data.Direction:Rotated(mod.QConst.ELECTRICITY_ANGLE * (2 * rng:RandomFloat() - 1))
            glowData.IsActive_HC = true
            glowData.HeavensCall = true

		end
	elseif data.IsActive_HC and entity.Timeout == 1 and data.NextPosition then
		data.IsActive_HC = false
		--Laser
		local angle = (data.NextPosition - entity.Position):GetAngleDegrees()
		local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, entity.Position, angle, 10, Vector.Zero, entity.Parent)
		laser:SetMaxDistance((data.NextPosition - entity.Position):Length())
		laser.DisableFollowParent = true
		laser:GetSprite().Color = mod.Colors.jupiterLaser2
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ElectricGlowUpdate, EffectVariant.GROUND_GLOW)

--SandPillar
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, entity)
	if entity.SpawnerEntity and entity.SpawnerEntity.Type == mod.EntityInf[mod.Entity.AshTwin].ID then
		entity:SetColor(mod.Colors.sand, 9999, 99, true, true)
	end
end, EffectVariant.CREEP_SLIPPERY_BROWN)