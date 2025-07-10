local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

mod.TheiaStates = {
    IDLE = 1,
    AIM = 2,
    ATTACK = 3,
    PLAYERATTACK = 4,
}

mod.TheiaConsts = {
    MAX_DIST = 150,
    MAX_TENSE_DIST = 300,
    CHARGE_SPEED = 20,
    MAX_TARGET_DIST = 300,
    ATTACK_CHANCE = 0.5,
    BETRAY_CHANCE = 0.02,
    CHAIN_L = 6,

    --runes
    HAGALAZ_CHANCE = 0.5,
    JERA_CHANCE = 0.5,
    EHWAZ_CHANCE = 0.25,
    DAGAZ_CHANCE = 0.5,
    ANSUZ_CHANCE = 1,
    PERTHRO_CHANCE = 1,
    BERKANO_CHANCE = 1,
    ALGIZ_CHANCE = 1,

    GEBO_CHANCE = 0.05,
    KENAZ_CHANCE = 1,
    FEHU_CHANCE = 0.15,
    OTHALA_CHANCE = 0.15,
    INGWAZ_CHANCE = 0.5,
    SOWILO_CHANCE = 0.3,

    --stars
    BETELGEUSE_CHANCE = 0.5,
    SIRIUS_CHANCE = 1/12,
    ALPHAC_CHANCE = 1,

    --[[
    hagalazChance = 1,
    jeraChance = 1,
    ehwazChance = 1,
    dagazChance = 1,
    ansuzChance = 1,
    perthroChance = 1,
    berkanoChance = 1,
    algizChance = 1,
    
    geboChance = 1,
    kenazChance = 1,
    fehuChance = 1,
    othalaChance = 1,
    ingwazChance = 1,
    sowiloChance = 1,
    ]]--
}

function mod:TheiaInit(familiar)
    if familiar.SubType == 0 then
        local player = familiar.Player
        local data = familiar:GetData()

        if player then

            data.StateFrame = 0
            data.State = mod.TheiaStates.IDLE
            data.Suffix = "Front"
            data.Color = "normal"
            data.ChainOffset = Vector.Zero

            local parent = familiar
            for i=1, mod.TheiaConsts.CHAIN_L do
                local position = familiar.Position + (player.Position - familiar.Position)*i/mod.TheiaConsts.CHAIN_L

                local chain = mod:SpawnEntity(mod.Entity.TwinChain, familiar.Position, Vector.Zero, familiar):ToNPC()
                chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                chain:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_DONT_OVERWRITE | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_NO_KNOCKBACK)
                chain:GetSprite():Play("Theia", true)
                chain.CollisionDamage = 0
                chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                parent.Child = chain
                chain.Parent = parent
                chain.I1 = i
                chain.DepthOffset = -15
                
                parent = chain
            end
            
            parent.Child = player
        else
            familiar:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.TheiaInit, mod.EntityInf[mod.Entity.Theia].VAR)

function mod:TheiaUpdate(familiar)
    if familiar.SubType == 0 then
        local player = familiar.Player
        local data = familiar:GetData()
        local sprite = familiar:GetSprite()
        local room = game:GetRoom()

        data.StateFrame = data.StateFrame + 1

        mod.TheiaFunctions[data.State](nil, familiar, player, data, sprite, room)
        mod:TheiaMove(familiar, player, data, sprite, room)

        if not data.IsJumping then
            familiar.Velocity = familiar.Velocity * 0.75
        end

        familiar.Position = room:GetClampedPosition(familiar.Position, 15)

        local index = room:GetGridIndex(familiar.Position)
        if index then room:DestroyGrid(index, false) end
        
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.TheiaUpdate, mod.EntityInf[mod.Entity.Theia].VAR)



function mod:TheiaIdle(familiar, player, data, sprite, room)
    if data.StateFrame == 1 then
        sprite:Play("Idle"..data.Suffix, true)
        data.ToPlayer = false

    elseif sprite:IsFinished() then--and string.sub(sprite:GetAnimation(), 1, 4) == "Idle" then
        data.StateFrame = 0
        if (rng:RandomFloat() < mod.TheiaConsts.ATTACK_CHANCE) and mod:GetTargetEnemy(familiar, mod.TheiaConsts.MAX_TARGET_DIST) then
            data.State = mod.TheiaStates.AIM
        else
            data.State = mod.TheiaStates.IDLE
        end

    end
end
function mod:TheiaAim(familiar, player, data, sprite, room)
    if data.StateFrame == 1 then
        sprite:Play("Aim"..data.Suffix, true)
        data.TargetPosition = nil

    elseif sprite:IsFinished() then--and string.sub(sprite:GetAnimation(), 1, 3) == "Aim" then
        data.StateFrame = 0
        if data.TargetPosition then
            if data.ToPlayer then
                data.State = mod.TheiaStates.PLAYERATTACK
            else
                data.State = mod.TheiaStates.ATTACK
            end
        else
            data.State = mod.TheiaStates.IDLE
        end

    elseif sprite:IsEventTriggered("Aim") then
        data.TargetPosition = nil
        if rng:RandomFloat() < mod.TheiaConsts.BETRAY_CHANCE then
            data.TargetPosition = familiar.Player.Position
            familiar:SetColor(Color(1,0.25,0.25,1,1,0,0), 10, 1, true, false)
            data.ToPlayer = true
            sfx:Play(SoundEffect.SOUND_DEATH_GROWL, 1, 2, false, 1)
        else
            local victim = mod:GetTargetEnemy(familiar, mod.TheiaConsts.MAX_TARGET_DIST)
            data.TargetPosition = victim and victim.Position or nil
        end

    elseif sprite:IsEventTriggered("Bark") then
        sfx:Play(Isaac.GetSoundIdByName("chainChomp"), 0.75)
    end
end
function mod:TheiaAttack(familiar, player, data, sprite, room)

    if data.StateFrame == 1 then
        sprite:Play("Attack"..data.Suffix, true)

    elseif sprite:IsFinished() and string.sub(sprite:GetAnimation(), 1, 6) == "Attack" then
        data.StateFrame = 0
        data.State = mod.TheiaStates.IDLE
        data.Hostile = false

    elseif sprite:IsEventTriggered("Jump") then
        local victim = (not data.ToPlayer) and mod:GetTargetEnemy(familiar, mod.TheiaConsts.MAX_TARGET_DIST)
        local targetPos = victim and victim.Position or data.TargetPosition

        local direction = targetPos - familiar.Position

        direction = direction:Normalized()
        familiar.Velocity = direction*mod.TheiaConsts.CHARGE_SPEED
        
        data.IsJumping = true
        sfx:Play(SoundEffect.SOUND_RECALL, 1.5)

    elseif sprite:IsEventTriggered("Land") then
        familiar.Velocity = Vector.Zero
        
        data.IsJumping = false

    end
end
function mod:TheiaPlayerAttack(familiar, player, data, sprite, room)
    mod:TheiaAttack(familiar, player, data, sprite, room)
    if sprite:IsEventTriggered("Jump") then
        data.Hostile = true
    elseif sprite:IsEventTriggered("Land") then
        data.Hostile = false

    elseif data.Hostile and familiar.Position:Distance(player.Position) < familiar.Size then
        player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CRUSH, EntityRef(familiar), 0)
    end
end

