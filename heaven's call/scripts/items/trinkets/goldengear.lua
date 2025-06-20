local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local BACK_ON_HIT = 0.1
local BACK_ON_DEATH = 0.3
local CHANCE_BREAK = 0.1

function mod:OnGoldenGearDamage(player)
    if player:HasTrinket(mod.Trinkets.Gear) then
        local chance = 1 - (1 - BACK_ON_HIT)^player:GetTrinketMultiplier(mod.Trinkets.Gear)
        local r = rng:RandomFloat()
        --print("hit", r, chance)
        if r < chance then
            mod:scheduleForUpdate(function ()
                if player then
                    --Effects
                    local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, player.Position + Vector(0,-10), Vector.Zero, player):ToEffect()
                    timestuck:FollowParent(player)
                    timestuck:GetSprite().PlaybackSpeed = 0.5
                    timestuck:GetSprite().Scale = Vector.One*0.5
                    timestuck.DepthOffset = -50
    	            timestuck:GetData().Timestop_inmune = 2

                    sfx:Play(Isaac.GetSoundIdByName("AshTime2"),1.2)
                    sfx:Play(Isaac.GetSoundIdByName("TimeResume"), 2)
                    
			        player:GetHeldSprite():ReplaceSpritesheet(1, "hc/gfx/items/trinkets/trinket_saturn.png", true)
                    
                    if rng:RandomFloat() < CHANCE_BREAK then
                        player:TryRemoveTrinket(mod.Trinkets.Gear)
                        player:TryRemoveSmeltedTrinket(mod.Trinkets.Gear)
                    end
                end
            end, 11)

            mod:EnableWeather(mod.WeatherFlags.TIMESTUCK, 0)
            mod.ShaderData.timestuckRoomIdx = game:GetLevel():GetCurrentRoomIndex()
            mod.ShaderData.timestuckStartFrame = game:GetFrameCount()
            mod.ShaderData.timestuckEndFrame = mod.ShaderData.timestuckStartFrame + 15
            return true
        end
    end
end

function mod:OnGoldenGearDeath(player)
    if player:HasTrinket(mod.Trinkets.Gear) then
        local chance = 1 - (1 - BACK_ON_DEATH)^player:GetTrinketMultiplier(mod.Trinkets.Gear)
        local r = rng:RandomFloat()
        --print("death", r, chance)
        if r < chance then
            --Isaac.ExecuteCommand("rewind")
    		player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false)
            mod:scheduleForUpdate(function ()
                if player then
                    --Effects
                    local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, player.Position + Vector(0,-10), Vector.Zero, player):ToEffect()
                    timestuck:FollowParent(player)
                    timestuck:GetSprite().PlaybackSpeed = 0.5
                    timestuck:GetSprite().Scale = Vector.One*0.5
                    timestuck.DepthOffset = -50
    	            timestuck:GetData().Timestop_inmune = 2

                    sfx:Play(Isaac.GetSoundIdByName("AshTime2"),1.2)
                    sfx:Play(Isaac.GetSoundIdByName("TimeResume"), 2)
                    
			        player:GetHeldSprite():ReplaceSpritesheet(1, "hc/gfx/items/trinkets/trinket_saturn.png", true)
                    
                    if rng:RandomFloat() < CHANCE_BREAK then
                        player:TryRemoveTrinket(mod.Trinkets.Gear)
                        player:TryRemoveSmeltedTrinket(mod.Trinkets.Gear)
                    end
                end
            end, 3)
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, mod.OnGoldenGearDeath)