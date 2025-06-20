local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--MERCURIUS
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@&%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%&@@@@&%%%%%%&@@@@&%%%%%%%&@@@@&%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%%%&@@@@&%%%%&@@@@&%%%%%@@@@@%%%%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@&%%%%%%%%%%%&@@@@&%%%%%%%%%%%%&@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@@%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%&@@@@@%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%%%%%@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.TmercuryConst = {
    MAX_MINIS = 25,

    CAP_CHANCE = 0.5,
    CAP_LUCK = 6,

    UNICORN_CHANCE = 0.05,
}

--UTILS---------------------------------------------------
function mod:ChangeSpriteToBismuth(tear)

    if tear:ToTear() then
        mod:scheduleForUpdate(function()
            local sprite = tear:GetSprite()
    
            local anim = sprite:GetAnimation()
            local valid = string.sub(anim,1,11)=="RegularTear" or string.sub(anim,1,11)=="BloodTear"

            if valid then
                tear:ChangeVariant(Isaac.GetEntityVariantByName("Mercurius Tear (HC)"))
                sprite:Load("hc/gfx/tear_Mercurius.anm2", true)
                sprite:Play(anim, true)
            elseif string.sub(anim,1,5)=="Stone" then
                tear:ChangeVariant(Isaac.GetEntityVariantByName("Mercurius Tear (HC)"))
                sprite:Load("hc/gfx/tear_Mercurius_stone.anm2", true)
                sprite:Play(anim, true)
            elseif string.sub(anim,1,6)=="Rotate" and sprite:GetDefaultAnimation()=="Rotate0" then
                tear:ChangeVariant(Isaac.GetEntityVariantByName("Mercurius Tear (HC)"))
                sprite:Load("hc/gfx/tear_Mercurius_rotate.anm2", true)
                sprite:Play(anim, true)
            end
        end, 1)

    elseif tear:ToBomb() then
        local bomb = tear:ToBomb()
        --Nah
        bomb:GetSprite().Color = mod.Colors.mercury
    end
end

function mod:MercuriusTearRoll(player, tear)
    if mod:LuckRoll(player.Luck, mod.TmercuryConst.CAP_LUCK, mod.TmercuryConst.CAP_CHANCE) then
        tear:GetData().MercuriusTear = true
        tear:GetData().MercuriusTearFlag = true
        
        mod:ChangeSpriteToBismuth(tear)
    end
end

--INITS------------------------------------------------
function mod:OnMercuryTearInit(tear)
	if not tear.SpawnerEntity then return end

	local player = tear.SpawnerEntity:ToPlayer()
	if player then
        if player:HasCollectible(mod.Items.Mercurius) then
            mod:MercuriusTearRoll(player, tear)
        end
	end

	local familiar = tear.SpawnerEntity:ToFamiliar()
    if familiar and familiar:GetData().IsOfBismuth then
        mod:ChangeSpriteToBismuth(tear)
	end

end
--mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.OnMercuryTearInit)

function mod:OnMercuryBombInit(bomb)
    if not bomb.SpawnerEntity then return end

	local player = bomb.SpawnerEntity:ToPlayer()
	if player then
        if player:HasCollectible(mod.Items.Mercurius) and mod:LuckRoll(player.Luck, mod.TmercuryConst.CAP_LUCK, mod.TmercuryConst.CAP_CHANCE) then
            bomb:GetData().IsOfBismuth = true
            mod:ChangeSpriteToBismuth(bomb)
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.OnMercuryBombInit)

function mod:OnMercuryKnifeInit(knife)
    knife:GetSprite():ReplaceSpritesheet(0, "hc/gfx/effects/bismuth_knife.png")
    knife:GetSprite():LoadGraphics()

    knife:GetData().IsOfBismuth = true
end

--UPDATES-----------------------------------------------
function mod:OnMercuryTearUpdate(tear)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

    if data.MercuriusTearFlag then
        if tear:IsDead() then
            mod:MercuriusTearDestroy(tear)
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.OnMercuryTearUpdate)

function mod:SpawnMiniIsaacMercury(player, position)
	if (not player) or #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC) >= mod.TmercuryConst.MAX_MINIS then
        return
    end

	sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 1, 2, false, 1)
	local miniIsaac = player:AddMinisaac(position)

	miniIsaac:GetData().IsOfBismuth = true
	miniIsaac:GetSprite():ReplaceSpritesheet(0, "hc/gfx/familiar/familiar_minisaac_mercury.png")
	miniIsaac:GetSprite():ReplaceSpritesheet(1, "hc/gfx/familiar/familiar_minisaac_mercury.png")
	miniIsaac:GetSprite():LoadGraphics()
end
function mod:MiniIsaacMercuryDeath(entity, amount)
	if entity.Variant == FamiliarVariant.MINISAAC and entity:GetData().IsOfBismuth then
		if entity.HitPoints <= amount then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, Vector.Zero, entity.Player)
			creep.SpriteScale = Vector.One * 0.01
			creep:GetSprite().Color = mod.Colors.mercury
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.MiniIsaacMercuryDeath, EntityType.ENTITY_FAMILIAR)

--HITS-----------------------------------------
function mod:MercuriusTearDestroy(tear)

    local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, tear.Position, Vector.Zero, nil)
    splat:GetSprite().Color = mod.Colors.mercury

    game:SpawnParticles (tear.Position, EffectVariant.DIAMOND_PARTICLE, 5, 3, Color(1,0.7,1,1,0.1,0.1,0.1))

    sfx:Play(Isaac.GetSoundIdByName("BismuthBreak"), 0.5, 2, false, 1)

end
function mod:MercuriusTearCollision(tear, collider)
	if tear:GetData().MercuriusTear and collider and collider:IsActiveEnemy() then

        mod:MercuriusTearDestroy(tear)

	end
end
--mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.MercuriusTearCollision)

function mod:MercuryHitCollision(enemy, source, flags)--laser and bomb
	if source then
        local player = mod:GetPlayerFromSource(source)
        if player then
            
            --tear
            if not enemy:GetData().BismuthTearFlag then
                enemy:GetData().BismuthTearFlag = true

                local tear = source and source:ToTear()
                if tear and tear:GetData().MercuriusTear then
                    mod:SpawnMiniIsaacMercury(player, enemy.Position)
                end
            end

            --laser
            if not enemy:GetData().BismuthLaserRollFlag then
                enemy:GetData().BismuthLaserRollFlag = true

                if source:ToBomb() then
                    if source:GetData().IsOfBismuth then
                        mod:SpawnMiniIsaacMercury(player, enemy.Position)
                        return
                    end
                end

                local validDamage = (flags&DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER)

                if validDamage and player:HasCollectible(mod.Items.Mercurius) and mod:LuckRoll(player.Luck, mod.TmercuryConst.CAP_LUCK, mod.TmercuryConst.CAP_CHANCE) then
                    mod:SpawnMiniIsaacMercury(player, enemy.Position)
                end

            end
            
            --knife
            if not enemy:GetData().BismuthKnifeRollFlag then
                enemy:GetData().BismuthKnifeRollFlag = true

                local knife = source and source:ToKnife()
                if knife and player:HasCollectible(mod.Items.Mercurius) and mod:LuckRoll(player.Luck, mod.TmercuryConst.CAP_LUCK, mod.TmercuryConst.CAP_CHANCE) then
                    mod:SpawnMiniIsaacMercury(player, enemy.Position)
                end
            end
        end
	end
end
--mod:AddSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.MercuryHitCollision)

--OTHER-----------------------------------------
function mod:OnMercuriusNewRoom(player)

    if player:HasCollectible(mod.Items.Mercurius) then
        if rng:RandomFloat() <= mod.TmercuryConst.UNICORN_CHANCE and game:GetRoom():IsFirstVisit() then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN, false, false, true, false)
        end
    end
end

--CACHE
function mod:OnMercuriusCache(player, cacheFlag)

	if player:HasCollectible(mod.Items.Mercurius) then
		if cacheFlag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.23*player:GetCollectibleNum(mod.Items.Mercurius)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnMercuriusCache)

--CALLBACKS
function mod:AddTMercuryCallbacks()
    mod:RemoveCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.OnMercuryTearInit)
    mod:RemoveCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.OnMercuryTearUpdate)
    mod:RemoveCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.MercuriusTearCollision)
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.MercuryHitCollision)

	if mod:SomebodyHasItem(mod.Items.Mercurius) then
        mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.OnMercuryTearInit)
        mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.OnMercuryTearUpdate)
		mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.MercuriusTearCollision)
        mod:AddSillyCallback(mod.ModCallbacks.ON_ENEMY_KILL, mod.MercuryHitCollision)
	end
end
mod:AddTMercuryCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTMercuryCallbacks, mod.Items.Mercurius)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTMercuryCallbacks)