local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.GlassHeartConsts = {
    HEART_CHANCE = 0.005,
}

function mod:OnGlassHeartUpdate(heart)
    if heart.SubType == mod.EntityInf[mod.Entity.GlassHeart].SUB then
        local sprite = heart:GetSprite()

        if sprite:IsEventTriggered("DropSound") then
            sfx:Play(SoundEffect.SOUND_BONE_BOUNCE)
        elseif sprite:IsPlaying("Collect") then
            heart.Velocity = Vector.Zero

        elseif sprite:IsFinished("Collect") then
            heart:Remove()
        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnGlassHeartUpdate, PickupVariant.PICKUP_HEART)

function mod:CanPickupGlassHeart(player)
    return player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE) == 0
end
function mod:OnGlassHeartCollide(pickup, player)
    if mod:CanPickupGlassHeart(player) then
        sfx:Play(SoundEffect.SOUND_GLASS_BREAK)
    
        player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
    
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        pickup.Velocity = Vector.Zero
        pickup.TargetPosition = pickup.Position
    
        local sprite = pickup:GetSprite()
        sprite:Play("Collect", true)
        
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityInf[mod.Entity.GlassHeart].SUB then
        if collider:ToPlayer() then
            return mod:OnGlassHeartCollide(pickup, collider:ToPlayer())
        end
    end
end, PickupVariant.PICKUP_HEART)


function mod:OnGlassHeartSpawn(pickup, variant, subType)
    local flag = false
    
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
            flag = flag or player:CanPickSoulHearts()
		end
	end

    if (not flag) or PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_THELOST_B) then
        if pickup then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityInf[mod.Entity.GlassHeart].SUB)
        end
        return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityInf[mod.Entity.GlassHeart].SUB}
    end
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnGlassHeartSpawn, {"glass_heart (HC)", mod.GlassHeartConsts.HEART_CHANCE, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, mod.EntityInf[mod.Entity.GlassHeart].SUB})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnGlassHeartSpawn, {"glass_heart (HC)", mod.GlassHeartConsts.HEART_CHANCE, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, mod.EntityInf[mod.Entity.GlassHeart].SUB})