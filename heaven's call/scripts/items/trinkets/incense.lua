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

    local is_golden = false
    if rng:RandomFloat() < 1-(1-0.02)^mod:HowManyTrinkets(mod.Trinkets.Incense) then
        is_golden = true
    end

    local total_trinkets = Isaac.GetItemConfig():GetTrinkets().Size - 1

    local trinket = mod:RandomInt(1, total_trinkets, rng)
    local c = 0

    while (not mod:TrinketExists(trinket)) or mod:IsTrinketInRoom(trinket) do
        trinket = mod:RandomInt(1, total_trinkets, rng)
        c = c + 1
        if c>=100 then break end
    end

    if is_golden then
        trinket = trinket | TrinketType.TRINKET_GOLDEN_FLAG
    end

    return trinket
end

function mod:OnCollectibleInitIncense(pickup)

    if mod:IsItemQuest(pickup.SubType) then return end

    mod.savedatarun().RerolledIncenseSeeds = mod.savedatarun().RerolledIncenseSeeds or {}

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
        
        sprite:SetRenderFlags(sprite:GetRenderFlags() & (~AnimRenderFlags.GOLDEN))

        local trinket = mod:GetFerventTrinket(pickup)
        data.fervent_trinket_id = trinket

        local path = Isaac.GetItemConfig():GetTrinket(trinket).GfxFileName

        if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND == 0 then
            sprite:ReplaceSpritesheet(1, path, true)
        end
        pickup:SetColor(FERVENT_COLOR, -1, 1, true, true)

        if EID then
            local description = EID:getDescriptionObj(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, nil, false)
            data["EID_Description"] = description
        end

        if trinket & TrinketType.TRINKET_GOLDEN_FLAG > 0 then --is golden
            sprite:SetRenderFlags(sprite:GetRenderFlags () | AnimRenderFlags.GOLDEN)
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
        local is_golden = false
        if trinket & TrinketType.TRINKET_GOLDEN_FLAG > 0 then --is golden
            is_golden = true
        end
        trinket = trinket  & (~TrinketType.TRINKET_GOLDEN_FLAG)
        
        
		local player = collider:ToPlayer()
		if player then
            local hud = game:GetHUD()
            local name = XMLData.GetEntryById(XMLNode.TRINKET, trinket).name
            local description = XMLData.GetEntryById(XMLNode.TRINKET, trinket).description
            hud:ShowItemText(name,description)

            if is_golden then
			    mod:AddGulpedTrinket(player, trinket | TrinketType.TRINKET_GOLDEN_FLAG, true)
            else
			    mod:AddGulpedTrinket(player, trinket, true)
            end

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