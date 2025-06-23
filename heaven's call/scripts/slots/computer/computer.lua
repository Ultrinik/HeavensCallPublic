local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local persistentGameData = Isaac.GetPersistentGameData()

include("scripts.slots.computer.tictactoe")
include("scripts.slots.computer.blackjack")

mod.ModFlags.InComputer = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ModFlags.InComputer", false)

mod.ComputerConts = {
    maxLength = 34,
    maxHistory = 14,

    cardChance = 0.005,
    cardId = Isaac.GetCardIdByName("Punched"),
}
mod.ComputerConts.maxLengthInput = mod.ComputerConts.maxLength-2

function mod:ComputerUpdate(slot)
    if slot.SubType == mod.EntityInf[mod.Entity.Computer].SUB then
        local sprite = slot:GetSprite()
        local data = slot:GetData()

        if not data.Init then
            data.Init = true

            slot.HitPoints = 1
            data.BlockedCounter = 0

            data.Sprite = Sprite()
            data.Sprite:Load("hc/gfx/screen_console.anm2", true)
            data.Sprite:Play("Idle", true)

            local path = "mods/heaven's call_3503885496/resources/hc/font/fixedsys.fnt"
            local c
            data.Text, c = Font(path)
            if not c then
                path = "mods/heaven's call/resources/hc/font/fixedsys.fnt"
                data.Text = Font(path)
            end
            
            for i=1, mod.ComputerConts.maxHistory do
                data["Text"..tostring(i)] = Font(path)
            end

            data.text = ">"
            for i=1, mod.ComputerConts.maxHistory do
                data["text"..tostring(i)] = ""
            end

            data.bar = "_"
        end
        if slot.FrameCount % 15 == 0 then
            if #data.bar==0 then
                data.bar = "_"
            else
                data.bar = ""
            end
        end

        data.BlockedCounter = data.BlockedCounter - 1

        if slot.HitPoints <= 0  then
            if not (sprite:GetAnimation()=="Death") then
                sprite:Play("Death", true)

            end
        else

            if data.BlockedCounter <= 0 then
                mod:CheckSlotContact(slot, mod.OnComputerCollide)
            end

        end

        if mod.ModFlags.InComputer and data.BeingUsed and data.Player then
            local player = data.Player
            player.ControlsCooldown = 5
            player:SetMinDamageCooldown(30)
            data.BlockedCounter = math.max(5, data.BlockedCounter)
        end

        --BAN QUICK RESET FROM FF AND TaintedTreasure AND MAYBE SOME OTHERS MODS IDK
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            if player then
                player:GetData().TaintedLastResetPress = 0
                player:GetData().LastResetPress = 0
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.ComputerUpdate, mod.EntityInf[mod.Entity.Computer].VAR)

function mod:OnComputerCollide(slot, player)
	local sprite = slot:GetSprite()
	local data = slot:GetData()
	if not mod.ModFlags.InComputer and sprite:IsPlaying("Idle") then
        mod:IntoComputer(slot, data, player)

        if not data.Booted then
            data.Booted = true
            sfx:Play(Isaac.GetSoundIdByName("bootUp"))
        end
	end
end
function mod:IntoComputer(slot, data, player)
    data.Player = player
    data.BeingUsed = true
    data.Scale = 0.01
    mod.ModFlags.InComputer = true
    mod.ModFlags.ComputerSlot = slot
    
    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnComputerRender)
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnComputerRender)
    mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, mod.CancelOptionsWhileComputer, InputHook.IS_ACTION_TRIGGERED)
    mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.CancelOptionsWhileComputer, InputHook.IS_ACTION_TRIGGERED)


    --block DSS
    local statue = mod:SpawnEntity(mod.Entity.Statue, Vector.Zero, Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.Statue].SUB+2)
    statue.Visible = false
    statue.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
end
function mod:OutComputer(slot, data)
    local process = data.Process
    if not process then
        mod.ModFlags.InComputer = false
        data.BeingUsed = false
        data.BlockedCounter = 30
    
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.OnComputerRender)
        mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, mod.CancelOptionsWhileComputer, InputHook.IS_ACTION_TRIGGERED)


        mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Statue, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB+2))
    else
        if process == "tictactoe" then
            mod:SendInputComputer(slot, player, "Game exited", false, false)
            data.Process = nil
        elseif process == "blackjack" then
            mod:SendInputComputer(slot, player, "Game exited, all money lost", false, false)
            data.Process = nil
        end
    end
end

function mod:OnComputerRender()
    if mod.ModFlags.InComputer then
        local slot = mod.ModFlags.ComputerSlot
        local data = slot:GetData()
        local sprite = data.Sprite
        local scale = Isaac.GetScreenPointScale()

        data.Scale = math.min(1, data.Scale*1.3)

        --logic
        if data.BeingUsed then
            mod:WriteOnComputer(slot, data)
        end

        --render
        local w = Isaac.GetScreenWidth()
        local h = Isaac.GetScreenHeight()
        local position = Vector(w/2, h/2)
        sprite.Scale = Vector.One*data.Scale
        sprite:Render(position)

        local scale = 1*data.Scale
        local kColor = KColor(1,0,0,1)

        --input
        local pos = position + Isaac.WorldToScreenDistance(Vector(-280, 130)*data.Scale)
        local text = data.Text
        local t = data.text 
        if #t < mod.ComputerConts.maxLengthInput then t = t .. data.bar end
        text:DrawStringScaled(t, pos.X, pos.Y, scale, scale, kColor, 0, true)

        --history
        pos = position + Isaac.WorldToScreenDistance(Vector(-280, -150)*data.Scale)
        for i=1, mod.ComputerConts.maxHistory do
            text = data["Text"..tostring(i)]
            t = data["text"..tostring(i)]

            text:DrawStringScaled(t, pos.X, pos.Y, scale, scale, kColor, 0, true)

            pos = pos + Isaac.WorldToScreenDistance(Vector(0, 19)*data.Scale)
        end
    end
end

function mod:CancelOptionsWhileComputer(entity, hook, button)
    if (false or mod.ModFlags.InComputer) and (button == ButtonAction.ACTION_FULLSCREEN or button == ButtonAction.ACTION_MUTE or button == ButtonAction.ACTION_PAUSE or button == ButtonAction.ACTION_RESTART) then
        return false
    end
end
--mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.CancelOptionsWhileComputer, InputHook.IS_ACTION_TRIGGERED)

