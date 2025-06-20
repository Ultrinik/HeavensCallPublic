local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.SolarItemsVars.NotJupiterDelay = 5*30
mod.SolarItemsVars.NotJupiterJumptime = 5
mod.SolarItemsVars.NotJupiterChance = 1--0.2

function mod:OnPlayerNotJupiterUpdate(player)
	if player:HasCollectible(mod.SolarItems.Jupiter) then
		local data = player:GetData()

        if not data.JupiterCountdownHC then
            data.JupiterCountdownHC = 0
            player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_JUPITER), false)
        end
        data.JupiterCountdownHC = (data.JupiterCountdownHC - 0.5)

        if data.JupiterCountdownHC == 0 then
            sfx:Play(SoundEffect.SOUND_BALL_AND_CHAIN_HIT, 1, 2, false, 2)
            player:SetColor(mod.Colors.white, 15, 1, true, true)

            local v = Vector.Zero

            player.SpriteOffset = v
            for i, costume in ipairs(player:GetCostumeSpriteDescs()) do
                local sprite = costume:GetSprite()
                sprite.Offset = v
            end
        elseif data.JupiterCountdownHC < 0 then
            for action = ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTDOWN do
                if Input.IsActionTriggered(action, player.ControllerIndex) then
                    data.JupiterKeyPressHC = data.JupiterKeyPressHC or {}
                    local previousKey = data.JupiterKeyPressHC[1]
                    local previousTime = data.JupiterKeyPressHC[2]
        
                    if previousTime and previousKey == action and (player.FrameCount - previousTime) < 20 then
                        mod:CreateJupiterShockwave(player)
                    end
                    data.JupiterKeyPressHC = {action, player.FrameCount}
                end
            end
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerNotJupiterUpdate, 0)

function mod:CreateJupiterShockwave(player)
    local data = player:GetData()

    mod:MakePlayerJump(player, 40, mod.SolarItemsVars.NotJupiterJumptime, true, false)

    data.JupiterCountdownHC = mod.SolarItemsVars.NotJupiterDelay

    local delay = math.floor(mod.SolarItemsVars.NotJupiterJumptime)*2
    mod:scheduleForUpdate(function()
        local position = player.Position

        local giganteMult = player:GetTrinketMultiplier(TrinketType.TRINKET_GIGANTE_BEAN) + 1
        local chiliFlag = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER)

        local nJupiters = player:GetCollectibleNum(mod.SolarItems.Jupiter)

        data.JupiterCountdownHC = math.ceil(data.JupiterCountdownHC/nJupiters)

        local n = 6
        for i=1, n do
    
            local direction = Vector.FromAngle(i*360/n)*12
    
            local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, position + direction*5, Vector.Zero, player):ToEffect()
            fart.SpriteScale = Vector.One*math.sqrt(giganteMult)
    
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, position, direction, player):ToEffect()
            cloud.SpriteScale = Vector.One*math.sqrt(giganteMult)
            cloud.Timeout = math.ceil(mod.SolarItemsVars.NotJupiterDelay*math.sqrt(giganteMult))

            if chiliFlag then
                local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, position, direction/2, player):ToEffect()
                fire.SpriteScale = Vector.One*math.sqrt(giganteMult)
                fire.Timeout = math.ceil(mod.SolarItemsVars.NotJupiterDelay*giganteMult)
            end
        end
        sfx:Stop(SoundEffect.SOUND_FART)
        sfx:Play(SoundEffect.SOUND_FART, 1, 2, false, 0.5)
    
        game:MakeShockwave(position, -0.025, 0.07, 90)
    
        for i, entity in ipairs(Isaac.GetRoomEntities()) do
            if mod:IsHostileEnemy(entity) or entity:ToBomb() or entity:ToProjectile() or entity:ToPickup() then
                local direction = (entity.Position - player.Position)
                local magnitude = 1/(direction:Length())*(650+(entity:ToProjectile() and 2 or 0))*giganteMult
                entity:AddKnockback(EntityRef(player), magnitude*direction:Normalized(), 7, true)
            end
        end

        game:ShakeScreen(15)
        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS)
    end, delay)
    
end

function mod:OnNewRoomNotJupiter()
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player and player:HasCollectible(mod.SolarItems.Jupiter) then 
            player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_JUPITER), false)
		end
	end

    if true then--unlocked
        local room = game:GetRoom()
        if room:IsFirstVisit() then
            for i, _item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                local item = _item:ToPickup()
                if item and item.SubType == CollectibleType.COLLECTIBLE_JUPITER and rng:RandomFloat() < mod.SolarItemsVars.NotJupiterChance then
                    item:Morph(item.Type, item.Variant, mod.SolarItems.Jupiter)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomNotJupiter)