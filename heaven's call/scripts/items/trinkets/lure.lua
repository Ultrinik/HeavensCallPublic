local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local LURE_UPGRADE_CHANCE = 0.5

--ITEM QUALITY
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "savedatafloor.DarkLureSeeds", {})


local darken = function (pickup, forced)
    if mod:IsItemQuest(pickup.SubType) then return end

    if forced then
        local sprite = pickup:GetSprite()
        sprite:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png", true)
        pickup:SetColor(Color(0,0,0,1), -1, 1, true, true)
        pickup:GetData().EID_Hide = true

        table.insert(mod.savedatafloor().DarkLureSeeds, pickup.InitSeed)
    else
        for i, seed in ipairs(mod.savedatafloor().DarkLureSeeds) do
            if seed == pickup.InitSeed then
                local sprite = pickup:GetSprite()
                sprite:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png", true)
                pickup:SetColor(Color(0,0,0,1), -1, 1, true, true)
                pickup:GetData().EID_Hide = true
                break
            end
        end
    end
end
function mod:OnLureNewRoom()
    local room = game:GetRoom()
    local lure_flag = mod:SomebodyHasTrinket(mod.Trinkets.Lure)

    if room:IsFirstVisit() then
        if lure_flag then
            for i, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                item = item:ToPickup()

                local quality = mod:GetItemQuality(item.SubType)
                if quality < 4 then

                    local chance = 1 - (1 - LURE_UPGRADE_CHANCE)^mod:HowManyTrinkets(mod.Trinkets.Lure)
                    if rng:RandomFloat() < chance then

                        local pool = room:GetItemPool()
                        local new_item = game:GetItemPool():GetCollectible(pool, false)
                        local c = 0

                        while mod:GetItemQuality(new_item) ~= (quality+1) do
                            new_item = game:GetItemPool():GetCollectible(pool, false)
                            c = c+1
                            if c >= 200 then break end
                        end

                        --print("old",item.SubType, quality, "new",new_item, mod:GetItemQuality(new_item))
                        item:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, new_item, true, true, false)
                        darken(item, true)
                    end
                end
            end
        end
    else
        for i, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            if item.SubType > 0 and not item:ToPickup().Touched then
                darken(item, false)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnLureNewRoom)