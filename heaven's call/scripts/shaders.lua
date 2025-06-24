local mod = HeavensCall
local game = Game()

mod.ShaderData = {

	--Timestuck
	globalTimestuck = false,
	playerTimestuck = false,
	playerTimestuckFlick = false,
	timestuckRoomIdx = -1,
	timestuckStartFrame = 0,
	timestuckEndFrame = 0,

	--weather
	weather = false,
	weatherFlags = 0,
	weatherIntensityFrame = 0,
	weatherFrame2 = 0,
	intensity = 1,
	currentIntensity = 1,
	rain = 0,
	heat = 0,
	blizzard = 0,

	--Black hole
	blackHole = false,
	blackHolePosition = Vector.Zero,
	blackHoleTime = 0,

	--Mars
	marsEnabled = false,
	marsCharge = 0,

	--SOL
	solData = {ENABLED = false, HPSIZE = 0, CORONACOLOR = Color(1,1,1,1), BODYCOLOR = Color(1,1,1,1), ROTATIONOFFSET = 0, TIME=0},

	--Radioactive
	radParams = {ENABLED = false, POSITION = Vector.Zero},

	--RadioactiveUI
	radUIParams = {ENABLED = false, POSITION0 = Vector.Zero, POSITION1 = Vector.Zero},

	--Apocalypse
	isApocalypseActive = false,
	apocalypseStartFrame = 0,

	--Monochrome
	monochrome = false,

	--Negative
	negative = false,

	--Underwater
	underwater = false,

	--ouroboos
	ouroborosEnabled = false,
	ouroborosGhostsEnabled = false,
	ouroborosGhosts = {},
	ouroborosGhostsSprites = {},
}


