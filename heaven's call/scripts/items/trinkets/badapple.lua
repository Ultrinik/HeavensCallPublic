local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

local BAD_APPLE_FRAME_CHANCE = 1/(30*20)
local BAD_APPLE_CONSUME_FRAME = 120

--UPDATES----------------------------
function mod:OnBadApplePlayerUpdate(player)
	if player:HasTrinket(mod.Trinkets.BadApple) then
		local room = game:GetRoom()
		if not room:IsClear() then
			if rng:RandomFloat() < BAD_APPLE_FRAME_CHANCE and (#mod:FindByTypeMod(mod.Entity.BadApple) <= player:GetTrinketMultiplier(mod.Trinkets.BadApple)-1) then
                local position = room:GetRandomPosition(0)
                
                local c = 0
                while not mod:IsPositionInScreen(position) do
                    position = room:GetRandomPosition(0)
                    c = c + 1
                    if c >= 100 then break end
                end

				local apple = mod:SpawnEntity(mod.Entity.BadApple, position, Vector.Zero, nil)
            end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnBadApplePlayerUpdate, 0)


--PICKUP-----------------------------------------
function mod:BadAppleUpdate(pickup)
    if pickup.SubType == mod.EntityInf[mod.Entity.BadApple].SUB then
		local data = pickup:GetData()
		local sprite = pickup:GetSprite()
		local room = game:GetRoom()

		if room:IsClear() then
			sprite:Play("Collect")
		end

		if not data.Init then
			data.Init = true

			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end

		if sprite:IsFinished("Appear") then
			sfx:Play(SoundEffect.SOUND_FETUS_LAND)
			sprite:Play("Idle", true)
		elseif sprite:IsFinished("Collect") then
			pickup:Remove()

            if not room:IsClear() then

                local variant = mod.EntityInf[mod.Entity.Snake2].VAR

                local position, rotation = mod:RandomUpDown()
                local posY = position.Y
                if game:GetRoom():GetCenterPos().Y > posY then
                    posY = posY - 300
                else
                    posY = posY + 300
                end
                position = Vector(pickup.Position.X, posY)

                local player = Isaac.GetPlayer(0)
                local snake = Isaac.Spawn(mod.EntityInf[mod.Entity.Snake1].ID, variant, 0, position, Vector.Zero, nil):ToNPC()
                local seed = math.floor(pickup.InitSeed * 0.001)
                snake.I1 = seed

                mod:scheduleForUpdate(function ()
                    for i, snk in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Snake1].ID, variant)) do
                        snk = snk:ToNPC()
                        --print("check", snk.I1, seed)
                        if snk and snk.I1 == seed then
                            snk:GetSprite():ReplaceSpritesheet(0, "hc/gfx/monsters/terra_snake_fossil.png", true)
                            snk.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                            snk:GetData().Target = nil
                            snk.Velocity = Vector.Zero
                        end
                    end
                end, 15)
            end

		elseif sprite:IsPlaying("Appear") then
			pickup.Velocity = Vector.Zero
		end

        if pickup.FrameCount == BAD_APPLE_CONSUME_FRAME then
			sprite:Play("Collect", true)
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.BadAppleUpdate, mod.EntityInf[mod.Entity.BadApple].VAR)
