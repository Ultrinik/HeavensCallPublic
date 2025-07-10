local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()
local persistentData = Isaac.GetPersistentGameData()

mod.ModCallbacks = {
    ON_ENEMY_KILL = 1,
    ON_PICKUP_CREATION = 2,
    ON_PLAYER_GAME_UPDATE = 3,
}

mod.DomesticAbuseCallbacks = {}
mod.PickupCreationCallbacks = {}
mod.PlayerGameUpdateCallbacks = {}

function mod:AddSillyCallback(callback, foo, args)
    local tabla
    if callback == mod.ModCallbacks.ON_ENEMY_KILL then
        tabla = mod.DomesticAbuseCallbacks
    elseif callback == mod.ModCallbacks.ON_PICKUP_CREATION then
        tabla = mod.PickupCreationCallbacks
    elseif callback == mod.ModCallbacks.ON_PLAYER_GAME_UPDATE then
        tabla = mod.PlayerGameUpdateCallbacks
    end

    table.insert(tabla, {foo,args})
end
function mod:RemoveSillyCallback(callback, foo, args)
    local tabla
    if callback == mod.ModCallbacks.ON_ENEMY_KILL then
        tabla = mod.DomesticAbuseCallbacks
    elseif callback == mod.ModCallbacks.ON_PICKUP_CREATION then
        tabla = mod.PickupCreationCallbacks
    elseif callback == mod.ModCallbacks.ON_PLAYER_GAME_UPDATE then
        tabla = mod.PlayerGameUpdateCallbacks
    end

    for i = #tabla, 1, -1 do  -- iterate backwards to safely remove
        if tabla[i][1] == foo then
            table.remove(tabla, i)
        end
    end
end

--enemy kill------------------------------------------------------------------------------------
mod.DomesticAbuseSources = {}
--mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "DomesticAbuseSources", {}) BELOW!!!
function mod:OnDomesticAbuse(entity, amount, flags, source, frames)

    local letal = entity.HitPoints <= amount
    if letal then
        local data = entity:GetData()
        if source and source.Entity and mod:IsVulnerableEnemy(entity) and not EntityRef(entity).IsCharmed and not data.LetalFlag_HC then
            data.LetalFlag_HC = true
            mod.DomesticAbuseSources[GetPtrHash(entity)] = {source.Entity, flags}
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnDomesticAbuse)

function mod:OnDomesticAbuseKill(entity)
    local entry = mod.DomesticAbuseSources[GetPtrHash(entity)]
    if entry and entry[1] then
        local source = entry[1]
        local flags = entry[2]

        for i, call_entry in ipairs(mod.DomesticAbuseCallbacks) do
            local func = call_entry[1]
            func(nil, entity, source, flags)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.OnDomesticAbuseKill)

function mod:OnPlayerGameUpdate()
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
            for i, call_entry in ipairs(mod.PlayerGameUpdateCallbacks) do
                local func = call_entry[1]
                func(nil, player)
            end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnPlayerGameUpdate)

--pickup creation------------------------------------------------------------------------------------
local debug_chance_mult = 1
function mod:OnPickupCreatinFunc(func, entity, variant, subType, achievementName, chance, neededVariant, neededSubtype, succesSubtype, gridIndex)
    chance = chance * debug_chance_mult
    --chance = math.min(0.75, chance)

    --[[if (variant == PickupVariant.PICKUP_KEY) or true then
        print("OnPickupCreatinFunc")
        print(achievementName)
        print(variant == neededVariant, variant, neededVariant) -- is the correct variant
        print((subType == neededSubtype or neededSubtype==-1), subType , neededSubtype ) -- is the correct subtype
        print((not (variant == PickupVariant.PICKUP_TAROTCARD and subType == Card.CARD_FOOL and game:GetLevel():GetStage() == LevelStage.STAGE3_2)) ) -- god dont reroll this one
        print(subType ~= succesSubtype) -- dont rereroll (kinda unnessesary)
    end
    --]]

    --if chance == 0.5 then print(((not achievementName) or mod.savedatasettings().UnlockAll or persistentData:Unlocked(Isaac.GetAchievementIdByName(achievementName))), "caca", variant == neededVariant, (subType == neededSubtype or neededSubtype==-1), (not (variant == PickupVariant.PICKUP_TAROTCARD and subType == Card.CARD_FOOL and game:GetLevel():GetStage() == LevelStage.STAGE3_2)), subType ~= succesSubtype) end

    if
    ((not achievementName) or mod.savedatasettings().UnlockAll or persistentData:Unlocked(Isaac.GetAchievementIdByName(achievementName))) and -- its unlocked
    rng:RandomFloat() < chance and -- succes chance
    variant == neededVariant and -- is the correct variant
    (subType == neededSubtype or neededSubtype==-1) and -- is the correct subtype
    (not (variant == PickupVariant.PICKUP_TAROTCARD and subType == Card.CARD_FOOL and game:GetLevel():GetStage() == LevelStage.STAGE3_2)) and -- god dont reroll this one
    subType ~= succesSubtype -- dont rereroll (kinda unnessesary)
    then
        return func(nil, entity, variant, subType, gridIndex)
    end
end

function mod:OnPickupRoomCreation(tipo, variant, subType, gridIndex, seed) -- room creation
    --print("OnPickupRoomCreation",tipo,variant,subType)
    if tipo == EntityType.ENTITY_PICKUP then
        mod.PickupCreationCallbacks = mod:Shuffle(mod.PickupCreationCallbacks)
        for i, entry in ipairs(mod.PickupCreationCallbacks) do
            local func = entry[1]
            local args = entry[2]
            local result = mod:OnPickupCreatinFunc(func, nil, variant, subType, args[1], args[2], args[3], args[4], args[5], gridIndex)
            if result then return result end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.OnPickupRoomCreation)

function mod:OnPickupRewardCreation() -- room reward
    mod:scheduleForUpdate(function()
        for i, _pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
            local pickup = _pickup:ToPickup()
            if pickup and pickup.FrameCount == 0 then
                mod.PickupCreationCallbacks = mod:Shuffle(mod.PickupCreationCallbacks)
                for i, entry in ipairs(mod.PickupCreationCallbacks) do
                    local func = entry[1]
                    local args = entry[2]
                    local result = mod:OnPickupCreatinFunc(func, pickup, pickup.Variant, pickup.SubType, args[1], args[2], args[3], args[4], args[5])
                    if result then return end
                end
            end
        end
    end, 1)
end
--mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnPickupRewardCreation) --covered by function below

function mod:OnPickupLootCreation(pickup) -- chest loot etc
    --print("OnPickupLootCreation", pickup.Variant, pickup.SubType)
    
    local flag1 = game:GetRoom():GetFrameCount() > 1
    and not (pickup.SpawnerEntity and (pickup.SpawnerEntity.Type == EntityType.ENTITY_PLAYER) and (pickup.Position:Distance(pickup.SpawnerEntity.Position) < 25)) -- if its from player and spawns near player

    local flag2 = game:GetRoom():GetFrameCount() == 0
    and not (pickup.SpawnerEntity and (pickup.SpawnerEntity.Type == EntityType.ENTITY_PLAYER) and (pickup.Position:Distance(pickup.SpawnerEntity.Position) < 25)) -- if its from player and spawns near player
    and pickup.Variant == PickupVariant.PICKUP_TAROTCARD and pickup.SubType > Card.CARD_SOUL_JACOB

    if (flag1 or flag2) and
    pickup:GetSprite():IsPlaying("Appear") -- is appearing and not idleing
    then
        --print("hdujsabdjusa")
        mod.PickupCreationCallbacks = mod:Shuffle(mod.PickupCreationCallbacks)
        for i, entry in ipairs(mod.PickupCreationCallbacks) do
            local func = entry[1]
            local args = entry[2]
            local result = mod:OnPickupCreatinFunc(func, pickup, pickup.Variant, pickup.SubType, args[1], args[2], args[3], args[4], args[5])
            if result then return end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnPickupLootCreation)


