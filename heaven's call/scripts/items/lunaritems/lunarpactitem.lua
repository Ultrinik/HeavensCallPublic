local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()


table.insert(mod.PostLoadInits, {"savedatarun", "LunarPactItems", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatarun.LunarPactItems", {})

--make the item on te ground
function mod:MakeLunarPact(pedestal, override, pool)
    pool = pool or ItemPoolType.POOL_ULTRA_SECRET
    pedestal = pedestal:ToPickup()

    if override then
        local player0 = Isaac.GetPlayer(0)
        player0:AddCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)

        local new_collectible = game:GetItemPool():GetCollectible(pool, true)
        table.insert(mod.savedatarun().LunarPactItems, pedestal.InitSeed)
        pedestal:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, new_collectible, false, true)

        player0:RemoveCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)
    end

    pedestal:GetData().LunarPact = true
    pedestal.AutoUpdatePrice = false
    pedestal.Price = -100

    pedestal:GetData().Price = mod.LunarPrices[pedestal.SubType] or {RED=1, SOUL=0, BROKEN=1}

    --SpawnPrice
    local price = mod:SpawnEntity(mod.Entity.Price, pedestal.Position + Vector(0,23), Vector.Zero, pedestal):ToEffect()
    price:GetData().OriginalPrice = pedestal:GetData().Price
    price:GetData().Force = true
    price.DepthOffset = 9999
    price.Parent = pedestal
    price.RenderZOffset = 69

end

function mod:AddLunarPactPrice(item, price)
    item = item or 0
    price = price or {}
    if tonumber(item) and item > 0 then
        local BROKEN = price.BROKEN or 0
        local RED = price.RED or 0
        local SOUL = price.SOUL or 0

        local total = BROKEN + RED + SOUL

        if total > 5 then
            print("ERROR: THE PRICE FOR ITEM ID: "..tostring(item).." EXCEEDS 5 HEARTS")
        elseif total == 0 then
            print("ERROR: THE PRICE FOR ITEM ID: "..tostring(item).." IS 0 HEARTS")
        else
            mod.LunarPrices[item] = {RED= RED,     SOUL= SOUL,     BROKEN= BROKEN}
        end
    else
        print("ERROR: THE ITEM ID IS NOT VALID")
    end
end

function mod:PriceUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Price].SUB then
        --if (not entity.Parent) or (entity.Parent:ToPickup().Wait == 20) then
        if (not entity.Parent) or (not entity.Parent:GetData().LunarPact) then
            entity:Remove()
            return
        end

        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if (data.Force or entity.FrameCount%5==0) and data.OriginalPrice then
            data.Force = false

            local BROKEN = data.OriginalPrice.BROKEN
            local RED = data.OriginalPrice.RED
            local SOUL = data.OriginalPrice.SOUL

            local nearesPlayer = nil
            for i=0, game:GetNumPlayers ()-1 do
                local player = Isaac.GetPlayer(i)
                if (not nearesPlayer) or player.Position:Distance(entity.Position) < nearesPlayer.Position:Distance(entity.Position) then
                    nearesPlayer = player
                end
            end

            if nearesPlayer then
                local TRUE_BROKEN, TRUE_RED, TRUE_SOUL = mod:TakeLunarPact(nearesPlayer, RED, SOUL, BROKEN)

                if TRUE_BROKEN == "soul" then
                    sprite:Play("soul", true)
                    sprite:RemoveOverlay()

                elseif TRUE_SOUL == nil then --KEEPER
                    local TRUE_BROKEN, TRUE_COINS = mod:TakeLunarPact(nearesPlayer, RED, SOUL, BROKEN)

                    if TRUE_COINS > 0 then
                        sprite:Play("coins", true)
                        sprite:Stop()
                        sprite:SetFrame(TRUE_COINS)
                        sprite:SetOverlayFrame(tostring(TRUE_BROKEN), 0)
                        sprite:SetOverlayRenderPriority(true)
                    else
                        sprite:Play(tostring(TRUE_BROKEN), true)
                        sprite:Stop()
                        sprite:SetFrame(0)
                    end

                else
                    local n = TRUE_BROKEN + TRUE_RED + TRUE_SOUL
                    sprite:Play(tostring(n), true)
                    sprite:Stop()

                    local options = {}
                    for a=0,n do
                        for b=0,n do
                            for c=0,n do
                                if a+b+c == n then
                                    options[a*(n+1)^2 + b*(n+1) + c] = true
                                end
                            end
                        end
                    end

                    local converted = TRUE_BROKEN*(n+1)^2 + TRUE_RED*(n+1) + TRUE_SOUL

                    local counter = 0
                    for i=0,n*(n+1)^2 do
                        if options[i] then
                            if i == converted then
                                break
                            end
                            counter = counter + 1
                        end
                    end

                    counter = sprite:GetFrame(sprite:SetLastFrame()) - counter

                    sprite:SetFrame(counter)
                    sprite:RemoveOverlay()

                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.PriceUpdate, mod.EntityInf[mod.Entity.Price].VAR)

function mod:TakeLunarPact(player, RED, SOUL, BROKEN, apply)

    if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then

        if apply then
            player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL)
        end

        return "soul"
    end

    if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
        local maxHp = 2
        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
            maxHp = 1
        end

        local totalCoins = player:GetNumCoins()
        local necessaryCoins = 5 * RED

        local maxRemainingBrokenHearts = maxHp - (player:GetBrokenHearts()+1)

        while maxRemainingBrokenHearts < BROKEN do
            BROKEN = BROKEN - 1
            necessaryCoins = necessaryCoins + 10
        end
        necessaryCoins = math.min(99, necessaryCoins)

        if apply then

            if necessaryCoins > totalCoins then
                for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                    if pedestal:GetData().LunarPact then
                        pedestal:Remove()
                    end
                end
            end

            --Coins
            player:AddCoins(-necessaryCoins)
            
            --Broken Hearts
            player:AddBrokenHearts(BROKEN)

        end

        return BROKEN, necessaryCoins
    else

        local redHealth = player:GetEffectiveMaxHearts()
        redHealth = math.floor(redHealth/2)
        local blueHealth = player:GetSoulHearts()
        blueHealth = math.floor(blueHealth/2)

        if redHealth < RED then
            SOUL = 3
            RED = math.max(0, RED - 1)
        end
        while redHealth < RED do
            SOUL = SOUL + 1
            RED = math.max(0, RED - 1)
        end
        while blueHealth < SOUL do
            SOUL = math.max(0, SOUL - 2)
            BROKEN = BROKEN + 1
        end
	
		if BROKEN + RED + SOUL > 5 then
			for i=1, 5 do
				SOUL = math.max(0, SOUL-1)
				if BROKEN + RED+ SOUL <= 5 then break end
			end
		end
		if BROKEN + RED + SOUL > 5 then
			for i=1, 5 do
				RED = math.max(0, RED-1)
				if BROKEN + RED + SOUL <= 5 then break end
			end
		end
		if BROKEN + RED + SOUL > 5 then
			for i=1, 5 do
				BROKEN = math.max(0, BROKEN-1)
				if BROKEN + RED + SOUL <= 5 then break end
			end
		end
		
        if RED+SOUL+BROKEN > 5 then return -1 end

        if apply then
            --lost pact
            if player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B or player:HasInstantDeathCurse() then
                for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                    if pedestal:GetData().LunarPact then
                        pedestal:Remove()
                    end
                end

                return 0,0,0
            end

            --Blood
            --player:AddHearts(-2*math.max(0,BROKEN))
        
            --Red hearts
            local boneHearts = player:GetBoneHearts()
            local redHearts = math.floor(player:GetMaxHearts()/2)
        
            if boneHearts >= RED then
                player:AddBoneHearts(-math.max(0,RED))
            else
                player:AddBoneHearts(-math.max(0,boneHearts))
                RED = RED - boneHearts
            end
            player:AddMaxHearts(-2*math.max(0,RED))
        
            --Blue hearts
            player:AddSoulHearts(-2*math.max(0,SOUL))

            if player:GetHearts() <= 0 then
                --player:AddHearts(1)
            end

            --Broken Hearts
            player:AddBrokenHearts(BROKEN)
        

        end

        return BROKEN, RED, SOUL
    end
end

function mod:IncreasePrice(item)
    local data = item:GetData()

    local RED = data.Price.RED
    local SOUL = data.Price.SOUL
    local BROKEN = data.Price.BROKEN

    if RED==1 and BROKEN==0 then
        RED=2
        BROKEN=0
        
    elseif RED==2 and BROKEN==0 then
        RED=0
        BROKEN=1
        
    elseif RED==0 and BROKEN==1 then
        RED=1
        BROKEN=1
        
    elseif RED==1 and BROKEN==1 then
        RED=2
        BROKEN=1
        
    elseif RED==2 and BROKEN==1 then
        RED=0
        BROKEN=2
        
    elseif RED==0 and BROKEN==2 then
        RED=1
        BROKEN=2
        
    elseif RED==1 and BROKEN==2 then
        RED=2
        BROKEN=2
        
    elseif RED==2 and BROKEN==2 then
        RED=0
        BROKEN=3

    end

    data.RED = RED
    data.BROKEN = BROKEN

    --Update sprite
end

function mod:ClearLunarPactItem(pedestal)
    local data = pedestal:GetData()

    local level = game:GetLevel()
    local pacts = mod.savedatarun().LunarPactItems
    for i = #pacts, 1, -1 do
        local pact = pacts[i]
        if pact == pedestal.InitSeed then
            table.remove(pacts, i)
        end
    end

    data.LunarPact = false
    data.Price = nil

end

function mod:PactCollision(pedestal, entity)
    local data = pedestal:GetData()
    if entity.Type == EntityType.ENTITY_PLAYER and data.LunarPact then
        local player = entity:ToPlayer()

        if player:CanPickupItem() and not ('P' == mod:get_char(player:GetSprite():GetAnimation(), 1)) then

            local price = data.Price

            mod:TakeLunarPact(player, price.RED, price.SOUL, price.BROKEN, true)
            
            mod:ClearLunarPactItem(pedestal)

            sfx:Stop(SoundEffect.SOUND_DEVILROOM_DEAL)
            sfx:Play(Isaac.GetSoundIdByName("LunarPact"), 5)
            
            if mod:GetPlayerHearts(player) == 0 then
                player:AddSoulHearts(1)
                mod:scheduleForUpdate(function ()
                    player:AddSoulHearts(-1)
                end,2)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PactCollision, PickupVariant.PICKUP_COLLECTIBLE)

--Dont f up lunar pacts
function mod:OnRerollLunarPact(item)
    --Mark pedestals
    for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        if pedestal:GetData().LunarPact then
            mod:scheduleForUpdate(function()
                mod:MakeLunarPact(pedestal, true)
            end, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnRerollLunarPact, CollectibleType.COLLECTIBLE_D6)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnRerollLunarPact, CollectibleType.COLLECTIBLE_ETERNAL_D6)

function mod:OnLunarPactCollectibleInit(pedestal)
    local level = game:GetLevel()

    local pacts = mod.savedatarun().LunarPactItems
    if pacts then
        for i, pact in ipairs(pacts) do
            if pact == pedestal.InitSeed then
                mod:MakeLunarPact(pedestal, false)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnLunarPactCollectibleInit, PickupVariant.PICKUP_COLLECTIBLE)

function mod:OnCreditCardUse()
    
    local pacts = mod.savedatarun().LunarPactItems
    local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    if pacts then
        for j, pedestal in ipairs(items) do
            for i, pact in ipairs(pacts) do

                if pact == pedestal.InitSeed then
                    mod:ClearLunarPactItem(pedestal)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnCreditCardUse, Card.CARD_CREDIT)