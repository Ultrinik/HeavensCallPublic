local mod = HeavensCall
local game = Game()
local json = require("json")
local persistentData = Isaac.GetPersistentGameData()
local sfx = SFXManager()


function mod.GetSaveData()
    return mod.savedatadss()
end

function mod.StoreSaveData()
    mod:SaveModdedModData(true)
end

--
-- End of generic data storage manager
--

--
-- MenuProvider
--

-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "Dead Sea Scrolls (Heavens Call)"

-- Every MenuProvider function below must have its own implementation in your mod, in order to
-- handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    mod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return mod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    mod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return mod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        mod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return mod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    mod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return mod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    mod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return mod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    mod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return mod.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    mod.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return mod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    mod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return mod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    mod.GetSaveData().MenusPoppedUp = var
end

local dssmenucore = include("scripts.libs.dssmenucore")

-- This function returns a table that some useful functions and defaults are stored on.
local dssmod = dssmenucore.init(DSSModName, MenuProvider)

local achievement_names = {
    "astral_challenge (HC)",
    "lunar_pact (HC)",
    "retro_planet (HC)",
    "clairvoyance (HC)",
    "balls_up (HC)",
    "glass_heart (HC)",
    "telescope (HC)",
    "titan (HC)",
    "double_nothing (HC)",
    "challenge_everchanger (HC)",
    "curse_wanderer (HC)",
    "lil_sol (HC)",
    "hyperdice (HC)",
    "space_jam (HC)",
    "asteroid_belt (HC)",
    "void_pickups_A (HC)",
    "heralds_stallion (HC)",
    "panspermia (HC)",
    "theia (HC)",
    "rocket_engine (HC)",
    "void_matter (HC)",
    "stellar_battery (HC)",
    "mothership (HC)",
    "golden_telescope (HC)",
    "quasar (HC)",
    "red_shovel (HC)",
    "picatrix (HC)",
    "infinity_chest (HC)",
    "mercury (HC)",
    "venus (HC)",
    "terra (HC)",
    "mars (HC)",
    "jupiter (HC)",
    "saturn (HC)",
    "uranus (HC)",
    "neptune (HC)",
    "kuiper (HC)",
    "luna (HC)",
    "errant (HC)",
    "rsaturn (HC)",
    "sol (HC)",
    "card_foil (HC)"
}

-- Adding a Menu
-- Creating a menu like any other DSS menu is a simple process. You need a "Directory", which
-- defines all of the pages ("items") that can be accessed on your menu, and a "DirectoryKey", which
-- defines the state of the menu.
local directory = {
    -- The keys in this table are used to determine button destinations.
    main = {
        -- "title" is the big line of text that shows up at the top of the page!
        title = 'heaven\'s call',
        -- "buttons" is a list of objects that will be displayed on this page. The meat of the menu!
        buttons = {
            -- The simplest button has just a "str" tag, which just displays a line of text.

            -- The "action" tag can do one of three pre-defined actions:
            -- 1) "resume" closes the menu, like the resume game button on the pause menu. Generally
            --    a good idea to have a button for this on your main page!
            -- 2) "back" backs out to the previous menu item, as if you had sent the menu back
            --    input.
            -- 3) "openmenu" opens a different dss menu, using the "menu" tag of the button as the
            --    name.

            -- The "dest" option, if specified, means that pressing the button will send you to that
            -- page of your menu.
            -- If using the "openmenu" action, "dest" will pick which item of that menu you are sent
            -- to.
            { str = 'settings',    dest = 'settings' },
            { str = 'mod settings',    dest = 'mod_settings' },
            { str = 'unlocks',    dest = 'unlocks' },

            -- A few default buttons are provided in the table returned from the `init` function.
            -- They are buttons that handle generic menu features, like changelogs, palette, and the
            -- menu opening keybind. They will only be visible in your menu if your menu is the only
            -- mod menu active. Otherwise, they will show up in the outermost Dead Sea Scrolls menu
            -- that lets you pick which mod menu to open. This one leads to the changelogs menu,
            -- which contains changelogs defined by all mods.
            dssmod.changelogsButton,
        },
        -- A tooltip can be set either on an item or a button, and will display in the corner of the
        -- menu while a button is selected or the item is visible with no tooltip selected from a
        -- button. The object returned from the `init` function contains a default tooltip that
        -- describes how to open the menu, at "menuOpenToolTip". It's generally a good idea to use
        -- that one as a default!
        tooltip = dssmod.menuOpenToolTip
    },
    settings = {
        title = 'settings',
        
        buttons = {
            -- These buttons are all generic menu handling buttons, provided in the table returned
            -- from the `init` function. They will only show up if your menu is the only mod menu
            -- active. You should generally include them somewhere in your menu, so that players can
            -- change the palette or menu keybind even if your mod is the only menu mod active. You
            -- can position them however you like, though!
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            dssmod.menuHintButton,
            dssmod.menuBuzzerButton,
        }
    },
    mod_settings = {
        title = 'mod settings',
        
        buttons = {

            { str = 'room chances',    dest = 'rooms' },
            { str = 'others',    dest = 'settingsother' },
        }
    },
    rooms = {
        title = 'room chances',
        buttons = {

            --[[
            {
                str = 'choice option',
                -- The "choices" tag on a button allows you to create a multiple-choice setting.
                choices = { 'choice a', 'choice b', 'choice c' },
                -- The "setting" tag determines the default setting, by list index. EG "1" here will
                -- result in the default setting being "choice a".
                setting = 1,
                -- "variable" is used as a key to story your setting; just set it to something
                -- unique for each setting!
                variable = 'ExampleChoiceOption',
                -- When the menu is opened, "load" will be called on all settings-buttons. The
                -- "load" function for a button should return what its current setting should be.
                -- This generally means looking at your mod's save data, and returning whatever
                -- setting you have stored.
                load = function()
                    return mod.GetSaveData().exampleoption or 1
                end,
                -- When the menu is closed, "store" will be called on all settings-buttons. The
                -- "store" function for a button should save the button's setting (passed in as the
                -- first argument) to save data!
                store = function(var)
                    mod.GetSaveData().exampleoption = var
                end,
                -- A simple way to define tooltips is using the "strset" tag, where each string in
                -- the table is another line of the tooltip.
                tooltip = { strset = { 'configure', 'my options', 'please!' } }
            },
            ]]--

            --first astral
            {
                -- Creating gaps in your page can be done simply by inserting a blank button. The
                -- "nosel" tag will make it impossible to select, so it'll be skipped over when
                -- traversing the menu, while still rendering!
                str = 'first astral',
                fsize = 3,
                nosel = true
            },
            {
                str = 'challenge chance',
                fsize = 3,
                -- If "min" and "max" are set without "slider", you've got yourself a number option!
                -- It will allow you to scroll through the entire range of numbers from "min" to
                -- "max", incrementing by "increment".
                min = 0,
                max = 100,
                increment = 1,
                
                -- You can also specify a prefix or suffix that will be applied to the number, which
                -- is especially useful for percentages!
                --pref = 'hi! ',
                suf = '%',
                setting = mod.astralChallengeConsts.BASE_SPAWN_CHANCE1,
                variable = "AstralChallengeChance",
                load = function()
                    return mod.savedatasettings().roomSpawnChance or mod.astralChallengeConsts.BASE_SPAWN_CHANCE1
                end,
                store = function(var)
                    mod.savedatasettings().roomSpawnChance = var
                end,
                tooltip = { strset = { "default "..tostring(mod.astralChallengeConsts.BASE_SPAWN_CHANCE1).."%", "ch. 2 to ch. 3" } },
            },
            
            --second astral
            {
                str = 'second astral',
                fsize = 3,
                nosel = true
            },
            {
                str = 'challenge chance',
                fsize = 3,
                
                min = 0,
                max = 100,
                increment = 1,

                suf = '%',
                setting = mod.astralChallengeConsts.BASE_SPAWN_CHANCE2,
                variable = "AstralChallengeChance2",
                load = function()
                    return mod.savedatasettings().roomSpawnChance2 or mod.astralChallengeConsts.BASE_SPAWN_CHANCE2
                end,
                store = function(var)
                    mod.savedatasettings().roomSpawnChance2 = var
                end,
                tooltip = { strset = { "default "..tostring(mod.astralChallengeConsts.BASE_SPAWN_CHANCE2).."%", "ch. 5 and", "4.5 only" } },
            },
            
            --lunar pact
            {
                str = 'lunar pact chance',
                fsize = 3,

                min = 0,
                max = 100,
                increment = 1,

                suf = '%',
                setting = mod.lunarPactConsts.BASE_SPAWN_CHANCE,
                variable = "LunarPactChance",
                load = function()
                    return mod.savedatasettings().lunarRoomSpawnChance or mod.lunarPactConsts.BASE_SPAWN_CHANCE
                end,
                store = function(var)
                    mod.savedatasettings().lunarRoomSpawnChance = var
                end,
                tooltip = { strset = { "default "..tostring(mod.lunarPactConsts.BASE_SPAWN_CHANCE).."%", "devil deal", "room alt" , "", "only boss", "room" } },
            },
            {
                str = 'red room',
                fsize = 3,
                nosel = true
            },
            {
                str = 'errant chance',
                fsize = 3,

                min = 0,
                max = 100,
                increment = 0.25,

                suf = '%',
                setting = mod.RedErrantChance,
                variable = "RedErrantChance",
                load = function()
                    return mod.savedatasettings().redErrantSpawnChance or mod.RedErrantChance
                end,
                store = function(var)
                    mod.savedatasettings().redErrantSpawnChance = var
                end,
                tooltip = { strset = { "default "..tostring(mod.RedErrantChance).."%", "", "chance for", "errant on" , "red key use" } },
            },
        }
    },
    settingsother = {
        title = 'other settings',

        buttons = {

            {
                str = 'alt ultra secret',
                fsize = 3,
                nosel = true
            },
            {
                str = 'room skin',
                -- The "choices" tag on a button allows you to create a multiple-choice setting.
                choices = { 'on', 'off' },
                -- The "setting" tag determines the default setting, by list index. EG "1" here will
                -- result in the default setting being "choice a".
                setting = 1,
                -- "variable" is used as a key to story your setting; just set it to something
                -- unique for each setting!
                variable = 'UltraSecretSkinOption',
                -- When the menu is opened, "load" will be called on all settings-buttons. The
                -- "load" function for a button should return what its current setting should be.
                -- This generally means looking at your mod's save data, and returning whatever
                -- setting you have stored.
                load = function()
                    return mod.savedatasettings().ultraSkin or 1
                end,
                -- When the menu is closed, "store" will be called on all settings-buttons. The
                -- "store" function for a button should save the button's setting (passed in as the
                -- first argument) to save data!
                store = function(var)
                    mod.savedatasettings().ultraSkin = var
                end,
                -- A simple way to define tooltips is using the "strset" tag, where each string in
                -- the table is another line of the tooltip.
                tooltip = { strset = { 'enable skin', 'for ultra', 'secret room', "", 'default on' } }
            },

            {
                str = 'gateway after boss',
                
                choices = { 'on', 'off' },
                setting = 1,
                variable = 'GatewayOption',
                
                load = function()
                    return mod.savedatasettings().victoryChest or 1
                end,
                store = function(var)
                    mod.savedatasettings().victoryChest = var
                end,
                
                tooltip = { strset = { 'enable chest', 'and void', 'portal to', 'spawn even if', 'not in sol', 'path', "", 'default on' } }
            },
            --[[
            {
                str = 'planet weather',
                
                choices = { 'on', 'off' },
                setting = 1,
                variable = 'WeatherOption',
                
                load = function()
                    return mod.savedatasettings().weather or 1
                end,
                store = function(var)
                    mod.savedatasettings().weather = var
                end,
                
                tooltip = { strset = { 'enable planets', 'to summon', 'weathers', '(may be laggy)', "", 'default on' } }
            },
            ]]--
            
            {
                str = 'astral notice',
                
                choices = { 'wisps', 'text', 'none' },
                setting = 1,
                variable = 'TooltipOption',
                
                load = function()
                    return mod.savedatasettings().astraltooltip or 1
                end,
                store = function(var)
                    mod.savedatasettings().astraltooltip = var
                end,
                
                tooltip = { strset = { 'hint for when','the astral', 'challenge room','spawns', "", 'default wisps' } }
            },

            {
                str = 'eternal boss chance',

                displayif = function(button, item, menuObj)
                    return (Isaac.GetSoundIdByName("super sloth spawn spiders") > 0)
                end,

                min = 0,
                max = 100,
                increment = 5,

                suf = '%',
                setting = mod.ETERNAL_CHANCE,
                variable = "EternalChance",
                load = function()
                    return mod.savedatasettings().eternalChance or mod.ETERNAL_CHANCE
                end,
                store = function(var)
                    mod.savedatasettings().eternalChance = var
                end,
                tooltip = { strset = {"eternal astral", "boss chance",  "default "..tostring(mod.ETERNAL_CHANCE).."%"} },
            },

            {
                str = 'tainted treasure pool',

                displayif = function(button, item, menuObj)
                    return TaintedTreasure ~= nil
                end,

                choices = { 'on', 'off' },
                setting = 0,
                variable = "TaintedTreasurePool",

                load = function()
                    return mod.savedatasettings().taintedTreasurePool or 0
                end,
                store = function(var)
                    mod.savedatasettings().taintedTreasurePool = var
                end,
                tooltip = { strset = { "retrograde pltrm.", "in TT item pool", "default off" } },
            },
        }
    },
    
    unlocks = {
        title = 'unlock manager',
        
        buttons = {

            { str = 'normal chrs.',    dest = 'unlock_normal' },
            { str = 'tainted chrs.',    dest = 'unlock_tainted' },
            { str = 'challenges',    dest = 'unlock_challenges' },
            { str = 'no-hits',    dest = 'unlock_nohit' },
            { str = 'others',    dest = 'unlock_others' },
            { str = '',         nosel = true},
            { str = 'unlock/lock all',    dest = 'unlock_global' },
        }
    },
    
    unlock_normal = {
        title = 'unlock manager',
        buttons = {
            
            {
                str = 'the hyperdice',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'IsaacUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("hyperdice (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("hyperdice (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("hyperdice (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            {
                str = 'space jam',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'MaggyUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("space_jam (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("space_jam (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("space_jam (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            {
                str = 'asteroid belt',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'CainUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("asteroid_belt (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("asteroid_belt (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("asteroid_belt (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'abyssal pickups',
                nosel = true
            },
            {
                str = 'set a',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'JudasUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("void_pickups_A (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("void_pickups_A (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("void_pickups_A (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'heralds stallion',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'QQQUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("heralds_stallion (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("heralds_stallion (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("heralds_stallion (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'panspermia',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'EveUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("panspermia (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("panspermia (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("panspermia (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'theia',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'SamsonUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("theia (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("theia (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("theia (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'rocket engine',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'AzazelUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("rocket_engine (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("rocket_engine (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("rocket_engine (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'void matter',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'LazarusUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("void_matter (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("void_matter (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("void_matter (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'stellar battery',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'EdenUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("stellar_battery (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("stellar_battery (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("stellar_battery (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'mothership',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'LilithUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("mothership (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("mothership (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("mothership (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'golden telescope',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'KeeperUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("golden_telescope (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("golden_telescope (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("golden_telescope (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'quasar',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'ApollyonUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("quasar (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("quasar (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("quasar (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'red shovel',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'ForgottenUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("red_shovel (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("red_shovel (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("red_shovel (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'picatrix',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'BethanyUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("picatrix (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("picatrix (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("picatrix (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            }
        }
    },
    
    unlock_tainted = {
        title = 'unlock manager',
        buttons = {
            
            {
                str = 'infinity chest',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'TLostUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("infinity_chest (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("infinity_chest (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("infinity_chest (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'unlocked by', 'default' } }
            }
        }
    },
    
    unlock_challenges = {
        title = 'unlock manager',
        buttons = {
            
            {
                str = 'escape the',
                nosel = true
            },
            {
                str = 'everchanger',
                nosel = true
            },
            {
                str = 'challenge',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'EverchangerUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("challenge_everchanger (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("challenge_everchanger (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("challenge_everchanger (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'die to the', 'everchanger in', 'tower of babel'} }
            },
            
            {
                str = 'double or nothing',
                nosel = true
            },
            {
                str = 'mode',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'DoubleNothingUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("double_nothing (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("double_nothing (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("double_nothing (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'beat challenge', 'tower of babel', 'on ascended' } }
            },
            
            {
                str = 'curse of the',
                nosel = true
            },
            {
                str = 'wanderer and',
                nosel = true
            },
            {
                str = 'marshmallow pill',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'WandererUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("curse_wanderer (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("curse_wanderer (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("curse_wanderer (HC)"))
                    end
                    mod.savedatasettings().OLD_challenge_Everchanger = true
                end,
                
                tooltip = { strset = { 'beat challenge', 'escape the', 'everchanger' } }
            },

            {
                str = 'lil sol',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'LilSolUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("lil_sol (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("lil_sol (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("lil_sol (HC)"))
                    end
                end,
                
                tooltip = { strset = { 'beat challenge', 'true solar', 'system' } }
            },
        }
    },

    unlock_nohit = {
        title = 'unlock manager',
        buttons = {

            {
                str = 'bismuth penny',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'MercuryNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("mercury (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("mercury (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("mercury (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'mercury on', 'radiant mode'} }
            },

            {
                str = 'fervent incense',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'VenusNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("venus (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("venus (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("venus (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'venus on', 'radiant mode'} }
            },

            {
                str = 'bad apple',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'TerraNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("terra (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("terra (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("terra (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'terra on', 'radiant mode'} }
            },

            {
                str = 'nanite',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'MarsNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("mars (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("mars (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("mars (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'mars on', 'radiant mode'} }
            },

            {
                str = 'broken battery',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'JupiterNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("jupiter (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("jupiter (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("jupiter (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'jupiter on', 'radiant mode'} }
            },

            {
                str = 'golden gear',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'SaturnNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("saturn (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("saturn (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("saturn (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'saturn on', 'radiant mode'} }
            },

            {
                str = 'clay brick',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'UranusNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("uranus (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("uranus (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("uranus (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'uranus on', 'radiant mode'} }
            },

            {
                str = 'neptunes lure',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'NeptuneNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("neptune (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("neptune (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("neptune (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'neptune on', 'radiant mode'} }
            },

            {
                str = 'cursed effigy',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'KuiperNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("kuiper (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("kuiper (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("kuiper (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'kuiper h. on', 'radiant mode'} }
            },

            {
                str = 'lunar crown',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'LunaNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("luna (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("luna (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("luna (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'luna on', 'radiant mode'} }
            },

            {
                str = 'quantum shard',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'ErrantNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("errant (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("errant (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("errant (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'errant on', 'radiant mode'} }
            },

            {
                str = 'i',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'RSaturnNohitUnlock',

                displayif = function(button, item, menuObj)
                    return TheFuture ~= nil
                end,

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("rsaturn (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("rsaturn (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("rsaturn (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'saturn on', 'radiant mode'} }
            },

            {
                str = 'fine tunning',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'SolNohitUnlock',

                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("sol (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,

                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("sol (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("sol (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat', 'sol on', 'radiant mode'} }
            },

        }
    },

    unlock_others = {
        title = 'unlock manager',
        buttons = {
            {
                str = 'astral challenge',
                nosel = true
            },
            {
                str = 'room',
                -- The "choices" tag on a button allows you to create a multiple-choice setting.
                choices = { 'unlocked', 'locked' },
                -- The "setting" tag determines the default setting, by list index. EG "1" here will
                -- result in the default setting being "choice a".
                setting = 1,
                -- "variable" is used as a key to story your setting; just set it to something
                -- unique for each setting!
                variable = 'AstralChallengeUnlock',
                -- When the menu is opened, "load" will be called on all settings-buttons. The
                -- "load" function for a button should return what its current setting should be.
                -- This generally means looking at your mod's save data, and returning whatever
                -- setting you have stored.
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("astral_challenge (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                -- When the menu is closed, "store" will be called on all settings-buttons. The
                -- "store" function for a button should save the button's setting (passed in as the
                -- first argument) to save data!
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("astral_challenge (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("astral_challenge (HC)"))
                    end
                end,
                -- A simple way to define tooltips is using the "strset" tag, where each string in
                -- the table is another line of the tooltip.
                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            
            {
                str = 'lunar pact',
                nosel = true
            },
            {
                str = 'room',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'LunarPactUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("lunar_pact (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("lunar_pact (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("lunar_pact (HC)"))
                    end
                end,

                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            
            {
                str = 'retrograde',
                nosel = true
            },
            {
                str = 'planetarium items',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'RetroPlanetUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("retro_planet (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("retro_planet (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("retro_planet (HC)"))
                    end
                end,

                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            
            {
                str = 'clairvoyance and',
                nosel = true
            },
            {
                str = 'clarivoyance pills',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'ClairvoyanceUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("clairvoyance (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("clairvoyance (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("clairvoyance (HC)"))
                    end
                end,

                tooltip = { strset = { 'unlocked by', 'default' } }
            },

            {
                str = 'balls up and ',
                nosel = true
            },
            {
                str = 'balls down pills',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'BallsUpUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("balls_up (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("balls_up (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("balls_up (HC)"))
                    end
                end,

                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            {
                str = 'glass heart',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'GlassHeartUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("glass_heart (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("glass_heart (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("glass_heart (HC)"))
                    end
                end,

                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            {
                str = 'telescope machine',
                choices = { 'unlocked', 'locked' },
                setting = 1,
                variable = 'TelescopeUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("telescope (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("telescope (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("telescope (HC)"))
                    end
                end,

                tooltip = { strset = { 'unlocked by', 'default' } }
            },
            {
                str = 'titan beggar',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'TitanUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("titan (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("titan (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("titan (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat an', 'astral boss', 'in greed mode' } }
            },
            {
                str = 'card protector',
                choices = { 'unlocked', 'locked' },
                setting = 2,
                variable = 'FoilUnlock',
                
                load = function()
                    if persistentData:Unlocked(Isaac.GetAchievementIdByName("card_foil (HC)")) then
                        return 1
                    else
                        return 2
                    end
                end,
                
                store = function(var)
                    if var == 1 then
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName("card_foil (HC)"), true)
                    else
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName("card_foil (HC)"))
                    end
                end,

                tooltip = { strset = { 'beat neptune', 'at 3 am', 'in the mirror' } }
            }
        }
    },

    unlock_global = {
        title = 'unlock/lock all',
        buttons = {
            {
                str = 'unlock all',
                func = function()
                    for i, text in ipairs(achievement_names) do
                        persistentData:TryUnlock(Isaac.GetAchievementIdByName(text), true)
                    end
                    sfx:Play(SoundEffect.SOUND_POOP_LASER)
                end,
                tooltip = { strset = { 'unlock all' } },
                action = "resume"
            },
            {
                str = 'lock all',
                func = function()
                    for i, text in ipairs(achievement_names) do
                        Isaac.ExecuteCommand('lockachievement '..Isaac.GetAchievementIdByName(text))
                    end
                    sfx:Play(SoundEffect.SOUND_POOPITEM_STORE)
                end,
                tooltip = { strset = { 'lock all' } },
                action = "resume"
            },
        }
    }
}

local directorykey = {
    -- This is the initial item of the menu, generally you want to set it to your main item
    Item = directory.main,
    -- The main item of the menu is the item that gets opened first when opening your mod's menu.
    Main = 'main',
    -- These are default state variables for the menu; they're important to have in here, but you
    -- don't need to change them at all.
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Heaven's Call", {
    -- The Run, Close, and Open functions define the core loop of your menu. Once your menu is
    -- opened, all the work is shifted off to your mod running these functions, so each mod can have
    -- its own independently functioning menu. The `init` function returns a table with defaults
    -- defined for each function, as "runMenu", "openMenu", and "closeMenu". Using these defaults
    -- will get you the same menu you see in Bertran and most other mods that use DSS. But, if you
    -- did want a completely custom menu, this would be the way to do it!

    -- This function runs every render frame while your menu is open, it handles everything!
    -- Drawing, inputs, etc.
    Run = dssmod.runMenu,
    -- This function runs when the menu is opened, and generally initializes the menu.
    Open = dssmod.openMenu,
    -- This function runs when the menu is closed, and generally handles storing of save data /
    -- general shut down.
    Close = dssmod.closeMenu,
    -- If UseSubMenu is set to true, when other mods with UseSubMenu set to false / nil are enabled,
    -- your menu will be hidden behind an "Other Mods" button.
    -- A good idea to use to help keep menus clean if you don't expect players to use your menu very
    -- often!
    UseSubMenu = false,
    Directory = directory,
    DirectoryKey = directorykey
})

-- There are a lot more features that DSS supports not covered here, like sprite insertion and
-- scroller menus, that you'll have to look at other mods for reference to use. But, this should be
-- everything you need to create a simple menu for configuration or other simple use cases!
