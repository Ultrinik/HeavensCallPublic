local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.VoidHeartConsts = {
    BREAK_CHANCE = 0.1,

}

function mod:OnVoidHeartUpdate(heart)

    if heart.SubType == mod.EntityVoidSub then
        local sprite = heart:GetSprite()

        if sprite:IsEventTriggered("DropSound") then

        elseif sprite:IsPlaying("Collect") then
            heart.Velocity = Vector.Zero

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidHeartUpdate, PickupVariant.PICKUP_HEART)

function mod:OnVoidHeartCollide(pickup, player)
    if mod:CanPickupVoidHeart(player) then
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        pickup.Velocity = Vector.Zero
        pickup.TargetPosition = pickup.Position

        mod:HeartBroker(pickup, player)

        local sprite = pickup:GetSprite()
        sprite:Play("Collect", true)

        sfx:Play(mod.SFX.VoidPickup)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            mod:OnVoidHeartCollide(pickup, collider:ToPlayer())
        end

        return false
    end
end, PickupVariant.PICKUP_HEART)

function mod:HeartBroker(pickup, player)

    mod.SaveManager.GetRunSave(player).currentVoidHearts = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
    mod.SaveManager.GetRunSave(player).voidHeartsState = mod.SaveManager.GetRunSave(player).voidHeartsState or 0

    if player:GetBrokenHearts() == mod.SaveManager.GetRunSave(player).currentVoidHearts then
        player:AddBrokenHearts(1)
        sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 2, false, 0.75)
    end

    mod.SaveManager.GetRunSave(player).currentVoidHearts = math.min(player:GetBrokenHearts(),mod.SaveManager.GetRunSave(player).currentVoidHearts + 1)
    mod.SaveManager.GetRunSave(player).voidHeartsState = mod.SaveManager.GetRunSave(player).voidHeartsState | (1 << (mod.SaveManager.GetRunSave(player).currentVoidHearts-1))

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
    mod:CheckVoidHeartRender()
end

function mod:CanPickupVoidHeart(player)
    local n_hearts = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
    local n_broken_hearts = player:GetBrokenHearts()

    if n_broken_hearts > n_hearts then
        return true
    elseif n_broken_hearts < 11 then
        return true
    end
    return false
end
function mod:NeedVoidHeartHeal(player)
    local n_hearts = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
    local heart_states = mod.SaveManager.GetRunSave(player).voidHeartsState or 0

    for i=0, n_hearts-1 do
        local state = (heart_states & (1 << i)) > 0
        if not state then
            return true
        end
    end
    return false
end
function mod:HealVoidHeart(player)
    local n_hearts = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
    local heart_states = mod.SaveManager.GetRunSave(player).voidHeartsState or 0

    for i=0, n_hearts-1 do
        local state = (heart_states & (1 << i)) > 0
        if not state then
            mod.SaveManager.GetRunSave(player).voidHeartsState = mod.SaveManager.GetRunSave(player).voidHeartsState | (1 << i)
            break
        end
    end

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
    mod:CheckVoidHeartRender()
end
function mod:RemoveVoidHeart(player, n_hearts, heart_states)
    for i=n_hearts-1, 0, -1 do
        local state = (heart_states & (1 << i)) > 0
        if state then

            if rng:RandomFloat() < mod.VoidHeartConsts.BREAK_CHANCE or (player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B) then
                mod.SaveManager.GetRunSave(player).voidHeartsState = mod:remove_bit(mod.SaveManager.GetRunSave(player).voidHeartsState, i)
                mod.SaveManager.GetRunSave(player).currentVoidHearts = mod.SaveManager.GetRunSave(player).currentVoidHearts - 1

                sfx:Play(SoundEffect.SOUND_GLASS_BREAK, 0.75)
            else
                mod.SaveManager.GetRunSave(player).voidHeartsState = mod.SaveManager.GetRunSave(player).voidHeartsState & ~(1 << i)
            end
            break
        end
    end

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
    mod:CheckVoidHeartRender()
end
function mod:CheckVoidHeartOnHit(player, amount, damageFlags, source, frames)
	--invalid means that the blaze heart will not break or protect
	local invalid = (damageFlags&DamageFlag.DAMAGE_RED_HEARTS==DamageFlag.DAMAGE_RED_HEARTS)
				or (damageFlags&DamageFlag.DAMAGE_DEVIL==DamageFlag.DAMAGE_DEVIL)
				or (damageFlags&DamageFlag.DAMAGE_INVINCIBLE==DamageFlag.DAMAGE_INVINCIBLE)
				or (damageFlags&DamageFlag.DAMAGE_CURSED_DOOR==DamageFlag.DAMAGE_CURSED_DOOR)
				or (damageFlags&DamageFlag.DAMAGE_IV_BAG==DamageFlag.DAMAGE_IV_BAG)
				or (damageFlags&DamageFlag.DAMAGE_FAKE==DamageFlag.DAMAGE_FAKE)

	if not invalid then
        local n_hearts = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
        local heart_states = mod.SaveManager.GetRunSave(player).voidHeartsState or 0

		if n_hearts > 0 and heart_states > 0 then
            mod:RemoveVoidHeart(player, n_hearts, heart_states)
            mod:OnVoidHeartBreak(player)
            return true
        else
            return false
        end
	end
end
function mod:OnVoidHeartBreak(player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, false, false, true, false, -1)

    --mod:SpawnBlackHole(player.Position, player)
end

function mod:GetVoidHearts(player)
    return mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
end


function mod:OnVoidHeartSpawn(pickup, variant, subType)
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidHeartSpawn, {"void_pickups_A (HC)", mod.voidConsts.HEART_CHANCE, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidHeartSpawn, {"void_pickups_A (HC)", mod.voidConsts.HEART_CHANCE, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidHeartSpawn, {"void_pickups_A (HC)", mod.voidConsts.HEART_CHANCE, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidHeartSpawn, {"void_pickups_A (HC)", mod.voidConsts.HEART_CHANCE, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SCARED, mod.EntityVoidSub})


--Recharge
function mod:OnOtherHeartsCollide(pickup, collider)
    local player = collider:ToPlayer()
    if player then
        local subType = pickup.SubType
        local r = rng:RandomFloat()
        local interaction_flag = false
        local regen_flag = false
        local dmg_flag = false
        mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp or 0

        if (not interaction_flag) and not player:CanPickRedHearts() then
            if subType == HeartSubType.HEART_FULL or subType == HeartSubType.HEART_SCARED or subType == HeartSubType.HEART_BLENDED then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 0.25 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.01
                    dmg_flag = true
                end
                interaction_flag = true

            elseif subType == HeartSubType.HEART_DOUBLEPACK then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 1 - (1-0.25)^2 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.02
                    dmg_flag = true
                end
                interaction_flag = true

            elseif subType == HeartSubType.HEART_HALF then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 0.14 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.005
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if (not interaction_flag) and not player:CanPickSoulHearts() then
            if subType == HeartSubType.HEART_SOUL or subType == HeartSubType.HEART_BLENDED then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 0.5 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.02
                    dmg_flag = true
                end
                interaction_flag = true

            elseif subType == HeartSubType.HEART_HALF_SOUL then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 0.3 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.01
                    dmg_flag = true
                end
                interaction_flag = true

            elseif subType == HeartSubType.HEART_BLACK then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 0.75 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.03
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if (not interaction_flag) and not player:CanPickRottenHearts() then
            if subType == HeartSubType.HEART_ROTTEN then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 1 - (1-0.25)^2 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.03
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if (not interaction_flag) and not player:CanPickBoneHearts() then
            if subType == HeartSubType.HEART_BONE then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 1 - (1-0.25)^2 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.04
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if (not interaction_flag) and not player:CanPickGoldenHearts() then
            if subType == HeartSubType.HEART_GOLDEN then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 1 - (1-0.25)^2 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.04
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if (not interaction_flag) and not mod:CanPickBlazeHearts(player) then
            if subType == mod.EntityInf[mod.Entity.BlazeHeart].SUB then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 1 - (1-0.25)^3 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.05
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if (not interaction_flag) and not mod:CanPickupGlassHeart(player) then
            if subType == mod.EntityInf[mod.Entity.GlassHeart].SUB then
                if mod:NeedVoidHeartHeal(player) then
                    if r < 1 - (1-0.25)^3 then
                        regen_flag = true
                    end
                else
                    mod.SaveManager.GetRunSave(player).voidHeartDamageUp = mod.SaveManager.GetRunSave(player).voidHeartDamageUp + 0.05
                    dmg_flag = true
                end
                interaction_flag = true
            end
        end

        if interaction_flag then
            if mod:NeedVoidHeartHeal(player) then
                if regen_flag then
                    mod:HealVoidHeart(player)
                    sfx:Play(SoundEffect.SOUND_VAMP_GULP,1)
                else
                    --too bad, better luck next time
                end
            end

            if dmg_flag then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end

            --pickup:GetSprite():Play("Collect", true)
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            pickup:Remove()
            game:SpawnParticles (pickup.Position, EffectVariant.HAEMO_TRAIL, 15, 9, Color(0,0,0,1))
            sfx:Play(SoundEffect.SOUND_POOPITEM_STORE, 1,2, false, 3)
            return true
        end
    end
end


--HEART RENDER
local abyss_sprite = Sprite()
abyss_sprite:Load("hc/gfx/ui/heart_abyss.anm2", true)
abyss_sprite:Play("HeartFull")

local abyss_sprite2 = Sprite()
abyss_sprite2:Load("hc/gfx/ui/heart_abyss.anm2", true)
abyss_sprite2:Play("HeartEmpty")

local s_offset = 12
local n_frame = 0
function mod:VoidRenderHealth(offset, sprite, position, scale, player)

	local n_hearts = mod:GetPlayerHearts(player)+player:GetBrokenHearts()

	local nVoidsReal = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
    local voidStates = mod.SaveManager.GetRunSave(player).voidHeartsState or 0

    voidStates = mod:push_ones_left(voidStates, nVoidsReal)
    --print(nVoidsReal, voidStates)

	nVoidsReal = math.min(n_hearts, nVoidsReal)

    local frame = math.floor(n_frame*0.25)&3
    n_frame = n_frame+1

	for i=0, nVoidsReal-1 do
		local last_index = n_hearts - i

		local x = (last_index-1)%6
		local y = math.floor((last_index-1)/6)

        local state = (voidStates & (1 << i)) > 0
        if state then
            abyss_sprite:Play("HeartFull")
            abyss_sprite:SetFrame(frame)
        else
            abyss_sprite:Play("HeartEmpty")
        end

		if player:GetPlayerType() == PlayerType.PLAYER_ESAU and player:GetOtherTwin() then
			abyss_sprite:Render(position+Vector(-x*s_offset+1, y*s_offset-y*2))
		else
			abyss_sprite:Render(position + Vector(s_offset*x,(s_offset-2)*y))
		end
	end
end
function mod:CheckVoidHeartRender()
	mod:RemoveCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, mod.VoidRenderHealth)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnOtherHeartsCollide, PickupVariant.PICKUP_HEART)

    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			local n_void_hearts = mod.SaveManager.GetRunSave(player).currentVoidHearts or 0
			if n_void_hearts > 0 then
				mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, mod.VoidRenderHealth)
                mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnOtherHeartsCollide, PickupVariant.PICKUP_HEART)
				return true
			end
		end
	end
end
mod.SaveManager.AddCallback(mod.SaveManager.Utility.CustomCallback.POST_DATA_LOAD, mod.CheckVoidHeartRender)