local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()

mod.LunarPrices = {
    [CollectibleType.COLLECTIBLE_ABYSS]             = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_D6]                = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_FLIP]              = {RED= 2,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_RED_KEY]           = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BRIMSTONE]         = {RED= 1,     SOUL= 0,     BROKEN= 4},
    [CollectibleType.COLLECTIBLE_C_SECTION]         = {RED= 1,     SOUL= 0,     BROKEN= 4},
    [CollectibleType.COLLECTIBLE_ECHO_CHAMBER]      = {RED= 0,     SOUL= 0,     BROKEN= 3},
    [CollectibleType.COLLECTIBLE_HAEMOLACRIA]       = {RED= 1,     SOUL= 0,     BROKEN= 3},
    [CollectibleType.COLLECTIBLE_SACRED_HEART]      = {RED= 1,     SOUL= 0,     BROKEN= 3},
    [CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM]    = {RED= 1,     SOUL= 0,     BROKEN= 3},
    [CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID]   = {RED= 0,     SOUL= 0,     BROKEN= 3},
    [CollectibleType.COLLECTIBLE_BERSERK]           = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_D20]               = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_DARK_ARTS]         = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_DATAMINER]         = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_ESAU_JR]           = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_GELLO]             = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_IV_BAG]            = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_KAMIKAZE]          = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_KIDNEY_BEAN]       = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_PLAN_C]            = {RED= 0,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_PLUM_FLUTE]        = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_PORTABLE_SLOT]     = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_RED_CANDLE]        = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP]    = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_SULFUR]            = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_YUM_HEART]         = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_HEART]             = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_2SPOOKY]           = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_ABADDON]           = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_ANEMIC]            = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_ANGRY_FLY]         = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_BACKSTABBER]       = {RED= 0,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BFFS]              = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BIRDS_EYE]         = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BLOOD_BAG]         = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_BLOOD_BOMBS]       = {RED= 3,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_BLOOD_CLOT]        = {RED= 0,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BLOOD_PUPPY]       = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_BLOODY_GUST]       = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BLOODY_LUST]       = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BODY]              = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_BOILED_BABY]       = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION]= {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_CANDY_HEART]       = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_CHAMPION_BELT]     = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_CONTAGION]         = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_CUBE_OF_MEAT]      = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_DEAD_EYE]          = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_EYE_OF_BELIAL]     = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT] = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_FALSE_PHD]         = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_HARLEQUIN_BABY]    = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_HEARTBREAK]        = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_HEMOPTYSIS]        = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_HUNGRY_SOUL]       = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_HYPERCOAGULATION]  = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_IMMACULATE_HEART]  = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_ISAACS_HEART]      = {RED= 0,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS]    = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_LIL_LOKI]          = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT]   = {RED= 0,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_LUSTY_BLOOD]       = {RED= 0,     SOUL= 0,     BROKEN= 3},
    [CollectibleType.COLLECTIBLE_MAGIC_SCAB]        = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_MAGNETO]           = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_MARKED]            = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_MARROW]            = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_MEAT]              = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_MOMS_CONTACTS]     = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_MOMS_HEELS]        = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_MOMS_LIPSTICK]     = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_OCULAR_RIFT]       = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_PACT]              = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_PENTAGRAM]         = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_PROPTOSIS]         = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_RED_STEW]          = {RED= 3,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_ROSARY]            = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO]     = {RED= 2,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_SANGUINE_BOND]     = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_SISTER_MAGGY]      = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT]={RED= 1,     SOUL= 0,     BROKEN= 2},
    [CollectibleType.COLLECTIBLE_STEM_CELLS]        = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_VARICOSE_VEINS]    = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_VASCULITIS]        = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_VENGEFUL_SPIRIT]   = {RED= 1,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_VIRUS]             = {RED= 2,     SOUL= 0,     BROKEN= 0},
    [CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON]  = {RED= 1,     SOUL= 0,     BROKEN= 1},
    [CollectibleType.COLLECTIBLE_WORM_FRIEND]       = {RED= 1,     SOUL= 0,     BROKEN= 0},
    
    [mod.Items.Mercurius]                           = {RED= 0,     SOUL= 0,     BROKEN= 2},
    [mod.Items.Venus]                               = {RED= 0,     SOUL= 0,     BROKEN= 2},
    [mod.Items.Terra]                               = {RED= 0,     SOUL= 0,     BROKEN= 3},
    [mod.Items.Mars]                                = {RED= 0,     SOUL= 0,     BROKEN= 2},
    [mod.Items.Jupiter]                             = {RED= 0,     SOUL= 0,     BROKEN= 2},
    [mod.Items.Saturnus]                            = {RED= 0,     SOUL= 0,     BROKEN= 2},
    [mod.Items.Uranus]                              = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [mod.Items.Neptunus]                            = {RED= 1,     SOUL= 0,     BROKEN= 2},
}
if FiendFolio then
    mod.LunarPrices[Isaac.GetItemIdByName("Dice Bag")]                      = {RED= 2,     SOUL= 0,     BROKEN= 1}
    mod.LunarPrices[Isaac.GetItemIdByName("Dichromatic Butterfly")]         = {RED= 2,     SOUL= 0,     BROKEN= 1}
    mod.LunarPrices[Isaac.GetItemIdByName("Birthday Gift")]                 = {RED= 1,     SOUL= 0,     BROKEN= 3}
    mod.LunarPrices[Isaac.GetItemIdByName("Strange Red Object")]            = {RED= 0,     SOUL= 0,     BROKEN= 5}
    mod.LunarPrices[Isaac.GetItemIdByName("Wrong Warp")]                    = {RED= 2,     SOUL= 0,     BROKEN= 2}
    mod.LunarPrices[Isaac.GetItemIdByName("Heart of China")]                = {RED= 1,     SOUL= 0,     BROKEN= 3}
end

function mod:PriceUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.Price].SUB then
        if not entity.Parent then entity:Remove() end

        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if (data.Force or entity.FrameCount%15==0) and data.OriginalPrice then
            data.Force = false
            

            local BROKEN = data.OriginalPrice.BROKEN
            local RED = data.OriginalPrice.RED
            local SOUL = data.OriginalPrice.SOUL

            local nearesPlayer = nil
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i):ToPlayer()
                if (not nearesPlayer) or player.Position:Distance(entity.Position) < nearesPlayer.Position:Distance(entity.Position) then
                    nearesPlayer = player
                end
            end

            if nearesPlayer then
                local TRUE_BROKEN, TRUE_RED, TRUE_SOUL = mod:LunarPact(nearesPlayer, RED, SOUL, BROKEN)

                if TRUE_BROKEN == "soul" then
                    sprite:Play("soul", true)
                    sprite:RemoveOverlay()

                elseif TRUE_SOUL == nil then --KEEPER
                    local TRUE_BROKEN, TRUE_COINS = mod:LunarPact(nearesPlayer, RED, SOUL, BROKEN)

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

function mod:MakeLunarPact(pedestal, noReroll)
    pedestal = pedestal:ToPickup()

    if noReroll then
        pedestal:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, pedestal.SubType)
    else
        local player0 = Isaac.GetPlayer(0)
        player0:AddCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)
        pedestal:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false))
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
end

function mod:LunarPact(player, RED, SOUL, BROKEN, apply)

    if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then

        if apply then
            player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL)
        end

        return "soul"
    end

    if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
        local maxHp = 3
        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
            maxHp = 2
        end

        local totalCoins = player:GetNumCoins()
        local necessaryCoins = 10 * RED

        local maxRemainingBrokenHearts = maxHp - (player:GetBrokenHearts()+1)

        while maxRemainingBrokenHearts < BROKEN do
            BROKEN = BROKEN - 1
            necessaryCoins = necessaryCoins + 15
        end
        necessaryCoins = math.min(99, necessaryCoins)
        
        if apply then
            --Broken Hearts
            player:AddBrokenHearts(BROKEN)

            if necessaryCoins > totalCoins then
                for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                    if pedestal:GetData().LunarPact then
                        pedestal:Remove()
                    end
                end
            end

            --Coins
            player:AddCoins(-necessaryCoins)
        end

        return BROKEN, necessaryCoins
    else

        local redHealth = player:GetEffectiveMaxHearts()
        redHealth = math.floor(redHealth/2)
        local blueHealth = player:GetSoulHearts()
        blueHealth = math.floor(blueHealth/2)

        if redHealth < RED then
            SOUL = 3
            RED = RED - 1
        end
        while redHealth < RED do
            SOUL = SOUL + 1
            RED = RED - 1
        end
    
        while blueHealth < SOUL do
            SOUL = SOUL - 2
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
            --Broken Hearts
            player:AddBrokenHearts(BROKEN)
        
            --Blood
            player:AddHearts(-2*math.max(0,BROKEN))
        
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

            if player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
                for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                    if pedestal:GetData().LunarPact then
                        pedestal:Remove()
                    end
                end
            end

            if player:GetHearts() <= 0 then
                player:AddHearts(1)
            end

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

function mod:PactCollision(pedestal, entity)
    local data = pedestal:GetData()
    if entity.Type == EntityType.ENTITY_PLAYER and data.LunarPact then
        local price = data.Price

        local oldSubType = pedestal.SubType

        mod:scheduleForUpdate(function()
            if oldSubType ~= pedestal.SubType then

                mod:LunarPact(entity:ToPlayer(), price.RED, price.SOUL, price.BROKEN, true)
                
                sfx:Stop(SoundEffect.SOUND_DEVILROOM_DEAL)
                sfx:Play(Isaac.GetSoundIdByName("LunarPact"), 5)
                --entity:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false)
        
                data.LunarPact = false
                data.Price = nil
        
                --Increase price
                for _, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                    if item:GetData().LunarPact then
                        --mod:IncreasePrice(item)
                    end
                end
            end
        end, 2)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PactCollision, PickupVariant.PICKUP_COLLECTIBLE)

function mod:LunarPactDoomSpawn()
    local room = game:GetRoom()
    local roomType = room:GetType()

    if roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss() then
        local level = game:GetLevel()
        
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)

            if door then
                local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
                
                if not mod.ModConfigs.lunarRoomSpawnChance then mod.ModConfigs.lunarRoomSpawnChance = 5 end

                if not mod.ModFlags.LunarPactInStage[level:GetStage()] 
                and level:GetStage() > LevelStage.STAGE1_2 
                and (targetroomdesc and targetroomdesc.Data and targetroomdesc.Data.Type == RoomType.ROOM_DEVIL) 
                and (rng:RandomFloat() < mod.ModConfigs.lunarRoomSpawnChance/100)
                and targetroomdesc.VisitedCount == 0 then
                    --Initialize mod.pactroomdata if nil
                    if not mod.pactroomdata then
                        mod:InitializeRoomsData()
                    end

                    local data
                    if rng:RandomFloat() < 0.05 then
                        data = mod.pactroomdata[mod.maxlunarvariant]
                    else
                        data = mod.pactroomdata[mod:RandomInt(mod.minlunarvariant, mod.maxlunarvariant-1)]
                    end
                    targetroomdesc.Data = data
                    targetroomdesc.Flags = 0
                    
                    mod.ModFlags.LunarPactInStage[level:GetStage()] = true
                end
                
                if mod:IsRoomDescLunarPact(targetroomdesc) then

                    mod:TransformDoor2LunarPact(door, room)

                    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD)) do
                        if effect.Position:Distance(door.Position) < 100 then
                            effect:GetSprite().Color = Color(1,0,0,1)
                        end
                    end
                    if sfx:IsPlaying(SoundEffect.SOUND_SATAN_ROOM_APPEAR) then
                        sfx:Stop(SoundEffect.SOUND_SATAN_ROOM_APPEAR)
                        sfx:Play(Isaac.GetSoundIdByName("LunarPactSpawn"), 2)
                    end
                end
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.LunarPactDoomSpawn)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.LunarPactDoomSpawn)
