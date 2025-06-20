local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

mod.EverchangerNodes = {}

function mod:InitializeNodes()

    mod.EverchangerNodes = {}

    local mapa = mod.everchangerMap
    mapa = mod:transposeMatrix(mapa)

    for x = 1, 13 do
        for y = 1, 13 do

            if mapa and mapa[x][y] == "X" or mapa[x][y] == "Y" then
            --if (game:GetLevel():GetRoomByIdx((x-1)+(y-1)*13).Data) then
                --print(x,y, (x-1)+(y-1)*13)
                mod:CreateNode(mod.EverchangerNodes, mapa, x, y)
            end
        end
    end
end

function mod:CreateNode(nodes, map, x, y)
    local newNode = {RIGHT = nil, UP = nil, LEFT = nil, DOWN = nil}
    local index = (x-1) + (y-1)*13

    mod:AddNeightbour(newNode, map, x, y, 1, 0)
    mod:AddNeightbour(newNode, map, x, y, -1, 0)
    mod:AddNeightbour(newNode, map, x, y, 0, 1)
    mod:AddNeightbour(newNode, map, x, y, 0, -1)

    nodes[index] = newNode

end
function mod:AddNeightbour(newNode, map, x, y, dx, dy)

    local nx = x+dx
    local ny = y+dy

    local nChar = mod:ValidCoord({nx,ny}) and map[nx][ny]
    if nChar and (nChar == "X" or nChar == "Y") then

        local nIndex = (nx-1) + (ny-1)*13
        if dx > 0 then
            newNode.RIGHT = nIndex
        elseif dx < 0 then
            newNode.LEFT = nIndex
        elseif dy > 0 then
            newNode.DOWN = nIndex
        elseif dy < 0 then
            newNode.UP = nIndex

        end
    end
end

function mod:GetDeadend(currentIdx, playerIdx)
    local deadends = {}
    for key, node in pairs(mod.EverchangerNodes) do
        local suma = (node.RIGHT and 1 or 0) + (node.LEFT and 1 or 0) + (node.UP and 1 or 0) + (node.DOWN and 1 or 0)
        if key ~= currentIdx  and key ~= playerIdx and suma == 1 then
            table.insert(deadends, key)
        end
    end

    return deadends[mod:RandomInt(1, #deadends)]
end



function mod:dijkstra(graph, start, target)
    local distances = {} -- Shortest distances from the start node
    local predecessors = {} -- Predecessors in the shortest path
    local visited = {}   -- Set of visited nodes

    -- Initialize distances
    for node, _ in pairs(graph) do
        distances[node] = math.huge
    end
    distances[start] = 0

    while true do
        local minDistance = math.huge
        local current = nil

        -- Find the unvisited node with the smallest distance
        for node, dist in pairs(distances) do
            if not visited[node] and dist < minDistance then
                minDistance = dist
                current = node
            end
        end

        -- If there are no unvisited nodes left or the target is unreachable, exit
        if not current or minDistance == math.huge then
            break
        end

        visited[current] = true

        -- Update distances for neighbors of the current node
        for direction, neighbor in pairs(graph[current]) do
            if not visited[neighbor] then
                local alt = distances[current] + 1 -- Assuming equal edge weights

                if alt < distances[neighbor] then
                    distances[neighbor] = alt
                    predecessors[neighbor] = current
                end
            end
        end
    end

    -- Build the path from start to target
    local path = {}
    local current = target
    while current do
        table.insert(path, 1, current)
        current = predecessors[current]
    end

    return path
end

function mod:tryDijsktra()
    local startNode = 84
    local targetNode = mod:GetRoomTypeIndex(RoomType.ROOM_BOSS)

    local nodes = mod.EverchangerNodes
    
    local path = mod:dijkstra(nodes, startNode, targetNode)
    if #path > 0 then
        print("Shortest path:", table.concat(path, " -> "))
    else
        print("No path found from node", startNode, "to node", targetNode)
    end
end