local black_hole_sprite = Sprite()
black_hole_sprite:Load("hc/gfx/effect_BlackHoleHole.anm2", true)
function mod:ShadersRender(shaderName)

	if mod.ShaderData.blackHole then
		local room = game:GetRoom()
		local position = room:WorldToScreenPosition(mod.ShaderData.blackHolePosition + Vector(0,-3))
		black_hole_sprite:Render(position)
		black_hole_sprite:Update()
	end

	if shaderName == "Weather" then
		if mod.ShaderData.weather then

			mod.ShaderData.currentIntensity = mod:Lerp(mod.ShaderData.currentIntensity, mod.ShaderData.intensity, 0.1)

			mod.ShaderData.weatherIntensityFrame = mod.ShaderData.weatherIntensityFrame + mod.ShaderData.intensity

			local timestuck = 0
			if (mod.ShaderData.globalTimestuck or (mod.ShaderData.playerTimestuck and mod.ShaderData.playerTimestuckFlick)) then timestuck = mod.WeatherFlags.TIMESTUCK end
			
			local params = {
				Intensity = mod.ShaderData.currentIntensity,
				Flags = mod.ShaderData.weatherFlags | timestuck,
				Charge = mod.ShaderData.marsCharge,
				Time = mod.ShaderData.weatherIntensityFrame--{mod.ShaderData.weatherIntensityFrame, mod.ShaderData.weatherFrame2, Isaac.GetFrameCount()},
			}
			return params
		else
			local params = {
				Flags = 0
			}
			return params
		end

	elseif shaderName == "Ouroboros" then
		if mod.ShaderData.ouroborosEnabled then
			
			if not game:IsPaused() then

				if mod.ShaderData.ouroborosGhostsEnabled then
					local hScreenSize = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())*0.5
					local room = game:GetRoom()
	
					for i=1, 4 do
						local ghost = mod.ShaderData.ouroborosGhosts[i]
	
						if ghost and not ghost:IsDead() then
	
							local gsprite = ghost:GetSprite()
						
							if not mod.ShaderData.ouroborosGhostsSprites[i] then
	
								mod.ShaderData.ouroborosGhostsSprites[i] = Sprite()

															
								local futureFlag = TheFuture and TheFuture.Stage:IsStage()
								if futureFlag then
									mod.ShaderData.ouroborosGhostsSprites[i]:Load("hc/gfx/entity_RetconSaturnGhost.anm2", true)
								else
									mod.ShaderData.ouroborosGhostsSprites[i]:Load("hc/gfx/entity_RetconSaturn.anm2", true)
								end

								mod.ShaderData.ouroborosGhostsSprites[i]:Play(gsprite:GetAnimation(), true)
	
							end
							local sprite = mod.ShaderData.ouroborosGhostsSprites[i]
							sprite.Scale = Vector.One * 0.5
							sprite.Color = gsprite.Color
	
							sprite:SetFrame(gsprite:GetFrame())
							local layer = sprite:GetLayer("face")
							layer:SetPos(gsprite:GetLayer("face"):GetPos())

													
							local angle1 = math.sin(ghost.FrameCount / 30)*3
							local angle2 = mod:Lerp(angle1, 0.5*ghost.Velocity.X, 0.1)
							for i=4,5 do
								local layer = sprite:GetLayer(i)
								layer:SetRotation(angle1 + angle2)
							end
							
							local position = room:WorldToScreenPosition(ghost.Position)*0.5
	
							ghost.Visible = false
	
							if i==1 then
								position = position + Vector(hScreenSize.X, 0)
							elseif i==2 then
								position = position + Vector(0, hScreenSize.Y)
							elseif i==3 then
								position = position + hScreenSize
							end
							sprite:Render(position)
						else
							mod.ShaderData.ouroborosEnabled = false
							mod:KillEntities(Isaac.FindByType(Isaac.GetEntityTypeByName("Ouroboros (Paradox Saturn)")))
							break
						end
					end

					if mod.ShaderData.ouroborosScreen then
						local screen = mod.ShaderData.ouroborosScreen
						local sprite = screen:GetSprite()
						sprite.Scale = Vector.One * 0.75

						sprite:Render(hScreenSize)
					end
				end
			end

			local params = {Enabled = 1}
			return params
		else
			local params = {Enabled = 0}
			return params
		end

	elseif shaderName == "Sol" then
		--mod.ShaderData.solData.ENABLED = false
		if mod.ShaderData.solData.ENABLED then
			local room = game:GetRoom()
			game:GetHUD():Render()
			if game:IsPaused() then
				mod.ShaderData.solData.ENABLED = false
			end
			--[[local testPos = Vector(math.sin(game:GetFrameCount()/50)*500,0)

			local room = game:GetRoom()
			local position = room:WorldToScreenPosition(room:GetCenterPos())--+testPos
			local time = game:GetFrameCount()

			local hp = (10000 - time*100 % 10000)
			--hp = 500
			local healthSize = -hp/15000 + 1.25

			local range = 100*healthSize

			local color1 = Color.Lerp(Color(1,1,1), Color(0.8,0,0), (1-hp/10000))
			
			local color2 = Color.Lerp(Color(1,1,1), Color(0.75,0.33,0), (1-hp/10000))
			color2 = Color.Lerp(color2, Color(1,1,0), (hp/20000)/3.5)]]

			local time = mod.ShaderData.solData.TIME

			local healthSize = mod.ShaderData.solData.HPSIZE -- 100% -> 0.583 ; 0% -> 1.250

			local range = 100*healthSize * 1.5

			local position = Isaac.WorldToScreen(mod.ShaderData.solData.POSITION)
			local radius = Isaac.WorldToScreen(mod.ShaderData.solData.POSITION + Vector(range,0))
			local warp_check = position + Vector(1,1)

			--local resolution = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
			--local normalizedPosition = Vector(position.X / resolution.X, position.Y / resolution.Y)
			--local normalizedRadius = Vector(radius.X / resolution.X, radius.Y / resolution.Y)
			--local normalizedWarpCheck = Vector(warp_check.X / resolution.X, warp_check.Y / resolution.Y)

			local color1 = mod.ShaderData.solData.CORONACOLOR
			local color2 = mod.ShaderData.solData.BODYCOLOR
			
			local isEternal = 1
			if mod.ShaderData.solData.ETERNAL then isEternal = -1 end

			local angle1 = time%360
			local angle2 = 72 + (time*2)%360
			local angle3 = 144 + (time/2)%360
			local angle4 = 216 + (time*-1.5)%360
			local angle5 = 288 + (time/-2.5)%360

			local params = {
				Enabled = 1,
				SolPosition = {position.X,  position.Y, radius.X},
				--SolPosition = {normalizedPosition.X,  normalizedPosition.Y, normalizedRadius.X},
				Time = time,
				HealthAngleAngle = {healthSize*isEternal, angle1, angle2},
				AngleAngleAngle = {angle3, angle4, angle5},
				CoronaColor = {color1.R, color1.G, color1.B},
				SolColor = {color2.R, color2.G, color2.B},
				WarpCheck = {warp_check.X + 1, warp_check.Y + 1},
				--WarpCheck = {normalizedWarpCheck.X + 1, normalizedWarpCheck.Y + 1},
				}
			return params
		else
			local params = {
				Enabled = 0,
				SolPosition = {0,  0},
				Time = 0,
				Angle1 = 0,
				Angle2 = 0,
				Angle3 = 0,
				Angle4 = 0,
				Angle5 = 0,
				RotationOffset = 0,
				Health = 0,
				CoronaColor = {1,1,1},
				SolColor = {1,1,1},
				}
			return params
		end
	elseif shaderName == "Apocalypse" then
		if mod.ShaderData.isApocalypseActive then
			local params = {
				Enabled = 1,
				Time = Isaac.GetFrameCount() - mod.ShaderData.apocalypseStartFrame
				}
			return params
		else
			local params = {
				Enabled = 0,
				Time = 0,
				}
			return params
		end
	elseif shaderName == "Darkness" then
		local flags = mod.EverchangerFlags
		if flags and flags.darknessDebug then
			local pos0 = Vector(flags.position0[0], flags.position0[1])
			local pos1 = Vector(flags.position1[0], flags.position1[1])
			local pos2 = Vector(flags.position2[0], flags.position2[1])
			local pos3 = Vector(flags.position3[0], flags.position3[1])
			local pos4 = Vector(flags.position4[0], flags.position4[1])
			local pos5 = Vector(flags.position5[0], flags.position5[1])
			local pos6 = Vector(flags.position6[0], flags.position6[1])
			local pos7 = Vector(flags.position7[0], flags.position7[1])

			local distance0 = Vector(flags.position0[2], flags.position0[2]+10)
			local distance1 = Vector(flags.position1[2], flags.position1[2]+10)
			local distance2 = Vector(flags.position2[2], flags.position2[2]+10)
			local distance3 = Vector(flags.position3[2], flags.position3[2]+10)
			local distance4 = Vector(flags.position4[2], flags.position4[2]+10)
			local distance5 = Vector(flags.position5[2], flags.position5[2]+10)
			local distance6 = Vector(flags.position6[2], flags.position6[2]+10)
			local distance7 = Vector(flags.position7[2], flags.position7[2]+10)

			local fadePos0 = Isaac.WorldToScreen(pos0 + Vector(distance0.Y, 0))
			local fadePos1 = Isaac.WorldToScreen(pos1 + Vector(distance1.Y, 0))
			local fadePos2 = Isaac.WorldToScreen(pos2 + Vector(distance2.Y, 0))
			local fadePos3 = Isaac.WorldToScreen(pos3 + Vector(distance3.Y, 0))
			local fadePos4 = Isaac.WorldToScreen(pos4 + Vector(distance4.Y, 0))
			local fadePos5 = Isaac.WorldToScreen(pos5 + Vector(distance5.Y, 0))
			local fadePos6 = Isaac.WorldToScreen(pos6 + Vector(distance6.Y, 0))
			local fadePos7 = Isaac.WorldToScreen(pos7 + Vector(distance7.Y, 0))

			pos0 = Isaac.WorldToScreen(pos0)
			pos1 = Isaac.WorldToScreen(pos1)
			pos2 = Isaac.WorldToScreen(pos2)
			pos3 = Isaac.WorldToScreen(pos3)
			pos4 = Isaac.WorldToScreen(pos4)
			pos5 = Isaac.WorldToScreen(pos5)
			pos6 = Isaac.WorldToScreen(pos6)
			pos7 = Isaac.WorldToScreen(pos7)

			local params = {
				ActiveIn = flags.enabledDarkness,
				
				TargetPosition0 = {pos0.X, pos0.Y, fadePos0.X, fadePos0.Y},
				TargetPosition1 = {pos1.X, pos1.Y, fadePos1.X, fadePos1.Y},
				TargetPosition2 = {pos2.X, pos2.Y, fadePos2.X, fadePos2.Y},
				TargetPosition3 = {pos3.X, pos3.Y, fadePos3.X, fadePos3.Y},
				TargetPosition4 = {pos4.X, pos4.Y, fadePos4.X, fadePos4.Y},
				TargetPosition5 = {pos5.X, pos5.Y, fadePos5.X, fadePos5.Y},
				TargetPosition6 = {pos6.X, pos6.Y, fadePos6.X, fadePos6.Y},
				TargetPosition7 = {pos7.X, pos7.Y, fadePos7.X, fadePos7.Y},
				
				WarpCheck = {pos0.X + 1, pos0.Y + 1},
			}

            return params
		else
			local params = {
				ActiveIn = 0,

				TargetPosition0 = {0, 0, 0, 0},
				}
			return params
		end

	elseif shaderName == "DarknessOther" then
		local flags = mod.EverchangerFlags
		if flags and flags.darknessDebug and flags.darknessOther then
			local room = game:GetRoom()
			local time = flags.time

			local position0 = room:WorldToScreenPosition(Vector(flags.position0[0], flags.position0[1]))
			local radius0 = room:WorldToScreenPosition(Vector(flags.position0[0], flags.position0[1]) + Vector(flags.position0[2], 0))

			local position1 = room:WorldToScreenPosition(Vector(flags.position1[0], flags.position1[1]))
			local radius1 = room:WorldToScreenPosition(Vector(flags.position1[0], flags.position1[1]) + Vector(flags.position1[2], 0))

			local params = {
				EnabledStatic = flags.enabledStatic,
				EnabledZoom = flags.enabledZoom,
				Position0 = {position0.X,  position0.Y, radius0.X},
				Position1 = {position1.X,  position1.Y, radius1.X},
				Time = time,
				Distance = flags.distance,
				Red = flags.alarmColor,
				WarpCheck = {position0.X + 1, position0.Y + 1},
				}
			return params
		else
			local params = {
				EnabledStatic = 0,
				EnabledZoom = 0,
				Position0 = {0,  0,  0},
				Position1 = {0,  0,  0},
				Time = 0,
				Distance = 999999,
				Red = 0,
				WarpCheck = {0,  0},
				}
			return params
		end

	end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.ShadersRender)

function mod:EnableBlackHole(position, scale)
	scale = scale or 0.8
	mod.ShaderData.blackHole = true
	mod.ShaderData.blackHolePosition = position
	black_hole_sprite:Play("Idle", true)
	black_hole_sprite.Scale = Vector.One * scale
end

--[[
mod:AddPriorityCallback (ModCallbacks.MC_HUD_RENDER, CallbackPriority.LATE, function ()
	game:GetHUD():SetVisible(false)
end)
mod:AddPriorityCallback (ModCallbacks.MC_HUD_RENDER, CallbackPriority.IMPORTANT, function ()
	game:GetHUD():SetVisible(false)
end)
]]--

-- not sure if this shader crash fix by agentcucco is still necessary, but i'll put it in anyway
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	Isaac.ExecuteCommand("reloadshaders")
end)

mod.WeatherFlags = {
	BLIZZARD = 1<<0,
	RAIN = 1<<1,
	HEAT = 1<<2,
	UNDERWATER = 1<<3,
	--DOOMSDAY = 1<<4,
	TIMESTUCK = 1<<5,
	MARTIAN = 1<<6,
}
function mod:EnableWeather(weather, vardata)

	if weather == mod.WeatherFlags.BLIZZARD then
		mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.BLIZZARD
		mod.ShaderData.currentIntensity = 0
		mod.ShaderData.intensity = 1
		mod.ShaderData.weatherIntensityFrame = 0

	elseif weather == mod.WeatherFlags.RAIN then
		mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.RAIN
		mod.ShaderData.currentIntensity = 0
		mod.ShaderData.intensity = 1
		mod.ShaderData.weatherIntensityFrame = 0

	elseif weather == mod.WeatherFlags.HEAT then
		mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.HEAT
		mod.ShaderData.currentIntensity = 0
		mod.ShaderData.intensity = 1
		mod.ShaderData.weatherIntensityFrame = 0

	elseif weather == mod.WeatherFlags.UNDERWATER then
		mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.UNDERWATER
		mod.ShaderData.intensity = 1
		mod.ShaderData.weatherIntensityFrame = 0

	elseif weather == mod.WeatherFlags.TIMESTUCK then
		--mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.TIMESTUCK
		if vardata == 0 then--player
            mod.ShaderData.playerTimestuck = true
            mod.ShaderData.playerTimestuckFlick = true
		else--boss
			mod.ShaderData.globalTimestuck = true
		end

	elseif weather == mod.WeatherFlags.MARTIAN then
		mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.MARTIAN

	end

	mod.ShaderData.weather = true
end

function mod:DisableWeather(weather, vardata)

	mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags & (~weather)

	if weather == mod.WeatherFlags.TIMESTUCK then
		--mod.ShaderData.weatherFlags = mod.ShaderData.weatherFlags | mod.WeatherFlags.TIMESTUCK
		if vardata == 0 then--player
            mod.ShaderData.playerTimestuck = false
            mod.ShaderData.playerTimestuckFlick = false
		else--boss
			mod.ShaderData.globalTimestuck = false
		end
	end
		
	if mod.ShaderData.weather and mod.ShaderData.weatherFlags == 0 and not ((mod.ShaderData.globalTimestuck or (mod.ShaderData.playerTimestuck and mod.ShaderData.playerTimestuckFlick))) then
		mod.ShaderData.weather = false
	end
end

function mod:OnWeatherNewRoom()
	if mod.ShaderData.weatherFlags > 0 then
		if mod.ShaderData.weatherFlags & mod.WeatherFlags.BLIZZARD then
			mod:DisableWeather(mod.WeatherFlags.BLIZZARD)
		end
		if mod.ShaderData.weatherFlags & mod.WeatherFlags.RAIN then
			mod:DisableWeather(mod.WeatherFlags.RAIN)
		end
		if mod.ShaderData.weatherFlags & mod.WeatherFlags.HEAT then
			mod:DisableWeather(mod.WeatherFlags.HEAT)
		end
		if mod.ShaderData.weatherFlags & mod.WeatherFlags.UNDERWATER then
			mod:DisableWeather(mod.WeatherFlags.UNDERWATER)
		end
	end

	mod.ShaderData.globalTimestuck = false
	mod.ShaderData.playerTimestuck = false
	mod.ShaderData.playerTimestuckFlick = false
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnWeatherNewRoom)