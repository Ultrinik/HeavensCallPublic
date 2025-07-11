local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,             *%@@@@@@@@@@&/                     *%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,        *%@@@@@@@@@@@@@@@@@@@@@@@#,     .(@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,   *%@@@@@@@@#*.   ......,#@@@@@@@@@@@#,.(@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,   *%@@@#,    ...........,(%%%&@@@@@@@#,.(@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@&/    .........,*(#%%#((((*./%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@&/    ../%@@@@@@@@&#(*..  ../%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#,    ..../%&/ *%@@@%*.     ..,/#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#,    ..../%@@@&##&@#, .......,/#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#,    .,(%&@@@@@@@@@@@&(,.....,/#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#*.....,(%%#(*...,#@@@@@@%*,*(((#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#*...*/##%(*.     ../%@@@@@@%##%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#*...*#%#(*.    ......,#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@&(.*##*  ...........,*(%&@@@@@@@@#,.(@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@@%(%&@%(/,........,/##%%%&@@@@@@@#,.(@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@@@@@@@&&%#((((((((#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,     .(@@@@@@@@@@@@@@@@@@@@@@@&/      *%@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,.(@@@@@@@@@@@@@@@@@@@@@@@&/             .(@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@#,   *%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]
function mod:SputnikUpdate(familiar)
	if familiar.OrbitDistance and not (familiar.Variant == FamiliarVariant.WISP or familiar.Variant == FamiliarVariant.ITEM_WISP) then
		local data = familiar:GetData()
		local player = familiar.Player

		if player:HasTrinket(mod.Trinkets.Sputnik) then
			local factor = player:GetTrinketMultiplier(mod.Trinkets.Sputnik) + 1
			factor = factor*0.75
	
			if not data.OgDistance or not data.OgSpeed then
				data.OgDistance = familiar.OrbitDistance
				data.OgSpeed = familiar.OrbitSpeed
			end
			data.Factor_HC = factor
			familiar.OrbitDistance = data.OgDistance * factor * 1.75
			familiar.OrbitSpeed = data.OgSpeed / factor / 2

		elseif data.OgDistance and data.OgSpeed then
			familiar.OrbitDistance = data.OgDistance
			familiar.OrbitSpeed = data.OgSpeed
			data.Factor_HC = nil
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.SputnikUpdate)