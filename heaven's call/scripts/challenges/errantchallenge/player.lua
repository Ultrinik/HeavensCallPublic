local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()


local playerMaxSpeed = 2

mod.EverchangerTrinkets = {
    unicorn = Isaac.GetTrinketIdByName("  My Little Unicorn  "),
    pyro = Isaac.GetTrinketIdByName("  Pyromaniac  "),
    apple = Isaac.GetTrinketIdByName("  The Apple  "),
    tech = Isaac.GetTrinketIdByName("  Technology  "),
    yuckheart = Isaac.GetTrinketIdByName("  Yuck Heart  "),
    sackhead = Isaac.GetTrinketIdByName("  Sack Head  "),
    icecube = Isaac.GetTrinketIdByName("  Ice Cube  "),
    darkmatter = Isaac.GetTrinketIdByName("  Dark Matter  "),
    certificate = Isaac.GetTrinketIdByName("  Death Certificate  "),
    pause = Isaac.GetTrinketIdByName("  Pause  "),
    pandorasbox = Isaac.GetTrinketIdByName("  Pandora's box  "),
    fish = Isaac.GetTrinketIdByName("  Fish  "),
    redkey = Isaac.GetTrinketIdByName("  Red key?  "),
    plunger = Isaac.GetTrinketIdByName("  Plunger  "),
    bible = Isaac.GetTrinketIdByName("  Bible  "),
    bluekey = TrinketType.TRINKET_STRANGE_KEY,

    guppy = Isaac.GetItemIdByName("CATCATCATCATCATCAT"),
}
local trinkets = mod.EverchangerTrinkets
local flags = mod.EverchangerFlags

mod.EverchangerItemCharges = {}

function mod:EverchangerPlayerUpdate(player)

    local sprite = player:GetSprite()
    local data = player:GetData()
    local room = game:GetRoom()

    local lightRange = 100

    if not flags.inBattle then
        player.FireDelay = 30
    end

    if flags.enabledZoom > 0 then
        player.MoveSpeed = 0.01
        if player.Velocity:Length() > playerMaxSpeed then
            player.Velocity = player.Velocity:Normalized()*playerMaxSpeed
        end
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
        local trinket1 = player:GetTrinket(0)
        mod:EverchangerTrinketUse(player, data, trinket1)
        local trinket2 = player:GetTrinket(1)
        mod:EverchangerTrinketUse(player, data, trinket2)
    end
    if Input.IsActionTriggered(ButtonAction.ACTION_MAP, player.ControllerIndex) then
        local position = player.Position + Vector(0, -60)
        local hud = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+10, position, Vector.Zero, player)
        hud:GetData().Full = true
    end

    if (sprite:GetFrame() == 10 or sprite:GetFrame() == 19) and not flags.SolRoom and not player.CanFly then
        sfx:Play(mod.SFX.WoodStep, 2)
    end

    if data.Rainbow and data.Rainbow > 0 then
        data.Rainbow = data.Rainbow - 1

        local rColor = mod:rainbowCycle(player.FrameCount*15)
        sprite.Color = Color(rColor[1], rColor[2], rColor[3])
        if data.Rainbow == 0 then
            sprite.Color = Color.Default
        end
    end

    --Safe spot
    data.IsHidden = false
    local idxPos = room:GetGridIndex(player.Position)
    for i, idx in ipairs(flags.safeIndexs) do
        if idx == idxPos then
            data.IsHidden = true
        end
    end


    if player:HasTrinket(trinkets.tech) then
        if mod.ShaderData.weatherFlags & mod.WeatherFlags.MARTIAN <= 0 then
            mod:EnableWeather(mod.WeatherFlags.MARTIAN)
        end

        mod.ShaderData.marsCharge = 1
        lightRange = 200

    else
        if mod.ShaderData.weatherFlags & mod.WeatherFlags.MARTIAN > 0 then
            mod:DisableWeather(mod.WeatherFlags.MARTIAN)
        end

        mod.ShaderData.marsCharge = 0
    end

    local r = lightRange + 3*math.sin( (flags.time or 0)/10 )
    local mr = 1
    if flags.firstRoom then mr = 2.5 end
    
    flags.position0 = {[0]=Isaac.GetPlayer(0).Position.X, [1]=Isaac.GetPlayer(0).Position.Y-15, [2]=r*mr}

    
    if player.FrameCount % 6 == 0 and player:HasTrinket(trinkets.redkey) then
        local flag = true
        local stains = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT)
        for _, s in ipairs(stains) do
            if s.Position:Distance(player.Position) < 20 then
                flag = false
                break
            end
        end
        if flag then
            local stain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, player.Position, Vector.Zero, player)
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_PAUSE) then
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_PAUSE)
        player:DropTrinket(player.Position, true)
        player:AddTrinket(trinkets.pause)
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LEMON_MISHAP) then
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_LEMON_MISHAP)
        player:DropTrinket(player.Position, true)
        player:AddTrinket(trinkets.plunger)
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_PURSE) then
        if not data.FirstUpdatePurse then
            data.FirstUpdatePurse = true
            for i, trinket in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
                if trinket.FrameCount < 2 then
                    trinket:Remove()
                end 
            end
        end
    end

    if player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS and game:GetLevel():GetCurrentRoomIndex() >= 0 then

        player:ChangePlayerType(PlayerType.PLAYER_ISAAC)
        mod:scheduleForUpdate(function()
            player:AddMaxHearts(6)
            player:AddHearts(6)
            player:AddSoulHearts(-24)
        end, 1)
        
        if flags.inBattle then
            --local corpse = Isaac.Spawn(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB, player.Position, Vector.Zero, nil)

            local idx = flags.lastRoom or game:GetLevel():GetStartingRoomIndex()
            table.insert(mod.furnitureQueue, {SUB = mod.furnitureData.CORPSE.SUB, IDX = idx, SLOT = nil})
        end

        mod:FinishEverchangerBattle(true, true)
        player.Position = room:GetCenterPos()

        flags.gameOverflag = true
    end
