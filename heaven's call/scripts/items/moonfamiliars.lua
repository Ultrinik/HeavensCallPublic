---@diagnostic disable: assign-type-mismatch
local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()


mod.Moons = {
	
	Luna = Isaac.GetItemIdByName("Lil Luna"),
	Jupiter = Isaac.GetItemIdByName("Lil Jupiter"),
	Saturn = Isaac.GetItemIdByName("Lil Saturn"),
	Uranus = Isaac.GetItemIdByName("Lil Uranus"),
	Neptune = Isaac.GetItemIdByName("Lil Neptune"),
	Mercury = Isaac.GetItemIdByName("Lil Mercury"),
	Venus = Isaac.GetItemIdByName("Lil Venus"),
	Terra = Isaac.GetItemIdByName("Lil Terra"),
	Mars = Isaac.GetItemIdByName("Lil Mars"),
	Errant = Isaac.GetItemIdByName("Lil Errant"),
	
	Ceres = Isaac.GetItemIdByName("Lil Ceres"),
	Io = Isaac.GetItemIdByName("Lil Io"),
	Europa = Isaac.GetItemIdByName("Lil Europa"),
	Ganymede = Isaac.GetItemIdByName("Lil Ganymede"),
	Callisto = Isaac.GetItemIdByName("Lil Callisto"),
	Titan = Isaac.GetItemIdByName("Lil Titan"),
	Titania = Isaac.GetItemIdByName("Lil Titania"),
	Oberon = Isaac.GetItemIdByName("Lil Oberon"),
	Triton = Isaac.GetItemIdByName("Lil Triton"),
	Pluto = Isaac.GetItemIdByName("Lil Pluto"),
	Charon = Isaac.GetItemIdByName("Lil Charon"),
	Eris = Isaac.GetItemIdByName("Lil Eris"),
	Makemake = Isaac.GetItemIdByName("Lil Makemake"),
	Haumea = Isaac.GetItemIdByName("Lil Haumea"),
	
	Iris = Isaac.GetItemIdByName("Lil Iris"),
	End = Isaac.GetItemIdByName("Lil End"),
	
	Subnautica = Isaac.GetItemIdByName("Lil Subnautica"),
	--Petrichor = Isaac.GetItemIdByName("Lil Petrichor"),
	Popstar = Isaac.GetItemIdByName("Lil Popstar"),
	--Skaia = Isaac.GetItemIdByName("Lil Skaia"),
	LethalTitan = Isaac.GetItemIdByName("​​​Lil Titan"),
	Cat = Isaac.GetItemIdByName("Lil Cat Planet"),
	Umbriel = Isaac.GetItemIdByName("Lil Umbriel"),
	Theia = Isaac.GetItemIdByName("Lil Theia"),
	--Treasure = Isaac.GetItemIdByName("Lil Treasure"),
	ParadoxSaturn = Isaac.GetItemIdByName("​​​Lil Saturn"),
	Remina = Isaac.GetItemIdByName("Lil Remina"),
	
	Ash = Isaac.GetItemIdByName("Lil Ash Twin"),
	Ember = Isaac.GetItemIdByName("Lil Ember Twin"),
	Timber = Isaac.GetItemIdByName("Lil Timber Hearth"),
	Brittle = Isaac.GetItemIdByName("Lil Brittle Hollow"),
	Lantern = Isaac.GetItemIdByName("Lil Hollow's Lantern"),
	Giant = Isaac.GetItemIdByName("Lil Giant's Deep"),
	Attle = Isaac.GetItemIdByName("Lil Attlerock"),
	Bramble = Isaac.GetItemIdByName("Lil Dark Bramble"),

}

--Orbital speed of the moon
mod.MoonSpeeds = {}
--Id of the orbit of each moon
mod.MoonOrbits = {}
--Id of the orbits of each moon if they are alone
mod.MoonOrbitsVanilla = {}
--Parent of each moon
mod.MoonParent = {}
--Orbital distance of each moon
mod.MoonOrbitDistance = {}

mod.LilMoon = {
	[mod.Moons.Luna] = Isaac.GetEntitySubTypeByName("Moon Luna (HC)"),
	[mod.Moons.Mercury] = Isaac.GetEntitySubTypeByName("Moon Mercury (HC)"),
	[mod.Moons.Venus] = Isaac.GetEntitySubTypeByName("Moon Venus (HC)"),
	[mod.Moons.Terra] = Isaac.GetEntitySubTypeByName("Moon Terra (HC)"),
	[mod.Moons.Mars] = Isaac.GetEntitySubTypeByName("Moon Mars (HC)"),
	[mod.Moons.Jupiter] = Isaac.GetEntitySubTypeByName("Moon Jupiter (HC)"),
	[mod.Moons.Saturn] = Isaac.GetEntitySubTypeByName("Moon Saturn (HC)"),
	[mod.Moons.Uranus] = Isaac.GetEntitySubTypeByName("Moon Uranus (HC)"),
	[mod.Moons.Neptune] = Isaac.GetEntitySubTypeByName("Moon Neptune (HC)"),
	[mod.Moons.Errant] = Isaac.GetEntitySubTypeByName("Moon Errant (HC)"),
	[mod.Moons.Ceres] = Isaac.GetEntitySubTypeByName("Moon Ceres (HC)"),
	[mod.Moons.Io] = Isaac.GetEntitySubTypeByName("Moon Io (HC)"),
	[mod.Moons.Europa] = Isaac.GetEntitySubTypeByName("Moon Europa (HC)"),
	[mod.Moons.Ganymede] = Isaac.GetEntitySubTypeByName("Moon Ganymede (HC)"),
	[mod.Moons.Callisto] = Isaac.GetEntitySubTypeByName("Moon Callisto (HC)"),
	[mod.Moons.Titan] = Isaac.GetEntitySubTypeByName("Moon Titan (HC)"),
	[mod.Moons.Titania] = Isaac.GetEntitySubTypeByName("Moon Titania (HC)"),
	[mod.Moons.Oberon] = Isaac.GetEntitySubTypeByName("Moon Oberon (HC)"),
	[mod.Moons.Triton] = Isaac.GetEntitySubTypeByName("Moon Triton (HC)"),
	[mod.Moons.Pluto] = Isaac.GetEntitySubTypeByName("Moon Pluto (HC)"),
	[mod.Moons.Charon] = Isaac.GetEntitySubTypeByName("Moon Charon (HC)"),
	[mod.Moons.Eris] = Isaac.GetEntitySubTypeByName("Moon Eris (HC)"),
	[mod.Moons.Makemake] = Isaac.GetEntitySubTypeByName("Moon Makemake (HC)"),
	[mod.Moons.Haumea] = Isaac.GetEntitySubTypeByName("Moon Haumea (HC)"),
	Sputnik = Isaac.GetEntitySubTypeByName("Moon Sputnik (HC)"),
	[mod.Moons.Iris] = Isaac.GetEntitySubTypeByName("Moon Iris (HC)"),
	[mod.Moons.End] = Isaac.GetEntitySubTypeByName("Moon End (HC)"),
	[mod.Moons.Subnautica] = Isaac.GetEntitySubTypeByName("Moon Subnautica (HC)"),
	--[mod.Moons.Petrichor] = Isaac.GetEntitySubTypeByName("Moon Petrichor (HC)"),
	[mod.Moons.Popstar] = Isaac.GetEntitySubTypeByName("Moon Popstar (HC)"),
	--[mod.Moons.Skaia] = Isaac.GetEntitySubTypeByName("Moon Skaia (HC)"),
	[mod.Moons.Cat] = Isaac.GetEntitySubTypeByName("Moon Cat (HC)"),
	[mod.Moons.LethalTitan] = Isaac.GetEntitySubTypeByName("Moon LethalTitan (HC)"),
	[mod.Moons.Umbriel] = Isaac.GetEntitySubTypeByName("Moon Umbriel (HC)"),
	[mod.Moons.Theia] = Isaac.GetEntitySubTypeByName("Moon Theia (HC)"),
	--[mod.Moons.Treasure] = Isaac.GetEntitySubTypeByName("Moon Treasure (HC)"),
	[mod.Moons.ParadoxSaturn] = Isaac.GetEntitySubTypeByName("Moon ParadoxSaturn (HC)"),
	[mod.Moons.Remina] = Isaac.GetEntitySubTypeByName("Moon Remina (HC)"),

	[mod.Moons.Ash] = Isaac.GetEntitySubTypeByName("Moon Ash (HC)"),
	[mod.Moons.Ember] = Isaac.GetEntitySubTypeByName("Moon Ember (HC)"),
	[mod.Moons.Timber] = Isaac.GetEntitySubTypeByName("Moon Timber (HC)"),
	[mod.Moons.Attle] = Isaac.GetEntitySubTypeByName("Moon Attle (HC)"),
	[mod.Moons.Brittle] = Isaac.GetEntitySubTypeByName("Moon Brittle (HC)"),
	[mod.Moons.Lantern] = Isaac.GetEntitySubTypeByName("Moon Lantern (HC)"),
	[mod.Moons.Giant] = Isaac.GetEntitySubTypeByName("Moon Giant (HC)"),
	[mod.Moons.Bramble] = Isaac.GetEntitySubTypeByName("Moon Bramble (HC)"),
}


mod.TotalMoons = 0
for k in pairs(mod.Moons) do mod.TotalMoons = mod.TotalMoons + 1 end
local TotalMoonsB = -1 ---1 for Sputnik
for k in pairs(mod.LilMoon) do TotalMoonsB = TotalMoonsB + 1 end
if TotalMoonsB ~= mod.TotalMoons then print("WARNING: Amount of Lil Moon entities and items differ") end

function mod:LoadLilMoonData(familiarSub, speed, orbitId, aloneOrbitId, parentSub, orbitDistance)
	aloneOrbitId = aloneOrbitId or orbitId
	parentSub = parentSub or familiarSub

	mod.MoonSpeeds[familiarSub] = speed
	mod.MoonOrbits[familiarSub] = orbitId
	mod.MoonOrbitsVanilla[familiarSub] = aloneOrbitId
	mod.MoonParent[familiarSub] = parentSub
	mod.MoonOrbitDistance[familiarSub] = orbitDistance*0.75
end

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Mercury], 0.25, 8501, nil, nil, 1)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Venus], 0.1826722338, 8502, nil, nil, 2)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Terra], 0.1555323591, 8503, nil, nil, 3)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Theia], 0.14065762005, 8520, nil, nil, 3.5)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Mars], 0.125782881, 8504, nil, nil, 4)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Ceres], 0.09331941545, 8511, nil, nil, 5)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Jupiter], 0.06837160752, 8505, nil, nil, 6)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Saturn], 0.0506263048, 8506, nil, nil, 7)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.ParadoxSaturn], 0.0506263048, 8506, nil, nil, 7)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Uranus], 0.03549060543, 8507, nil, nil, 8)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Neptune], 0.02818371608, 8508, nil, nil, 9)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Pluto], 0.02473903967, 8516, nil, nil, 11)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Eris], 0.01790187891, 8516, nil, nil, 12.8)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Makemake], 0.02306889353, 8516, nil, nil, 12.2)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Haumea], 0.02364300626, 8516, nil, nil, 11.6)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Luna], 0.005636743215, 8510, 8503, mod.LilMoon[mod.Moons.Terra], 1)
mod:LoadLilMoonData(mod.LilMoon.Sputnik, 0.04175365344, 8510, 8503, mod.LilMoon[mod.Moons.Terra], 1)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Io], 0.09044885177, 8512, 8505, mod.LilMoon[mod.Moons.Jupiter], 1.3)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Europa], 0.07171189979, 8512, 8505, mod.LilMoon[mod.Moons.Jupiter], 1.4)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Ganymede], 0.05678496868, 8512, 8505, mod.LilMoon[mod.Moons.Jupiter], 1.5)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Callisto], 0.04279749478, 8512, 8505, mod.LilMoon[mod.Moons.Jupiter], 1.6)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Titan], 0.02907098121, 8513, 8506, mod.LilMoon[mod.Moons.Saturn], 1)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.LethalTitan], 0.02907098121, 8513, 8506, mod.LilMoon[mod.Moons.Saturn], 1)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Umbriel], 0.0243737107, 8514, 8507, mod.LilMoon[mod.Moons.Uranus], 1.05)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Titania], 0.01899791232, 8514, 8507, mod.LilMoon[mod.Moons.Uranus], 1.15)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Oberon], 0.01644050104, 8514, 8507, mod.LilMoon[mod.Moons.Uranus], 1.25)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Triton], 0.02291231733, 8515, 8508, mod.LilMoon[mod.Moons.Neptune], 1)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Charon], 0.001096033403, 8517, 8516, mod.LilMoon[mod.Moons.Pluto], 1)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Errant], 0.01, 8509, nil, nil, 13)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Iris], 0.026461377875, 8518, nil, nil, 10)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.End], 0.0064, 8519, nil, nil, 13)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Subnautica], 0.1529819831, 8520, nil, nil, 3.4)
--mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Petrichor], 0.1093874582, 8520, nil, nil, 3.6)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Popstar], 0.01555323591, 8519, nil, nil, 13)
--mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Skaia], 0.012, 8519, nil, nil, 13)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Cat], 0.01529819831, 8519, nil, nil, 13)
--mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Treasure], 0.02, 8519, nil, nil, 13)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Remina], 0.1, 8511, nil, nil, 5)

