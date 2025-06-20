local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

function mod:OnInvictusUpdate()
    if mod:InvictusCurse() then
        if rng:RandomFloat() < mod.CurseConsts.INVICTUS_STARFALL_CHANCE then
            local starfallTimer = mod.SolConst.STARFALL_TIMER

            local room = game:GetRoom()
            local position = room:GetRandomPosition(0)

            local target = mod:SpawnEntity(mod.Entity.SolStarTarget, position, Vector.Zero, nil):ToEffect()
            target:SetTimeout(starfallTimer)
            target:GetSprite().Color = Color(1,1,1,1,1,1,1)
        end
    else
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnInvictusUpdate)
    end
end

function mod:OnInvictusHit(player)

    if not mod:InvictusCurse() then return end

    local item
    local items = mod:GetListOfItems(player, ItemType.ITEM_ACTIVE)
    for i=1, 100 do
        item = items[mod:RandomInt(1,#items)]
        if item and item > 0 and not mod:IsItemQuest(item) then
            break
        end
    end

    if item and item > 0 then
        local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, player.Position, Vector.Zero, nil)
        collectible.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        collectible:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        collectible:Update()
        local deintegration = mod:SpawnDeintegration(collectible, 32, 32, 4, nil, nil, 1, nil, nil, 0.7)
        deintegration.DepthOffset = 100
        collectible:Remove()

        player:RemoveCollectible(item)

        player:AnimateTrapdoor()
        mod:scheduleForUpdate(function()
            player:GetSprite():Play("Sad", true)
        end, 0)
        
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
    end
end

function mod:InitInvictusCurse()
    local level = game:GetLevel()
    local curse = mod.Curse.INVICTUS
    level:AddCurse(curse, true)
    
    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnInvictusUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnInvictusUpdate)
end

function mod:OnInvictusContinue(isContinue)
    if mod:InvictusCurse() then
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.OnInvictusUpdate)
        mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnInvictusUpdate)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnInvictusContinue)