end

function mod:EverchangerTrinketUse(player, data, trinket)

    if mod.EverchangerItemCharges[trinket] == false then
        sfx:Play(SoundEffect.SOUND_BATTERYDISCHARGE)
        return
    end

    if trinket == trinkets.unicorn then
        --player:AnimateCollectible(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN, "UseItem")
        sfx:Play(mod.SFX.Crack)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN, true)

        local n = 3
        if flags.inWaterRoom then
            n = 30
        end
        for i=1, n do
            player:UseActiveItem(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN)
        end
        
        data.Rainbow = 6*30*4*2
        mod.EverchangerItemCharges[trinket] = false

    elseif trinket == trinkets.yuckheart then
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_YUCK_HEART, "UseItem")
        local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, player.Position, Vector.Zero, nil)
        fart.SpriteScale = Vector.One*0.67
        player:AddHearts(1)
        sfx:Play(SoundEffect.SOUND_VAMP_GULP)
        mod.EverchangerItemCharges[trinket] = false

    elseif trinket == trinkets.certificate then
        local dropPosition = player.Position

        local roomdata = game:GetLevel():GetCurrentRoomDesc().Data
        if roomdata and roomdata.Variant == 8534 then
            local circle = Isaac.FindByType(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB)[1]
            if circle then
                local circlePos = circle.Position
                local centerPos = game:GetRoom():GetCenterPos()
                local mirrorPos = Vector(circlePos.X, centerPos.Y - (circlePos.Y - centerPos.Y))

                if player.Position:Distance(mirrorPos) < circle:GetData().Dist then
                    dropPosition = circlePos
                    --table.insert(mod.furnitureQueue, {SUB = entity.SubType, IDX = door.TargetRoomIndex, SLOT = mod.oppslots[i]})
                    mod:scheduleForUpdate(function()
                        local corpse = Isaac.FindByType(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB)[1]
                        if corpse then
                            corpse.Position = circlePos
                        end
                    end, 3)
                end
            end
        end

        player:DropTrinket(dropPosition, true)
        player:TakeDamage(9999, 0, EntityRef(player), 0)

    elseif trinket == trinkets.pause then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, true)
        mod.EverchangerItemCharges[trinket] = false

    elseif trinket == trinkets.pandorasbox then
        sfx:Play(mod.SFX.LockedBox)

    elseif trinket == trinkets.bible then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BIBLE, true)
        mod.EverchangerItemCharges[trinket] = false

    end
end

function mod:EverchangerTrinketCollision(entity, player)
    --pandora
    local pandoraFlag = false
    if entity.SubType == mod.EverchangerTrinkets.pandorasbox then
        if player:HasTrinket(TrinketType.TRINKET_STRANGE_KEY) then
            pandoraFlag = true
        end
    elseif entity.SubType == TrinketType.TRINKET_STRANGE_KEY then
        if player:HasTrinket(mod.EverchangerTrinkets.pandorasbox) then
            pandoraFlag = true
        end
    end
    if pandoraFlag then
        local pyro = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.pyro, player.Position, RandomVector()*5, player)
        local unicorn = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.unicorn, player.Position, RandomVector()*5, player)

        mod:scheduleForUpdate(function()
            player:TryRemoveTrinket(TrinketType.TRINKET_STRANGE_KEY)
            player:TryRemoveTrinket(mod.EverchangerTrinkets.pandorasbox)
            for i, t in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
                if t.SubType == TrinketType.TRINKET_STRANGE_KEY or t.SubType == mod.EverchangerTrinkets.pandorasbox then
                    t:Remove()
                end
            end
        end, 1)
        sfx:Play(mod.SFX.ChainBreak, 20)
    end

end
function mod:EverchangerTrinketCollisionTunel(pickup, player)
    if player:ToPlayer() then
        mod:EverchangerTrinketCollision(pickup, player:ToPlayer())
    end
end

function mod:EverchangerPlayerDamage(player, amount, damageFlags, source, frames)
    player = player:ToPlayer()
    if player:HasTrinket(mod.EverchangerTrinkets.pyro) then
        if damageFlags & DamageFlag.DAMAGE_FIRE > 0 then
            return false
        elseif damageFlags & DamageFlag.DAMAGE_EXPLOSION > 0 then
            player:AddHearts(1)
            
			local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position + Vector(0,10), Vector.Zero, player)
			healHeart.DepthOffset = 200

            return false
        end
    end

    if flags.gameOverflag or flags.jumpscareFlag then
        return false
    end

    if amount > 0 then
        mod:scheduleForUpdate(function()
            local position = player.Position + Vector(0, -60)
            local hud = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+10, position, Vector.Zero, player)
        end, 1)
    end
end


function mod:EverchangerTrinketInit(entity)
    if not flags.inChallenge then
        local sub = entity.SubType
        if not (sub == TrinketType.TRINKET_STRANGE_KEY) then
            for k, trinket in pairs(mod.EverchangerTrinkets) do
                if (sub%32768) == trinket then
                    local golden = 0
                    if sub > TrinketType.TRINKET_GOLDEN_FLAG then golden = TrinketType.TRINKET_GOLDEN_FLAG end

                    local ntrinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, entity.Position, entity.Velocity, entity.SpawnerEntity):ToPickup()
                    ntrinket:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, ntrinket.SubType + golden, true, true)

                    entity:Remove()
                    break
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.EverchangerTrinketInit, PickupVariant.PICKUP_TRINKET)


--POPOPOPOP
mod.RainbowColors = {
    { color = Color(1,0.3,0.3,1), angle = 0 },     
    { color = Color(1,1,0.3,1), angle = 60 },    
    { color = Color(0.3,1,0.3,1), angle = 120 },    
    { color = Color(0.3,1,1,1), angle = 180 },   
    { color = Color(0.3,0.3,1,1), angle = 240 },   
    { color = Color(1,0.3,1,1), angle = 300 },   
}
function mod:rainbowCycle(time)
    local colors = mod.RainbowColors
    local period = 360

    -- Calculate the angle for the given time
    local normalizedTime = time % period
    local angle = normalizedTime

    -- Find the two closest colors based on the angle
    local color1, color2
    for i = 1, #colors do
        if colors[i].angle > angle then
            color2 = colors[i]
            color1 = colors[i - 1] or colors[#colors]
            break
        end
    end

    if color1 and color2 then
        -- Interpolate between the two closest colors
        local ratio = (angle - color1.angle) / (color2.angle - color1.angle)
        local r1, g1, b1 = color1.color.R, color1.color.G, color1.color.B
        local r2, g2, b2 = color2.color.R, color2.color.G, color2.color.B
    
        local r = r1 + ratio * (r2 - r1)
        local g = g1 + ratio * (g2 - g1)
        local b = b1 + ratio * (b2 - b1)
    
        return {r, g, b}
    end
    return {1,1,1}
end