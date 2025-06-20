local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local FERVENT_TRINKET_ID = Isaac.GetItemIdByName("Fervent Trinket")
local FERVENT_COLOR = Color(1,1,1,1, 0.25,0.12,0)

--ITEM TRINKET ROLL
mod:AddResetFlag(ModCallbacks.MC_POST_GAME_STARTED, "savedatarun.RerolledIncenseSeeds", {})

function mod:GetFerventTrinket(collectible)
    local rng = RNG(collectible.InitSeed)

    local trinket = mod:RandomInt(1, TrinketType.NUM_TRINKETS-1, rng)
    local c = 0

    while mod:IsTrinketInRoom(trinket) do
        trinket = mod:RandomInt(1, TrinketType.NUM_TRINKETS-1, rng)
        c = c + 1
        if c>=100 then break end
    end
    return trinket
end

function mod:OnCollectibleInitIncense(pickup)

    local flag = false
    for i, seed in ipairs(mod.savedatarun().RerolledIncenseSeeds) do
        if seed == pickup.InitSeed then
            flag = true
            break
        end
    end
    if not flag then
        table.insert(mod.savedatarun().RerolledIncenseSeeds, pickup.InitSeed)
    end

    if pickup.SubType == FERVENT_TRINKET_ID then
        local sprite = pickup:GetSprite()
        local data = pickup:GetData()

        local trinket = mod:GetFerventTrinket(pickup)
        data.fervent_trinket_id = trinket

        local trinket_dummy = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, Vector.Zero, Vector.Zero, nil)
        local path = trinket_dummy:GetSprite():GetLayer(0):GetSpritesheetPath()
        trinket_dummy:Remove()

        if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND == 0 then
            sprite:ReplaceSpritesheet(1, path, true)
        end
        pickup:SetColor(FERVENT_COLOR, -1, 1, true, true)

        if EID then
            local description = EID:getDescriptionObj(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, nil, false)
            data["EID_Description"] = description
        end

    elseif mod:SomebodyHasTrinket(mod.Trinkets.Incense) and pickup.SubType > 0 then
        if not flag then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, FERVENT_TRINKET_ID, true, true, false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OnCollectibleInitIncense, PickupVariant.PICKUP_COLLECTIBLE)


function mod:FerventTrinketPostCollision(collectible, collider)
    local is_fervent = true
    local color = collectible:GetColor()
    for _, p in ipairs({'R','G','G','RO','GO','BO'}) do
        is_fervent = is_fervent and (color[p] == FERVENT_COLOR[p])
    end

    if (collectible.SubType == 0) and is_fervent then
        local trinket = mod:GetFerventTrinket(collectible)
		local player = collider:ToPlayer()
		if player then
            local hud = game:GetHUD()
            local name = XMLData.GetEntryById(XMLNode.TRINKET, trinket).name
            local description = XMLData.GetEntryById(XMLNode.TRINKET, trinket).description
            hud:ShowItemText(name,description)

			mod:AddGulpedTrinket(player, trinket, true)
            collectible:GetData().fervent_trinket_id = nil
            collectible:GetSprite().Color = Color.Default

            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)

            mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.FerventTrinketUpdate)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.FerventTrinketPostCollision, PickupVariant.PICKUP_COLLECTIBLE)

function mod:FerventTrinketUpdate(player)
    if player:HasCollectible(FERVENT_TRINKET_ID) then
        player:RemoveCollectible(FERVENT_TRINKET_ID)
        if not player:HasCollectible(FERVENT_TRINKET_ID) and player:GetHeldSprite():GetAnimation() == ""  then
            mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.FerventTrinketUpdate)
        end
    end
end