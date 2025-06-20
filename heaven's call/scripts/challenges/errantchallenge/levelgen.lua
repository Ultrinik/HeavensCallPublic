local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()


--not out of bounds
function mod:ValidCoord(coords)
    if (1 <= coords[1]) and (coords[1] <= 13) and (1 <= coords[2]) and (coords[2] <= 13) then
        return true
    end
    return false
end

mod.everchangerMap = {
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ','X',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ','N','N',' ','X','X','X',' '},
    {' ',' ',' ',' ','X',' ','N','N',' ','X',' ','X','X'},
    {'X','X','X','X','X',' ','N',' ','X','X','X','X',' '},
    {' ',' ','X',' ','X','Y','Y','Y','X',' ',' ','X',' '},
    {' ',' ','X','X','X',' ','Y',' ','X','X',' ','X','X'},
    {' ','X','X',' ','X',' ',' ',' ','X',' ',' ','X',' '},
    {' ',' ',' ',' ','X','X','X',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
}
mod.everchangerRoomMapping = {
    [96] = 8511, 
    [95] = 8512, 
    [82] = 8513, 
    [81] = 8514, 
    [80] = 8515, 
    [93] = 8516, 
    [106] = 8517, 
    [119] = 8518, 
    [134] = 8519, 
    [108] = 8520, 
    [98] = 8521, 
    [99] = 8522, 
    [112] = 8523, 
    [86] = 8524, 
    [87] = 8525, 
    [88] = 8526, 
    [89] = 8527, 
    [76] = 8532, 
    [63] = 8529, 
    [62] = 8530, 
    [61] = 8531, 
    [74] = 8528, 
    [115] = 8533, 
    [48] = 8534, 
    [110] = 8507, 
    [69] = 8506, 
    [118] = 8505, 
    [147] = 8509, 
    [128] = 8510, 
    [116] = 8508, 
    [77] = 8504,
    [107] = 8535, 
    [135] = 8536,
    [121] = 8537,
    [125] = 8538,--toilet
    [113] = 8539,--turrets
    [79] = 8540,--infinite
    [78] = 8541,--nil
    [136] = 8542,--mars
}
mod.EVFloorIdRange = Vector(8500, 8542)

--[[mod.everchangerMap = {
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ','N','N',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ','N','N',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ','X',' ','N',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ','X','Y','Y','Y','X',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ','Y',' ','X',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
}]]

function mod:GenerateEverchangerRoomsFromMapa()

    local mapa = mod.everchangerMap

    mapa = mod:transposeMatrix(mapa)

    local level = game:GetLevel()

    for i = 1, 13 do
        for j = 1, 13 do
            local char = mapa[i][j]
            if char == 'X' or char == 'N' then
                local roomIdx = (i-1) + (j-1)*13
                local currentroomdesc = level:GetRoomByIdx(roomIdx, 0)

                local c = 0
                for x = -1, 1 do
                    for y = -1, 1 do
                        if x*x+y*y == 1 then
                            local newCoords = {[1]=i+x,[2]=j+y}

                            local newChar = mod:ValidCoord(newCoords) and mapa[newCoords[1]][newCoords[2]]

                            if mod:ValidCoord(newCoords) and (newChar == 'X' or newChar == 'L' or newChar == '|' ) then

                                local slot
                                if c == 2 then slot = DoorSlot.DOWN0
                                elseif c == 1 then slot = DoorSlot.UP0
                                elseif c == 3 then slot = DoorSlot.RIGHT0
                                elseif c == 0 then slot = DoorSlot.LEFT0
                                end

                                local newRoomIdx = (newCoords[1]-1) + (newCoords[2]-1)*13

                                if newRoomIdx and level:MakeRedRoomDoor(roomIdx, slot) then
                                    local newroomdesc = level:GetRoomByIdx(newRoomIdx, 0)

                                    if newChar == 'X' then
                                        newroomdesc.Data = mod.everchangerroomdata[8501]

                                    elseif newChar == 'L' then
                                        newroomdesc.Data = mod.everchangerroomdata[8502]
                                        --level:MakeRedRoomDoor(newRoomIdx, DoorSlot.RIGHT1)

                                    elseif newChar == '|' then
                                        --level:MakeRedRoomDoor(newRoomIdx, DoorSlot.DOWN0)
                                        newroomdesc.Data = mod.everchangerroomdata[8503]

                                        mod:scheduleForUpdate(function()
                                            mod:CopyDescriptors(level:GetRoomByIdx(newRoomIdx, 0), level:GetRoomByIdx(roomIdx, 0))
                                        end,1)

                                    end
                                    newroomdesc.Flags = 0

                                    mod:UpdateRoomDisplayFlags(newroomdesc)
                                    mod:UpdateRoomDisplayFlags(currentroomdesc)
                                end
                            end
                            c = c + 1
                        end
                    end
                end

            end
        end
    end
    level:UpdateVisibility()
end

function mod:AddCustomEverchangerRooms()
    local level = game:GetLevel()
    for i=0, 13*13-1 do
        local newroomIdx = mod.everchangerRoomMapping[i]
        if newroomIdx then
            local roomdesc = level:GetRoomByIdx(i, 0)
            roomdesc.Data = mod.everchangerroomdata[newroomIdx]
        end
    end
end

function mod:CopyDescriptors(source, destination)
    --destination.AllowedDoors = source.AllowedDoors
    destination.AwardSeed = source.AwardSeed
    destination.ChallengeDone = source.ChallengeDone
    destination.Clear = source.Clear
    destination.ClearCount = source.ClearCount
    --destination.Data = source.Data
    destination.DecorationSeed = source.DecorationSeed
    destination.DeliriumDistance = source.DeliriumDistance
    destination.DisplayFlags = source.DisplayFlags
    destination.Flags = source.Flags
    destination.GridIndex = source.GridIndex
    destination.HasWater = source.HasWater
    destination.ListIndex = source.ListIndex
    destination.NoReward = source.NoReward
    --destination.OverrideData = source.OverrideData
    destination.PitsCount = source.PitsCount
    destination.PoopCount = source.PoopCount
    destination.PressurePlatesTriggered = source.PressurePlatesTriggered
    destination.SacrificeDone = source.SacrificeDone
    destination.SafeGridIndex = source.SafeGridIndex
    destination.ShopItemDiscountIdx = source.ShopItemDiscountIdx
    destination.SpawnSeed = source.SpawnSeed
    destination.SurpriseMiniboss = source.SurpriseMiniboss
    destination.VisitedCount = source.VisitedCount
end