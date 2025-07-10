local mod = HeavensCall
local game = Game()
local persistentGameData = Isaac.GetPersistentGameData()
local sfx = SFXManager()

mod.RNGS = {}
function mod:GetRunRNG()

	local newrng = RNG()
	table.insert(mod.RNGS, newrng)

	return newrng
end

function mod:SetSeedToRNGs()
	local prevrng
	for i, rng in ipairs(mod.RNGS) do
		local shift = 1
		if prevrng then shift = math.ceil(prevrng:RandomFloat()*80) end
		if shift == 0 then shift = 1 end

		rng:SetSeed(game:GetSeeds():GetStartSeed(), shift)

		prevrng = rng
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.SetSeedToRNGs)

local rng = mod:GetRunRNG()

--MATH AND LUA THINGS---------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- Random int between Min and Max, both inclusive
function mod:RandomInt(Min, Max, _rng)
	_rng = _rng or rng
    if Min > Max then 
        print("El minimo ta' ma grande")
    else
        return Min + _rng:RandomInt(Max + 1 - Min)
    end
end

--Return the nearest integer from n in a list
function mod:Takeclosest(list, n)
    local difference = math.abs(list[1]-n)
	local current = list[1]
	for i=2, #list do
		if (math.abs(list[i]-n) < difference) then
			difference = math.abs(list[i]-n)
			current = list[i]
		end
	end
	return current
end

--Shuffles a list, from Tainted Treasure
function mod:Shuffle(list)
	for i = #list, 2, -1 do
		local j = mod:RandomInt(1, i)
		list[i], list[j] = list[j], list[i]
	end
	return list
end

--Random Element from table
function mod:random_elem(tb)
    local keys = {}
    for k in pairs(tb) do table.insert(keys, k) end

	if #keys==0 then
		return nil
	end

    return tb[keys[math.random(#keys)]]
end

--U know this thing
function mod:MarkovTransition(state, chain)
	local roll = math.random()
	for i = 1, #chain+1 do
		roll = roll - chain[state][i]
		if roll <= 0 then
			return i - 1
		end
	end
	print("WARNING: A state chain without a sum of 1 is present")
	return -1
end
function mod:MiniMarkovTransition(chain)
	local roll = math.random()
	for i = 1, #chain do
		roll = roll - chain[i]
		if roll <= 0 then
			return i - 1
		end
	end
	return "lol lmao"
end

--Get index with the lowest value (size 3)
function mod:get_lowest_index(arr)

    local lowest_index = 1
    if arr[2] < arr[lowest_index] then
        lowest_index = 2
    end
    if arr[3] < arr[lowest_index] then
        lowest_index = 3
    end

    return lowest_index
end

function mod:getMaxValueFromTable(tbl)
    local maxValue = nil
	local maxIndex = nil

    for index, value in pairs(tbl) do
        if maxValue == nil or value > maxValue then
            maxValue = value
			maxIndex = index
        end
    end

    return maxIndex, maxValue
end

function mod:split(input, separator)
    local result = {}
    local pattern = string.format("([^%s]+)", separator)
    
    for match in input:gmatch(pattern) do
        table.insert(result, match)
    end
    
    return result
end

function mod:Lerp(vec1, vec2, percent)
    return vec1 * (1 - percent) + vec2 * percent
end
function mod:AngleLerp(a, b, t)
    -- Ensure both angles are within -180 to 180
    a = (a + 180) % 360 - 180
    b = (b + 180) % 360 - 180

    -- Calculate the difference and adjust for shortest path
    local diff = b - a
    if diff > 180 then
        diff = diff - 360
    elseif diff < -180 then
        diff = diff + 360
    end

    -- Perform the lerp and ensure the result stays within -180 to 180
    local result = (a + diff * t + 180) % 360 - 180
    return result
end
function mod:VectorLerp(vec1, vec2, percent)
	local l1 = vec1:Length()
	local l2 = vec2:Length()
	local l = mod:Lerp(l1, l2, percent)
    return mod:UVectorLerp(vec1, vec2, percent) * l
end
function mod:UVectorLerp(vec1, vec2, percent)
	local angle1 = vec1:GetAngleDegrees()
	local angle2 = vec2:GetAngleDegrees()
	local angle = mod:AngleLerp(angle1, angle2, percent)
    return Vector.FromAngle(angle)
end


function mod:getFilteredNewEntities(oldEntities, newEntities)
    local oldEntityList = {}
    local filteredEntities = {}
  
    for _, v in pairs(oldEntities) do
      local hash = GetPtrHash(v)
      oldEntityList[hash] = true
    end
    
    for _, v in pairs(newEntities) do
      local hash = GetPtrHash(v)
      if not oldEntityList[hash] then
        table.insert(filteredEntities, v)
      end
    end
  
    return filteredEntities
end

function mod:cubic_interpolation(x, x_points, y_points)
    local n = #x_points - 1

    -- Find the index of the interval [x_k, x_{k+1}] that contains x
    local k = 1
    while k < n and x > x_points[k + 1] do
        k = k + 1
    end

    -- Ensure k is in a valid range
    k = math.max(1, math.min(n - 1, k))

    -- Compute the coefficients of the cubic polynomial
    local h = x_points[k + 1] - x_points[k]
    local t = (x - x_points[k]) / h
    local t2 = t * t
    local t3 = t2 * t

    local a = -t3 + 2 * t2 - t
    local b = 3 * t3 - 5 * t2 + 2
    local c = -3 * t3 + 4 * t2 + t
    local d = t3 - t2

    -- Evaluate the cubic polynomial to get the interpolated values
    local y_interp = a * y_points[k] + b * y_points[k + 1] + c * (y_points[k + 1] - y_points[k]) + d * (y_points[k] - y_points[k + 1])

    return y_interp
end

function mod:randomPointOnPerimeter(p1, p2)
    local minX, minY = math.min(p1.X, p2.X), math.min(p1.Y, p2.Y)
    local maxX, maxY = math.max(p1.X, p2.X), math.max(p1.Y, p2.Y)

    local side = mod:RandomInt(1,4) -- Randomly choose one of the four sides

    local x, y
    if side == 1 then -- Top side
        x = rng:RandomFloat() * (maxX - minX) + minX
        y = minY
    elseif side == 2 then -- Right side
        x = maxX
        y = rng:RandomFloat() * (maxY - minY) + minY
    elseif side == 3 then -- Bottom side
        x = rng:RandomFloat() * (maxX - minX) + minX
        y = maxY
    else -- Left side
        x = minX
        y = rng:RandomFloat() * (maxY - minY) + minY
    end

    return Vector(x,y)
end

function mod:crop_angle(angle, a, b)
    -- Ensure angle, a, and b are within 0 to 359
    angle = angle % 360
    a = a % 360
    b = b % 360

    -- Ensure b is greater than a
    if b <= a then
        b = b + 360
    end

    if angle >= a and angle <= b then
        -- If the angle is within the interval [a, b], return either a or b
        if (angle - a) < (b - angle) then
            return a
        else
            return b
        end
    else
        -- If the angle is outside the interval [a, b], return the original angle
        return angle
    end
end

function mod:tablefind(tab,el)
	for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end

function mod:mean(t)
    local sum = 0
    for i = 1, #t do
        sum = sum + t[i]
    end
    return sum / #t
end

function mod:standard_deviation(t)
    local m = mod:mean(t)
    local sum_sq_diff = 0

    for i = 1, #t do
        sum_sq_diff = sum_sq_diff + (t[i] - m) ^ 2
    end

    return math.sqrt(sum_sq_diff / #t)
end

function mod:transposeMatrix(matrix)
    local rows = #matrix
    local cols = #matrix[1]
  
    local transposedMatrix = {}
  
    for i = 1, cols do
      transposedMatrix[i] = {}
      for j = 1, rows do
        transposedMatrix[i][j] = matrix[j][i]
      end
    end
  
    return transposedMatrix
end

function mod:checkSums(matrix)
    for state, row in pairs(matrix) do
        local sum = 0
        for _, value in ipairs(row) do
            sum = sum + value
        end
        if math.abs(sum - 1) > 0.0001 then  -- Allowing for a small floating-point tolerance
            print("Row for state " .. state .. " does not add to 1. Sum: " .. sum)
        else
            print("Row for state " .. state .. " adds to 1.")
        end
    end
end

function mod:DotProduct(v1, v2)
    return v1.X * v2.X + v1.Y * v2.Y
end

function mod:table_remove_element(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            table.remove(tbl, i)
            return true -- Return true if the value was found and removed
        end
    end
    return false -- Return false if the value was not found
end

function mod:NormalizeTable(tabla)
	for key, values in ipairs(tabla) do
		tabla[key] = mod:NormalizeList(values)
	end
	return tabla
end
function mod:NormalizeList(lista)
	local total_sum = 0
	for index, value in ipairs(lista) do
		total_sum = total_sum + value
	end

	local new_values = {}
	for index, value in ipairs(lista) do
		new_values[index] = value/total_sum
	end
	return new_values
end

function mod:PushControlPoint(P0, P1, PC, strength)
	local dx = P1.X - P0.X
	local dy = P1.Y - P0.Y

	local nx = -dy
	local ny = dx

	local len = math.sqrt(nx * nx + ny * ny)
	nx = nx / len
	ny = ny / len

	local newPC = Vector(PC.X + nx * strength, PC.Y + ny * strength)
	return newPC
end

function mod:GetBezierPosition(t, P0, P1, PC)
	
	--PC = mod:PushControlPoint(P0, P1, PC, 100)
	--PC = Isaac.GetPlayer(0).Position
	
	--local direction = (P1 - P0):Normalized():Rotated(-90)
	--PC = PC + direction*125

	local p0x = P0.X
	local p0y = P0.Y

	local p1x = P1.X
	local p1y = P1.Y
	
	local pcx = PC.X
	local pcy = PC.Y

	local x = (1 - t)^2 * p0x + 2 * (1 - t) * t * pcx + t^2 * p1x
    local y = (1 - t)^2 * p0y + 2 * (1 - t) * t * pcy + t^2 * p1y
    
	return Vector(x,y)
end

function mod:set_char(s, n, new_char)
    return string.sub(s, 1, n - 1) .. new_char .. string.sub(s, n + 1)
end
function mod:get_char(s, n)
    return string.sub(s, n, n)
end

function mod:remove_bit(x, i)
  local lower = x & ((1 << i) - 1)
  local upper = x >> (i + 1)
  return lower | (upper << i)
end

function mod:push_ones_left(n, bits)
	local count = 0
	local temp = n
	while temp > 0 do
		if temp & 1 == 1 then count = count + 1 end
		temp = temp >> 1
	end
	return ((1 << count) - 1) << (bits - count)
end

function mod:IsPointInCapsule(P, A, B, r)
    -- Vector subtraction: AB = B - A
    local AB = Vector(B.X - A.X, B.Y - A.Y)
    local AP = Vector(P.X - A.X, P.Y - A.Y)

    local AB_len_sq = AB.X * AB.X + AB.Y * AB.Y

    if AB_len_sq == 0 then
        -- Degenerate capsule: just a circle at A
        local dx = P.X - A.X
        local dy = P.Y - A.Y
        return dx * dx + dy * dy <= r * r
    end

    -- Project point P onto line AB and clamp t to [0, 1]
    local t = (AP.X * AB.X + AP.Y * AB.Y) / AB_len_sq
    t = math.max(0, math.min(1, t))

    -- Closest point on segment AB to P
    local closest = Vector(A.X + t * AB.X, A.Y + t * AB.Y)

    -- Distance from P to closest point
    local dx = P.X - closest.X
    local dy = P.Y - closest.Y

    return dx * dx + dy * dy <= r * r
end

function mod:GetDateTime()
	return os.date("*t")
end

--ISAAC THINGS----------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

--Somebody as X item?
function mod:SomebodyHasItem(item)
	return PlayerManager.AnyoneHasCollectible(item)
	--[[
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player:HasCollectible (item,true) then 
			return true
		end
	end
	return false
	]]--
end
--How many X items are
function mod:HowManyItems(item)
	local n = 0
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			n = n + player:GetCollectibleNum(item)
		end
	end
	return n
end

--Somebody as X trinket?
function mod:SomebodyHasTrinket(trinket)
	return PlayerManager.AnyoneHasTrinket(trinket)
	--[[
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player:HasTrinket(trinket,false) then 
			return true
		end
	end
	return false
	]]--
end
--How many X trinkets are
function mod:HowManyTrinkets(trinket)
	local n = 0
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player then
			n = n + player:GetTrinketMultiplier(trinket)
		end
	end
	return n
end

--trinkets in existence in room
function mod:IsTrinketInRoom(trinket)
	if mod:SomebodyHasTrinket(trinket) then
		 return true
	end

	for i, t in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
		if t.SubType == trinket then
			return true
		end
	end

	return false
end

--Somebody is X
function mod:SomebodyHasTransformation(transformation)
	for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player:HasPlayerForm(transformation) then 
			return true
		end
	end
	return false
end

function mod:IsOutsideRoom(point, room)
	room = room or game:GetRoom()

	local marginX = 50
	local marginY = 50

	local varX = room:GetCenterPos(0).X - point.X
	local varY = room:GetCenterPos(0).Y - point.Y
	if varX > 0 then --p left
		if varY > 0 then--p up
			point = Vector(point.X - 1.65*marginX , point.Y - 1.65*marginY)
		else--p down
			point = Vector(point.X - 1.65*marginX , point.Y + marginY)
		end
	else --p right
		if varY > 0 then--p up
			point = Vector(point.X + 0.95*marginX , point.Y - 1.65*marginY)
		else--p down
			point = Vector(point.X + 0.95*marginX , point.Y + marginY)
		end
	end

	if room:GetGridIndex(point) == -1 then 
		return true 
	else
		return false
	end
end

--Check unlocks (not really, but close)
function mod:CheckVoidUnlock()
	return persistentGameData:Unlocked(Achievement.VOID_FLOOR)

	--[[
	local itemsFromVoid = {}
	itemsFromVoid[1] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DELIRIOUS)
	itemsFromVoid[2] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_D_INFINITY)
	itemsFromVoid[3] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_EUCHARIST)
	itemsFromVoid[4] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SHADE)
	itemsFromVoid[5] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_KING_BABY)
	itemsFromVoid[6] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DULL_RAZOR)
	itemsFromVoid[7] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE)
	itemsFromVoid[8] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_EDENS_SOUL)
	itemsFromVoid[9] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_EUTHANASIA)
	itemsFromVoid[10] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_CROOKED_PENNY)
	itemsFromVoid[11] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_VOID)
	itemsFromVoid[12] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD)
	itemsFromVoid[13] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM)
	itemsFromVoid[14] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SUPLEX)
	itemsFromVoid[15] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SPINDOWN_DICE)
	itemsFromVoid[16] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HYPERCOAGULATION)
	itemsFromVoid[17] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)
	itemsFromVoid[18] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DARK_ARTS)
	itemsFromVoid[19] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_IBS)
	itemsFromVoid[20] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM)
	itemsFromVoid[21] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BERSERK)
	itemsFromVoid[22] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HEMOPTYSIS)
	itemsFromVoid[23] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_FLIP)
	itemsFromVoid[24] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS)
	itemsFromVoid[25] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_GELLO)
	itemsFromVoid[26] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_KEEPERS_KIN)
	itemsFromVoid[27] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ABYSS)
	itemsFromVoid[28] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_DECAP_ATTACK)
	itemsFromVoid[29] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LEMEGETON)
	itemsFromVoid[30] = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ANIMA_SOLA)
	
	for i=1, #itemsFromVoid do
		if itemsFromVoid[i]:IsAvailable() then
			return true
		end
	end
	return false
	]]--
end
function mod:CheckChestUnlock()
	local level = game:GetLevel()
	local corpseFlag = mod:AreWeOnCorpse()

	if level:GetStage() == LevelStage.STAGE5 then
		if level:GetStageType() == StageType.STAGETYPE_ORIGINAL and persistentGameData:Unlocked(Achievement.NEGATIVE) then--Sheol
			return true
		elseif level:GetStageType() == StageType.STAGETYPE_WOTL and persistentGameData:Unlocked(Achievement.POLAROID) then--Cathedral
			return true
		end
	elseif corpseFlag then
		return persistentGameData:Unlocked(Achievement.NEGATIVE) or persistentGameData:Unlocked(Achievement.POLAROID)
	end
	return false


	--[[
	polaroid = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_POLAROID)
	negative = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NEGATIVE)
	
	if level:GetStage() == LevelStage.STAGE5 then
		if level:GetStageType() == StageType.STAGETYPE_ORIGINAL and negative:IsAvailable() then--Sheol
			return true
		elseif level:GetStageType() == StageType.STAGETYPE_WOTL and polaroid:IsAvailable() then--Cathedral
			return true
		end
		
	end
	return false
	]]--
end

function mod:AreWeOnCorpse()
	local level = game:GetLevel()
	local levelStage = level:GetStage()
	local corpseFlag = ( (LevelStage.STAGE4_1 <= levelStage and levelStage == LevelStage.STAGE4_2) and ( level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B )) or (LastJudgement and LastJudgement.STAGE.Mortis:IsStage())
	return corpseFlag
end

function mod:CheckCorrectPolaroid()
	
	local level = game:GetLevel()

	if level:GetStage() == LevelStage.STAGE5 then
		if level:GetStageType() == StageType.STAGETYPE_ORIGINAL and mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_NEGATIVE) then--Sheol
			return true
		elseif level:GetStageType() == StageType.STAGETYPE_WOTL and mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_POLAROID) then--Cathedral
			return true
		end
		
	end
	return false
end

--Look at the correct direction
function mod:FaceTarget(entity, target, reverse)
	local condition = entity.Position.X < target.Position.X
	if reverse then condition = not condition end

	if condition then
		entity:GetSprite().FlipX = true
	else
		entity:GetSprite().FlipX = false
	end

	if entity:GetData().Ass == false then 
		entity:GetSprite().FlipX = not entity:GetSprite().FlipX
	end
end

--def stage
function mod:defaultStageOfFloor(StageOffset)
    if (StageOffset == 0) then
        print("Attempting to get default stage of floor 0. This is not recommended")
        Isaac.DebugString("Attempting to get default stage of floor 0. This is not recommended")
        return 0
    elseif (StageOffset <= 8) then
        return math.ceil(StageOffset/2) * 3 -2
    else
        return 10 + (StageOffset-8) * 2
    end
end

--Is an enemy
function mod:IsHostileEnemy(entity)
	entity = entity and entity:ToNPC()
	if entity then
		local r = entity and entity:IsActiveEnemy() and entity:IsEnemy() and entity.CanShutDoors and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
		return r
	end
end
function mod:IsVulnerableEnemy(entity)
	entity = entity and entity:ToNPC()
	if entity then
		local r = mod:IsHostileEnemy(entity) and entity:IsVulnerableEnemy()
		return r
	end
end

--check if the same player
function mod:ComparePlayer(player1, player2)
	if player1:ToPlayer():GetCollectibleRNG(1):GetSeed() == player2:ToPlayer():GetCollectibleRNG(1):GetSeed() then
		return true
	end
	return false
end

--get player "Id"
function mod:PlayerId(player)
	if player and player:ToPlayer() then
		return player:GetCollectibleRNG(1):GetSeed()
	else
		return -1
	end
end

function mod:GetNumOfTearShots(player)
	local mutantNum = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
	local mutantBonus = (mutantNum > 0 and 3) or 0
	mutantBonus = mutantBonus + math.max(0, mutantNum-1)*2

	local innerNum = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE)
	local innerBonus = (innerNum > 0 and 2) or 0
	innerBonus = innerBonus + math.max(0, innerNum-1)

	local nerdNum = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20)
	local nerdBonus = (nerdNum > 0 and 1) or 0
	nerdBonus = nerdBonus + math.max(0, nerdNum-1)

	local wizNum = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ)
	local wizBonus = (wizNum > 0 and 1) or 0
	wizBonus = wizBonus + math.max(0, wizNum-1)

	local conjoinedBonus = 0
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
		conjoinedBonus = conjoinedBonus + 2
	end

	local keeperBonus = ( (player:GetPlayerType() == PlayerType.PLAYER_KEEPER) and 2) or ( (player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) and 3) or 0

	return math.min(16, mutantBonus+innerBonus+nerdBonus+wizBonus+keeperBonus+conjoinedBonus)
end

--Charge active with Bethanies charges (for Saturnus? and Mars?)
function mod:TolaterateBethanyCharge(player, slot, maxCharges, flags)
	local resetState = function(ogCurrentCharges)
		mod:scheduleForUpdate(function()
			player:SetActiveCharge(ogCurrentCharges, slot)
			--dont remember what is this "flags == 1"
			if flags == 1 then player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.Items.Mars)) end
		end,2)
	end
	
	if player:GetPlayerType() == PlayerType.PLAYER_BETHANY or player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
		local ogCurrentCharges = player:GetActiveCharge(slot)
		local currentCharges = math.floor(4 * player:GetActiveCharge(slot) / maxCharges)
		
		local specialCharges = player:GetEffectiveSoulCharge()
		if player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then specialCharges = player:GetEffectiveBloodCharge() end

		if currentCharges ~= maxCharges and specialCharges < (4 - currentCharges) then
			if player:GetPlayerType() == PlayerType.PLAYER_BETHANY then player:SetSoulCharge(specialCharges + 1)
			else player:SetBloodCharge(specialCharges + 1) end
			
			resetState(ogCurrentCharges)

			return false
		else
			
			if player:GetPlayerType() == PlayerType.PLAYER_BETHANY then player:SetSoulCharge(specialCharges + 1 - (4 - currentCharges))
			else player:SetBloodCharge(specialCharges + 1 - (4-currentCharges)) end
		end

	end
end

--Get the entity player from some source entity
function mod:GetPlayerFromSource(source)
	return source and (source:ToPlayer() or source:ToFamiliar() and source:ToFamiliar().Player or source.SpawnerEntity and (source.SpawnerEntity:ToPlayer() or source.SpawnerEntity:ToFamiliar() and source.SpawnerEntity:ToFamiliar().Player))
end

-- Move to a specific position, some weird lerp
function mod:MoveTowards(entity, data, objective, velocity)
	if entity.Position:Distance(objective) < 45 then
		entity.Velocity = Vector.Zero
		--entity.Position = objective
		data.MoveTowards = false
	else
		data.targetvelocity = (objective - entity.Position):Normalized()*2
		--Do the actual movement
		entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * velocity
	end
end

--Is there a Lilith?
function mod:IsThereLilith()
	return PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_LILITH)
	--[[
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player and player:GetPlayerType() == PlayerType.PLAYER_LILITH then 
			return true
		end
	end
    return false
	]]--
end

--Clean the room from trashy things.
function mod:CleanRoom()
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TINY_BUG))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TINY_FLY))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WORM))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BEETLE))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WALL_BUG))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BUTTERFLY))
	mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT))

	local room = game:GetRoom()
	for i=0, room:GetGridSize()-1 do
		local grid = room:GetGridEntity(i)
		if grid then
			if grid:GetType() == GridEntityType.GRID_DECORATION then
				grid:GetSprite():Load("", true)
			end
		end
	end
end

--Get random post
function mod:GetRandomPosition(originalPos, range, targetPos)
    if not targetPos then
        targetPos = originalPos
    end
    local room = game:GetRoom()

    local position = room:GetRandomPosition(0)
    if originalPos and range then
        for i=1, 100 do
            if position:Distance(originalPos) > range and position:Distance(targetPos) > range then break end
            position = room:GetRandomPosition(0)
        end
    end
    return position
end

function mod:GetSlotOfActive(player, item)
	if player:HasCollectible(item) then
		local slot
		if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == item then
			slot = ActiveSlot.SLOT_PRIMARY
		elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == item then
			slot = ActiveSlot.SLOT_SECONDARY 
		elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == item then
			slot = ActiveSlot.SLOT_POCKET 
		end

		return slot
	end
end

function mod:RandomVector(scale, minScale)
	scale = (scale or 1)
	minScale = (minScale or 0)
	local magnitude = (scale-minScale) * rng:RandomFloat() + minScale
	local angle = 360*rng:RandomFloat()
	return Vector(magnitude, 0):Rotated(angle)
end

function mod:AddGulpedTrinket(player, trinket, firstTimePickingUp)
	player:AddSmeltedTrinket(trinket, firstTimePickingUp)

	--[[
    local t1 = player:GetTrinket(0)
    local t2 = player:GetTrinket(1)
    if t1 > 0 then
        player:TryRemoveTrinket(t1)
    end
    if t2 > 0 then
        player:TryRemoveTrinket(t2)
    end

    player:AddTrinket(trinket)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
    
    if t1 > 0 then
        player:AddTrinket(t1, false)
    end
    if t2 > 0 then
        player:AddTrinket(t2, false)
    end
	]]--
end

function mod:GetListOfItems(player, banType)

	local listOfItems = player:GetCollectiblesList()
	local finalList = {}
	for item=1, #listOfItems do
		if listOfItems[item] > 0 and ((not banType) or Isaac.GetItemConfig():GetCollectible(item).Type ~= banType) then
			table.insert(finalList, item)
		end
	end
	return finalList

	--[[
	local listOfItems = {}

	local index = 1
	local totalItems = Isaac.GetItemConfig():GetCollectibles().Size - 1
	for item=1, totalItems do

		if player:HasCollectible(item) and ((not banType) or Isaac.GetItemConfig():GetCollectible(item).Type ~= banType) then
			
			if not (player:GetPlayerType() == PlayerType.PLAYER_THELOST and item == CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
				listOfItems[index] = item
				index = index + 1
			end
		end
	end
	return listOfItems
	]]--
end

function mod:GetRandomCurse(iteration, banned)
	banned = banned or 0
	iteration = iteration or 0
	local curse

	local max = 5
	if CURCOL then
		max = 11
	end

	local random = mod:RandomInt(1, max)

	if random == 1 then
		curse = LevelCurse.CURSE_OF_DARKNESS
	elseif random == 2 then
		curse = LevelCurse.CURSE_OF_THE_LOST
	elseif random == 3 then
		curse = LevelCurse.CURSE_OF_THE_UNKNOWN
	elseif random == 4 then
		curse = LevelCurse.CURSE_OF_MAZE
	elseif random == 5 then
		curse = LevelCurse.CURSE_OF_BLIND
	elseif CURCOL and random == 6 then
		curse = Isaac.GetCurseIdByName("Curse of Famine")
		curse = 1 << (curse - 1)
	elseif CURCOL and random == 7 then
		curse = Isaac.GetCurseIdByName("Curse of Decay")
		curse = 1 << (curse - 1)
	elseif CURCOL and random == 8 then
		curse = Isaac.GetCurseIdByName("Curse of Blight")
		curse = 1 << (curse - 1)
	elseif CURCOL and random == 9 then
		curse = Isaac.GetCurseIdByName("Curse of Conquest")
		curse = 1 << (curse - 1)
	elseif CURCOL and random == 10 then
		curse = Isaac.GetCurseIdByName("Curse of Rebirth")
		curse = 1 << (curse - 1)
	elseif CURCOL and random == 11 then
		curse = Isaac.GetCurseIdByName("Curse of Creation")
		curse = 1 << (curse - 1)
	end

	if iteration > 100 then return LevelCurse.CURSE_NONE end

	if (game:GetLevel():GetCurses() & curse > 0) or (curse & banned > 0) then
		return mod:GetRandomCurse(iteration+1)
	else
		return curse
	end

end
function mod:CountCurses()
	local level = game:GetLevel()

	local count = 0
	for i=1, LevelCurse.NUM_CURSES do
		curse = 1 << (i - 1)
		if level:GetCurses() & curse > 0 then
			count = count + 1
		end
	end
	return count
end

function mod:GridIndexToVector(gridIndex, mode)
	mode = mode or 0
	if mode == 0 then
		local x = gridIndex % 13
		local y = math.floor(gridIndex / 13)
		local position = Vector(x,y)
		return position
	else

		local x = gridIndex % 13 +1 
		local y = math.floor(gridIndex / 13) +1
		local position = Vector(x,y)
		return position
	end
end

--Make tear fall after
function mod:TearFallAfter(projectile, frames)

    frames = math.floor(frames)

    projectile:AddProjectileFlags(ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
    projectile.ChangeFlags = ProjectileFlags.TRACTOR_BEAM
    projectile.ChangeTimeout = frames
    
    projectile.FallingSpeed = 0
    projectile.FallingAccel = -0.1

end

function mod:GetTargetEnemy(ogEntity, maxDistance)
	local victim
	for _, entity in ipairs(Isaac.FindInRadius(ogEntity.Position, maxDistance)) do
		if (victim == nil or entity.HitPoints > victim.HitPoints) and mod:IsVulnerableEnemy(entity) then
			victim = entity
		end
	end
	return victim
end

function mod:PlayerHasCard(player, card)
    for i=0, 3 do
        if player:GetCard(i) == card then
			return true
		end
    end
	return false
end

function mod:PlayerGetCardSlot(player, card)
    for i=0, 3 do
        if player:GetCard(i) == card then
			return i
		end
    end
	return -1
end

function mod:KillEntities(list)
    for i=1, #list do
        local v = list[i]
		v:Die()
    end
end

function mod:GetRealBlackHearts(player)
	local n = player:GetBlackHearts()

	local count=0
	while n ~= 0 do
		n = n&(n-1)
		count = count + 1
	end

	return count
end

function mod:toTearsPerSecond(maxFireDelay)
	return 30 / (maxFireDelay + 1)
end

function mod:toMaxFireDelay(tearsPerSecond)
	return (30 / tearsPerSecond) - 1
end

function mod:FamiliarParentMovement(entity, distance, speed, stopness)
	local parent = entity.Parent

	entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, speed)

    local direction = parent.Position - entity.Position

	if parent.Position:Distance(entity.Position) > distance then
		entity.Velocity = mod:Lerp(entity.Velocity, direction / stopness, speed)
	end
	
end
function mod:FamiliarTargetMovement(entity, target, distance, speed, stopness)

	entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, speed)

    local direction = target.Position - entity.Position

	if target.Position:Distance(entity.Position) > distance then
		entity.Velocity = mod:Lerp(entity.Velocity, direction / stopness, speed)
	end
	
end

function mod:GetRoomTypeIndex(roomType)
	local level = game:GetLevel()

	for index = 0, 13*13-1 do
		local roomdesc = level:GetRoomByIdx(index)
		if roomdesc.Data and (roomdesc.Data.Type == roomType) then
			local banFlag = false or
			(roomType == RoomType.ROOM_DICE and (mod:IsRoomDescAstralChallenge(roomdesc)))
			if not banFlag then
				return index
			end
		end
	end
end

function mod:ItemGainCharge(player, collectibleType, amount)
    local slot
    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == collectibleType then slot = ActiveSlot.SLOT_PRIMARY
    elseif player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == collectibleType then slot = ActiveSlot.SLOT_SECONDARY
    elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == collectibleType then slot = ActiveSlot.SLOT_POCKET end
    if slot and slot~=-1 then
        player:SetActiveCharge( math.floor(player:GetActiveCharge(slot) + amount), slot)
    end
end


function mod:formatStringItemName(input)
    -- Remove the '#' character if present
    input = input:gsub("#", "")
    
    local parts = {}
    for part in input:gmatch("[^_]+") do
        table.insert(parts, part:lower()) -- Convert to lowercase
    end
    
    local result = table.concat(parts, " ")
    
    -- Capitalize the first letter of each word
    result = result:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest end)
    
    -- Remove the last word if it's "Name"
    result = result:gsub(" Name$", "")
    
    return result
end

function mod:GetItemName(item)
	local itemConfig = Isaac.GetItemConfig()
	local config = itemConfig:GetCollectible(item)
	if config then
		local name = mod:formatStringItemName(config.Name)
		return name
	end
	return "INVALID"
end

function mod:GetItemFromName(name)
	local item = Isaac.GetItemIdByName(name:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest end))
	if item > 0 then
		return item
	else
		for i=1, CollectibleType.NUM_COLLECTIBLES do
			local maybeName = mod:GetItemName(i)
			if string.lower(maybeName) == string.lower(name) then
				return i
			end
		end
	end
end

function mod:SetCanShoot(Player, CanShoot)
    local OldChallenge = Game().Challenge
    Game().Challenge = CanShoot and 0 or 6
    Player:UpdateCanShoot()
    Game().Challenge = OldChallenge
end

function mod:IsItemActive(item)
	return Isaac.GetItemConfig():GetCollectible(item).Type == ItemType.ITEM_ACTIVE
end

function mod:IsItemQuest(item)
	return Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_QUEST > 0
end

function mod:GetItemQuality(item)
	return Isaac.GetItemConfig():GetCollectible(item).Quality
end

function mod:ItemGivesExtraLive(item)
	return (item == CollectibleType.COLLECTIBLE_INNER_CHILD) or (item == CollectibleType.COLLECTIBLE_1UP) or (item == CollectibleType.COLLECTIBLE_DEAD_CAT) or (item == CollectibleType.COLLECTIBLE_ANKH) or (item == CollectibleType.COLLECTIBLE_GUPPYS_COLLAR) or (item == CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
end

function mod:HeavenifyChest()
	if not (mod.savedatarun().planetSol1 and mod.savedatarun().planetSol2) then return end

	for i, winChest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 0)) do
		winChest:GetData().IsHeaven = true
		local sprite = winChest:GetSprite()
		sprite:ReplaceSpritesheet(0, "hc/gfx/items/pick ups/end_chest.png")
		sprite:ReplaceSpritesheet(2, "hc/gfx/items/pick ups/end_chest.png")
		sprite:LoadGraphics()
	end
end

function mod:IsCurrentRoomBossRoom()
    local room = game:GetRoom()
    local roomType = room:GetType()

    return roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss()
end

function mod:DistanceFromPlayers(position, umbral)
    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
		if player and player.Position:Distance(position) < umbral then 
			return true
		end
	end
    return false
end

function mod:PlayerHasRune(player)
	for i=0, 3 do
		local card = player:GetCard(i)
		local itemConfig = Isaac:GetItemConfig():GetCard(card)
		if itemConfig:IsRune() then
			return true
		end
	end
	return false
end

function mod:PlayerHasMeteor(player)
	for i=0, 3 do
		local card = player:GetCard(i)
		if mod.Meteors.HAGALAZ <= card and card <= mod.Meteors.SOWILO then
			return true
		end
	end
	return false
end

function mod:PlayerHasStar(player)
	for i=0, 3 do
		local card = player:GetCard(i)
		if Isaac.GetCardIdByName("betelgeuse") <= card and card <= Isaac.GetCardIdByName("alphacentauri") then
			return true
		end
	end
	return false
end

function mod:AndromedaSpodeTears(entity, player, pos)

	local colors = {
		"red",
		"lightred",
		"orange",
		"yellow",
		"blue",
		"white",
	}

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local velocity = Vector.Zero

	if entity.Type == EntityType.ENTITY_EFFECT
	or entity.Type == EntityType.ENTITY_BOMB
	or entity.Type == EntityType.ENTITY_LASER
	then
		velocity = RandomVector() * rng:RandomFloat() * (rng:RandomInt(15) + 1)
	end
	
	local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, velocity, player):ToTear()
	local sprite = newTear:GetSprite()
	local randNum = rng:RandomInt(#colors) + 1
    sfx:Play(SoundEffect.SOUND_TEARS_FIRE, 0)
	
	newTear:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	
	sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
	newTear.CollisionDamage = player.Damage / 4
	newTear.Scale = 0.5345 * math.sqrt(newTear.CollisionDamage)
	newTear.WaitFrames = 0
	newTear.HomingFriction = 0.8
	newTear:GetData().isSpodeTear = true
	
	if entity.Type == EntityType.ENTITY_TEAR then
		newTear.FallingAcceleration = entity.FallingAcceleration
		newTear.FallingSpeed = entity.FallingSpeed

		if entity:GetData().starburstTear then
			newTear:GetData().starburstTear = true
		end
	elseif entity.Type == EntityType.ENTITY_EFFECT
	or entity.Type == EntityType.ENTITY_BOMB
	then
		local randFrame = rng:RandomInt(LAST_FRAME) + 1
		
		for i = 1, randFrame do
			sprite:Update()
		end

		newTear.FallingSpeed = newTear.FallingSpeed - (2 * rng:RandomFloat())
	else
		newTear.FallingAcceleration = 0
		newTear.FallingSpeed = -3
	end

	if entity.Type ~= EntityType.ENTITY_TEAR
	and player:HasCollectible(Isaac.GetItemIdByName("Starburst"))
	and rng:RandomFloat() < 0.06
	then
		newTear:GetData().starburstTear = true
	end
end

function mod:CountPlayerTrinkets(player)
	local trinkets = player:GetSmeltedTrinkets()
	local count = 0
	for i, entry in ipairs(trinkets) do
		count = count + entry.trinketAmount
	end
	return count
end

function mod:SpawnTouchedCollectible(item, position)
	local player = Isaac.GetPlayer(0)
	local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, position, Vector.Zero, nil):ToPickup()

	local flag = false
	if player:HasCollectible(item) then flag = true end
	player:DropCollectible(item, collectible)
	if flag then player:AddCollectible(item,0,false) end

	return collectible
end

function mod:IsItemFromForm(item, playerForm)
	--lol no
	--[[
	local n1 = Isaac.GetPlayer(0):GetPlayerFormCounter(playerForm)
	Isaac.GetPlayer(0):AddCollectible(item)
	local n2 = Isaac.GetPlayer(0):GetPlayerFormCounter(playerForm)
	Isaac.GetPlayer(0):RemoveCollectible(item)
	if n2>n1 then return true end
	return false
	]]--
end

function mod:AddTransformationItemsToPool(pool, playerForm)

end

function mod:TestChain(states, chain, testStates)
	local state = 0
	local registry = {}

	for i=1, 100000 do
		state = mod:MarkovTransition(state, chain)
		registry[state] = (registry[state] and (registry[state]+1)) or 1
	end

	local trueTotal = 0
	for state, total in pairs(registry) do
		for j, s in pairs(testStates) do
			if state == s[2] then
				trueTotal = trueTotal + total
				break
			end
		end
	end
	for state, total in pairs(registry) do
		for j, s in pairs(testStates) do
			if state == s[2] then
				print(s[1], total/trueTotal*100)
				break
			end
		end
	end
end

function mod:ArchProjectile(tear, dest, frames, fallAcc)
	local height = tear.Height
	local origin = tear.Position

	local velocity = (dest - origin)/frames
	local hv = (1.82 - height + 0.5*fallAcc*frames^2)/frames

	tear.Velocity = velocity

	tear.FallingSpeed = -hv*1.5
	tear.FallingAccel = fallAcc
end

function mod:GetSafeRandomRoomPos(margin)
	local room = game:GetRoom()

	local position = room:GetRandomPosition(0)
	local safeDistance = function (position)
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if player and player.Position:Distance(position) < margin then
				return false
			end
		end
		return true
	end

	local counter = 0
	while not safeDistance(position) and counter < 100 do
		position = room:GetRandomPosition(0)
		counter = counter + 1
	end
	return position
end

function mod:IsSlotAMachine(entity)
	local valid =
	entity.Variant == SlotVariant.SLOT_MACHINE or
	entity.Variant == SlotVariant.BLOOD_DONATION_MACHINE or
	entity.Variant == SlotVariant.FORTUNE_TELLING_MACHINE or
	entity.Variant == SlotVariant.DONATION_MACHINE or
	entity.Variant == SlotVariant.SHOP_RESTOCK_MACHINE or
	entity.Variant == SlotVariant.GREED_DONATION_MACHINE or
	entity.Variant == SlotVariant.CRANE_GAME or

	entity.Variant == mod.EntityInf[mod.Entity.Telescope].VAR or
	(entity.Variant == mod.EntityInf[mod.Entity.Computer].VAR and entity.SubType == mod.EntityInf[mod.Entity.Computer].SUB)

	if FiendFolio then
		valid = valid or
		entity.Variant == Isaac.GetEntityVariantByName("Mining Machine") or
		entity.Variant == Isaac.GetEntityVariantByName("Robot Teller") or
		entity.Variant == Isaac.GetEntityVariantByName("Phone Booth") or
		entity.Variant == Isaac.GetEntityVariantByName("Golden Slot Machine") or
		entity.Variant == Isaac.GetEntityVariantByName("Jukebox") or
		entity.Variant == Isaac.GetEntityVariantByName("Vending Machine (Vanilla)") or
		entity.Variant == Isaac.GetEntityVariantByName("Vending Machine (Fiend Folio)") or
		entity.Variant == Isaac.GetEntityVariantByName("Grid Restock Machine")
	end
	if Epiphany then
		valid = valid or
		entity.Variant == Isaac.GetEntityVariantByName("Dice Machine") or
		entity.Variant == Isaac.GetEntityVariantByName("Glitch Slot") or
		entity.Variant == Isaac.GetEntityVariantByName("Converter Beggar") or
		entity.Variant == Isaac.GetEntityVariantByName("Pain-O-Matic")
	end

	return valid
end

function mod:SetStageHpButbad(entity, stage, multiplier)
	multiplier = multiplier or 1

	local eConfig = EntityConfig.GetEntity(entity.Type, entity.Variant, entity.SubType)
	
	local base = eConfig:GetBaseHP()
	local extra = eConfig:GetStageHP()

	local dict = {[1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 4, [6] = 4.8}
	local mult = dict[stage] or stage

	entity.MaxHitPoints = (base + mult * extra) * multiplier
	entity.HitPoints = entity.MaxHitPoints

	return entity.HitPoints
end

function mod:GetTrinketFromList(lista)

	local trinket = lista[mod:RandomInt(1,#lista)]
	local counter = 0
    local total_trinkets = Isaac.GetItemConfig():GetTrinkets().Size - 1

	while (not mod:TrinketExists(trinket)) or mod:IsTrinketInRoom(trinket) do
		trinket = lista[mod:RandomInt(1,#lista)]
		counter = counter + 1
		if counter > 500 then
			trinket = mod:RandomInt(1, total_trinkets)
			break
		end
	end
	counter = 0
	while (not mod:TrinketExists(trinket)) or mod:IsTrinketInRoom(trinket) do
		trinket = mod:RandomInt(1, total_trinkets)
		counter = counter + 1
		if counter > 500 then
			break
		end
	end

	return trinket
end

function mod:GetTrueSafeGridIndex(index, level)
	if not index then return -1 end
	level = level or game:GetLevel()
	local roomdesc = level:GetRoomByIdx(index)

	local safe_index = roomdesc.SafeGridIndex

	return safe_index
end

function mod:IsPositionInScreen(point)
	local room = game:GetRoom()
	local screen_pos = Isaac.WorldToScreen(point)

	local h = Isaac.GetScreenHeight()
	local w = Isaac.GetScreenWidth()

	if (0 <= screen_pos.X and screen_pos.X <= w) and (0 <= screen_pos.Y and screen_pos.Y <= h) then
		return true
	end
	return false
end

function mod:GetPlayerHearts(player)
	
	local red = math.ceil(player:GetEffectiveMaxHearts() * 0.5)
	local soul = math.ceil(player:GetSoulHearts() * 0.5)

	return red+soul

	--[[
	local hud = game:GetHUD()

	local player_id = mod.PlayerNum2Ids[mod:PlayerId(player)]
	local player_hud = hud:GetPlayerHUD(player_id)
	local hearts = player_hud:GetHearts()
	
	local last_index = 1
	for i=2, 12 do
		if not hearts[i]:IsVisible() then
			break
		end
		last_index = i
	end
	return last_index
	]]
end

function mod:TrinketExists(trinket)
	local config = Isaac.GetItemConfig():GetTrinket(trinket)

	local is_everchanger = false
	for i, t in pairs(mod.EverchangerTrinkets) do
		if (t ~= TrinketType.TRINKET_STRANGE_KEY) and trinket == t then
			is_everchanger = true
		end
	end

	return config and (config.GfxFileName ~= "gfx/items/trinkets/") and config:IsAvailable() and not is_everchanger
end

--OWN MOD THINGS--------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--Find mod entity
function mod:FindByTypeMod(entityNum, var, sub)
	return Isaac.FindByType(mod.EntityInf[entityNum].ID, var or mod.EntityInf[entityNum].VAR, sub or mod.EntityInf[entityNum].SUB)
end

--Spawn entity from mod
function mod:SpawnEntity(entityNum, position, velocity, origin, variant, subtype)
	local tipo = mod.EntityInf[entityNum].ID
	local var = variant or mod.EntityInf[entityNum].VAR
	local sub = subtype or mod.EntityInf[entityNum].SUB
	local entity = Isaac.Spawn(tipo, var, sub, position, velocity, origin)
	entity:GetData().HeavensCall = true
	return entity
end

--orbit
function mod:OrbitParent(entity)
	if entity.Parent then
		local data = entity:GetData()
		if (not data.orbitAngle) then
			data.ColClass = entity.EntityCollisionClass
			data.orbitAngle = data.orbitIndex*360/data.orbitTotal
		end
		
        if not entity.Parent.Visible then
            entity.Visible = false
            entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            entity.Visible = true
            entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
            entity.EntityCollisionClass = data.ColClass or EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end
		entity.Position  = entity.Parent.Position + Vector.FromAngle(data.orbitAngle):Resized(data.orbitDistance*3)
		data.orbitAngle = (data.orbitAngle + data.orbitSpin*data.orbitSpeed) % 360

        return true
    else
        return false
	end

end

function mod:getBombRadius(bomb)
	bomb = bomb:ToBomb()
	local damage = bomb.ExplosionDamage
	local radius = bomb.RadiusMultiplier

    if 175.0 <= damage then
        return 105.0*radius
    else
        if damage <= 140.0 then
            return 75.0*radius
        else
            return 90.0*radius
        end
    end
end

function mod:GetAstralRoomLevel()
	local level = game:GetLevel()
	local levelStage = level:GetStage()

	--Spawn floors
	local stageMin = LevelStage.STAGE2_1
	local stageLimit = LevelStage.STAGE3_2

	if mod:CanAstralChallengeSpawnInWomb() then
		stageLimit = LevelStage.STAGE4_2
	end

	local corpseFlag = ( (LevelStage.STAGE4_1 <= levelStage and levelStage == LevelStage.STAGE4_2) and ( level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B )) or (LastJudgement and LastJudgement.STAGE.Mortis:IsStage())

	local outerFlag = (levelStage < LevelStage.STAGE5 and not corpseFlag) and (not mod.savedatarun().planetAlive) and (not mod.savedatarun().planetKilled1) and (stageMin <= levelStage and levelStage <= stageLimit) and (mod.savedatarun().spawnchancemultiplier1 > 0)
	local innerFlag = (levelStage == LevelStage.STAGE5 or corpseFlag) and (not mod.savedatarun().planetAlive) and (not mod.savedatarun().planetKilled2) and (mod.savedatarun().spawnchancemultiplier2 > 0)

	return {outerFlag, innerFlag}
end
function mod:GetAstralChallengeGenType()
	local level = game:GetLevel()
	local levelStage = level:GetStage()

	local nonRunFlag = game:IsGreedMode() or level:IsAscent()

	local r = mod:GetAstralRoomLevel()
	local outerFlag = r[1]
	local innerFlag = r[2]
	
	local alreadyExists = mod:IsThereAstralChallengeInFloor()

	if nonRunFlag or alreadyExists then
		return "none"
	else
		if outerFlag then
			return "outer"
		elseif innerFlag then
			return "inner"
		end
	end
	return "none"
end

--Colors
mod.Colors = {
	boom = Color(1,1,1,1),
	boom2 = Color(1,1,1,1),
	jupiterShot = Color(2,2,2,1),
	jupiterLaser1 = Color(0.5,0.5,0.5,1),
	jupiterLaser2 = Color(1,1,1,0.95),
	jupiterLaser3 = Color(1,1,1,0.95),
	hail = Color(1,1,1,0.9),
	poop = Color(1,1,1,1),
	poop2 = Color(0.5,0.5,0.5,1),
	pee = Color(1,1,1,1),
	ice = Color(1,1,1,0.7),
	frozen = Color(1,1,1,1),
	timeChanged = Color(1,1,1,1),
	timeChanged2 = Color(1,1,1,1),
	fire = Color(1,1,1,1),
	superFire = Color(0.75,0.75,0.75,1),
	buttFire = Color(1,1,1,1),
	mercury = Color(0.3,0.3,0.3,1),
	deep_mercury = Color(1,0.7,1,1,0.1,0.1,0.1),
	tar = Color(0.5,0.5,0.5, 1, 0,0,0),
	black = Color(0,0,0,1,0,0,0),
	maw = Color(0.1,0.1,0.1,1,0,0,0),
	ghost = Color(1,1,1,0.6,1,1,1),
	greenEden = Color(0.5,1,0.5,0.6,0.4,1,0.4),
	wax = Color(1,1,1,1,1,0.85,0.8),
	booger = Color(1,1,1,1),
	white = Color(1,1,1,1),
	red = Color(10,0.5,0.5,1),
	red2 = Color(0.8,0,0,1),
	whiteish = Color(1,1,1,1,0.1,0.1,0.1),
	redlight = Color(3,0.75,0.75,1),
	parasite = Color(0.9, 0.3, 0.08, 1, 0, 0, 0),
	parasite2 = Color(0.45, 0.15, 0.04, 1, 0, 0, 0),
	hot = Color(1,0.6,0,1),
	giant = Color(0.6,1.6,0.4,1),
	ember = Color(0.6,0.1,0,1),
	sand = Color(1,0.4,0.2,1),
	revelation = Color(2,2,2,1),
	glitch = Color(1,1,1,1),
	wax2 = Color(1,1,1,1),
	pitchBlack = Color(0,0,0,1,1,1,1),
	infected = Color(1,0.8,0.8,1, 0.3,0.1,0.1),
	hyperred = Color(1,0,0,1,1),
	lesbian = Color(1,1,1,1),

	futureblue =  	Color(0.25,	0.25,	1,		1,		0,0,1),
	futureblue2 = 	Color(0.25,	0.25,	1,		0.25,	0,0,1),
	pastred = 		Color(1,	0.15,	0.15,	1,		0,0,0),
	pastred2 = 		Color(1,	0.15,	0.15,	0.25,	0,0,0),

	yellowGlass = Color(1,0.5,0,1,0.2,0.1,0.1),
	spacerune = Color(0.8,0.9,1,1, 0.1,0.2,0.4),

	neptuneWater = Color(0,0,0.2,1),
}

if true then
	mod.Colors.boom:SetColorize(1.3,2,0.7,1)
	mod.Colors.boom2:SetColorize(1.9,2.5,1.4,1)
	mod.Colors.jupiterShot:SetColorize(1.9,2.5,1.4,1)
	mod.Colors.jupiterLaser1:SetColorize(1.9,2.5,1.4,1)
	mod.Colors.jupiterLaser2:SetColorize(3,5.5,6.5,1)
	mod.Colors.jupiterLaser3:SetColorize(8.5,4.5,2,1)
	mod.Colors.hail:SetColorize(1,1.5,2.5,1)
	mod.Colors.poop:SetColorize(1.2,0.7,0.6,1)
	mod.Colors.poop2:SetColorize(1.2,0.7,0.6,1)
	mod.Colors.pee:SetColorize(3,2.7,0.1,1)
	mod.Colors.ice:SetColorize(5,7,10,1)
	mod.Colors.frozen:SetColorize(1.5,2,3,1)
	mod.Colors.timeChanged:SetColorize(1,0.2,0.2,1)
	mod.Colors.timeChanged2:SetColorize(0.25,0.25,0.75,1)
	mod.Colors.fire:SetColorize(5,1.75,0,1)
	mod.Colors.superFire:SetColorize(20,7,0,1)
	mod.Colors.buttFire:SetColorize(2,1,0,1)
	mod.Colors.mercury:SetColorize(7,5,7,1)
	mod.Colors.tar:SetColorize(1, 1, 1, 1)
	mod.Colors.booger:SetColorize(0.3, 2, 0.2, 1)
	mod.Colors.red:SetColorize(5, 0, 0, 1)
	mod.Colors.white:SetColorize(10, 10, 10, 1)
	mod.Colors.whiteish:SetColorize(5, 5, 5, 1)
	mod.Colors.redlight:SetColorize(4, 1, 1, 1)
	mod.Colors.hot:SetColorize(4, 1, 0, 1)
	mod.Colors.sand:SetColorize(4, 2.5, 1, 1)
	mod.Colors.revelation:SetColorize(1, 1, 1, 0.4)
	mod.Colors.glitch:SetColorize(1, 1, 1, 1)
	mod.Colors.wax2:SetColorize(0.85, 0.8, 0, 1)
	mod.Colors.pitchBlack:SetColorize(1,1,1, 2)
	mod.Colors.lesbian:SetColorize(2,0,1.5,4)

end

--[[
function aaa()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data

	print("sub", roomdata.Subtype)

	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			print(door.TargetRoomIndex, door:GetSprite():GetAnimation())
			print(door:IsLocked())
		end
	end
end
]]