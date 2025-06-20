local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

--Book of illusions / heart of illusion from team compilance was of big help

mod.BlazeCharacterId = Isaac.GetPlayerTypeByName("The Blaze (HC)")

function mod:OnPicatrixActiveUse(collectibleType, rng, player, flags, slot, customVarData)

    mod:SpawnAstralGuardian(player)

	if flags & UseFlag.USE_NOANIM == 0 then
		player:AnimateCollectible(mod.SolarItems.Picatrix, "UseItem", "PlayerPickupSparkle")

        sfx:Play(mod.SFX.Fireblast)
        sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
	end

end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.OnPicatrixActiveUse, mod.SolarItems.Picatrix)


function mod:SpawnAstralGuardian(player)

    for i=0, game:GetNumPlayers ()-1 do
		local player = game:GetPlayer(i)
        if player and player:GetPlayerType() ~= mod.BlazeCharacterId then
            player:GetData().NotNewPicatrixSummon = true
        end
    end

    player:UseCard(Card.CARD_SOUL_FORGOTTEN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
    --Isaac.ExecuteCommand("addplayer "..mod.BlazeCharacterId.." "..player.ControllerIndex)

	local newPlayerIndex = game:GetNumPlayers() - 1
	local picatrixSummon = Isaac.GetPlayer(newPlayerIndex)
    
    if picatrixSummon then
        picatrixSummon:ChangePlayerType(mod.BlazeCharacterId)
        picatrixSummon:AddCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
        picatrixSummon:AddMaxHearts(-24)
        picatrixSummon:AddHearts(-24)
        picatrixSummon:AddSoulHearts(-24)

        picatrixSummon.Parent = player

        --picatrixSummon:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS)

        local data = picatrixSummon:GetData()
        data.OrbitOffset_HC = 360*rng:RandomFloat()
        data.OrbitAngle_HC = 0
        data.OrbitSpeed_HC = 1
        data.OrbitDistance_HC = 50

        local items = mod:GetListOfItems(player, ItemType.ITEM_ACTIVE)
        items = mod:Shuffle(items)
    
        for index, item in pairs(items) do
            picatrixSummon:AddItemWisp(item, picatrixSummon.Position, true)
        end

        if #items == 0 then 
            picatrixSummon:AddItemWisp(CollectibleType.COLLECTIBLE_SAD_ONION, picatrixSummon.Position, true)
        end

        picatrixSummon:SetColor(Color(1,1,1,1,0.3,0.1,0.4), -1, 1, true, true)
    end

	game:GetHUD():AssignPlayerHUDs()
    
end

function mod:OnPicatrixSummonUpdate(summon)

    if summon:GetPlayerType() == mod.BlazeCharacterId then
        if summon.Parent then
            --summon.MoveSpeed = 0
            summon.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES

            local player = summon.Parent:ToPlayer()
            local data = summon:GetData()

            --init
            data.OrbitAngle_HC = data.OrbitAngle_HC or 0
            data.OrbitSpeed_HC = data.OrbitSpeed_HC or 1
            data.OrbitDistance_HC = data.OrbitDistance_HC or 50
            data.OrbitOffset_HC = data.OrbitOffset_HC or 0


            data.OrbitAngle_HC = (data.OrbitAngle_HC + data.OrbitSpeed_HC) % 360
            
		    summon.Position  = player.Position + Vector.FromAngle(data.OrbitAngle_HC + data.OrbitOffset_HC):Resized(data.OrbitDistance_HC)

            if mod:CountItemWisps(summon) <= 0 then
                mod:FakePlayerDie(summon)
            end
        else
            mod:FakePlayerDie(summon)
        end

        if summon:GetSprite():IsFinished("Death") then
            summon:GetSprite():SetFrame(70)
            
            summon:ChangePlayerType(PlayerType.PLAYER_THELOST)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPicatrixSummonUpdate, 0)

function mod:CountItemWisps(player)
    if not player then return -1 end

    local count = 0
    for _, _wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)) do
        local wisp = _wisp:ToFamiliar()
        local wispPlayer = wisp.SpawnerEntity and wisp.SpawnerEntity:ToPlayer()

        if wispPlayer and mod:ComparePlayer(player, wispPlayer) then
            count = count + 1
        end
    end
    return count
end