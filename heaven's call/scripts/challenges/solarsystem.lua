local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local music = MusicManager()

-- startingtrinkets="Faded Flag"

-- i dont kwon why the run initializas twice

mod.SolarPlayerId = Isaac.GetPlayerTypeByName("Sol (HC)")

function mod:OnSolarSystemStart()
    
end

function mod:SolarSystemChallengePool()
    local player = Isaac.GetPlayer(0)
    local newMoon = mod:ChooseMiniMoon(player)
    if newMoon == -1 then
        return CollectibleType.COLLECTIBLE_BREAKFAST
    end
    return newMoon
end

function mod:OnSolarMomsHeartInit(entity)
    if mod:IsChallenge(mod.Challenges.SolarSystem) then
        mod:scheduleForUpdate(function()
            entity:Die()
            mod:scheduleForUpdate(function()
                if #mod:FindByTypeMod(mod.Entity.Luna) == 0 then
                    local luna = mod:SpawnEntity(mod.Entity.Luna, entity.Position, Vector.Zero, nil)
                    luna:GetData().SlowSpawn = true
                
                    local customMusic = mod.Music.LUNA_INTRO
                    music:Crossfade (customMusic, 2)
                    music:Queue(mod.Music.LUNA)
                end
            end, 30)
        end, 30)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.OnSolarMomsHeartInit, EntityType.ENTITY_MOMS_HEART)

function mod:OnSolarSystemInit(isContinued)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.SolarPlayerRender)
    mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnSolarPlayerDamage)
    mod:RemoveCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, mod.SolarSystemChallengePool)
    if mod:IsChallenge(mod.Challenges.SolarSystem) then

        mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.SolarPlayerRender, 0)
        mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnSolarPlayerDamage, EntityType.ENTITY_PLAYER)
        mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, mod.SolarSystemChallengePool)

        if not isContinued then
            local player = Isaac.GetPlayer(0)
            local data = player:GetData()
            mod:scheduleForUpdate(function ()
                for i=1, 5 do
                    local newMoon = mod:ChooseMiniMoon(player)
                    if (mod:CountMiniMoons(player) < 5) and (newMoon > 0) then
                        player:AddCollectible(newMoon)
                    end
                end
            end,2)
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnSolarSystemInit)

function mod:SolarPlayerInit(player)
    if player:GetPlayerType() == mod.SolarPlayerId then
        local data = player:GetData()
            
        data.SolEyeDir = Vector.Zero
        data.SolPupilDir = Vector.Zero

        data.SolarSpriteEye = Sprite()
        data.SolarSpriteEye:Load("hc/gfx/effect_SolPlayer.anm2", true)
        data.SolarSpriteEye:Play("Eye", true)

        data.SolarSprite = Sprite()
        data.SolarSprite:Load("hc/gfx/effect_SolPlayer.anm2", true)
        data.SolarSprite:Play("Idle", true)
        
        --player:SetCanShoot(false)

    end
    
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.SolarPlayerInit, 0)

function mod:SolarPlayerRender(player,offset)
    if mod:IsChallenge(mod.Challenges.SolarSystem) then
        local data = player:GetData()
        if data.SolarSprite then
            local sprite = data.SolarSprite
            local spriteEye = data.SolarSpriteEye

            local position = player.Position
            local inputDir = player:GetShootingInput()
            if inputDir:Length() < 0.01 and player.Velocity:Length() > 2 then
                inputDir = player.Velocity:Normalized()
            end

            local eyePos = inputDir*10
            data.SolEyeDir = mod:Lerp(data.SolEyeDir, eyePos, 0.1)
            local pupilPos = inputDir*5
            data.SolPupilDir = mod:Lerp(data.SolEyeDir, pupilPos, 0.05)
            
            sprite:Render(Isaac.WorldToScreen(position))
            sprite:Update()

            spriteEye:RenderLayer(3, Isaac.WorldToScreen(position+data.SolEyeDir))
            spriteEye:RenderLayer(4, Isaac.WorldToScreen(position+data.SolEyeDir/2+data.SolPupilDir))

        end
    else
        mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.SolarPlayerRender)
    end 
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.SolarPlayerRender, 0)

function mod:OnSolarPlayerDamage(player, amount)
    player = player:ToPlayer()
    if player:GetPlayerType() == mod.SolarPlayerId then
        local total = 20
        for i=1, total do
            local velocity = mod:RandomVector(5,10)
            local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, player.Position, velocity, player):ToEffect()
            feather.Visible = false
            feather.SpriteOffset = Vector(0,-10)
            feather:GetData().FromPlayer = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnSolarPlayerDamage, EntityType.ENTITY_PLAYER)