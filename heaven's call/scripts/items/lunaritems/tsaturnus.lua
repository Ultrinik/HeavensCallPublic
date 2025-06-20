local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--SATURN
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@@@@@@@%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@%%%%%@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%&@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%&@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%&@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%%%%%%%@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%&@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.ItemsVars.timeStops = {}

mod.TsaturnusConsts = {
    MAX_CHARGES = 1350,
    TOTAL_SECONDS = 5,
}

mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.playerTimestuck", false)
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.playerTimestuckFlick", false)
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.timestuckRoomIdx", -1)
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.timestuckStartFrame", 0)
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.timestuckEndFrame", 0)


--ACTIVE----------------------------------------
function mod:OnSaturnusUse(collectibleType, rng, player, flags, slot)

    --Bethany
	if player:NeedsCharge(slot) then
        local maxCharges = mod.TsaturnusConsts.MAX_CHARGES
		mod:TolaterateBethanyCharge(player, slot, maxCharges, 0)
    end

    --Do nothing if effect is active
    if mod.ShaderData.playerTimestuck then return end

    --flags
    mod.ItemsVars.timeStops[player.ControllerIndex] = true
    mod:EnableWeather(mod.WeatherFlags.TIMESTUCK, 0)
    
    --Effects
    local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, player.Position + Vector(0,-10), Vector.Zero, player):ToEffect()
    timestuck:FollowParent(player)
    timestuck:GetSprite().PlaybackSpeed = 0.5
    timestuck:GetSprite().Scale = Vector.One*0.5
    timestuck.DepthOffset = -50
    timestuck:GetData().Timestop_inmune = 2

    sfx:Play(Isaac.GetSoundIdByName("TimeStop"), 2)

    --Chache
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    --inmune
    player:GetData().Timestop_inmune = 1

    --Freeze time
    local n = mod.TsaturnusConsts.TOTAL_SECONDS
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then n = n*2 end
    mod:StopTime(n*31)
    
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnSaturnusUse, mod.Items.Saturnus)

--UPDATES-------------------------------------------
function mod:OnSaturnusPlayerUpdate(player)
	if player:HasCollectible(mod.Items.Saturnus) then
		if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == 0 then
			mod:PocketizeItem(player, mod.Items.Saturnus)
		end
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnSaturnusPlayerUpdate, 0)

function mod:OnSaturnusUpdate(player)
    if player:HasCollectible(mod.Items.Saturnus) then
        mod:ItemGainCharge(player, mod.Items.Saturnus, 1)

        if mod.ShaderData.playerTimestuck then
            local n = game:GetFrameCount() - mod.ShaderData.timestuckStartFrame
            local m = mod.ShaderData.timestuckEndFrame - mod.ShaderData.timestuckStartFrame

            for i = 1, 7 do
                if n == m - i*5 then
                    mod.ShaderData.playerTimestuckFlick = not mod.ShaderData.playerTimestuckFlick
                end
            end
        end
    end
end
--mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnSaturnusUpdate)

--OTHERS--------------------------------------
function mod:OnSaturnusNewRoom(player)
    if player:HasCollectible(mod.Items.Saturnus) then
        mod.ItemsVars.timeStops[player.ControllerIndex] = false
        
        player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR)
        player:EvaluateItems()
    end
end

-------------------------------------------------------------------------------
--THE TIME STOP----------------------------------------------------------------
-------------------------------------------------------------------------------
function mod:StopTimeUpdate()
    if mod.ShaderData.timestuckEndFrame then
        if game:GetFrameCount() >= mod.ShaderData.timestuckEndFrame then
            mod:ResumeTime()
            mod.ShaderData.timestuckEndFrame = nil
        end
    else
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.StopTimeUpdate)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.StopTimeUpdate)

local CopyLaserEntityFields = function(source, target)
    target.Angle = source.Angle
    target.AngleDegrees = source.AngleDegrees
    target.BounceLaser = source.BounceLaser
    target.CurveStrength = source.CurveStrength
    target.EndPoint = source.EndPoint
    target.FirstUpdate = source.FirstUpdate
    target.GridHit = source.GridHit
    target.IsActiveRotating = source.IsActiveRotating
    target.LaserLength = source.LaserLength
    target.LastAngleDegrees = source.LastAngleDegrees
    target.MaxDistance = source.MaxDistance
    target.ParentOffset = source.ParentOffset
    target.Radius = source.Radius
    target.RotationDegrees = source.RotationDegrees
    target.RotationDelay = source.RotationDelay
    target.RotationSpd = source.RotationSpd
    target.StartAngleDegrees = source.StartAngleDegrees
    target.TearFlags = source.TearFlags

    target:SetBlackHpDropChance(source.BlackHpDropChance)
    target:SetHomingType(source.HomingType)
    target:SetOneHit(source:GetOneHit())
    target:SetMultidimensionalTouched(source:IsMultidimensionalTouched())
    target:SetPrismTouched(source:IsPrismTouched())
    target:SetDamageMultiplier(source:GetDamageMultiplier())
    target:SetDisableFollowParent(source:GetDisableFollowParent())
    target:SetScale(source:GetScale())
    target:SetShrink(source:GetShrink())
    target:SetTimeout(source:GetTimeout())

end

function mod:TimeStopedEntity(entity)
    local data = entity:GetData()
    if not data.Timestop_inmune then
        local sprite = entity:GetSprite()

        if not data.Stored_vel then
            data.Stored_vel = entity.Velocity

            if entity.Type == EntityType.ENTITY_BOMB and entity.FrameCount == 0 then
                entity = entity:ToBomb()
                entity:SetExplosionCountdown(1)

                sprite.Color = mod.Colors.timeChanged

                local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeObjective, entity.Position, Vector.Zero, entity)
                timestuck:GetSprite().Scale = Vector.One*0.4
                timestuck:GetData().Timestop_inmune = 2
                timestuck.DepthOffset = -100

            elseif entity.Type == EntityType.ENTITY_LASER then
                entity = entity:ToLaser()
                entity.DisableFollowParent = true
                if entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() then
                    local laser = EntityLaser.ShootAngle(entity.Variant, entity.Position, entity.Angle, entity.Timeout, entity.PositionOffset, entity.SpawnerEntity)

                    laser:GetData().Timestop_inmune = 1
                    laser:Update()
                    laser:GetData().Timestop_inmune = nil

                    laser:GetData().Stored_vel = entity.Velocity
                    CopyLaserEntityFields(entity, laser)
                    entity:Remove()
                end
            end
        else
            sprite:SetFrame(math.max(0, sprite:GetFrame()-1))

            entity.Velocity = Vector.Zero
            return true
        end
    end
end
local callbacks = {ModCallbacks.MC_PRE_SLOT_UPDATE, ModCallbacks.MC_PRE_PLAYER_UPDATE, ModCallbacks.MC_PRE_TEAR_UPDATE, ModCallbacks.MC_PRE_FAMILIAR_UPDATE, ModCallbacks.MC_PRE_BOMB_UPDATE, ModCallbacks.MC_PRE_PICKUP_UPDATE, ModCallbacks.MC_PRE_PROJECTILE_UPDATE, ModCallbacks.MC_PRE_LASER_UPDATE, ModCallbacks.MC_PRE_EFFECT_UPDATE, ModCallbacks.MC_PRE_NPC_UPDATE}

function mod:StopTime(frames)
    
    mod.ShaderData.timestuckRoomIdx = game:GetLevel():GetCurrentRoomIndex()
    mod.ShaderData.timestuckStartFrame = game:GetFrameCount()
    mod.ShaderData.timestuckEndFrame = mod.ShaderData.timestuckStartFrame + frames

    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player and (player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) or (player:GetData().Timestop_inmune and player:GetData().Timestop_inmune > 0)) then
            player:GetData().Timestop_inmune = 1
            for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
                local familiar_player = familiar.Player or familiar.SpawnerEntity and familiar.SpawnerEntity:ToPlayer()
                if familiar_player and mod:ComparePlayer(player, familiar_player) then
                    familiar:GetData().Timestop_inmune = 1
                end
            end
		end
	end

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.StopTimeUpdate)

    --freeze entites
    for i, callback in ipairs(callbacks) do
        mod:AddPriorityCallback(callback, CallbackPriority.IMPORTANT*2, mod.TimeStopedEntity)
    end
end

function mod:ResumeTime()
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
            mod.ItemsVars.timeStops[player.ControllerIndex] = false

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
		end
	end
    mod:DisableWeather(mod.WeatherFlags.TIMESTUCK, 0)

    
    --unfreeze entites
    for i, callback in ipairs(callbacks) do
        mod:RemoveCallback(callback, mod.TimeStopedEntity)
    end

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local data = entity:GetData()
        if data.Timestop_inmune and data.Timestop_inmune == 1 then
            data.Timestop_inmune = nil
        elseif data.Stored_vel then
            entity.Velocity = data.Stored_vel
            data.Stored_vel = nil
        end
    end
end

--CACHE
function mod:TimestopOnCache(player, cacheFlag)

	if mod.ItemsVars.timeStops[player.ControllerIndex] then

		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 2
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			local tps = mod:toTearsPerSecond(player.MaxFireDelay)
			local new = mod:toMaxFireDelay(3*tps)
			player.MaxFireDelay = new
		end
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = mod.Colors.timeChanged
		end

	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.TimestopOnCache)

--CALLBACKS
function mod:AddTSaturnusCallbacks()
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnSaturnusUpdate)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnSaturnusPlayerUpdate, 0)

	if mod:SomebodyHasItem(mod.Items.Saturnus) then
        mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnSaturnusUpdate)
        mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnSaturnusPlayerUpdate, 0)
	end
end
mod:AddTSaturnusCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTSaturnusCallbacks, mod.Items.Saturnus)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTSaturnusCallbacks)