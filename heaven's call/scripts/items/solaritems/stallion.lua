local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[Stallion------------------------------
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#########&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###%&@&%###%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#%@@@@@@@&####&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@%##################%&@@@@@@&%##################%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@&%#######################%@@@@@@@&#####################%&@@@@@@@@@@@@
@@@@@@@@@%###%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%########%&@@@@@@@
@@@@@@@@@%###%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%###%&@@@@@@@
@@@@@@@@@%###%&@@@@@@&%##############################################&@@@@@@@@@@
@@@@@@@@@%###%&@@@@@@&%%&@@@@@@@@@@@@@@@@@@@&####&@@@@&###########%&@@@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@@@@@@@@@@@@@@@@&####&@@@@&####&@&%###%&@@@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@&#########&@@@@&####&@@@@&####&@&%###%&@@@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@&#########&@@@@&####&@@@@&####&@&%###%&@@@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@@@@@@@@@@@@@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@&#########&@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@&#########&@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@@@@@@@@@@@@@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@&#########&@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@@@&%###%@@@@&%%&@@@@&#########&@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@%###%&@@@@%###%&@@@@@@@@@@@@@@@@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@%###%&@@@@%###%&@@@@&#########&@@@@&####&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@@@@%###%&@@@@%#############################&@@@@&####&@@@@&####&@@@@@@@@@@
@@@@@@&%###%@@@@&%########%@@@@&%###%@@@@&%######&@&%######&@@@@&####&@@@@@@@@@@
@@@@@@&%###%@@@@&%#####%&@@@@&#########&@@@@&##############&@@@@&####&@@@@@@@@@@
@@@@@@&%###%@@@@&%###%@@@@&%###########&@@@@@@&%#&@@@@@@@@@@@@@@&####&@@@@@@@@@@
@@@@%###%&@@@@%###%&@@@@@@&%###%@@@@&%###%@@@@&%######&@@@@@@@@@&####&@@@@@@@@@@
@@@@%###%&@@@@%#%@@@@@@@%###%&@@@@@@@@@&##########################%&@@@@@@@@@@@@
@@@@@@&%##################%@@@@@@@@@@@@@@&%###%@@@@@@@&#########&@@@@@@@@@@@@@@@
@@@@@@@@@%###%&@&%#####%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.SolarItemsVars.MountTimers = {}
mod.SolarItemsVars.ScepterTimer = 0

mod.StallionCons = {
    offset = 5,
    minRamSpeed = 4,
    speedBonus = 0.25,
}

--UPDATES------------------------------------------
function mod:OnPlayerCowUpdate(player)
	if player:HasCollectible(mod.SolarItems.Stallion) then

        if Input.GetActionValue(ButtonAction.ACTION_DROP, player.ControllerIndex) > 0 then

            mod.SolarItemsVars.MountTimers[player:GetCollectibleRNG(1):GetSeed()] = mod.SolarItemsVars.MountTimers[player:GetCollectibleRNG(1):GetSeed()] + 1
            
            if mod.SolarItemsVars.MountTimers[player:GetCollectibleRNG(1):GetSeed()] > 30*1.5 then
                mod.SolarItemsVars.MountTimers[player:GetCollectibleRNG(1):GetSeed()] = 0

                for _, cow in ipairs(mod:FindByTypeMod(mod.Entity.Cow)) do
                    cow = cow:ToFamiliar()
                    if cow and cow.Player and mod:ComparePlayer(player, cow.Player) and cow.Position:Distance(cow.Player.Position+Vector(0,mod.StallionCons.offset)) < 75 then
                        local player = cow.Player
                        local playerSprite = player:GetSprite()
                        local playerData = player:GetData()
                        local data = cow:GetData()

                        if data.Mounted then
                            mod:OutCow(player, cow)
                        else
                            mod:IntoCow(player, cow)
                        end
                        mod:OutIntoCow(player, cow)

                        break
                    end
                end

            end
        else
            mod.SolarItemsVars.MountTimers[player:GetCollectibleRNG(1):GetSeed()] = 0
        end
    end
end
function mod:IntoCow(player, cow)
    local playerData = player:GetData()
    local data = cow:GetData()

    player.Position = cow.Position
    playerData.Mounted_HC = true
    mod:scheduleForUpdate(function()
            data.Mounted = true
    end, 20)
    player.ControlsCooldown = 25
    
    local costume = Isaac.GetCostumeIdByPath("hc/gfx/characters/costume_stallion.anm2")
    player:AddNullCostume(costume) 
    --player:AddCostume(Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Scepter), false)
end
function mod:OutCow(player, cow)
    local playerData = player:GetData()
    local data = cow:GetData()

    data.Mounted = false
    cow.Velocity = Vector.Zero
    playerData.Mounted_HC = false
    
    local costume = Isaac.GetCostumeIdByPath("hc/gfx/characters/costume_stallion.anm2")
    player:TryRemoveNullCostume(costume) 
    --player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Scepter))
end
function mod:OutIntoCow(player, cow)
    local playerSprite = player:GetSprite()
    local playerData = player:GetData()
    local data = cow:GetData()

    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()

    player:AnimateTrapdoor()
    mod:scheduleForUpdate(function()
        playerSprite:Play("Jump", true)
    end, 0)
end

function mod:OnCowUpdate(familiar)

    if familiar.SubType == 0 then
        local data = familiar:GetData()
        local player = familiar.Player
        local sprite = familiar:GetSprite()
        local room = game:GetRoom()

        if not data.Init then
            data.Init = true

            data.Direction = 0
            data.Mounted = false
            data.IdleTargetPos = room:FindFreeTilePosition(familiar.Position + Vector(rng:RandomFloat()*50, 0):Rotated(360*rng:RandomFloat()), 10)

            data.ogSize = familiar.Size

            sprite:SetOverlayAnimation("Shadow")
            sprite:SetOverlayRenderPriority(false)

            familiar.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER

            familiar:AddEntityFlags(EntityFlag.FLAG_TRANSITION_UPDATE)
        end


        familiar.SpriteOffset = Vector(0,mod.StallionCons.offset)

        if player then

            if data.Mounted then
                familiar:SetSize(player.Size, Vector.One, 12)

                familiar.Position = player.Position + Vector(0,1)
                familiar.Velocity = player.Velocity
                --familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                local velocity = player.Velocity
                if math.abs(velocity.X) > math.abs(velocity.Y) then
                    if velocity.X > 0 then
                        data.Direction = 0
                    else
                        data.Direction = 2
                    end
                    familiar.Position = familiar.Position + Vector(0,5)
                else
                    if velocity.Y > 0 then
                        data.Direction = 3
                    else
                        data.Direction = 1
                    end
                    familiar.Position = familiar.Position + Vector(0,5)
                end

                familiar.DepthOffset = 0

                if familiar.FrameCount % 2 == 0 then
                    local function break_grid(grid)
                        if grid then
                            --Isaac.Spawn(EntityType.ENTITY_TEAR,0,0,grid.Position,Vector.Zero,nil)
                            local gridType = grid:GetType()
                            if gridType == GridEntityType.GRID_PIT then
                                grid:ToPit():MakeBridge(grid)
                            elseif (GridEntityType.GRID_ROCK <= gridType and gridType <= GridEntityType.GRID_ROCK_ALT) or (GridEntityType.GRID_LOCK <= gridType and gridType <= GridEntityType.GRID_POOP) or (GridEntityType.GRID_STATUE <= gridType and gridType <= GridEntityType.GRID_ROCK_SS) or (GridEntityType.GRID_LOCK <= gridType and gridType <= GridEntityType.GRID_POOP) or (GridEntityType.GRID_PILLAR <= gridType and gridType <= GridEntityType.GRID_ROCK_GOLD) then
                                if gridType == GridEntityType.GRID_ROCKB or gridType == GridEntityType.GRID_PILLAR then
                                    sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1.5, 2, false, 1.25)
                                    game:SpawnParticles (grid.Position, EffectVariant.ROCK_PARTICLE, 10, 5)
                                    room:RemoveGridEntity(grid:GetGridIndex (), 0, true)
                                else
                                    grid:Destroy()
                                end
                            end
                        end
                    end

                    break_grid(room:GetGridEntityFromPos(familiar.Position + 20*Vector(1,1)))
                    break_grid(room:GetGridEntityFromPos(familiar.Position + 20*Vector(1,-1)))
                    break_grid(room:GetGridEntityFromPos(familiar.Position + 20*Vector(-1,1)))
                    break_grid(room:GetGridEntityFromPos(familiar.Position + 20*Vector(-1,-1)))
                end

                if not sfx:IsPlaying(mod.SFX.CowStep) and familiar.Velocity:Length() > 1 then
                    sfx:Play(mod.SFX.CowStep)
                end
            else
                familiar:SetSize(data.ogSize, Vector.One, 12)

                mod:CowIdle(familiar, sprite, data)
                --familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

                familiar.DepthOffset = mod.StallionCons.offset + 5

                local direction = (player.Position - familiar.Position):Normalized()
                local vel = player.Velocity:Normalized()
                --local dot = direction.X*vel.X + direction.Y*vel.Y

                if familiar.Position:Distance(player.Position) < (familiar.Size + player.Size) then
                    local new_vel = -direction
                    if player.Velocity:Length() > 1 then
                        new_vel = new_vel + player.Velocity*2
                    end

                    familiar.Velocity = mod:Lerp(familiar.Velocity, new_vel, 0.1)
                else
                    familiar.Velocity = Vector.Zero
                end

                local velocity = familiar.Velocity
                if velocity.X > 0.05 then
                    data.Direction = 0
                elseif velocity.X < -0.05 then
                    data.Direction = 2
                end
            end

            if familiar.Velocity:Length() > 1 then
                if data.Direction == 0 then
                    if not (sprite:IsPlaying("WalkH") or sprite:IsPlaying("WalkHBody")) then
                        if data.Mounted then
                            sprite:Play("WalkHBody", true)
                        else
                            sprite:Play("WalkH", true)
                        end
                    end
                    sprite.FlipX = false
                elseif data.Direction == 1 then
                    if not sprite:IsPlaying("WalkUp") then
                        sprite:Play("WalkUp", true)
                    end
                    sprite.FlipX = false
                elseif data.Direction == 2 then
                    if not (sprite:IsPlaying("WalkH") or sprite:IsPlaying("WalkHBody")) then
                        if data.Mounted then
                            sprite:Play("WalkHBody", true)
                        else
                            sprite:Play("WalkH", true)
                        end
                    end
                    sprite.FlipX = true
                elseif data.Direction == 3 then
                    if not sprite:IsPlaying("WalkDown") then
                        sprite:Play("WalkDown", true)
                    end
                    sprite.FlipX = false
                end
            elseif not (sprite:IsPlaying("Idle1") or sprite:IsPlaying("Idle2") or sprite:IsPlaying("Idle3")) then
                if data.Direction == 0 then
                    if data.Mounted then
                        if sprite:GetAnimation() ~= "IdleHBody" then
                            sprite:Play("IdleHBody", true)
                        end
                    else
                        if sprite:GetAnimation() ~= "IdleH" then
                            sprite:Play("IdleH", true)
                        end
                    end
                    sprite.FlipX = false
                elseif data.Direction == 1 then
                    if not sprite:IsPlaying("IdleUp") then
                        sprite:Play("IdleUp", true)
                        sprite.FlipX = false
                    end
                elseif data.Direction == 2 then
                    if data.Mounted then
                        if sprite:GetAnimation() ~= "IdleHBody" then
                            sprite:Play("IdleHBody", true)
                        end
                    else
                        if sprite:GetAnimation() ~= "IdleH" then
                            sprite:Play("IdleH", true)
                        end
                    end
                    sprite.FlipX = true
                elseif data.Direction == 3 then
                    if not sprite:IsPlaying("IdleDown") then
                        sprite:Play("IdleDown", true)
                        sprite.FlipX = false
                    end
                end
            end

            if (not room:IsClear()) and rng:RandomFloat() < 0.0025 then
                mod:CowPoop(familiar)
            end

            if familiar.FrameCount % 2*3 == 0 then
                local gridIndex = room:GetClampedGridIndex(familiar.Position)
                room:SetGridPath(gridIndex, 900)

                if familiar:GetData().SkinColor ~= player:GetBodyColor() then
                    mod:UpdateCowCostume(familiar)
                end
            end

            if data.Mounted or player:GetData().Mounted_HC then
                if familiar.Position:Distance(player.Position) > 80 then
                    mod:OutCow(player, familiar)
                    mod:OutIntoCow(player, familiar)
                end
            end

            if sprite:IsEventTriggered("Sound") then
                if sprite:IsPlaying("Idle1") then
                    sfx:Play(mod.SFX.Lick)
                elseif sprite:IsPlaying("Idle2") then
                    sfx:Play(mod.SFX.Cow)
                elseif sprite:IsPlaying("Idle3") then
                    sfx:Play(mod.SFX.MiniBite)
                end
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnCowUpdate, mod.EntityInf[mod.Entity.Cow].VAR)

function mod:OnCowRender(familiar)
    if familiar.SubType == 0 then
        local player = familiar.Player
        if player then
            local sprite = familiar:GetSprite()

            sprite.Color.A = 1
            local position
            if familiar:GetData().Mounted then
                position = player.Position
            else
                position = familiar.Position
            end
            sprite:Render(Isaac.WorldToScreen(position + familiar.SpriteOffset))
            sprite.Color.A = 0
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, mod.OnCowRender, mod.EntityInf[mod.Entity.Cow].VAR)

function mod:OnCowCollision(cow, collider, collision)
    if cow.SubType == 0 then
        local player = cow.Player
        if not cow:GetData().Mounted then
            mod:FamiliarProtection(cow, collider, collision)
        end

        if player and player.Velocity:Length() > mod.StallionCons.minRamSpeed then
            if collider and mod:IsHostileEnemy(collider) and player.Position:Distance(collider.Position) < (player.Size + collider.Size) then
                collider:TakeDamage(30, DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.OnCowCollision, mod.EntityInf[mod.Entity.Cow].VAR)

function mod:UpdateCowCostume(familiar)
    local player = familiar.Player
    if player then
        local sprite = familiar:GetSprite()
        
        local skinColor = player:GetBodyColor()
        familiar:GetData().SkinColor = skinColor
        if skinColor == SkinColor.SKIN_PINK then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body.png")
        elseif skinColor == SkinColor.SKIN_WHITE then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_white.png")
        elseif skinColor == SkinColor.SKIN_BLACK then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_black.png")
        elseif skinColor == SkinColor.SKIN_BLUE then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_blue.png")
        elseif skinColor == SkinColor.SKIN_RED then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_red.png")
        elseif skinColor == SkinColor.SKIN_GREEN then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_green.png")
        elseif skinColor == SkinColor.SKIN_GREY then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_grey.png")
        elseif skinColor == SkinColor.SKIN_SHADOW then
            sprite:ReplaceSpritesheet(5, "hc/gfx/characters/costumes/costume_109_mars_body_shadow.png")
        end
        sprite:LoadGraphics()
    end
end

function mod:CowIdle(familiar, sprite, data)
    if sprite:GetFrame() == 0 then
        if rng:RandomFloat() < 0.01 then
            sprite:Play("Idle"..mod:RandomInt(1,3), true)
        else
            sprite:Play("IdleH", true)
            if sprite.FlipX then
                data.Direction = 2
            else
                data.Direction = 0
            end
        end
    end
end

function mod:OnCowReward()
    for _, cow in ipairs(mod:FindByTypeMod(mod.Entity.Cow)) do
        cow:GetData().PoopLock = false
        mod:CowPoop(cow)
    end
end
--mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnCowReward)

function mod:CowPoop(cow)
    if not cow:GetData().PoopLock then
        local subtype = 0
        if rng:RandomFloat() < 0.2 then
            subtype = 1
        end

        local poop = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, subtype, cow.Position-cow.Velocity, -cow.Velocity:Normalized()*3, cow)


        local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, cow.Position, Vector.Zero, cow):ToEffect()
        local n = 6
        for i=1, n do
            local direction = Vector.FromAngle(i*360/n)*7
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, cow.Position, direction, cow.Player):ToEffect()
            cloud.Timeout = 100
        end
        sfx:Stop(SoundEffect.SOUND_FART)
    end
end

function mod:OnNewRoomCow()
    local value = false
    local room = game:GetRoom()

    local gridSize = room:GetGridSize()
    for index = 1, gridSize do
        local grid = room:GetGridEntity(index)
        if grid and grid:ToPressurePlate() then
            value = true
            break
        end
    end

    for _, cow in ipairs(mod:FindByTypeMod(mod.Entity.Cow)) do
        cow:GetData().PoopLock = value
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoomCow)

function mod:OnStallionCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_SPEED then
		if player:GetData().Mounted_HC then
			player.MoveSpeed = player.MoveSpeed + mod.StallionCons.speedBonus
		end
	end

	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		--Stallion
		local numItem = player:GetCollectibleNum(mod.SolarItems.Stallion)
		local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)

		player:CheckFamiliar(mod.EntityInf[mod.Entity.Cow].VAR, numFamiliars, player:GetCollectibleRNG(mod.SolarItems.Stallion), Isaac.GetItemConfig():GetCollectible(mod.SolarItems.Stallion))
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnStallionCache)


--CALLBACKS
function mod:AddStallionCallbacks()
    mod:RemoveSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnPlayerCowUpdate)

	if mod:SomebodyHasItem(mod.SolarItems.Stallion) then
        mod:AddSillyCallback(mod.ModCallbacks.ON_PLAYER_GAME_UPDATE, mod.OnPlayerCowUpdate)
	end
end
mod:AddStallionCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddStallionCallbacks, mod.SolarItems.Stallion)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddStallionCallbacks)