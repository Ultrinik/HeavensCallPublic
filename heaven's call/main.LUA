HeavensCall = RegisterMod("Heaven's call", 1)
local mod = HeavensCall

local saveManager = include("scripts.libs.save_manager")
saveManager.Init(mod)
mod.SaveManager = saveManager

include("scripts.shaders")

if REPENTOGON then
    include("scripts.mainmain")
else
	include("scripts.rgonwarning")
end