----------------------------------------------------------------------------------------------------
--flag callbacks------------------------------------------------------------------------------------

mod.FlagCallbacks = {[ModCallbacks.MC_POST_NEW_ROOM] = {}, [ModCallbacks.MC_POST_NEW_LEVEL] = {}, [ModCallbacks.MC_POST_GAME_STARTED] = {}}
function mod:AddResetFlag(callback, fieldName, ogValue)
    if not mod.FlagCallbacks[callback] then mod.FlagCallbacks[callback] = {} end

    table.insert(mod.FlagCallbacks[callback], {FIELDNAME = fieldName, OGVALUE = ogValue})
end

function mod:FlagCallbackRoom()
    for _, entry in ipairs(mod.FlagCallbacks[ModCallbacks.MC_POST_NEW_ROOM]) do
        if type(entry.OGVALUE) == "table" then
            mod:ExecuteResetFlag(entry.FIELDNAME, {})
        else
            mod:ExecuteResetFlag(entry.FIELDNAME, entry.OGVALUE)
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.EARLY, mod.FlagCallbackRoom)

function mod:FlagCallbackState()
    for _, entry in ipairs(mod.FlagCallbacks[ModCallbacks.MC_POST_NEW_LEVEL]) do
        if type(entry.OGVALUE) == "table" then
            mod:ExecuteResetFlag(entry.FIELDNAME, {})
        else
            mod:ExecuteResetFlag(entry.FIELDNAME, entry.OGVALUE)
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.EARLY, mod.FlagCallbackState)

function mod:FlagCallbackRun(isContinued)
    for _, entry in ipairs(mod.FlagCallbacks[ModCallbacks.MC_POST_GAME_STARTED]) do
        if isContinued then
            if type(entry.OGVALUE) == "table" then
                mod:ExecuteSecureResetFlag(entry.FIELDNAME, {})
            else
                mod:ExecuteSecureResetFlag(entry.FIELDNAME, entry.OGVALUE)
            end
        else
            if type(entry.OGVALUE) == "table" then
                mod:ExecuteResetFlag(entry.FIELDNAME, {})
            else
                mod:ExecuteResetFlag(entry.FIELDNAME, entry.OGVALUE)
            end
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.EARLY, mod.FlagCallbackRun)

function mod:ExecuteResetFlag(fieldName, ogValue)

    local fieldNames = mod:split(fieldName, ".")
    local n = #fieldNames

    if 0 == n then
        print("ERROR: No field for table")
    end

    local result = mod
    for i=1, n do
        local fieldName = fieldNames[i]

        if fieldNames[i+1]==nil then
            result[fieldName] = ogValue
            break

        else
            if fieldName:sub(1, 8) == "savedata" then
                result = result[fieldName]()
            else
                result = result[fieldName]
            end
        end
    end
end
function mod:ExecuteSecureResetFlag(fieldName, ogValue)

    local fieldNames = mod:split(fieldName, ".")
    local n = #fieldNames

    if 0 == n then
        print("ERROR: No field for table")
    end

    local result = mod
    for i=1, n do
        local fieldName = fieldNames[i]

        if fieldNames[i+1]==nil then
            if not result[fieldName] then
                result[fieldName] = ogValue
            end
            break

        else
            if fieldName:sub(1, 8) == "savedata" then
                result = result[fieldName]()
            else
                result = result[fieldName]
            end
        end
    end
end

--enemy kill
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "DomesticAbuseSources", {})

--SHADERS-------------
mod.ShaderData.ouroborosEnabled = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.ouroborosEnabled", false)

mod.ShaderData.solData.ENABLED = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.solData.ENABLED", false)

mod.ShaderData.blackHole = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ShaderData.blackHole", false)