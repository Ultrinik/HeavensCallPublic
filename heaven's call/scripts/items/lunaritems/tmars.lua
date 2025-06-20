local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@&%&@@@@&%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.TmarsConsts = {
    MAX_CHARGES = 1000,
    MAX_MARS_FRAMES = 300,

    BONUS_FRAMES = 20,

    TOTAL_SECONDS = 7.5,

    FRAME_DELAY_EXPLOSION = 5,
}

--INIT------------------------------------------------
function mod:MarsTearInit(tear)
	if not tear.SpawnerEntity then return end
	local player = tear.SpawnerEntity:ToPlayer()

	if player and player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime > 0 then

		tear.HomingFriction = 10

		game:ShakeScreen(20)
		tear.Velocity = tear.Velocity:Rotated(mod:RandomInt(-5,5))*(0.8 + rng:RandomFloat()*0.6)
		
		local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, tear.Position, tear.Velocity, nil):ToEffect()
		energy.LifeSpan = 1000
		energy.Parent = tear
		energy.DepthOffset = 5
		energy:GetData().HeavensCall = true
		energy:GetData().MarsShot_HC = true
		energy:FollowParent(tear)

		player.Velocity = player.Velocity - tear.Velocity*0.15

		--Laser
		local succes = mod:LuckRoll(player.Luck, 5, 0.85) or mod:LuckRoll(player.Luck, 5, 0.85)
		if succes then
			local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, player.Position, tear.Velocity:GetAngleDegrees(), 3, Vector(0, -20), player)
			laser:AddTearFlags(TearFlags.TEAR_HOMING)
		end
	end

end
--mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.MarsTearInit)

--UPDATES--------------------------------------------
function mod:OnMarsUpdate(player)
    if player:HasCollectible(mod.Items.Mars) then
        if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == 0 then
            mod:PocketizeItem(player, mod.Items.Mars)
        end

        if not player:GetData().marsOverhaulTime then player:GetData().marsOverhaulTime = -1 end

        player:GetData().marsOverhaulTime = math.max(-1, player:GetData().marsOverhaulTime - 1)
        local time = player:GetData().marsOverhaulTime

        if time > 0 then

            if time%2==0 and (true or not player:HasWeaponType(WeaponType.WEAPON_TEARS)) then
                local shotDirection = player:GetData().CurrentAttackDirection_HC

                if shotDirection then
                    local tear = player:FireTear(player.Position, shotDirection*player.ShotSpeed*10, true, true, false, player, 1)
                    --tear:ChangeVariant(TearVariant.TECH_SWORD_BEAM)
                end
            end

            if mod.ShaderData.weatherFlags & mod.WeatherFlags.MARTIAN <= 0 then
                mod:EnableWeather(mod.WeatherFlags.MARTIAN)
            end
            mod.ShaderData.marsCharge = time/mod.TmarsConsts.MAX_MARS_FRAMES
        else
            if mod.ShaderData.weatherFlags & mod.WeatherFlags.MARTIAN > 0 then
                mod:DisableWeather(mod.WeatherFlags.MARTIAN)
            end
            mod.ShaderData.marsCharge = 0
        end

        if time > 45 then
            sfx:Stop(Isaac.GetSoundIdByName("MarsDischarge"))
        elseif time == 45 then
            sfx:Play(Isaac.GetSoundIdByName("MarsDischarge"), 7.5)

        elseif time == 0 then
            sfx:Play(SoundEffect.SOUND_BERSERK_END)
            player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.Items.Mars))

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end

        if player:GetData().marsOverhaulTime == 60 then
            sfx:Play(Isaac.GetSoundIdByName("OverhaulTicks"))
        end
    else
        player:GetData().marsOverhaulTime = -1
    end
end
--mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnMarsUpdate)

