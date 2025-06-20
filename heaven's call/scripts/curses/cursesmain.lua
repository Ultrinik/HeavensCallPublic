local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()
local persistentData = Isaac.GetPersistentGameData()

mod.Curse = {
    APOCALYPSE = 1 << (Isaac.GetCurseIdByName("The world is ending!") - 1),
    LUNA = 1 << (Isaac.GetCurseIdByName("Curse of la Luna!") - 1),
    WANDERER = 1 << (Isaac.GetCurseIdByName("Curse of the Wanderer!") - 1),
    INVICTUS = 1 << (Isaac.GetCurseIdByName("Curse of the Invictus!") - 1)
}

function mod:CurseBlocked()
    return mod:SomebodyHasItem(CollectibleType.COLLECTIBLE_BLACK_CANDLE) or mod:ShouldEffigyBlockCurse()
end

--include("scripts.curses.apocalypse")
--include("scripts.curses.laluna")
include("scripts.curses.wanderer")
include("scripts.curses.invictus")

function mod:DoomsdayCurse()
    local level = game:GetLevel()
	return level:GetCurses() & mod.Curse.APOCALYPSE > 0
end
function mod:LaLunaCurse()
    local level = game:GetLevel()
	return level:GetCurses() & mod.Curse.LUNA > 0
end
function mod:WandererCurse()
    local level = game:GetLevel()
	return level:GetCurses() & mod.Curse.WANDERER > 0
end
function mod:InvictusCurse()
    local level = game:GetLevel()
	return level:GetCurses() & mod.Curse.INVICTUS > 0
end

mod.CurseConsts = {
    WANDERER_CHANCE = 0.1,
    WANDERER_SECONDS = math.ceil(30*60*2.5),

    INVICTUS_STARFALL_CHANCE = 1/(12*30),
}
local wanderer_verif = false
--Game():GetLevel():GetCurses() & HeavensCall.Curse.WANDERER
function mod:VerifyNewCurse(curse)
    local level = game:GetLevel()
    local curses_bit = level:GetCurses()

    --print("curses:", curses_bit)
    if curses_bit == 0 or curses_bit == LevelCurse.CURSE_OF_LABYRINTH then return end

    if (curses_bit & curse == 0) then
        if curse == mod.Curse.WANDERER then
            mod.savedatafloor().wanderer_time_start = game.TimeCounter
        end
        level:AddCurse(curse, true)
        for i=0, 20 do
            local current_curse = 1 << i
            if (current_curse ~= LevelCurse.CURSE_OF_LABYRINTH) and (curses_bit & current_curse > 0) then
                level:RemoveCurses(current_curse)
                break
            end
        end
    end
end

function mod:OnNewLevelCurse(curses_bit)
    if game.Challenge > 0 then return end
    if mod:CurseBlocked() then return end

    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnWandererUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnWandererUpdate)

    mod:scheduleForUpdate(function ()
        if wanderer_verif and not mod:ShouldEffigyBlockCurse() then
            wanderer_verif = false
            mod:VerifyNewCurse(mod.Curse.WANDERER)
        end
    end,2)

    local wanderer_chance = mod.CurseConsts.WANDERER_CHANCE
    if not (mod.savedatasettings().UnlockAll or persistentData:Unlocked(Isaac.GetAchievementIdByName("curse_wanderer (HC)"))) then
        wanderer_chance = 0
    end
    wanderer_verif = rng:RandomFloat() < wanderer_chance

    if curses_bit > 0 and (curses_bit ~= LevelCurse.CURSE_OF_LABYRINTH) then
        if wanderer_verif then
        --if rng:RandomFloat() < mod.CurseConsts.WANDERER_CHANCE then
            --level:AddCurse(mod.Curse.WANDERER, true)

            for i=0, 20 do
                local curse = 1 << i
                if curse ~= LevelCurse.CURSE_OF_LABYRINTH and curses_bit & curse > 0 then
                    --print("removed:", curse, curse > 1 << 6)
                    --level:RemoveCurses(curse)
                    mod.savedatafloor().wanderer_time_start = game.TimeCounter
                    return (curses_bit & ~curse) | mod.Curse.WANDERER
                    --break
                end
            end
        end
    else
        wanderer_verif = false
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_CURSE_EVAL, CallbackPriority.IMPORTANT-100, mod.OnNewLevelCurse)

--minimapi
if MinimapAPI then
    local sprite = Sprite()
    sprite:Load("hc/gfx/ui/minimapapi/minimapapi_cursesicons.anm2", true)

    MinimapAPI:AddMapFlag("Doomsday", mod.DoomsdayCurse, sprite, "curses", 0)
    MinimapAPI:AddMapFlag("Luna", mod.LaLunaCurse, sprite, "curses", 1)
    MinimapAPI:AddMapFlag("Wanderer", mod.WandererCurse, sprite, "curses", 2)
    MinimapAPI:AddMapFlag("Invictus", mod.InvictusCurse, sprite, "curses", 3)
end