local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

local cardMap = {
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7",
    [8] = "8",
    [9] = "9",
    [10] = "10",
    [11] = "J",
    [12] = "Q",
    [13] = "K",
    [1] = "A"
}

local thinkTime = 30

function mod:show_blackjack(slot, data, player, hidetooltip)
    mod:SendInputComputer(slot, player, "", false, false)
    mod:SendInputComputer(slot, player, "", false, false)
    mod:SendInputComputer(slot, player, "", false, false)
    mod:SendInputComputer(slot, player, "", false, false)
    mod:SendInputComputer(slot, player, "", false, false)
    mod:SendInputComputer(slot, player, "", false, false)
    local turn = data.turn
    
    mod:SendInputComputer(slot, player, "BLACK JACK - get close to 21", false, false)
    mod:SendInputComputer(slot, player, "-------------------------", false, false)
    mod:SendInputComputer(slot, player, "DEALER:", false, false)

    local insurenceFlag = turn == 1 and data.dealerCards[1] == 1 and math.floor(0.5*data.amount) > 0

    if turn < 0 then
        local line = "        "
        local total = mod:get_total_blackjack(data, false)
        for i, card in ipairs(data.dealerCards) do
            line = line .. " " .. tostring(cardMap[card])
        end
        mod:SendInputComputer(slot, player, line, false, false)
        mod:SendInputComputer(slot, player, "total: "..tostring(total), false, false)
    else
        mod:SendInputComputer(slot, player, "        "..tostring(cardMap[data.dealerCards[1]]).." ?", false, false)
        mod:SendInputComputer(slot, player, "total: ?", false, false)
    end

    mod:SendInputComputer(slot, player, "-------------------------", false, false)
    mod:SendInputComputer(slot, player, string.upper(EntityConfig.GetPlayer(player:GetPlayerType()):GetName():sub(2, -6))..":", false, false)
    if insurenceFlag then
        mod:SendInputComputer(slot, player, "        "..tostring(cardMap[data.playerCards[1]]).." ?", false, false)
        mod:SendInputComputer(slot, player, "total: ?", false, false)
    else
        local line = "        "
        local total = mod:get_total_blackjack(data, true)
        for i, card in ipairs(data.playerCards) do
            line = line .. " " .. tostring(cardMap[card])
        end
        mod:SendInputComputer(slot, player, line, false, false)
        mod:SendInputComputer(slot, player, "total: "..tostring(total), false, false)
    end
    mod:SendInputComputer(slot, player, "-------------------------", false, false)
    mod:SendInputComputer(slot, player, "", false, false)
    
    local options = {"hit", "stand", "double"}
    if insurenceFlag then
        table.insert(options, "insurance")
    end
    table.insert(options, "surrender")

    
    local total = 0
    for i, card in ipairs(data.playerCards) do
        total = total + card
    end
    if total == 21 then
        options = {"stand"}
    end

    local line = "Action: "
    for i, option in ipairs(options) do
        line = line .. option .. "-"
    end
    if data.turn > 0 and not hidetooltip then
        mod:SendInputComputer(slot, player, line:sub(1, -2), false, false)
    end
end

function mod:get_total_blackjack(data, isPlayer)
    local tabla = data.dealerCards
    if isPlayer then
        tabla = data.playerCards
    end

    local total = 0
    for i, card in ipairs(tabla) do
        if card > 1 then
            total = total + math.min(10, card)
        end
    end
    for i, card in ipairs(tabla) do
        if card == 1 then
            if total + 11 > 21 then
                total = total + 1
            else
                total = total + 11
            end
        end
    end
    return total
end

function mod:play_blackjack(slot, data, player, input, isPlayer)
    if data.turn > 0 then
        local ttotal = mod:get_total_blackjack(data, isPlayer)
        if input == "hit" and ttotal < 21 then
            if isPlayer then
                table.insert(data.playerCards, mod:RandomInt(1,13))
                local total = mod:get_total_blackjack(data, true)

                if total < 21 then
                    mod:show_blackjack(slot, data, player)

                elseif total == 21 then
                    mod:show_blackjack(slot, data, player, true)
                    mod:SendInputComputer(slot, player, "21!!!", false, false)
                    mod:SendInputComputer(slot, player, "Now is dealer's turn", false, false)
                    data.turn = -1
                    mod:scheduleForUpdate(function()
                        if slot then
                            mod:play_blackjack_dealer(slot, data, player)
                        end
                    end, thinkTime)
                else
                    mod:show_blackjack(slot, data, player, true)
                    mod:SendInputComputer(slot, player, "Bust!!! Too bad", false, false)
                    mod:OutComputer(slot, data)
                end
            else
                --bruh
            end
        elseif input == "stand" then
            mod:SendInputComputer(slot, player, "You stand, now is dealer's turn", false, false)
            data.turn = -1
            mod:scheduleForUpdate(function()
                if slot then
                    mod:play_blackjack_dealer(slot, data, player)
                end
            end, thinkTime)
        elseif input == "double" then
            if isPlayer then
                table.insert(data.playerCards, mod:RandomInt(1,13))
                local total = mod:get_total_blackjack(data, true)

                if mod:CompuerGetResource(data.targetAccount) >= data.amount then
                    mod:CompuerPayResource(data.targetAccount, data.amount)
                    data.amount = data.amount*2

                    mod:show_blackjack(slot, data, player, true)
    
                    if total == 21 then
                        mod:SendInputComputer(slot, player, "21!!!", false, false)
                        mod:SendInputComputer(slot, player, "Now is dealer's turn", false, false)
                        data.turn = -1
                        mod:scheduleForUpdate(function()
                            if slot then
                                mod:play_blackjack_dealer(slot, data, player)
                            end
                        end, thinkTime)
                    elseif total > 21 then
                        mod:SendInputComputer(slot, player, "Bust!!! Too bad", false, false)
                        mod:OutComputer(slot, data)
                    else
                        mod:SendInputComputer(slot, player, "Now is dealer's turn", false, false)
                        data.turn = -1
                        mod:scheduleForUpdate(function()
                            if slot then
                                mod:play_blackjack_dealer(slot, data, player)
                            end
                        end, thinkTime)
                    end
                else
                    mod:SendInputComputer(slot, player, "Not enough money", false, false)
                end
            else
                --bruh
            end
        elseif input == "insurance" and (data.turn == 1 and data.dealerCards[1] == 1 and math.floor(0.5*data.amount) > 0) then
            if mod:CompuerGetResource(data.targetAccount) >= math.floor(0.5*data.amount) then
                data.insurance = math.floor(0.5*data.amount)
                mod:CompuerPayResource(data.targetAccount, data.insurance)

                mod:scheduleForUpdate(function()
                    if slot then
                        mod:show_blackjack(slot, data, player)
                        mod:SendInputComputer(slot, player, "Insurance set!", false, false)
                    end
                end, 1)
            else

                mod:scheduleForUpdate(function()
                    if slot then
                        mod:show_blackjack(slot, data, player)
                        mod:SendInputComputer(slot, player, "Not enough money", false, false)
                    end
                end, 1)
            end
        else

            mod:scheduleForUpdate(function()
                if slot then
                    mod:show_blackjack(slot, data, player)
                    mod:SendInputComputer(slot, player, "Invalid choice", false, false)
                end
            end, 1)
        end

        if data.turn > 0 then
            data.turn = data.turn + 1
        end
    end
end

function mod:play_blackjack_dealer(slot, data, player)

    if data.Process == "blackjack" and data.turn < 0 then

        local total = mod:get_total_blackjack(data, false)
    
        if data.turn == -1 then
            if (data.dealerCards[1]==1 and data.dealerCards[2]>= 10) or (data.dealerCards[2]==1 and data.dealerCards[1]>= 10) then
                if (data.playerCards[1]==1 and data.playerCards[2]>= 10) or (data.playerCards[2]==1 and data.playerCards[1]>= 10) then
                    mod:show_blackjack(slot, data, player)
                    mod:SendInputComputer(slot, player, "Draw!!! Money returned", false, false)
                    data.Process = nil
                    mod:CompuerPayResource(data.targetAccount, -data.amount)
                else
                    mod:show_blackjack(slot, data, player)
                    mod:SendInputComputer(slot, player, "Dealer Black Jack!!! Too bad", false, false)
                    mod:OutComputer(slot, data)
                    local insurance = 3*data.insurance
                    if insurance > 0 then
                        mod:SendInputComputer(slot, player, "You got "..tostring(insurance).." in insurance", false, false)
                        mod:CompuerPayResource(data.targetAccount, -insurance)
                    end
                end
            end
        else
        
            if total <= 16 then
                table.insert(data.dealerCards, mod:RandomInt(1,13))
            end

            mod:show_blackjack(slot, data, player, true)

            local newtotal = mod:get_total_blackjack(data, false)
            if newtotal > 21 then
                mod:SendInputComputer(slot, player, "Dealer bust!!! great", false, false)
                mod:SendInputComputer(slot, player, "You duped your "..tostring(data.amount), false, false)
                mod:CompuerPayResource(data.targetAccount, -2*data.amount)
                data.Process = nil

            else
                        
                local playertotal = mod:get_total_blackjack(data, true)
                local dealertotal = mod:get_total_blackjack(data, false)

                if playertotal == dealertotal then
                    mod:SendInputComputer(slot, player, "Draw!!! Money returned", false, false)
                    data.Process = nil
                elseif playertotal > dealertotal then
                    mod:SendInputComputer(slot, player, "You win!!!", false, false)
                    mod:SendInputComputer(slot, player, "You duped your "..tostring(data.amount), false, false)
                    mod:CompuerPayResource(data.targetAccount, -2*data.amount)
                    data.Process = nil
                else
                    mod:SendInputComputer(slot, player, "You lose", false, false)
                    mod:OutComputer(slot, data)
                end

            end
    
        end
    
        data.turn = data.turn - 1
        mod:scheduleForUpdate(function()
            if slot then
                mod:play_blackjack_dealer(slot, data, player)
            end
        end, thinkTime)
    end
end