--ACTIVE---------------------------------------------
function mod:OnMarsUse(collectibleType, rng, player, flags, slot)

    --Bethany
    local maxCharges = mod.TmarsConsts.MAX_CHARGES
	if slot > 0 and math.floor(4 * player:GetActiveCharge(slot) / maxCharges) ~= maxCharges then
		mod:TolaterateBethanyCharge(player, slot, maxCharges, 1)
	end

	local n = mod.TmarsConsts.TOTAL_SECONDS
	player:GetData().marsOverhaulTime = player:GetData().marsOverhaulTime + n*30

	sfx:Play(SoundEffect.SOUND_BERSERK_START)

	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnMarsUse, mod.Items.Mars)

--OTHERS------------------------------------------
function mod:OnMarsNewRoom(player)
    if player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime > 0 then
        player:AddCostume (Isaac.GetItemConfig():GetCollectible(mod.Items.Mars), false)

        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
        mod:scheduleForUpdate(function()
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end, mod.TmarsConsts.FRAME_DELAY_EXPLOSION+1)

    end
end

function mod:OnMarsDomesticAbuse(entity, amount, flags, source, frames)
    if source and source.Entity then

        local player = mod:GetPlayerFromSource(source.Entity)
        if player and player:HasCollectible(mod.Items.Mars) then

            --Gain charge
            if player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime<=0 then
                local slot
                if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == mod.Items.Mars then slot = ActiveSlot.SLOT_PRIMARY
                elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == mod.Items.Mars then slot = ActiveSlot.SLOT_SECONDARY
                elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == mod.Items.Mars then slot = ActiveSlot.SLOT_POCKET end
                if (slot and slot~=-1) then
                    player:SetActiveCharge( math.floor(player:GetActiveCharge(slot) + amount), slot)
                end
            end
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnMarsDomesticAbuse)


function mod:OnMarsKill(entity, source)
    local player = mod:GetPlayerFromSource(source)
    if player and player:HasCollectible(mod.Items.Mars) and player:GetData().marsOverhaulTime > 0 then
        player:GetData().marsOverhaulTime = math.min(player:GetData().marsOverhaulTime + mod.TmarsConsts.BONUS_FRAMES, mod.TmarsConsts.MAX_MARS_FRAMES)
    end
end
--mod:AddSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.OnMarsKill)

--CACHE
function mod:OnMarsCache(player, cacheFlag)

	if player:GetData().marsOverhaulTime and player:GetData().marsOverhaulTime > 0 and player:HasCollectible(mod.Items.Mars) then
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 10

		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			local tps = mod:toTearsPerSecond(player.MaxFireDelay)
			local new = mod:toMaxFireDelay(tps + 10)
			player.MaxFireDelay = new

		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed*3

		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 75
		end
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = mod.Colors.red
		end
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage*2.5
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			if game:GetRoom():GetFrameCount() >= mod.TmarsConsts.FRAME_DELAY_EXPLOSION then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_PERSISTENT |  TearFlags.TEAR_EXPLOSIVE |  TearFlags.TEAR_PULSE | TearFlags.TEAR_HOMING
			else
				player.TearFlags = player.TearFlags | TearFlags.TEAR_PERSISTENT |  TearFlags.TEAR_PULSE | TearFlags.TEAR_HOMING
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnMarsCache)

--CALLBACKS
function mod:AddTMarsCallbacks()

    mod:RemoveCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.MarsTearInit)
    mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnMarsDomesticAbuse)
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.OnMarsKill)
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnMarsUpdate)

	if mod:SomebodyHasItem(mod.Items.Mars) then
		mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.MarsTearInit)
        mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnMarsDomesticAbuse)
        mod:AddSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.OnMarsKill)
        mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnMarsUpdate)

    else
        mod:DisableWeather(mod.WeatherFlags.MARTIAN)
        mod.ShaderData.marsCharge = 0
	end
end
mod:AddTMarsCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTMarsCallbacks, mod.Items.Mars)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTMarsCallbacks)