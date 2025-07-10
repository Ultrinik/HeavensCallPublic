local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--Reset chances if glowing hourglass was used
function mod:OnGlowingHourglass()
	if mod.savedatarun().planetNum == mod.Entity.Saturn then
		mod.ModFlags.glowingHourglass = 2--You are not going to scape
	end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnGlowingHourglass, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
function mod:OnGlowingHourglassNewRoom()
	mod.ModFlags.glowingHourglass = mod.ModFlags.glowingHourglass - 1
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnGlowingHourglassNewRoom)


--ABOSRT TYPE ACTIVE--------------------------------------------------------------------------------
--Trying to steal the item
function mod:TryToStealStatue()
	mod:ForceStatueToTrigger()
	--mod:OnDoomsdayItemTaken()
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TryToStealStatue, CollectibleType.COLLECTIBLE_VOID)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TryToStealStatue, CollectibleType.COLLECTIBLE_ABYSS)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TryToStealStatue, CollectibleType.COLLECTIBLE_MOVING_BOX)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TryToStealStatue, mod.SolarItems.Quasar)

function mod:OnStealConsumable()

	mod:TryToStealStatue()

	if mod:IsRoomDescLunarPact(game:GetLevel():GetCurrentRoomDesc()) then
		--Mark pedestals
		for _, _pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
			local pedestal = _pedestal:ToPickup()
			if pedestal then
				if pedestal:GetData().LunarPact then
					local oldSubType = pedestal.SubType
	
					pedestal:Remove()
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnStealConsumable, Card.RUNE_BLACK)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnStealConsumable, Card.CARD_REVERSE_HERMIT)

--Uranus shitting
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Uranus)) do
		e:GetData().State = mod.UMSState.SPIN
		e:GetData().StateFrame = 0
		mod:UranusThank(e, e:GetData(), e:GetSprite())
	end
end,  CollectibleType.COLLECTIBLE_FLUSH)

--Can spawn after R key
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	if not mod.savedatarun().planetAlive then
		mod.savedatarun().spawnchancemultiplier1 = 1
		mod.savedatarun().spawnchancemultiplier2 = 1
		mod.savedatarun().planetKilled1 = false
		mod.savedatarun().planetKilled2 = false
		mod.savedatarun().planetKilled3 = false
		mod.savedatarun().planetKilled4 = false
	end
end,  CollectibleType.COLLECTIBLE_R_KEY)

--Not Death Certificate or Genesis
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item)
	if mod.savedatarun().planetAlive and ( item == CollectibleType.COLLECTIBLE_GENESIS or item == CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE or item == CollectibleType.COLLECTIBLE_MEAT_CLEAVER ) then
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1)
		return true
	end
end)
--Eternal D6
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,item)
	mod:RemoveCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.StatueRenderUpdate)
	mod:scheduleForUpdate(function()
		mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.StatueRenderUpdate, mod.EntityInf[mod.Entity.Statue].ID)
		for _,pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)) do
			pedestal:GetData().WasDeleted = true
		end
	end,1)
end, CollectibleType.COLLECTIBLE_ETERNAL_D6)

--Errant Generator
mod.RedErrantChance = 0.005*100
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item, rng, player)
	
    if mod.savedatasettings().redErrantSpawnChance == nil then mod.savedatasettings().redErrantSpawnChance = mod.RedErrantChance end
    local totalchance = mod.savedatasettings().redErrantSpawnChance/100

	if rng:RandomFloat() < totalchance and not mod.ModFlags.ErrantRoomSpawned and not mod:WandererCurse() then
		local room = game:GetRoom()

		local closestFrame
		for _, frame in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DOOR_OUTLINE)) do
			if not closestFrame or closestFrame.Position:Distance(player.Position) > frame.Position:Distance(player.Position) then
				closestFrame = frame
			end
		end
		if not closestFrame then return end
		local chosenSlot
		for i = 0, DoorSlot.NUM_DOOR_SLOTS-1 do
			if room:GetDoorSlotPosition(i).X == closestFrame.Position.X and room:GetDoorSlotPosition(i).Y == closestFrame.Position.Y then
				chosenSlot = i
				break
			end
		end

		mod:GenerateErrantRoom(chosenSlot)
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_RED_KEY, "UseItem")
		return true
	end
end,  CollectibleType.COLLECTIBLE_RED_KEY)

function mod:GenerateErrantRoom(slot)
	local level = game:GetLevel()
	local room = game:GetRoom()
	local roomdesc = level:GetCurrentRoomDesc()
	local deadends = mod:GetDeadEnds(roomdesc)

	local roomidx = level:GetCurrentRoomIndex()

	local shape = roomdesc.Data.Shape
	local adjindex = mod.adjindexes[shape]
	local deadend = {}
	for i, entry in pairs(adjindex) do
		if level:GetRoomByIdx(roomidx).Data then
			local oob = false
			for j, idx in pairs(mod.borderrooms[i]) do
				if idx == roomidx then
					oob = true
				end
			end

			if roomdesc.Data.Doors & (1 << i) > 0 and i == slot and level:GetRoomByIdx(roomidx+adjindex[i]).GridIndex == -1 and not oob then
				deadend =  {Slot = i, GridIndex = roomidx+adjindex[i]}
				break
			end
		end
	end
	if not deadend then return end

	local deadendslot = deadend.Slot
	local deadendidx = deadend.GridIndex

	if level:MakeRedRoomDoor(roomidx, slot) then
		local newroomdesc = level:GetRoomByIdx(deadendidx, 0)

		local data = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, 8510, 20)
		newroomdesc.Data = data
		newroomdesc.Flags = 0

		mod:UpdateRoomDisplayFlags(newroomdesc)
		level:UpdateVisibility()

		mod:scheduleForUpdate(function()
			local door = room:GetDoor(slot)
			if not door then return end
			mod:TransformDoor2Astral(door, room, level)
			door:Open()
		end,1)

		if MinimapAPI then
			local gridIndex = newroomdesc.SafeGridIndex
			local position = mod:GridIndexToVector(gridIndex)

			local maproom = MinimapAPI:GetRoomAtPosition(position)
			if maproom then
				--maproom.ID = "astralchallenge"..tostring(gridIndex)

				--Anything below is optional
				maproom.Type = RoomType.ROOM_DICE
				maproom.PermanentIcons = {"GlitchAstralChallenge"}
				maproom.DisplayFlags = 0
				maproom.AdjacentDisplayFlags = 3
				maproom.Descriptor = newroomdesc
				maproom.AllowRoomOverlap = false
				maproom.Color = Color.Default
			end
		end

		mod.ModFlags.ErrantRoomSpawned = true
	end
end

--No D20 reroll chest
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_,item)
	for _, chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST)) do
		if chest:GetSprite():GetAnimation() == "Opened" then
			if mod.EntityVoidSub <= chest.SubType and chest.SubType <= mod.EntityVoidSub+1 then --Void and infinity chest
				chest:Remove()
			end
		end
	end
end, CollectibleType.COLLECTIBLE_D20)

--Void and abyss deintegration
function mod:OnVoidDeintegration(og_item, rng, player)

    local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
	for i, _item in ipairs(items) do
		local item = _item:ToPickup()
		if item.SubType > 0 and item.Price == 0 then

			local deintegration
			if og_item == CollectibleType.COLLECTIBLE_VOID then
				deintegration = mod:SpawnDeintegration(item, 32, 32, 4, player, nil, 1, nil, nil, 1)
			elseif CollectibleType.COLLECTIBLE_ABYSS then
				deintegration = mod:SpawnDeintegration(item, 32, 32, 4, nil, nil, 1, nil, nil, 1)
			end
			deintegration:GetData().EnabledSound = true

			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, item.Position, Vector.Zero, nil)			

			sfx:Play(SoundEffect.SOUND_MEGA_BLAST_END)
			sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnVoidDeintegration, CollectibleType.COLLECTIBLE_VOID)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnVoidDeintegration, CollectibleType.COLLECTIBLE_ABYSS)

--FAKE ACHIEVEMENT
local achievementSprite
function mod:StartAchievement(paper, text)
	achievementSprite = Sprite()

	achievementSprite:Load("hc/gfx/ui/achievement/screen_achievement.anm2", true)

	achievementSprite:ReplaceSpritesheet(4, "hc/gfx/ui/achievement/"..text..".png")
	achievementSprite:ReplaceSpritesheet(2, "hc/gfx/ui/achievement/"..paper..".png")
	achievementSprite:ReplaceSpritesheet(3, "hc/gfx/ui/achievement/"..paper..".png")

	achievementSprite:LoadGraphics()

	achievementSprite:Play("Show", true)
	
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderAchievement)
end
function mod:RenderAchievement()
	if achievementSprite then
		local w = Isaac.GetScreenWidth()
		local h = Isaac.GetScreenHeight()
		local position = Vector(w/2, h/2)

		achievementSprite:Render(position)
		achievementSprite:Update()

		if achievementSprite:IsFinished() then
			achievementSprite = nil
			mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.RenderAchievement)
		end
	end
end