function mod:WriteOnComputer(slot, data)
    local player = data.Player
    local crt = player.ControllerIndex

    local string = data.text

    
    if Input.IsButtonPressed (Keyboard.KEY_LEFT_CONTROL, crt) or Input.IsButtonPressed (Keyboard.KEY_RIGHT_CONTROL, crt) then
        if Input.IsButtonTriggered(Keyboard.KEY_C, crt) then
            mod:OutComputer(slot, data)
            return
        end
        if Input.IsButtonTriggered(Keyboard.KEY_V, crt) then
            local clip = Isaac.GetClipboard()
            clip = string.sub(clip, 1, mod.ComputerConts.maxLengthInput)
            string = string..clip
        end
    end

    if #string < mod.ComputerConts.maxLengthInput then
        local mayus = false
        if not (Input.IsButtonPressed (Keyboard.KEY_LEFT_SHIFT, crt) or Input.IsButtonPressed (Keyboard.KEY_RIGHT_SHIFT, crt)) then
            mayus = true
        end
        for i=32, 126 do
            if Input.IsButtonTriggered(i, crt) then
                if mayus then
                    string = string..string.lower(string.char(i))
                else
                    string = string..string.char(i)
                end
            end
            if #string >= mod.ComputerConts.maxLengthInput then
                break
            end
        end
    end

    if Input.IsButtonTriggered (Keyboard.KEY_BACKSPACE, crt) then
        string = string.sub(string, 1, -2)
        if #string == 0 then
            string = ">"
        end
    end

    if Input.IsButtonTriggered (Keyboard.KEY_C, crt) then
        sfx:Stop(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
    end

    if #string < #data.text then
        sfx:Play(mod.SFX.Key2)
    elseif #string > #data.text then
        sfx:Play(mod.SFX.Key1)
    end

    data.text = string

    if Input.IsButtonTriggered (Keyboard.KEY_ENTER, crt) then
        if #data.text == 1 then
            mod:SendInputComputer(slot, player, nil, false, false)
        else
            mod:SendInputComputer(slot, player, nil, true, data.Process)
        end
        sfx:Play(mod.SFX.Key2)
    end

    if 
    --Input.GetActionValue(ButtonAction.ACTION_DROP, crt) > 0 or
    Input.GetActionValue(ButtonAction.ACTION_MAP, crt) > 0 or
    Input.GetActionValue(ButtonAction.ACTION_MENUBACK, crt) > 0
    then
        mod:OutComputer(slot, data)
    end
end
function mod:SendInputComputer(slot, player, forcedText, isCommand, process)
    local data = slot:GetData()

    local inputText = data.text
    local text = forcedText or inputText

    --split if more excedes max length
    local function splitString(original, n)
        local firstPart = string.sub(original, 1, n)
        local secondPart = string.sub(original, n + 1)
        return firstPart, secondPart
    end
    local text2
    text, text2 = splitString(text, mod.ComputerConts.maxLength)

    --print
    local auxText
    for i=mod.ComputerConts.maxHistory, 1, -1 do
        auxText = data["text"..tostring(i)]
        data["text"..tostring(i)] = text
        text = auxText
    end

    --multiline
    if #text2>0 then --if it was too long
        mod:SendInputComputer(slot, player, text2, isCommand, false)
    else
        if isCommand then
            if (#inputText > 0) then
                local input = mod:split(string.sub(string.lower(data.text), 2), " ")
                mod:ProcessComputerInput(slot, data, player, input, process)
            end
            data.text = ">"
        end
    end
end

--COMMANDS----------------------------------------
table.insert(mod.PostLoadInits, {"savedatafloor", "setTreasure", -1})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatafloor.setTreasure", -1)
table.insert(mod.PostLoadInits, {"savedatafloor", "setTreasureRoom", -1})
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatafloor.setTreasureRoom", -1)

table.insert(mod.PostLoadInits, {"savedatarun", "calibrations", {}})
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.calibrations", {})

mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.marketplace", nil)


function mod:ProcessComputerInput(slot, data, player, input, process)
    local room = game:GetRoom()
    local level = game:GetLevel()
    if process == nil then process = data.Process end

    if not process then
        if input[1] == "kill" then
            mod:OutComputer(slot, data)
            player:UseCard(Card.CARD_SOUL_LOST, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

        elseif input[1] == "seed" then
            local seed = game:GetSeeds():GetStartSeedString()
            mod:SendInputComputer(slot, player, seed, false, false)

        elseif input[1] == "clear" then
            for i=1, mod.ComputerConts.maxHistory do
                mod:SendInputComputer(slot, player, "", false, false)
            end

        elseif input[1] == "exit" then
            mod:OutComputer(slot, data)

        elseif input[1] == "cake" then
            mod:SendInputComputer(slot, player, "The cake is a lie", false, false)

        elseif input[1] == "noclip" then
            mod:SendInputComputer(slot, player, "nah", false, false)

        elseif input[1] == "sv_cheats" or input[1] == "sv-cheats" then
            mod:SendInputComputer(slot, player, "lol no", false, false)

        elseif input[1] == "amogus" then
            mod:SendInputComputer(slot, player, " ## ", false, false)
            mod:SendInputComputer(slot, player, "####", false, false)
            mod:SendInputComputer(slot, player, "## |", false, false)
            mod:SendInputComputer(slot, player, "####", false, false)
            mod:SendInputComputer(slot, player, "####", false, false)
            mod:SendInputComputer(slot, player, "#  #", false, false)

        elseif input[1] == "trans" then
            mod:SendInputComputer(slot, player, "rights", false, false)

        elseif input[1] == "sex" then
            mod:SendInputComputer(slot, player, "not for you, lol", false, false)

        elseif input[1] == "boobs" or input[1] == "tits" then
            mod:SendInputComputer(slot, player, "( . )( . )", false, false)

        elseif input[1] == "dick" or input[1] == "cock" or input[1] == "penis" then
            mod:SendInputComputer(slot, player, "8==D", false, false)

        elseif input[1] == "vagina" or input[1] == "pussy" then
            mod:SendInputComputer(slot, player, "(|)", false, false)

        elseif input[1] == "timeset" then
            local num = tonumber(input[2])
            if num and num >= 0 then
                game.TimeCounter = num
                local s = math.floor(num/30)
                mod:SendInputComputer(slot, player, "Time set to "..tostring(s).."s", false, false)
            else
                mod:SendInputComputer(slot, player, "Invalid time", false, false)
            end

        elseif input[1] == "math" then
            local num1 = tonumber(input[2])
            local op = input[3]
            local num2 = tonumber(input[4])

            if (num1 and num2 and op) and (op == "add" or op == "+" or op == "sub" or op == "-" or op == "mul" or op == "mult" or op == "*" or op == "div" or op == "/") then
                if op == "add" or op == "+" then
                    mod:SendInputComputer(slot, player, tostring(num1+num2), false, false)
                elseif op == "sub" or op == "-" then
                    mod:SendInputComputer(slot, player, tostring(num1-num2), false, false)
                elseif op == "mul" or op == "mult" or op == "*" then
                    mod:SendInputComputer(slot, player, tostring(num1*num2), false, false)
                elseif op == "div" or op == "/" then
                    if num2 == 0 then
                        mod:SendInputComputer(slot, player, "Oh god, what have you done!?", false, false)
                        mod:scheduleForUpdate(function()
                            Isaac.Spawn(3487891234,381923789123,37982138912,Vector.Zero,Vector.Zero,nil)
                        end, 30)
                    else
                        mod:SendInputComputer(slot, player, tostring(num1/num2), false, false)
                    end

                end
            else
                mod:SendInputComputer(slot, player, "Invalid syntax, <num> <txt> <num>", false, false)
            end

        elseif input[1] == "bitch" then
            mod:SendInputComputer(slot, player, "Your mom", false, false)
        elseif input[1] == "fuck" then
            mod:SendInputComputer(slot, player, "                                  ", false, false)
            mod:SendInputComputer(slot, player, "                                  ", false, false)
            mod:SendInputComputer(slot, player, "                                  ", false, false)
            
            mod:SendInputComputer(slot, player, "  ###### ### ###  #####  ###  ### ", false, false)
            mod:SendInputComputer(slot, player, " ####### ### ### ### ### ### #### ", false, false)
            mod:SendInputComputer(slot, player, " ###     ### ### ### ### #######  ", false, false)
            mod:SendInputComputer(slot, player, " #####   ### ### ###     ######   ", false, false)
            mod:SendInputComputer(slot, player, " #####   ### ### ### ### #######  ", false, false)
            mod:SendInputComputer(slot, player, " ###     ### ### ### ### ### #### ", false, false)
            mod:SendInputComputer(slot, player, " ###      #####   #####  ###  ### ", false, false)

            mod:SendInputComputer(slot, player, "                                  ", false, false)
            mod:SendInputComputer(slot, player, "                                  ", false, false)
            mod:SendInputComputer(slot, player, "                                  ", false, false)

        elseif input[1] == "debug" then
            mod:SendInputComputer(slot, player, "Hell no!", false, false)
        elseif input[1] == "gamemode" then
            mod:SendInputComputer(slot, player, "You do not have access to that command", false, false)

        elseif input[1] == "badapple" or (input[1] == "bad" and input[2] and input[2] == "apple") then
            if not mod.badapple then
                include("scripts.lmao.badapple")
            end

            mod.ModFlags.badappleIndex = 1
            Isaac.CreateTimer(function()
                local frame = mod.badapple[mod.ModFlags.badappleIndex]

                for _, str in ipairs(frame) do
                    mod:SendInputComputer(slot, player, str, false, false)
                end

                mod.ModFlags.badappleIndex = mod.ModFlags.badappleIndex + 1
            end, 3, #mod.badapple, false)
        
        elseif input[1] == "chipi" or input[1] == "chapa" or input[1] == "chipichipi" or input[1] == "chapachapa" then
            if not mod.chipi then
                include("scripts.lmao.chipi")
            end

            Isaac.CreateTimer(function()
                mod.ModFlags.chipiIndex = 1
                Isaac.CreateTimer(function()
                    local frame = mod.chipi[mod.ModFlags.chipiIndex]

                    for _, str in ipairs(frame) do
                        mod:SendInputComputer(slot, player, str, false, false)
                    end

                    mod.ModFlags.chipiIndex = mod.ModFlags.chipiIndex + 1
                end, 3, #mod.chipi, false)
            end, 3*#mod.chipi, 7, false)
        
        elseif input[1] == "calibrate" or input[1] == "cal" then
            if input[2] then
                local num = tonumber(input[2])
                
                if input[3] then
                    local p = string.lower(input[3])
        
                    if p == "earth" then p = "terra" end
                    if p == "moon" then p = "luna" end
                    if p == "sun" then p = "sol" end
        
                    if num then
                        if 1 <= num and num <= 5 then
                            if (p == "mercury") or (p == "venus") or (p == "terra") or (p == "mars") or (p == "luna") or (p == "jupiter") or (p == "saturn") or (p == "uranus") or (p == "neptune") or (p == "pluto") or (p == "sol") then
                                
                                if (p == "sol") or (num == 1 and ((p == "mercury") or (p == "venus") or (p == "terra") or (p == "mars") or (p == "luna"))) or (num == 2 and ((p == "jupiter") or (p == "saturn") or (p == "uranus") or (p == "neptune") or (p == "pluto"))) or (num > 2 and (p == "luna" or p == "pluto")) then
                                    mod:SendInputComputer(slot, player, "Error, satellite #"..tostring(num).." can't point   towards "..p, false, false)
                                else
                                    mod:SendInputComputer(slot, player, "Success, satellite #"..tostring(num).." pointing    towards "..p, false, false)

                                    local converter = {jupiter = 1, saturn = 2, uranus = 3, neptune = 4, mercury = 5, venus = 6, terra = 7, mars = 8, luna = 9, pluto = 10}
                                    local pc = converter[p]
                                    for i, cal in ipairs(mod.savedatarun().calibrations) do
                                        if (cal ~= nil or cal ~= -1) and ((pc == cal and i ~= num) ) then
                                            mod.savedatarun().calibrations[i] = -1
                                            mod:SendInputComputer(slot, player, "Warning, satellite #"..tostring(i).." has decalibrated", false, false)
                                        end
                                    end
                                    mod.savedatarun().calibrations[num] = pc
                                end
        
                            else
                                mod:SendInputComputer(slot, player, "Invalid planet name", false, false)
        
                            end
                        else
                            mod:SendInputComputer(slot, player, "Invalid satellite number, must be between 1 and 5", false, false)
                        end
                    else
                        mod:SendInputComputer(slot, player, "Invalid satellite number, must be between 1 and 5", false, false)
                    end
                else
                    mod:SendInputComputer(slot, player, "Submit a planet target, type      \"help calibrate\" for guidance", false, false)
                end
            else
                mod:SendInputComputer(slot, player, "Submit a satellite number, type   \"help calibrate\" for guidance", false, false)
            end
        elseif input[1] == "ariral" then
            mod:SendInputComputer(slot, player, ">:3", false, false)
            mod:OutComputer(slot, data)
            local position = room:GetDoorSlotPosition(level.EnterDoor) + (room:GetCenterPos() - room:GetDoorSlotPosition(level.EnterDoor)):Normalized()*30
            local ariral = mod:SpawnEntity(mod.Entity.GlassGaper, position, Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.GlassGaper].SUB+1)
        elseif input[1] == "play" then
            
            data.game_state = {
                {'.', '.', '.'},
                {'.', '.', '.'},
                {'.', '.', '.'}
            }
            data.current_state = "Not Done"
            data.current_player_idx = 1 

            mod:print_board(slot, player, data)
            mod:SendInputComputer(slot, player, "Play your mark by writing its     coordinates, ex: A3", false, false)

            data.Process = "tictactoe"
        elseif input[1] == "coords" then
            local index = -1
            if input[2] and (input[2] == "current" or input[2] == "treasure" or input[2] == "boss" or input[2] == "shop" or input[2] == "secret" or input[2] == "supersecret" or input[2] == "ssecret" or input[2] == "ultrasecret" or input[2] == "usecret" or input[2] == "planetarium") then
                if input[2] == "current" then
                    index = level:GetCurrentRoomIndex()
                elseif input[2] == "treasure" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_TREASURE)
                elseif input[2] == "boss" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_BOSS)
                elseif input[2] == "shop" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_SHOP)
                elseif input[2] == "secret" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_SECRET)
                elseif input[2] == "supersecret" or input[2] == "ssecret" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_SUPERSECRET)
                elseif input[2] == "ultrasecret" or input[2] == "usecret" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_ULTRASECRET)
                elseif input[2] == "planetarium" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_PLANETARIUM)
                end

                if index and index >= 0 then
                    local x = tostring(math.floor((index)/13) + 1)
                    local y = tostring((index)%13 + 1)
                    mod:SendInputComputer(slot, player, x .. " " .. y, false, false)
                else
                    mod:SendInputComputer(slot, player, "Error, requested room not found", false, false)
                end

            else
                mod:SendInputComputer(slot, player, "Submit a valid room target, type  \"help coords\" for guidance", false, false)
            end
        elseif input[1] == "items" then

            local line = ""

            local items = player:GetCollectiblesList()
            for item, amount in pairs(items) do
                if amount > 0 then
                    local name = mod:GetItemName(item)
                    line = line .. name .. " - "
                end
            end

            mod:SendInputComputer(slot, player, string.sub(line, 1, -4), false, false)
        elseif input[1] == "greedcheck" then
            if input[2] and (input[2] == "shop" or input[2] == "secret") then
                local index
                if input[2] == "shop" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_SHOP)
                elseif input[2] == "secret" then
                    index = mod:GetRoomTypeIndex(RoomType.ROOM_SECRET)
                end

                if index and index >= 0 then
                    local roomdesc = level:GetRoomByIdx(index)
                    if roomdesc.Flags & RoomDescriptor.FLAG_SURPRISE_MINIBOSS == RoomDescriptor.FLAG_SURPRISE_MINIBOSS then
                        mod:SendInputComputer(slot, player, "Greed found in room", false, false)
                    else
                        mod:SendInputComputer(slot, player, "No boss found in room", false, false)
                    end
                else
                    mod:SendInputComputer(slot, player, "Error, requested room not found", false, false)
                end

            else
                mod:SendInputComputer(slot, player, "Submit a valid room target, type  \"help greedcheck\" for guidance", false, false)
            end
        elseif input[1] == "amount" then
            if input[2] and (input[2] == "edentokens" or input[2] == "tokens" or input[2] == "edens" or input[2] == "coins" or input[2] == "donationcoins" or input[2] == "gcoins" or input[2] == "greedcoins") then
                local amount = -1
                local tipo = ""

                if input[2] == "edentokens" or input[2] == "tokens" or input[2] == "edens" then
                    amount = persistentGameData:GetEventCounter(EventCounter.EDEN_TOKENS)
                    tipo = "Eden Tokens"
                elseif input[2] == "coins" or input[2] == "donationcoins" then
                    amount = persistentGameData:GetEventCounter(EventCounter.DONATION_MACHINE_COUNTER)
                    tipo = "Coins in Donation Machine"
                elseif input[2] == "gcoins" or input[2] == "greedcoins" then
                    amount = persistentGameData:GetEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER)
                    tipo = "Coins in Greed Donation Machine"
                end
                amount = amount%1000

                if amount and amount >= 0 then
                    mod:SendInputComputer(slot, player, "There are "..tostring(amount).." "..tipo, false, false)
                else
                    mod:SendInputComputer(slot, player, "Error, requested resource not found", false, false)
                end

            else
                mod:SendInputComputer(slot, player, "Submit a resource, type           \"help amount\" for guidance", false, false)
            end
        elseif input[1] == "doomsday" then
            if true then
                mod:SendInputComputer(slot, player, "No doom approaching", false, false)
            else
                local s = mod.savedatapersistent().doomsdayTimer

                local hours = math.floor(s / 3600)
                local seconds = s % 3600
                local minutes = math.floor(seconds / 60)
                local seconds = math.floor(s % 60)

                if mod.savedatapersistent().doomsdayState == mod.DState.TO_BE_ACTIVATED or mod.savedatapersistent().doomsdayState == mod.DState.DISABLED then
                    mod:SendInputComputer(slot, player, "No doom approaching", false, false)
                elseif mod.savedatapersistent().doomsdayState == mod.DState.ACTIVATED or mod.savedatapersistent().doomsdayState == mod.DState.ACTIVATED_IN_RUN then
                    mod:SendInputComputer(slot, player, tostring(hours).." hours, "..tostring(minutes).." minutes and " .. tostring(seconds) .. " seconds until armageddon", false, false)
                elseif mod.savedatapersistent().doomsdayState == mod.DState.APOCALYPSE then
                    mod:SendInputComputer(slot, player, "kys", false, false)
                    mod:OutComputer(slot, data)
                    mod:scheduleForUpdate(function()
                        room:MamaMegaExplosion(slot.Position)
                    end, 1)
                end
            end
        elseif input[1] == "item" then
            if mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
                mod:SendInputComputer(slot, player, "An error has accured, please do not try again", false, false)
            else
                local index = mod:GetRoomTypeIndex(RoomType.ROOM_TREASURE)
                if index >= 0 then
                    local roomdesc = level:GetRoomByIdx(index)
    
                    if roomdesc and roomdesc.VisitedCount == 0 then
                        if mod.savedatafloor().setTreasure == -1 then
                            local seed = game:GetSeeds():GetStartSeed()
                            local newItem = game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false, seed)
                            mod.savedatafloor().setTreasure = newItem
                        end
                        if mod.savedatafloor().setTreasure > 0 then
                            mod.savedatafloor().setTreasureRoom = index
    
                            local name = mod:GetItemName(mod.savedatafloor().setTreasure)
                            mod:SendInputComputer(slot, player, "The item in the tresure room is " .. name, false, false)
                        else
                            mod:SendInputComputer(slot, player, "An error has accured, please do not try again", false, false)
                        end
                    else
                        mod:SendInputComputer(slot, player, "An error has accured, please do not try again", false, false)
                    end
                else
                    mod:SendInputComputer(slot, player, "Error, no treasure room has been found", false, false)
                end
            end
        elseif input[1] == "marketplace" or input[1] == "market" then
            if not mod.savedatarun().marketplace then
                mod.savedatarun().marketplace = {mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES),
                                            mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES),
                                            mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES)}
            end
            mod:SendInputComputer(slot, player, "ID | PRICE | NAME", false, false)
            mod:SendInputComputer(slot, player, "---+-------+----------------------", false, false)

            local function zeroPad(num)
                if num < 10 then
                    return "00" .. tostring(num)
                elseif num < 100 then
                    return "0" .. tostring(num)
                else
                    return tostring(num)
                end
            end

            local itemConfig = Isaac.GetItemConfig()
            for i=1, 3 do
                local item = mod.savedatarun().marketplace[i]
                if item > 0 then
                    local config = itemConfig:GetCollectible(item)
                    local newrng = RNG()
                    newrng:SetSeed(item^3, 35)
                    local price = math.ceil(config.ShopPrice*(0.5 + newrng:RandomFloat())*math.sqrt(config.Quality+1))
                    local name = mod:GetItemName(item)

                    local sprice = zeroPad(price)
                    local sid = zeroPad(item)

                    mod:SendInputComputer(slot, player, " "..tostring(i).." |  ".. sprice .."  | "..name, false, false)
                    mod:SendInputComputer(slot, player, "---+-------+----------------------", false, false)
                end
            end
            mod:SendInputComputer(slot, player, "To buy type: \'buy ID\'", false, false)
        elseif input[1] == "buy" then
            if not mod.savedatarun().marketplace then
                mod.savedatarun().marketplace = {mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES),
                                            mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES),
                                            mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES)}
            end
            if input[2] then
                local id = tonumber(input[2])
                if id and 1 <= id and id <= 3 then
                    local item = mod.savedatarun().marketplace[id]
                    if item > 0 then
                        local itemConfig = Isaac.GetItemConfig()
                        local config = itemConfig:GetCollectible(item)
                        local newrng = RNG()
                        newrng:SetSeed(item^3, 35)
                        local price = math.ceil(config.ShopPrice*(0.5 + newrng:RandomFloat())*math.sqrt(config.Quality+1))
                        local name = mod:GetItemName(item)
                        if price <= Isaac.GetPlayer(0):GetNumCoins() then
                            mod.savedatarun().marketplace[id] = -1
                            if config.Type == ItemType.ITEM_ACTIVE then
                                player:DropCollectible(player:GetActiveItem())
                            end
                            player:AddCollectible(item)
                            sfx:Play(SoundEffect.SOUND_POWERUP1)
                            mod:SendInputComputer(slot, player, name.." was bought", false, false)
                            Isaac.GetPlayer(0):AddCoins(-price)
                        else
                            mod:SendInputComputer(slot, player, "Not enough money! Come back when  you are a bit richer!", false, false)
                        end
                    else
                        mod:SendInputComputer(slot, player, "Item not avalible", false, false)
                    end
                else
                    mod:SendInputComputer(slot, player, "Id must be between 1 and 3", false, false)
                end
            else
                mod:SendInputComputer(slot, player, "Submit a valid item id to buy, type \"help buy\" for guidance", false, false)
            end
        elseif input[1] == "donate" then
            if input[2] then
                local num = tonumber(input[2])
                if num then
                    if num <= Isaac.GetPlayer(0):GetNumCoins() then
                        Isaac.GetPlayer(0):AddCoins(-num)
                        if game:IsGreedMode() then
                            persistentGameData:IncreaseEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER ,num)
                        else
                            persistentGameData:IncreaseEventCounter(EventCounter.DONATION_MACHINE_COUNTER ,num)
                        end
                        if num >= 0 then
                            mod:SendInputComputer(slot, player, "You donated "..tostring(num).." coins", false, false)
                        else
                            mod:SendInputComputer(slot, player, "coins "..tostring(-num).." donated You", false, false)
                        end
                    else
                        mod:SendInputComputer(slot, player, "Not enough money! Come back when  you are a bit richer!", false, false)
                    end
                else
                    mod:SendInputComputer(slot, player, "Not a valid amount", false, false)
                end
            else
                mod:SendInputComputer(slot, player, "Submit an amount to donate, type \"help donate\" for guidance", false, false)
            end
            if not mod.savedatarun().marketplace then
                mod.savedatarun().marketplace = {mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES),
                                            mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES),
                                            mod:RandomInt(1, CollectibleType.NUM_COLLECTIBLES)}
            end
        elseif input[1] == "sell" then

            if input[2] then
                local target = input[2]
                if (target == "own" or target == "current" or target == "edentokens" or target == "tokens" or target == "edens" or target == "coins" or target == "donationcoins" or target == "gcoins" or target == "greedcoins") then

                    local itemName = input[3]
                    for i=4, 10 do
                        if input[i] then
                            itemName = itemName .. " " .. input[i]
                        end
                    end

                    if itemName then
                        local id = tonumber(itemName)
                        if not id then
                            id = mod:GetItemFromName(itemName)
                        end

                        if id then
                            if player:HasCollectible(id) then
                                local itemConfig = Isaac.GetItemConfig()
                                local config = itemConfig:GetCollectible(id)
                                local newrng = RNG()
                                newrng:SetSeed(id^3, 35)
                                local price = math.ceil(config.ShopPrice*(0.5 + newrng:RandomFloat())*math.sqrt(config.Quality+1))
                                local name = mod:GetItemName(id)
        
                                player:RemoveCollectible(id)
        
                                local change = ""
                                if target == "own" or target == "current" then
                                    player:AddCoins(price)
                                elseif target == "edentokens" or target == "tokens" or target == "edens" then
                                    local num = math.floor(price/10)
                                    local changechange = price - 10*num
                                    change = ", you got "..tostring(changechange).. " coins in change"
                                    player:AddCoins(changechange)
                                    persistentGameData:IncreaseEventCounter(EventCounter.EDEN_TOKENS, num)
                                elseif target == "coins" or target == "donationcoins" then
                                    persistentGameData:IncreaseEventCounter(EventCounter.DONATION_MACHINE_COUNTER, price)
                                elseif target == "gcoins" or target == "greedcoins" then
                                    persistentGameData:IncreaseEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER, price)
                                end
        
                                mod:SendInputComputer(slot, player, name.." was sold for "..tostring(price).." pennies" ..change, false, false)
                            else
                                mod:SendInputComputer(slot, player, "You don't have that item, type \"items\" to see a list of your items", false, false)
                            end
                        else
                            mod:SendInputComputer(slot, player, "The item does not exists, type \"items\" to see a list of your items", false, false)
                        end
                    else
                        mod:SendInputComputer(slot, player, "Submit an item, type \"help sell\" for guidance", false, false)
                    end


                else
                    mod:SendInputComputer(slot, player, "Invalid account", false, false)
                end
            else
                mod:SendInputComputer(slot, player, "Please submit a target account to receive the money, type \"help sell\" for guidance", false, false)
            end

        elseif input[1] == "bet" then
            if input[2] then
                local target = input[2]
                if (target == "own" or target == "current" or target == "edentokens" or target == "tokens" or target == "edens" or target == "coins" or target == "donationcoins" or target == "gcoins" or target == "greedcoins") then

                    local amount = tonumber(input[3])
                    if amount and amount > 0 then

                        local notEnoughtFlag = false
                        if target == "own" or target == "current" then
                            if amount <= player:GetNumCoins() then
                                player:AddCoins(-amount)
                                data.targetAccount = "own"
                            else
                                notEnoughtFlag = true
                            end
                        elseif target == "edentokens" or target == "tokens" or target == "edens" then
                            if amount <= persistentGameData:GetEventCounter(EventCounter.EDEN_TOKENS) then
                                persistentGameData:IncreaseEventCounter(EventCounter.EDEN_TOKENS, -amount)
                                data.targetAccount = "edens"
                            else
                                notEnoughtFlag = true
                            end
                        elseif target == "coins" or target == "donationcoins" then
                            if amount <= persistentGameData:GetEventCounter(EventCounter.DONATION_MACHINE_COUNTER) then
                                persistentGameData:IncreaseEventCounter(EventCounter.DONATION_MACHINE_COUNTER, -amount)
                                data.targetAccount = "coins"
                            else
                                notEnoughtFlag = true
                            end
                        elseif target == "gcoins" or target == "greedcoins" then
                            if amount <= persistentGameData:GetEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER) then
                                persistentGameData:IncreaseEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER, -amount)
                                data.targetAccount = "gcoins"
                            else
                                notEnoughtFlag = true
                            end
                        end

                        if notEnoughtFlag then
                            mod:SendInputComputer(slot, player, "Not enough resources", false, false)
                        else
                            data.dealerCards = {mod:RandomInt(1,13),mod:RandomInt(1,13)}
                            data.playerCards = {mod:RandomInt(1,13),mod:RandomInt(1,13)}
                            data.turn = 1
                            data.insurance = 0
                            data.amount = amount
                            mod:show_blackjack(slot, data, player)
                            data.Process = "blackjack"
                        end
                    else
                        mod:SendInputComputer(slot, player, "Invalid amount", false, false)
                    end
                else
                    mod:SendInputComputer(slot, player, "Invalid account", false, false)
                end
            else
                mod:SendInputComputer(slot, player, "Please submit a target account to retrieve and receive the money, type \"help bet\" for guidance", false, false)
            end
        elseif input[1] == "help" then
            
            if input[2] then
                local c2 = input[2]
                if c2 == "help" then
                    local line = [[
                    elseif input[1] == "help" then
                        if not input[2] then
                            local c2 = input[2]
                            if c2 == "help" then
                                mod:SendInputComputer(slot, player, "Here is a list of commands:", false, false)
                            elseif c2 == "kill" then
                                mod:SendInputComputer(slot, player, "kys", false, false)
                            elseif c2 == "seed" then
                                mod:SendInputComputer(slot, player, "Prints your run seed", false, false)
                            elseif c2 == "clear" then
                                mod:SendInputComputer(slot, player, "Clears the console", false, false)
                            elseif c2 == "exit" then
                                mod:SendInputComputer(slot, player, "Exit the current process", false, false)
                            elseif c2 == "timeset" then
                                mod:SendInputComputer(slot, player, "Input: <number>,set game time to the submitted value", false, false)
                            elseif c2 == "math" then
                                mod:SendInputComputer(slot, player, "Input: <number> <string> <number>, input two numbers and an operator to print the result, valid operators are the following: add, sub, mul, div", false, false)
                            elseif c2 == "badapple" or (c2 == "bad" and input[3] and input[3] == "apple") then
                                mod:SendInputComputer(slot, player, "tojo", false, false)
                            elseif c2 == "chipi" or c2 == "chapa" or c2 == "chipichipi" or c2 == "chapachapa" then
                                mod:SendInputComputer(slot, player, "Magico mi dubidubi boom, boom, boom, boom", false, false)
                            elseif c2 == "calibrate" then
                                mod:SendInputComputer(slot, player, "Input: <number> <string>, input a satellite number and a planet name to force its boss to spawn in a set battle, [1-2] = Astral Challenge, [3-5] = Absolute Planets", false, false)
                            elseif c2 == "ariral" then
                                mod:SendInputComputer(slot, player, "You said shrimp is crap", false, false)
                            elseif c2 == "play" then
                                mod:SendInputComputer(slot, player, "Play to round of Tic Tac Toe", false, false)
                            elseif c2 == "coords" then
                                mod:SendInputComputer(slot, player, "Input: <string>, input a room type and get its coordinates in the 13X13 map, coordinates are from 1 to 13, valid room types are the following: current, treasure, shop, boss, secret, ssecret, usecret, planetarium", false, false)
                            elseif c2 == "items" then
                                mod:SendInputComputer(slot, player, "Print the name of all your items", false, false)
                            elseif c2 == "greedcheck" then
                                mod:SendInputComputer(slot, player, "Input: <string>, check if greed mini boss will spawn in the submitted room, valid rooms are the following: shop, secret", false, false)
                            elseif c2 == "amount" then
                                mod:SendInputComputer(slot, player, "Input: <string>, prints the amount of the submitted resource, valid sources are the following: donationcoins, greedcoins, edentokens", false, false)
                            elseif c2 == "doomsday" then
                                mod:SendInputComputer(slot, player, "Displays the time remaining until armageddon in hours, minutes and seconds", false, false)
                            elseif c2 == "item" then
                                mod:SendInputComputer(slot, player, "Displays the item present in the treasure room", false, false)
                            elseif c2 == "market" then
                                mod:SendInputComputer(slot, player, "Displays a list of three items to buy", false, false)
                            elseif c2 == "buy" then
                                mod:SendInputComputer(slot, player, "Input: <number>, buys the item with the selected ID if available", false, false)
                            elseif c2 == "donate" then
                                mod:SendInputComputer(slot, player, "Input: <number>, donated the inputted amount to the donation machine", false, false)
                            elseif c2 == "sell" then
                                mod:SendInputComputer(slot, player, "Input: <string> <string>, input first an account to deposit the money and then the name of an item to sell, valid accounts are: own,  donationcoins, greedcoins, edentokens", false, false)
                            elseif c2 == "bet" then
                                mod:SendInputComputer(slot, player, "Input: <string> <number>, start a Black Jack game, input an account to play money with and an amount to bet.", false, false)
                            elseif c2 == "aaaaa" then
                                mod:SendInputComputer(slot, player, "aaaaa", false, false)
                            else
                                mod:SendInputComputer(slot, player, "Command not found, type \"help\" to see a list of commands", false, false)
                            end
                        else
                            mod:SendInputComputer(slot, player, "Here is a list of commands:", false, false)
                            mod:SendInputComputer(slot, player, "Type \"help <command>\" for instructions", false, false)
                            local line = "clear - exit - calibrate - coords - amount - doomsday - play - bet - market - buy - sell - timeset - math - items - item - greedcheck - donate"
                        end
                    ]]
                    mod:SendInputComputer(slot, player, line, false, false)
                elseif c2 == "kill" then
                    mod:SendInputComputer(slot, player, "kys", false, false)
                elseif c2 == "seed" then
                    mod:SendInputComputer(slot, player, "Prints your run seed", false, false)
                elseif c2 == "clear" then
                    mod:SendInputComputer(slot, player, "Clears the console", false, false)
                elseif c2 == "exit" then
                    mod:SendInputComputer(slot, player, "Exit the current process", false, false)
                elseif c2 == "timeset" then
                    mod:SendInputComputer(slot, player, "Input: <number>,set game time to the submitted value", false, false)
                elseif c2 == "math" then
                    mod:SendInputComputer(slot, player, "Input: <number> <string> <number>, input two numbers and an operator to print the result, valid operators are the following: add, sub, mul, div", false, false)
                elseif c2 == "badapple" or (c2 == "bad" and input[3] and input[3] == "apple") then
                    mod:SendInputComputer(slot, player, "tojo", false, false)
                elseif c2 == "chipi" or c2 == "chapa" or c2 == "chipichipi" or c2 == "chapachapa" then
                    mod:SendInputComputer(slot, player, "Magico mi dubidubi boom, boom, boom, boom", false, false)
                elseif c2 == "calibrate" then
                    mod:SendInputComputer(slot, player, "Input: <number> <string>, input a satellite number and a planet name to force its boss to spawn in a set battle, [1-2] = Astral Challenge, [3-5] = Absolute Planets", false, false)
                elseif c2 == "ariral" then
                    mod:SendInputComputer(slot, player, "You said shrimp is crap", false, false)
                elseif c2 == "play" then
                    mod:SendInputComputer(slot, player, "Play to round of Tic Tac Toe", false, false)
                elseif c2 == "coords" then
                    mod:SendInputComputer(slot, player, "Input: <string>, input a room type and get its coordinates in the 13X13 map, coordinates are from 1 to 13, valid room types are the following: current, treasure, shop, boss, secret, ssecret, usecret, planetarium", false, false)
                elseif c2 == "items" then
                    mod:SendInputComputer(slot, player, "Print the name of all your items", false, false)
                elseif c2 == "greedcheck" then
                    mod:SendInputComputer(slot, player, "Input: <string>, check if greed mini boss will spawn in the submitted room, valid rooms are the following: shop, secret", false, false)
                elseif c2 == "amount" then
                    mod:SendInputComputer(slot, player, "Input: <string>, prints the amount of the submitted resource, valid sources are the following: donationcoins, greedcoins, edentokens", false, false)
                elseif c2 == "doomsday" then
                    mod:SendInputComputer(slot, player, "Displays the time remaining until armageddon in hours, minutes and seconds", false, false)
                elseif c2 == "item" then
                    mod:SendInputComputer(slot, player, "Displays the item present in the treasure room", false, false)
                elseif c2 == "market" then
                    mod:SendInputComputer(slot, player, "Displays a list of three items to buy", false, false)
                elseif c2 == "buy" then
                    mod:SendInputComputer(slot, player, "Input: <number>, buys the item with the selected ID if available", false, false)
                elseif c2 == "donate" then
                    mod:SendInputComputer(slot, player, "Input: <number>, donated the inputted amount to the donation machine", false, false)
                elseif c2 == "sell" then
                    mod:SendInputComputer(slot, player, "Input: <string> <string>, input first an account to deposit the money and then the name of an item to sell, valid accounts are: own,  donationcoins, greedcoins, edentokens", false, false)
                    mod:SendInputComputer(slot, player, "Then input the name of the item you want to sell, to see your items type: \"items\"", false, false)
                elseif c2 == "bet" then
                    mod:SendInputComputer(slot, player, "Input: <string> <number>, start a Black Jack game, input an account to play money with and an amount to bet, valid accounts are: own,   donationcoins, greedcoins,        edentokens.", false, false)
                    mod:SendInputComputer(slot, player, "Then input the amount you want to bet.", false, false)
                elseif c2 == "aaaaa" then
                    mod:SendInputComputer(slot, player, "aaaaa", false, false)
                else
                    mod:SendInputComputer(slot, player, "Command not found, type \"help\" to see a list of commands", false, false)
                end
            else
                mod:SendInputComputer(slot, player, "Here is a list of commands:", false, false)
                local line = "clear - exit - calibrate - coords - amount - doomsday - play - bet - market - buy - sell - timeset -  math - items - item - greedcheck - donate"
                mod:SendInputComputer(slot, player, line, false, false)
            end
        elseif input[1] == "among us" then--wip
            mod:SendInputComputer(slot, player, "when the mom is sus", false, false)
        elseif input[1] and #input[1] == 6 and (string.byte(input[1]:sub(1, 1))*string.byte(input[1]:sub(2, 2))*string.byte(input[1]:sub(3, 3))*string.byte(input[1]:sub(4, 4))*string.byte(input[1]:sub(5, 5))*string.byte(input[1]:sub(6, 6)) == 1410855900300) then
            mod:SendInputComputer(slot, player, "you're going to cut yourself on   that edge", false, false)
        elseif input[1] == "aaaaa" then
            mod:SendInputComputer(slot, player, "aaaaa", false, false)
        else
            mod:SendInputComputer(slot, player, "Command not recognized", false, false)
        end

    else
        if process == "tictactoe" then
            if input[1] == "exit" then
                mod:OutComputer(slot, data)
            elseif input[1] and #input[1]==2 then
                local X = string.upper(input[1]:sub(1,1))
                local Y = input[1]:sub(2,2)
                if not (X=="A" or X=="B" or X=="C") or not (Y=="1" or Y=="2" or Y=="3") then
                    mod:SendInputComputer(slot, player, "Error, invalid coordinate", false, false)
                else
                    local map = {A = 1, B = 2, C = 3}
                    local sX = map[X]
                    local sY = tonumber(Y)
                    local ended = mod:tictactoe_play(slot, player, data, sX, sY)
                    if ended ~= nil or data.current_state == "Done" then
                        if ended == "X" then
                            mod:SendInputComputer(slot, player, "You won 1 penny", false, false)
                            Isaac.GetPlayer(0):AddCoins(1)
                            sfx:Play(SoundEffect.SOUND_PENNYPICKUP)
                        end
                        mod:OutComputer(slot, data)
                    end
                end
            end
        elseif process == "blackjack" then
            if input[1] == "hit" or input[1] == "stand" or input[1] == "double" or input[1] == "insurance" then
                mod:play_blackjack(slot, data, player, input[1], true)

            elseif input[1] == "exit" or input[1] == "surrender" then
                    mod:OutComputer(slot, data)
            else
                mod:show_blackjack(slot, data, player)
                mod:SendInputComputer(slot, player, "Invalid choice", false, false)
            end

        else
            mod:SendInputComputer(slot, player, "FATAL ERROR, unrecognized process", false, false)
        end
    end
end

function mod:ComputerNewRoom()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local roomindex = level:GetCurrentRoomIndex()
    local roomdesc = level:GetRoomByIdx(roomindex)

    if mod.savedatafloor().setTreasureRoom and mod.savedatafloor().setTreasureRoom >= 0 and mod.savedatafloor().setTreasure and mod.savedatafloor().setTreasure > 0 and roomdesc.VisitedCount == 1 then
        local _collectible = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)[1]
        if _collectible then
            local collectible = _collectible:ToPickup()
            if collectible then
                collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.savedatafloor().setTreasure)
            end
        end
        mod:scheduleForUpdate(function()
            mod.savedatafloor().setTreasureRoom = -1
            mod.savedatafloor().setTreasure = -1
        end, 1)
    else

    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ComputerNewRoom)

function mod:CompuerGetResource(resource)

    local amount
    if resource == "own" or resource == "current" then
        amount = Isaac.GetPlayer(0):GetNumCoins()
    elseif resource == "edentokens" or resource == "tokens" or resource == "edens" then
        amount = persistentGameData:GetEventCounter(EventCounter.EDEN_TOKENS)
    elseif resource == "coins" or resource == "donationcoins" then
        amount = persistentGameData:GetEventCounter(EventCounter.DONATION_MACHINE_COUNTER)
    elseif resource == "gcoins" or resource == "greedcoins" then
        amount = persistentGameData:GetEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER)
    end
    return amount
end
function mod:CompuerPayResource(resource, amount)

    if resource == "own" or resource == "current" then
        Isaac.GetPlayer(0):AddCoins(-amount)
    elseif resource == "edentokens" or resource == "tokens" or resource == "edens" then
        persistentGameData:IncreaseEventCounter(EventCounter.EDEN_TOKENS, -amount)
    elseif resource == "coins" or resource == "donationcoins" then
        persistentGameData:IncreaseEventCounter(EventCounter.DONATION_MACHINE_COUNTER, -amount)
    elseif resource == "gcoins" or resource == "greedcoins" then
        persistentGameData:IncreaseEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER, -amount)
    end
end


function mod:OnComputerDestruction(slot)
    if slot.SubType == mod.EntityInf[mod.Entity.Computer].SUB then
        sfx:Play(Isaac.GetSoundIdByName("windows_error"))
        slot.HitPoints = 0

    end
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.OnComputerDestruction, mod.EntityInf[mod.Entity.Computer].VAR)


--card
function mod:OnPunchedCardUse(card, player, flags)
    
    local position = player.Position + Vector(60,0):Rotated(rng:RandomFloat()*360)
    mod.ModFlags.IsThereCusmonSlot = true
    local computer = mod:SpawnEntity(mod.Entity.Computer, game:GetRoom():GetClampedPosition(position,0), Vector.Zero, nil)
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnPunchedCardUse, mod.ComputerConts.cardId)


function mod:OnPunchedSpawn(pickup, variant, subType)

    local itemConfig = Isaac:GetItemConfig():GetCard(subType)
    if itemConfig:IsCard() then
        if pickup then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.ComputerConts.cardId)
        end
        return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.ComputerConts.cardId}
    end
end
--mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnPunchedSpawn, {"computer (HC)", mod.ComputerConts.cardChance, PickupVariant.PICKUP_TAROTCARD, -1, mod.ComputerConts.cardId})