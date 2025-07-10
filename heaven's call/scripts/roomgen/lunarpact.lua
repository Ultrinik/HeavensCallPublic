local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

mod.lunarPactConsts = {
    BASE_SPAWN_CHANCE = 5,--%
}

function mod:LunarRoomGenerator(door, targetroomdesc, forced)

	local level = game:GetLevel()
	local room = game:GetRoom()


	local extraChance = 0
	local extraMult = 1

	local success = nil

	if mod:SomebodyHasTrinket(mod.Trinkets.Noise) then
		extraMult = extraMult + 1*mod:HowManyTrinkets(mod.Trinkets.Noise)
	end

	if mod:SomebodyHasItem(mod.SolarItems.Mochi) then
		extraMult = extraMult + 1*mod:HowManyItems(mod.SolarItems.Mochi)
	end

	local totalchance = 0
    if mod.savedatasettings().lunarRoomSpawnChance == nil then mod.savedatasettings().lunarRoomSpawnChance = mod.lunarPactConsts.BASE_SPAWN_CHANCE end
    if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0 then
        totalchance = totalchance + (1 - (1-mod.savedatasettings().lunarRoomSpawnChance/100)^2)--You dont add probabilities
    else
        totalchance = totalchance + mod.savedatasettings().lunarRoomSpawnChance/100
    end
    
    totalchance = (totalchance + extraChance) * extraMult
    if forced then totalchance = 1 end

    --lunar crown
    totalchance = totalchance + mod:HowManyTrinkets(mod.Trinkets.Crown) * mod.LunarCrownConts.PACT_CHANCE
    
    --pill bonus
	local pill_bonus = mod.savedatarun().planetariumPillsPermanent or 0
	totalchance = totalchance + pill_bonus/100

	if totalchance > 0 and targetroomdesc.Data then
		if rng:RandomFloat() <= totalchance then

			local newroomdata
			if rng:RandomFloat() < 0.05 then
				newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DEVIL, mod.RoomVariantVecs.Lunar.Y+1, 20)
			else
				newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,9999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DEVIL, RoomShape.ROOMSHAPE_1x1, mod.RoomVariantVecs.Lunar.X, mod.RoomVariantVecs.Lunar.Y, 0, 20, targetroomdesc.Data.Doors)
			end
			targetroomdesc.Data = newroomdata
			targetroomdesc.Flags = 0

			mod:TransformDoor2LunarPact(door, room)
			targetroomdesc.SurpriseMiniboss = false
            
            --lunar crown
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                if player and player:HasTrinket(mod.Trinkets.Crown) then
                    local chance = mod.LunarCrownConts.REROLL_CHANCE ^ player:GetTrinketMultiplier(mod.Trinkets.Crown)
                    if rng:RandomFloat() < chance then
                        player:TryRemoveTrinket(mod.Trinkets.Crown)
                        player:TryRemoveSmeltedTrinket(mod.Trinkets.Crown)

                        local devils_crown = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_DEVILS_CROWN, player.Position, Vector.Zero, player)
                    end
                end
            end
		end
	end
end

function mod:OnLunarPactInterior()
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	mod:ChangeRoomBackdrop(mod.Backdrops.LUNAR)
    game:SetColorModifier(ColorModifier(1,1,1,0),true)

    local statue = mod:SpawnEntity(mod.Entity.LunarStatue, game:GetRoom():GetCenterPos()+Vector(0,-20),Vector.Zero, Isaac.GetPlayer(0))

    mod:PlayRoomMusic(mod.Music.LUNAR_PACT)
    room:SetItemPool(ItemPoolType.POOL_ULTRA_SECRET)

	--Mark pedestals
    for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
        if room:IsFirstVisit() then
            mod:MakeLunarPact(pedestal, true)
        end
    end
end

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
    
    [mod.SolarItems.RedShovel]                      = {RED= 2,     SOUL= 0,     BROKEN= 3},
    [mod.SolarItems.Panspermia]                     = {RED= 1,     SOUL= 0,     BROKEN= 2},
    [mod.SolarItems.Mothership_01]                  = {RED= 2,     SOUL= 0,     BROKEN= 2},
    [mod.SolarItems.Mothership_02]                  = {RED= 2,     SOUL= 0,     BROKEN= 2},
    [mod.SolarItems.Mothership_03]                  = {RED= 2,     SOUL= 0,     BROKEN= 2},
    [mod.SolarItems.Mothership_04]                  = {RED= 2,     SOUL= 0,     BROKEN= 2},
}
if FiendFolio then
    mod.LunarPrices[Isaac.GetItemIdByName("Dice Bag")]                      = {RED= 2,     SOUL= 0,     BROKEN= 1}
    mod.LunarPrices[Isaac.GetItemIdByName("Dichromatic Butterfly")]         = {RED= 2,     SOUL= 0,     BROKEN= 1}
    mod.LunarPrices[Isaac.GetItemIdByName("Birthday Gift")]                 = {RED= 1,     SOUL= 0,     BROKEN= 3}
    mod.LunarPrices[Isaac.GetItemIdByName("Strange Red Object")]            = {RED= 0,     SOUL= 0,     BROKEN= 5}
    mod.LunarPrices[Isaac.GetItemIdByName("Wrong Warp")]                    = {RED= 2,     SOUL= 0,     BROKEN= 2}
    mod.LunarPrices[Isaac.GetItemIdByName("Heart of China")]                = {RED= 1,     SOUL= 0,     BROKEN= 3}
end

function mod:LunarPactDoomSpawn(rng, position, forced)
    local room = game:GetRoom()
    local roomType = room:GetType()

    if not (mod.savedatasettings().UnlockAll or Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("lunar_pact (HC)"))) then
        return
    end

    if forced or (roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss()) then
        local level = game:GetLevel()

        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)

            if door then
                local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)

                if not mod.savedatasettings().lunarRoomSpawnChance then mod.savedatasettings().lunarRoomSpawnChance = mod.lunarPactConsts.BASE_SPAWN_CHANCE end

                if (targetroomdesc and targetroomdesc.Data and targetroomdesc.Data.Type == RoomType.ROOM_DEVIL) and targetroomdesc.VisitedCount == 0 then
                    mod:LunarRoomGenerator(door, targetroomdesc, forced)
                end

                if mod:IsRoomDescLunarPact(targetroomdesc) then

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
