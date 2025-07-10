local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local json = require("json")
local persistentData = Isaac.GetPersistentGameData()


--MINIMAPI----------------------------------------------------------------------------------------------------------------
if MinimapAPI then

	local sprite = Sprite()
	sprite:Load("hc/gfx/ui/minimapapi/minimapapi_minimapicons.anm2", true)

	MinimapAPI:AddIcon("AstralChallenge", sprite, "Icon", 0)
	MinimapAPI:AddIcon("LunarRoom", sprite, "Icon", 1)
	MinimapAPI:AddIcon("SolarBoss", sprite, "Icon", 2)
	MinimapAPI:AddIcon("HyperDice", sprite, "Icon", 3)
	MinimapAPI:AddIcon("AstralBoss", sprite, "Icon", 4)
	MinimapAPI:AddIcon("LunarBoss", sprite, "Icon", 5)
	MinimapAPI:AddIcon("EmptyHC", sprite, "Icon", 11)
	MinimapAPI:AddIcon("GlitchAstralChallenge", sprite, "Icon", 12)
	MinimapAPI:AddIcon("GlitchAstralBoss", sprite, "Icon", 13)

end

--ENHANCED BOSS BARS----------------------------------------------------------------------------------------------------------------
if HPBars then
	--Creating a better planetarium bar
	HPBars.BarStyles["PlanetariumHC"] = {
		sprite ="hc/gfx/ui/bosshp_bars/bossbar_design_planetariumHC.png",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble the Planetarium but Darker"
	}
	HPBars.BarStyles["LunarHC"] = {
		sprite ="hc/gfx/ui/bosshp_bars/bossbar_design_lunarHC.png",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble the Darker Planetarium but Reder"
	}
	HPBars.BarStyles["QuantumHC"] = {
		sprite ="hc/gfx/ui/bosshp_bars/errant2_bar.png",
		barAnm2 = "gfx/ui/bosshp_bars/".."bosses/dogma_bosshp.anm2",
		barAnimationType = "Animated",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble the quantum shard"
	}
	HPBars.BarStyles["SolHC"] = {
		sprite ="hc/gfx/ui/bosshp_bars/bossbar_design_lunarHC.png",
		idleColoring = HPBars.BarColorings.none,
		tooltip = "Styled to resemble light"
	}

	HPBars.Conditions["isFliped"] =
		(function(entity)
			return entity:GetData().FlipFlag
		end)
	HPBars.Conditions["isBlood"] =
		(function()
			return mod:IsWomb()
		end)

	local truFunc = function(entity)
		return entity:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_HIDE_HP_BAR)
	end
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Statue].ID).."."..tostring(mod.EntityInf[mod.Entity.Statue].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Statue].ID).."."..tostring(mod.EntityInf[mod.Entity.Statue].VAR+1)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.MercuryBird].ID).."."..tostring(mod.EntityInf[mod.Entity.MercuryBird].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Terra2].ID).."."..tostring(mod.EntityInf[mod.Entity.Terra2].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Horsemen].ID).."."..tostring(mod.EntityInf[mod.Entity.Horsemen].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Horsemen].ID).."."..tostring(mod.EntityInf[mod.Entity.Horsemen].VAR+1)] = truFunc
	HPBars.BossIgnoreList[tostring(EntityType.ENTITY_DOGMA)..".10"] = truFunc
	HPBars.BossIgnoreList[tostring(EntityType.ENTITY_ADVERSARY)..".0"] = function(entity) if entity:GetData().HeavensCall then return true end end
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Attlerock].ID).."."..tostring(mod.EntityInf[mod.Entity.Attlerock].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.HollowsLantern].ID).."."..tostring(mod.EntityInf[mod.Entity.HollowsLantern].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.WhiteHole].ID).."."..tostring(mod.EntityInf[mod.Entity.WhiteHole].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.AshTwin].ID).."."..tostring(mod.EntityInf[mod.Entity.AshTwin].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Charon1].ID).."."..tostring(mod.EntityInf[mod.Entity.Charon1].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Charon2].ID).."."..tostring(mod.EntityInf[mod.Entity.Charon2].VAR)] = truFunc
	--HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Ceres].ID).."."..tostring(mod.EntityInf[mod.Entity.Ceres].VAR)] = truFunc

	
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.SolarBlaster].ID).."."..tostring(mod.EntityInf[mod.Entity.SolarBlaster].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.SolSnake].ID).."."..tostring(mod.EntityInf[mod.Entity.SolSnake].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.SolSword].ID).."."..tostring(mod.EntityInf[mod.Entity.SolSword].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.BossSolStatue].ID).."."..tostring(mod.EntityInf[mod.Entity.BossSolStatue].VAR)] = truFunc
	
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.LilSteven].ID).."."..tostring(mod.EntityInf[mod.Entity.LilSteven].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.SaturnGhost].ID).."."..tostring(mod.EntityInf[mod.Entity.SaturnGhost].VAR)] = truFunc
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.StevenBox].ID).."."..tostring(mod.EntityInf[mod.Entity.StevenBox].VAR)] = truFunc
	
	HPBars.BossIgnoreList[tostring(mod.EntityInf[mod.Entity.Everchanger].ID).."."..tostring(mod.EntityInf[mod.Entity.Everchanger].VAR)] = truFunc


	--Adding the bars
	Jid = tostring(mod.EntityInf[mod.Entity.Jupiter].ID).."."..tostring(mod.EntityInf[mod.Entity.Jupiter].VAR)
	Sid = tostring(mod.EntityInf[mod.Entity.Saturn].ID).."."..tostring(mod.EntityInf[mod.Entity.Saturn].VAR)
	Uid = tostring(mod.EntityInf[mod.Entity.Uranus].ID).."."..tostring(mod.EntityInf[mod.Entity.Uranus].VAR)
	Nid = tostring(mod.EntityInf[mod.Entity.Neptune].ID).."."..tostring(mod.EntityInf[mod.Entity.Neptune].VAR)

	MRid = tostring(mod.EntityInf[mod.Entity.Mercury].ID).."."..tostring(mod.EntityInf[mod.Entity.Mercury].VAR)
	Vid = tostring(mod.EntityInf[mod.Entity.Venus].ID).."."..tostring(mod.EntityInf[mod.Entity.Venus].VAR)
	T1id = tostring(mod.EntityInf[mod.Entity.Terra1].ID).."."..tostring(mod.EntityInf[mod.Entity.Terra1].VAR)
	T3id = tostring(mod.EntityInf[mod.Entity.Terra3].ID).."."..tostring(mod.EntityInf[mod.Entity.Terra3].VAR)
	Mid = tostring(mod.EntityInf[mod.Entity.Mars].ID).."."..tostring(mod.EntityInf[mod.Entity.Mars].VAR)
	
	Lid = tostring(mod.EntityInf[mod.Entity.Luna].ID).."."..tostring(mod.EntityInf[mod.Entity.Luna].VAR)
	Pid = tostring(mod.EntityInf[mod.Entity.Pluto].ID).."."..tostring(mod.EntityInf[mod.Entity.Pluto].VAR)
	Eid = tostring(mod.EntityInf[mod.Entity.Eris].ID).."."..tostring(mod.EntityInf[mod.Entity.Eris].VAR)
	MKid = tostring(mod.EntityInf[mod.Entity.Makemake].ID).."."..tostring(mod.EntityInf[mod.Entity.Makemake].VAR)
	Hid = tostring(mod.EntityInf[mod.Entity.Haumea].ID).."."..tostring(mod.EntityInf[mod.Entity.Haumea].VAR)
	Qid = tostring(mod.EntityInf[mod.Entity.Errant].ID).."."..tostring(mod.EntityInf[mod.Entity.Errant].VAR)
	
	Soid = tostring(mod.EntityInf[mod.Entity.Sol].ID).."."..tostring(mod.EntityInf[mod.Entity.Sol].VAR)
	RSid = tostring(mod.EntityInf[mod.Entity.RSaturn].ID).."."..tostring(mod.EntityInf[mod.Entity.RSaturn].VAR)
	Cid = tostring(mod.EntityInf[mod.Entity.Ceres].ID).."."..tostring(mod.EntityInf[mod.Entity.Ceres].VAR)

    HPBars.BossDefinitions[Jid] = {
        sprite = "hc/gfx/ui/icons/icon_jupiter.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Sid] = {
        sprite = "hc/gfx/ui/icons/icon_saturn.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Uid] = {
        sprite = "hc/gfx/ui/icons/icon_uranus.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Nid] = {
        sprite = "hc/gfx/ui/icons/icon_neptune.png",
		conditionalSprites = {
			{"isBlood","hc/gfx/ui/icons/icon_neptune_shiny.png"}
		},
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }

	HPBars.BossDefinitions[MRid] = {
        sprite = "hc/gfx/ui/icons/icon_mercury.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Vid] = {
        sprite = "hc/gfx/ui/icons/icon_venus.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[T1id] = {
        sprite = "hc/gfx/ui/icons/icon_terra1.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[T3id] = {
        sprite = "hc/gfx/ui/icons/icon_terra3.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Mid] = {
        sprite = "hc/gfx/ui/icons/icon_mars.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }

	HPBars.BossDefinitions[Lid] = {
        sprite = "hc/gfx/ui/icons/icon_luna.png",
		conditionalSprites = {
			{"isFliped","hc/gfx/ui/icons/icon_lunaflip.png"}
		},
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "LunarHC",
		offset = Vector(0,-7)
    }
	HPBars.BossDefinitions[Pid] = {
        sprite = "hc/gfx/ui/icons/icon_pluto.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Eid] = {
        sprite = "hc/gfx/ui/icons/icon_eris.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[MKid] = {
        sprite = "hc/gfx/ui/icons/icon_makemake.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Hid] = {
        sprite = "hc/gfx/ui/icons/icon_haumea.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
	HPBars.BossDefinitions[Qid] = {
        sprite = "hc/gfx/ui/icons/icon_errant.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "QuantumHC"
    }
	
	HPBars.BossDefinitions[Soid] = {
        sprite = "hc/gfx/ui/icons/icon_sol.png",
		iconAnm2 = "gfx/ui/bosshp_icons/bosshp_icon_64px.anm2",
		barStyle = "Revelation"
    }
	HPBars.BossDefinitions[RSid] = {
        sprite = "hc/gfx/ui/icons/icon_rsaturn.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "Steven"
    }
	HPBars.BossDefinitions[Cid] = {
        sprite = "hc/gfx/ui/icons/icon_ceres.png",
		iconAnm2 = "hc/gfx/ui/icons/icon.anm2",
		barStyle = "PlanetariumHC"
    }
end


--REVELATIONS------------------------------------------------------------------
if REVEL then
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.RevelationsDoorsUpdate, EffectVariant.DOOR_OUTLINE)
	mod.RevelationDoor = nil
end

--EXTERNAL ITEMS DESCRIPTIONS--------------------------------------------------
if EID then

	local blaze_heeart_icon = Sprite()
	blaze_heeart_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('BlazeHeartHC', 'BlazeHeart', 0, 9, 10, -1, 0, blaze_heeart_icon)

	local apple_icon = Sprite()
	apple_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('AppleHC', 'Apple', 0, 9, 10, -1, 0, apple_icon)

	local bismuth_icon = Sprite()
	bismuth_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('BismuthHC', 'Bismuth', 0, 9, 10, 0, 0, bismuth_icon)

	local normal_icon = Sprite()
	normal_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('NormalHC', 'Normal', 0, 9, 10, -1, 0, normal_icon)
	local attuned_icon = Sprite()
	attuned_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('AttunedHC', 'Attuned', 0, 9, 10, -1, 0, attuned_icon)
	local ascended_icon = Sprite()
	ascended_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('AscendedHC', 'Ascended', 0, 9, 10, -1, 0, ascended_icon)
	local radiant_icon = Sprite()
	radiant_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('RadiantHC', 'Radiant', 0, 9, 10, -1, 0, radiant_icon)

	local lunar_icon = Sprite()
	lunar_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('LunarHC', 'LunarPact', 0, 9, 10, -1, 0, lunar_icon)

	local abyssal_heart_icon = Sprite()
	abyssal_heart_icon:Load("hc/gfx/ui/eid/icons.anm2", true)
	EID:addIcon('AbyssalHC', 'AbyssalHeart', 0, 9, 10, -1, 0, abyssal_heart_icon)


	--TAINTED PLANETARIUMS

	EID:addCollectible(mod.Items.Mercurius, "# Flight # 7% chance to shoot {{ColorTransform}}bismuth tears{{ColorText}} # Bismuth tears spawn a mini-Isaac upon killing an enemy # 5% chance to trigger {{Collectible77}} effect in a new room #{{ArrowUp}} +0.23 Speed", "Retrograde Mercurius", "en_us")
	EID:addCollectible(mod.Items.Mercurius, "# Vuelo # 7% de probabilidad de disparar {{ColorTransform}}lágrimas de bismuto{{ColorText}} # Las lágrimas de bismuto generan un mini-Isaac al matar a un enemigo # 5% de probabilidad de activar el efecto de {{Collectible77}} en una nueva sala #{{ArrowUp}} +0.23 Velocidad", "Mercurio Retrógrado", "spa")

	EID:addCollectible(mod.Items.Venus, "# Grants a candle familiar, which after killing 12 enemies, spawns a wax ally # Wax allies can be executed by holding the DROP button # Executed allies have a chance to drop {{BlazeHeartHC}} Blaze Hearts; the lower their health, the higher the chance #{{BlazeHeartHC}} Blaze Hearts act as a shield and summon a Willo while held", "Retrograde Venus", "en_us")
	EID:addCollectible(mod.Items.Venus, "# Otorga un familiar vela, que tras matar a 12 enemigos, genera un aliado de cera # Los aliados de cera pueden ser ejecutados manteniendo presionado el botón de SOLTAR # Los aliados ejecutados tienen una probabilidad de soltar {{BlazeHeartHC}} Corazones Llameantes; cuanto menor sea su salud, mayor la probabilidad #{{BlazeHeartHC}} Los Corazones Llameantes actúan como escudo y proporcionan un Willo mientras se sostienen", "Venus Retrógrado", "spa")

	EID:addCollectible(mod.Items.Terra, "#{{AppleHC}} Apples begin to spawn on the floor # Picked-up apples summon a giant snake that targets vulnerable enemy with the highest health # Apples on the floor grow up to stage 3; the higher the stage, the stronger the snake # The snake does not harm Isaac", "Retrograde Terra", "en_us")
	EID:addCollectible(mod.Items.Terra, "#{{AppleHC}} Comienzan a aparecer manzanas en el suelo # Las manzanas recogidas invocan una serpiente gigante que ataca al enemigo vulnerable con más salud # Las manzanas en el suelo crecen hasta la etapa 3; cuanto mayor la etapa, más fuerte la serpiente # La serpiente no daña a Isaac", "Terra Retrógrada", "spa")

	EID:addCollectible(mod.Items.Mars, "#On use, transforms Isaac into a laser gun for a few seconds # While active: # Explosive projectiles #{{ArrowUp}} x2.5 Damage #{{ArrowUp}} +10 Tears #{{ArrowUp}} x3 Shot Speed #{{ArrowUp}} +1.88 Range #{{ArrowDown}} Speed reduced to 0.1 # The laser gun timer increases by killing enemies # Moves to your pocket active slot if available", "Retrograde Mars", "en_us")
	EID:addCollectible(mod.Items.Mars, "#Al usarse, transforma a Isaac en una ametralladora láser durante unos segundos # Mientras está activo: # Proyectiles explosivos #{{ArrowUp}} x2.5 Daño #{{ArrowUp}} +10 Lagrimas #{{ArrowUp}} x3 Velocidad de disparo #{{ArrowUp}} +1.88 Alcance #{{ArrowDown}} Velocidad reducida a 0.1 # El temporizador de la ametralladora láser aumenta al matar enemigos # Se mueve a tu espacio de objeto activo de bolsillo si está disponible", "Marte Retrógrado", "spa")

	EID:addCollectible(mod.Items.Jupiter, "# Isaac creates an electrified laser trail while walking # If the trail forms a closed loop, it triggers a short circuit that electrocutes all entities inside # The short circuit can also activate some slot machines for free, upgrade batteries, or cause both slot machines and batteries to explode It can also revive shopkeepers as allies", "Retrograde Jupiter", "en_us")
	EID:addCollectible(mod.Items.Jupiter, "# Isaac crea una estela láser electrificado al caminar # Si la estela forma un círculo cerrado, genera un cortocircuito que electrocuta a todas las entidades dentro # El cortocircuito también puede activar algunas máquinas tragamonedas de forma gratuita, mejorar baterías, o hacer que tanto las máquinas como las baterías exploten También puede revivir tenderos como aliados", "Júpiter Retrógrado", "spa")

	EID:addCollectible(mod.Items.Saturnus, "#On use, freezes time # While active: #{{ArrowUp}} Speed increased to 2 #{{ArrowUp}} x3 Fire Rate # Tears begin moving once time resumes # Placed bombs instantly explode when the effect ends # Moves to your pocket active slot if available", "Retrograde Saturnus", "en_us")
	EID:addCollectible(mod.Items.Saturnus, "#Al usarse, congela el tiempo # Mientras está activo: #{{ArrowUp}} Velocidad aumentada a 2 #{{ArrowUp}} x3 Cadencia de disparo # Las lágrimas comienzan a moverse cuando el tiempo se reanuda # Las bombas colocadas explotan instantáneamente al terminar el efecto # Se mueve a tu espacio de objeto activo de bolsillo si está disponible", "Saturno Retrógrado", "spa")

	EID:addCollectible(mod.Items.Uranus, " Isaac poops in the opposite direction of his shots # Poop tears apply the {{ColorTransform}}filthy{{ColorText}} debuff to enemies # Filthy enemies are weakened and leave behind boosting brown creep # Killing a filthy enemy spawns a {{Player25}} poop # If the enemy survives and the effect wears off, friendly Dips will spawn on them", "Retrograde Uranus", "en_us")
	EID:addCollectible(mod.Items.Uranus, " Isaac defeca en la dirección opuesta a sus disparos # Las lágrimas de caca aplican el efecto de {{ColorTransform}}inmundo{{ColorText}} a los enemigos # Los enemigos inmundos estarán debilitados y dejarán un charco marrón potenciador # Matar a un enemigo inmundo generará una caca de {{Player25}} # Si el enemigo sobrevive y el efecto desaparece, se generarán Dips amistosos sobre él", "Urano Retrógrado", "spa")

	EID:addCollectible(mod.Items.Neptunus, "# Grants a trident familiar that behaves like {{Collectible114}} but faster # The trident has a chance to open black holes on enemies it kills while in the air", "Retrograde Neptunus", "en_us")
	EID:addCollectible(mod.Items.Neptunus, "# Otorga un familiar tridente que se comporta como {{Collectible114}} pero más rápido # El tridente tiene la posibilidad de abrir agujeros negros en los enemigos que mata mientras está en el aire", "Neptuno Retrógrado", "spa")

	EID:addCollectible(mod.Items.Luna, "# Not implemented", "Tainted Luna", "en_us")

	EID:addCollectible(mod.Items.Sol, "# Not implemented", "Tainted Sol", "en_us")

	--NO-HIT TRINKETS
	EID:addTrinket(mod.Trinkets.BismuthPenny, "#{{BismuthHC}} Picking up a coin has a 25% chance to spawn a bismuth crystal # Nickels and dimes have a higher chance # Holding bismuth increases the chance of finding higher quality items # Taking damage drops all Bismuth on the floor", "Bismuth Penny", "en_us")
	EID:addTrinket(mod.Trinkets.BismuthPenny, "#{{BismuthHC}} Recoger una moneda tiene un 25% de probabilidad de generar un cristal de bismuto # Los níqueles y las monedas de diez tienen mayor probabilidad # Sostener bismuto aumenta la probabilidad de encontrar objetos de mayor calidad # Al recibir daño, se suelta todo el bismuto en el suelo", "Centavo de Bismuto", "spa")

	EID:addTrinket(mod.Trinkets.Incense, "#{{Trinket}} Collectibles are replaced with fervent trinkets # Fervent trinkets are automatically smelted on pickup", "Fervent Incense", "en_us")
	EID:addTrinket(mod.Trinkets.Incense, "#{{Trinket}} Objetos son reemplazados por baratijas fervientes # Las baratijas fervientes se funden automáticamente al recogerlos", "Incienso Ferviente", "spa")

	EID:addTrinket(mod.Trinkets.BadApple, "#{{AppleHC}} Rotten apples randomly spawn on the floor # A giant snake will sweep vertically through apples positions # The snake deals heavy damage to anything it touches, including Isaac", "Bad Apple", "en_us")
	EID:addTrinket(mod.Trinkets.BadApple, "#{{AppleHC}} Manzanas podridas aparecerán aleatoriamente en el suelo # Una serpiente gigante cruzará verticalmente por la posición de las manzanas # La serpiente hace gran daño a todo lo que toca, incluyendo a Isaac", "Manzana Podrida", "spa")

	EID:addTrinket(mod.Trinkets.Nanite, "#{{Bomb}} Placed bombs have 7% chance to be upgraded into Giga Bombs", "Nanite", "en_us")
	EID:addTrinket(mod.Trinkets.Nanite, "#{{Bomb}} Las bombas colocadas tienen una probabilidad del 7% de convertirse en Giga Bombas", "Nanite", "spa")

	EID:addTrinket(mod.Trinkets.Battery, "# Using an active item creates electric flies based on its charges # {{Warning}} Doesn't work with 0 or +12 charges items", "Broken Battery", "en_us")
	EID:addTrinket(mod.Trinkets.Battery, "# Usar un objeto activo genera moscas eléctricas según sus cargas # {{Warning}} No funciona con objetos de 0 o +12 cargas", "Batería Rota", "spa")

	EID:addTrinket(mod.Trinkets.Gear, "# Taking damage has a 10% chance to trigger the effect of {{Collectible422}} # Dying has a 30% chance to trigger the effect of {{Collectible422}} #{{Warning}} Has a 10% chance to break when activated", "Golden Gear", "en_us")
	EID:addTrinket(mod.Trinkets.Gear, "#Recibir daño tiene un 10% de probabilidad de activar el efecto de {{Collectible422}} # Morir tiene un 30% de probabilidad de activar el efecto de {{Collectible422}} #{{Warning}} Tiene un 10% de probabilidad de romperse al activarse", "Engranaje Dorado", "spa")

	EID:addTrinket(mod.Trinkets.ClayBrick, "# Rocks and blocks have a 10% chance to be replaced with poops #{{PoopPickup}} Special poops can also spawn", "Clay Brick", "en_us")
	EID:addTrinket(mod.Trinkets.ClayBrick, "# Rocas y bloques tiene una probabilidad del 10% de ser reemplazados por cacas #{{PoopPickup}} También pueden aparecer cacas especiales", "Ladrillo de Arcilla", "spa")

	EID:addTrinket(mod.Trinkets.Lure, "# Room items have a 50% chance to be upgraded by one quality level # Upgraded items will have their sprites hidden # Does not affect {{Quality4}} items", "Neptune's Lure", "en_us")
	EID:addTrinket(mod.Trinkets.Lure, "# Los objetos de la habitación tienen una posibilidad del 50% de ser mejorados en un nivel de calidad # Los objetos mejorados tendrán su sprite oculto # No afecta a objetos de calidad {{Quality4}}", "Señuelo de Neptuno", "spa")

	EID:addTrinket(mod.Trinkets.Effigy, "# At the start of the floor, 75% chance to replace a curse with a blessing # If blessings are locked, the curse is just removed #{{Warning}} Blessings are not implemented yet", "Cursed Effigy", "en_us")
	EID:addTrinket(mod.Trinkets.Effigy, "# Al comenzar el piso, 75% de posibilidades de reemplazar una maldición por una bendición # Si las bendiciones están bloqueadas, simplemente la elimina #{{Warning}} Las bendiciones aún no están implementadas", "Efigie Maldita", "spa")

	EID:addTrinket(mod.Trinkets.Crown, "#{{LunarHC}} +66.6% to Lunar Pact #{{Warning}} 33% chance to turn into {{Trinket146}} after a Lunar Pact spawns #{{PlanetariumChance}} Planetariums are replaced with Void Planetariums", "Lunar Crown", "en_us")
	EID:addTrinket(mod.Trinkets.Crown, "#{{LunarHC}} +66.6% al Pacto Lunar #{{Warning}} 33% de probabilidad de convertirse en {{Trinket146}} tras aparecer un Pacto Lunar #{{PlanetariumChance}} Los planetarios son reemplazados por Planetarios de Vacío", "Corona Lunar", "spa")

	EID:addTrinket(mod.Trinkets.Sol, "# At the start of each floor, most rooms are rerolled multiple times, keeping the rarest outcome", "Fine Tuning", "en_us")
	EID:addTrinket(mod.Trinkets.Sol, "# Al comenzar cada piso, la mayoría de las habitaciones se vuelven a generar varias veces, conservando la opción más rara", "Ajuste Fino", "spa")

	EID:addTrinket(mod.Trinkets.i, "#{{Collectible"..mod.SolarItems.HyperDice.."}} At the start of each floor, special rooms have a 50% chance to be rerolled into other types", "i", "en_us")
	EID:addTrinket(mod.Trinkets.i, "#{{Collectible"..mod.SolarItems.HyperDice.."}} Al comenzar cada piso, las salas especiales tienen probabilidad del 50% de convertirse en otras diferentes", "i", "spa")

    EID:addTrinket(mod.Trinkets.Shard, "# Taking damage has a "..tostring(math.floor(100*mod.SHARD_CHANCE)).."% chance to nullify it #{{Warning}} Isaac will be teleported to a random spot in the room, regardless of safety", "Quantum Shard", "en_us")
    EID:addTrinket(mod.Trinkets.Shard, "# Al recibir daño hay una posibilidad del "..tostring(math.floor(100*mod.SHARD_CHANCE)).."% de anularlo #{{Warning}} Isaac será teletransportado a una posición aleatoria en la sala, sin importar si es segura", "Fragmento Cuántico", "spa")

	--SOLAR ITEMS
	EID:addCollectible(mod.SolarItems.HyperDice, "# Rerolls unvisited special rooms into different ones", "Hyper Dice", "en_us")
    EID:addCollectible(mod.SolarItems.HyperDice, "# Cambia salas especiales no visitadas en otras diferentes", "Hiper Dado", "spa")

	EID:addCollectible(mod.SolarItems.SpaceJam, "# Various berries fall from the sky # Picking up berries grants temporary stat boosts # Berries damage enemies on impact", "Space Jam", "en_us")
	EID:addCollectible(mod.SolarItems.SpaceJam, "# Varias bayas caerán del cielo # Recoger bayas otorga aumentos temporales de estadísticas # Las bayas dañan a los enemigos al impactar", "Mermelada Espacial", "spa")

	EID:addCollectible(mod.SolarItems.AsteroidBelt, "# For every 20 coins, bombs or keys held, grants an orbital", "Asteroid Belt", "en_us")
	EID:addCollectible(mod.SolarItems.AsteroidBelt, "# Por cada 20 monedas, bombas o llaves que se tengan, otorga un orbital", "Cinturón de Asteroides", "spa")

	EID:addCollectible(mod.SolarItems.Stallion, "# Hold the DROP button to mount or dismount # While riding: # {{ArrowUp}} +0.25 Speed # Immune to floor hazards # Ramming into enemies deals damage # Destroys rocks and blocks # While not riding: # Stands still, blocking projectiles and enemies, can be pushed to move # Periodically farts, creating toxic clouds", "Herald's Stallion", "en_us")
	EID:addCollectible(mod.SolarItems.Stallion, "# Mantén presionado el botón de SOLTAR para montar o desmontar # Mientras estás montado: #{{ArrowUp}} +0.25 Velocidad # Inmune a peligros del suelo # Embestir a enemigos causa daño # Destruye rocas y bloques # Mientras no estás montado: # Permanece quieto, bloquea proyectiles y enemigos, puede empujarse para moverlo # Suelta pedos periódicamente, creando nubes tóxicas", "Semental del Heraldo", "spa")


	EID:addCollectible(mod.SolarItems.Panspermia, "#{{ArrowUp}} {{Heart}} +1 Health # Damaging enemies charges blood # Double tap the attack button to release a flesh whip that does heavy damage, consuming one blood charge # Overcharging blood consumes it all and drops half a red heart #{{HealingRed}} 25% chance to heal half a heart every 30 seconds", "Panspermia", "en_us")
	EID:addCollectible(mod.SolarItems.Panspermia, "#{{ArrowUp}} {{Heart}} +1 de salud # Dañar enemigos carga sangre # Pulsa dos veces el botón de ataque para liberar un látigo de carne que cause gran daño, consumiendo una carga de sangre # Sobrecargar la sangre la consume toda y deja caer medio corazón rojo #{{HealingRed}} 25% de probabilidad de curar medio corazón cada 30 segundos", "Panspermia", "spa")

	EID:addCollectible(mod.SolarItems.Theia, "# Grants a large Theia familiar chained to the player # Theia leaps at enemies to attack and may occasionally target the player # When idle, the player can pull her by moving # While attacking, the player is dragged by the chain # Theia breaks rocks #{{Rune}} Holding a rune grants Theia special abilities", "Theia", "en_us")
	EID:addCollectible(mod.SolarItems.Theia, "# Otorga un familiar Teia de gran tamaño, encadenada al jugador # Teia salta sobre los enemigos para atacar y ocasionalmente puede atacar al jugador # Cuando está inactiva, el jugador puede arrastrarla al moverse # Mientras ataca, el jugador es arrastrado por la cadena # Teia rompe rocas #{{Rune}} Sostener una runa le otorga habilidades especiales a Teia", "Teia", "spa")

	EID:addCollectible(mod.SolarItems.Engine, "# Replaces Isaac's attack with a continuous short-range flame # The engine overheats if used too long, disabling the flame until it cools down # Higher {{Tears}} increases flame duration before overheating # Higher {{Shotspeed}} speeds up cooling", "Rocket Engine", "en_us")
	EID:addCollectible(mod.SolarItems.Engine, "# Reemplaza el ataque de Isaac por una llama continua de corto alcance # El motor se sobrecalienta si se usa por mucho tiempo, desactivando la llama hasta que se enfríe # Un mayor {{Tears}} aumenta la duración de la llama antes de sobrecalentarse # Un mayor {{Shotspeed}} acelera el enfriamiento", "Motor de Cohete", "spa")

    EID:addTrinket(mod.Trinkets.Void, "# Defeating the floor boss respawns it as a permanent ally, lasting until it dies # {{Warning}} Some particular bosses are excluded for not being friendly compatible", "Void Matter", "en_us")
	EID:addTrinket(mod.Trinkets.Void, "# Al derrotar al jefe del piso, este reaparecerá como un aliado permanente hasta que muera # {{Warning}} Algunos jefes particulares están excluidos por no ser compatibles como aliados", "Materia de Vacío", "spa")

	EID:addCollectible(mod.SolarItems.Battery, "# Using an active item discharges it and spawns an {{ColorTransform}}item spark{{ColorText}} # Item sparks behave like active item wisps, triggering the effect when destroyed # If the active item is used without enough charge, the oldest spark is consumed instead", "Stellar Battery", "en_us")
	EID:addCollectible(mod.SolarItems.Battery, "# Usar el objeto activo lo descargará y generará una {{ColorTransform}}chispa de objeto{{ColorText}} # Las chispas de objeto actúan como llamas de objetos activos, activando su efecto al destruirse # Si se usa el objeto sin suficiente carga, se consumirá la chispa más antigua", "Batería Estelar", "spa")

	EID:addCollectible(mod.SolarItems.Mothership_01, "#{{1}} Fires a laser that infects enemies; infected enemies spawn friendly maggots on death #{{2}} Infected enemies become charmed #{{3}} Isaac can keep 2 additional maggots between rooms # Increases power when combined with other Mothership modules # Other Mothership modules appear more often", "The Inseminator", "en_us")
	EID:addCollectible(mod.SolarItems.Mothership_02, "#{{1}} Automatically fires at nearby enemies #{{2}} Increased damage and spectral tears #{{3}} Rocket launcher # Increases power when combined with other Mothership modules # Other Mothership modules appear more often", "The Pistol", "en_us")
	EID:addCollectible(mod.SolarItems.Mothership_03, "#{{1}} Destroys tinted and golden rocks #{{2}} Opens secret rooms and stone chests #{{2}} Destroys spiked rocks and Bishops #{{3}} Opens crawlspaces # Increases power when combined with other Mothership modules # Other Mothership modules appear more often", "The Penetrator", "en_us")
	EID:addCollectible(mod.SolarItems.Mothership_04, "#{{1}} Grants a shield every 5 rooms #{{2}} Grants a shield every 3 rooms #{{2}} Blocks projectiles #{{3}} Isaac can stack two shields # Increases power when combined with other Mothership modules # Other Mothership modules appear more often", "The Protector", "en_us")

	EID:addCollectible(mod.SolarItems.Mothership_01, "#{{1}} Dispara un láser que infecta a los enemigos; los infectados generan larvas amigas al morir #{{2}} Los enemigos infectados quedan enamorados #{{3}} Isaac puede llevar 2 larvas adicionales entre salas # Aumenta su poder al combinarse con otros módulos de la Nave Nodriza # Los otros módulos de la Nave Nodriza aparecen con más frecuencia", "El Inseminador", "spa")
	EID:addCollectible(mod.SolarItems.Mothership_02, "#{{1}} Dispara automáticamente a enemigos cercanos #{{2}} Daño aumentado y lágrimas espectrales #{{3}} Lanzacohetes # Aumenta su poder al combinarse con otros módulos de la Nave Nodriza # Los otros módulos de la Nave Nodriza aparecen con más frecuencia", "La Pistola", "spa")
	EID:addCollectible(mod.SolarItems.Mothership_03, "#{{1}} Destruye rocas marcadas y doradas #{{2}} Abre salas secretas y cofres de piedra #{{2}} Destruye rocas con pinchos y Obispos #{{3}} Abre entradas a subniveles # Aumenta su poder al combinarse con otros módulos de la Nave Nodriza # Los otros módulos de la Nave Nodriza aparecen con más frecuencia", "El Penetrador", "spa")
	EID:addCollectible(mod.SolarItems.Mothership_04, "#{{1}} Otorga un escudo cada 5 habitaciones #{{2}} Otorga un escudo cada 3 habitaciones #{{2}} Bloquea proyectiles #{{3}} Isaac puede acumular dos escudos # Aumenta su poder al combinarse con otros módulos de la Nave Nodriza # Los otros módulos de la Nave Nodriza aparecen con más frecuencia", "El Protector", "spa")

	EID:addCollectible(mod.SolarItems.Telescope, "# When leaving a floor, all unvisited rooms convert into bonus golden rooms on the next floor # Golden rooms are lower weight than standard rooms # Large rooms count as multiple # Unvisited golden rooms also carry over #{{ArrowUp}} +2 Luck", "Golden Telescope", "en_us")
	EID:addCollectible(mod.SolarItems.Telescope, "# Al salir de un piso, todas las habitaciones no visitadas se convierten en habitaciones doradas extra en el siguiente piso # Las habitaciones doradas tienen un menor peso que las habitaciones estándar # Las habitaciones grandes cuentan como múltiples # Las habitaciones doradas no visitadas también se acumulan #{{ArrowUp}} +2 Suerte", "Telescopio Dorado", "spa")

	EID:addCollectible(mod.SolarItems.Quasar, "# On use, if collectibles are present in the room, consumes no charges and absorbs them # Each absorbed item grants charges based on its quality + 1 x4 # On use, if no collectibles are present, creates two twin giant lasers for a few seconds, consuming one charge #{{Warning}} This item can only be recharged by absorbing collectibles", "Quasar", "en_us")
	EID:addCollectible(mod.SolarItems.Quasar, "# Al usarse, si hay coleccionables en la sala, no consume cargas y los absorbe # Cada objeto absorbido otorga cargas según su calidad + 1 x4 # Al usarse sin coleccionables en la sala, crea dos láseres gigantes gemelos durante unos segundos, consumiendo una carga #{{Warning}} Este objeto solo puede recargarse absorbiendo coleccionables", "Cuásar", "spa")

	EID:addCollectible(mod.SolarItems.RedShovel, "# On use, Isaac enters a red trapdoor leading to a parallel floor at the same progression point # While on the red floor, the shovel becomes {{Collectible84}} and reverts after completing the floor", "Red Shovel", "en_us")
    EID:addCollectible(mod.SolarItems.RedShovel, "# Al usarla, Isaac entra por una trampilla roja que lo lleva a un piso paralelo del mismo punto de progresión # Mientras esté en el piso rojo, la pala se convierte en {{Collectible84}} y vuelve a la normalidad al completar el piso", "Pala Roja", "spa")

	EID:addCollectible(mod.SolarItems.Picatrix, "# On use, spawns an astral image of the player that orbits around them # The astral image has all the player's original items as item wisps and attacks simultaneously with the player # The astral image disappears when changing rooms or if all wisps are lost", "Picatrix", "en_us")
	EID:addCollectible(mod.SolarItems.Picatrix, "# Al usarse, genera una imagen astral del jugador que orbita a su alrededor # La imagen astral tiene todos los objetos originales del jugador como llamas de objetos y ataca simultáneamente con el jugador # La imagen astral desaparece al cambiar de habitación o si se pierden todos las llamas", "Picatrix", "spa")

	--PICKUPS
	EID:addPill(mod.Pills.CLAIRVOYANCE, "#{{Planetarium}} +1% Planetarium chance", "Clairvoyance", "en_us")
	EID:addHorsePill(mod.Pills.CLAIRVOYANCE, "{{Planetarium}} +3% Planetarium chance", "Clairvoyance", "en_us")
	EID:addPill(mod.Pills.CLAIRVOYANCE, "#{{Planetarium}} +1% de probabilidad de Planetario", "Clarividencia", "spa")
	EID:addHorsePill(mod.Pills.CLAIRVOYANCE, "{{Planetarium}} +3% de probabilidad de Planetario", "Clarividencia", "spa")

	EID:addPill(mod.Pills.CLAIRVOYANCE_BAD, "# Screen distortion", "Clarivoyance", "en_us")
	EID:addHorsePill(mod.Pills.CLAIRVOYANCE_BAD, "Strong screen distortion", "Clarivoyance", "en_us")
	EID:addPill(mod.Pills.CLAIRVOYANCE_BAD, "# Distorsión de pantalla", "Clarividensia", "spa")
	EID:addHorsePill(mod.Pills.CLAIRVOYANCE_BAD, "Distorsión de pantalla intensa", "Clarividensia", "spa")


	EID:addPill(mod.Pills.BALLS_UP, "#{{Throwable}} +1 Permanent Lil Moon familiar # Up to three", "Balls Up", "en_us")
	EID:addHorsePill(mod.Pills.BALLS_UP, "#{{Throwable}} +2 Permanent Lil Moon familiars # Up to three", "Balls Up!", "en_us")
	EID:addPill(mod.Pills.BALLS_UP, "#{{Throwable}} +1 familiar Mini Luna permanente # Hasta tres", "Más Pelotas", "spa")
	EID:addHorsePill(mod.Pills.BALLS_UP, "#{{Throwable}} +2 familiares Mini Luna permanentes # Hasta tres", "¡Más Pelotas!", "spa")

	EID:addPill(mod.Pills.BALLS_DOWN, "#{{Throwable}} -1 Permanent Lil Moon familiar", "Balls Down", "en_us")
	EID:addHorsePill(mod.Pills.BALLS_DOWN, "#{{Throwable}} -2 Permanent Lil Moon familiars", "Balls Down!", "en_us")
	EID:addPill(mod.Pills.BALLS_DOWN, "#{{Throwable}} -1 familiar Mini Luna permanente", "Menos Pelotas", "spa")
	EID:addHorsePill(mod.Pills.BALLS_DOWN, "#{{Throwable}} -2 familiares Mini Luna permanentes", "¡Menos Pelotas!", "spa")


	EID:addPill(mod.Pills.MARSHMALLOW, "#{{Throwable}} Grants 9 special Lil Moon familiars for the room", "Marshmallow!?", "en_us")
	EID:addHorsePill(mod.Pills.MARSHMALLOW, "#{{Throwable}} Grants 9 special Lil Moon familiars for the room # Grants {{Collectible247}} for the room", "Marshmallow!?", "en_us")
	EID:addPill(mod.Pills.MARSHMALLOW, "#{{Throwable}} Otorga 9 familiares Mini Luna especiales durante la habitación", "¿¡Malvavisco!?", "spa")
	EID:addHorsePill(mod.Pills.MARSHMALLOW, "#{{Throwable}} Otorga 9 familiares Mini Luna especiales durante la habitación # Otorga {{Collectible247}} durante la habitación", "¿¡Malvavisco!?", "spa")

	
	EID:addCard(mod.FoilConsts.FOIL_ID, "# Applies a protection to the nearest card # Protected cards have a "..tostring(math.floor(100*(1-mod.FoilConsts.BREAK_CHANCE))).."% chance not to be consumed", "Card Protector", "en_us")
	EID:addCard(mod.FoilConsts.FOIL_ID, "# Aplica una funda a la carta más cercana # Las cartas con funda tienen un "..tostring(math.floor(100*(1-mod.FoilConsts.BREAK_CHANCE))).."% de probabilidad de no consumirse", "Funda de Carta", "spa")


	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.EntityVoidSub, "Abyssal Penny", "# Will take all your coins and create a golden explosion, gilding pickups, trinkets, enemies and more!", "en_us")
	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.EntityVoidSub, "Penique Abisal", "# Se llevará todas tus monedas y creará una explosión dorada que dorará objetos, baratijas, enemigos y más", "spa")

	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, mod.EntityVoidSub, "Abyssal Bomb", "# Next bomb placed will try to absorb anything in the room and then do a {{Collectible483}} explosion", "en_us")
	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, mod.EntityVoidSub, "Bomba Abisal", "# La siguiente bomba colocada intentará absorber todo en la habitación y luego hará una explosión de {{Collectible483}}", "spa")

	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, mod.EntityVoidSub, "Abyssal Key", "# The next door opened will create a line of red rooms in its direction, reaching the I'm Error room # Triggers {{Collectible175}} when used # Colliding with a closed door will also trigger the effect", "en_us")
	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, mod.EntityVoidSub, "Llave Abisal", "# La siguiente puerta que se abra creará una línea de habitaciones rojas en su dirección, llegando a la sala I'm Error # Activa {{Collectible175}} al ser usada # Chocar contra una puerta cerrada también activará el efecto", "spa")


	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityVoidSub, "Abyssal Heart", "# +1 {{AbyssalHC}} (+1 {{BrokenHeart}} if no free hearts available) # Works as a shield, "..tostring(math.floor(100*mod.VoidHeartConsts.BREAK_CHANCE)).."% chance to break # If not broken, may be restored when picking up a {{Heart}} at full health #  Triggers {{Collectible35}} on use # Picking up a {{Heart}} while both health and {{AbyssalHC}} are full grants a permanent damage up # Amount of {{AbyssalHC}} acts as a damage multiplier", "en_us")

	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, mod.EntityVoidSub, "Corazón Abisal", "# +1 {{AbyssalHC}} (+1 {{BrokenHeart}} si no hay corazones libres) # Funciona como escudo, "..tostring(math.floor(100*mod.VoidHeartConsts.BREAK_CHANCE)).."% de probabilidades de romperse # Si no es roto, puede restaurarse al tomar un {{Heart}} con la vida llena # Activa el efecto de {{Collectible35}} al usarse # Recoger un {{Heart}} mientras tanto la salud como los {{AbyssalHC}} están llenos otorga un aumento permanente de daño # Cantidad de {{AbyssalHC}} actúa como multiplicador de daño", "spa")


	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, mod.EntityVoidSub, "Abyssal Battery", "# Will take all your item charge and can only be picked up when fully charged # Grants you 5 item sparks of your active item", "en_us")
	EID:addEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, mod.EntityVoidSub, "Batería Abisal", "# Se llevará toda la carga de tu objeto y solo puede recogerse cuando está completamente cargado # Te dará 5 chispas de tu objeto activo", "spa")


	--OTHER
	EID:addCollectible(mod.SolarItems.LilSol, "# Grants a Lil Sol familiar that bounces around the room # Has an aura similar to {{Collectible417}}, behaving like the one from {{Collectible543}} # All Lil Moon familiars will orbit Lil Sol instead of Isaac", "Lil Sol", "en_us")
	EID:addCollectible(mod.SolarItems.LilSol, "# Otorga un familiar Pequeño Sol que rebota por la habitación # Tiene un aura similar a {{Collectible417}}, que se comporta como la de {{Collectible543}} # Todos los familiares Mini Lunas orbitan alrededor de Pequeño Sol en lugar de Isaac", "Pequeño Sol", "spa")

	EID:addCollectible(mod.SolarItems.Mochi, "# {{ArrowUp}} +1 Health # {{HealingRed}} Heals 1 heart # {{ArrowUp}} +0.25 Tears # {{ArrowUp}} +0.25 Damage # {{ArrowUp}} +1 Luck # {{LunarHC}} x2 Lunar Pact chance", "Mochi", "en_us")
	EID:addCollectible(mod.SolarItems.Mochi, "# {{ArrowUp}} +1 Corazón # {{HealingRed}} Cura 1 corazon # {{ArrowUp}} +0.25 Lágrimas # {{ArrowUp}} +0.25 Daño # {{ArrowUp}} +1 Suerte # {{LunarHC}} x2 probabilidad de Pacto Lunar", "Mochi", "spa")


    EID:addTrinket(mod.Trinkets.Sputnik, "# Grants a satellite orbital #{{Throwable}} Orbitals orbit farther from Isaac and move more slowly", "Sputnik", "en_us")
    EID:addTrinket(mod.Trinkets.Sputnik, "# Otorga un orbital satélite #{{Throwable}} Los orbitales giran más lejos de Isaac y se mueven más lento", "Sputnik", "spa")

    EID:addTrinket(mod.Trinkets.Flag, "#{{ArrowUp}} +15% chance for Telescopes #{{ArrowUp}} +6% chance for a Telescope to grant a Lil Moon #{{ArrowUp}} +50% damage from Lil Moons #{{ArrowUp}} x2 Fire Rate from Lil Moons", "Faded Flag", "en_us")
    EID:addTrinket(mod.Trinkets.Flag, "#{{ArrowUp}} +15% de probabilidad de obtener Telescopios #{{ArrowUp}} +6% de probabilidad de que un Telescopio otorgue una Mini Luna #{{ArrowUp}} +50% de daño de las Mini Lunas #{{ArrowUp}} x2 Cadencia de disparo de las Mini Lunas", "Bandera Desgastada", "spa")


	EID:addTrinket(mod.Trinkets.Noise, "# Not implemented", "Background Noise", "en_us")
	EID:addTrinket(mod.Trash.Soldier, "# Not implemented", "Toy Soldier", "en_us")
	EID:addTrinket(mod.Trash.Silver, "# Not implemented", "Mirror Shard", "en_us")

	EID:addCollectible(mod.SolarItems.Wormhole, "# Not implementad", "Cosmic Tapeworm", "en_us")
	EID:addCollectible(mod.SolarItems.SunGlasses, "# Not implementad", "Sun Glasses", "en_us")
	EID:addCollectible(mod.SolarItems.Jupiter, "# Not implementad", "Jupiter", "en_us")
	EID:addCollectible(mod.SolarItems.Scepter, "# Not implementad", "The Scepter", "en_us")
	for i=0, 9 do
		local text = "Eye of the Universe"
		for k=1, i do
			text = "​"..text
		end
		EID:addCollectible(mod.SolarItems.Dial+i, "# Not implementad", "Eye of the Universe", "en_us")
	end

	EID:addCollectible(mod.OtherItems.CatFish, "# Not implemented", "Cat fish", "en_us")

	--EID:addCollectible(mod.OtherItems.Apple, "# WIP", "Apple", "en_us")
	--EID:addCollectible(mod.OtherItems.Carrot, "# WIP", "Carrot", "en_us")
	--EID:addCollectible(mod.OtherItems.Egg, "# WIP", "Egg", "en_us")

	EID:addCollectible(mod.SolarItems.Friend, "# You should not be reading this, if you do, its a bug (or you used a command)", "Friend", "en_us")
	EID:addCollectible(mod.SolarItems.CursedHead, "# You should not be reading this, if you do, its a bug (or you used a command)", "Cursed Head", "en_us")
	EID:addCollectible(mod.SolarItems.CursedBody, "# You should not be reading this, if you do, its a bug (or you used a command)", "Cursed Body", "en_us")
	EID:addCollectible(mod.SolarItems.CursedSoul, "# You should not be reading this, if you do, its a bug (or you used a command)", "Cursed Soul", "en_us")

	EID:addCollectible(mod.SolarItems.AdInfinitum, "# Not implemented", "Ad Infinitum", "en_us")
	EID:addCollectible(mod.SolarItems.Whistle, "# Not implemented", "Death Whistle", "en_us")


	EID:addEntity(mod.EntityInf[mod.Entity.Telescope].ID, mod.EntityInf[mod.Entity.Telescope].VAR, mod.EntityInf[mod.Entity.Telescope].SUB, "Telescope", "{{Coin}} Costs one coin, can reward you with: # Wisps # Astral item wisps and sparks # Soul Hearts # Blaze Hearts # Astral items # {{ColorCyan}}Lil {{ColorCyan}}Moon orbitals", "en_us")
	EID:addEntity(mod.EntityInf[mod.Entity.Telescope].ID, mod.EntityInf[mod.Entity.Telescope].VAR, mod.EntityInf[mod.Entity.Telescope].SUB, "Telescopio", "{{Coin}} Cuesta una moneda, puede recompensarte con: # Llamas # Llamas y chispas de objetos astrales # Corazones de Alma # Corazones Llameantes # Objetos astrales # Órbitasles {{ColorCyan}}Mini {{ColorCyan}}Lunas", "spa")

	--on entity data
	--EID:addEntity(mod.EntityInf[mod.Entity.Titan].ID, mod.EntityInf[mod.Entity.Titan].VAR, mod.EntityInf[mod.Entity.Titan].SUB, "Lil Titan Beggar", "Takes an increasing number of coins and can reward you with golden pickups and trinkets", "en_us")
	--EID:addEntity(mod.EntityInf[mod.Entity.Titan].ID, mod.EntityInf[mod.Entity.Titan].VAR, mod.EntityInf[mod.Entity.Titan].SUB, "Pequeño Mendigo Titán", "Toma una cantidad creciente de monedas y puede recompensarte con objetos y baratijas doradas", "spa")

	mod:scheduleForUpdate(function ()
		if persistentData:Unlocked(Isaac.GetAchievementIdByName("double_nothing (HC)")) then
			EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB, "Astral Statue", "#{{Planetarium}} Take the item to trigger a boss fight #{{Bomb}} Bombing the statue turns the item into pickups (and also spawns the boss!) # {{ColorTransform}}Collect all stars in the room to activate Double-or-Nothing:{{ColorText}} # Gain an extra reward item, but lose both if hit # Isaac receives a free {{Collectible313}} shield # Boss difficulty increases to Ascended", "en_us")
			EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB, "Estatua Astral", "#{{Planetarium}} Tomar el objeto inicia una pelea contra un jefe #{{Bomb}} Si revientas la estatua, el objeto se convierte en consumibles (¡y también aparece el jefe!) # {{ColorTransform}}Recoge todas las estrellas de la sala para activar Doble o Nada{{ColorText}}: # Obtén un objeto extra como recompensa, pero pierde ambos si recibes daño # Isaac recibe un escudo de {{Collectible313}} gratis # La dificultad del jefe sube a Ascendido", "spa")
		else
			EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB, "Astral Statue", "#{{Planetarium}} Take the item to trigger a boss fight #{{Bomb}} Bombing the statue turns the item into pickups (and also spawns the boss!)", "en_us")
			EID:addEntity(mod.EntityInf[mod.Entity.Statue].ID, mod.EntityInf[mod.Entity.Statue].VAR, mod.EntityInf[mod.Entity.Statue].SUB, "Estatua Astral", "#{{Planetarium}} Tomar el objeto inicia una pelea contra un jefe #{{Bomb}} Si revientas la estatua, el objeto se convierte en consumibles (¡y también aparece el jefe!)", "spa")
		end
	end, 1)

	EID:addEntity(mod.EntityInf[mod.Entity.LunarStatue].ID, mod.EntityInf[mod.Entity.LunarStatue].VAR, mod.EntityInf[mod.Entity.LunarStatue].SUB, "Lunar Pact", "#Trade {{BrokenHeart}}, {{Heart}}, and {{SoulHeart}} for an item # This room is under the effects of {{Collectible691}}", "en_us")
	EID:addEntity(mod.EntityInf[mod.Entity.LunarStatue].ID, mod.EntityInf[mod.Entity.LunarStatue].VAR, mod.EntityInf[mod.Entity.LunarStatue].SUB, "Pacto Lunar", "#Intercambia {{BrokenHeart}}, {{Heart}} y {{SoulHeart}} por un objeto # Esta sala está bajo los efectos de {{Collectible691}}", "spa")

	EID:addEntity(mod.EntityInf[mod.Entity.BabelButton].ID, mod.EntityInf[mod.Entity.BabelButton].VAR, mod.EntityInf[mod.Entity.BabelButton].SUB, "Boss Difficulty", "#{{NormalHC}} Standard difficulty, same as normal runs #{{AttunedHC}} Extra and deadlier attacks + double damage #{{AscendedHC}} Further enhanced attacks {{ColorTransform}}[Complete the tower in this mode to finish the challenge]{{ColorText}} #{{RadiantHC}} No-hit mode {{ColorTransform}}[No rewards for completing the tower in this mode]{{ColorText}}", "en_us")
	EID:addEntity(mod.EntityInf[mod.Entity.BabelButton].ID, mod.EntityInf[mod.Entity.BabelButton].VAR, mod.EntityInf[mod.Entity.BabelButton].SUB, "Dificultad de Jefe", "#{{NormalHC}} Dificultad estándar, igual que en las partidas normales #{{AttunedHC}} Ataques adicionales y más letales + daño doble #{{AscendedHC}} Ataques aún más agresivos {{ColorTransform}}[Completa la torre en este modo para superar el desafío]{{ColorText}} #{{RadiantHC}} Modo sin recibir daño {{ColorTransform}}[No hay recompensas por completar la torre en este modo]{{ColorText}}", "spa")


end

--ANTIBIRTH RUNES----------------------------------------------------------
if AntibirthRunes then
	function mod:OnHCIngwaz(card, player, flags, oneTime)
		for i, _chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST)) do
			local chest = _chest:ToPickup()
			if chest and chest.SubType == mod.EntityVoidSub or chest.SubType == mod.EntityVoidSub+1 then

				if chest.SubType == mod.EntityVoidSub then
					local result = mod:VoidChestOpen(chest)

					local sprite = chest:GetSprite()
					sprite:ReplaceSpritesheet(5, "hc/gfx/items/void_altar.png", true)
					sprite:SetOverlayFrame("Alternates", 10)

					if result and oneTime then return true end
				end

				if chest.SubType == mod.EntityVoidSub+1 then
					local result = chest:TryOpenChest()
					--local result = mod:InfinityChestOpen(chest)
					if result and oneTime then return true end
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnHCIngwaz, Isaac.GetCardIdByName("Ingwaz"))
end

--STAGE API
if StageAPI then
	for key, music in ipairs(mod.Music) do
		StageAPI.StopOverridingMusic(music)
	end
end

--ANDROMEDA
if ANDROMEDA then
	function mod:OnUseGravityShift(item, rng, player)
		if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Andromeda", false) then
			
			local room = game:GetRoom()
			local level = game:GetLevel()
			local roomdesc = level:GetCurrentRoomDesc()

			if room:IsFirstVisit() and mod:IsRoomDescChallenge(roomdesc) then
				local astralMode = mod:GetAstralChallengeGenType()

				if astralMode ~= "none" then
					
					game:SetColorModifier(ColorModifier(1,1,1,1,10),false)
					sfx:Play(Isaac.GetSoundIdByName("gravity_shift"))

					player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false)

					game:SetColorModifier(ColorModifier(1,1,1,1,2),false)
					mod:scheduleForUpdate(function ()
						local newroomdata
						if astralMode == "outer" then
							newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, mod.RoomVariantVecs.Astral1.X, mod.RoomVariantVecs.Astral1.Y, 20, 20, mod.normalDoors)
						else
							newroomdata = RoomConfigHolder.GetRandomRoom(mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, mod.RoomVariantVecs.Astral2.X, mod.RoomVariantVecs.Astral2.Y, 20, 20, mod.normalDoors)
						end
						
						if roomdesc and roomdesc.Data then
							roomdesc.Data = newroomdata
				
							if MinimapAPI then
								local gridIndex = roomdesc.SafeGridIndex
								local position = mod:GridIndexToVector(gridIndex)
								
								local maproom = MinimapAPI:GetRoomAtPosition(position)
								if maproom then
									--maproom.ID = "angelshop"..tostring(gridIndex)
									maproom.Shape = newroomdata.Shape
						
									--Anything below is optional
									maproom.Type = RoomType.ROOM_ANGEL
									maproom.PermanentIcons = {"AstralChallenge"}
									maproom.DisplayFlags = 0
									maproom.AdjacentDisplayFlags = 3
									maproom.Descriptor = roomdesc
									maproom.AllowRoomOverlap = false
									maproom.Color = Color.Default
				
								end
							end
				
							mod:UpdateRoomDisplayFlags(roomdesc)
						end

						
						game:SetColorModifier(ColorModifier(1,1,1,1,1),true)
						game:StartRoomTransition(roomdesc.SafeGridIndex, Direction.NO_DIRECTION, RoomTransitionAnim.WALK)
						sfx:Play(Isaac.GetSoundIdByName("gravity_shift_teleport"))
						--sfx:Play(SoundEffect.SOUND_FLASHBACK)
					end,2)
				end
			end

		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnUseGravityShift, Isaac.GetItemIdByName("Gravity Shift"))
end

--Tainted Treasure
if TaintedTreasure then
	function mod:AddTaintedItemToPool(is_continued)
		if mod.savedatasettings().taintedTreasurePool > 0 then
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_MERCURIUS, mod.Items.Mercurius)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_VENUS, mod.Items.Venus)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_TERRA, mod.Items.Terra)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_MARS, mod.Items.Mars)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_JUPITER, mod.Items.Jupiter)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_SATURNUS, mod.Items.Saturnus)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_URANUS, mod.Items.Uranus)
			TaintedTreasure:AddTaintedTreasure(CollectibleType.COLLECTIBLE_NEPTUNUS, mod.Items.Neptunus)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.AddTaintedItemToPool)
end

--DDS------------------------------------------------------------------
include("scripts.dssmenumanager")