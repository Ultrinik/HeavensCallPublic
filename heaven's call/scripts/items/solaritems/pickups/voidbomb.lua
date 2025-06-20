local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

table.insert(mod.PostLoadInits, {"savedatarun", "VoidBombQueue", 0})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.VoidBombQueue", 0)

function mod:OnVoidBombUpdatePickup(heart)

    if heart.SubType == mod.EntityVoidSub then
        local sprite = heart:GetSprite()

        if sprite:IsEventTriggered("DropSound") then

        elseif sprite:IsPlaying("Collect") then
            heart.Velocity = Vector.Zero

        end

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnVoidBombUpdatePickup, PickupVariant.PICKUP_BOMB)

function mod:OnVoidBombCollide(pickup, player)
    slot = slot or 0

    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.Velocity = Vector.Zero
    pickup.TargetPosition = pickup.Position

    player:AddBombs(1)
    mod:AddVoidBomb(player)

    local sprite = pickup:GetSprite()
    sprite:Play("Collect", true)

    sfx:Play(mod.SFX.VoidPickup)
    sfx:Stop(SoundEffect.SOUND_FETUS_JUMP)

    mod:CheckRenderVoidPickups()
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if pickup.SubType == mod.EntityVoidSub then
        if collider:ToPlayer() then
            mod:OnVoidBombCollide(pickup, collider:ToPlayer())
        end
        
        return false
    end
end, PickupVariant.PICKUP_BOMB)

function mod:AddVoidBomb(player)
    mod.savedatarun().VoidBombQueue = mod.savedatarun().VoidBombQueue or 0
    mod.savedatarun().VoidBombQueue = mod.savedatarun().VoidBombQueue + 1
end

function mod:OnVoidBombInit(player, bomb)
    mod.savedatarun().VoidBombQueue = mod.savedatarun().VoidBombQueue or 0
    if mod.savedatarun().VoidBombQueue > 0 and not (bomb.Variant == BombVariant.BOMB_GIGA or bomb.Variant == BombVariant.BOMB_ROCKET_GIGA) then
        mod:scheduleForUpdate(function()
            mod.savedatarun().VoidBombQueue = math.max(0, mod.savedatarun().VoidBombQueue - 1)

            local animation = bomb:GetSprite():GetAnimation()

            local newBomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_GIGA, mod.EntityVoidSub, bomb.Position, bomb.Velocity, bomb.SpawnerEntity:ToPlayer()):ToBomb()
            if newBomb then
                newBomb:SetExplosionCountdown(math.ceil(30*6.75))
                newBomb:GetSprite():Play(animation, true)

                newBomb.ExplosionDamage = newBomb.ExplosionDamage*3

                newBomb.TargetPosition = newBomb.Position

                mod:scheduleForUpdate(function()
                    if newBomb and player then
                        local hole = mod:SpawnBlackHole(newBomb.Position, player):ToEffect()
                        hole.Parent = newBomb
                        hole:FollowParent(newBomb)
                    end
                end, 20)

                bomb:Remove()
                
                sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_CHARGE, 1, 2, false, 0.6)
                sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_CLOSE)
            end
        end, 2)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, mod.OnVoidBombInit, 0)

function mod:OnVoidBombUpdateBomb(bomb)
    if bomb.SubType == mod.EntityVoidSub then
        
        bomb.Position = bomb.TargetPosition

        local n = 1/(bomb:GetExplosionCountdown()/100+0.01)
        n = math.ceil(n)
        
        game:ShakeScreen(n)

        local f = bomb.FrameCount

        
        if bomb:GetSprite():IsPlaying("Pulse") then
            bomb:GetSprite().Rotation = (bomb:GetSprite().Rotation + 360/15)%360
            if f < 30 then
                local h = -math.sin(math.pi*2*f/30)*20
                bomb.SpriteOffset = Vector(0, h)
                for i=0, 2, 2 do
                    --local layer = bomb:GetSprite():GetLayer(i)
                    --layer:SetRotation(layer:GetRotation() + 360/15)
                end
            else
                if rng:RandomFloat() < 0.1*n then
                    local trace = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOGMA_BLACKHOLE, 1, bomb.Position, Vector.Zero, nil)
                end
                if rng:RandomFloat() < 0.1*n then
                    local trace = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOGMA_BLACKHOLE, 2, bomb.Position, Vector.Zero, nil)
                end
            end

        elseif bomb:GetSprite():IsPlaying("Explode") then
            game:GetRoom():MamaMegaExplosion(bomb.Position)
            sfx:Play(mod.SFX.SuperExplosion)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.OnVoidBombUpdateBomb, BombVariant.BOMB_GIGA)

--RENDER
function mod:CheckRenderVoidPickups()
    mod.savedatarun().VoidBombQueue = mod.savedatarun().VoidBombQueue or 0
    mod.savedatarun().VoidKeyQueue = mod.savedatarun().VoidKeyQueue or 0
    if mod.savedatarun().VoidBombQueue + mod.savedatarun().VoidKeyQueue > 0 then
        
        mod.VoidBombSprite = Sprite()
        mod.VoidBombSprite:Load("hc/gfx/screen_VoidUI.anm2", true)
        mod.VoidBombSprite:Play("Bomb", true)

        mod.VoidKeySprite = Sprite()
        mod.VoidKeySprite:Load("hc/gfx/screen_VoidUI.anm2", true)
        mod.VoidKeySprite:Play("Key", true)

        mod:RemoveCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnVoidPickupRender)
        mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnVoidPickupRender)
        if mod.savedatarun().VoidKeyQueue > 0 then
            mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.VoidKeyUpdate)
            mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.VoidKeyUpdate)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.CheckRenderVoidPickups)

function mod:OnVoidPickupRender()
    mod.savedatarun().VoidBombQueue = mod.savedatarun().VoidBombQueue or 0
    mod.savedatarun().VoidKeyQueue = mod.savedatarun().VoidKeyQueue or 0

    if mod.savedatarun().VoidBombQueue + mod.savedatarun().VoidKeyQueue <= 0 then
        mod:RemoveCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnVoidPickupRender)

    else
        local bombIcon = mod.VoidBombSprite
        local keyIcon = mod.VoidKeySprite
        
        if bombIcon and keyIcon then
            
            local dim = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
            local offsetVector = dim / dim:Length() * Options.HUDOffset * 25
    
            local spellPosition = Vector(Isaac.GetScreenWidth()*0.1, Isaac.GetScreenHeight()*0.20) + offsetVector 
    
            local iconPosition = Vector(38-31, 68-17) + offsetVector
            if mod.savedatarun().VoidBombQueue > 0 then
                bombIcon:Render(iconPosition)
            end
            iconPosition = iconPosition + Vector(1,13)
            if mod.savedatarun().VoidKeyQueue > 0 then
                keyIcon:Render(iconPosition)
            end
        end
    end

end
--mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.OnVoidPickupRender)



function mod:OnVoidBombSpawn(pickup, variant, subType)
    
    if pickup then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, mod.EntityVoidSub)
    end
    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, mod.EntityVoidSub}
end
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidBombSpawn, {"void_pickups_A (HC)", mod.voidConsts.BOMB_CHANCE, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, mod.EntityVoidSub})
mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnVoidBombSpawn, {"void_pickups_A (HC)", mod.voidConsts.BOMB_CHANCE*2, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_DOUBLEPACK, mod.EntityVoidSub})
