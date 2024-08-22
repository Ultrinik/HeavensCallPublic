local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local music = MusicManager()

mod.SFX = {
    WoodStep = Isaac.GetSoundIdByName("WoodStep"),
    GrassStep = Isaac.GetSoundIdByName("GrassStep"),
    LockedBox = Isaac.GetSoundIdByName("LockedBox"),
    Crack = Isaac.GetSoundIdByName("Crack"),
    Broke = Isaac.GetSoundIdByName("Broke"),
    StaticScream = Isaac.GetSoundIdByName("StaticScream"),
    AngryStaticScream = Isaac.GetSoundIdByName("AngryStaticScream"),
    Generator = Isaac.GetSoundIdByName("GeneratorLoop"),
    ChainBreak = Isaac.GetSoundIdByName("ChainBreak"),
    EffigyCompleted = Isaac.GetSoundIdByName("EffigyCompleted"),
    ThroughDoor = Isaac.GetSoundIdByName("ThroughDoor"),
    CorpsePush = Isaac.GetSoundIdByName("CorpsePush"),
    GlitchGaper = Isaac.GetSoundIdByName("GlitchGaper"),
    LightsOff = Isaac.GetSoundIdByName("LightsOff"),
    CorrectPassword = Isaac.GetSoundIdByName("CorrectPassword"),
    PasswordAlarm = Isaac.GetSoundIdByName("PasswordAlarm"),
    PasswordClick = Isaac.GetSoundIdByName("PasswordClick"),
    Purring = Isaac.GetSoundIdByName("Purring"),
    Sink = Isaac.GetSoundIdByName("Sink"),
    EvilClock = Isaac.GetSoundIdByName("EvilClock"),
    ClockTick = Isaac.GetSoundIdByName("ClockTick"),
    SecretRoom = Isaac.GetSoundIdByName("SecretRoom"),
    TrainBells = Isaac.GetSoundIdByName("TrainBells"),
    Supernova = Isaac.GetSoundIdByName("Supernova"),
    Effigy = Isaac.GetSoundIdByName("effigy1"),
}

mod.MUSIC = {
    evERR = Isaac.GetMusicIdByName("evERR"),
}

mod.EverchangerFlags = {
    inChallenge = false,
    darkness = false,

    position0 = {[0]=0,[1]=0,[2]=0},
    position1 = {[0]=0,[1]=0,[2]=0},
    position2 = {[0]=0,[1]=0,[2]=0},
    position3 = {[0]=0,[1]=0,[2]=0},
    position4 = {[0]=0,[1]=0,[2]=0},
    position5 = {[0]=0,[1]=0,[2]=0},
    position6 = {[0]=0,[1]=0,[2]=0},
    position7 = {[0]=0,[1]=0,[2]=0},
    position8 = {[0]=0,[1]=0,[2]=0},
    position9 = {[0]=0,[1]=0,[2]=0},

    hasSackBeenTaken = false,

    safeIndexs = {},

    ogMusic = nil,

    darknessDebug = true,
    enabledHUD = false,
    enabledErrant = true,

    enabledDarkness = 0,
    enabledStatic = 0,
    enabledZoom = 0,

    inWaterRoom = false,

    errantMoving = false,
    jumpscareFlag = false,
    achievementFlag = false,
    deleteInfinite = false,

    alarmColor = 0
}

local flags = mod.EverchangerFlags

include("scripts.errantchallenge.everchanger")
include("scripts.errantchallenge.player")
include("scripts.errantchallenge.levelgen")
include("scripts.errantchallenge.entities")
include("scripts.errantchallenge.worldmap")
include("scripts.errantchallenge.furniture")

function mod:EverchangerCallbacks(init)

    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.KeepMusicGoing)
    mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.EverchangerPlayerUpdate)
    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnEverchangerNewRoom)
    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.EverchangerMainUpdate)
    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.EverchangerMainRender)
    mod:RemoveCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.EverchangerTrinketCollisionTunel, PickupVariant.PICKUP_TRINKET)
    mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.EverchangerPlayerDamage, EntityType.ENTITY_PLAYER)
    mod:RemoveCallback(ModCallbacks.MC_NPC_UPDATE, mod.ShopkeeperUpdate, EntityType.ENTITY_SHOPKEEPER)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.AntiGoldBomb, PickupVariant.PICKUP_BOMB)
    mod:RemoveCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.EverchangerBombUpdate, BombVariant.BOMB_NORMAL)
    mod:RemoveCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.EverchangerPickupInit)

    if init then
		mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.KeepMusicGoing)
		mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.EverchangerPlayerUpdate)
		mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnEverchangerNewRoom)
		mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.EverchangerMainUpdate)
		mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.EverchangerMainRender)
        mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.EverchangerTrinketCollisionTunel, PickupVariant.PICKUP_TRINKET)
        mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.EverchangerPlayerDamage, EntityType.ENTITY_PLAYER)
        mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ShopkeeperUpdate, EntityType.ENTITY_SHOPKEEPER)
        mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.AntiGoldBomb, PickupVariant.PICKUP_BOMB)
        mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.EverchangerBombUpdate, BombVariant.BOMB_NORMAL)
        mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.EverchangerPickupInit)
    end
end

function mod:EverchangerStartCheck(isContinue)
    flags.errantMoving = false
    flags.currentPath = nil
    flags.everchangerCurrentIdx = nil
    flags.distance = 9999
    flags.inBattle = false
    flags.hasSackBeenTaken = false
    flags.darknessOther = false
    flags.oxygen = 100
    flags.endRoomOpen = false
    flags.alarmColor = 0
    flags.inWaterRoom = false

    flags.jumpscareFlag = false
    flags.achievementFlag = false
    flags.deleteInfinite = false

    mod.CirclesStates = {}
    mod.furnitureQueue = {}
    mod.ClockPassword = {}

    if Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[HC] Escape the Everchanger") then
        flags.inChallenge = true
        flags.isHunting = false
        flags.darknessOther = true
        flags.HasEverchangeBeenInitialized = false
        
        mod.EverchangerItemCharges = {
            [mod.EverchangerTrinkets.unicorn] = true,
            [mod.EverchangerTrinkets.yuckheart] = true,
            [mod.EverchangerTrinkets.pause] = true,
            [mod.EverchangerTrinkets.bible] = true,
        }

        if flags.darknessDebug then
            flags.enabledDarkness = 1
            flags.enabledStatic = 1
            flags.enabledZoom = 1
        end

        if not flags.ogMusic then
            flags.ogMusic = Options.MusicVolume
            Options.MusicVolume = 1
        end

        if not isContinue then
            mod:OnEverchangerStart()
        end

        game:GetHUD():SetVisible(flags.enabledHUD)
        

        mod:EverchangerCallbacks(true)

    else

        mod:EverchangerCallbacks(false)

        if flags.inChallenge then
            local player = Isaac.GetPlayer(0)
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
            player:EvaluateItems()
        end

        flags.inChallenge = false
        flags.enabledDarkness = 0
        flags.isHunting = false

    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.EverchangerStartCheck)

function mod:EverchangerMainUpdate()

    local player = Isaac.GetPlayer(0)
    flags.time = Isaac.GetFrameCount()

    if flags.isHunting then
        mod:EverchangerWorldUpdate()

    end

    if flags.inBattle and flags.enemiesSpawned then
        local fakers = Isaac.FindByType(mod.EntityFakerData.ID, mod.EntityFakerData.VAR, mod.EntityFakerData.SUB)
        if #fakers == 0 then
            mod:FinishEverchangerBattle(nil, false)
        end
    end
    
    if flags.inWaterRoom then
        flags.oxygen = math.max(0, flags.oxygen-0.5)
        if flags.oxygen <= 0 then
            player:TakeDamage(1, 0, EntityRef(player), 0)
        end

        
        if flags.oxygen > 0 and (player.Velocity:Length() > 0.1 and player.FrameCount % 6 == 0) then
            local bubble = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, player.Position + Vector(0,-5), Vector(0,-10), nil):ToEffect()
            bubble.DepthOffset = 500
            local bubbleSprite = bubble:GetSprite()
            bubbleSprite:Load("gfx/effect_UnderwaterBubble.anm2", true)
            bubbleSprite:Play("Poof", true)
            bubbleSprite.Scale = Vector.One*(rng:RandomFloat()*0.3 + 0.1)
            bubbleSprite.PlaybackSpeed = 0.1
        end
    else
        flags.oxygen = math.min(100, flags.oxygen+1)
    end

    if player:GetSprite():GetAnimation() == "Death" and player:GetSprite():GetFrame() == 1 then
        local corpse = Isaac.Spawn(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB, player.Position, Vector.Zero, nil)
        corpse.Visible = false
    end

    if sfx:IsPlaying(mod.SFX.PasswordAlarm) then
        flags.alarmColor = math.abs(math.sin(10 * player.FrameCount * math.pi / 180))
    else
        flags.alarmColor = 0
    end
end
function mod:EverchangerMainRender()
    if flags.jumpscareFlag then
        if not flags.jumpscareSprite then
            flags.jumpscareSprite = Sprite()
            sprite = flags.jumpscareSprite

            sprite:Load("gfx/screen_Jumpscare.anm2", true)
            sprite:Play("Idle", true)
        end
        sprite = flags.jumpscareSprite
        if sprite then
            local w = Isaac.GetScreenWidth()
            local h = Isaac.GetScreenHeight()
            local position = Vector(w/2, h/2)

            sprite:Render(position)
            sprite:Update()
            
            flags.enabledDarkness = 0
            flags.enabledStatic = 0
            flags.enabledZoom = 0

            if sprite:IsEventTriggered("BaseEnd") or sprite:IsFinished() then
                flags.jumpscareFlag = false
                flags.jumpscareSprite = nil
            
                flags.enabledDarkness = 1
                flags.enabledStatic = 1
                flags.enabledZoom = 1
                
                Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_SAD_ONION)
                Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_CRICKETS_HEAD)
            end
        end
    end

    if flags.achievementFlag then
        if not flags.achievementSprite then
            flags.achievementSprite = Sprite()
            sprite = flags.achievementSprite

            sprite:Load("gfx/ui/achievement/screen_EverchangerAchievement.anm2", true)
            sprite:Play("Appear", true)
            
        end
        sprite = flags.achievementSprite
        if sprite then
            local w = Isaac.GetScreenWidth()
            local h = Isaac.GetScreenHeight()
            local position = Vector(w/2, h/2)

            sprite:Render(position)
            sprite:Update()

            if sprite:IsFinished() and #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY) == 0 then
                mod.savedata.challenge_Everchanger = true
                game:End(3)
            end
        end
    end

    if flags.gameOverflag then
        if not flags.gameOverSprite then
            flags.gameOverSprite = Sprite()
            sprite = flags.gameOverSprite

            sprite:Load("gfx/screen_GameOver.anm2", true)

            if Isaac.GetPlayer(0):HasCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW) then
                sprite:Play("Idle1", true)
            else
                sprite:Play("Idle2", true)
            end
            sfx:Play(SoundEffect.SOUND_STATIC)
            
        end

        sprite = flags.gameOverSprite
        if sprite then
            local w = Isaac.GetScreenWidth()
            local h = Isaac.GetScreenHeight()
            local position = Vector(w/2, h/2)

            sprite:Render(position)
            sprite:Update()

            flags.currentRoomprogress = 0
            flags.distance = 9999

            flags.enabledDarkness = 0
            flags.enabledStatic = 0
            flags.enabledZoom = 0

            Isaac.GetPlayer(0).ControlsCooldown = 10

            if sprite:IsFinished() then
                flags.gameOverflag = false

                if flags.darknessDebug then
                    flags.enabledDarkness = 1
                    flags.enabledStatic = 1
                    flags.enabledZoom = 1
                end

                flags.gameOverSprite = nil
                sfx:Play(SoundEffect.SOUND_STATIC)
            end
        end
    end
    
    if flags.inWaterRoom then
        local player = Isaac.GetPlayer(0)

        if not flags.oxygenSprite then
            flags.oxygenSprite = Sprite()
            flags.oxygenSprite:Load("gfx/effect_OxygenBar.anm2", true)
            flags.oxygenSprite:Play("Charging", true)
        end

        if flags.oxygen < 100 then
            local sprite = flags.oxygenSprite
            local frame = math.floor(flags.oxygen)
            sprite:SetFrame(frame)

            local position = Isaac.WorldToScreen(player.Position + Vector(-30, -30))
            sprite:Render(position)
        end
    end

    if flags.inMirror then
        local centerPos = game:GetRoom():GetCenterPos() + Vector(0,-20)
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if (entity.Type == EntityType.ENTITY_EFFECT and (entity.Variant == EffectVariant.WISP or (false and entity.Variant == EffectVariant.WOMB_TELEPORT))) then
                
                local sprite = entity:GetSprite()
                
                local entityPos = entity.Position
                local mirrorPos = Vector(entityPos.X, centerPos.Y - (entityPos.Y - centerPos.Y))

                local position = Isaac.WorldToScreen(mirrorPos)
                
                sprite:Render(position)
            end
        end
    end
end

function mod:OnEverchangerStart()
    game:ShowHallucination(1, BackdropType.PLANETARIUM)
    mod.ModFlags.forcedPitchBlack = false
    mod:scheduleForUpdate(function()
        mod.ModFlags.forcedPitchBlack = false

        if flags.enabledHUD then
            Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_MIND)
            Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_SKELETON_KEY)
            Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_PYRO)
        end
    end,15)

    Isaac.GetPlayer(0):AddBombs(-1)

    mod:scheduleForUpdate(function()
        Isaac.ExecuteCommand("stage 9")

        mod:InitEverchangerFloor()
        
        mod:scheduleForUpdate(function()

            mod:scheduleForUpdate(function()
                mod.ModFlags.forcedPitchBlack = false
            end, 15)
    
            game:StartRoomTransition(game:GetLevel():GetCurrentRoomIndex(), Direction.UP, RoomTransitionAnim.FADE)
            Isaac.GetPlayer(0).Position = game:GetRoom():GetCenterPos() + Vector(0,-80) 
        end, 1)
    end, 1)
end
function mod:InitEverchangerFloor()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()

	if not mod.everchangerroomdata then
		mod:InitializeRoomsData()
	end

	mod:scheduleForUpdate(function()
        --mod:GenerateEverchangerRoomsFromMapa(1)
        --mod:GenerateEverchangerRoomsFromMapa(2)
        --mod:GenerateEverchangerRoomsFromMapa(3)
        mod:GenerateEverchangerRoomsFromMapa(-1)
        mod:AddCustomEverchangerRooms()

        for i=0, 13*13-1 do
            local roomdesc = game:GetLevel():GetRoomByIdx(i)
            if roomdesc.Data then
                roomdesc.NoReward = true
            end
        end

		level:SetStage(0,0)
        
		game:ShowHallucination(0,BackdropType.HALLWAY)
		sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx
	end,1)
	
    level:DisableDevilRoom()

    for _, chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        chest:Remove()
    end

	--Door(s)
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
            door:TryUnlock(Isaac.GetPlayer(0), true)
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			if targetroomdesc and targetroomdesc.Data then
				local data = targetroomdesc.Data
				if data.Type == RoomType.ROOM_BOSS then
					targetroomdesc.Data = mod.everchangerroomdata[8500]
					table.insert(mod.minimaprooms, targetroomdesc.GridIndex)

                elseif data.Type == RoomType.ROOM_SHOP or data.Type == RoomType.ROOM_TREASURE then
					targetroomdesc.Data = mod.everchangerroomdata[8501]
					table.insert(mod.minimaprooms, targetroomdesc.GridIndex)
				end
			end
		end
	end

    --extra lives
    local player = Isaac.GetPlayer(0)
    player:AddCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
    player:AddCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
    
    mod:scheduleForUpdate(function()
        player.Position = room:GetCenterPos() + Vector(0,-150)
    end, 3)
    
    mod.ModFlags.forcedPitchBlack = true
    mod:scheduleForUpdate(function()
        mod.ModFlags.forcedPitchBlack = false
    end, 180, ModCallbacks.MC_POST_RENDER)

end

function mod:StartEverchangerEntity()
    if flags.enabledErrant then
        mod:InitializeNodes()
        flags.HasEverchangeBeenInitialized = true
        flags.isHunting = true
        flags.everchangerCurrentIdx = 63
        flags.roaming = true
        flags.errantMoving = true
        
        sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1.3)
    end
end
function mod:ResetEverchangerEntity(currentIdx)
    if flags.enabledErrant then

        currentIdx = currentIdx or game:GetLevel():GetCurrentRoomIndex()
        local x = currentIdx % 13
        local respawnIdx = 63
        if x > 5 then
            respawnIdx = 79
        end

        flags.isHunting = true
        flags.errantMoving = true
        flags.currentPath = nil
        flags.everchangerCurrentIdx = respawnIdx--mod:GetDeadend(flags.everchangerCurrentIdx, game:GetLevel():GetCurrentRoomIndex())
        flags.everchangerNextIdx = nil
        flags.everchangerPreviousIdx = nil
        flags.currentRoomprogress = 0
        flags.roaming = true
        flags.direction = nil
        flags.distance = 9999
    end
end


function mod:KeepMusicGoing()
	local level = game:GetLevel()
	if level:GetStage() == LevelStage.STAGE4_3 or level:GetStage() == LevelStage.STAGE_NULL then

        if not flags.inBattle then
            flags.distance = flags.distance or 999
            local volume = 100/flags.distance * 100
    
            if music:GetCurrentMusicID() ~= mod.MUSIC.evERR then
                music:Play(mod.MUSIC.evERR, volume)
            end
    
            music:VolumeSlide(volume, 1)

        else
            music:VolumeSlide(0, 1)
        end
        sfx:Stop (SoundEffect.SOUND_DEATH_CARD)
	end
end

function mod:OnEverchangerNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
    local roomidx = level:GetCurrentRoomIndex()
    local roomid = roomdesc.Data.Variant
    local player = Isaac.GetPlayer(0)

        
	if level:GetStage() == LevelStage.STAGE4_3 or level:GetStage() == LevelStage.STAGE_NULL then
        mod:EverchangerDoors()
        mod:SwitchGuppyState(rng:RandomFloat() > 0.9)

        player:GetData().Rainbow = 0

        sfx:Stop(mod.SFX.Generator)

        for index, entry in ipairs(mod.furnitureQueue) do
            if entry.IDX == roomidx then
                mod.furnitureQueue[index] = nil

                local position = entry.POSITION or ((entry.SLOT ~= nil) and ((room:GetDoor(entry.SLOT) and room:GetDoor(entry.SLOT).Position) or (room:GetDoor(entry.SLOT+4) and room:GetDoor(entry.SLOT+4).Position))) or room:GetCenterPos()
                position = position + (room:GetCenterPos() - position):Normalized()*80
                position = Isaac.GetFreeNearPosition(position, 10)

                local thing = Isaac.Spawn(mod.furnitureData.GENERATOR.ID, mod.furnitureData.GENERATOR.VAR, entry.SUB, position, Vector.Zero, nil)
            end
        end

        flags.enabledDarkness = 1
        --if mod:IsRoomElectrified() then
            --flags.enabledDarkness = 0
        --end

        game:ShowHallucination(0,BackdropType.HALLWAY)

        --mod:OnNewRoomFakeDoors()

        flags.position1 = {[0]=0,[1]=0,[2]=0}
        mod:GetSafeSpots(room)

        for i=1, 8 do
            flags["position"..tostring(i+1)] = {[0]=0,[1]=0,[2]=0}
        end
        for i, fire in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
            if i<=8 then
                flags["position"..tostring(i+1)] = {[0]=fire.Position.X,[1]=fire.Position.Y,[2]=100 + 30*math.sin( (flags.time or 0) )}
            else
                break
            end

        end

        if roomidx == level:GetStartingRoomIndex() or roomidx-13 == level:GetStartingRoomIndex() then
            --INSTRUCTIONS
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
            local sprite = effect:GetSprite()
            sprite:Load("gfx/backdrop/instructions.anm2", true)
            sprite:LoadGraphics()
            sprite:SetFrame("idle", player:GetCollectibleNum(CollectibleType.COLLECTIBLE_JUDAS_SHADOW))
            effect.DepthOffset = -5000
        elseif flags.enabledErrant and not flags.HasEverchangeBeenInitialized then
            mod:StartEverchangerEntity()
        end

        if roomid == 8500 then --Sol
            mod:SwitchGuppyState(false)
            flags.SolRoom = true
            flags.enabledDarkness = 0
            --flags.enabledZoom = 0

            --trinket
            if room:IsFirstVisit() then
                for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                    pickup = pickup:ToPickup()

                    if pickup.Variant == PickupVariant.PICKUP_TRINKET then
                        if pickup.SubType == TrinketType.TRINKET_PETRIFIED_POOP then
                            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.pandorasbox)
                            break
                        end
                    end
                end

                for i=1, 30 do
                    local wisp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, room:GetRandomPosition(0), Vector.Zero, nil)
                end
            end

            --wisps
            for i, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0)) do
                wisp:GetSprite().Color = Color(1,1,0,1,1.5,1.5,1.5)
            end

            --statue
            local statue = Isaac.FindByType(mod.furnitureData.STATUE.ID, mod.furnitureData.STATUE.VAR, mod.furnitureData.STATUE.SUB)[1]
            if not statue then
                statue = Isaac.Spawn(mod.furnitureData.STATUE.ID, mod.furnitureData.STATUE.VAR, mod.furnitureData.STATUE.SUB, room:GetCenterPos(), Vector.Zero, nil)
            end

            --background
            if true then

                game:ShowHallucination(0,BackdropType.ERROR_ROOM)

                --VOID
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
                local sprite = effect:GetSprite()
                sprite:Load("gfx/backdrop/sol/solarsky.anm2", true)
                sprite:LoadGraphics()
                sprite:Play("idle", true)
                effect.DepthOffset = -5000

                --STARS
                for i=1, 4 do

                    mod:scheduleForUpdate(function()
                        if not flags.SolRoom then return end
                        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
                        effect:SetColor(Color(0, 0, 0, 1), 60, 1, true, true)
                        local sprite = effect:GetSprite()
                        sprite.Scale = Vector.One
                        sprite:Load("gfx/backdrop/sol/solarsky.anm2", true)
                        for j=0, 3 do
                            sprite:ReplaceSpritesheet(j, "gfx/backdrop/sol/stars"..tostring(i)..".png")
                        end
                        sprite:LoadGraphics()
                        sprite:Play("idle")

                        sprite.PlaybackSpeed = (1 + 1.5*i)
                        sprite.PlaybackSpeed = sprite.PlaybackSpeed*sprite.PlaybackSpeed
                        sprite.PlaybackSpeed = sprite.PlaybackSpeed*0.0125
                        --sprite.PlaybackSpeed = 5

                        effect.DepthOffset = -5000 + i*10
                    end, i*5)
                end

                --planets
                mod:scheduleForUpdate(function()
                    if not flags.SolRoom then return end
                    if true then
                        local count = 0
                        local totalCount = 0
                        
                        if false then--force them all
                            for tipo = 0, 8 do
                                mod.CirclesStates[tipo] = true
                                --mod.CirclesStates[tipo] = rng:RandomFloat() < 0.5
                            end
                        end
                        for tipo = 0, 8 do
                            if mod.CirclesStates[tipo] then totalCount = totalCount + 1 end
                        end
                        for tipo = 0, 8 do
                            if mod.CirclesStates[tipo] then
                                local planet = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB + 6, room:GetCenterPos(), Vector.Zero, nil)
                                planet:SetColor(Color(0, 0, 0, 1), 30, 1, true, false)
                                local data = planet:GetData()
                                data.Tipo = tipo

                                planet.Parent = statue
                                data.orbitIndex = count
                                data.orbitTotal = totalCount
                                data.orbitSpin = 1
                                data.orbitSpeed = 0.5
                                data.orbitDistance = 200

                                count = count + 1
                            end
                        end
                    end
                end, 30)
                
                --GLASS
                if not flags.SolRoom then return end
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
                effect.SortingLayer = SortingLayer.SORTING_DOOR
                local sprite = effect:GetSprite()
                sprite.Scale = Vector(0.87, 0.78)
                sprite:Load("gfx/backdrop/solarfloor.anm2", true)
                sprite:LoadGraphics()
                sprite:Play("idle", true)
                effect.DepthOffset = -3000
            end

        else
            flags.SolRoom = false
            if flags.darknessDebug then
                flags.enabledZoom = 1
            end
        end

        if roomid == 8505 then --Neptune
            flags.inWaterRoom = true
            mod:SwitchGuppyState(true)

            --trinket
            if room:IsFirstVisit() then
                for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                    pickup = pickup:ToPickup()

                    if pickup.Variant == PickupVariant.PICKUP_TRINKET then
                        if pickup.SubType == TrinketType.TRINKET_PETRIFIED_POOP then
                            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.fish)
                        elseif pickup.SubType == TrinketType.TRINKET_SWALLOWED_PENNY then
                            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.bible)
                        end
                    end
                end
            end

            local position = Vector(160, 600)
            local circle = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+5, position, Vector.Zero, nil)

            local grid = room:GetGridEntity(24)
            if grid and grid:GetType() == GridEntityType.GRID_TELEPORTER then

                local flag = true
                for i, corpse in ipairs(Isaac.FindByType(mod.furnitureData.CORPSE.ID, mod.furnitureData.CORPSE.VAR, mod.furnitureData.CORPSE.SUB)) do
                    local position = corpse.Position
                    if not (position.X == 160 and position.Y == 680) then
                        flag = false
                    end
                end
                if flag then
                    grid.CollisionClass = GridCollisionClass.COLLISION_PIT
                    grid:GetSprite().Color = Color(1,1,1,0)
                end
            end
            local grid = room:GetGridEntity(211)
            if grid and grid:GetType() == GridEntityType.GRID_TELEPORTER then
                grid:GetSprite().Color = Color(0,1,1,1)
            end
            
            if player:HasTrinket(mod.EverchangerTrinkets.redkey) then
                player:TryRemoveTrinket(mod.EverchangerTrinkets.redkey)
                local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_STRANGE_KEY, player.Position, Vector.Zero, entity)
            end

        else
            flags.inWaterRoom = false
        end

        if roomid == 8518 then --pre neptune
            --WARNING
            local position = Vector(160, 240)
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, position, Vector.Zero, nil) --Some inert thing thats in the floor
            effect.SortingLayer = SortingLayer.SORTING_DOOR
            effect.DepthOffset = 15
            local sprite = effect:GetSprite()
            sprite.Scale = Vector.One*0.85
            sprite:Load("gfx/backdrop/everchanger_neptune.anm2", true)
            sprite:Play("idle", true)
        end

        if roomid == 8504 then --Venus
            flags.enabledDarkness = 0

            --trinket
            if room:IsFirstVisit() then
                for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                    pickup = pickup:ToPickup()

                    if pickup.Variant == PickupVariant.PICKUP_TRINKET then
                        if pickup.SubType == TrinketType.TRINKET_PETRIFIED_POOP then
                            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.tech)
                            break
                        end
                    end
                end
            end
            
        end

        if roomid == 8506 then --Shop
            if room:IsFirstVisit() then
                for i, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                    pickup = pickup:ToPickup()
                    pickup.ShopItemId = i
                    pickup.AutoUpdatePrice = false

                    if pickup.Variant == PickupVariant.PICKUP_BOMB then
                        pickup.Price = 1
                    elseif pickup.Variant == PickupVariant.PICKUP_KEY then
                        pickup.Price = 1
                    elseif pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                        if pickup.SubType == CollectibleType.COLLECTIBLE_PAUSE then
                            pickup.Price = 5
                        elseif pickup.SubType == CollectibleType.COLLECTIBLE_LEMON_MISHAP then
                            pickup.Price = 5
                        else
                            pickup.Price = 10
                        end
                    end
                end

            end
            for i, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LEMON_MISHAP)) do
                pickup:Update()
                pickup:Update()

                local sprite = pickup:GetSprite()
                sprite:ReplaceSpritesheet(1, "gfx/items/trinkets/trinket_plunger.png")
                sprite:LoadGraphics()
            end
        end
        
        if roomid == 8509 or roomid == 8510 then --Station; 9 -> ; 10 v
            local gridSize = room:GetGridSize()
            for i=0, gridSize do
                local grid = room:GetGridEntity(i)
                if grid and grid:GetType() == GridEntityType.GRID_ROCKB then
                    local sprite = grid:GetSprite()
        
                    sprite:Load("gfx/grid/grid_bismuth.anm2", true)
                    sprite:LoadGraphics()
                    sprite:Play("black", true)
                    sprite:SetFrame(rng:RandomInt(3))
                end
            end

            local cart = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+9, room:GetCenterPos(), Vector.Zero, nil)
            cart:GetData().Inactive = 15

            if roomid == 8509 then
                local position = room:GetDoorSlotPosition(DoorSlot.RIGHT0)
                local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORMWOOD_HOLE, 0, position, Vector.Zero, nil)
                local sprite = crack:GetSprite()
                sprite:ReplaceSpritesheet(0, "gfx/effects/mercury_hole.png")
                sprite:LoadGraphics()
                sprite.Rotation = 180

                cart:GetSprite():Play("IdleHorizontal", true)
            else
                local position = room:GetDoorSlotPosition(DoorSlot.DOWN0)
                local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORMWOOD_HOLE, 0, position, Vector.Zero, nil)
                local sprite = crack:GetSprite()
                sprite:ReplaceSpritesheet(0, "gfx/effects/mercury_hole.png")
                sprite:LoadGraphics()
                sprite.Rotation = -90
                
                cart:GetSprite():Play("IdleVertical", true)

                for i, trinket in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.bible)) do
                    trinket.Position = room:GetCenterPos() + Vector(50, -50)
                end
            end

            if flags.FromMinecart then
                flags.FromMinecart = false

                player.Position = room:GetCenterPos()
                player.Visible = true
                player.ControlsCooldown = 0

                sfx:Stop(mod.SFX.TrainBells)
                sfx:Play(mod.SFX.ThroughDoor, 50)
            end
        end

        if roomid == 8508 then --Endroom
            mod:SwitchGuppyState(false, true)
            mod:CleanDiceRoom()

            --trinket
            if room:IsFirstVisit() then
                for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                    pickup = pickup:ToPickup()

                    if pickup.Variant == PickupVariant.PICKUP_TRINKET then
                        if pickup.SubType == TrinketType.TRINKET_PETRIFIED_POOP then
                            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.EverchangerTrinkets.certificate)
                            break
                        end
                    end
                end
            end

            if true then

                game:ShowHallucination(0,BackdropType.ERROR_ROOM)

                --VOID
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
                local sprite = effect:GetSprite()
                sprite.Color = Color(1,1,1,1)
                sprite:Load("gfx/backdrop/eyeoftheuniverse.anm2", true)
                sprite:LoadGraphics()
                sprite:Play("idle", true)
                effect.DepthOffset = -5000

                for i=1, 20 do
                    local position = room:GetRandomPosition(0)
                    local corpse = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+2, position, Vector.Zero, nil)
                end

                --WALLS
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
                local sprite = effect:GetSprite()
                sprite.Color = Color(1,1,1,1)
                sprite:Load("gfx/backdrop/endwalls.anm2", true)
                sprite:LoadGraphics()
                sprite:Play("idle", true)
                effect.DepthOffset = -4000
            end
        end

        if roomid == 8507 then --Guppy
            for i, keeper in ipairs(Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER)) do
                keeper:GetData().SackHead = true
            end

            if not player:HasCollectible(mod.EverchangerTrinkets.guppy) then
                player:AddCollectible(mod.EverchangerTrinkets.guppy)
                player:CheckFamiliar(FamiliarVariant.LEECH, 1, player:GetCollectibleRNG(mod.EverchangerTrinkets.guppy), Isaac.GetItemConfig():GetCollectible(mod.EverchangerTrinkets.guppy), 160)
        
            end
            
        end

        if roomid == 8536 then --Passcode
            local counter = 0
            local tipos = {0,1,2,3,4,5,6,7,8,9}
            tipos = mod:Shuffle(tipos)
            for j=-40, 40, 80 do
                for i=-80*2, 80*2, 80 do
                    local position = Vector(i, j) + room:GetCenterPos() + Vector(-45, 0)
                    local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+1, position, Vector.Zero, nil)
                    button:GetData().Type = tipos[counter+1]
                    counter = counter + 1
                end
            end
        end
        
        if roomid == 8555 then --Battle
            mod:SwitchGuppyState(true)

            if true then

                game:ShowHallucination(0,BackdropType.ERROR_ROOM)

                --VOID
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos(), Vector.Zero, nil) --Some inert thing thats in the floor
                local sprite = effect:GetSprite()
                sprite.Scale = Vector.One*1.5
                sprite.Color = Color(1,1,1,1)
                sprite:Load("gfx/backdrop/eyeoftheuniverse.anm2", true)
                sprite:LoadGraphics()
                sprite:Play("idle", true)
                effect.DepthOffset = -5000
            end
        end

        if roomid == 8534 then --Mirror
            flags.inMirror = true
            if true then

                --VOID
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, room:GetCenterPos() + Vector(0,-20), Vector.Zero, nil) --Some inert thing thats in the floor
                effect.SortingLayer = SortingLayer.SORTING_NORMAL
                effect.DepthOffset = 15
                local sprite = effect:GetSprite()
                sprite:Load("gfx/backdrop/glassfloor.anm2", true)
                sprite:ReplaceSpritesheet(0, "gfx/backdrop/mirror.png")
                sprite:LoadGraphics()
                sprite:Play("idle", true)

            end

            local position = Vector.Zero
            if not mod.CirclesStates[8] then
                local mirrorPlayer = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+3, position, Vector.Zero, nil)
                mirrorPlayer.Parent = player
            end
            local guppy = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEECH, 160)[1]
            if guppy then
                local mirroGuppy = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+4, position, Vector.Zero, nil)
                mirroGuppy.Parent = guppy
            end
                    
        else
            flags.inMirror = false
        end

        if roomid == 8515 then --Terra
            if flags.deleteInfinite then
                room:RemoveDoor(DoorSlot.LEFT0)
            end
        end

        if roomid == 8540 then --Infinite

            local gridSize = room:GetGridSize()
            for i=0, gridSize-1 do
                local grid = room:GetGridEntity(i)
                if grid and grid:GetType() == GridEntityType.GRID_ROCK then
                    grid.State = 2
                    grid:SetType(GridEntityType.GRID_NULL)
                    grid:Destroy(true)
                end
            end

            for i=1, 20 do
                local index = mod:RandomInt(0, gridSize-1)
                if not (60 <= index and index <= 74) then
                    room:SpawnGridEntity(index, GridEntityType.GRID_ROCK,  mod:RandomInt(0, 3), mod:RandomInt(1, 420), 0)
                    local grid = room:GetGridEntity(index)
                    local sprite = grid:GetSprite()
                    sprite:ReplaceSpritesheet(0, "gfx/grid/quantum_rock.png")
                    sprite:LoadGraphics()
                end
            end

            if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY) == 0 then
                flags.deleteInfinite = true
            end
        end
        if roomidx == 78 then
            game:StartRoomTransition(79, Direction.LEFT, RoomTransitionAnim.WALK)
        end

        --saturn puzzle
        if true then
            local centerPos = room:GetCenterPos()
            
            if roomid == 8533 then --clock
                local clock = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+8, centerPos, Vector.Zero, nil)
                if flags.endRoomOpen then
                    --Door(s)
                    for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                        local door = room:GetDoor(i)
                        if door and door:GetSprite():GetAnimation() == "Hidden" then
                            door:TryBlowOpen(true, player)
                        end
                    end
                end

            elseif roomid == 8525 then -- 5
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 5
            elseif roomid == 8526 then -- 4
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 4
            elseif roomid == 8527 then -- 3
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 3
            elseif roomid == 8528 then -- 6
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 6
            elseif roomid == 8529 then -- 1
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 1
            elseif roomid == 8530 then -- 8
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 8
            elseif roomid == 8531 then -- 7
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 7
            elseif roomid == 8532 then -- 2
                local button = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB+7, centerPos, Vector.Zero, nil)
                button:GetData().Index = 2
            end
        end
        
        if roomidx == 102 then --Evil spikeroom
            local walls = {[59] = true, [60] = true, [74] = true, [75] = true}
            local safe = {[50] = true, [65] = true, [80] = true, [54] = true, [69] = true, [84] = true, [66] = true, [67] = true, [68] = true, [46]=true, [61]=true, [76]=true, [58]=true, [73]=true, [88]=true}
            for i=46, 88 do
                if not walls[i] then
                    local position = room:GetGridPosition(i)
                    local spike = mod:SpawnEntity(mod.Entity.Spike, position, Vector.Zero, nil)
                    if safe[i] then
                        spike:GetData().Disabled = true
                    end
                    spike:GetSprite():Play("Low", true)
                end
            end
        end

        for tipo, entry in pairs(mod.CirclesData) do
            if entry.IDX == roomidx then
                local position = entry.POSITION

                local circle = Isaac.Spawn(mod.EntityCircleData.ID, mod.EntityCircleData.VAR, mod.EntityCircleData.SUB, position, Vector.Zero, nil)
                circle:GetData().Type = tipo
            end
        end
    end

end

function mod:GetSafeSpots(room)
    flags.safeIndexs = {}
    for _, dirt in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH)) do
        dirt.Visible = false

        local pos = dirt.Position
        local idx = room:GetGridIndex(pos)
        table.insert(flags.safeIndexs, idx)
    end
end

function mod:TriggerEverchangerBattle()
    local room = game:GetRoom()

    flags.jumpscareFlag = true

    flags.errantMoving = false
    flags.distance = 9999


    flags.lastRoom = game:GetLevel():GetCurrentRoomIndex()
    Isaac.ExecuteCommand("goto s.blackmarket.8555")
    flags.inBattle = true

    sfx:Play(mod.SFX.StaticScream, 50)

    Isaac.GetPlayer(0):PlayExtraAnimation("Appear")

    mod:scheduleForUpdate(function()
        local ever = Isaac.Spawn(Isaac.GetEntityTypeByName(" Everchanger "), Isaac.GetEntityVariantByName(" Everchanger "), 0, room:GetCenterPos(), Vector.Zero, nil)
        ever:GetData().State = mod.ECState.BATTLE

    end, 22)

    mod:scheduleForUpdate(function()
        mod:SpawnEnemyWave(6)
    end, 30*2)
    mod:scheduleForUpdate(function()
        mod:SpawnEnemyWave(5)
    end, 30*7)
    mod:scheduleForUpdate(function()
        mod:SpawnEnemyWave(4)
    end, 30*14)
    mod:scheduleForUpdate(function()
        mod:SpawnEnemyWave(3)
    end, 30*23)
end

function mod:FinishEverchangerBattle(forceStart, lost)
    local player = Isaac.GetPlayer(0)

    flags.inBattle = false
    flags.enemiesSpawned = false

    mod.ModFlags.forcedPitchBlack = true
    sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1.3)
    mod:scheduleForUpdate(function()
        mod.ModFlags.forcedPitchBlack = false
    end, 10)
    
    player:RemoveCollectible(CollectibleType.COLLECTIBLE_SAD_ONION)
    player:RemoveCollectible(CollectibleType.COLLECTIBLE_CRICKETS_HEAD)

    if flags.lastRoom and not forceStart then
        game:StartRoomTransition(flags.lastRoom, Direction.NO_DIRECTION, RoomTransitionAnim.PIXELATION)
    else
        game:StartRoomTransition(game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, RoomTransitionAnim.FADE)
        mod:scheduleForUpdate(function()
            player.Position = game:GetRoom():GetCenterPos()+Vector(0,60)
        end, 2)
    end
    mod:ResetEverchangerEntity(flags.lastRoom)

    local t1 = player:GetTrinket(0)
    local t2 = player:GetTrinket(1)
    local c1 = t1>0 and mod.EverchangerItemCharges[t1] == false
    local c2 = t2>0 and mod.EverchangerItemCharges[t2] == false
    if (not lost) and ( c1 or c2 ) then
        
        mod:scheduleForUpdate(function()
            sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 2)
            local player = Isaac.GetPlayer(0)
			local battery = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, player.Position + Vector(0,10), Vector.Zero, player)
			battery.DepthOffset = 200
        end, 30)

        if c1 then
            mod.EverchangerItemCharges[t1] = true
        end
        if c2 then
            mod.EverchangerItemCharges[t2] = true
        end
    end
end

function mod:SpawnEnemyWave(n)
    if flags.inBattle then
        flags.enemiesSpawned = true
        local room = game:GetRoom()

        for i=1, n do
            local vector = Vector(5000, 0):Rotated(rng:RandomFloat()*360)
            local position = room:GetClampedPosition(vector, 10)
            
            local faker = Isaac.Spawn(mod.EntityFakerData.ID, mod.EntityFakerData.VAR, mod.EntityFakerData.SUB, position, Vector.Zero, nil)
        end
    end
end

function mod:EverchagerCache(player, cacheFlag)

    if cacheFlag == CacheFlag.CACHE_FAMILIARS then

		local numFamiliars = player:GetCollectibleNum(mod.EverchangerTrinkets.guppy)
        player:CheckFamiliar(FamiliarVariant.LEECH, numFamiliars, player:GetCollectibleRNG(mod.EverchangerTrinkets.guppy), Isaac.GetItemConfig():GetCollectible(mod.EverchangerTrinkets.guppy), 160)
        
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EverchagerCache)

function mod:EverchangerDoors()
    local room = game:GetRoom()
	local level = game:GetLevel()
	local roomdesc = level:GetCurrentRoomDesc()
    local roomidx = level:GetCurrentRoomIndex()
    local roomid = roomdesc.Data.Variant

    --Door(s)
    for i = 0, DoorSlot.NUM_DOOR_SLOTS do
        local door = room:GetDoor(i)
        if door then
            local targetroomindex = door.TargetRoomIndex
            local targetroomdesc = level:GetRoomByIdx(targetroomindex)
            local targetroomid = targetroomdesc.Data.Variant
            local sprite = door:GetSprite()

            if targetroomid == 8500 then
                sprite:Load("gfx/grid/megasoldoor.anm2", true)
                sprite:Play("Open", true)
            elseif targetroomid == 8506 then
                for i=0, 4 do sprite:ReplaceSpritesheet(i, "gfx/grid/door_00_shopdoor.png") end
                sprite:LoadGraphics()

            elseif targetroomid ~= 8508 and roomid ~= 8508 then
                for i=0, 4 do sprite:ReplaceSpritesheet(i, "gfx/grid/door_01_normaldoor.png") end
                sprite:LoadGraphics()
            end
        end
    end

    if roomid == 8500 then
        --Door(s)
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door then
                local sprite = door:GetSprite()
                sprite:Load("gfx/grid/megasoldoor.anm2", true)
                sprite:Play("Open", true)
            end
        end
    end

end


--DEBUG
function mod:CallEC()
    mod:ChanceEverchangerPath(game:GetLevel():GetCurrentRoomIndex())
end