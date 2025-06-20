local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

function mod:OnWandererUpdate()
    
    local level = game:GetLevel()
    if level:GetCurses() & mod.Curse.WANDERER > 0 then

        mod.savedatafloor().wanderer_time_start = mod.savedatafloor().wanderer_time_start or game.TimeCounter
        if game.TimeCounter - mod.savedatafloor().wanderer_time_start > mod.CurseConsts.WANDERER_SECONDS then
            local hud = game:GetHUD()
            
            if Options.Language == "es" then
                hud:ShowItemText("¡Un escalofrío terrible recorre tu espalda!","El Siemprecambiante se ha despertado")
            else
                hud:ShowItemText("A terrible chill runs up your spine!","The Everchanger has awakened")
            end

            mod:StartEverchangerEntity()

            mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnWandererUpdate)
        end

    else
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnWandererUpdate)
    end
end

function mod:OnWandererContinue(isContinue)
    if mod:WandererCurse() and not mod.EverchangerEntityFlags.errantMoving then
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnWandererUpdate)
        mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnWandererUpdate)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnWandererContinue)