function mod:TheiaMove(familiar, player, data, sprite, room)
    local direction = familiar.Position - player.Position
    local distance = direction:Length()
    if distance > mod.TheiaConsts.MAX_DIST then
        if data.IsJumping then
            player.Velocity = mod:Lerp(player.Velocity, direction, 0.005)
            if distance > mod.TheiaConsts.MAX_TARGET_DIST then
                familiar.Velocity = Vector.Zero
            end
        else
            familiar.Velocity = mod:Lerp(familiar.Velocity, -direction, 0.015)

            mod:TheiaCorrectLook(familiar, -familiar.Velocity, data, sprite)
        end

    elseif data.State == mod.TheiaStates.AIM and data.TargetPosition then
        local direction = data.TargetPosition - familiar.Position
        mod:TheiaCorrectLook(familiar, direction, data, sprite)
    elseif data.IsJumping then
        mod:TheiaCorrectLook(familiar, familiar.Velocity, data, sprite)
    end
end

mod.TheiaDirectionSuffix = {
    [0] = "Right",
    [90] = "Front",
    [180] = "Left",
    [-180] = "Left",
    [-90] = "Back",
}

mod.TheiaStateNameLen = {
    [mod.TheiaStates.IDLE] = 4,
    [mod.TheiaStates.AIM] = 3,
    [mod.TheiaStates.ATTACK] = 6,
    [mod.TheiaStates.PLAYERATTACK] = 6,
}

function mod:TheiaCorrectLook(familiar, vector, data, sprite)
    local angle = vector:GetAngleDegrees()
    angle = mod:Takeclosest({0,90,180,-90,-180}, angle)

    data.Suffix = mod.TheiaDirectionSuffix[angle]
    data.ChainOffset = Vector(-30,0):Rotated(angle)
    data.ChainOffset.Y = 0

    local animation = sprite:GetAnimation()
    if string.sub(animation, mod.TheiaStateNameLen[data.State], #animation) ~= data.Suffix then
        local frame = sprite:GetFrame()
        sprite:Play(string.sub(animation, 1, mod.TheiaStateNameLen[data.State])..data.Suffix, true)
        sprite:SetFrame(frame)
    end
end

mod.TheiaFunctions = {
    [mod.TheiaStates.IDLE] = mod.TheiaIdle,
    [mod.TheiaStates.AIM] = mod.TheiaAim,
    [mod.TheiaStates.ATTACK] = mod.TheiaAttack,
    [mod.TheiaStates.PLAYERATTACK] = mod.TheiaPlayerAttack,
}

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.FamiliarProtection, mod.EntityInf[mod.Entity.Theia].VAR)

function mod:ChainNewRoom()
    for _, chain in ipairs(mod:FindByTypeMod(mod.Entity.TwinChain)) do
        chain.Position = Isaac.GetPlayer(0).Position
        chain.Velocity = Vector.Zero
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ChainNewRoom)

function mod:UpdateTheia()
    for i, theia in ipairs(mod:FindByTypeMod(mod.Entity.Theia)) do
        theia = theia:ToFamiliar()
        local data = theia:GetData()
        local sprite = theia:GetSprite()
        local player = theia.Player

        if mod:PlayerHasMeteor(player) then
            if data.Color ~= "meteor" then
                data.Color = "meteor"
                sprite:ReplaceSpritesheet(0, "hc/gfx/familiar/theia_meteor.png", true)
            end
        elseif mod:PlayerHasStar(player) then
            if data.Color ~= "star" then
                data.Color = "star"
                sprite:ReplaceSpritesheet(0, "hc/gfx/familiar/theia_star.png", true)
            end
        elseif mod:PlayerHasRune(player) then
            if data.Color ~= "rune" then
                data.Color = "rune"
                sprite:ReplaceSpritesheet(0, "hc/gfx/familiar/theia_rune.png", true)
            end
        elseif data.Color ~= "normal" then
            data.Color = "normal"
            sprite:ReplaceSpritesheet(0, "hc/gfx/familiar/theia.png", true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.UpdateTheia)
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.UpdateTheia)

function mod:OnRuneCollision(pickup, collider, low)
    local itemConfig = Isaac:GetItemConfig():GetCard(pickup.SubType)
    if itemConfig and itemConfig:IsRune() and collider and collider:ToPlayer() and collider:ToPlayer():HasCollectible(mod.SolarItems.Theia) then
        mod:UpdateTheia()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.OnRuneCollision, PickupVariant.PICKUP_TAROTCARD)



function mod:OnTheiaDomesticAbuse(entity, source)
    if source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == mod.EntityInf[mod.Entity.Theia].VAR and source.SubType == mod.EntityInf[mod.Entity.Theia].SUB then
        mod:OnTheiaKill(source:ToFamiliar(), nil, entity)
    end
end
mod:AddSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.OnTheiaDomesticAbuse)


function mod:OnTheiaKill(familiar, forcedCard, entity)
    forcedCard = forcedCard or -1
    local player = familiar.Player

    if forcedCard == -1 and mod:PlayerHasCard(player, Card.RUNE_BLANK) then
        if AntibirthRunes then
            if rng:RandomInt(1,8+6) > 8 then
                return mod:OnTheiaKill(familiar, mod:RandomInt(Isaac.GetCardIdByName("Gebo"), Isaac.GetCardIdByName("Ingwaz")), entity)
            end
        end
        return mod:OnTheiaKill(familiar, mod:RandomInt(Card.RUNE_HAGALAZ, Card.RUNE_ALGIZ), entity)
    end

    if (forcedCard == Card.RUNE_HAGALAZ or mod:PlayerHasCard(player, Card.RUNE_HAGALAZ)) and (rng:RandomFloat() < mod.TheiaConsts.HAGALAZ_CHANCE) then
		--Explosion:
		local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, familiar.Position, Vector.Zero, familiar):ToEffect()

		--Explosion damage
		for i, entity in ipairs(Isaac.FindInRadius(familiar.Position, 50)) do
			if mod:IsHostileEnemy(entity) then
				entity:TakeDamage(15, DamageFlag.DAMAGE_EXPLOSION, EntityRef(familiar), 0)
			end
		end

    elseif (forcedCard == Card.RUNE_JERA or mod:PlayerHasCard(player, Card.RUNE_JERA)) and (rng:RandomFloat() < mod.TheiaConsts.JERA_CHANCE) or (forcedCard == mod.Meteors.JERA or mod:PlayerHasCard(player, mod.Meteors.JERA)) and (rng:RandomFloat() < mod.TheiaConsts.JERA_CHANCE*2) then
        --Dupe
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D1, false, false, true, false, -1)

    elseif (forcedCard == Card.RUNE_EHWAZ or mod:PlayerHasCard(player, Card.RUNE_EHWAZ)) and (rng:RandomFloat() < mod.TheiaConsts.EHWAZ_CHANCE) or (forcedCard == mod.Meteors.EHWAZ or mod:PlayerHasCard(player, mod.Meteors.EHWAZ)) and (rng:RandomFloat() < mod.TheiaConsts.EHWAZ_CHANCE*2) then
        local enemies = Isaac.GetRoomEntities()
        local victim = enemies[mod:RandomInt(1,#enemies)]
        if victim then
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, victim.Position, Vector.Zero, nil):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_HORN)
                tear.Visible = false
            end
        end

    elseif (forcedCard == Card.RUNE_DAGAZ or mod:PlayerHasCard(player, Card.RUNE_DAGAZ)) and (rng:RandomFloat() < mod.TheiaConsts.DAGAZ_CHANCE) or (forcedCard == mod.Meteors.DAGAZ or mod:PlayerHasCard(player, mod.Meteors.DAGAZ)) and (rng:RandomFloat() < mod.TheiaConsts.DAGAZ_CHANCE*2) then

        local chance = mod.TheiaConsts.DAGAZ_CHANCE
        if (forcedCard == mod.Meteors.DAGAZ or mod:PlayerHasCard(player, mod.Meteors.DAGAZ)) then chance = chance*2 end

        --Soul heart
        if rng:RandomFloat() < chance*0.3 then
            local velocity = mod:RandomVector() * 3
            local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, familiar.Position, velocity, nil)
        end
        --Remove curse
        if rng:RandomFloat() < chance*0.04 and not mod.ModFlags.IsApocalypseActive then
            Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE, 0, false)
            Isaac.GetPlayer(0):RemoveCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
        end

    elseif (forcedCard == Card.RUNE_ANSUZ or mod:PlayerHasCard(player, Card.RUNE_ANSUZ)) and (rng:RandomFloat() < mod.TheiaConsts.ANSUZ_CHANCE) or (forcedCard == mod.Meteors.ANSUZ or mod:PlayerHasCard(player, mod.Meteors.ANSUZ)) and (rng:RandomFloat() < mod.TheiaConsts.ANSUZ_CHANCE) then
        --Reveal
        local level = game:GetLevel()
        local n = 10
        if (forcedCard == mod.Meteors.ANSUZ or mod:PlayerHasCard(player, mod.Meteors.ANSUZ)) then n = n*2 end

        local random = mod:RandomInt(1,n)
        for i=1, random do
            local roomdesc = level:GetRoomByIdx(mod:RandomInt(0,13*13-1)) --Only roomdescriptors from level:GetRoomByIdx() are mutable
            if roomdesc then
                roomdesc.DisplayFlags = roomdesc.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
            end
        end
        level:UpdateVisibility()

    elseif (forcedCard == Card.RUNE_PERTHRO or mod:PlayerHasCard(player, Card.RUNE_PERTHRO)) and (rng:RandomFloat() < mod.TheiaConsts.PERTHRO_CHANCE) then
        --Reroll
        Isaac.GetPlayer(0):UseCard(Card.CARD_DICE_SHARD, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)

    elseif (forcedCard == Card.RUNE_BERKANO or mod:PlayerHasCard(player, Card.RUNE_BERKANO)) and (rng:RandomFloat() < mod.TheiaConsts.BERKANO_CHANCE) or (forcedCard == mod.Meteors.BERKANO or mod:PlayerHasCard(player, mod.Meteors.BERKANO)) and (rng:RandomFloat() < mod.TheiaConsts.BERKANO_CHANCE) then
        --Flies
        local total = mod:RandomInt(1,2)
        for i=1, total do
            local subtype = 0
            if (forcedCard == mod.Meteors.BERKANO or mod:PlayerHasCard(player, mod.Meteors.BERKANO)) then subtype = mod:RandomInt(LocustSubtypes.LOCUST_OF_WRATH, LocustSubtypes.LOCUST_OF_CONQUEST) end
            local pickup = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, subtype, familiar.Position, Vector.Zero, player)
        end

    elseif (forcedCard == Card.RUNE_ALGIZ or mod:PlayerHasCard(player, Card.RUNE_ALGIZ)) and (rng:RandomFloat() < mod.TheiaConsts.ALGIZ_CHANCE) then
        --shield
        player:SetMinDamageCooldown(60)

        player:SetColor(Color(1,1,1,1,1,1,1), 30, 1, true, false)

    elseif (forcedCard == mod.Meteors.HAGALAZ or mod:PlayerHasCard(player, mod.Meteors.HAGALAZ)) and (rng:RandomFloat() < mod.TheiaConsts.HAGALAZ_CHANCE) then
        --Explosion:
        local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, familiar.Position, Vector.Zero, familiar):ToEffect()

        --Explosion damage
        for i, entity in ipairs(Isaac.FindInRadius(familiar.Position, 100)) do
            if mod:IsHostileEnemy(entity) then
                entity:TakeDamage(15, DamageFlag.DAMAGE_EXPLOSION, EntityRef(familiar), 0)
            end
        end

    elseif (forcedCard == mod.Meteors.PERTHRO or mod:PlayerHasCard(player, mod.Meteors.PERTHRO)) and (rng:RandomFloat() < mod.TheiaConsts.PERTHRO_CHANCE) then
        --Reroll
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D20, false, false, true, false, -1)
        Isaac.GetPlayer(0):UseCard(Card.CARD_SOUL_ISAAC, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)

    elseif (forcedCard == mod.Meteors.ALGIZ or mod:PlayerHasCard(player, mod.Meteors.ALGIZ)) and (rng:RandomFloat() < mod.TheiaConsts.ALGIZ_CHANCE) then
        --shield
        player:SetMinDamageCooldown(120)

        player:SetColor(Color(1,1,1,1,1,1,1), 60, 1, true, false)

    end

    if AntibirthRunes then
        if (forcedCard == Isaac.GetCardIdByName("Gebo") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("Gebo"))) and (rng:RandomFloat() < mod.TheiaConsts.GEBO_CHANCE) or (forcedCard == mod.Meteors.GEBO or mod:PlayerHasCard(player, mod.Meteors.GEBO)) and (rng:RandomFloat() < mod.TheiaConsts.GEBO_CHANCE*2) then
            local playerKey = tostring(mod:PlayerId(player))
            mod.savedatarun().currentStatUps[playerKey] = mod.savedatarun().currentStatUps[playerKey] or {}
            mod.savedatarun().currentStatUps[playerKey].LUCK = mod.savedatarun().currentStatUps[playerKey].LUCK or 0
            mod.savedatarun().currentStatUps[playerKey].LUCK = mod.savedatarun().currentStatUps[playerKey].LUCK + 0.5

            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()

        elseif (forcedCard == Isaac.GetCardIdByName("Kenaz") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("Kenaz"))) and (rng:RandomFloat() < mod.TheiaConsts.KENAZ_CHANCE) or (forcedCard == mod.Meteors.KENAZ or mod:PlayerHasCard(player, mod.Meteors.KENAZ)) and (rng:RandomFloat() < mod.TheiaConsts.KENAZ_CHANCE) then
            local giganteMult = player:GetTrinketMultiplier(TrinketType.TRINKET_GIGANTE_BEAN) + 1
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, familiar.Position, Vector.Zero, player):ToEffect()
            if cloud then
                cloud.SpriteScale = cloud.SpriteScale*math.sqrt(giganteMult)
                if (forcedCard == mod.Meteors.KENAZ or mod:PlayerHasCard(player, mod.Meteors.KENAZ)) then cloud.SpriteScale = cloud.SpriteScale*1.5 end

                mod:scheduleForUpdate(function()--ok sure
                    if cloud then
                        cloud.Timeout = math.ceil(30*math.sqrt(giganteMult))
                        if (forcedCard == mod.Meteors.KENAZ or mod:PlayerHasCard(player, mod.Meteors.KENAZ)) then cloud.Timeout = math.ceil(60*math.sqrt(giganteMult)) end
                    end
                end,30)
            end

        elseif (forcedCard == Isaac.GetCardIdByName("Fehu") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("Fehu"))) and (rng:RandomFloat() < mod.TheiaConsts.FEHU_CHANCE) or (forcedCard == mod.Meteors.FEHU or mod:PlayerHasCard(player, mod.Meteors.FEHU)) and (rng:RandomFloat() < mod.TheiaConsts.FEHU_CHANCE*2) then
            local velocity = mod:RandomVector() * 3
            local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, familiar.Position, velocity, nil)

        elseif (forcedCard == Isaac.GetCardIdByName("Othala") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("Othala"))) and (rng:RandomFloat() < mod.TheiaConsts.OTHALA_CHANCE) or (forcedCard == mod.Meteors.OTHALA or mod:PlayerHasCard(player, mod.Meteors.OTHALA)) and (rng:RandomFloat() < mod.TheiaConsts.OTHALA_CHANCE*2) then
            player:AddWisp(1, player.Position)

        elseif (forcedCard == Isaac.GetCardIdByName("Ingwaz") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("Ingwaz"))) and (rng:RandomFloat() < mod.TheiaConsts.INGWAZ_CHANCE) or (forcedCard == mod.Meteors.INGWAZ or mod:PlayerHasCard(player, mod.Meteors.INGWAZ)) and (rng:RandomFloat() < mod.TheiaConsts.INGWAZ_CHANCE) then
            local n = 1
            if (forcedCard == mod.Meteors.INGWAZ or mod:PlayerHasCard(player, mod.Meteors.INGWAZ)) then n=n+1 end

            for j=1, n do
                local entities = Isaac:GetRoomEntities()
                for i=1, #entities do
                    if entities[i]:ToPickup() then
                        local flag = false

                        flag = mod:OnHCIngwaz(nil, player, nil, true)
                        if not flag and ((entities[i].Variant >= 50 and 60 >= entities[i].Variant) or entities[i].Variant == PickupVariant.PICKUP_REDCHEST or entities[i].Variant == PickupVariant.PICKUP_MOMSCHEST) then
                            flag = entities[i]:ToPickup():TryOpenChest(player)
                        end
                        if not flag and RepentancePlusMod then
                            if entities[i].Variant == RepentancePlusMod.CustomPickups.FLESH_CHEST then
                                flag = RepentancePlusMod.openFleshChest(entities[i])
                            elseif entities[i].Variant == RepentancePlusMod.CustomPickups.SCARLET_CHEST then
                                flag = RepentancePlusMod.openScarletChest(entities[i])
                            elseif entities[i].Variant == RepentancePlusMod.CustomPickups.BLACK_CHEST then
                                flag = RepentancePlusMod.openBlackChest(entities[i])
                            end
                        end
                        if flag then break end
                    end
                end
            end
        elseif (forcedCard == Isaac.GetCardIdByName("Sowilo") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("Sowilo"))) and (rng:RandomFloat() < mod.TheiaConsts.SOWILO_CHANCE) or (forcedCard == mod.Meteors.SOWILO or mod:PlayerHasCard(player, mod.Meteors.SOWILO)) and (rng:RandomFloat() < mod.TheiaConsts.SOWILO_CHANCE*2) then
            local newEntity = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, Vector.Zero, nil):ToNPC()
            if newEntity then
                newEntity:MakeChampion(newEntity.InitSeed, -1, true)
            end
        end
    end

    if ANDROMEDA then
        if (forcedCard == Isaac.GetCardIdByName("betelgeuse") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("betelgeuse"))) and (rng:RandomFloat() < mod.TheiaConsts.BETELGEUSE_CHANCE) then
            --Explosion:
            local explode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, familiar.Position, Vector.Zero, familiar):ToEffect()

            --Explosion damage
            for i, entity in ipairs(Isaac.FindInRadius(familiar.Position, 100)) do
                if mod:IsHostileEnemy(entity) then
                    entity:TakeDamage(15, DamageFlag.DAMAGE_EXPLOSION, EntityRef(familiar), 0)
                end
            end

        elseif (forcedCard == Isaac.GetCardIdByName("sirius") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("sirius"))) and (rng:RandomFloat() < mod.TheiaConsts.SIRIUS_CHANCE) then
            local charges = player:GetActiveCharge()
            player:SetActiveCharge(charges + 1)

        elseif (forcedCard == Isaac.GetCardIdByName("alphacentauri") or mod:PlayerHasCard(player, Isaac.GetCardIdByName("alphacentauri"))) and (rng:RandomFloat() < mod.TheiaConsts.ALPHAC_CHANCE) then
            --player:AddWisp(1, player.Position)
            for i=1, mod:RandomInt(1,4) do
                mod:AndromedaSpodeTears(entity, player, entity.Position) 
            end
        end
    end
end

function mod:OnTheiaCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		--Theia
		local numItem = player:GetCollectibleNum(mod.SolarItems.Theia)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)

		player:CheckFamiliar(mod.EntityInf[mod.Entity.Theia].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Theia), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Theia))
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnTheiaCache)