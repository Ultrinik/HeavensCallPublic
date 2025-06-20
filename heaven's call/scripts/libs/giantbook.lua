local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

mod.ModFlags.playingBook = false
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_ROOM, "ModFlags.playingBook", false)

local frame = 0
function mod:BookRenderUpdate()
    if mod.ModFlags.playingBook then
        local sprite = mod.BookSprite

        frame = frame + 0.5
        local realFrame = math.floor(frame)
        sprite:SetFrame(realFrame)

        local finished = realFrame > sprite:GetFrame()
        
        local w = Isaac.GetScreenWidth()
        local h = Isaac.GetScreenHeight()
        local position = Vector(w/2, h/2)
        sprite:Render(position)

        mod:ResumeTime()

        if finished or sprite:IsFinished() then
            mod.ModFlags.playingBook = false
            mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.BookRenderUpdate)
        end
    end
end


mod.BookSprite = Sprite()
function mod:PlayBookAnimation(id, isAchivement)
    local sprite = mod.BookSprite
    frame = 0

    if isAchivement then

    else
        if id == 0 then --Hyperdice
            sprite:Load("hc/gfx/ui/giantbook/giantbook_hyperdice.anm2", true)
            sprite:Play("Appear", true)
        else

        end
    end

    mod.ModFlags.playingBook = true

    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.BookRenderUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.BookRenderUpdate)
end