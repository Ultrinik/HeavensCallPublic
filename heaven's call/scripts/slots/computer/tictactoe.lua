--https://github.com/agrawal-rohit/tic-tac-toe-ai-bots

local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local infinity = math.huge

function mod:play_move(slot, player, state, playerMark, row, col)
    local data = slot:GetData()
    local valid = false
    
    if state[row][col] == '.' then
        state[row][col] = playerMark
        valid = true
    else
        mod:scheduleForUpdate(function()
            mod:SendInputComputer(slot, player, "Block is not empty, Choose again: ", false, false)
        end, 1)
    end
    return state, valid
end

function mod:copy_game_state(state)
    local new_state = {
        {'.', '.', '.'},
        {'.', '.', '.'},
        {'.', '.', '.'}
    }
    for i = 1, 3 do
        for j = 1, 3 do
            new_state[i][j] = state[i][j]
        end
    end
    return new_state
end

function mod:check_current_state(game_state)
    -- Check horizontals
    for i = 1, 3 do
        if game_state[i][1] == game_state[i][2] and game_state[i][2] == game_state[i][3] and game_state[i][1] ~= '.' then
            return game_state[i][1], "Done"
        end
    end
    -- Check verticals
    for j = 1, 3 do
        if game_state[1][j] == game_state[2][j] and game_state[2][j] == game_state[3][j] and game_state[1][j] ~= '.' then
            return game_state[1][j], "Done"
        end
    end
    -- Check diagonals
    if game_state[1][1] == game_state[2][2] and game_state[2][2] == game_state[3][3] and game_state[1][1] ~= '.' then
        return game_state[1][1], "Done"
    end
    if game_state[3][1] == game_state[2][2] and game_state[2][2] == game_state[1][3] and game_state[3][1] ~= '.' then
        return game_state[3][1], "Done"
    end
    -- Check if draw
    local draw_flag = true
    for i = 1, 3 do
        for j = 1, 3 do
            if game_state[i][j] == '.' then
                draw_flag = false
                break
            end
        end
        if not draw_flag then
            break
        end
    end
    if draw_flag then
        return nil, "Draw"
    end
    return nil, "Not Done"
end

function mod:print_board(slot, player, data)
    local game_state = data.game_state
    
    --mod:SendInputComputer(slot, player, "clear", true, false)

    mod:SendInputComputer(slot, player, '----------------', false, false)
    mod:SendInputComputer(slot, player, "  1 2 3", false, false)
    for i, j in ipairs({"A", "B", "C"}) do
        local line = j .. " " .. game_state[i][1] .. " " .. game_state[i][2] .. " " .. game_state[i][3]
        mod:SendInputComputer(slot, player, line, false, false)
    end
    mod:SendInputComputer(slot, player, '----------------', false, false)
end

function mod:getBestMove(slot, player, state, playerMark)
    local data = slot:GetData()
    local winner_loser, done = mod:check_current_state(state)
    if done == "Done" and winner_loser == 'O' then
        return 1, 0
    elseif done == "Done" and winner_loser == 'X' then
        return -1, 0
    elseif done == "Draw" then
        return 0, 0
    end
    local moves = {}
    local empty_cells = {}
    for i = 1, 3 do
        for j = 1, 3 do
            if state[i][j] == '.' then
                local index = (i - 1) * 3 + j
                table.insert(empty_cells, index)
            end
        end
    end
    for count, empty_cell in ipairs(empty_cells) do
        local move = {}
        move.index = empty_cell
        local AIrow = math.floor((empty_cell-1)/3)+1
        local AIcol = (empty_cell-1)%3+1
        
        local new_state = mod:copy_game_state(state)
        new_state, _ = mod:play_move(slot, player, new_state, playerMark, AIrow, AIcol)
        local result

        if playerMark == 'O' then
            result, _ = mod:getBestMove(slot, player, new_state, 'X')
            move.score = result
        else
            result, _ = mod:getBestMove(slot, player, new_state, 'O')
            move.score = result
        end
        table.insert(moves, move)
    end
    local best_move = nil
    local best
    if playerMark == 'O' then
        best = -infinity
        for _, move in ipairs(moves) do
            if move.score > best then
                best = move.score
                best_move = move.index
            end
        end
    else
        best = infinity
        for _, move in ipairs(moves) do
            if move.score < best then
                best = move.score
                best_move = move.index
            end
        end
    end
    return best, best_move
end

function mod:tictactoe_play(slot, player, data, row, col)

    if data.current_state == "Not Done" then

        
        local valid = true
        if data.current_player_idx == 1 then -- Human's turn
            --mod:SendInputComputer(slot, player, "Oye Human, your turn!", false, false)
            data.game_state, valid = mod:play_move(slot, player, data.game_state, "X", row, col)
            
            if valid then
                for i=1, mod.ComputerConts.maxHistory do
                    mod:SendInputComputer(slot, player, "", false, false)
                end
            end
        else -- AI's turn
            local _, block_choice = mod:getBestMove(slot, player, data.game_state, "O")
            local AIrow = math.floor((block_choice-1)/3)+1
            local AIcol = (block_choice-1)%3+1
            
            data.game_state, _ = mod:play_move(slot, player, data.game_state, "O", AIrow, AIcol)
        end
        mod:print_board(slot, player, data)
        
        local winner, new_current_state = mod:check_current_state(data.game_state)
        data.current_state = new_current_state

        if winner ~= nil then
            if winner == "X" then
                mod:SendInputComputer(slot, player, EntityConfig.GetPlayer(player:GetPlayerType()):GetName():sub(2, -6) .. " won!", false, false)
            else
                mod:SendInputComputer(slot, player, "The AI won!", false, false)
            end
            return winner
        elseif valid then
            data.current_player_idx = 3 - data.current_player_idx
        end

        if data.current_state == "Draw" then
            mod:SendInputComputer(slot, player, "Draw!", false, false)
            return "draw"

        elseif data.current_state == "Not Done" and data.current_player_idx == 2 then
            mod:tictactoe_play(slot, player, data, nil, nil)
        end
    end
end