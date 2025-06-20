local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()


mod.IridicentItems = {}

--BISMUTH COLLECTIBLE
function mod:BismutifyCollectible(collectible, created)
	local sprite = collectible:GetSprite()

	local currentAnimation = sprite:GetAnimation()
	local currentOverlayAnimation = sprite:GetOverlayAnimation()
	local overlayFrame = sprite:GetOverlayFrame()
	local item = collectible.SubType

	sprite:Load("hc/gfx/pickup_BismuthCollectible.anm2", false)
	sprite:Play(currentAnimation, true)
	sprite:SetOverlayFrame(currentOverlayAnimation, overlayFrame)
	sprite:ReplaceSpritesheet(1, Isaac.GetItemConfig():GetCollectible(item).GfxFileName)
	sprite:LoadGraphics()

	collectible:GetData().IsBismuth_HC = true

    if created then
        mod.IridicentItems[#mod.IridicentItems + 1] = {ROOM = game:GetLevel():GetCurrentRoomIndex(), ITEM = collectible.SubType}
    end
end

function mod:BismuthCollectibleUpdate(collectible)
	if collectible:GetData().IsBismuth_HC and collectible.FrameCount % 4 == 0 then
		local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ULTRA_GREED_BLING, 0, collectible.Position + Vector(0,-40) + RandomVector() * ( 10 * rng:RandomFloat() + 10 ), Vector.Zero, collectible)
		shine.DepthOffset = 50
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.BismuthCollectibleUpdate, PickupVariant.PICKUP_COLLECTIBLE)

function mod:BismuthCollectibleCollision(collectible, collider)
	if collectible:GetData().IsBismuth_HC then
		player = collider:ToPlayer()
		if player then
			local item = collectible.SubType
			mod:scheduleForUpdate(function()
                if collectible then
                    if collectible.SubType == 0 then
                        player:AddCollectible(item, 0, false)

                        for i, entry in ipairs(mod.IridicentItems) do
                            if entry.ROOM == game:GetLevel():GetCurrentRoomIndex() and item == entry.ITEM then
                                mod.IridicentItems[i] = nil
                                break
                            end
                        end
                    else
                        collectible:GetData().IsBismuth_HC = true
                    end
                end
			end, 41)
			collectible:GetData().IsBismuth_HC = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.BismuthCollectibleCollision, PickupVariant.PICKUP_COLLECTIBLE)

function mod:SetIridicentsOnNewRoom()

    for _, entry in ipairs(mod.IridicentItems) do
        if entry.ROOM == game:GetLevel():GetCurrentRoomIndex() then
            for _, collectible in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                if collectible.SubType ~= 0 and collectible.SubType == entry.ITEM and not collectible:GetData().IsBismuth_HC then
                    mod:BismutifyCollectible(collectible, false)
                    break
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SetIridicentsOnNewRoom)


function mod:DivideCollectible(collectible)
    for i=1, 2 do
        local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible.SubType, collectible.Position, collectible.Velocity, nil)
    end
    collectible:Remove()
end

function mod:IsCollectibleIridisent(collectible)
    return collectible:GetData().IsBismuth_HC
end


function mod:OnAbsorbActive()
	for _, pedestal in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
		if mod:IsCollectibleIridisent(pedestal) then
			mod:DivideCollectible(pedestal)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnAbsorbActive, CollectibleType.COLLECTIBLE_VOID)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnAbsorbActive, CollectibleType.COLLECTIBLE_ABYSS)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.OnAbsorbActive, CollectibleType.COLLECTIBLE_MOVING_BOX)
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnAbsorbActive, Card.RUNE_BLACK)
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnAbsorbActive, Card.CARD_REVERSE_HERMIT)