local s = 0.55
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Ember], s*5/110, 8521, nil, nil, s*5)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Timber], s*9/250, 8522, nil, nil, s*9)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Brittle], s*12/397, 8523, nil, nil, s*12)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Giant], s*17/650, 8524, nil, nil, s*17)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Bramble], s*20/900, 8525, nil, nil, s*20)

mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Ash], s*5/55, 8526, 8521, mod.LilMoon[mod.Moons.Ember], 0.5)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Attle], s*9/105, 8527, 8522, mod.LilMoon[mod.Moons.Timber], 1)
mod:LoadLilMoonData(mod.LilMoon[mod.Moons.Lantern], s*12/115, 8528, 8523, mod.LilMoon[mod.Moons.Brittle], 1)

--PLAYER UPDATE------------------------------------
function mod:OnPlayerUpdateMoons(player)
	local data = player:GetData()

	--Moons
	local shotDirection = data.CurrentAttackDirection_HC
	if shotDirection then

		local n = 1
		if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then n=n+player:GetTrinketMultiplier(TrinketType.TRINKET_FORGOTTEN_LULLABY) end
		if player:HasTrinket(mod.Trinkets.Flag) then n=n+player:GetTrinketMultiplier(mod.Trinkets.Flag) end

		data.MoonShootMultiplier_HC = n
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdateMoons, 0)

--CACHE-------------------------------------------
function mod:MoonsOnCache(player, cacheFlag)

    if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

		--Mini moon
		for key, moonItemId in pairs(mod.Moons) do
			local numItem = player:GetCollectibleNum(moonItemId)
			local numFamiliars = (numItem > 0 and (numItem + boxUses) or 0)
			player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetCollectibleRNG(moonItemId), Isaac.GetItemConfig():GetCollectible(moonItemId), mod.LilMoon[moonItemId])
		end

		local numFamiliars = player:GetTrinketMultiplier(mod.Trinkets.Sputnik)
		player:CheckFamiliar(mod.EntityInf[mod.Entity.Moon].VAR, numFamiliars, player:GetTrinketRNG(mod.Trinkets.Sputnik), Isaac.GetItemConfig():GetTrinket(mod.Trinkets.Sputnik), mod.LilMoon.Sputnik)
		
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.MoonsOnCache)

--UPDATES-------------------------------------------
function mod:MoonAttack(familiar)
	local data = familiar:GetData()
    local velocity = data.Direcion * 8
    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, velocity, familiar):ToTear()
    tear.CollisionDamage = 4*familiar.CollisionDamage

    if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
        tear:AddTearFlags(TearFlags.TEAR_HOMING)
    end
    if familiar.Player:HasTrinket(mod.Trinkets.Flag) then
        tear.CollisionDamage = 1.5*familiar.CollisionDamage*familiar.Player:GetTrinketMultiplier(mod.Trinkets.Flag)
    end

    local subtype = familiar.SubType

	for i=1, 3 do
		if subtype == mod.LilMoon[mod.Moons.Errant] then
			subtype = mod:RandomInt(0,mod.TotalMoons-1)
		end
	end

    if subtype == mod.LilMoon[mod.Moons.Luna] then
        tear:ChangeVariant(TearVariant.KEY_BLOOD)
        tear:AddTearFlags(TearFlags.TEAR_PIERCING)
        tear:GetSprite().Color = Color(0.75,0.1,0.1,1)
		tear.SpriteScale = tear.SpriteScale*0.67

    elseif subtype == mod.LilMoon[mod.Moons.Mercury] then
		tear:Update()
        tear:GetData().MercuriusTear = true
        tear:GetData().MercuriusTearFlag = true
        mod:ChangeSpriteToBismuth(tear)
		tear.SpriteScale = tear.SpriteScale*0.67

    elseif subtype == mod.LilMoon[mod.Moons.Venus] then
        tear:ChangeVariant(TearVariant.FIRE_MIND)
        tear:AddTearFlags(TearFlags.TEAR_CHARM)
        --tear:AddTearFlags(TearFlags.TEAR_BURN)
		tear:Update()

    elseif subtype == mod.LilMoon[mod.Moons.Terra] then
        --tear:ChangeVariant(TearVariant.HUNGRY)
        tear:AddTearFlags(TearFlags.TEAR_POP)
        tear:AddTearFlags(TearFlags.TEAR_HYDROBOUNCE)
        --tear.CollisionDamage = tear.CollisionDamage*1.5
        tear:GetSprite().Color = Color(0.6,0.6,1,1)

    elseif subtype == mod.LilMoon[mod.Moons.Mars] then
        tear:ChangeVariant(TearVariant.BLOOD)
        tear:AddTearFlags(TearFlags.TEAR_JACOBS)
        tear:GetSprite().Color = mod.Colors.red
                
        local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, tear.Position, Vector.Zero, nil):ToEffect()
		if energy then
			energy.LifeSpan = 1000
			energy.Parent = tear
			energy.DepthOffset = 5
			energy:GetData().HeavensCall = true
			energy:GetData().MarsShot_HC = true
			energy:GetSprite().Scale = Vector.One*0.8
			energy:FollowParent(tear)
		end

    elseif subtype == mod.LilMoon[mod.Moons.Jupiter] then
        tear:AddTearFlags(TearFlags.TEAR_POISON)
        tear:AddTearFlags(TearFlags.TEAR_KNOCKBACK)
        tear:GetSprite().Color = Color.ProjectileCorpseGreen

    elseif subtype == mod.LilMoon[mod.Moons.Saturn] then
        tear:ChangeVariant(TearVariant.KEY)
        tear:AddTearFlags(TearFlags.TEAR_FREEZE)
		tear.SpriteScale = tear.SpriteScale*0.67

    elseif subtype == mod.LilMoon[mod.Moons.Uranus] then
        tear:ChangeVariant(TearVariant.ICE)
        tear:AddTearFlags(TearFlags.TEAR_SLOW)
        tear:AddTearFlags(TearFlags.TEAR_ICE)
		tear.SpriteScale = tear.SpriteScale*0.75

    elseif subtype == mod.LilMoon[mod.Moons.Neptune] then
        tear:ChangeVariant(TearVariant.DARK_MATTER)
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        tear:GetSprite().Color = Color(0,0,1,1)
		if rng:RandomFloat() < 0.5 then
			tear:AddTearFlags(TearFlags.TEAR_FEAR)
		end
        
    elseif subtype == mod.LilMoon[mod.Moons.Ceres] then
        tear:ChangeVariant(TearVariant.GLAUCOMA)
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
        
    elseif subtype == mod.LilMoon[mod.Moons.Io] then
        tear:AddTearFlags(TearFlags.TEAR_ACID)
        tear:GetSprite().Color = Color.ProjectileCorpseYellow
    elseif subtype == mod.LilMoon[mod.Moons.Europa] then
        tear:ChangeVariant(TearVariant.BLOOD)
        tear:AddTearFlags(TearFlags.TEAR_GISH)
        tear:AddTearFlags(TearFlags.TEAR_SLOW)
        tear:GetSprite().Color = Color.ProjectileTar
    elseif subtype == mod.LilMoon[mod.Moons.Ganymede] then
        tear:AddTearFlags(TearFlags.TEAR_JACOBS)
		if rng:RandomFloat() < 0.5 then
			tear:GetSprite().Color = Color(1,1,1,1,1,0.5,0)
		else
			tear:GetSprite().Color = Color(1,1,1,1,0.5,0.5,1)
		end
    elseif subtype == mod.LilMoon[mod.Moons.Callisto] then
        tear:ChangeVariant(TearVariant.EYE)
        tear:AddTearFlags(TearFlags.TEAR_POP)
        
    elseif subtype == mod.LilMoon[mod.Moons.Titan] then
        tear:ChangeVariant(TearVariant.COIN)
        tear:AddTearFlags(TearFlags.TEAR_COIN_DROP_DEATH)
		tear.SpriteScale = tear.SpriteScale*0.8
        
    elseif subtype == mod.LilMoon[mod.Moons.Titania] then
        tear:ChangeVariant(TearVariant.BLOOD)
        tear:AddTearFlags(TearFlags.TEAR_BAIT)
        tear:GetSprite().Color = Color(1,0,0,1)

    elseif subtype == mod.LilMoon[mod.Moons.Oberon] then
		if rng:RandomFloat() < 0.5 then
			tear:GetData().UranusPoopTear = true
		end
        tear:GetSprite().Color = Color.TearNumberOne

    elseif subtype == mod.LilMoon[mod.Moons.Umbriel] then
		if rng:RandomFloat() < 0.5 then
			tear:GetData().UranusPoopTear = true
		end
        tear:SetColor(mod.Colors.poop2, 0, 99, true, true)
        
    elseif subtype == mod.LilMoon[mod.Moons.Triton] then
        tear:ChangeVariant(TearVariant.DARK_MATTER)
        tear:AddTearFlags(TearFlags.TEAR_BAIT)
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        tear:GetSprite().Color = Color(1,0.,0.,1,0.2)
        
    elseif subtype == mod.LilMoon[mod.Moons.Pluto] then
        tear:ChangeVariant(TearVariant.BONE)
        tear:AddTearFlags(TearFlags.TEAR_PIERCING)
		tear.SpriteScale = tear.SpriteScale*0.8
    elseif subtype == mod.LilMoon[mod.Moons.Eris] then
        tear:ChangeVariant(TearVariant.SWORD_BEAM)
		tear:Update()
        tear:AddTearFlags(TearFlags.TEAR_PUNCH)
		tear.SpriteScale = Vector(tear.SpriteScale.X*0.5, tear.SpriteScale.Y)*0.8
    elseif subtype == mod.LilMoon[mod.Moons.Makemake] then
        tear:ChangeVariant(TearVariant.ROCK)
        tear:AddTearFlags(TearFlags.TEAR_ROCK)
		tear.SpriteScale = tear.SpriteScale*0.8
    elseif subtype == mod.LilMoon[mod.Moons.Haumea] then
        tear:ChangeVariant(TearVariant.LOST_CONTACT)
        tear:AddTearFlags(TearFlags.TEAR_SPLIT)
        tear:GetSprite().Color = Color(1,0.5,0.5,1)
		tear.SpriteScale = tear.SpriteScale*0.6

    elseif subtype == mod.LilMoon[mod.Moons.Iris] then
        tear:ChangeVariant(TearVariant.PUPULA_BLOOD)
        tear:AddTearFlags(TearFlags.TEAR_BAIT)
    elseif subtype == mod.LilMoon[mod.Moons.End] then
        tear:ChangeVariant(TearVariant.MULTIDIMENSIONAL)
        tear:AddTearFlags(TearFlags.TEAR_CONTINUUM)
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
		
    elseif subtype == mod.LilMoon[mod.Moons.Subnautica] then
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        tear:GetSprite().Color = Color(0.5,0.7,1,1)
		if rng:RandomFloat() < 0.5 then
			tear:AddTearFlags(TearFlags.TEAR_FEAR)
		end
    --elseif subtype == mod.LilMoon[mod.Moons.Petrichor] then
    --	tear:AddTearFlags(TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP)
	--	tear:Update()
	--	tear.Color = Color.ProjectileCorpseClusterDark
    elseif subtype == mod.LilMoon[mod.Moons.Popstar] then
        tear:ChangeVariant(TearVariant.HUNGRY)
        tear:AddTearFlags(TearFlags.TEAR_POP)
        tear:AddTearFlags(TearFlags.TEAR_HYDROBOUNCE)
		tear.Color = Color(2,0.3,.35,1,0.1,0.1,0.1)
    --elseif subtype == mod.LilMoon[mod.Moons.Skaia] then
    --    tear:ChangeVariant(TearVariant.CUPID_BLUE)
    --    tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
    --    tear:AddTearFlags(TearFlags.TEAR_CHARM)
	--	tear.SpriteScale = tear.SpriteScale*0.75
    elseif subtype == mod.LilMoon[mod.Moons.Cat] then
        tear:AddTearFlags(TearFlags.TEAR_CHARM)
        tear:AddTearFlags(TearFlags.TEAR_CONTINUUM)
    elseif subtype == mod.LilMoon[mod.Moons.LethalTitan] then
        tear:ChangeVariant(TearVariant.ICE)
        tear:AddTearFlags(TearFlags.TEAR_ICE)
		if rng:RandomFloat() < 0.5 then
			tear:AddTearFlags(TearFlags.TEAR_FEAR)
		end
		tear.SpriteScale = tear.SpriteScale*0.75
    --elseif subtype == mod.LilMoon[mod.Moons.Treasure] then
    --    tear:ChangeVariant(TearVariant.NAIL)
	--	if rng:RandomFloat() < 0.25 then
	--		tear:AddTearFlags(TearFlags.TEAR_MIDAS)
	--	end
	--	tear.SpriteScale = tear.SpriteScale*0.75
	--	tear:GetSprite().Color = Color(0.7,1,0.7,1,0,0.5,0)
    elseif subtype == mod.LilMoon[mod.Moons.Theia] then
        tear:ChangeVariant(TearVariant.DIAMOND)
        tear:AddTearFlags(TearFlags.TEAR_ROCK)
        tear:AddTearFlags(TearFlags.TEAR_SPLIT)
		local color = Color.ProjectileHoming
		tear:GetSprite().Color = color
    elseif subtype == mod.LilMoon[mod.Moons.Remina] then
        tear:ChangeVariant(TearVariant.CUPID_BLOOD)
        tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
		if rng:RandomFloat() < 0.5 then
			tear:AddTearFlags(TearFlags.TEAR_FEAR)
		end
		tear.SpriteScale = tear.SpriteScale*0.75
		
    elseif subtype == mod.LilMoon[mod.Moons.ParadoxSaturn] then
        tear:ChangeVariant(TearVariant.MULTIDIMENSIONAL)
        tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
	elseif subtype == mod.LilMoon[mod.Moons.Ash] then
        tear:ChangeVariant(TearVariant.ROCK)
        tear:AddTearFlags(TearFlags.TEAR_ROCK)
		tear.SpriteScale = tear.SpriteScale*0.8
		tear:GetSprite().Color = Color(1,1,0.5,1)
	elseif subtype == mod.LilMoon[mod.Moons.Ember] then
        tear:ChangeVariant(TearVariant.ROCK)
        tear:AddTearFlags(TearFlags.TEAR_ROCK)
		tear.SpriteScale = tear.SpriteScale*0.8
		tear:GetSprite().Color = Color(1,0.5,0.5,1)
	elseif subtype == mod.LilMoon[mod.Moons.Timber] then
		--tear:ChangeVariant(TearVariant.HUNGRY)
        tear:AddTearFlags(TearFlags.TEAR_POP)
        tear:AddTearFlags(TearFlags.TEAR_HYDROBOUNCE)
        --tear.CollisionDamage = tear.CollisionDamage*1.5
        tear:GetSprite().Color = Color(0.6,0.6,1,1)
	elseif subtype == mod.LilMoon[mod.Moons.Brittle] then
        tear:ChangeVariant(TearVariant.MULTIDIMENSIONAL)
        tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
	elseif subtype == mod.LilMoon[mod.Moons.Giant] then
        tear:AddTearFlags(TearFlags.TEAR_JACOBS)
                
        local energy = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, 0, tear.Position, Vector.Zero, nil):ToEffect()
		if energy then
			energy.LifeSpan = 1000
			energy.Parent = tear
			energy.DepthOffset = 5
			energy:GetData().HeavensCall = true
			energy:GetData().MarsShot_HC = true
			energy:GetSprite().Scale = Vector.One*0.8
			energy:FollowParent(tear)
		end

	elseif subtype == mod.LilMoon[mod.Moons.Bramble] then
        tear:ChangeVariant(TearVariant.ICE)
        tear:AddTearFlags(TearFlags.TEAR_SLOW)
        tear:AddTearFlags(TearFlags.TEAR_ICE)
		tear.SpriteScale = tear.SpriteScale*0.75
    end
end

function mod:OnMoonUpdate(familiar)
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local data = familiar:GetData()

	familiar.CollisionDamage = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		familiar.CollisionDamage = familiar.CollisionDamage * 2
	end

	if player:GetData().CurrentAttackDirection_HC then
		data.Direcion = player:GetData().CurrentAttackDirection_HC

		for i=1, player:GetData().MoonShootMultiplier_HC do
			if rng:RandomFloat() < 0.025 and not sprite:IsPlaying("Attack") then
				sprite:Play("Attack", true)
			end
		end
	end

	if sprite:IsFinished("Attack") then
		sprite:Play("Idle", true)
	elseif sprite:IsEventTriggered("Attack") and data.Direcion then
		mod:MoonAttack(familiar)
	end


	--Orbits
	local factor1 = 1
	local factor2 = 1* 0.5 
	if data.Factor_HC then
		factor1 = data.Factor_HC*0.85
		factor2 = 1/data.Factor_HC/2* 0.5 
	end

	if familiar.Parent then
		if familiar.SubType ~= 9 then
			familiar.Velocity = familiar:GetOrbitPosition(familiar.Parent.Position + familiar.Parent.Velocity) - familiar.Position
			familiar.OrbitSpeed = mod.MoonSpeeds[familiar.SubType] * factor2
			familiar.OrbitDistance = Vector(25, 25) * mod.MoonOrbitDistance[familiar.SubType] * factor1
		else
			familiar.Velocity = familiar:GetOrbitPosition(familiar.Parent.Position + familiar.Parent.Velocity) - familiar.Position
			familiar.OrbitSpeed = mod.MoonSpeeds[familiar.SubType] * factor2 * 10
			familiar.OrbitDistance = Vector(25, 25) * mod.MoonOrbitDistance[familiar.SubType] * factor1 / 10
		end
	else
		local theEntity = mod.SolarItemsVars.LilSol[mod:PlayerId(player)] or player
		familiar.Velocity = familiar:GetOrbitPosition(theEntity.Position) - familiar.Position
		familiar.OrbitSpeed = mod.MoonSpeeds[mod.MoonParent[familiar.SubType]] * factor2
		familiar.OrbitDistance = Vector(25, 25) * mod.MoonOrbitDistance[mod.MoonParent[familiar.SubType]] * factor1
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.OnMoonUpdate, mod.EntityInf[mod.Entity.Moon].VAR)

--INITS-------------------------------------
function mod:OnMoonInit(familiar, flag)

	mod:scheduleForUpdate(function()
		if not flag then
			for _, moon in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR)) do
				
				mod:OnMoonInit(moon:ToFamiliar(), true)
			end
		end
	end, 1)

	local parent = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR, mod.MoonParent[familiar.SubType])[1]
	if parent and familiar.InitSeed ~= parent.InitSeed then
		familiar:AddToOrbit(mod.MoonOrbits[familiar.SubType])
		familiar.Parent = parent
	else
		familiar:AddToOrbit(mod.MoonOrbitsVanilla[familiar.SubType])
	end

	local sprite = familiar:GetSprite()
	sprite:Play("Idle")
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.OnMoonInit, mod.EntityInf[mod.Entity.Moon].VAR)

--OTHERS---------------------------
function mod:CountMiniMoons(player)
	local count = 0
	for k in pairs(mod.Moons) do
		local moon = mod.Moons[k]
		count = count + player:GetCollectibleNum(moon)
	end
	return count
end
function mod:ChooseMiniMoon(player)

	local options = {}

	for k in pairs(mod.Moons) do
		local moon = mod.Moons[k]
		if (not player:HasCollectible(moon)) and not (mod.Moons.Ash <= moon and moon <= mod.Moons.Bramble) then
			table.insert(options, moon)
		end
	end

	if #options > 0 then
		return mod:random_elem(options)
	else
		return -1
	end
end
function mod:GetRandomHeldMiniMoon(player)

	local options = {}

	for k in pairs(mod.Moons) do
		if mod.Moons[k] and player:HasCollectible(mod.Moons[k]) then
			table.insert(options, mod.Moons[k])
		end
	end

	if #options > 0 then
		return mod:random_elem(options)
	else
		return -1
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.FamiliarProtection, mod.EntityInf[mod.Entity.Moon].VAR)

function mod:GiveAllMoons()
	local player = game:GetPlayer(0)

	for k in pairs(mod.Moons) do
		player:AddCollectible(mod.Moons[k])
	end
end

function mod:ChangeLilErrantOrbit()
	--Errant Moons
	for _, _errant in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR, mod.LilMoon[mod.Moons.Errant])) do
		local errant = _errant:ToFamiliar()
		if errant then
			local moons = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.EntityInf[mod.Entity.Moon].VAR)
			local random = mod:RandomInt(1, #moons)
			local i = 1
			for _, moon in ipairs(moons) do
				if moon.SubType ~= 9 and i==random then
					errant.Parent = moon
					errant:AddToOrbit(mod.MoonOrbits[moon.SubType])
					break
				end
				i=i+1
			end
		end
	end
end