local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@&%%%%&@@@@&%%%%%@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@%%%%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@&%%%%&@@&%&@@@@&%%&@&%%%%&@@@@&%%%%%@@&%%@@@@@%%&@@%%%%%@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%&@@@@&%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
--Swordfish from TT was of big help

mod.TridentStates = {
	IDLE = 0,
	LAUNCHED = 1,
	ABYSS = 2,
}

--UPDATES-----------------------------------
function mod:OnNeptuneUpdate(player)
    if player:HasCollectible(mod.Items.Neptunus) then
        local data = player:GetData()

        local shotDirection = player:GetData().CurrentAttackDirection_HC

        if not data.AttackVector_HC then data.AttackVector_HC = Vector(0,1) end
        if not data.TridentCharge_HC then data.TridentCharge_HC = 0 end

        if shotDirection then
            data.AttackVector_HC = shotDirection
            data.TridentForce_HC = 0
            data.TridentCharge_HC = math.min(90, data.TridentCharge_HC + 1*10/player.MaxFireDelay)

        else
            data.TridentForce_HC = data.TridentCharge_HC
            data.TridentCharge_HC = 0
        end
    end
end

function mod:TridentUpdate(familiar)
	local data = familiar:GetData()
    local sprite = familiar:GetSprite()
	local player = familiar.Player

    if not data.Init then
        data.Init = true
		data.State = mod.TridentStates.IDLE

        familiar:SetSize(10, Vector(4.5,1), 12)
        familiar.SpriteOffset = Vector(0,-12)
        data.Distance = 40
		data.Objective = data.Distance
        data.StabTimer = 0
    end

    if player then
		
        if data.State == mod.TridentStates.IDLE then

			familiar.CollisionDamage = player.Damage*2
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				familiar.CollisionDamage = familiar.CollisionDamage * 2
				familiar:SetSize(10, Vector(5,1), 12)
			end
            
			if sprite:IsFinished("Idle") then
				sprite:Play("Idle", true)
			end

			if player:GetData().TridentForce_HC and player:GetData().TridentForce_HC > 0 then

				familiar.CollisionDamage = player.Damage*(1 + math.min(3.5, 3.5*player:GetData().TridentForce_HC/30))
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					familiar.CollisionDamage = familiar.CollisionDamage * 2
					familiar:SetSize(10, Vector(5,1), 12)
				end

				data.State = mod.TridentStates.LAUNCHED

				local force = player:GetData().TridentForce_HC
				if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
					force = math.min(90, force*1.5)
				end
				data.Force = (force*2 + data.Distance + 30)/260*player.TearRange
					
				data.Objective = player.Position + Vector(data.Force, 0):Rotated(sprite.Rotation)
			elseif player:GetData().AttackVector_HC then
				sprite.Rotation = mod:AngleLerp(sprite.Rotation, player:GetData().AttackVector_HC:GetAngleDegrees(), 0.5)
				familiar.TargetPosition = player.Position + Vector(data.Distance,0):Rotated(sprite.Rotation)
				familiar.Velocity = (familiar.TargetPosition - familiar.Position)/2

			end

        elseif data.State == mod.TridentStates.LAUNCHED then

			local objective = data.Objective
			if not objective then objective = player.Position + Vector(data.Distance,0):Rotated(sprite.Rotation) end

			familiar.Velocity = (objective - familiar.Position)/2

			if familiar.Position:Distance(objective) < 15 then

				if not (data.Force == data.Distance)  then
					data.Force = data.Distance
					data.Objective = nil
	
				elseif data.Force == data.Distance then
					data.State = mod.TridentStates.IDLE
				end
			end

        end

    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.TridentUpdate, mod.EntityInf[mod.Entity.Trident].VAR)

--BLACK HOLE---------------------------------------------------
function mod:SpawnAbyssHole(familiar, victim)
	if familiar.Player and (mod:LuckRoll(familiar.Player.Luck + 5, 20, 0.3)) then
		local position = victim.Position
		mod:scheduleForUpdate(function()
			mod:SpawnBlackHole(position, familiar.Player)
		end, 10)

		local triton = mod:SpawnEntity(mod.Entity.TritonHole, position + Vector(0,25), Vector.Zero, nil)
		sfx:Play(mod.SFX.Triton, 2.5)
	end
end
function mod:SpawnBlackHole(position, player)
	local blackhole = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, position, Vector.Zero, player):ToEffect()
	blackhole:GetSprite():ReplaceSpritesheet(0, "hc/gfx/effects/abyss_hole.png")
	blackhole:GetSprite():ReplaceSpritesheet(1, "")
	blackhole:GetSprite():LoadGraphics()
	blackhole:GetSprite().PlaybackSpeed = 10
	return blackhole
end

function mod:AbyssBlackholeUpdate(blackhole)
    local data = blackhole:GetData()
    local sprite = blackhole:GetSprite()

    if not data.Init_HC and sprite:IsPlaying("Init") then
        data.Init_HC = true

        data.Position_HC = blackhole.Position
		mod:EnableBlackHole(blackhole.Position)
    end

    if data.Position_HC then
        game:MakeShockwave(data.Position_HC, -0.1, 0.0025, 60)
    end

    if not data.Stop_HC and sprite:IsPlaying("Death") then
        data.Stop_HC = true

        mod.ShaderData.blackHole = false
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.AbyssBlackholeUpdate, EffectVariant.BLACK_HOLE)

--Triton
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DissapearAfterIdle, mod.EntityInf[mod.Entity.TritonHole].VAR)

--PAIN-------------------------------------------------
function mod:TridentKill(entity, source)

	if source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == mod.EntityInf[mod.Entity.Trident].VAR and source.SubType == mod.EntityInf[mod.Entity.Trident].SUB then
        local familiar = source:ToFamiliar()

		local data = familiar:GetData()
		if data.State and data.State == mod.TridentStates.LAUNCHED then
			mod:SpawnAbyssHole(familiar, entity)
		end
    end
end

--CACHE
function mod:OnNeptunusCache(player, cacheFlag)

    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		local numItem = player:GetCollectibleNum(mod.Items.Neptunus)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)

		player:CheckFamiliar(mod.EntityInf[mod.Entity.Trident].VAR, numFamiliars, player:GetCollectibleRNG(mod.Items.Neptunus), Isaac.GetItemConfig():GetCollectible(mod.Items.Neptunus))
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnNeptunusCache)

--CALLBACKS
function mod:AddTNeptunusCallbacks()
	mod:RemoveSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.TridentKill)
	mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnNeptuneUpdate)

	if mod:SomebodyHasItem(mod.Items.Neptunus) then
		mod:AddSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.TridentKill)
    	mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnNeptuneUpdate)
	end
end
mod:AddTNeptunusCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTNeptunusCallbacks, mod.Items.Neptunus)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTNeptunusCallbacks)