local mod = HeavensCall
local rng = mod:GetRunRNG()
local game = Game()
local sfx = SFXManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%&@@@@&%&@@@@@%%&@@@@&%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%&@@@@@%%&@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%&@@@@@%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%%%%&@@@@&%%%%%%%%%%%&@@@@@%%%%%%%%%%%%&@@@@&%%%%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%%%&@@&%&@@@@@%%&@&%%%%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%%%%&@@@@&%%&@@@@&%&@@@@@%%&@@@@&%%@@@@@%%%%%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@&%%%%%%%%%&@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@&%%%%%%%%%&@@@@@@&%%%%%@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@&%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%&@@@@@@@@@&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]

mod.TterraConst = {
    MAX_APPLES = 1,

    APPLE_DELAY = 300,

	DAMAGE_MULT = 1,
}
mod.TerraCounter = 0

--UPDATES----------------------------
function mod:OnTerraPlayerUpdate(player)
	if player:HasCollectible(mod.Items.Terra) then
		local room = game:GetRoom()
		if not room:IsClear() then
			mod.TerraCounter = mod.TerraCounter + 1
	
			if
			mod.TerraCounter % mod.TterraConst.APPLE_DELAY == 0 and
			#mod:FindByTypeMod(mod.Entity.Apple) < mod.TterraConst.MAX_APPLES * player:GetCollectibleNum(mod.Items.Terra) 
			then
				mod.TerraCounter = 1
				local position = Isaac.GetFreeNearPosition(room:GetRandomPosition(0), 1000)
				local apple = mod:SpawnEntity(mod.Entity.Apple, position, Vector.Zero, player)
			end
		else
			mod.TerraCounter = 150
		end

	else
		mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnTerraPlayerUpdate, 0)
	end
end

function mod:SnakeUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Snake1].VAR or
		entity.Variant == mod.EntityInf[mod.Entity.Snake2].VAR or
		entity.Variant == mod.EntityInf[mod.Entity.Snake3].VAR then

		entity.Velocity = Vector.Zero

		local data = entity:GetData()
		local room = game:GetRoom()

		local n = (1 + (entity.Variant - mod.EntityInf[mod.Entity.Snake3].VAR))
		local m = 0.125*n + 0.625

		if not data.Init then
			data.Init = true
			sfx:Stop(SoundEffect.SOUND_SUMMON_POOF)

			data.Direcion = -1 --Up
			if entity.Position.Y < room:GetCenterPos().Y then
				data.Direcion = 1 --Down
				entity:GetSprite().FlipY = true
			end

			if not data.PosX then data.PosX = entity.Position.X end
			if not data.Offset then data.Offset = 0 end

			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			entity.CollisionDamage = 7*n+2--(1 + entity.Variant - mod.EntityInf[mod.Entity.Snake3].VAR) * mod.TterraConst.DAMAGE_MULT
			
			entity:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			entity:GetSprite().Color = Color.Default

			
			if entity.SubType == 0 then
				local parent = entity

				for i=1, 13*n do
					local position = entity.Position - Vector(0, -data.Direcion*50*m)
					local tail = Isaac.Spawn(mod.EntityInf[mod.Entity.Snake1].ID, entity.Variant, 1, position, Vector.Zero, entity):ToNPC()
					tail.Parent = parent

					if data.Direcion > 0 then
						tail.DepthOffset = parent.DepthOffset + data.Direcion*51*m
					end

					tail:GetData().PosX = data.PosX
					tail:GetData().Offset = i*86
					
					tail:GetData().Target = entity:GetData().Target
					tail.I1 = entity.I1
					--print("trans", tail.I1, entity.I1)

					parent = tail
				end


			elseif entity.SubType == 1 then
				entity:GetSprite():Play("Tail", true)
			end

			sfx:Play(Isaac.GetSoundIdByName("snake_hiss"))
		end

		if data.Target and type(data.Target) ~= "number" then
			data.PosX = data.PosX*0.975 + data.Target.Position.X*0.025
		end

		local posX = data.PosX + 20*math.sin((entity.FrameCount + data.Offset)/1.75)

		local posY
		if entity.SubType == 0 then
			if math.abs(entity.Position.Y) > 4000 then
				entity:Remove()
			end
			posY = entity.Position.Y + data.Direcion*25

		elseif entity.SubType == 1 then
			if not entity.Parent then
				entity:Remove()
				return
			end
			posY = entity.Parent.Position.Y - data.Direcion*75*m
		end

		entity.Position = Vector(posX, posY)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SnakeUpdate, mod.EntityInf[mod.Entity.Snake1].ID)
function mod:TakeDamageBySnake(entity, amount, flags, source, frames)
	if (flags & DamageFlag.DAMAGE_CLONES) == 0 then
		if source and (source.Type == mod.EntityInf[mod.Entity.Snake1].ID) and
			(mod.EntityInf[mod.Entity.Snake3].VAR <= source.Variant and source.Variant <= mod.EntityInf[mod.Entity.Snake1].VAR)
		then

			if entity.Type == EntityType.ENTITY_PLAYER then
				entity:TakeDamage(1, flags | DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR | DamageFlag.DAMAGE_CLONES, source, frames)
				return false
			end

			local damage = source.Entity and source.Entity.CollisionDamage or 1
			entity:TakeDamage(damage, flags | DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_CRUSH | DamageFlag.DAMAGE_IGNORE_ARMOR | DamageFlag.DAMAGE_CLONES, source, frames)
			entity.Velocity = Vector.Zero
			entity.Position = mod:Lerp(entity.Position, source.Entity.Position, 0.1)
			return false
		end
	end
end

--PICKUP-----------------------------------------
function mod:AppleUpdate(pickup)
    if pickup.SubType == mod.EntityInf[mod.Entity.Apple].SUB then
		local data = pickup:GetData()
		local sprite = pickup:GetSprite()
		local room = game:GetRoom()

		if room:IsClear() then
			sprite:Play("Collect"..tostring(string.sub(sprite:GetAnimation(),#sprite:GetAnimation())))
		end

		if not data.Init then
			data.Init = true

			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end

		if sprite:IsFinished("Appear") then
			sfx:Play(SoundEffect.SOUND_FETUS_LAND)
			sprite:Play("Idle1", true)
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		elseif sprite:IsFinished("Grow1") then
			sprite:Play("Idle2", true)
		elseif sprite:IsFinished("Grow2") then
			sprite:Play("Idle3", true)
		elseif sprite:IsFinished("Collect1") or sprite:IsFinished("Collect2") or sprite:IsFinished("Collect3") then
			pickup:Remove()

		elseif pickup.FrameCount == 250 and not data.Picked then
			sprite:Play("Grow1", true)
		elseif pickup.FrameCount == 750 and not data.Picked then
			sprite:Play("Grow2", true)

		elseif sprite:IsPlaying("Appear") then
			pickup.Velocity = Vector.Zero
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.AppleUpdate, mod.EntityInf[mod.Entity.Apple].VAR)

function mod:OnAppleCollision(pickup, collider)
    if pickup.SubType == mod.EntityInf[mod.Entity.Apple].SUB then
		local player = collider:ToPlayer()
		local sprite = pickup:GetSprite()

		if player and player:HasCollectible(mod.Items.Terra) and (not (sprite:IsPlaying("Collect1") or sprite:IsPlaying("Collect2") or sprite:IsPlaying("Collect3"))) then
			pickup:GetData().Picked = true
			pickup.Velocity = Vector.Zero
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			local size = tostring(string.sub(pickup:GetSprite():GetAnimation(),#pickup:GetSprite():GetAnimation()))
			if (sprite:IsPlaying("Grow1") or sprite:IsPlaying("Grow2")) then
				size = tostring(tonumber(size) + 1)
			end
			if size == 'r' then size = '1' end
			pickup:GetSprite():Play("Collect"..size)

			local victim = mod:GetTargetEnemy(player, 9999)
			if not victim then victim = player end

			local variant
			if size == "1" then 
				variant = mod.EntityInf[mod.Entity.Snake3].VAR
			elseif size == "2" then 
				variant = mod.EntityInf[mod.Entity.Snake2].VAR
			elseif size == "3" then 
				variant = mod.EntityInf[mod.Entity.Snake1].VAR
			end

			local position, rotation = mod:RandomUpDown()
			local posY = position.Y
			if game:GetRoom():GetCenterPos().Y > posY then
				posY = posY - 300
			else
				posY = posY + 300
			end

			position = Vector(victim.Position.X, posY)
			local snake = Isaac.Spawn(mod.EntityInf[mod.Entity.Snake1].ID, variant, 0, position, Vector.Zero, player)
			snake:GetData().Target = victim

			sfx:Play(mod.SFX.Chomp, 0.5,0,false,0.7)
			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnAppleCollision, mod.EntityInf[mod.Entity.Apple].VAR)

--CALLBACKS
function mod:AddTTerraCallbacks()
	mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnTerraPlayerUpdate, 0)
	mod:RemoveCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.TakeDamageBySnake)

	if mod:SomebodyHasItem(mod.Items.Terra) then
		mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnTerraPlayerUpdate, 0)
		mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.TakeDamageBySnake)
	end
end
mod:AddTTerraCallbacks()
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.AddTTerraCallbacks, mod.Items.Terra)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddTTerraCallbacks)