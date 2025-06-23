local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.bismuthConsts = {
    COIN_CHANCE = 0.25,
    GOLDEN_CHANCE = 0.01,

    QUALITY_UMBRAL = 2,
}


--Bismuth pickup
function mod:BismuthUpdatePickup(pickup)
    local sprite = pickup:GetSprite()
    local data = pickup:GetData()

    if not data.Init then
        data.Init = true

        if pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB then
            sprite:Play("Idle1", true)
        elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+1 then
            sprite:Play("Idle2", true)
        elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+2 then
            sprite:Play("Idle3", true)
        elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+3 then
            sprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/bismuth_golden.png", true)
            if not data.SubType then
                data.SubType = mod:RandomInt(1,3)
                sprite:Play("Idle"..tostring(data.SubType), true)
            end
        end
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    end
    if not data.TrueInit then
        data.TrueInit = true

        if rng:RandomFloat() < 0.5 then sprite.FlipX = true end
    end

    if sprite:IsFinished("Appear1") then
        sprite:Play("Idle1", true)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    elseif sprite:IsFinished("Appear2") then
        sprite:Play("Idle2", true)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    elseif sprite:IsFinished("Appear3") then
        sprite:Play("Idle3", true)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    
    elseif sprite:IsFinished("Collect1") or sprite:IsFinished("Collect2") or sprite:IsFinished("Collect3") then
        pickup:Remove()
    end


end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.BismuthUpdatePickup, mod.EntityInf[mod.Entity.BismuthOre].VAR)

function mod:OnBismuthCollision(pickup, collider)
	local player = collider:ToPlayer()
	local sprite = pickup:GetSprite()
    local data = pickup:GetData()

	if player and not (sprite:IsPlaying("Collect1") or sprite:IsPlaying("Collect2") or sprite:IsPlaying("Collect3")) then
        mod:AddBismuth(1)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(mod.SFX.BismuthPick)

        pickup.Velocity = Vector.Zero
		if pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB then
            sprite:Play("Collect1", true)
        elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+1 then
            sprite:Play("Collect2", true)
        elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+2 then
            sprite:Play("Collect3", true)
        elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+3 then
            sprite:Play("Collect"..tostring(data.SubType or 1), true)
            if rng:RandomFloat() < 0.9 then
                mod:SpawnGoldenBismuth()
            end
        end

        mod:EnableBismuthCounter()
        return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnBismuthCollision, mod.EntityInf[mod.Entity.BismuthOre].VAR)

function mod:SpawnGoldenBismuth()
    local room = game:GetRoom()
    local position = room:GetGridPosition(room:GetClampedGridIndex (room:FindFreePickupSpawnPosition (room:GetRandomPosition(0))))
    local bismuth = mod:SpawnEntity(mod.Entity.BismuthOre, position, Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.BismuthOre].SUB+3)

	local sprite = bismuth:GetSprite()
    local data = bismuth:GetData()

    bismuth.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    data.SubType = data.SubType or mod:RandomInt(1,3)
    sprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/bismuth_golden.png", true)
    sprite:Play("Appear"..tostring(data.SubType), true)
    data.Init = true

    return bismuth
end
function mod:GildBismuth(bismuth)
    local position = bismuth.Position
    local velocity = bismuth.Velocity
    bismuth:Remove()

    local newBismuth = mod:SpawnGoldenBismuth()
    newBismuth.Position = position
    newBismuth.Velocity = velocity
    
end

--STAT

function mod:EnableBismuthCounter()
    if not mod.BismuthSprite then
        mod.BismuthSprite = Sprite()
        mod.BismuthSprite:Load("hc/gfx/pickup_Bismuth.anm2", true)
        mod.BismuthSprite:Play("Idle2", true)
    end
    if not mod.BismuthText then
        mod.BismuthText = Font()
        mod.BismuthText:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
    end
    mod.ModFlags.bismuthRender = true

    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnBismuthRender)
    --mod:RemoveCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_RENDER, mod.BismuthBlockRender)

    mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnBismuthRender)
    --mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_RENDER, mod.BismuthBlockRender, GridEntityType.GRID_ROCKB)
end

function mod:AddBismuth(amount)

    if not mod.savedatarun().bismuthCount then mod.savedatarun().bismuthCount = 0 end

    mod.savedatarun().bismuthCount = math.max(0, math.min(99, mod.savedatarun().bismuthCount + amount))
end 
function mod:GetBismuth()

    if not mod.savedatarun().bismuthCount then mod.savedatarun().bismuthCount = 0 end

    return mod.savedatarun().bismuthCount

end

function mod:OnPlayerHitBismuth(player)
    if mod.savedatarun().bismuthCount == nil then mod.savedatarun().bismuthCount = 0 end
    if mod.savedatarun().bismuthCount > 0 then
        for i=1, mod.savedatarun().bismuthCount do
            local direction = Vector(10,0):Rotated(rng:RandomFloat()*360)
            local idx = mod:RandomInt(0,2)
    
            local pickup = mod:SpawnEntity(mod.Entity.BismuthOre, player.Position, direction, nil, nil, mod.EntityInf[mod.Entity.BismuthOre].SUB+idx)
    
            local sprite = pickup:GetSprite()
            if pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB then
                sprite:Play("Appear1", true)
            elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+1 then
                sprite:Play("Appear2", true)
            elseif pickup.SubType == mod.EntityInf[mod.Entity.BismuthOre].SUB+2 then
                sprite:Play("Appear3", true)
            end
            pickup:GetData().Init = true
        end
        mod.savedatarun().bismuthCount = 0

        sfx:Play(Isaac.GetSoundIdByName("drop_bismuth"))
    end
end

--RENDER
function mod:OnBismuthRender()

    if not mod.ModFlags.bismuthRender then
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnBismuthRender)
        mod:RemoveCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_RENDER, mod.BismuthBlockRender)
    end

    local spriteIcon = mod.BismuthSprite
    local text = mod.BismuthText
    if spriteIcon then

        local dim = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
        local offsetVector = dim / dim:Length() * Options.HUDOffset * 25

		local iconPosition = Vector(38, 68) + offsetVector
		spriteIcon:Render(iconPosition)


        local nBismuth = mod:GetBismuth()
        local bismuthText = ""
        if nBismuth < 10 then
            bismuthText = "0"..tostring(nBismuth)
        else
            bismuthText = tostring(nBismuth)
        end
		--text:DrawString(bismuthText, iconPosition.X + 10 + 2, iconPosition.Y - 11 + 2, KColor(0,0,0,1),0,true)
		text:DrawString(bismuthText, iconPosition.X + 10, iconPosition.Y - 11, KColor(1,1,1,1),0,true)

    end
end

--ITEM QUALITY
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.RerolledBismuthSeeds", {})

function mod:OnCollectibleInitBismuth(pickup)

    if game:GetLevel():GetDimension() == Dimension.DEATH_CERTIFICATE then return end

    local n_bismuth = mod:GetBismuth()
    if n_bismuth > 0 and pickup.SubType > 0 then
        local chance = 1.5/99 * n_bismuth
        local n_seed = pickup.InitSeed

        local flag = false
        for i, seed in ipairs(mod.savedatarun().RerolledBismuthSeeds) do
            if seed == n_seed then
                flag = true
                break
            end
        end

        if not flag then
            table.insert(mod.savedatarun().RerolledBismuthSeeds, pickup.InitSeed)

            local c = chance
            local cc = 0

            while cc < c do
                local next_val = math.min(math.floor(cc) + 1, c)
                local current_chance = next_val - cc

                if rng:RandomFloat() < current_chance and mod:GetItemQuality(pickup.SubType) <= mod.bismuthConsts.QUALITY_UMBRAL then
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true, true, false)
                    --pickup:SetColor(Color(1,1,1,1 ,0.5,0.5,0.5), 15, 1, true, true)
                end

                cc = next_val
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnCollectibleInitBismuth, PickupVariant.PICKUP_COLLECTIBLE)