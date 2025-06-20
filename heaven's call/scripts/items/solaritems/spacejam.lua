local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.TemporalStats = {}
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "TemporalStats", {})


---------------------------------------------------------------------------------------
--Temporal Stats-----------------------------------------------------------------------
---------------------------------------------------------------------------------------

mod.TemporalStatsTypes = {
    DAMAGE = 1,
    TEARS = 2,
    SPEED = 3,
    LUCK = 4,
    RANGE = 5,
    SHOTSPEED = 6,
}

mod.SpaceJamConsts = {
    TIMEOUT = 4,
    EXPLOSION_RADIUS = 50,
    SPAWN_CHANCE = 1/500,
    MELON_CHANCE = 1/1000,
}

function mod:AddTemporalStat(player, stat, time, value)

    mod.TemporalStats[mod:PlayerId(player)] = mod.TemporalStats[mod:PlayerId(player)] or {}
    local ogEntry = mod.TemporalStats[mod:PlayerId(player)][stat] or {TIME = 0, VALUE = 0, OGVALUE = 0}

    local entry = {}

    if stat == mod.TemporalStatsTypes.DAMAGE then
    elseif stat == mod.TemporalStatsTypes.TEARS then
    elseif stat == mod.TemporalStatsTypes.LUCK then
    elseif stat == mod.TemporalStatsTypes.SPEED then
        value = math.min(value, 2-player.MoveSpeed)
    end
    
    entry.VALUE = math.max(value, ogEntry.VALUE)
    entry.TIME = math.max(time, (time+ogEntry.TIME)/2)
    entry.OGVALUE = math.max(value, (value+ogEntry.OGVALUE)/2)

    mod.TemporalStats[mod:PlayerId(player)][stat] = entry
end

function mod:TemporalStatsUpdate(player)
    mod.TemporalStats[mod:PlayerId(player)] = mod.TemporalStats[mod:PlayerId(player)] or {}
    for stat=1, 6 do
        local entry = mod.TemporalStats[mod:PlayerId(player)][stat]

        if entry then
            local time = entry.TIME
            local value = entry.VALUE
            local ogValue = entry.OGVALUE
    
            local step = ogValue/(time*30)
    
            entry.VALUE = entry.VALUE - step

            if stat == mod.TemporalStatsTypes.DAMAGE then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            elseif stat == mod.TemporalStatsTypes.TEARS then
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            elseif stat == mod.TemporalStatsTypes.LUCK then
                player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            elseif stat == mod.TemporalStatsTypes.SPEED then
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            elseif stat == mod.TemporalStatsTypes.RANGE then
                player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            elseif stat == mod.TemporalStatsTypes.SHOTSPEED then
                player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
            end
    
            if entry.VALUE <= 0 then
                mod.TemporalStats[mod:PlayerId(player)][stat] = nil
                player:AddCacheFlags(CacheFlag.CACHE_ALL)
            end
            player:EvaluateItems()
            
        end
    end
end

function mod:TemporalStatsCache(player, cacheFlag)
    mod.TemporalStats[mod:PlayerId(player)] = mod.TemporalStats[mod:PlayerId(player)] or {}

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local entry = mod.TemporalStats[mod:PlayerId(player)][mod.TemporalStatsTypes.DAMAGE]
        if entry then
            player.Damage = player.Damage + entry.VALUE
        end

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local entry = mod.TemporalStats[mod:PlayerId(player)][mod.TemporalStatsTypes.TEARS]
        if entry then

            local tearsPerSecond = mod:toTearsPerSecond(player.MaxFireDelay)
            tearsPerSecond = tearsPerSecond + (entry.VALUE)
            tearsPerSecond = math.max(1.4, tearsPerSecond)

            player.MaxFireDelay = mod:toMaxFireDelay(tearsPerSecond)
        end

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        local entry = mod.TemporalStats[mod:PlayerId(player)][mod.TemporalStatsTypes.LUCK]
        if entry then
            player.Luck = player.Luck + entry.VALUE
        end

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        local entry = mod.TemporalStats[mod:PlayerId(player)][mod.TemporalStatsTypes.SPEED]
        if entry then
            player.MoveSpeed = player.MoveSpeed + entry.VALUE
        end

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        local entry = mod.TemporalStats[mod:PlayerId(player)][mod.TemporalStatsTypes.RANGE]
        if entry then
            player.TearRange = player.TearRange + entry.VALUE
        end

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        local entry = mod.TemporalStats[mod:PlayerId(player)][mod.TemporalStatsTypes.SHOTSPEED]
        if entry then
            player.ShotSpeed = player.ShotSpeed + entry.VALUE
        end

    end
end


---------------------------------------------------------------------------------------
--Item---------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
local chanceMultiplier = 1
function mod:OnSpaceJamUpdate(player)
	if player:HasCollectible(mod.SolarItems.SpaceJam) then
		local room = game:GetRoom()
		if not room:IsClear() then
            for i=1, player:GetCollectibleNum(mod.SolarItems.SpaceJam) do
                if rng:RandomFloat() < mod.SpaceJamConsts.SPAWN_CHANCE*chanceMultiplier then
                    local position = Isaac.GetFreeNearPosition(room:GetRandomPosition(0), 1000)

                    local subtype = mod:RandomInt(161,165)
                    --local subtype = mod:RandomInt(161,166)
                    if rng:RandomFloat() < mod.SpaceJamConsts.MELON_CHANCE then subtype = 166 end
                    --subtype = 166

                    local berry = mod:SpawnEntity(mod.Entity.Apple, position, Vector.Zero, player, nil, subtype)
                    berry:GetSprite():Play("Spawn")

                    chanceMultiplier = 1
                else
                    chanceMultiplier = chanceMultiplier*1.01
                end
            end
		end
	end
end

---------------------------------------------------------------------------------------
--Pickups------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

function mod:BerryInit(entity)
    if 161 <= entity.SubType and entity.SubType <= 166 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if sprite:IsPlaying("Idle") then
            entity:Remove()

        elseif sprite:IsPlaying("Spawn") then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        end

        if entity.SubType == 161 then--strawbeey
            data.Color = Color(1,1,1,1, 1,0.5,0.5)
        elseif entity.SubType == 162 then--blackberry
            data.Color = Color(0.15,0.15,1,1, -0.5,0,0)
        elseif entity.SubType == 163 then--bluberry
            data.Color = Color(0,0.5,1,1, 0,0,0.5)
        elseif entity.SubType == 164 then--raspberry
            data.Color = Color(1,1,1,1, 1,0,0)
        elseif entity.SubType == 165 then--goldenberry
            data.Color = Color(1,1,0,1, 1,1.5,0)
        elseif entity.SubType == 166 then--watermelon
            data.Color = Color(1,1,1,1, 2,0,0)

        end 
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.BerryInit, mod.EntityInf[mod.Entity.Apple].VAR)
 
function mod:BerryUpdate(entity)
    if 161 <= entity.SubType and entity.SubType <= 166 then
        local sprite = entity:GetSprite()
        local data = entity:GetData()

        if sprite:IsFinished("Spawn") then
            sprite:Play("Idle", true)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

            mod:BerryImpact(entity)

        elseif sprite:IsFinished("Idle") then
            data.Idles = (data.Idles and data.Idles+1) or 1
            if data.Idles < mod.SpaceJamConsts.TIMEOUT then
                sprite:Play("Idle", true)
            else
                sprite:Play("Despawn", true)
            end

        elseif sprite:IsFinished("Despawn") then
            entity:Remove()

        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.BerryUpdate, mod.EntityInf[mod.Entity.Apple].VAR)


function mod:BerryImpact(entity)
            
    local color = entity:GetData().Color or Color.Default

    local scale = (entity.SubType == 166 and 1) or 0.5

    --Explosion:
    local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
    explosion.DepthOffset = 10
    explosion.SpriteScale = Vector.One*scale
    explosion:GetSprite().Color = color

    local damage = 3.5
    local player = entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer()
    if player then
        damage = player.Damage * mod:toTearsPerSecond(player.MaxFireDelay)
    end
    damage = damage*(scale/0.5)

    --Explosion damage
    for i, e in ipairs(Isaac.FindInRadius(entity.Position, mod.SpaceJamConsts.EXPLOSION_RADIUS*(scale/0.5))) do
        if e.Type ~= EntityType.ENTITY_PLAYER then
            e:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION, EntityRef(entity), 0)
        end
    end
end


function mod:OnBerryCollision(entity, collider)
    if 161 <= entity.SubType and entity.SubType <= 166 then
		local player = collider:ToPlayer()
		local sprite = entity:GetSprite()

		if player and player:HasCollectible(mod.SolarItems.SpaceJam) then

			entity.Velocity = Vector.Zero
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE


            if true then
                sfx:Play(Isaac.GetSoundIdByName("Chomp"),1,0,false,0.7)
                
                local color = entity:GetData().Color or Color.Default

                local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, player)
                cloud.SpriteScale = Vector.One*0.5
                cloud:GetSprite().Color = color

                cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, player)
                cloud.SpriteScale = Vector.One*0.5
                cloud:GetSprite().Color = color

                cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, player)
                cloud.SpriteScale = Vector.One*0.5
                cloud:GetSprite().Color = color

                sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
            end


            if entity.SubType == 161 then--strawbeey
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.DAMAGE, 10, 4)
            elseif entity.SubType == 162 then--blackberry
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.SPEED, 20, 0.67)
            elseif entity.SubType == 163 then--bluberry
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.TEARS, 10, 1.2)
            elseif entity.SubType == 164 then--raspberry
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.RANGE, 15, 5)
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.SHOTSPEED, 15, 0.67)
            elseif entity.SubType == 165 then--goldenberry
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.LUCK, 10, 15)
            elseif entity.SubType == 166 then--watermelon
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.DAMAGE, 10, 6)
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.SPEED, 10, 1)
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.TEARS, 10, 1.8)
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.LUCK, 10, 22.5)
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.RANGE, 10, 7.5)
                mod:AddTemporalStat(player, mod.TemporalStatsTypes.SHOTSPEED, 10, 1)
                --player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false, false, true, false)
            end 

            entity:Remove()

			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnBerryCollision, mod.EntityInf[mod.Entity.Apple].VAR)

--CALLBACKS
function mod:AddSpacejamCallbacks()
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnSpaceJamUpdate)

	if mod:SomebodyHasItem(mod.SolarItems.SpaceJam) then
        mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnSpaceJamUpdate)
	end
end
mod:AddSpacejamCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddSpacejamCallbacks, mod.SolarItems.SpaceJam)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddSpacejamCallbacks)