local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

mod.mapa = {
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '}
}

mod.ogCoords = {}

function mod:InitializeMapGrid(roomIdx)
    mod.mapa = {
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
        {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '}
    }
    
    local x = roomIdx%13+1
    local y = roomIdx//13+1

    --2x1 start room
    mod.mapa[x][y] = 'Y'
    mod.mapa[x][y+1] = 'Y'

    --2x2 boss room
    mod.mapa[x][y-1] = 'Y'
    mod.mapa[x][y-2] = 'Y'
    mod.mapa[x+1][y-1] = 'Y'
    mod.mapa[x+1][y-2] = 'Y'

    --specials
    mod.mapa[x-1][y+1] = 'R'
    mod.mapa[x+1][y+1] = 'R'
    mod.mapa[x][y+2] = 'Y'

    mod.ogCoords = {x-1,y+1}
end

--Does char exist
function mod:IsThereChar(char)
    for i = 1, 13 do
        for j = 1, 13 do
            if mod.mapa[i][j] == char then
                return true
            end
        end
    end
    return false
end

--not out of bounds
function mod:ValidCoord(coords)
    if (1 <= coords[1]) and (coords[1] <= 13) and (1 <= coords[2]) and (coords[2] <= 13) then
        return true
    end
    return false
end

--replace all charcters x with y
function mod:TransformMapChar (char1, char2)
    for i = 1, 13 do
        for j = 1, 13 do
            if mod.mapa[i][j] == char1 then
                mod.mapa[i][j] = char2
            end
        end
    end
end

--is there more than one X adjacent
function mod:MoreThan1X (coords)

    local exitos = 0
    for x = -1, 1, 1 do
        for y = -1, 1, 1 do
            if x*x+y*y == 1 then

                local newCoords = {[1]=coords[1]+x, [2]=coords[2]+y}
                if mod:ValidCoord(newCoords) and
                (mod.mapa[newCoords[1]][newCoords[2]] == 'X' or 
                mod.mapa[newCoords[1]][newCoords[2]] == 'O' or 
                mod.mapa[newCoords[1]][newCoords[2]] == 'Y' or 
                mod.mapa[newCoords[1]][newCoords[2]] == 'R') 
                then
                    exitos = exitos + 1
                end
            end
        end
    end

    if exitos > 1 then
        return true
    end
    return false
end

--randomly select from where to generate
function mod:SelectStart(char)
    local lista = {}
    for i = 1, 13 do
        for j = 1, 13 do
            if mod.mapa[i][j] == char then
                table.insert(lista, {[1]=i,[2]=j})
            end
        end
    end
    return mod:random_elem(lista)
end

function mod:GenerateMapa()
    local nGeneratedRooms = 0

    local loops = 0
    while ((nGeneratedRooms < 30) and (loops < 500)) do
        loops = loops + 1
        local loops2 = 0

        while (mod:IsThereChar('O') or mod:IsThereChar('R')) and loops2 < 500 do
            loops2 = loops2 + 1

            local coords
            if mod:IsThereChar('R') then
                coords = mod:SelectStart('R') 
            else
                coords = mod:SelectStart('O') 
            end

            for x = -1, 1 do
                for y = -1, 1 do
                    if x*x+y*y == 1 then
                        local newCoords = {[1]=coords[1]+x,[2]=coords[2]+y}
                        if mod:ValidCoord(newCoords) and
                        (mod.mapa[newCoords[1]][newCoords[2]] ~= 'X') and
                        (mod.mapa[newCoords[1]][newCoords[2]] ~= 'Y') and
                        (not mod:MoreThan1X(newCoords))
                        then
                            if rng:RandomFloat() < 0.3 then
                                mod.mapa[newCoords[1]][newCoords[2]] = '1'
                                if mod.mapa[coords[1]][coords[2]] == 'R' then
                                    mod.mapa[coords[1]][coords[2]] = 'Y'
                                else
                                    mod.mapa[coords[1]][coords[2]] = 'X'
                                end
                                nGeneratedRooms = nGeneratedRooms + 1
                            end
                        end
                    end
                end
            end

        end
        mod:TransformMapChar('1', 'O')
    end
    mod:TransformMapChar('1', 'X')
    mod:TransformMapChar('O', 'X')
end

function mod:GenerateRoomsFromMapa()
    local level = game:GetLevel()
    local data = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_ERROR, 8503, 20)

    for i = 1, 13 do
        for j = 1, 13 do
            if mod.mapa[i][j] == 'X' then
                local roomIdx = (i-1) + (j-1)*13
                local c = 0
                for x = -1, 1 do
                    for y = -1, 1 do
                        if x*x+y*y == 1 then
                            local newCoords = {[1]=i+x,[2]=j+y}
                            if mod:ValidCoord(newCoords) and (mod.mapa[newCoords[1]][newCoords[2]] == 'X') then
                                local slot
                                if c == 2 then slot = DoorSlot.DOWN0
                                elseif c == 1 then slot = DoorSlot.UP0
                                elseif c == 3 then slot = DoorSlot.RIGHT0
                                elseif c == 0 then slot = DoorSlot.LEFT0
                                end

                                local newRoomIdx = (newCoords[1]-1) + (newCoords[2]-1)*13

                                if newRoomIdx and level:MakeRedRoomDoor(roomIdx, slot) then

                                    local newroomdesc = level:GetRoomByIdx(newRoomIdx, 0)
                                    newroomdesc.Data = data
                                    newroomdesc.Flags = 0
                                    mod:UpdateRoomDisplayFlags(newroomdesc)
                                    
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
