local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

table.insert(mod.PostLoadInits, {"savedatarun", "wormHoleConsumed", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.wormHoleConsumed", {})

mod.WormholeConts = {
    idleTime = 10,
    pullForce = 5,
    pickupSpeed = 30,
}

mod.WormholeRedHearts = {
    [HeartSubType.HEART_FULL] = 1,
    [HeartSubType.HEART_HALF] = 0.5,
    [HeartSubType.HEART_DOUBLEPACK] = 2,
    [HeartSubType.HEART_SCARED] = 1,
    [HeartSubType.HEART_BLENDED] = 0.5,
}
mod.WormholeSoulHearts = {
    [HeartSubType.HEART_SOUL] = 1,
    [HeartSubType.HEART_HALF_SOUL] = 0.5,
    [HeartSubType.HEART_BLENDED] = 2,
}

mod.WormholeRewards = {
    REDHEART = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL},
    SOULHEART = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL},
    BLACKHEART = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL},
    ETERNALHEART = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK},
    BONEHEART = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN},
    ROTTENHEART = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE},
    
    GLASS = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityInf[mod.Entity.BlazeHeart].SUB},
    BLAZE = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityInf[mod.Entity.GlassHeart].SUB},
    
    KEY = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
    BOMB = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
    
    TRINKET = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0},
    COLLECTIBLE = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1},
    
    CARD = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0},
    
    BATTERY = {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK},
}

function mod:OnWormholeActiveUse(collectibleType, rng, player, flags, slot, customVarData)
    local wormhole = mod:SpawnEntity(mod.Entity.Wormhole, player.Position, Vector.Zero, player)
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnWormholeActiveUse, mod.SolarItems.Wormhole)

function mod:WormholeUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Wormhole].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if not data.Init then
            data.Init = true

            data.IdleCount = 0
            data.Swallows = 0

            entity.DepthOffset = -300

            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 2, false, 1)
            sfx:Play(SoundEffect.SOUND_SHOVEL_DIG, 0.67, 2, false, 2)
        end

        if sprite:IsFinished("Appear") then
            sprite:Play("Idle", true)
            sfx:Play(SoundEffect.SOUND_MOTHER_SUCTION, 0.25, 2, true, 2)
            mod:scheduleForUpdate(function()
                sfx:Stop(SoundEffect.SOUND_MOTHER_SUCTION)
            end, mod.WormholeConts.idleTime*10)

        elseif sprite:IsFinished("Idle") then
            data.IdleCount = data.IdleCount + 1
            if data.IdleCount >= mod.WormholeConts.idleTime then
                sfx:Stop(SoundEffect.SOUND_MOTHER_SUCTION)
                sfx:Play(SoundEffect.SOUND_FAT_GRUNT, 0.67, 2, false, 2)
                sprite:Play("Hide", true)
            else
                sprite:Play("Idle", true)

            end

        elseif sprite:IsFinished("Hide") then
            sfx:Play(SoundEffect.SOUND_SHOVEL_DIG, 0.67, 2, false, 2)
            sprite:Play("Puke", true)

        elseif sprite:IsFinished("Puke") then
            sprite:Play("Death", true)
            
        elseif sprite:IsFinished("Death") then
            entity:Remove()


        elseif sprite:IsPlaying("Idle") then
            mod:WormholeAbsorb(entity, data)

        elseif sprite:IsEventTriggered("Puke") then
            sfx:Play(SoundEffect.SOUND_LITTLE_SPIT, 1, 2, false, 1)
            mod:WormholePuke(entity)
        end

        if sprite:IsPlaying("Idle") then
            if rng:RandomFloat() < 0.1 then
                local trace = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOGMA_BLACKHOLE, 1, entity.Position, Vector.Zero, nil)
                trace.SpriteScale = trace.SpriteScale*0.5
                trace:GetSprite().Color = Color(1,1,1,0.15,1,1,1)
            end
            if rng:RandomFloat() < 0.1 then
                local trace = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOGMA_BLACKHOLE, 2, entity.Position, Vector.Zero, nil)
                trace.SpriteScale = trace.SpriteScale*0.5
                trace:GetSprite().Color = Color(1,1,1,0.15,1,1,1)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.WormholeUpdate, mod.EntityInf[mod.Entity.Wormhole].VAR)

function mod:WormholeAbsorb(wormhole, data)
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:ToPickup() or entity:ToBomb() then-- or entity:ToNPC() or entity:ToProjectile() then
            local direction = wormhole.Position - entity.Position
            local distance = direction:Length()/15 + 0.0001

            local force = mod.WormholeConts.pullForce / distance^2 * direction:Normalized()

            entity.Velocity = entity.Velocity + force*2

            if (not entity:GetData().Wormholed) then
                if distance < 1 then
                    mod:WormholeSwallow(wormhole, data, entity)
    
                elseif entity:ToPickup() and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType > 0 and distance < 10 then
                    mod.savedatarun().wormHoleConsumed.COLLECTIBLE = mod.savedatarun().wormHoleConsumed.COLLECTIBLE or 0
                    mod.savedatarun().wormHoleConsumed.COLLECTIBLE = mod.savedatarun().wormHoleConsumed.COLLECTIBLE + 1
                    entity:Remove()
                    entity:GetData().Wormholed = true
                end
            end
        elseif entity:ToProjectile() then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            entity.CollisionDamage = 0

            local direction = wormhole.Position - entity.Position
            local distance = direction:Length()/30 + 0.0001

            local force = mod.WormholeConts.pullForce / distance * direction:Normalized()

            entity.Velocity = entity.Velocity + force*5

            if distance < 3 then
                entity:Remove()
            end
        end
    end
end
function mod:WormholeSwallow(wormhole, data, entity)
    if entity:ToNPC() and data.Swallows < 3 then
        data.Swallows = data.Swallows + 1
        data.Health = data.Health or 0
        data.Health = data.Health + entity.MaxHitPoints
        entity:Die()

    elseif entity:ToBomb() then

        local pitch = 1

        if entity.Variant == BombVariant.BOMB_ROCKET_GIGA or entity.Variant == BombVariant.BOMB_GIGA then
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 10
            entity:Remove()
            entity:GetData().Wormholed = true

            sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)

        elseif entity.Variant == BombVariant.BOMB_GOLDENTROLL then
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 99
            entity:Remove()
            entity:GetData().Wormholed = true

            sfx:Play(SoundEffect.SOUND_GOLDENBOMB, 1, 2, false, pitch)

        elseif entity.Variant == BombVariant.BOMB_SUPERTROLL then
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 2
            entity:Remove()
            entity:GetData().Wormholed = true

            sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)

        else
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
            mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 1
            entity:Remove()
            entity:GetData().Wormholed = true

            sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)
            
        end

    elseif entity:ToPickup() then
        local pitch = 1

        if entity.Variant == PickupVariant.PICKUP_TRINKET then
            mod.savedatarun().wormHoleConsumed.TRINKET = mod.savedatarun().wormHoleConsumed.TRINKET or 0
            if entity.SubType & TrinketType.TRINKET_GOLDEN_FLAG > 0 then
                mod.savedatarun().wormHoleConsumed.TRINKET = mod.savedatarun().wormHoleConsumed.TRINKET + 4
            else
                mod.savedatarun().wormHoleConsumed.TRINKET = mod.savedatarun().wormHoleConsumed.TRINKET + 1
            end
            entity:Remove()
            entity:GetData().Wormholed = true

        elseif entity.Variant == PickupVariant.PICKUP_HEART then
            if mod.WormholeRedHearts[entity.SubType] then
                mod.savedatarun().wormHoleConsumed.REDHEART = mod.savedatarun().wormHoleConsumed.REDHEART or 0
                mod.savedatarun().wormHoleConsumed.REDHEART = mod.savedatarun().wormHoleConsumed.REDHEART + mod.WormholeRedHearts[entity.SubType]
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES, 1, 2, false, pitch)

            elseif mod.WormholeSoulHearts[entity.SubType] then
                mod.savedatarun().wormHoleConsumed.SOULHEART = mod.savedatarun().wormHoleConsumed.SOULHEART or 0
                mod.savedatarun().wormHoleConsumed.SOULHEART = mod.savedatarun().wormHoleConsumed.SOULHEART + mod.WormholeSoulHearts[entity.SubType]
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_HOLY, 1, 2, false, pitch)

            elseif entity.SubType == HeartSubType.HEART_ETERNAL then
                mod.savedatarun().wormHoleConsumed.ETERNALHEART = mod.savedatarun().wormHoleConsumed.ETERNALHEART or 0
                mod.savedatarun().wormHoleConsumed.ETERNALHEART = mod.savedatarun().wormHoleConsumed.ETERNALHEART + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_SUPERHOLY, 1, 2, false, pitch)

            elseif entity.SubType == HeartSubType.HEART_BLACK then
                mod.savedatarun().wormHoleConsumed.BLACKHEART = mod.savedatarun().wormHoleConsumed.BLACKHEART or 0
                mod.savedatarun().wormHoleConsumed.BLACKHEART = mod.savedatarun().wormHoleConsumed.BLACKHEART + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_UNHOLY, 1, 2, false, pitch)

            elseif entity.SubType == HeartSubType.HEART_BONE then
                mod.savedatarun().wormHoleConsumed.BONEHEART = mod.savedatarun().wormHoleConsumed.BONEHEART or 0
                mod.savedatarun().wormHoleConsumed.BONEHEART = mod.savedatarun().wormHoleConsumed.BONEHEART + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_BONE_HEART, 1, 2, false, pitch)

            elseif entity.SubType == HeartSubType.HEART_ROTTEN then
                mod.savedatarun().wormHoleConsumed.ROTTENHEART = mod.savedatarun().wormHoleConsumed.ROTTENHEART or 0
                mod.savedatarun().wormHoleConsumed.ROTTENHEART = mod.savedatarun().wormHoleConsumed.ROTTENHEART + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_ROTTEN_HEART, 1, 2, false, pitch)

            elseif entity.SubType == HeartSubType.HEART_GOLDEN then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 10
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_GOLD_HEART, 1, 2, false, pitch)

            elseif entity.SubType == mod.EntityVoidSub then
                mod.savedatarun().wormHoleConsumed.REDHEART = mod.savedatarun().wormHoleConsumed.REDHEART or 0
                mod.savedatarun().wormHoleConsumed.REDHEART = mod.savedatarun().wormHoleConsumed.REDHEART + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)

            elseif entity.SubType == mod.EntityInf[mod.Entity.GlassHeart].SUB then
                mod.savedatarun().wormHoleConsumed.GLASS = mod.savedatarun().wormHoleConsumed.GLASS or 0
                mod.savedatarun().wormHoleConsumed.GLASS = mod.savedatarun().wormHoleConsumed.GLASS + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_GLASS_BREAK, 1, 2, false, pitch)

            elseif entity.SubType == mod.EntityInf[mod.Entity.BlazeHeart].SUB then
                mod.savedatarun().wormHoleConsumed.BLAZE = mod.savedatarun().wormHoleConsumed.BLAZE or 0
                mod.savedatarun().wormHoleConsumed.BLAZE = mod.savedatarun().wormHoleConsumed.BLAZE + 2
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 2, false, pitch)

            end
        
        elseif entity.Variant == PickupVariant.PICKUP_BOMB then
            if entity.SubType == BombSubType.BOMB_NORMAL or entity.SubType == BombSubType.BOMB_DOUBLEPACK then
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + entity.SubType
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)

            elseif entity.SubType == BombSubType.BOMB_TROLL then
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)

            elseif entity.SubType == BombSubType.BOMB_SUPERTROLL then
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 2
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)

            elseif entity.SubType == BombSubType.BOMB_GIGA then
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 10
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 2, false, pitch)

            elseif entity.SubType == BombSubType.BOMB_GOLDEN or entity.SubType == BombSubType.BOMB_GOLDENTROLL then
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 99
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_GOLDENBOMB, 1, 2, false, pitch)

            elseif entity.SubType == mod.EntityVoidSub then
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB or 0
                mod.savedatarun().wormHoleConsumed.BOMB = mod.savedatarun().wormHoleConsumed.BOMB + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)

            end
        
        elseif entity.Variant == PickupVariant.PICKUP_KEY then
            if entity.SubType == KeySubType.KEY_NORMAL then
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY or 0
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 2, false, pitch)

            elseif entity.SubType == KeySubType.KEY_DOUBLEPACK or entity.SubType == KeySubType.KEY_CHARGED then
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY or 0
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY + 2
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 2, false, pitch)

            elseif entity.SubType == KeySubType.KEY_GOLDEN then
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY or 0
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY + 99
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 2, false, pitch)

            elseif entity.SubType == mod.EntityVoidSub then
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY or 0
                mod.savedatarun().wormHoleConsumed.KEY = mod.savedatarun().wormHoleConsumed.KEY + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)

            end

        elseif entity.Variant == PickupVariant.PICKUP_TAROTCARD then

            if entity.SubType == mod.VoidConsumables[1] then
                mod.savedatarun().wormHoleConsumed.CARD = mod.savedatarun().wormHoleConsumed.CARD or 0
                mod.savedatarun().wormHoleConsumed.CARD = mod.savedatarun().wormHoleConsumed.CARD + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)
                return
            elseif entity.SubType == mod.VoidConsumables[2] then
                mod.savedatarun().wormHoleConsumed.PILL = mod.savedatarun().wormHoleConsumed.PILL or 0
                mod.savedatarun().wormHoleConsumed.PILL = mod.savedatarun().wormHoleConsumed.PILL + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)
                return
            elseif entity.SubType == mod.VoidConsumables[3] then
                mod.savedatarun().wormHoleConsumed.RUNE = mod.savedatarun().wormHoleConsumed.RUNE or 0
                mod.savedatarun().wormHoleConsumed.RUNE = mod.savedatarun().wormHoleConsumed.RUNE + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)
                return
            end

            local itemConfig = Isaac:GetItemConfig():GetCard(entity.SubType)
            if itemConfig then
                local isCard = itemConfig:IsCard()
                local isRune = itemConfig:IsRune()

                if isCard then
                    mod.savedatarun().wormHoleConsumed.CARD = mod.savedatarun().wormHoleConsumed.CARD or 0
                    mod.savedatarun().wormHoleConsumed.CARD = mod.savedatarun().wormHoleConsumed.CARD + 1
                    entity:Remove()
                    entity:GetData().Wormholed = true

                    sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, pitch)

                elseif isRune then
                    local isSoul = Card.CARD_SOUL_ISAAC <= entity.SubType and entity.SubType <= Card.CARD_SOUL_JACOB
                    if isSoul then
                        mod.savedatarun().wormHoleConsumed.SOUL = mod.savedatarun().wormHoleConsumed.SOUL or 0
                        mod.savedatarun().wormHoleConsumed.SOUL = mod.savedatarun().wormHoleConsumed.SOUL + 1
                        entity:Remove()
                        entity:GetData().Wormholed = true

                        sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, pitch)
                    else
                        mod.savedatarun().wormHoleConsumed.RUNE = mod.savedatarun().wormHoleConsumed.RUNE or 0
                        mod.savedatarun().wormHoleConsumed.RUNE = mod.savedatarun().wormHoleConsumed.RUNE + 1
                        entity:Remove()
                        entity:GetData().Wormholed = true

                        sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, pitch)
                    end
                end
            end
            
        elseif entity.Variant == PickupVariant.PICKUP_PILL then
            mod.savedatarun().wormHoleConsumed.PILL = mod.savedatarun().wormHoleConsumed.PILL or 0

            local multiplier = ((entity.SubType == PillColor.PILL_GOLD) and 10) or 1
            if entity.SubType & PillColor.PILL_GIANT_FLAG > 0 then
                mod.savedatarun().wormHoleConsumed.PILL = mod.savedatarun().wormHoleConsumed.PILL + 4*multiplier
            else
                mod.savedatarun().wormHoleConsumed.PILL = mod.savedatarun().wormHoleConsumed.PILL + 1*multiplier
            end
            entity:Remove()
            entity:GetData().Wormholed = true

            sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, pitch)

        elseif entity.Variant == PickupVariant.PICKUP_COIN then
            if entity.SubType == CoinSubType.COIN_PENNY then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 1
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 2, false, pitch)

            elseif entity.SubType == CoinSubType.COIN_DOUBLEPACK then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 2
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 2, false, pitch)

            elseif entity.SubType == CoinSubType.COIN_NICKEL or entity.SubType == CoinSubType.COIN_STICKYNICKEL then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 5
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_NICKELPICKUP, 1, 2, false, pitch)

            elseif entity.SubType == CoinSubType.COIN_DIME then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 10
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_DIMEPICKUP, 1, 2, false, pitch)

            elseif entity.SubType == CoinSubType.COIN_LUCKYPENNY then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 10
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_LUCKYPICKUP, 1, 2, false, pitch)

            elseif entity.SubType == CoinSubType.COIN_GOLDEN then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 15
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 2, false, pitch)

            elseif entity.SubType == mod.EntityVoidSub then
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS or 0
                mod.savedatarun().wormHoleConsumed.COINS = mod.savedatarun().wormHoleConsumed.COINS + 49
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)
                

            end
        elseif entity.Variant == PickupVariant.PICKUP_LIL_BATTERY then
            if entity.SubType == mod.EntityVoidSub then
                mod.savedatarun().wormHoleConsumed.BATTERY = mod.savedatarun().wormHoleConsumed.BATTERY or 0
                mod.savedatarun().wormHoleConsumed.BATTERY = mod.savedatarun().wormHoleConsumed.BATTERY + 1000
                entity:Remove()
                entity:GetData().Wormholed = true

                sfx:Play(mod.SFX.VoidPickup, 1, 2, false, pitch)
            end
        end
    end
end

function mod:WormholePuke(entity)
    for key, value in pairs(mod.savedatarun().wormHoleConsumed) do
        local currentValue = value

        if key == "KEY" or key == "BOMB" then
            while currentValue >= 1000 do
                currentValue = currentValue - 1000
                local velocity = mod:RandomVector() * mod.WormholeConts.pickupSpeed

                local pickup = Isaac.Spawn(mod.WormholeRewards[key][1], mod.WormholeRewards[key][2], mod.EntityVoidSub, entity.Position, velocity, nil)
            end

            while currentValue >= 99 do
                currentValue = currentValue - 99
                local velocity = mod:RandomVector() * mod.WormholeConts.pickupSpeed

                local subType = ((key == "KEY") and BombSubType.BOMB_GOLDEN) or KeySubType.KEY_GOLDEN

                local pickup = Isaac.Spawn(mod.WormholeRewards[key][1], mod.WormholeRewards[key][2], subType, entity.Position, velocity, nil)
            end
        end

        if key == "COINS" then
            while currentValue >= 7 do
                currentValue = currentValue - 7
                local velocity = mod:RandomVector() * mod.WormholeConts.pickupSpeed
                
                local r = mod:RandomInt(1,4)
                local subtype = -1
                if r == 1 then
                    subtype = CoinSubType.COIN_NICKEL
                elseif r == 2 then
                    subtype = CoinSubType.COIN_DIME
                elseif r == 3 then
                    subtype = CoinSubType.COIN_LUCKYPENNY
                elseif r == 4 then
                    subtype = CoinSubType.COIN_GOLDEN
                end
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, subtype, entity.Position, velocity, nil)
            end

        else
            while currentValue >= 1000 do
                currentValue = currentValue - 1000
                local velocity = mod:RandomVector() * mod.WormholeConts.pickupSpeed

                if key == "PILL" then
                    local subtype = mod.VoidConsumables[3-mod:RandomInt(0,1)*2]
                    mod.lockVoidRerroll = true
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, subtype, entity.Position, velocity, nil)
                elseif key == "RUNE" then
                    local subtype = mod.VoidConsumables[mod:RandomInt(1,2)]
                    mod.lockVoidRerroll = true
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, subtype, entity.Position, velocity, nil)
                elseif key == "CARD" then
                    local subtype = mod.VoidConsumables[mod:RandomInt(2,3)]
                    mod.lockVoidRerroll = true
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, subtype, entity.Position, velocity, nil)
                elseif key == "REDHEART" then
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, mod.EntityVoidSub, entity.Position, velocity, nil)
                elseif key == "BATTERY" then
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityVoidSub, entity.Position, velocity, nil)
                end
            end

            while currentValue >= 2 do
                currentValue = currentValue - 2
                local velocity = mod:RandomVector() * mod.WormholeConts.pickupSpeed

                if not (key == "RUNE" or key == "SOUL" or key == "PILL") then
                    local position = (key == "COLLECTIBLE") and game:GetRoom():FindFreePickupSpawnPosition(entity.Position, 50) or entity.Position
                    local pickup = Isaac.Spawn(mod.WormholeRewards[key][1], mod.WormholeRewards[key][2], mod.WormholeRewards[key][3], position, velocity, nil)

                elseif key == "PILL" then
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod:GetRandomCard(), entity.Position, velocity, nil)
                elseif key == "RUNE" then
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod:GetRandomSoul(), entity.Position, velocity, nil)
                elseif key == "SOUL" then
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod:GetRandomRune(), entity.Position, velocity, nil)
                end
            end
        end
        
        mod.savedatarun().wormHoleConsumed[key] = currentValue

    end
end

function mod:GetRandomCard()
    local itemPool = game:GetItemPool()
    local card = itemPool:GetCard(rng:Next(), true, false, false)

    local counter = 0
    while (card == Card.CARD_CRACKED_KEY or card == Card.CARD_DICE_SHARD) and counter < 100 do
        counter = counter + 1
        card = itemPool:GetCard(rng:Next(), true, false, false)
    end

    return card

end
function mod:GetRandomRune()
    local itemPool = game:GetItemPool()
    local rune = itemPool:GetCard(rng:Next(), false, true, true)

    local counter = 0
    while Card.CARD_SOUL_ISAAC <= rune and rune <= Card.CARD_SOUL_JACOB and counter < 100 do
        counter = counter + 1
        rune = itemPool:GetCard(rng:Next(), false, true, true)
    end

    return rune

end
function mod:GetRandomSoul()
    return mod:RandomInt(Card.CARD_SOUL_ISAAC, Card.CARD_SOUL_JACOB)
end
