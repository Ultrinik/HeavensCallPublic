local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.Meteors = {
    HAGALAZ = Isaac.GetCardIdByName("*Hagalaz"),
    JERA = Isaac.GetCardIdByName("*Jera"),
    EHWAZ = Isaac.GetCardIdByName("*Ehwaz"),
    DAGAZ = Isaac.GetCardIdByName("*Dagaz"),
    ANSUZ = Isaac.GetCardIdByName("*Ansuz"),
    PERTHRO = Isaac.GetCardIdByName("*Perthro"),
    BERKANO = Isaac.GetCardIdByName("*Berkano"),
    ALGIZ = Isaac.GetCardIdByName("*Algiz"),
    
    GEBO = Isaac.GetCardIdByName("*Gebo"),
    KENAZ = Isaac.GetCardIdByName("*Kenaz"),
    FEHU = Isaac.GetCardIdByName("*Fehu"),
    OTHALA = Isaac.GetCardIdByName("*Othala"),
    INGWAZ = Isaac.GetCardIdByName("*Ingwaz"),
    SOWILO = Isaac.GetCardIdByName("*Sowilo"),
}
function mod:IsMeteoricRune(subType)
    return mod.Meteors.HAGALAZ <= subType and subType <= mod.Meteors.SOWILO
end

mod.MeteorsConsts = {

    METEOR_CHANCE = 0.0143,

    SPEED = 15,

    V_SPEED = -5,
    DV_SPEED = 0.67,
}

function mod:MeteorRuneUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.RuneMeteor].VAR and entity.SubType == mod.EntityInf[mod.Entity.RuneMeteor].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        local player = entity.Parent and entity.Parent:ToPlayer()
        local card = data.card_hc
        local flags = data.flags_hc

        if player and card and flags then
        
            local id = card - mod.Meteors.HAGALAZ

            if not data.Init then
                data.Init = true
    
                sprite:SetFrame("Idle", id)
                sprite.Offset = Vector(0,-40)
    
                data.vspeed = mod.MeteorsConsts.V_SPEED

                mod:UpdateTheia()
            end
    
            data.vspeed = data.vspeed + mod.MeteorsConsts.DV_SPEED
            sprite.Offset = sprite.Offset + Vector(0, data.vspeed)
            if sprite.Offset.Y >= 0 then
    
                mod:UseMeteorRune(card, player, flags | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
                
                game:BombExplosionEffects(entity.Position, 100, TearFlags.TEAR_NORMAL, mod.Colors.ice, player, 1)
                
		        game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 40, 16, mod.Colors.spacerune)

                entity:Remove()
            end

            sprite.Rotation = sprite.Rotation + 4

        else
            entity:Remove()
        end

    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MeteorRuneUpdate, mod.EntityInf[mod.Entity.RuneMeteor].ID)


local holdingRune = {}
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    holdingRune = {}
end)

function mod:RunesUpdate(player)
    if holdingRune[mod:PlayerId(player)] then
        local data = player:GetData()
        local card = holdingRune[mod:PlayerId(player)][1]
        local flags = holdingRune[mod:PlayerId(player)][2]

        if not mod:PlayerHasCard(player, card) then
            holdingRune[mod:PlayerId(player)] = nil
            player:AnimateCard(card, "HideItem")
            mod:UpdateTheia()
        end

        if data.CurrentAttackDirection_HC then
            player:AnimateCard(card, "HideItem")

            local velocity = data.CurrentAttackDirection_HC*mod.MeteorsConsts.SPEED
            local meteor = mod:SpawnEntity(mod.Entity.RuneMeteor, player.Position, velocity, player)
            meteor.Parent = player

            meteor:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            meteor.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            local mdata = meteor:GetData()
            mdata.card_hc = card
            mdata.flags_hc = flags

            player:SetCard(mod:PlayerGetCardSlot(player, card), Card.CARD_NULL)
            
            holdingRune[mod:PlayerId(player)] = nil
            mod:UpdateTheia()
        end
    end
end

function mod:UseMeteorRune(card, player, flags)
    if card == mod.Meteors.HAGALAZ then
        mod:OnHagalazUse(card, player, flags)
    elseif card == mod.Meteors.JERA then
        mod:OnJeraUse(card, player, flags)
    elseif card == mod.Meteors.EHWAZ then
        mod:OnEhwazUse(card, player, flags)
    elseif card == mod.Meteors.DAGAZ then
        mod:OnDagazUse(card, player, flags)
    elseif card == mod.Meteors.ANSUZ then
        mod:OnAnsuzUse(card, player, flags)
    elseif card == mod.Meteors.PERTHRO then
        mod:OnPerthroUse(card, player, flags)
    elseif card == mod.Meteors.BERKANO then
        mod:OnBerkanoUse(card, player, flags)
    elseif card == mod.Meteors.ALGIZ then
        mod:OnAlgizUse(card, player, flags)
    
    elseif AntibirthRunes then
        if card == mod.Meteors.GEBO then
            mod:OnGeboUse(card, player, flags)
        elseif card == mod.Meteors.KENAZ then
            mod:OnKenazUse(card, player, flags)
        elseif card == mod.Meteors.FEHU then
            mod:OnFehuUse(card, player, flags)
        elseif card == mod.Meteors.OTHALA then
            mod:OnOthalaUse(card, player, flags)
        elseif card == mod.Meteors.INGWAZ then
            mod:OnIngwazUse(card, player, flags)
        elseif card == mod.Meteors.SOWILO then
            mod:OnSowiloUse(card, player, flags)
        end
    end
end
function mod:LiftRune(card, player, flags)
    if flags & UseFlag.USE_MIMIC > 0 then
        mod:UseMeteorRune(card, player, flags)
        return
    end

    if not holdingRune[mod:PlayerId(player)] then
        player:AnimateCard(card, "LiftItem")
        player:AddCard(card)
        holdingRune[mod:PlayerId(player)] = {card, flags}
    else
        player:AnimateCard(card, "HideItem")
        holdingRune[mod:PlayerId(player)] = nil
        player:AddCard(card)
    end
    mod:UpdateTheia()

end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.HAGALAZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.JERA)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.EHWAZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.DAGAZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.ANSUZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.PERTHRO)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.BERKANO)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.ALGIZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.GEBO)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.KENAZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.FEHU)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.OTHALA)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.INGWAZ)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.LiftRune, mod.Meteors.SOWILO)

function mod:OnHagalazUse(card, player, flags)
    local room = game:GetRoom()
    local gridSize = room:GetGridSize()

    local boom = function(_, position)
        game:BombExplosionEffects(position, 50, TearFlags.TEAR_NORMAL, Color.Default, player, 0.5)
    end

    for index=0, gridSize do
        local grid = room:GetGridEntity(index)
        if grid then
            if grid:GetType() == GridEntityType.GRID_ROCKB or grid:GetType() == GridEntityType.GRID_LOCK or grid:GetType() == GridEntityType.GRID_PILLAR then

                room:RemoveGridEntity(index, 0, false)
                room:Update()
                room:SpawnGridEntity(index, GridEntityType.GRID_DECORATION, 0, grid:GetRNG():GetSeed(), 0)
            end
            if grid:GetType() == GridEntityType.GRID_ROCK_SS then
                boom(grid.Position)
            end

            if grid.State <= 1 and not (grid:GetType() == GridEntityType.GRID_NULL or grid:GetType() == GridEntityType.GRID_DECORATION or grid:GetType() == GridEntityType.GRID_PIT or grid:GetType() == GridEntityType.GRID_SPIKES or grid:GetType() == GridEntityType.GRID_SPIKES_ONOFF or grid:GetType() == GridEntityType.GRID_SPIDERWEB or grid:GetType() == GridEntityType.GRID_WALL or grid:GetType() == GridEntityType.GRID_TRAPDOOR or grid:GetType() == GridEntityType.GRID_STAIRS or grid:GetType() == GridEntityType.GRID_GRAVITY or grid:GetType() == GridEntityType.GRID_PRESSURE_PLATE or grid:GetType() == GridEntityType.GRID_STATUE or grid:GetType() == GridEntityType.GRID_TELEPORTER or grid:GetType() == GridEntityType.GRID_ROCK_SPIKED or grid:GetType() == GridEntityType.GRID_ROCK_SS) then
                game:BombExplosionEffects(grid.Position, 50)
            end
        end
    end

    player:UseCard(Card.RUNE_HAGALAZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_HAGALAZ)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Hagalaz (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnHagalazUse, mod.Meteors.HAGALAZ)

function mod:OnJeraUse(card, player, flags)
    local room = game:GetRoom()

    player:UseCard(Card.RUNE_JERA ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    --player:UseCard(Card.RUNE_JERA ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)

    player:UseActiveItem(CollectibleType.COLLECTIBLE_DIPLOPIA, false)
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_JERA)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Jera (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnJeraUse, mod.Meteors.JERA)

function mod:OnEhwazUse(card, player, flags)
    local room = game:GetRoom()

    player:UseCard(Card.RUNE_EHWAZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)

    if mod:IsCurrentRoomBossRoom() then
        room:TrySpawnDevilRoomDoor(true, true)
    end
    room:TrySpawnBossRushDoor(true, false)
    room:TrySpawnBlueWombDoor(true, true, false)
    room:TrySpawnSecretShop(true)
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_EHWAZ)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Ehwaz (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnEhwazUse, mod.Meteors.EHWAZ)

function mod:OnDagazUse(card, player, flags)
    local room = game:GetRoom()
    local level = game:GetLevel()

    player:UseCard(Card.RUNE_DAGAZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:UseCard(Card.RUNE_DAGAZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)

    for i=0, 13*13-1 do
        local roomdesc = level:GetRoomByIdx(i)
        if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_CURSE then
            local newroomdata = RoomConfigHolder.GetRandomRoom (mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_ANGEL, RoomShape.ROOMSHAPE_1x1, 40, 45, 0, 10, roomdesc.Data.Doors)
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
                    maproom.PermanentIcons = {"AngelRoom"}
                    maproom.DisplayFlags = 0
                    maproom.AdjacentDisplayFlags = 3
                    maproom.Descriptor = roomdesc
                    maproom.AllowRoomOverlap = false
                    maproom.Color = Color.Default

                end
            end

            mod:UpdateRoomDisplayFlags(roomdesc)
        end
    end
    level:UpdateVisibility()

    --Door
    for i = 0, DoorSlot.NUM_DOOR_SLOTS do
        local door = room:GetDoor(i)
        if door and (door.TargetRoomType == RoomType.ROOM_CURSE or door.TargetRoomType == RoomType.ROOM_ANGEL) then
            door:SetRoomTypes(RoomType.ROOM_ANGEL, RoomType.ROOM_ANGEL)
            mod:HyperUpdateDoor(door, RoomType.ROOM_ANGEL)

        end
    end

    if mod.ModFlags.IsApocalypseActive then
        mod:OnApocalypseEnd()
    end
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_DAGAZ)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Dagaz (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnDagazUse, mod.Meteors.DAGAZ)

mod.ModFlags.guppyEyeStage = nil
mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.guppyEyeStage", nil)

function mod:OnAnsuzUse(card, player, flags)
    local room = game:GetRoom()
    local level = game:GetLevel()

    player:UseCard(Card.RUNE_ANSUZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)

    mod.hiddenItemManager:AddForFloor(player, CollectibleType.COLLECTIBLE_GUPPYS_EYE)

    mod.ModFlags.guppyEyeStage = level:GetStage()
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnAnsuzNewRoom)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnAnsuzNewRoom)
    mod:OnAnsuzNewRoom()

    
    for i=0, 13*13-1 do
        local roomdesc = level:GetRoomByIdx(i)
        if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_ULTRASECRET then
            roomdesc.DisplayFlags = roomdesc.DisplayFlags | (1<<0) | (1<<2)
            
            if MinimapAPI then
                local gridIndex = roomdesc.SafeGridIndex
                local position = mod:GridIndexToVector(gridIndex)
                
                local maproom = MinimapAPI:GetRoomAtPosition(position)
                if maproom then
                    maproom.DisplayFlags = (1<<0) | (1<<2)

                end
            end
        end
    end
    level:UpdateVisibility()

    player:UsePill(PillEffect.PILLEFFECT_SEE_FOREVER, PillColor.PILL_BLUE_BLUE, flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    sfx:Stop(SoundEffect.SOUND_THUMBSUP)

    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_ANZUS)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Ansuz (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnAnsuzUse, mod.Meteors.ANSUZ)
function mod:OnAnsuzNewRoom()   
    local room = game:GetRoom()
    local level = game:GetLevel()
    local gridSize = room:GetGridSize()

    local mark = function(sprite)
        sprite:ReplaceSpritesheet(0, "hc/gfx/grid/pearl.png")
        sprite:ReplaceSpritesheet(1, "hc/gfx/grid/pearl.png")
        sprite:LoadGraphics()
    end

    for index=0, gridSize do
        local grid = room:GetGridEntity(index)
        if grid then
            if grid:GetType() == GridEntityType.GRID_ROCKT or grid:GetType() == GridEntityType.GRID_ROCK_SS or grid:GetType() == GridEntityType.GRID_ROCK_ALT2 or grid:GetType() == GridEntityType.GRID_ROCK_GOLD then
                mark(grid:GetSprite())
            end
        end
    end
    local grid = room:GetGridEntity(room:GetDungeonRockIdx())
    if grid and grid:GetType() == GridEntityType.GRID_ROCK and grid.State~=2 then
        mark(grid:GetSprite())
    end

    if mod.ModFlags.guppyEyeStage ~= level:GetStage() then
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnAnsuzNewRoom)
    end
end

function mod:OnPerthroUse(card, player, flags)
    local room = game:GetRoom()

    player:AddCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)
    player:UseCard(Card.CARD_SOUL_EDEN ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:UseCard(Card.CARD_SOUL_ISAAC ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:UseCard(Card.CARD_SOUL_ISAAC ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:RemoveCollectible(CollectibleType.COLLECTIBLE_SACRED_ORB)
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_PERTHRO)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Perthro (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnPerthroUse, mod.Meteors.PERTHRO)


function mod:OnBerkanoUse(card, player, flags)
    local room = game:GetRoom()

    player:UseCard(Card.RUNE_BERKANO ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:UseCard(Card.RUNE_BERKANO ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:UseCard(Card.CARD_SOUL_APOLLYON ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)

    local n = mod:RandomInt(4,6)
    local dipSubs = {0,1,2,4,5,6,12,13,14,20}--nogolden
    for i=1, n do
        local dip = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, dipSubs[mod:RandomInt(1,#dipSubs)], player.Position, Vector.Zero, nil)
    end

    mod:SpawnWaxFriend(player)
    mod:SpawnWaxFriend(player)

    mod:SpawnMiniIsaacMercury(player, player.Position)
    mod:SpawnMiniIsaacMercury(player, player.Position)
    mod:SpawnMiniIsaacMercury(player, player.Position)
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_BERKANO)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Berkano (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnBerkanoUse, mod.Meteors.BERKANO)

function mod:OnAlgizUse(card, player, flags)
    local room = game:GetRoom()

    player:UseCard(Card.RUNE_ALGIZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    player:UseCard(Card.RUNE_ALGIZ ,flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
    
    player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, player.Position)
    player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, player.Position)
    player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, player.Position)
    player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, player.Position)
    
    if flags & UseFlag.USE_NOANNOUNCER == 0 then
        sfx:Play(SoundEffect.SOUND_ALGIZ)
    end
    ItemOverlay.Show(Isaac.GetGiantBookIdByName("Algiz (HC)"), 3, player)
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnAlgizUse, mod.Meteors.ALGIZ)

--AntibirthRunes
if AntibirthRunes then

    function mod:OnGeboUse(card, player, flags)
        local room = game:GetRoom()
    
        player:UseCard(Isaac.GetCardIdByName("Gebo"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        player:UseCard(Isaac.GetCardIdByName("Gebo"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        
        
        if flags & UseFlag.USE_NOANNOUNCER == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Gebo"))
        end
        ItemOverlay.Show(Isaac.GetGiantBookIdByName("Gebo (HC)"), 3, player)
    end
    --mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnGeboUse, mod.Meteors.GEBO)

    function mod:OnKenazUse(card, player, flags)
        local room = game:GetRoom()
        local t = math.floor(30*6)

        player:UseCard(Isaac.GetCardIdByName("Kenaz"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)

        local giganteMult = player:GetTrinketMultiplier(TrinketType.TRINKET_GIGANTE_BEAN) + 1
        
		local entities = Isaac.GetRoomEntities()
		for index, entity in ipairs(entities) do
			if entity:IsActiveEnemy(false) then
				entity:AddBurn(EntityRef(player), t, 1.)
				entity:AddCharmed(EntityRef(player), t)
				entity:AddConfusion(EntityRef(player), t, true)
				entity:AddFear(EntityRef(player), t)
				entity:AddPoison(EntityRef(player), t, 1.)
				entity:AddSlowing(EntityRef(player), t, 0.85, Color.Default)

                local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, player):ToEffect()
                if cloud then
                    cloud.SpriteScale = cloud.SpriteScale*math.sqrt(giganteMult)
                    mod:scheduleForUpdate(function()--ok sure
                        if cloud then
                            cloud.Timeout = math.ceil(30*math.sqrt(giganteMult))
                        end
                    end,30)
                end
			end
		end    
        
        if flags & UseFlag.USE_NOANNOUNCER == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Kenaz"))
        end
        ItemOverlay.Show(Isaac.GetGiantBookIdByName("Kenaz (HC)"), 3, player)
    end
    --mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnKenazUse, mod.Meteors.KENAZ)

    function mod:OnFehuUse(card, player, flags)
        local room = game:GetRoom()
        local t = 30*5

        player:UseCard(Isaac.GetCardIdByName("Fehu"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        
		local entities = Isaac.GetRoomEntities()
		for index, entity in ipairs(entities) do
			if entity:IsActiveEnemy(false) then
				entity:AddMidasFreeze(EntityRef(player), t)
                mod:scheduleForUpdate(function()
                    if entity then
                        entity:AddMidasFreeze(EntityRef(player), t)
                    end
                end, t)
            end
        end
        
        if flags & UseFlag.USE_NOANNOUNCER == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Fehu"))
        end
        ItemOverlay.Show(Isaac.GetGiantBookIdByName("Fehu (HC)"), 3, player)
    end
    --mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnFehuUse, mod.Meteors.FEHU)

    function mod:OnOthalaUse(card, player, flags)
        local room = game:GetRoom()
    
        player:UseCard(Isaac.GetCardIdByName("Othala"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        
        local items = mod:GetListOfItems(player)
        for i=1, 3 do
            local item = items[mod:RandomInt(1,#items)]
            if item and item > 0 then
                if not mod:IsItemQuest(item) then
                    if mod:IsItemActive(item) then
                        for j=1, 3 do
                            mod:AddItemSpark(player, item, nil, nil, mod:CheckIsStellarItemSpecial(item), true)
                        end
                    else
                        player:AddItemWisp(item, player.Position)
                    end
                end
            end
        end
        
        
        if flags & UseFlag.USE_NOANNOUNCER == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Othala"))
        end
        ItemOverlay.Show(Isaac.GetGiantBookIdByName("Othala (HC)"), 3, player)
    end
    --mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnOthalaUse, mod.Meteors.OTHALA)

    function mod:OnIngwazUse(card, player, flags)
        local room = game:GetRoom()
        local level = game:GetLevel()
    
        player:UseCard(Isaac.GetCardIdByName("Ingwaz"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        
        if true then
            local newroomdata = nil
            local p = nil
            local t = nil
            if mod:RandomInt(0,1) == 0 then
                newroomdata = RoomConfigHolder.GetRandomRoom (mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_TREASURE, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 10, mod.normalDoors)
                p = "TreasureRoom"
                t = RoomType.ROOM_TREASURE
            else
                newroomdata = RoomConfigHolder.GetRandomRoom (mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_CHEST, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 10, mod.normalDoors)
                p = "ChestRoom"
                t = RoomType.ROOM_CHEST
            end

            local roomdesc = mod:GenerateRoomFromData(newroomdata, false)
            if roomdesc then
                local roomdata = roomdesc.Data

                if MinimapAPI then
                    local gridIndex = roomdesc.SafeGridIndex
                    local position = mod:GridIndexToVector(gridIndex)
                    
                    local maproom = MinimapAPI:GetRoomAtPosition(position)
                    if maproom then
                        --maproom.ID = "angelshop"..tostring(gridIndex)
                        maproom.Shape = roomdata.Shape
            
                        --Anything below is optional
                        maproom.Type = t
                        maproom.PermanentIcons = {p}
                        maproom.DisplayFlags = 0
                        maproom.AdjacentDisplayFlags = 3
                        maproom.Descriptor = roomdesc
                        maproom.AllowRoomOverlap = false
                        maproom.Color = Color.Default
    
                    end
                end
    
                mod:UpdateRoomDisplayFlags(roomdesc)
                level:UpdateVisibility()
            end
        end
        
        if flags & UseFlag.USE_NOANNOUNCER == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Ingwaz"))
        end
        ItemOverlay.Show(Isaac.GetGiantBookIdByName("Ingwaz (HC)"), 3, player)
    end
    --mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnIngwazUse, mod.Meteors.INGWAZ)
    
    function mod:OnSowiloUse(card, player, flags)
        local room = game:GetRoom()
    
        player:UseCard(Isaac.GetCardIdByName("Sowilo"), flags | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOANIM)
        mod:ChampifyEnemies()
        
        
        if flags & UseFlag.USE_NOANNOUNCER == 0 then
            sfx:Play(Isaac.GetSoundIdByName("Sowilo"))
        end
        ItemOverlay.Show(Isaac.GetGiantBookIdByName("Sowilo (HC)"), 3, player)
    end
    --mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnSowiloUse, mod.Meteors.SOWILO)


    --Gebo Compatibility
    function mod:OnOgGeboUse(card, player, flags)
        for i, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
            if (slot.Variant == mod.EntityInf[mod.Entity.Telescope].VAR and slot.SubType == mod.EntityInf[mod.Entity.Telescope].SUB) or
            (slot.Variant == mod.EntityInf[mod.Entity.Titan].VAR and slot.SubType == mod.EntityInf[mod.Entity.Titan].SUB) then
                slot:GetData().Uses = slot:GetData().Uses + 5
                slot:GetData().Player = player
            end
        end
        for i, slot in ipairs(mod:FindByTypeMod(mod.Entity.FishingRod, mod.EntityInf[mod.Entity.FishingRod].VAR+1)) do
            if (slot.Variant == mod.EntityInf[mod.Entity.FishingRod].VAR+1 and slot.SubType == mod.EntityInf[mod.Entity.FishingRod].SUB) then
                for i=0,4 do
                    mod:scheduleForUpdate(function()
                        if (slot and slot~=-1) and player then
                            mod:BoxStore(slot, player, mod.RodHearts.RED)
                        end
                    end, 25*i)
                end
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnOgGeboUse, Isaac.GetCardIdByName("Gebo"))
end

function mod:SpawnAllMeteors()
    --for i=mod.Meteors.HAGALAZ, mod.Meteors.SOWILO do
        --Isaac.ExecuteCommand("spawn 5.300."..tostring(i))
    --end
    local index = 0
    for subType=Card.RUNE_HAGALAZ, Card.RUNE_ALGIZ do
        mod:OnMeteorRuneSpawn(nil, PickupVariant.PICKUP_TAROTCARD, subType, index)
        index = index + 1
    end
    if AntibirthRunes then
        for subType=Isaac.GetCardIdByName("Gebo"), Isaac.GetCardIdByName("Ingwaz") do
            mod:OnMeteorRuneSpawn(nil, PickupVariant.PICKUP_TAROTCARD, subType, index)
            index = index + 1
        end
    end
end
--[[
function za()
    local c=0
    for i=1, 10000 do
        local newroomdata = RoomConfigHolder.GetRandomRoom (mod:RandomInt(1,99999), false, StbType.SPECIAL_ROOMS, RoomType.ROOM_DICE, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 20, mod.normalDoors)
        --local newroomdata = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, 20, i, 1)
        --print(i, newroomdata)
        if newroomdata.Variant > 8500 then
            c = c+1
        end
    end
    print(c)
end
]]--

--effect
function mod:MeteorRuneEffectUpdate(entity)
    if entity.SubType == mod.EntityInf[mod.Entity.MeteorRune].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if data.Init == nil then
            data.Init = true
            data.Id = data.Id or 0

            sprite:Play(tostring(data.Id),true)

            local rune = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, data.Id+mod.Meteors.HAGALAZ, entity.Position, Vector.Zero, nil)
            rune:AddFreeze(EntityRef(entity), 30)
        end

        if sprite:IsFinished() then
            --Explosion:
            game:BombExplosionEffects(entity.Position, 100, TearFlags.TEAR_NORMAL, mod.Colors.ice, nil, 0.67)

            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.MeteorRuneEffectUpdate, mod.EntityInf[mod.Entity.MeteorRune].VAR)


--spawning
function mod:OnMeteorRuneSpawn(pickup, variant, subType, gridIndex)
    
    local itemConfig = Isaac:GetItemConfig():GetCard(subType)
    if itemConfig:IsRune() and not (subType == Card.RUNE_BLANK or subType == Card.RUNE_BLACK or subType == Card.RUNE_SHARD) and not mod:IsMeteoricRune(subType) then

        local id = 0
        if Card.RUNE_HAGALAZ <= subType and subType <= Card.RUNE_ALGIZ then
            id = subType - Card.RUNE_HAGALAZ
        elseif subType == Isaac.GetCardIdByName("Gebo") then
            id = mod.Meteors.GEBO - mod.Meteors.HAGALAZ
        elseif subType == Isaac.GetCardIdByName("Kenaz") then
            id = mod.Meteors.KENAZ - mod.Meteors.HAGALAZ
        elseif subType == Isaac.GetCardIdByName("Fehu") then
            id = mod.Meteors.FEHU - mod.Meteors.HAGALAZ
        elseif subType == Isaac.GetCardIdByName("Othala") then
            id = mod.Meteors.OTHALA - mod.Meteors.HAGALAZ
        elseif subType == Isaac.GetCardIdByName("Ingwaz") then
            id = mod.Meteors.INGWAZ - mod.Meteors.HAGALAZ
        elseif subType == Isaac.GetCardIdByName("Sowilo") then
            id = mod.Meteors.SOWILO - mod.Meteors.HAGALAZ
        end

        local position = Vector.Zero
        if gridIndex then
            position = game:GetRoom():GetGridPosition(gridIndex)
        elseif pickup then
            position = pickup.Position
            pickup:Remove()
        end

        local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, position, Vector.Zero, pickup):ToEffect()
        if target then
            target:SetColor(Color(0.5,1,1,1,0,0,0.5), -1, 1, true, true)
            target.Timeout = 30
            sfx:Play(SoundEffect.SOUND_DOGMA_LIGHT_APPEAR, 0.5, 0, false, 3)

            local meteor = mod:SpawnEntity(mod.Entity.MeteorRune, target.Position, Vector.Zero, nil)
            meteor:GetData().Id = id
            meteor:AddFreeze(EntityRef(target), target.Timeout)
        end

        return {EntityType.ENTITY_EFFECT-1, EffectVariant.TINY_BUG, 0}
    end
end
--mod:AddSillyCallback(mod.ModCallbacks.ON_PICKUP_CREATION, mod.OnMeteorRuneSpawn, {"meteor_grid (HC)", mod.MeteorsConsts.METEOR_CHANCE, PickupVariant.PICKUP_TAROTCARD, -1, -1})

