local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

--[[
/*//**/**//*//**/**//*//**/**//*//**/**//**/**/**//**/**//*//**/**//*//**/**//*/
/*//**/**//*//**/**//*/###%##(/*//**/**//**/**/**//**/**//*//**/**//*//**/**//*/
********************/#&%%%%%%%&&%(**********************************************
*/**//*//**/**//*//**&%%#/*//#&@@@@@@@@@@@@&&@@@&**/**//**/**//*//**/**//*//**/*
*/**//*//**/**//*//**%%%%@@@@@@@@@@@@@@@@@@@@@&&&@@@@@@/**/**//*//**/**//*//**/*
/*//**/**//*//**/**//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%//**/**//*//**/**//*/
/*//**/**//*//**/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(*/**//*//**/**//*/
*/**//*//**/**/&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//**/**//*//**/*
*/**//%%%#(#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@**/**//*//**/*
/*//*(%%&#/#@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/*//**/**//*/
/*//*(%%&&(@@@@@@@@&(#(((#((&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%#(/(/*/
*/**//*#%&@@@@@@@@&(#@(@(@#(%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#####%%(/(*
*/**//*//@@@&@@@@@@&(#(@@##%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/##%%///*
/*//**/**@@@(&@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(####*/(*/
/*//**/*&@@@@@((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((#**//*/
*/**/#%%@@@@@@@@@(&@&(&@@(&@((&&((&((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//*//**/*
*/*%&%###@@@@@@@@@@@@@@@@(@@@@@@@@@@@%((@@@@@@@&&%%#%&&@@@@@@@@@@@@@@@@//*//**/*
/*%%%#/**&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@&(#@@@@(#%&@@@@@@@@@@@@@&&&%**//*/
/*%&%##**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#(@(@(@##&@@@@@@@@@@@@@&&&%**//*/
/*#%&&%#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(%@@@@&&##((##%&@@@@@@@@@@@@@&%((/**//*/
*/**##%&&%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((&@@@@@&&@@@@@@@@@@@@@@@@/**//*//**/*
*/**//*//**/%@@@@@@@((&@@@@@@@@@@@@@@@@@@@@@&(%@(@@@@@@@@@@@@@@@@@@*/**//*//**/*
/*//**/**//*//@@@@@@&(&@@@@@@@@@@@@@@@@@@@@@@@@@#@@((@((@%(@@@@@@#//*//**/**//*/
/*//**/**//*//**@@@@@@@@@@%((&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%*//**/**//*/
*/**//*//**/**//*/#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//*%&%#%(*//*//**/*
*/**//*//**/**//*//**(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%&%%&@&#%(*//*//**/*
/*//**/**//*//**/**//*//**@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@&&&&&%%%##(///**/**//*/
/*//**/**//*//**/**//*//**/**//*/@@@@@@@@@@@@@/**//**/**//(#(/*/**//*//**/**//*
/*//**/**//*//**/**//*//**/**//*//**/**//**/**/**//**/**//*//**/**//*//**/**//*/
]]--

mod:AddResetFlag(ModCallbacks.MC_POST_NEW_LEVEL, "ModFlags.blood_room", false)

mod.NMSState = {
	APPEAR = 0,
	IDLE = 1,
	DEIDLE = 2,
	REIDLE = 3,
	SHOT = 4,
	ABSORB = 5,
	RAIN = 6,
	BUBBLE = 7,
	DOWN = 8,
	UP = 9,
	AMBUSH = 10,
	REAPPEAR = 11,
	NOAMBUSHXD = 12,
	GYRO = 13,
	BITE = 14,
}
mod.chainN = {
	--                           app  idl   deid  reid    shot   torn  rain   bubbb  down  up    ambus reap  noamb   gyro    bite
	[mod.NMSState.APPEAR] = 	{0,   1,    0,    0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.IDLE] = 		{0,   0.2,  0.8,  0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.DEIDLE] = 	{0,   0,    0,    0,      0.28,  0,    0.27,  0,     0.45, 0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.REIDLE] = 	{0,   1,    0,    0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.SHOT] = 		{0,   0,    0,    0.44,   0.13,  0,    0.13,  0,     0.3,  0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.ABSORB] = 	{0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.RAIN] = 		{0,   0,    0,    0.35,   0.15,  0,    0.25,  0,     0.25, 0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.BUBBLE] = 	{0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.DOWN] = 		{0,   0,    0,    0,      0,     0,    0,     0,     0,    0.73, 0.27,  0, 	 0, 	 0, 	 0},
	[mod.NMSState.UP] = 		{0,   0,    0,    0,      0,     0.5,  0,     0.5,   0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.AMBUSH] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0,    1, 	 0, 	 0, 	 0},
	[mod.NMSState.REAPPEAR] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0.65, 0, 	 0.35, 	 0, 	 0},
	[mod.NMSState.NOAMBUSHXD] = {0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.GYRO] = 		{0,   0,    0,    1,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0},
	[mod.NMSState.BITE] = 		{0,   0,    0,    0,      0,     0,    0,     0,     1,    0,    0,    0, 	 0, 	 0, 	 0},
	
}
mod.NConst = {--Some constant variables of Neptune
	SPEED = 2,

	N_UP_DOWN_SPLASH = 2,
	UP_DOWN_SPLASH_FALL = 0.7,
	MIN_DISTANCE_TO_REAPPEAR = 50,
	N_SPLASH = 8,

	--shot
	N_SHOTS = 4,
	N_EXTRA_SHOTS = 1,
	NORMAL_SHOT_SPEED = 9,
	NORMAL_SHOT_ANGLE = 90,
	EXTRA_SHOT_ANGLE = 60,
	SPECIAL_SHOT_SPEED = 13,
	SPECIAL_SHOT_SCALE = 0.5, --+1

	--tornado
	N_ABSORBS = 33,
	N_TORNADO_RING = 8,

	--rain
	N_RAIN_DROP = 24,
	RAIN_DROP_RADIUS = 120,

	--bubble splash
	N_BUBBLE_SPLASH = 2,
	BUBBLE_SPASH_FALL = 0.9,
	N_BUBBLE_RING = 8,
	BUBBLE_SPEED = 7,
	N_BUBBLE_END_SPLASH = 3,
	BUBBLE_END_SPLASH_FALL = 0.7,

	--ambush
	N_FAKERS = 4,
	N_AMBUSH_SPLASH = 2,
	AMBUSH_SPLASH_FALL = 2,
	AMBUSH_SPEED = 60,

	--bite
	BITE_SPEED = 50,
	BITE_N_IDLES = 0,
	TELE_DISTANCE = 120,
	N_BITES = 2,
	N_BITE_SPLASH = 7,
	BITE_N_FAKERS = 3,

	--pixel
	PIXEL_SPEED = 1.6,
	PIXEL_ANGULAR_SPEED = 0.01,
	FISH_DISSAPEAR_CHANCE = 0.5,
}
function mod:SetNeptuneDifficulty(difficulty)
    if difficulty == mod.Difficulties.NORMAL then
		--                             			app  idl   deid  reid    shot   torn  rain   bubbb  down  up    ambus reap    noamb   gyro    bite
		mod.chainN[mod.NMSState.DEIDLE] = 	   {0,   0,    0,    0,      0.28,   0,    0.27,  0,    0.45,0,     0,    0, 	 0, 	 0, 	 0}
		mod.chainN[mod.NMSState.IDLE] = 	   {0,   0.2,  0.8,  0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0}
		mod.chainN[mod.NMSState.AMBUSH] = 	   {0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0,    1, 	 0, 	 0, 	 0}
		mod.chainN[mod.NMSState.REAPPEAR] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0.65, 0, 	 0.35, 	 0, 	 0}
		
		--stat changes--------------------------------------------------------------------------------------------------
		mod.NConst.SPEED = 2
		--shot
		mod.NConst.N_SHOTS = 4
		mod.NConst.N_EXTRA_SHOTS = 1
		mod.NConst.NORMAL_SHOT_SPEED = 9
		mod.NConst.SPECIAL_SHOT_SPEED = 12

		--tornado
		mod.NConst.N_ABSORBS = 33
		mod.NConst.N_TORNADO_RING = 8

		--rain
		mod.NConst.N_RAIN_DROP = 24
		mod.NConst.RAIN_DROP_RADIUS = 100

		--bubble splash
		mod.NConst.N_BUBBLE_SPLASH = 2
		mod.NConst.N_BUBBLE_RING = 8
		mod.NConst.BUBBLE_SPEED = 7
		mod.NConst.N_BUBBLE_END_SPLASH = 3

		--ambush
		mod.NConst.N_FAKERS = 4
		mod.NConst.N_AMBUSH_SPLASH = 2

		--bite

		--pixel
		mod.NConst.PIXEL_SPEED = 1.6
		mod.NConst.PIXEL_ANGULAR_SPEED = 0.01
		mod.NConst.FISH_DISSAPEAR_CHANCE = 0.5

	elseif difficulty == mod.Difficulties.ATTUNED then
		--                             			app  idl   deid  reid    shot   torn  rain   bubbb  down  up    ambus reap    noamb   gyro    bite
		mod.chainN[mod.NMSState.DEIDLE] = 	   {0,   0,    0,    0,      0.2,   0,    0.2,   0,     0.4,  0,    0,    0, 	 0, 	 0.2, 	 0}
		mod.chainN[mod.NMSState.IDLE] = 	   {0,   0.2,  0.8,  0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0}
		mod.chainN[mod.NMSState.AMBUSH] = 	   {0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0,    1, 	 0, 	 0, 	 0}
		mod.chainN[mod.NMSState.REAPPEAR] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,   0.6,  0, 	 0.4, 	 0, 	 0}

		--stat changes--------------------------------------------------------------------------------------------------
		mod.NConst.SPEED = 2.025
		--shot
		mod.NConst.N_SHOTS = 6
		mod.NConst.N_EXTRA_SHOTS = 3
		mod.NConst.NORMAL_SHOT_SPEED = 10
		mod.NConst.SPECIAL_SHOT_SPEED = 13

		--tornado
		mod.NConst.N_ABSORBS = 35
		mod.NConst.N_TORNADO_RING = 10

		--rain
		mod.NConst.N_RAIN_DROP = 36
		mod.NConst.RAIN_DROP_RADIUS = 130

		--bubble splash
		mod.NConst.N_BUBBLE_SPLASH = 3
		mod.NConst.N_BUBBLE_RING = 12
		mod.NConst.BUBBLE_SPEED = 8
		mod.NConst.N_BUBBLE_END_SPLASH = 4

		--ambush
		mod.NConst.N_FAKERS = 6
		mod.NConst.N_AMBUSH_SPLASH = 3

		--bite

		--pixel
		mod.NConst.PIXEL_SPEED = 1.6
		mod.NConst.PIXEL_ANGULAR_SPEED = 0.01
		mod.NConst.FISH_DISSAPEAR_CHANCE = 0.5

    elseif difficulty == mod.Difficulties.ASCENDED then
		--                             			app  idl   deid  reid    shot   torn  rain   bubbb  down  up    ambus reap    noamb   gyro    bite
		mod.chainN[mod.NMSState.DEIDLE] = 	   {0,   0,    0,    0,      0.2,   0,    0.2,   0,     0.32,  0,    0,    0, 	 0, 	 0.28, 	 0}
		mod.chainN[mod.NMSState.IDLE] = 	   {0,   0.2,  0.7,  0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 0, 	 0.1}
		mod.chainN[mod.NMSState.AMBUSH] = 	   {0,   0,    0,    0,      0,     0,    0,     0,     0,    0,    0,    1,  	 0, 	 0, 	 0}
		mod.chainN[mod.NMSState.REAPPEAR] = 	{0,   0,    0,    0,      0,     0,    0,     0,     0,    0,   0.6,  0, 	 0.4, 	 0, 	 0}

		--mod.chainN[mod.NMSState.IDLE] = 	   {0,   0,	   0,    0,      0,     0,    0,     0,     0,    0,    0,    0, 	 0, 	 1, 	 1}

		--stat changes--------------------------------------------------------------------------------------------------
		mod.NConst.SPEED = 2.05
		--shot
		mod.NConst.N_SHOTS = 6
		mod.NConst.N_EXTRA_SHOTS = 5
		mod.NConst.NORMAL_SHOT_SPEED = 11
		mod.NConst.SPECIAL_SHOT_SPEED = 14

		--tornado
		mod.NConst.N_ABSORBS = 37
		mod.NConst.N_TORNADO_RING = 12

		--rain
		mod.NConst.N_RAIN_DROP = 48
		mod.NConst.RAIN_DROP_RADIUS = 160

		--bubble splash
		mod.NConst.N_BUBBLE_SPLASH = 4
		mod.NConst.N_BUBBLE_RING = 16
		mod.NConst.BUBBLE_SPEED = 9
		mod.NConst.N_BUBBLE_END_SPLASH = 5

		--ambush
		mod.NConst.N_FAKERS = 7
		mod.NConst.N_AMBUSH_SPLASH = 4

		--bite

		--pixel
		mod.NConst.PIXEL_SPEED = 1.75
		mod.NConst.PIXEL_ANGULAR_SPEED = 0.02
		mod.NConst.FISH_DISSAPEAR_CHANCE = 0.25

    end
end
--mod:SetNeptuneDifficulty(mod.savedatasettings().Difficulty)

--mod:TestChain(mod.NMSState, mod.chainN, {{"SHOT",4},{"ABSORB",5},{"RAIN",6},{"BUBBLE",7},{"AMBUSH",10},{"GYRO",13},{"BITE",14}})

mod.NeptunePixelarts = {
	{{1, Vector(4, 0)}, {1, Vector(5, 0)}, {1, Vector(6, 0)}, {1, Vector(7, 0)}, {1, Vector(2, 1)}, {2, Vector(3, 1)}, {3, Vector(4, 1)}, {3, Vector(5, 1)}, {3, Vector(6, 1)}, {3, Vector(7, 1)}, {2, Vector(8, 1)}, {1, Vector(9, 1)}, {1, Vector(1, 2)}, {2, Vector(2, 2)}, {1, Vector(3, 2)}, {1, Vector(8, 2)}, {2, Vector(9, 2)}, {1, Vector(10, 2)}, {2, Vector(1, 3)}, {1, Vector(2, 3)}, {1, Vector(9, 3)}, {2, Vector(10, 3)}, {1, Vector(0, 4)}, {3, Vector(1, 4)}, {3, Vector(10, 4)}, {1, Vector(11, 4)}, {1, Vector(0, 5)}, {3, Vector(1, 5)}, {3, Vector(10, 5)}, {1, Vector(11, 5)}, {1, Vector(0, 6)}, {3, Vector(1, 6)}, {3, Vector(10, 6)}, {1, Vector(11, 6)}, {1, Vector(0, 7)}, {3, Vector(1, 7)}, {3, Vector(10, 7)}, {1, Vector(11, 7)}, {2, Vector(1, 8)}, {1, Vector(2, 8)}, {1, Vector(9, 8)}, {2, Vector(10, 8)}, {1, Vector(1, 9)}, {2, Vector(2, 9)}, {1, Vector(3, 9)}, {1, Vector(8, 9)}, {2, Vector(9, 9)}, {1, Vector(10, 9)}, {1, Vector(2, 10)}, {2, Vector(3, 10)}, {3, Vector(4, 10)}, {3, Vector(5, 10)}, {3, Vector(6, 10)}, {3, Vector(7, 10)}, {2, Vector(8, 10)}, {1, Vector(9, 10)}, {1, Vector(4, 11)}, {1, Vector(5, 11)}, {1, Vector(6, 11)}, {1, Vector(7, 11)}},--circle

	{{1, Vector(4, 0)}, {2, Vector(5, 0)}, {2, Vector(6, 0)}, {1, Vector(7, 0)}, {1, Vector(3, 1)}, {2, Vector(4, 1)}, {2, Vector(7, 1)}, {1, Vector(8, 1)}, {1, Vector(2, 2)}, {2, Vector(3, 2)}, {2, Vector(8, 2)}, {1, Vector(9, 2)}, {1, Vector(1, 3)}, {2, Vector(2, 3)}, {2, Vector(9, 3)}, {1, Vector(10, 3)}, {1, Vector(0, 4)}, {2, Vector(1, 4)}, {2, Vector(10, 4)}, {1, Vector(11, 4)}, {2, Vector(0, 5)}, {2, Vector(11, 5)}, {3, Vector(0, 6)}, {3, Vector(11, 6)}, {1, Vector(0, 7)}, {3, Vector(1, 7)}, {3, Vector(10, 7)}, {1, Vector(11, 7)}, {1, Vector(1, 8)}, {3, Vector(2, 8)}, {3, Vector(9, 8)}, {1, Vector(10, 8)}, {1, Vector(2, 9)}, {3, Vector(3, 9)}, {3, Vector(8, 9)}, {1, Vector(9, 9)}, {1, Vector(3, 10)}, {3, Vector(4, 10)}, {3, Vector(7, 10)}, {1, Vector(8, 10)}, {1, Vector(4, 11)}, {3, Vector(5, 11)}, {3, Vector(6, 11)}, {1, Vector(7, 11)}},--square

	{{2, Vector(0, 0)}, {2, Vector(1, 0)}, {3, Vector(2, 0)}, {1, Vector(3, 0)}, {2, Vector(0, 1)}, {3, Vector(1, 1)}, {2, Vector(2, 1)}, {2, Vector(3, 1)}, {2, Vector(4, 1)}, {3, Vector(5, 1)}, {1, Vector(6, 1)}, {1, Vector(7, 1)}, {2, Vector(0, 2)}, {1, Vector(1, 2)}, {1, Vector(4, 2)}, {3, Vector(5, 2)}, {2, Vector(6, 2)}, {2, Vector(7, 2)}, {3, Vector(8, 2)}, {3, Vector(9, 2)}, {1, Vector(10, 2)}, {3, Vector(0, 3)}, {2, Vector(1, 3)}, {1, Vector(8, 3)}, {3, Vector(9, 3)}, {3, Vector(10, 3)}, {2, Vector(11, 3)}, {1, Vector(0, 4)}, {2, Vector(1, 4)}, {1, Vector(9, 4)}, {2, Vector(10, 4)}, {2, Vector(11, 4)}, {2, Vector(1, 5)}, {1, Vector(2, 5)}, {2, Vector(9, 5)}, {2, Vector(10, 5)}, {3, Vector(1, 6)}, {3, Vector(2, 6)}, {1, Vector(7, 6)}, {2, Vector(8, 6)}, {2, Vector(9, 6)}, {1, Vector(1, 7)}, {2, Vector(2, 7)}, {2, Vector(7, 7)}, {2, Vector(8, 7)}, {3, Vector(9, 7)}, {2, Vector(2, 8)}, {1, Vector(5, 8)}, {2, Vector(6, 8)}, {2, Vector(7, 8)}, {3, Vector(2, 9)}, {1, Vector(3, 9)}, {2, Vector(5, 9)}, {2, Vector(6, 9)}, {3, Vector(7, 9)}, {3, Vector(2, 10)}, {3, Vector(3, 10)}, {2, Vector(4, 10)}, {2, Vector(5, 10)}, {1, Vector(2, 11)}, {2, Vector(3, 11)}, {2, Vector(4, 11)}, {3, Vector(5, 11)}},--triangle
}

function mod:NeptuneUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR and entity.SubType == mod.EntityInf[mod.Entity.Neptune].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then
			data.State = 0
			data.StateFrame = 0

			data.AbsorbCount = 0

			--game:GetLevel():AddCurse(LevelCurse.CURSE_OF_DARKNESS)

			for i, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WISP)) do
				wisp:Remove()
			end

			if mod.savedatasettings().Difficulty > mod.Difficulties.NORMAL then
				mod:scheduleForUpdate(function()
					game:SetColorModifier(ColorModifier(0.5,0.5,1, 0.33, -0.1, 1))
				end, 120) 
			end
			

			data.Blood = false
			data.Steam = false
			data.Grotto = false
			data.Dross = false

			data.Tear = ProjectileVariant.PROJECTILE_TEAR

			if mod:IsWomb() then
				data.Blood = true
				data.Tear = ProjectileVariant.PROJECTILE_NORMAL
			end
			if mod:IsBoiler() then
				data.Steam = true
				data.Tear = ProjectileVariant.PROJECTILE_TEAR
			end
			if mod:IsGrotto() then
				data.Grotto = true
				data.Tear = ProjectileVariant.PROJECTILE_NORMAL
			end
			if mod:IsDross() then
				data.Dross = true
				data.Tear = ProjectileVariant.PROJECTILE_TEAR
			end

			if data.Blood then
				sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_shiny.png")
				sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/neptune/neptune_shiny.png")
				sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/neptune/neptune_shiny_eyes.png")
				sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/neptune/neptune_shiny_body.png")
				sprite:LoadGraphics()
			end
			if data.Steam then
				sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_boiler.png")
				sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/neptune/neptune_boiler.png")
				sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/neptune/neptune_boiler_eyes.png")
				sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/neptune/neptune_boiler_body.png")
				sprite:LoadGraphics()
			end
			if data.Grotto then
				sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_grotto.png")
				sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/neptune/neptune_grotto.png")
				sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/neptune/neptune_grotto_eyes.png")
				sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/neptune/neptune_grotto_body.png")
				sprite:LoadGraphics()
			end
			if data.Dross then
				sprite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_dross.png")
				sprite:ReplaceSpritesheet (3, "hc/gfx/bosses/neptune/neptune_dross.png")
				sprite:ReplaceSpritesheet (4, "hc/gfx/bosses/neptune/neptune_dross_eyes.png")
				sprite:ReplaceSpritesheet (5, "hc/gfx/bosses/neptune/neptune_dross_body.png")
				sprite:LoadGraphics()
			end

			mod:CheckEternalBoss(entity)
			
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		game:Darken(1,60)
		

		--water
		if entity.FrameCount < 100 then
			room:SetWaterAmount(math.max(room:GetWaterAmount(), (entity.FrameCount/100)^2))
		end
		
		if data.State == mod.NMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)

				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				mod:NeptuneStateChange(entity, sprite, data)
			elseif sprite:IsEventTriggered("EndAppear") then
				mod:EnableWeather(mod.WeatherFlags.RAIN)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		elseif data.State == mod.NMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle1",true)
				data.CurrentTargetPosition = target.Position
				entity:PlaySound(SoundEffect.SOUND_HEARTIN,1,0,false,mod:RandomInt(198,202)/1000);
			elseif sprite:IsFinished("Idle1") then
				sprite:Play("Idle2",true)
				data.CurrentTargetPosition = target.Position
				sfx:Play(SoundEffect.SOUND_HEARTIN,1,0,false,mod:RandomInt(198,202)/1000);
			elseif sprite:IsFinished("Idle2") then
				mod:NeptuneStateChange(entity, sprite, data)
				
			elseif sprite:GetFrame() < 15 then
				mod:NeptuneMove(entity, data, room, data.CurrentTargetPosition)
			end
		
		elseif data.State == mod.NMSState.DEIDLE then
			if data.StateFrame == 1 then
				sprite:Play("Derotate",true)
			elseif sprite:IsFinished("Derotate") then
				mod:NeptuneStateChange(entity, sprite, data)
				
			end
		elseif data.State == mod.NMSState.REIDLE then
			if data.StateFrame == 1 then
				sprite:Play("Rerotate",true)
			elseif sprite:IsFinished("Rerotate") then
				mod:NeptuneStateChange(entity, sprite, data)
				
			end
		elseif data.State == mod.NMSState.DOWN then
			if data.StateFrame == 1 then
				sprite:Play("Down",true)
				entity.CollisionDamage = 0
			elseif sprite:IsFinished("Down") then
				mod:NeptuneStateChange(entity, sprite, data)
			
			elseif sprite:IsEventTriggered("HideShadow") then
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
				sfx:Play(SoundEffect.SOUND_BOSS2_DIVE,1)

				if entity.Position:Distance(target.Position) > 60 then
					mod:SpawnSplash(entity, mod.NConst.N_UP_DOWN_SPLASH, mod.NConst.UP_DOWN_SPLASH_FALL)
				end
			
			end
		elseif data.State == mod.NMSState.UP then
			if data.StateFrame == 1 then
				sprite:Play("Up",true)
				entity.Position = room:GetCenterPos()
			elseif sprite:IsFinished("Up") then
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
				entity.CollisionDamage = 1
				mod:SpawnSplash(entity, mod.NConst.N_UP_DOWN_SPLASH, mod.NConst.UP_DOWN_SPLASH_FALL)
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1);

				mod:NeptuneStateChange(entity, sprite, data)
			end
		
		elseif data.State == mod.NMSState.SHOT then
			mod:NeptuneShot(entity, data, sprite, target, room)
		
		elseif data.State == mod.NMSState.ABSORB then
			mod:NeptuneAbsorb(entity, data, sprite, target, room)
		
		elseif data.State == mod.NMSState.RAIN then
			mod:NeptuneRain(entity, data, sprite, target, room)
			
		elseif data.State == mod.NMSState.BUBBLE then
			mod:NeptuneBubble(entity, data, sprite, target, room)
		
		elseif data.State == mod.NMSState.AMBUSH then
			mod:NeptuneAmbush(entity, data, sprite, target, room)

		elseif data.State == mod.NMSState.NOAMBUSHXD then
			if data.StateFrame == 1 then
				sprite:Play("Up",true)
				entity.CollisionDamage = 0
				local position = room:GetRandomPosition(0)
				while position:Distance(target.Position) < mod.NConst.MIN_DISTANCE_TO_REAPPEAR do
					position = room:GetRandomPosition(0)
				end
				entity.Position = position
			elseif sprite:IsFinished("Up") then
				sprite:Play("Bounce",true)
				entity.CollisionDamage = 1
				mod:SpawnSplash(entity, mod.NConst.N_UP_DOWN_SPLASH, mod.NConst.UP_DOWN_SPLASH_FALL)
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1);
			elseif sprite:IsFinished("Bounce") then
				mod:NeptuneStateChange(entity, sprite, data)
			end
		elseif data.State == mod.NMSState.REAPPEAR then
			mod:NeptuneStateChange(entity, sprite, data)
		elseif data.State == mod.NMSState.BITE then
			mod:NeptuneBite(entity, data, sprite, target, room)
		elseif data.State == mod.NMSState.GYRO then
			mod:NeptuneGyro(entity, data, sprite, target, room)
			
		end
        
        local xvel = entity.Velocity.X / 10
        sprite.Rotation = mod:Lerp(sprite.Rotation, 15*xvel, 0.1)

		if (not mod.CriticalState) and mod.savedatasettings().weather == 1 and entity.FrameCount % 3 == 0 then
			local rain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RAIN_DROP, 0, room:GetRandomPosition(0), Vector(0,0), entity):ToEffect()
		end
		
		--data.State = mod.NMSState.IDLE
		--data.StateFrame = 0

	end
	
end
function mod:NeptuneShot(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Shot",true)
	elseif sprite:IsFinished("Shot") then
		mod:NeptuneStateChange(entity, sprite, data)
	
	elseif sprite:IsEventTriggered("Shot") then
		local targetAim = target.Position - entity.Position
		for i=0, mod.NConst.N_SHOTS-1 do
			local angle = -mod.NConst.NORMAL_SHOT_ANGLE/2 + mod.NConst.NORMAL_SHOT_ANGLE / (mod.NConst.N_SHOTS-1) *i
			local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, targetAim:Normalized():Rotated(angle)*mod.NConst.NORMAL_SHOT_SPEED, entity):ToProjectile()
			water.FallingSpeed = 0
			water.FallingAccel = -0.1
			if data.Steam then
				water:GetData().RecolorToBoiler = true
			elseif data.Grotto then
				FFGRACE:MakeProjectileToMud(water)
			elseif data.Dross then
				water.Color = Color.TearNumberOne
			end
		end
		
		for i=0, mod.NConst.N_EXTRA_SHOTS-1 do	
			local angle = -mod.NConst.EXTRA_SHOT_ANGLE/2 + mod.NConst.EXTRA_SHOT_ANGLE / (mod.NConst.N_EXTRA_SHOTS-1) *i
			local water = mod:SpawnEntity(mod.Entity.DarkMatter, entity.Position, targetAim:Normalized():Rotated(angle)*mod.NConst.SPECIAL_SHOT_SPEED, entity):ToProjectile()
			water.FallingSpeed = 0
			water.FallingAccel = -0.1
			water:AddScale(mod.NConst.SPECIAL_SHOT_SCALE)	
		end
		local water = mod:SpawnEntity(mod.Entity.DarkMatter, entity.Position, targetAim:Normalized()*mod.NConst.SPECIAL_SHOT_SPEED, entity):ToProjectile()		
		water.FallingSpeed = 0
		water.FallingAccel = -0.1
		water:AddScale(mod.NConst.SPECIAL_SHOT_SCALE)		

		--sfx:Play(SoundEffect.SOUND_PING_PONG,2)
		sfx:Play(SoundEffect.SOUND_BLACK_POOF, 1, 2, false, 1.5)
		sfx:Play(SoundEffect.SOUND_MOTHER_SHOOT, 1, 2, false, 1.5)
	end
end
function mod:NeptuneAbsorb(entity, data, sprite, target, room)--actually a tornado
	entity.Position = room:GetCenterPos(0)
	entity.Velocity = Vector.Zero
	if data.StateFrame == 1 then
		sprite:Play("AbsorbBegin",true)
		sfx:Play(SoundEffect.SOUND_BOSS2_WATERTHRASHING,1)
        sfx:Play(Isaac.GetSoundIdByName("GiantsTornado"),1)
		
		entity.Friction = 1
		entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

		
		for _, i in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, data.Tear)) do
			i:Remove()
		end

	elseif sprite:IsFinished("AbsorbBegin") then
		
		sprite:Play("Absorb",true)
		local tornado = mod:SpawnEntity(mod.Entity.Tornado, entity.Position+Vector(0,1), Vector.Zero, entity)
		tornado:GetData().Lifespan = 9
		tornado:GetData().Height = 7
		tornado:GetData().Scale = 0.9
		tornado:GetData().FastSpawn = true
		
	elseif sprite:IsFinished("Absorb") then
	
		if data.AbsorbCount < mod.NConst.N_ABSORBS then
			data.AbsorbCount = data.AbsorbCount + 1
			sprite:Play("Absorb",true)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WHIRLPOOL, 1, entity.Position, Vector(0,0), entity):ToEffect()
			if data.StateFrame%20==0 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DOGMA_BLACKHOLE, 2, entity.Position, Vector(0,0), entity):ToEffect()
			end
			
			--Tears
			for i=1, mod.NConst.N_TORNADO_RING do
				if mod:RandomInt(0,20)<=2 then
					local velocity = mod:RandomInt(5,55)/10
					local targetAim = target.Position-entity.Position
					local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, targetAim:Normalized()*velocity, entity):ToProjectile()
					water.Scale = mod:RandomInt(1,120)/100
					water.FallingSpeed = 0
					water.FallingAccel = -0.1

					mod:TearFallAfter(water, 30*5)
							
					if data.Steam then
						water:GetData().RecolorToBoiler = true
					elseif data.Grotto then
						FFGRACE:MakeProjectileToMud(water)
					elseif data.Dross then
						water.Color = Color.TearNumberOne
					end
				end
				
			end
		else
			data.AbsorbCount = 0
			entity.Friction = 0.8
			entity:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			entity:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			
			mod:NeptuneStateChange(entity, sprite, data)
			
		end
		
	end
	if sprite:IsPlaying("Absorb") then
		
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			if not player.CanFly then
				local spinVector = player.Position - entity.Position
				player.Velocity = player.Velocity + Vector(-0.016*spinVector.Y, 0.008*spinVector.X-0.008*spinVector.Y)
			end
		end
		
	end
end
function mod:NeptuneRain(entity, data, sprite, target, room)
	if data.StateFrame == 1 then

		for i, fish in ipairs(mod:FindByTypeMod(mod.Entity.NemoFish)) do
			fish:ToProjectile():AddProjectileFlags(ProjectileFlags.TRACTOR_BEAM)
		end

		sprite:Play("Rain",true)
	elseif sprite:IsFinished("Rain") then
		mod:NeptuneStateChange(entity, sprite, data)
	
	elseif sprite:IsEventTriggered("Rain") then
		game:ShakeScreen(15)
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)

		for i=0, mod.NConst.N_RAIN_DROP do
			local angle = 360*rng:RandomFloat()
			local position = target.Position + Vector(math.sqrt(mod:RandomInt(0,mod.NConst.RAIN_DROP_RADIUS^2)),0):Rotated(angle)
			--Rain projectiles:
			local dropParams = ProjectileParams()
			dropParams.Scale = mod:RandomInt(1,100)/100
			dropParams.FallingAccelModifier = 2
			dropParams.ChangeTimeout = 3
			dropParams.HeightModifier = -mod:RandomInt(380,1200)
			dropParams.Variant = data.Tear
			
			local projectiles = entity:FireProjectilesEx(position, Vector.Zero, 0, dropParams)
			if data.Steam then
				for i, water in ipairs(projectiles) do
					water:GetData().RecolorToBoiler = true
				end
			elseif data.Grotto then
				for i, water in ipairs(projectiles) do
					FFGRACE:MakeProjectileToMud(water)
				end
			elseif data.Dross then
				for i, water in ipairs(projectiles) do
					water.Color = Color.TearNumberOne
				end
			end
		end
		sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH,1)
	end
end
function mod:NeptuneBubble(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("Bounce",true)
	elseif sprite:IsFinished("Bounce") then
		sprite:Play("Bubble",true)
		sfx:Play(Isaac.GetSoundIdByName("Inflation"),1)
		data.StateFrame = 1
		entity.Friction = 1
	elseif sprite:IsFinished("Bubble") then
		entity.Friction = 0.8
		mod:SpawnSplash(entity, mod.NConst.N_BUBBLE_END_SPLASH, mod.NConst.BUBBLE_END_SPLASH_FALL)
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1,2,false,2.4)

		mod:NeptuneStateChange(entity, sprite, data)
	
	elseif data.StateFrame <= 90 and data.StateFrame%25==0 then
		local offset = 360*rng:RandomFloat()
		for i=1, mod.NConst.N_BUBBLE_RING do
			local angle = i*360/mod.NConst.N_BUBBLE_RING + offset
			local water = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, data.Tear, 0, entity.Position, Vector(1,0):Rotated(angle)*mod.NConst.BUBBLE_SPEED, entity):ToProjectile()
			water.FallingSpeed = 0
			water.FallingAccel = -0.1

			if data.Steam then
				water:GetData().RecolorToBoiler = true
			elseif data.Grotto then
				FFGRACE:MakeProjectileToMud(water)
			elseif data.Dross then
				water.Color = Color.TearNumberOne
			end
		end
		mod:SpawnSplash(entity, mod.NConst.N_BUBBLE_SPLASH, mod.NConst.BUBBLE_SPASH_FALL)
		
	elseif sprite:IsEventTriggered("BubbleWave") then
		sfx:Play(SoundEffect.SOUND_BOSS2_WATERTHRASHING,1,2,false,1);
	end

end
function mod:NeptuneAmbush(entity, data, sprite, target, room)
	if data.StateFrame == 1 then

		for i, fish in ipairs(mod:FindByTypeMod(mod.Entity.NemoFish)) do
			fish:ToProjectile():AddProjectileFlags(ProjectileFlags.TRACTOR_BEAM)
		end

		sprite:Play("Up",true)
		entity.CollisionDamage = 0
		local position = room:GetRandomPosition(0)
		while position:Distance(target.Position) < mod.NConst.MIN_DISTANCE_TO_REAPPEAR do
			position = room:GetRandomPosition(0)
		end
		entity.Position = position

		for i=1,mod.NConst.N_FAKERS do
			local position = Vector.Zero
			local fakers = mod:FindByTypeMod(mod.Entity.NeptuneFaker)
			local validPos = false

			local counter = 0
			while not validPos and counter < 100 do
				position = room:GetRandomPosition(0)

				for i, faker in ipairs(fakers) do
					if faker.Position:Distance(position) < 80 then
						validPos = false
						break
					end
					validPos = true
				end
			
				counter = counter + 1
			end

			local faker = mod:SpawnEntity(mod.Entity.NeptuneFaker, position, Vector.Zero, entity)
			local fpsrite = faker:GetSprite()
			
			
			if mod:ShouldBossBeEternal(entity) then
				fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_eternal.png")
				fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_eternal_body.png")
				fpsrite:LoadGraphics()
			elseif data.Blood then
				fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_shiny.png")
				fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_shiny_body.png")
				fpsrite:LoadGraphics()
			elseif data.Steam then
				fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_boiler.png")
				fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_boiler_body.png")
				fpsrite:LoadGraphics()
			elseif data.Grotto then
				fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_grotto.png")
				fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_grotto_body.png")
				fpsrite:LoadGraphics()
			elseif data.Dross then
				fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_dross.png")
				fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_dross_body.png")
				fpsrite:LoadGraphics()
			end
			fpsrite:Play("Up",true)
			faker.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			faker:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end

		game:Darken(1,60)

		local stereo = math.cos((entity.Position - target.Position):GetAngleDegrees()*3.1415/180)
		sfx:Play(SoundEffect.SOUND_BEAST_SUCTION_END, 1.15, 2, false, 2, stereo)

		data.SpeedBoost = 1

	elseif sprite:IsFinished("Up") then
		sprite:Play("Waiter1",true)
		entity.CollisionDamage = 1
		data.AimPosition = target.Position
	elseif sprite:IsFinished("Waiter1") then
		if mod.savedatasettings().Difficulty == mod.Difficulties.ASCENDED then
			sprite:Play("Waiter3",true)
		else
			sprite:Play("Waiter2",true)
		end
	elseif sprite:IsFinished("Waiter3") then
		data.AimPosition = target.Position
		sprite:Play("Waiter2",true)
	elseif sprite:IsFinished("Waiter2") then
		mod:NeptuneStateChange(entity, sprite, data)
		entity.CollisionDamage = 0
	
	elseif sprite:IsEventTriggered("Ambush") then
		mod:SpawnSplash(entity, mod.NConst.N_AMBUSH_SPLASH, mod.NConst.AMBUSH_SPLASH_FALL)
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
		entity.Velocity = (data.AimPosition - entity.Position):Normalized()*mod.NConst.AMBUSH_SPEED*data.SpeedBoost
		
		data.SpeedBoost = 0.67
		
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION,1);
		
		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.NeptuneFaker)) do
			i:Remove()
		end
	elseif sprite:IsEventTriggered("Chomp") then
		sfx:Play(Isaac.GetSoundIdByName("Chomp"),2,0,false,0.7)
		
	end
end
function mod:NeptuneBite(entity, data, sprite, target, room)
	if data.StateFrame == 1 then

		for i, fish in ipairs(mod:FindByTypeMod(mod.Entity.NemoFish)) do
			fish:ToProjectile():AddProjectileFlags(ProjectileFlags.TRACTOR_BEAM)
		end

		sprite:Play("Bite",true)
		data.nBites = 0
		data.biteNIdles = 0
		data.makeInvisible = nil
		data.targetAim = nil
		data.SpeedMult = 0.75

	elseif sprite:IsFinished("EvilIdle") then
		if data.biteNIdles > mod.NConst.BITE_N_IDLES then
			sprite:Play("Bite",true)
			data.biteNIdles = 0
		else
			data.biteNIdles = data.biteNIdles + 1
			sprite:Play("EvilIdle",true)
		end

	elseif sprite:IsFinished("Bite") then
		if data.nBites > mod.NConst.N_BITES then
			mod:NeptuneStateChange(entity, sprite, data)
		else
			data.nBites = data.nBites + 1
			sprite:Play("EvilIdle",true)

			
			local newPos = target.Position + mod:RandomVector(mod.NConst.TELE_DISTANCE, mod.NConst.TELE_DISTANCE)
			for i=1, 100 do
				if room:IsPositionInRoom(newPos, 0) then break end
				newPos = target.Position + mod:RandomVector(mod.NConst.TELE_DISTANCE, mod.NConst.TELE_DISTANCE)
			end
			entity.Position = newPos
			data.makeInvisible = false

			
			local ogAngle = (newPos-target.Position):GetAngleDegrees()
			for i=1,mod.NConst.BITE_N_FAKERS do
				
				local angle = ogAngle + i*360/(mod.NConst.BITE_N_FAKERS+1)
				local newPos = target.Position + Vector.FromAngle(angle)*mod.NConst.TELE_DISTANCE

				local faker = mod:SpawnEntity(mod.Entity.NeptuneFaker, newPos, Vector.Zero, entity, nil, mod.EntityInf[mod.Entity.NeptuneFaker].SUB+1)
				local fpsrite = faker:GetSprite()
				if mod:ShouldBossBeEternal(entity) then
					fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_eternal.png")
					fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_eternal_body.png")
					fpsrite:LoadGraphics()
				elseif data.Blood then
					fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_shiny.png")
					fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_shiny_body.png")
					fpsrite:LoadGraphics()
				elseif data.Steam then
					fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_boiler.png")
					fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_boiler_body.png")
					fpsrite:LoadGraphics()
				elseif data.Grotto then
					fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_grotto.png")
					fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_grotto_body.png")
					fpsrite:LoadGraphics()
				elseif data.Dross then
					fpsrite:ReplaceSpritesheet (0, "hc/gfx/bosses/neptune/neptune_dross.png")
					fpsrite:ReplaceSpritesheet (1, "hc/gfx/bosses/neptune/neptune_dross_body.png")
					fpsrite:LoadGraphics()
				end
				fpsrite:Play("Idle",true)
				faker.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				faker:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	
	elseif sprite:IsEventTriggered("EndAppear") then
		data.targetAim = (target.Position - entity.Position):Normalized()

	elseif sprite:IsEventTriggered("Ambush") then
		sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH, 2)
		sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 1)

		local targetAim = data.targetAim or (target.Position - entity.Position):Normalized()
		entity.Velocity = targetAim * mod.NConst.BITE_SPEED * data.SpeedMult
		data.SpeedMult = 1

		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.NeptuneFaker, nil, mod.EntityInf[mod.Entity.NeptuneFaker].SUB+1)) do
			i:Remove()
		end
	
	elseif sprite:IsEventTriggered("Chomp") then
		sfx:Play(Isaac.GetSoundIdByName("Chomp"),2,0,false,0.7)

		if data.nBites <= mod.NConst.N_BITES then
			data.makeInvisible = true
		end
	end

	if sprite:WasEventTriggered("Ambush") and not sprite:WasEventTriggered("Chomp") then
		if entity.FrameCount % 3 == 0 then
			local targetAim = data.targetAim or (target.Position - entity.Position):Normalized()
			local angle = targetAim:GetAngleDegrees()
			local projectiles = mod:SpawnSplash(entity, mod.NConst.N_BITE_SPLASH, mod.NConst.UP_DOWN_SPLASH_FALL, 1)
			for i, tear in pairs(projectiles) do
				tear.Velocity = tear.Velocity:Rotated(angle)
			end
		end
	end

	if data.makeInvisible == true then
		sprite.Color = Color.Lerp(sprite.Color, Color(1,1,1,0), 0.1)
	elseif data.makeInvisible == false then
		sprite.Color = Color.Lerp(sprite.Color, Color.Default, 0.1)
	end

	for _, faker in ipairs(mod:FindByTypeMod(mod.Entity.NeptuneFaker, nil, mod.EntityInf[mod.Entity.NeptuneFaker].SUB+1)) do
		faker:GetSprite().Color = sprite.Color
	end
end
function mod:NeptuneGyro(entity, data, sprite, target, room)
	if data.StateFrame == 1 then
		sprite:Play("GyroStart",true)

		for i, fish in ipairs(mod:FindByTypeMod(mod.Entity.NemoFish)) do
			fish:ToProjectile():AddProjectileFlags(ProjectileFlags.TRACTOR_BEAM)
		end
	elseif sprite:IsFinished("GyroStart") then
		sprite:Play("GyroEnd",true)

		--attack
		local spin = 1-2*mod:RandomInt(0,1)
		spin = spin * mod.NConst.PIXEL_ANGULAR_SPEED

		local list = mod.NeptunePixelarts[mod:RandomInt(1, #mod.NeptunePixelarts)]
		for i, entry in ipairs(list) do
			if rng:RandomFloat() > mod.NConst.FISH_DISSAPEAR_CHANCE then
				local fishType = entry[1]
				local point = entry[2]

				--local newPoint = (point - Vector(8,8)):Rotated(rng:RandomFloat()*360)
				--local newPoint = (point - Vector(8,8)):Rotated(mod:RandomInt(-45,45))
				local newPoint = (point - 6*Vector.One)
				local longPoint = newPoint*mod.NConst.PIXEL_SPEED
				local velocity = longPoint - newPoint
				local position = newPoint + entity.Position

				local fish = mod:SpawnEntity(mod.Entity.NemoFish, position, velocity, entity):ToProjectile()
				fish:GetData().Fish = fishType
				fish:GetData().Spin = spin
				fish.Parent = entity
				fish:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
				mod:TearFallAfter(fish, 150)

				fish.Height = -7
			end
		end

		
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position+Vector(0,1), Vector.Zero, entity)
		sfx:Play(SoundEffect.SOUND_BOSS2_DIVE,1)
		
		local n = 7
		for i=1, n, n-1 do
			mod:scheduleForUpdate(function()
				sfx:Play(SoundEffect.SOUND_BIG_LEECH,1, 2, false, 2)
				mod:scheduleForUpdate(function()
					sfx:Play(SoundEffect.SOUND_LEECH, 1, 2, false, 2)
				end, i+n)
			end, i)
		end

	elseif sprite:IsFinished("GyroEnd") then
		mod:NeptuneStateChange(entity, sprite, data)
	
	end
end

--State Change
function mod:NeptuneStateChange(entity, sprite, data)
	local ogState = data.State

	entity.Color = Color.Default
	data.makeInvisible = nil


	data.State = mod:MarkovTransition(data.State, mod.chainN)
	data.StateFrame = 0

	if ogState == mod.NMSState.AMBUSH and data.State == mod.NMSState.BITE and entity.Position:Distance(entity:GetPlayerTarget().Position)< 200 then
		data.State = mod.NMSState.REAPPEAR
	end

	if data.State == mod.NMSState.ABSORB then
		local flag = true
		for i=0, game:GetNumPlayers ()-1 do
			local player = game:GetPlayer(i)
			flag = flag and player.CanFly
		end
		if flag then
			data.State = mod.NMSState.BUBBLE
		end
	end
end

--Move
function mod:NeptuneMove(entity, data, room, targetPosition)
	--If Neptune is slowed down, it moves ridiculously fast
	if not (entity:HasEntityFlags(EntityFlag.FLAG_SLOW)) then 
		data.targetvelocity = ((targetPosition - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
		
		--Do the actual movement
		entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.NConst.SPEED
		data.targetvelocity = data.targetvelocity * 0.9
	end
	
	--I dont know how to check if the hourglass effect is active, so the next if solves it 😎
	if entity.Velocity:Length() > 40 then
		entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, 0.1)
	end
end

--ded
function mod:NeptuneDeath(entity)
	
	if entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR and entity.SubType == mod.EntityInf[mod.Entity.Neptune].SUB then

		for _, i in ipairs(mod:FindByTypeMod(mod.Entity.NeptuneFaker)) do
			i:Remove()
		end
		
		sfx:Play(Isaac.GetSoundIdByName("Pop"),100);

		mod:NormalDeath(entity)
		
		mod:SpawnSplash(entity, 5, mod.NConst.UP_DOWN_SPLASH_FALL*1.5, nil, mod.Colors.neptuneWater)
		
		game:GetRoom():SetWaterAmount(0)
		
		mod:DisableWeather(mod.WeatherFlags.RAIN)

		if entity.I1 then
			music:Fadeout()

			local persistentGameData = Isaac.GetPersistentGameData()
			persistentGameData:TryUnlock(Isaac.GetAchievementIdByName("card_foil (HC)"), false)
		end
	end

end
--deding
function mod:NeptuneDying(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Neptune].VAR and entity.SubType == mod.EntityInf[mod.Entity.Neptune].SUB then
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if data.deathFrame == nil then data.deathFrame = 1 end

		if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
			data.deathFrame = data.deathFrame + 1
			if data.deathFrame == 1 then
				sprite.Rotation = 0
			elseif sprite:IsEventTriggered("DeathSplash") then 
				mod:DyingSplash(entity)
				
			elseif sprite:IsEventTriggered("DeathCry") then
				sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,2,2,false,2)
				if #(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER))==0 and not (data.Blood or data.Steam or data.Dross or data.Grotto) then
					local water = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER, 0, entity.Position, Vector.Zero, entity)
					water:GetSprite().Color = mod.Colors.neptuneWater
				end
			end
		end
	end
end
function mod:DyingSplash(entity)
	local waterParams = ProjectileParams()
	waterParams.Variant = entity:GetData().Tear
	waterParams.FallingAccelModifier = mod.NConst.UP_DOWN_SPLASH_FALL*3.5
	waterParams.Color = mod.Colors.neptuneWater
	for i = 1, 5 do
		local angle = 360*rng:RandomFloat()
		local projectiles = entity:FireBossProjectilesEx (3, entity.Position + Vector(1,0):Rotated(angle), 0, waterParams )
		if mod:IsBoiler() then
			for i, water in ipairs(projectiles) do
				water:GetData().RecolorToBoiler = true
			end
		elseif mod:IsGrotto() then
			for i, water in ipairs(projectiles) do
				FFGRACE:MakeProjectileToMud(water)
			end
		elseif mod:IsDross() then
			for i, water in ipairs(projectiles) do
				water.Color = Color.TearNumberOne
			end
		end
	end
end

--Do a splash of water
function mod:SpawnSplash(entity, amount, falling, nSplash, color, variant)
	variant = variant or ProjectileVariant.PROJECTILE_TEAR
	nSplash = nSplash or mod.NConst.N_SPLASH
	color = color or Color.Default
	for i=1, nSplash do
		local waterParams = ProjectileParams()
		waterParams.Variant = variant
		if mod:IsWomb() then
			waterParams.Variant = ProjectileVariant.PROJECTILE_NORMAL
		end
		if mod:IsBoiler() then
			waterParams.Variant = ProjectileVariant.PROJECTILE_TEAR
		else
			waterParams.Color = color
		end
		waterParams.FallingAccelModifier = falling

		local angle = i*360/nSplash
		local projectiles = entity:FireBossProjectilesEx (amount, entity.Position + Vector(1,0):Rotated(angle), 0, waterParams)
		if mod:IsBoiler() then
			for i, water in ipairs(projectiles) do
				water:GetData().RecolorToBoiler = true
			end
		elseif mod:IsGrotto() then
			for i, water in ipairs(projectiles) do
				FFGRACE:MakeProjectileToMud(water)
			end
		elseif mod:IsDross() then
			for i, water in ipairs(projectiles) do
				water.Color = Color.TearNumberOne
			end
		end
		if nSplash == 1 then
			return projectiles
		end
	end
end

--Callbacks
--Neptune updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.NeptuneUpdate, mod.EntityInf[mod.Entity.Neptune].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.NeptuneDeath, mod.EntityInf[mod.Entity.Neptune].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.NeptuneDying, mod.EntityInf[mod.Entity.Neptune].ID)

function mod:IsBoiler()
	return FFGRACE and FFGRACE.STAGE.Boiler:IsStage()
end
function mod:IsDross()
	return (game:GetLevel():GetStage()==LevelStage.STAGE1_1 or game:GetLevel():GetStage()==LevelStage.STAGE1_2) and game:GetLevel():GetStageType()==StageType.STAGETYPE_REPENTANCE_B
end
function mod:IsWomb()
	return (game:GetLevel():GetStage()==LevelStage.STAGE4_1 or game:GetLevel():GetStage()==LevelStage.STAGE4_2) or mod.ModFlags.blood_room
end
function mod:IsGrotto()
	return FFGRACE and FFGRACE.STAGE.Grotto:IsStage()
end

--OTHERS------------------------
--Tornado
function mod:TornadoUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.Tornado].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()

		if data.Lifespan == nil then data.Lifespan = 12 end
		if data.Height == nil then data.Height = 6 end
		if data.Scale == nil then data.Scale = 0.5 end
		if data.Duped == nil then data.Duped = false end
		if data.OriginalPos == nil then data.OriginalPos = entity.Position end
		if data.Frame == nil then data.Frame = 0 end
		if data.FlagForSpawn == nil then data.FlagForSpawn = false end
		if data.Velocity == nil then data.Velocity = Vector.Zero end

		if not data.Init then
			data.Init = true
			sprite.Scale = Vector(1,1)*data.Scale

			if not data.IsGiants then
				if mod:IsWomb() then
					sprite:ReplaceSpritesheet (0, "hc/gfx/effects/tornado_shiny.png")
					sprite:LoadGraphics()
				end
				if mod:IsBoiler() then
					sprite:ReplaceSpritesheet (0, "hc/gfx/effects/tornado_boiler.png")
					sprite:LoadGraphics()
				end
				if mod:IsGrotto() then
					sprite:ReplaceSpritesheet (0, "hc/gfx/effects/tornado_grotto.png")
					sprite:LoadGraphics()
				end
				if mod:IsDross() then
					sprite:ReplaceSpritesheet (0, "hc/gfx/effects/tornado_dross.png")
					sprite:LoadGraphics()
				end
			end
		end

		if data.FlagForSpawn then
			data.FlagForSpawn = false
			if not data.Duped and data.Height > 0 then
				data.Duped = true
				local tornado = mod:SpawnEntity(mod.Entity.Tornado, data.OriginalPos+Vector(0,-32*data.Scale), Vector.Zero, entity)
				tornado:GetSprite().Color = sprite.Color
				tornado:GetData().Lifespan = data.Lifespan
				tornado:GetData().Height = data.Height - 1
				tornado:GetData().Scale = data.Scale * 1.3
				tornado:GetData().Velocity = data.Velocity
				tornado:GetData().IsGiants = data.IsGiants
				tornado.DepthOffset = entity.DepthOffset + 44
			end
		end

		if sprite:IsFinished("Appear") then
			sprite:Play("Idle",true)
			data.FlagForSpawn = true
		elseif sprite:IsEventTriggered("FastSpawn") and data.FastSpawn then
			data.FlagForSpawn = true
		elseif sprite:IsFinished("Idle") then
			if data.Lifespan > 0 then
				data.Lifespan = data.Lifespan - 1
				sprite:Play("Idle",true)

			else
				sprite:Play("Death",true)
			end
		elseif sprite:IsFinished("Death") then
			entity:Remove()
		end

		--Waving
		local angle = data.Frame/(data.Scale)
		entity.Position = data.OriginalPos + Vector(10*data.Scale,0)*math.sin(angle)
		data.OriginalPos = data.OriginalPos + data.Velocity/2
		data.Frame = data.Frame + 1

		--Rain
		if data.Rain and entity.FrameCount%3==0 then
			for i=0, mod.QConst.N_RAIN_DROP/5 do
				local angle = 360*rng:RandomFloat()
				local position = entity.Position + Vector(math.sqrt(mod:RandomInt(0,mod.QConst.RAIN_DROP_RADIUS^2)),0):Rotated(angle)
				--Rain projectiles:
				local dropParams = ProjectileParams()
				dropParams.Scale = mod:RandomInt(1,100)/100
				dropParams.FallingAccelModifier = 2
				dropParams.ChangeTimeout = 3
				dropParams.HeightModifier = -mod:RandomInt(380,1200)
				dropParams.Variant = ProjectileVariant.PROJECTILE_TEAR
				dropParams.Color = sprite.Color
				
				if entity.Parent then
					entity.Parent:ToNPC():FireProjectiles(position, Vector.Zero, 0, dropParams)
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.TornadoUpdate, mod.EntityInf[mod.Entity.Tornado].VAR)

--Dark Matter------------------------------------------------------------------------------------------------------------------------------
function mod:DarkMatterUpdate(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.DarkMatter].SUB then
        local data = tear:GetData()
        local sprite = tear:GetSprite()
        local parent = tear.Parent

		if data.Init == nil then
			data.Init = true
			--Sprite
			sprite:Play("Idle", true)
			sprite.Rotation = rng:RandomFloat()*360

			
			if mod:IsBoiler() then
				data.RecolorToBoiler = true
			elseif mod:IsGrotto() then
				FFGRACE:MakeProjectileToMud(tear)
			end


		end

		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector.Zero, nil)
            cloud:GetSprite().Color = Color(0,0,0,1)

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.DarkMatterUpdate, mod.EntityInf[mod.Entity.DarkMatter].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.DarkMatterUpdate, mod.EntityInf[mod.Entity.DarkMatter].VAR)

--Nemo fish------------------------------------------------------------------------------------------------------------------------------
function mod:NemoFishUpdate(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.NemoFish].SUB then
        local data = tear:GetData()
        local sprite = tear:GetSprite()
        local parent = tear.Parent

		if data.Init == nil then
			data.Init = true
			data.Fish = data.Fish or 1
			data.Spin = data.Spin or 0
			data.CurrentFish = data.CurrentFish or 1

			sprite.PlaybackSpeed = 0.5 + rng:RandomFloat()

			--Sprite
			sprite:Play("Idle1", true)

			if parent and (parent:GetData().Blood or parent:GetData().Steam or parent:GetData().Grotto) then
				sprite:ReplaceSpritesheet(0, "hc/gfx/projectiles/nemo_fish_red.png")
				sprite:ReplaceSpritesheet(2, "hc/gfx/projectiles/nemo_fish_red.png")
				sprite:ReplaceSpritesheet(1, "hc/gfx/projectiles/nemo_fish_white_red.png")
				sprite:ReplaceSpritesheet(3, "hc/gfx/projectiles/nemo_fish_white_red.png")
				sprite:LoadGraphics()

				data.Red = true
			elseif parent and parent:GetData().Dross then
				sprite:ReplaceSpritesheet(0, "hc/gfx/projectiles/nemo_fish_dross.png")
				sprite:ReplaceSpritesheet(2, "hc/gfx/projectiles/nemo_fish_dross.png")
				sprite:ReplaceSpritesheet(1, "hc/gfx/projectiles/nemo_fish_white_dross.png")
				sprite:ReplaceSpritesheet(3, "hc/gfx/projectiles/nemo_fish_white_dross.png")
				sprite:LoadGraphics()

				data.Dross = true
			end

		end

		if data.CurrentFish < data.Fish and tear.FrameCount % 15 == 0 then
			data.CurrentFish = data.CurrentFish + 1
			sprite:Play("Idle"..tostring(data.CurrentFish), true)
		end

		sprite.Rotation = tear.Velocity:GetAngleDegrees()

		tear.Velocity = tear.Velocity + data.Spin*tear.Velocity:Rotated(90)

		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then

			for i=1, 3 do
				local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BULLET_POOF, 0, tear.Position, mod:RandomVector(5,0), nil)
				if data.Red then
					blood:SetColor(Color(1,1,0,1,0.5,0,0), -1, 1, false, false)
				elseif data.Dross then
					blood:SetColor(Color.TearNumberOne, -1, 1, false, false)
				else
					blood:SetColor(Color(0,1,1,1,0,0,0.5), -1, 1, false, false)
				end
			end

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.NemoFishUpdate, mod.EntityInf[mod.Entity.NemoFish].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.NemoFishUpdate, mod.EntityInf[mod.Entity.NemoFish].VAR)

--MIRROR
function mod:OnNeptuneMirrorUpdate(entity)
	if entity.SubType == mod.EntityInf[mod.Entity.NeptuneMirrorTimer].SUB then
		local room = game:GetRoom()
		local data = entity:GetData()

		if entity.FrameCount < 5 then return end

		if not data.Init then
			data.Init = true
			data.Frame = 0

			local flag = false
			for i = 0, DoorSlot.NUM_DOOR_SLOTS do
				local door = room:GetDoor(i)
				if door and door.TargetRoomIndex == -100 and door:GetSprite():GetAnimation() ~= 'Break' then
					entity.Position = door.Position
					flag  = true
				end
			end

			for i=0, game:GetNumPlayers ()-1 do
				local player = game:GetPlayer(i)
				if player and player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B or player:HasInstantDeathCurse() then
					flag = false
				end
			end

			if game:GetLevel():GetDimension() == Dimension.MIRROR then
				flag = false
			end

			if not flag then
				entity:Remove()
				return
			end
		end

		local hour = mod:GetDateTime().hour
		if hour == 3 then
			data.Frame = data.Frame + 1
			if data.Frame > 30*5 then
				mod.ModFlags.blood_room = true
				local neptune = mod:SpawnEntity(mod.Entity.Neptune, entity.Position, Vector.Zero, nil):ToNPC()
				neptune.I1 = 1
				neptune:Update()

				local ndata = neptune:GetData()
				neptune.MaxHitPoints = neptune.MaxHitPoints*0.5
				neptune.HitPoints = neptune.MaxHitPoints
				neptune.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				ndata.State = mod.NMSState.BITE
				ndata.StateFrame = 0

				mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.RedTrapdoor))
				music:Crossfade (mod.Music.ERRANT, 2)
				music:Queue(mod.Music.ERRANT)

				room:SetWaterColor(KColor(1,-1,-1,0.5))

				room:EmitBloodFromWalls(20, 10)

				entity:Remove()
				game:BombExplosionEffects (entity.Position, 0, TearFlags.TEAR_NORMAL, Color(1,1,1,0), nil, 0, true, false, DamageFlag.DAMAGE_EXPLOSION )

				local gridSize = room:GetGridSize()
				for i=0, gridSize do
                	local grid = room:GetGridEntity(i)
					if grid then
						local gridType = grid:GetType()
						if (GridEntityType.GRID_ROCK <= gridType and gridType <= GridEntityType.GRID_ROCK_ALT) or (GridEntityType.GRID_LOCK <= gridType and gridType <= GridEntityType.GRID_POOP) or (GridEntityType.GRID_STATUE <= gridType and gridType <= GridEntityType.GRID_ROCK_SS) or (GridEntityType.GRID_LOCK <= gridType and gridType <= GridEntityType.GRID_POOP) or (GridEntityType.GRID_PILLAR <= gridType and gridType <= GridEntityType.GRID_ROCK_GOLD) then
							if gridType == GridEntityType.GRID_ROCKB or gridType == GridEntityType.GRID_PILLAR then
								sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1.5, 2, false, 1.25)
								game:SpawnParticles (grid.Position, EffectVariant.ROCK_PARTICLE, 10, 5)
								room:RemoveGridEntity(grid:GetGridIndex (), 0, true)
							else
								grid:Destroy()
							end
						end
					end
				end
				
                for i, fire in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
                    fire:Die()
                end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnNeptuneMirrorUpdate, mod.EntityInf[mod.Entity.NeptuneMirrorTimer].VAR)