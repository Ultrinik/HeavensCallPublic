local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()

function mod:DissapearAfterIdle(effect)
    if effect:GetSprite():IsFinished("Idle") or effect:GetSprite():IsFinished("Idle2") or effect:GetSprite():IsFinished("Idle3") then
        effect:Remove()
    end
end

--Fix Position
function mod:FixPosition(entity)
	local data = entity:GetData()
	if data.Position_HC then
		entity.Position = data.Position_HC
		entity.Velocity = Vector.Zero
	end
end
--Selfdestruct
function mod:Selfdestruct(entity)
	local data = entity:GetData()
	if not data.FrameCount then
		data.FrameCount = 0
	end

	if data.MaxFrames and data.FrameCount and (data.FrameCount > data.MaxFrames) then
		if data.Die then
			entity:Die()
		elseif data.NoPoof then
			entity:Remove()
		else
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position + Vector(5,0), Vector.Zero, nil)
			poof.DepthOffset = 100
			entity:Remove()
		end
	end
	data.FrameCount = data.FrameCount + 1
end

--SCRIPTS
include("scripts.entities.otherentities")

include("scripts.entities.others.astralstatue")

include("scripts.entities.outer.jupiter")
include("scripts.entities.outer.saturn")
include("scripts.entities.outer.uranus")
include("scripts.entities.outer.neptune")

include("scripts.entities.inner.mercury")
include("scripts.entities.inner.venus")
include("scripts.entities.inner.terra")
include("scripts.entities.inner.mars")

include("scripts.entities.lunar.luna")
include("scripts.entities.lunar.kuiper")
include("scripts.entities.lunar.errant")

include("scripts.entities.solar.sol")
include("scripts.entities.solar.rsaturn")
include("scripts.entities.solar.everchanger")

include("scripts.entities.planetpersistance")

function mod:TryToSpawnLunarCrawler(roomdesc)
	local room = game:GetRoom()
	if mod:IsRedRoom(roomdesc) and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 and not mod:IsGlassRoom(roomdesc) and not (mod.savedatarun().planetAlive and mod.savedatarun().planetNum == mod.Entity.Luna) then
		local position = nil
		local extra = 110
		if mod:RandomInt(0,1) == 0 then
			local random = mod:RandomInt(63, 577)
			if mod:RandomInt(0,1) == 0 then
				position = Vector(random, 142-extra)
			else
				position = Vector(random, 417+extra)
			end
		else
			local random = mod:RandomInt(142, 417)
			if mod:RandomInt(0,1) == 0 then
				position = Vector(63-extra, random)
			else
				position = Vector(577+extra, random)
			end
		end

		mod:SpawnEntity(mod.Entity.ICUP, position, Vector.Zero, nil)
	end
end


function mod:SpawnAllBosses(charmed, difficulty)
	local position = game:GetRoom():GetCenterPos()
	local entities = {}

	local jupiter = mod:SpawnEntity(mod.Entity.Jupiter, position, Vector.Zero, nil); table.insert(entities, jupiter)
	local saturn = mod:SpawnEntity(mod.Entity.Saturn, position, Vector.Zero, nil); table.insert(entities, saturn)
	local uranus = mod:SpawnEntity(mod.Entity.Uranus, position, Vector.Zero, nil); table.insert(entities, uranus)
	local neptune = mod:SpawnEntity(mod.Entity.Neptune, position, Vector.Zero, nil); table.insert(entities, neptune)
	local mercury = mod:SpawnEntity(mod.Entity.Mercury, position, Vector.Zero, nil); table.insert(entities, mercury)
	local venus = mod:SpawnEntity(mod.Entity.Venus, position, Vector.Zero, nil); table.insert(entities, venus)
	local terra = mod:SpawnEntity(mod.Entity.Terra1, position, Vector.Zero, nil); table.insert(entities, terra)
	local mars = mod:SpawnEntity(mod.Entity.Mars, position, Vector.Zero, nil); table.insert(entities, mars)
	local pluto = mod:SpawnEntity(mod.Entity.Pluto, position, Vector.Zero, nil); table.insert(entities, pluto)
	local charon = mod:SpawnEntity(mod.Entity.Charon1, position, Vector.Zero, nil); table.insert(entities, charon)
	local eris = mod:SpawnEntity(mod.Entity.Eris, position, Vector.Zero, nil); table.insert(entities, eris)
	local makemake = mod:SpawnEntity(mod.Entity.Makemake, position, Vector.Zero, nil); table.insert(entities, makemake)
	local haumea = mod:SpawnEntity(mod.Entity.Haumea, position, Vector.Zero, nil); table.insert(entities, haumea)
	local ceres = mod:SpawnEntity(mod.Entity.Ceres, position, Vector.Zero, nil); table.insert(entities, ceres)
	local luna = mod:SpawnEntity(mod.Entity.Luna, position, Vector.Zero, nil); table.insert(entities, luna)
	local errant = mod:SpawnEntity(mod.Entity.Errant, position, Vector.Zero, nil); table.insert(entities, errant)
	local sol = mod:SpawnEntity(mod.Entity.Sol, position, Vector.Zero, nil); table.insert(entities, sol)
	local rsaturn = mod:SpawnEntity(mod.Entity.RSaturn, position, Vector.Zero, nil); table.insert(entities, rsaturn)

	if charmed then
		local player = Isaac.GetPlayer()
		for i, entity in ipairs(entities) do
			--entity:AddCharmed(EntityRef(player), -1)
			entity:AddEntityFlags(EntityFlag.FLAG_BAITED)
		end
	end

	if difficulty then
		mod:UpdateDifficulty(difficulty)
	end
end

function mod:FamiliarProtection(familiar, collider, collision)
	if collider.Type == EntityType.ENTITY_PROJECTILE then 
		if collider:ToProjectile():HasProjectileFlags(ProjectileFlags.EXPLODE) or collider:GetData().LunaIpecac then
			collider:Remove()
		else
			collider:Die()
		end
	end
end