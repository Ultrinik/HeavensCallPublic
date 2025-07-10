local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()
local music = MusicManager()

--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%##%%&@@@@
@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#/    (%&@@@
@@@@@&%#  *#%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#/       #%&@@
@@@@@%#     /(%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#/        ,#%@@@
@@@@&%(       /(%&@@@@@@&@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%#/          (#&@@@
@@@@@&#*        /(#&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%(/           (#&@@@@
@@@@@&%#.          /(%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%#(             /#&@@@@@
@@@@@&%#(*            /(#%&&@@@@@@@@@@@@@@@@&&&&%&%%%%%%%%%%%%%%%%%%&&&&&&&&@@@@@@@@@@@@@@@&&%(/               *((#%&@@@
@@@&%#.                   /(#%%&&&@@@&&&&&%%%%#######################%%%%%%&&&&&&&&&%&&&%%#(/                .      .%&@
@@@%#                         ,/((#%%%%%%##(// ///((((//(////////((((((#####%%####(,   **.          .               (%&@
@@@&%#(                             (###((/   ,, **.#    #         **////((((/                                    /#%&@@
@@@@@@&%%#(/*,                     */(((/*,                              ****  *///.                            /(%&@@@@
@@@@@@@&%#(*                       ,***/*        (          #                 ,*//*,                          .*/(#%&&@@
@@@@@@&%(                           .,          ,                               **,,                               .%&@@
@@@@@@&%(                                     .   ##(.    ,(#* #                  .                                (%&@@
@@@@@@@@&%##(//*,.                          ##                    #                                              (#%&@@@
@@@@@@@@@@@&%%(/                         #                        #   *                                  .,*/(#%%&@@@@@@
@@@@@@@@@@@@%#/                       .   (                        .    #                                  /(%&%@@@@@@@@
@@@@@@@@@@@&%#                       (   *                           /    /                                 (#&@@@@@@@@@
@@@@@@@@@@@@%%#, .**,.                               @                .    #                                 #%@@@@@@@@@
@@@@@@@@@@@@@@&&%%#(*                 #        @@@@@@@@@@@@@@(  ,&      /   #                        ,/(#(#%%&@@@@@@@@@@
@@@@@@@@@@@@@@@@@&%#/             #        @@@@@%            *&@@@&&&    .                           /#%&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&@@@&%#(/**,,       .(     &@,    #%    /&              &    * (                .,*. ,#%%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&%##(((((/*,      *    /&      &   &.   ,,          #       *(           ,,   /(#%%&&@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&%#       ((//*,    #   %#      &   %  ,   &        @           .         ,,*//(##&&&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&(  (((/  (((//* #       %&      @   *    %      #@*          #  /          ./(##&&&@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@&#  ##  #####(//*            &     @(   @.   /@              #     ,     .   /(#%&&@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&&&&&&&%%%#(%//*     /       #%@@,,,,,. #     & % %       (       (       *(#%%&@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@&&&%%%((//**    .       &       *&&%(.    *#,     #           ,   */(#%&&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@&%&&%%%##(/*......#....                        /            ,*#/((#%%&&@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&&&%%##((/**,      #                     #.             ,**/((#%%&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@&&&%%%##((/**,         .##/      (##                ,**//((#%%&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@&@@@@@@@@@@@@@@@@@@@@@&&&&%%##(/*,   .                              .,,**/((##%%&&&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&%%%#(*   .***,,                        ,**/(((##%%&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&%#(/    *//**,,   ,,,,,,,,,,******//(((###   %&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&###*           *////////((((((####%%%%%%%%&&@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%##(((((((###########%%%%%%%&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
mod.SolState = {
	APPEAR = 0,
	IDLE = 1,

    LASER = 2,
    ZODIAC = 3,
    CROSSED = 4,
    STARFALL = 5,
    SPRAY = 6,
    GAPER = 7,
    TIME = 8,
    BLAST = 9,
    TELEPORT = 10,
    BLASTER_A = 11,
    BLASTER_B = 12,
    FOCUS = 13,
    HELL = 14,
    HOMING = 15,
    DASH = 16,
    SNAKE = 17,
    SHINE = 18,
    SWORD = 19,

    SLASH = 20,
    SMASH = 21,
    GUN = 22,

}

--First number is how many Idle cycles is Sol forced to do after that attack, the second number is the chance for chosing that state
mod.ChainSolBase0 = {                
    [mod.SolState.APPEAR] = {5, -1},
    [mod.SolState.IDLE] = {0, 1},

    [mod.SolState.TELEPORT] =   {2, 0},

    [mod.SolState.LASER] =      {3, 0.1},
    [mod.SolState.ZODIAC] =     {2, 0},
    [mod.SolState.CROSSED] =    {2, 0.1}, --
    [mod.SolState.STARFALL] =   {6, 0.1}, --
    [mod.SolState.SPRAY] =      {3, 0.1}, --
    [mod.SolState.GAPER] =      {4, 0.1}, --
    [mod.SolState.TIME] =       {1, 0},
    [mod.SolState.BLAST] =      {1, 0},
    [mod.SolState.BLASTER_A] =  {4, 0},
    [mod.SolState.BLASTER_B] =  {1, 0},
    [mod.SolState.FOCUS] =      {4, 0},
    [mod.SolState.HELL] =       {4, 0},
    [mod.SolState.HOMING] =     {3, 0.1}, --
    [mod.SolState.DASH] =       {3, 0},
    [mod.SolState.SNAKE] =      {3, 0},
    [mod.SolState.SHINE] =      {2, 0},
    [mod.SolState.SWORD] =      {5, 0.1}, --

    [mod.SolState.SLASH] =      {1, 0.1}, --
    [mod.SolState.SMASH] =      {1, 0.1}, --
    [mod.SolState.GUN] =        {1, 0.1}, --
}
mod.ChainSolBase1 = {                
    [mod.SolState.APPEAR] = {5, -1},
    [mod.SolState.IDLE] = {0, 1},

    [mod.SolState.TELEPORT] =   {2, 0}, --

    [mod.SolState.LASER] =      {6, 0.1}, --
    [mod.SolState.ZODIAC] =     {2, 0.07}, --
    [mod.SolState.CROSSED] =    {2, 0},
    [mod.SolState.STARFALL] =   {6, 0.1}, --
    [mod.SolState.SPRAY] =      {3, 0.1}, --
    [mod.SolState.GAPER] =      {4, 0.09}, --
    [mod.SolState.TIME] =       {1, 0},
    [mod.SolState.BLAST] =      {1, 0},
    [mod.SolState.BLASTER_A] =  {8, 0},
    [mod.SolState.BLASTER_B] =  {1, 0.1}, --
    [mod.SolState.FOCUS] =      {4, 0},
    [mod.SolState.HELL] =       {4, 0},
    [mod.SolState.HOMING] =     {3, 0},
    [mod.SolState.DASH] =       {6, 0.1}, --
    [mod.SolState.SNAKE] =      {6, 0.05}, --
    [mod.SolState.SHINE] =      {4, 0.05}, --
    [mod.SolState.SWORD] =      {4, 0.09}, --
    
    [mod.SolState.SLASH] =      {1, 0.05}, --
    [mod.SolState.SMASH] =      {1, 0.05}, --
    [mod.SolState.GUN] =        {1, 0.05}, --
}
mod.ChainSolBase2 = {                
    [mod.SolState.APPEAR] = {5, -1},
    [mod.SolState.IDLE] = {0, 1},

    [mod.SolState.TELEPORT] =   {2, 0}, --

    [mod.SolState.LASER] =      {4, 0.1}, --
    [mod.SolState.ZODIAC] =     {4, 0.1}, --
    [mod.SolState.CROSSED] =    {2, 0.06}, --
    [mod.SolState.STARFALL] =   {6, 0.06}, --
    [mod.SolState.SPRAY] =      {2, 0},
    [mod.SolState.GAPER] =      {4, 0},
    [mod.SolState.TIME] =       {1, 0.08}, --
    [mod.SolState.BLAST] =      {5, 0.08}, --
    [mod.SolState.BLASTER_A] =  {8, 0.0},
    [mod.SolState.BLASTER_B] =  {1, 0.06}, --
    [mod.SolState.FOCUS] =      {2, 0},
    [mod.SolState.HELL] =       {5, 0.05}, --
    [mod.SolState.HOMING] =     {3, 0.07}, --
    [mod.SolState.DASH] =       {5, 0.08}, --
    [mod.SolState.SNAKE] =      {6, 0.07}, --
    [mod.SolState.SHINE] =      {2, 0},
    [mod.SolState.SWORD] =      {4, 0.07}, --
    
    [mod.SolState.SLASH] =      {1, 0.04}, --
    [mod.SolState.SMASH] =      {1, 0.04}, --
    [mod.SolState.GUN] =        {1, 0.04}, --
}
mod.ChainSolBase3 = {                
    [mod.SolState.APPEAR] = {5, -1},
    [mod.SolState.IDLE] = {0, 1},

    [mod.SolState.TELEPORT] =   {2, 0},

    [mod.SolState.LASER] =      {2, 0.2}, --
    [mod.SolState.ZODIAC] =     {2, 0},
    [mod.SolState.CROSSED] =    {2, 0},
    [mod.SolState.STARFALL] =   {6, 0},
    [mod.SolState.SPRAY] =      {2, 0},
    [mod.SolState.GAPER] =      {4, 0},
    [mod.SolState.TIME] =       {1, 0.15}, --
    [mod.SolState.BLAST] =      {6, 0.2}, --
    [mod.SolState.BLASTER_A] =  {8, 0},
    [mod.SolState.BLASTER_B] =  {1, 0},
    [mod.SolState.FOCUS] =      {2, 0},
    [mod.SolState.HELL] =       {3, 0.2}, --
    [mod.SolState.HOMING] =     {3, 0},
    [mod.SolState.DASH] =       {3, 0},
    [mod.SolState.SNAKE] =      {3, 0},
    [mod.SolState.SHINE] =      {2, 0.05}, --
    [mod.SolState.SWORD] =      {2, 0.2}, --
    
    [mod.SolState.SLASH] =      {0, 0},
    [mod.SolState.SMASH] =      {0, 0},
    [mod.SolState.GUN] =        {0, 0},
}

for i=0, 3 do
    local entry = mod["ChainSolBase"..tostring(i)]
    local total = 0
    for key, dic in ipairs(entry) do
        if not (key == mod.SolState.APPEAR or key == mod.SolState.IDLE) then
            total = total + dic[2]
        end
    end
    if  0.0001 < total - 1.0 or total - 1.0 < -0.0001 then print("WARNING, Solar chain #"..tostring(i)..":", total) end
end

mod.SolConst = {

    SPEED_0 = 0.1,
    SPEED_1 = 0.05,
    SPEED_2 = 1.25,

    FIRST_UMBRAL = 0.75,
    SECOND_UMBRAL = 0.5,
    THRID_UMBRAL = 0.25,

    SAD_CHANCE = 0.2,
    NEUTRAL_CHANCE = 0.034,
    ANGRY_CHANCE = 0.2,

    SOLAR_PARCTICLE = 20,
    WISP_SPEED = Vector(20,10),
    
    FEATHERS_PARTICLES = 20,
    FEATHERS_PARTICLES_MINI = 5,
    FEATHERS_SPEED = Vector(20,10),
    MINI_FEATHERS_SCALAR = 1.3,

    --hands
    MAX_SOL_HAND_DIST = 20,

    --movement
    DISTANCE_0 = 450,
    INTERVAL_0 = Vector(30, 60),

    INTERVAL_2 = Vector(50, 70),
    CENTER_DISTANCE_TOLERATION = 200,

    --spray
    N_SPRAY_WAVES = 3,
    N_SPRAY_NUMS = 5,
    SPRAY_STEP_ANGLE = 8,
    SPRAY_SPEED = 5,

    --zodiac
    ZODIAC_TRACE_AMOUNT = 28,--even
    N_ZODIACS = 3,
    ZODIAC_RING = 7,
    ZODIAC_RING_SPEED = 7,

    --crossed
    N_BURST = 8,
    BURST_ANGLE = 70,
    BURST_ANGLE_VAR = 20,
    BURST_SPEED_1 = 7.5,
    BURST_SPEED_2 = 20,

    --laser
    LASER_RINGS = 3,
    LASER_AMOUNT_RING = 8,
    LASER_SPEED = 10,
    LASER_IDLES = 3,
    LASER_TIMEOUT = 45,
    LASER_WARNIGNS = 3,
    LASER_SPIN_SPEED = 1,

    --starfall
    N_STARFALLS = 3,
    STARFALL_TIMER = 45,

    --gaper
    N_SUMMONS = 6,

    --time
    TIME_VENT_TIME = 20,

    --blast
    BLAST_SPEED = 7,
    BLAST_RING = 8,
    BLAST_WAVES = 4,

    --teleports
    N_TELEPORTS = 2,
    TELEPORT_SPEED = 9,
    TELEPORT_RING = 5,
    TELE_CHANCE_1 = 1/30,
    TELE_CHANCE_2 = 1/60,

    --blasters A
    N_BLASTER_A = 18,
    BLASTER_ANGLE = 20,
    BLASTER_DISTANCE = 200,

    --blasters B
    N_BLASTER_B = 7,
    BLASTER_SPACING = 95,
    BLASTER_IDLES = 1,

    --focus
    N_GALAXIES = 6,

    --hell
    HELL_TIMER = 30*5,
    HELL_FREQ = 6,
    HELL_FREQ2 = 24,
    HELL_FREQ3 = 96,
    HELL_NUM = 7,
    HELL_SPEED = 5,

    --homing
    HOMING_RING = 4,
    HOMING_SPEED = 5,
    HOMING_DIST = 150,

    --dash
    DASH_SPEED = 25,
    AMOUNT_DASH = 10,
    DASH_F = 10,
    DASH_TEAR_SPEED = 7,

    --snake
    SNAKE_SPEED = 30,
    SNAKE_STAR_SPEED = 4,
    SNAKE_TIMEOUT = 30*7,
    SNAKE_AMOUNT = 8,

    --shine
    SHINE_SPEED = 0.3,
    SHINE_AMOUNT = 3, --x2
    SHINE_TIMEOUT = 30*10,
    SHINE_TRIGGER_ANGLE = 30,

    --sword
    SWORD_IDLES = 4,
    SWORD_PROJ_SPEED = 5,

    --slash
    SLASH_CHANCE = 0.5,
    SLASH_FEATHER_SPEED = 10,
    N_SLASH_FEATHERS = 5,

    --smash
    SMASH_FEATHER_SPEED = 10,
    N_SMASH_FEATHERS = 10,
}

mod.SolZodiacs = {
    --ARIES
    [1] = {{Vector(13, 29), Vector(66,50), Vector(83,63), Vector(85, 72)}},
    --TAURUS
    [2] = {{Vector(18,26), Vector(49, 48), Vector(53,52), Vector(55,57), Vector(66,63), Vector(84,67), Vector(87,70)},
            {Vector(11,42), Vector(43,54), Vector(49,55), Vector(55,57)}},
    --GEMINI
    [3] = {{Vector(19,39),Vector(25,44),Vector(36,60),Vector(38,77),Vector(63,89)},
            {Vector(67,78),Vector(47,65),Vector(36,60)},
            {Vector(28,27),Vector(43,33),Vector(62,50),Vector(78,58),Vector(84,58),Vector(90,55)},
            {Vector(62,50),Vector(74,65)},
            {Vector(19,51),Vector(25,44),Vector(34,40),Vector(43,33),Vector(55,22)}},
    --CANCER
    [4] = {{Vector(48,15),Vector(50,43),Vector(49,56),Vector(64,74),Vector(74,87)},
            {Vector(36,77),Vector(49,56)}},
    --LEO
    [5] = {{Vector(12,59),Vector(30,47),Vector(60,49),Vector(61,41),Vector(73,35),Vector(76,40),Vector(84,41),Vector(88,34)},
            {Vector(23,59),Vector(30,58),Vector(65,66),Vector(65,56),Vector(60,49)}},
    --VIRGO
    [6] = {{Vector(11,47),Vector(30,48),Vector(42,52),Vector(65,53),Vector(74,51),Vector(86,47),Vector(87,39),Vector(80,36),Vector(74,51)},
            {Vector(13,60),Vector(26,61),Vector(42,52)},
            {Vector(48,69),Vector(53,60),Vector(65,53),Vector(59,45),Vector(57,32)}},
    --LIBRA
    [7] = {{Vector(26,43),Vector(40,35),Vector(53,19),Vector(74,41),Vector(64,69)},
            {Vector(39,84),Vector(40,78),Vector(64,69),Vector(53,19)}},
    --SCORPIO
    [8] = {{Vector(25,64),Vector(19,74),Vector(26,82),Vector(39,80),Vector(48,78),Vector(49,65),Vector(50,57),Vector(58,40),Vector(63,35),Vector(69,32),Vector(82,26),Vector(79,18)},
            {Vector(83,43),Vector(82,34),Vector(82,26)}},
    --SAGGITARIUS
    [9] = {{Vector(19,50),Vector(13,38),Vector(29,29),Vector(40,34),Vector(70,52),Vector(86,58),Vector(64,76),Vector(19,50),Vector(40,34),Vector(63,26),Vector(70,52),Vector(64,76)}},
    --CAPRICORN
    [10] = {{Vector(14,43),Vector(22,45),Vector(46,45),Vector(83,31),Vector(81,37),Vector(73,50),Vector(60,71),Vector(56,76),Vector(31,62),Vector(22,53),Vector(14,43)}},
    --AQUARIUS
    [11] = {{Vector(10,76),Vector(11,53),Vector(13,45),Vector(25,48),Vector(44,48),Vector(41,35),Vector(50,32)},
            {Vector(16,79),Vector(11,53)},
            {Vector(24,66),Vector(11,53)},
            {Vector(27,62),Vector(25,48)},
            {Vector(50,62),Vector(44,48)},
            {Vector(33,31),Vector(37,32),Vector(41,35)},
            {Vector(93,54),Vector(68,44),Vector(50,32)},
            {Vector(39,28),Vector(50,32)}},
    --PISCES
    [12] = {{Vector(37,31),Vector(34,25),Vector(38,20),Vector(37,31),Vector(27,48),Vector(20,60),Vector(12,70),Vector(23,66),Vector(40,63),Vector(71,65),Vector(80,67),Vector(86,64),Vector(91,71),Vector(86,75),Vector(79,74),Vector(80,67)}}
}

function mod:SolUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Sol].VAR and entity.SubType == mod.EntityInf[mod.Entity.Sol].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
        local pDistance = (game:GetPlayer(0).Position - entity.Position):Length()
		
        --entity.HitPoints = entity.MaxHitPoints
        --entity.HitPoints = 201
        --entity.HitPoints = entity.MaxHitPoints/2
        --entity.HitPoints = entity.MaxHitPoints*math.sin(entity.FrameCount*math.pi/180*2)^2+1
        --sfx:Stop(SoundEffect.SOUND_ZOMBIE_WALKER_KID)
        --entity.HitPoints = 1

        --print(data.State)

        --data.State = mod.SolState.IDLE
        --data.StateFrame = 1

        --entity.Velocity = Vector(math.sin(entity.FrameCount/30)*10, 0)
        --entity.Position = room:GetCenterPos()

		--Custom data:
		if data.State == nil then

			data.State = 0
			data.StateFrame = 0
            data.TargetPos = Vector.Zero
            data.TriggeredScreen = false

            data.WingVelocity = Vector.Zero

            data.GrowFlag = false
            data.GrowSize = 0

            --data.Test = 0
            data.HpPercent = 0
            data.HpPercentSqrd = 0

            data.eyeSprite = Sprite()
            data.eyeSprite:Load("hc/gfx/entity_SolEye.anm2", true)
            data.eyeSprite:Play("Idle", true)

            data.Chain = mod.ChainSolBase0
            data.IdleWaits = 1

            data.ShaderSpeed = 1

            --burh

            data.nGridWaits = 0

            --render?
            data.OffsetPosition = Vector.Zero

            --hands
            mod:RestoreSolHands(entity)

			mod.ShaderData.solData.ETERNAL = mod:CheckEternalBoss(entity)
		end
        --data.State = mod.SolState.IDLE
        mod.ShaderData.solData.EYESPRITE = data.eyeSprite

        data.HpPercent = 1-entity.HitPoints/entity.MaxHitPoints
        data.HpPercentSqrd = data.HpPercent*data.HpPercent

        --Frame
        data.OffsetPosition = Vector.Zero
		data.StateFrame = data.StateFrame + 1
        local hp = entity.HitPoints

        --Chain
        if entity.HitPoints > entity.MaxHitPoints*mod.SolConst.FIRST_UMBRAL then
            data.Chain = mod.ChainSolBase0

            local a = entity.HitPoints - entity.MaxHitPoints*mod.SolConst.FIRST_UMBRAL
            local b = entity.MaxHitPoints - entity.MaxHitPoints*mod.SolConst.FIRST_UMBRAL
            data.hpInterval = a/b
            
            data.hpStage = 0 + (1-data.hpInterval)
        elseif entity.HitPoints > entity.MaxHitPoints*mod.SolConst.SECOND_UMBRAL then
            data.Chain = mod.ChainSolBase1

            local a = entity.HitPoints - entity.MaxHitPoints*mod.SolConst.SECOND_UMBRAL
            local b = entity.MaxHitPoints*mod.SolConst.FIRST_UMBRAL - entity.MaxHitPoints*mod.SolConst.SECOND_UMBRAL
            data.hpInterval = a/b
            
            data.hpStage = 1 + (1-data.hpInterval)
        elseif entity.HitPoints > entity.MaxHitPoints*mod.SolConst.THRID_UMBRAL then
            data.Chain = mod.ChainSolBase2

            local a = entity.HitPoints - entity.MaxHitPoints*mod.SolConst.THRID_UMBRAL
            local b = entity.MaxHitPoints*mod.SolConst.SECOND_UMBRAL - entity.MaxHitPoints*mod.SolConst.THRID_UMBRAL
            data.hpInterval = a/b
            
            data.hpStage = 2 + (1-data.hpInterval)
        else
            data.Chain = mod.ChainSolBase3
            
            data.hpInterval = 0

            entity.Position = mod:Lerp(entity.Position, room:GetCenterPos()-Vector(0,90), 0.01)
            entity.Velocity = Vector.Zero
            
            data.hpStage = 3
        end
        
        local hpStage = data.hpStage + (mod.savedatasettings().Difficulty)*1.5

        --hpStage = 50
		
		if data.State == mod.SolState.APPEAR then
            mod:SolAppear(entity, data, sprite, target, room, hpStage)
		elseif data.State == mod.SolState.IDLE then
            mod:SolIdle(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.SPRAY then
            mod:SolSpray(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.ZODIAC then
            mod:SolZodiac(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.CROSSED then
            mod:SolCrossed(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.LASER then
            mod:SolLaser(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.STARFALL then
            mod:SolStarfall(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.GAPER then
            mod:SolGaper(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.TIME then
            mod:SolTime(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.BLAST then
            mod:SolBlast(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.TELEPORT then
            mod:SolTeleport(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.BLASTER_A then
            mod:SolBlasterA(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.BLASTER_B then
            mod:SolBlasterB(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.FOCUS then
            mod:SolFocus(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.HELL then
            if data.Hell == nil then
                sfx:Play(SoundEffect.SOUND_SIREN_SCREAM_ATTACK, 1, 2, false, 0.67)
                sfx:Play(SoundEffect.SOUND_BEAST_SPIT, 1, 2, false, 1.5)
                data.Hell = data.Hell or mod:RandomInt(1,3)
            end
            if data.Hell == 1 then
                mod:SolHell(entity, data, sprite, target, room, hpStage)
            elseif data.Hell == 2 then
                mod:SolHell2(entity, data, sprite, target, room, hpStage)
            elseif data.Hell == 3 then
                mod:SolHell3(entity, data, sprite, target, room, hpStage)
            end
        elseif data.State == mod.SolState.HOMING then
            mod:SolHoming(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.DASH then
            mod:SolDash(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.SNAKE then
            mod:SolSnake(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.SHINE then
            mod:SolShine(entity, data, sprite, target, room, hpStage)
        elseif data.State == mod.SolState.SWORD then
            
            mod:ChanceSolHandsStates(entity, target, mod.SolHandState.SWORD, false)
            mod:SolSword(entity, data, sprite, target, room, hpStage)

        elseif data.State == mod.SolState.SLASH then
            if data.StateFrame == 1 then
                if entity.Position:Distance(target.Position) > 300 then
                    mod:ChanceSolHandsStates(entity, target, mod.SolHandState.SLASH, true)
                end
                mod:SolChangeState(entity, data, mod.SolState.IDLE)
            end
        elseif data.State == mod.SolState.SMASH then
            if data.StateFrame == 1 then
                if entity.Position:Distance(target.Position) > 300 then
                    mod:ChanceSolHandsStates(entity, target, mod.SolHandState.SMASH, true)
                end
                mod:SolChangeState(entity, data, mod.SolState.IDLE)
            end
        elseif data.State == mod.SolState.GUN then
            if data.StateFrame == 1 then
                --mod:ChanceSolHandsStates(entity, target, mod.SolHandState.GUN, true)
                --mod:SolChangeState(entity, data, mod.SolState.IDLE)

                data.StateFrame = 0
                if rng:RandomFloat() < 0.5 then
                    data.State = mod.SolState.SLASH
                else
                    data.State = mod.SolState.SMASH
                end
            end
        end

        mod:SolEyeSpriteUpdate(entity, data.eyeSprite)

        --background
        local wombs = mod:FindByTypeMod(mod.Entity.Background)
        for i, background in ipairs(wombs) do
            local bsprite = background:GetSprite()

            local hppercent = data.HpPercentSqrd
            hppercent = hppercent*hppercent
            
            local newColor = Color(1,0,0, 0.9, 0,-0.5,-1)
            
            local bId = background:GetData().bId
            if bId then
                bsprite.PlaybackSpeed = 1 + hppercent*i/4

                local h = hppercent
                if bId == 1 or bId == 3 then 
                    newColor.R = 0
                    newColor.G = 0
                end
                bsprite.Color = Color.Lerp(Color.Default, newColor, h)

                bsprite.Rotation = bsprite.Rotation + 0.05*i*(1+h)
            end
        end

        --Update solData
        mod.ShaderData.solData.POSITION = entity.Position + mod.ShaderData.solData.HPSIZE*Vector(0,-100) + data.OffsetPosition
        mod.ShaderData.solData.TRUEPOSITION = entity.Position
        mod.ShaderData.solData.TIME = mod.ShaderData.solData.TIME + data.ShaderSpeed*(1+data.hpStage/3)
        --rotation offset
        mod.ShaderData.solData.ROTATIONOFFSET = 0

        if data.GrowFlag then -- hp = 18750 -> size = 0
            mod.ShaderData.solData.ENABLED = true

            local maximum = 47
            if sprite:IsPlaying("Appear") then maximum = 16 end

            data.GrowSize = math.min(maximum,data.GrowSize + 2)
            mod.ShaderData.solData.HPSIZE = (data.GrowSize/maximum + 0.0472) * 0.5833 / 1.0472
            
            mod.ShaderData.solData.CORONACOLOR = Color(1,1,1,1)
            mod.ShaderData.solData.BODYCOLOR = Color(1,1,1,1)

            if data.GrowSize >= maximum then
                data.GrowFlag = false
            end

            data.OffsetPosition = Vector(0,-100)*mod.ShaderData.solData.HPSIZE

            --Others
            sprite.Color = Color(1,1,1, 1, 2,2,1)
            data.Color = sprite.Color
            
            local size = 1.75*0.5833
            entity.SpriteScale = Vector.One*size
            entity.Scale = size
            entity:SetSize(80*0.5833, Vector(1.25,0.75), 12)
            
        elseif data.State ~= mod.SolState.APPEAR then
            mod.ShaderData.solData.ENABLED = true

            --mod.ShaderData.solData.HPSIZE = -hp/15000 + 1.25
			local healthSize = 0.583 + data.HpPercentSqrd*0.667
			local m = 1.49925
			local b = -0.874063
			healthSize = m*healthSize + b
			healthSize = healthSize^1
			healthSize = (healthSize-b)/m
            mod.ShaderData.solData.HPSIZE = healthSize
            
            local color1 = Color.Lerp(Color(1,1,1), Color(0.8,0,0), data.HpPercent)
            local color2 = Color.Lerp(Color(1,1,1), Color(0.75,0.33,0), data.HpPercent)
            color2 = Color.Lerp(color2, Color(1,1,0), data.HpPercent/7)
    
            mod.ShaderData.solData.CORONACOLOR = color1
            mod.ShaderData.solData.BODYCOLOR = color2
    
            --Others
            local whiteColor = Color(1,1,1,1, 1,1,1)
            local yellowColor = Color(1,0.75,0,1, 1,1,0)
            local redColor = Color(1,0.1,0,1, 1,0,0)

            local finalColor = Color.Lerp(whiteColor, yellowColor, data.HpPercentSqrd)
            finalColor = Color.Lerp(finalColor, redColor, data.HpPercentSqrd)

            data.Color = finalColor
            --data.Color = Color(1,1,1, 1, hp/(entity.MaxHitPoints/2), hp/(entity.MaxHitPoints/2), hp/entity.MaxHitPoints)
            sprite.Color = data.Color
    
            local size = 1.75*mod.ShaderData.solData.HPSIZE
            entity.SpriteScale = Vector.One*size
            entity.Scale = size
            entity:SetSize(100*mod.ShaderData.solData.HPSIZE, Vector(1.25,0.75), 12)
    
        end

        --mod.ShaderData.solData.ENABLED = false

        --particles
        if (not mod.CriticalState) and entity.FrameCount % 2==0 then
            local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y) + entity.Velocity
            local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity)
        end

        --wings
        if true or entity.Velocity:Length() > 4 or data.hpStage >= 3 then
            data.WingVelocity = mod:Lerp(data.WingVelocity, entity.Velocity, 0.5)

            local layerWingR = sprite:GetLayer(4)
            local layerWingL = sprite:GetLayer(3)

            local xFactor = math.max(-1, math.min(1, data.WingVelocity.X/19))

            local hpsize = mod.ShaderData.solData.HPSIZE
            local xOffset = xFactor^3 * (hpsize + 1) * 15

            --print(xFactor, hpsize+1, xOffset)

            layerWingR:SetPos(Vector(-xOffset, 0))
            layerWingL:SetPos(Vector(-xOffset, 0))
            
            layerWingR:SetSize(Vector(1 - 0.5*xFactor, 1))
            layerWingL:SetSize(Vector(1 + 0.5*xFactor, 1))

        end

        --Isaac.DebugString(data.State)
        --Isaac.DebugString(data.StateFrame)

        --entity.Visible = false
        --entity.Position = game:GetRoom():GetBottomRightPos()
        --sprite.Color = Color(1,1,1,0)
        
        --print("sol upd", entity.I1 == 1)
    end
end
function mod:SolRender(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Sol].VAR and entity.SubType == mod.EntityInf[mod.Entity.Sol].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local room = game:GetRoom()

        local hpsize = mod.ShaderData.solData.HPSIZE or 0
        local offset = data.OffsetPosition or Vector.Zero
        mod.ShaderData.solData.POSITION = entity.Position + hpsize*Vector(0,-100) + offset
        mod.ShaderData.solData.TRUEPOSITION = entity.Position
    end
end
function mod:SolRenderUpdate()
    if mod.ShaderData.solData.ENABLED then
        local room = game:GetRoom()
        
        local eyeSprite = mod.ShaderData.solData.EYESPRITE
        if mod.ShaderData.solData.ROTATIONOFFSET == -1 then
            eyeSprite:Render(room:WorldToScreenPosition(mod.ShaderData.solData.TRUEPOSITION))
            return
        end
        
        local hpsize = mod.ShaderData.solData.HPSIZE

        local position = room:WorldToScreenPosition(mod.ShaderData.solData.POSITION) + Vector(0, 100)*hpsize
        local scale = Vector.One*hpsize*2.0
        local target = Isaac.GetPlayer(0)

        local targetPos = mod.ShaderData.solData.EYETARGET or target.Position
        local solTruePos = mod.ShaderData.solData.TRUEPOSITION

        eyeSprite.Scale = scale

        local offset = (targetPos - solTruePos):Normalized()*scale*16*hpsize
        mod.ShaderData.solData.EYEOFFSET = mod.ShaderData.solData.EYEOFFSET or offset
        mod.ShaderData.solData.EYEOFFSET = mod:VectorLerp(mod.ShaderData.solData.EYEOFFSET, offset, 0.25)

        local offset_pupil = mod.ShaderData.solData.EYEOFFSET + (targetPos - solTruePos):Normalized()*scale*14*hpsize
        offset_pupil.Y = offset_pupil.Y*0.67

        --eyeSprite:Render(position)
        eyeSprite:RenderLayer(1, position + mod.ShaderData.solData.EYEOFFSET);--EYE
        eyeSprite:RenderLayer(2, position + offset_pupil);--PUPIL
        eyeSprite:Update()

    end
end

function mod:SolAppear(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)

    if data.StateFrame == 1 then
        mod:AppearPlanet(entity)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES do
                local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end

    elseif sprite:GetFrame()==60 or (sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow")) then
        if entity.FrameCount > 147 or data.SkippedIntro then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        end
        if not data.TriggeredScreen then
            data.TriggeredScreen = true
            mod:ShowBattleScreen(entity)
        end
    end
    
    if sprite:IsEventTriggered("EndAppear") then
        data.GrowFlag = false

    elseif sprite:IsEventTriggered("StartAppear") then
        data.GrowFlag = true
        data.GrowSize = 0
        sprite.PlaybackSpeed = 1.9167
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

    end
end

function mod:SolIdle(entity, data, sprite, target, room, hpStage)
    sprite.PlaybackSpeed = 1

    mod:SolLookAt(entity, target.Position)

    if data.StateFrame == 1 then
        sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        local pDistance = target.Position:Distance(entity.Position)
        sfx:Play(SoundEffect.SOUND_DOGMA_WING_FLAP, math.min(1,math.max(0,100/pDistance)))

        data.IdleWaits = math.max(0,data.IdleWaits-1)

        if data.IdleWaits == 0 then
            mod:SolChangeState(entity, data, nil)
            --mod:SolChangeState(entity, data, mod.SolState.IDLE)
            --mod:SolChangeState(entity, data, mod.SolState.SHINE)

            --sfx:Play(SoundEffect.SOUND_1UP)
        end
        data.StateFrame = 0

        if rng:RandomFloat() < mod.SolConst.NEUTRAL_CHANCE then
            mod:SolSpeak("neutral", data.hpStage)
        end
        
    else
        mod:SolMove(entity, data, sprite, target, room, hpStage)
    end
end

function mod:SolEyeSpriteUpdate(entity, sprite)

    if sprite:IsPlaying("Idle") then
        if entity.FrameCount%120==0 then
            sprite:Play("Blink", true)
        elseif rng:RandomFloat() < 1/(30*10) then
            --sprite:Play("Big", true)
        end

    elseif sprite:IsFinished() then
        sprite:Play("Idle", true)
    end
end

function mod:SolMove(entity, data, sprite, target, room, hpStage)
    hpStage = math.floor(data.hpStage)
    if hpStage == 0 then
        data.MoveVector = data.MoveVector or Vector(mod.SolConst.DISTANCE_0, 0):Rotated(rng:RandomFloat()*360)
        mod:SolMove0(entity, data, sprite, target, room)
    elseif hpStage == 1 then
        mod:SolMove1(entity, data, sprite, target, room)
    elseif hpStage == 2 then
        mod:SolMove2(entity, data, sprite, target, room)
    end
end
function mod:SolMove0(entity, data, sprite, target, room)

    if not data.MoveInterval then
        data.MoveInterval = data.MoveInterval or mod:RandomInt(mod.SolConst.INTERVAL_0.X, mod.SolConst.INTERVAL_0.Y)

        if rng:RandomFloat() < 0.5 then
            data.MoveTargetVector = Vector(mod.SolConst.DISTANCE_0, 0):Rotated(mod:RandomInt(-45,45))
            data.MoveTrueTargetVector = Vector(mod.SolConst.DISTANCE_0, 0)
        else
            data.MoveTargetVector = Vector(mod.SolConst.DISTANCE_0, 0):Rotated(180+mod:RandomInt(-45,45))
            data.MoveTrueTargetVector = Vector(-mod.SolConst.DISTANCE_0, 0)
        end
    end

    local outside = mod:IsOutsideRoom((target.Position + data.MoveTargetVector), room)
    data.MoveInterval = data.MoveInterval - 1
    if data.MoveInterval < 0 or outside then 
        data.MoveInterval = nil 
    end

    data.MoveTargetVector = mod:Lerp(data.MoveTargetVector, data.MoveTrueTargetVector, mod.SolConst.SPEED_0/5)

    local angle = mod:AngleLerp(data.MoveVector:GetAngleDegrees(), data.MoveTargetVector:GetAngleDegrees(), mod.SolConst.SPEED_0)
    data.MoveVector = Vector(mod.SolConst.DISTANCE_0, 0):Rotated(angle)

    --move
    
    local targetDir = target.Position - entity.Position
    if targetDir:Length() > 200 then
        local finalPos = (target.Position + data.MoveVector)
        local direction = finalPos - entity.Position
        
        entity.Velocity = mod:Lerp(entity.Velocity, direction/30, 0.1)
        entity.Position = mod:Lerp(entity.Position, finalPos, mod.SolConst.SPEED_0/200)

    elseif targetDir:Length() < 100 then
        entity.Velocity = mod:Lerp(entity.Velocity, -targetDir/60, 0.1)
    end
end
function mod:SolMove1(entity, data, sprite, target, room)
    data.PositionPosition = data.PositionPosition or room:GetRandomPosition(0)
    if rng:RandomFloat() < 1/60 or entity.Position:Distance(data.PositionPosition) < 100 then 
        data.PositionPosition = room:GetRandomPosition(0) 
    end

    data.PositionPosition = mod:Lerp(data.PositionPosition, target.Position, 0.0001)

    --move
    local finalPos = data.PositionPosition
    local direction = finalPos - entity.Position
    entity.Velocity = direction/100
    entity.Position = mod:Lerp(entity.Position, finalPos, mod.SolConst.SPEED_1/100)
    
    
    if data.State == mod.SolState.IDLE and rng:RandomFloat() < mod.SolConst.TELE_CHANCE_1 and target.Position:Distance(entity.Position) > 550 then
        mod:SolChangeState(entity, data, mod.SolState.TELEPORT)
    end
    
end
function mod:SolMove2(entity, data, sprite, target, room)
    
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.SolConst.INTERVAL_2.X, mod.SolConst.INTERVAL_2.Y)
        
		local distance = 0.95*(room:GetCenterPos().X-entity.Position.X)^2 + 2*(room:GetCenterPos().Y-entity.Position.Y)^2
		
		if distance > mod.SolConst.CENTER_DISTANCE_TOLERATION^2 then
			data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		else
			data.targetvelocity = ((target.Position - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-50, 50))
		end
	end

	--If run out of idle time
	if data.idleTime <= 0 and data.idleTime ~= nil then
		data.idleTime = nil
	else
		data.idleTime = data.idleTime - 1
	end

	--Do the actual movement
	local speed = mod.SolConst.SPEED_2
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * speed
	data.targetvelocity = data.targetvelocity * 0.99
    
    if data.State == mod.SolState.IDLE and rng:RandomFloat() < mod.SolConst.TELE_CHANCE_2 and target.Position:Distance(entity.Position) > 550 then
        mod:SolChangeState(entity, data, mod.SolState.TELEPORT)
    end
end


function mod:SolSpray(entity, data, sprite, target, room, hpStage)
    entity.Velocity = Vector.Zero

    local nSprayWaves = math.ceil(mod.SolConst.N_SPRAY_WAVES * (1 + hpStage/9))
    local nSprayNums = math.ceil(mod.SolConst.N_SPRAY_NUMS * (1 + hpStage/9))
    local starSpeed = mod.SolConst.SPRAY_SPEED * (1 + hpStage/12)
    local sprayStepAngle = mod.SolConst.SPRAY_STEP_ANGLE * (1 + hpStage/6)

    if data.StateFrame == 1 then
        sprite:Play("Attack2", true)

        data.nSprayWaves = 0
        data.targetDirection = (target.Position - entity.Position):Normalized()
        mod:SolLookAt(entity, target.Position)

        mod:PlaySolHandsAnimation(entity, target, "Slash", false, target.Position, 10)
        data.ShaderSpeed = 2

        sfx:Play(Isaac.GetSoundIdByName("starSpray"))
        
    elseif sprite:IsFinished("Attack2") then
        data.nSprayWaves = data.nSprayWaves + 1
        
        if data.nSprayWaves >= nSprayWaves then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        else
            sprite:Play("Attack2", true)
        end

    elseif sprite:GetFrame() == 1 then
        
        local n = nSprayNums-1
        local step = (15)/n
        local angleStep = -sprayStepAngle*n/2
        
        
        local color = entity:GetData().Color
        for i = 0, n do
            mod:scheduleForUpdate(function()
                if entity and entity.HitPoints > 0 and entity:Exists() then
                    local sign = 1
                    if data.nSprayWaves%2==0 then
                        sign = -1
                    end

                    local pitch = 1+(i+data.nSprayWaves*nSprayNums)/(nSprayWaves*n)*3
                    
                    sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER, 0.65, 2, false, 1/pitch)
                    sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 0.65, 2, false, pitch)

                    local angle = angleStep + sprayStepAngle*i
                    
                    angle = sign * angle
                    angle = angle + data.targetDirection:GetAngleDegrees()

                    local bonus = (nSprayWaves-data.nSprayWaves)
                    bonus = bonus
                    local velocity = Vector(starSpeed + bonus, 0):Rotated(angle)

                    local star = mod:SpawnEntity(mod.Entity.Star5, entity.Position, velocity, entity):ToProjectile()
                    local starSprite = star:GetSprite()

                    star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                    starSprite.Color = color

                    star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

                    mod:TearFallAfter(star, 270)

                    --feathers
                    if (not mod.CriticalState) then
                        local n = math.ceil(mod.SolConst.FEATHERS_PARTICLES_MINI*0.5)
                        for i=1, n do
                            local speed = mod:RandomInt(mod.SolConst.FEATHERS_SPEED.Y, mod.SolConst.FEATHERS_SPEED.X)*mod.SolConst.MINI_FEATHERS_SCALAR
                            local velocity = data.targetDirection:Rotated(-30,30)*speed
                            local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                        end
                    end

                end
            end, math.ceil(step*i))
        end
    end

end
function mod:SolZodiac(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        sprite:Play("Attack1",true)
        data.nRepeats = 0
        data.nZodiac = 0

    elseif sprite:IsFinished("Attack1") then
        data.nZodiac = 0
        data.nRepeats = data.nRepeats + 1

        local nZodiacs = mod.SolConst.N_ZODIACS + hpStage

        if data.nRepeats > nZodiacs then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        else
            sprite:Play("Attack1",true)
        end

    elseif sprite:IsEventTriggered("Attack") then
        local angleOffset = rng:RandomFloat()*360
        local amount = math.ceil(mod.SolConst.ZODIAC_RING*(1+hpStage/2))
        local speed = mod.SolConst.ZODIAC_RING_SPEED*(1+hpStage/6)


        for i=1, amount do
            local angle = i*360/amount+angleOffset
            local velocity = Vector.FromAngle(angle)*speed

            local dot = mod:DotProduct(velocity, target.Position-entity.Position)
            if dot > 0 then

                local star = mod:SpawnEntity(mod.Entity.Star5, entity.Position, velocity, entity):ToProjectile()
                local starSprite = star:GetSprite()
    
                star:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                star.CurvingStrength = 0.0005
    
                star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                starSprite.Color = entity:GetData().Color
    
                star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
                mod:TearFallAfter(star, 270)
            end
        end

        sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER, 1, 2, false, 1)
        sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1.5, 2, false, 1)

    elseif sprite:WasEventTriggered("Attack") and entity.FrameCount%4==0 then
        local gridSet = mod.SolZodiacs[mod:RandomInt(1,12)]
        local gridAngle = 2*math.pi*rng:RandomFloat()

        local scale = 2.5 + 1.5*rng:RandomFloat() + hpStage/2

        local tPos = target.Position + target.Velocity*(30*data.nZodiac)

        for _, trace in ipairs(gridSet) do
            for index, point in ipairs(trace) do

                point = point - Vector(50,50)
                point = Vector(math.cos(gridAngle)*point.X - math.sin(gridAngle)*point.Y, math.sin(gridAngle)*point.X + math.cos(gridAngle)*point.Y)
                point = scale*point + tPos

                local flag = true
                for _, star in ipairs(mod:FindByTypeMod(mod.Entity.StarZodiac)) do
                    if star.Position.X == point.X and star.Position.Y == point.Y then
                        flag = false
                        break
                    end
                end
                if flag then
                    local star = mod:SpawnEntity(mod.Entity.StarZodiac, point, Vector.Zero, entity)
                    star:GetSprite().Color = data.Color
                    star.SpriteScale = Vector.One*(0.2 + 0.2*rng:RandomFloat())
                    star:GetSprite().Rotation = 360*rng:RandomFloat()
                end
                
                if (index < #trace) then

                    local pointNext = trace[index+1]
                    pointNext = pointNext - Vector(50,50)
                    pointNext = Vector(math.cos(gridAngle)*pointNext.X - math.sin(gridAngle)*pointNext.Y, math.sin(gridAngle)*pointNext.X + math.cos(gridAngle)*pointNext.Y)
                    pointNext = scale*pointNext + tPos

                    local angulo = (pointNext-point):GetAngleDegrees()
                    local tracerTimeout = mod.SolConst.ZODIAC_TRACE_AMOUNT
                    local length = (pointNext-point):Length()

                    local laser = mod:SpawnEntity(mod.Entity.SolWarningLaser, point, Vector.Zero, entity):ToLaser()
                    laser.Angle = angulo
                    laser.Timeout = tracerTimeout
                    laser.Parent = entity
                    laser.MaxDistance = length
        
                    laser.DisableFollowParent = true
                    laser:GetSprite().Color = data.Color

                    mod:scheduleForUpdate(function()
                        --1
                        local laser = mod:SpawnEntity(mod.Entity.SolLaser, point, Vector.Zero, entity):ToLaser()
                        laser.Angle = angulo
                        laser.Timeout = 1
                        laser.Parent = entity
                        laser.MaxDistance = length
                        laser.Size = laser.Size/2
            
                        laser.DisableFollowParent = true
                        laser:GetSprite().Color = data.Color

                        --2
                        local origin = point + Vector(length, 0):Rotated(angulo)
                        laser = mod:SpawnEntity(mod.Entity.SolLaser, origin, Vector.Zero, entity):ToLaser()
                        laser.Angle = angulo + 180
                        laser.Timeout = 1
                        laser.Parent = entity
                        laser.MaxDistance = length
                        laser.Size = laser.Size/2
            
                        laser.DisableFollowParent = true
                        laser:GetSprite().Color = data.Color

                    end, tracerTimeout+5)
                end
            end
        end

        data.nZodiac = data.nZodiac + 1
    end
end
function mod:SolCrossed(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero
    if data.StateFrame == 1 then
        if #mod:FindByTypeMod(mod.Entity.SolarSaw) > 0 or #mod:FindByTypeMod(mod.Entity.Star4) > 0 then 
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Attack1",true)
        end
    elseif sprite:IsFinished("Attack1") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    elseif sprite:IsEventTriggered("Attack") then

        mod:PlaySolHandsAnimation(entity, target, "Palm", false, target.Position, 10)
        data.ShaderSpeed = 3

        --sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER, 1, 2, false, 1)
        --sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1.5, 2, false, 1)
        sfx:Play(SoundEffect.SOUND_BEAST_SUCTION_START, 1, 2, false, 3)

        local nSprayWaves = math.ceil(mod.SolConst.N_SPRAY_WAVES * (1 + hpStage/9))

        local burstAngle = mod.SolConst.BURST_ANGLE * (1 + hpStage/6)
        local nBurst = math.ceil(mod.SolConst.N_BURST * (1 + hpStage/6) * 0.67)
        local burstAngleVar = mod.SolConst.BURST_ANGLE_VAR * (1 + hpStage/6)
        local burstSpeed1 = mod.SolConst.BURST_SPEED_1

        for k=-1,1,2 do
            local baseAngle = k * burstAngle

            local direction = target.Position - entity.Position
            for i=1, nBurst do
                local angle = direction:GetAngleDegrees() + baseAngle + 2*(rng:RandomFloat() - 0.5) * burstAngleVar
                local velocity = Vector(burstSpeed1 + rng:RandomFloat()*5, 0):Rotated(angle)

                local star = mod:SpawnEntity(mod.Entity.Star4, entity.Position, velocity, entity):ToProjectile()
                star.Parent = entity
                local starSprite = star:GetSprite()
        
                star.SpriteScale = (entity.SpriteScale)*0.2 + 0.4*Vector.One
                starSprite.Color = data.Color
                
                star.FallingSpeed = 0
                star.FallingAccel = -0.1
                star.ProjectileFlags = star.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE

                star.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            end

            --feathers
            if (not mod.CriticalState) then
                for i=1, mod.SolConst.FEATHERS_PARTICLES_MINI do
                    local speed = mod:RandomInt(mod.SolConst.FEATHERS_SPEED.Y, mod.SolConst.FEATHERS_SPEED.X)*mod.SolConst.MINI_FEATHERS_SCALAR
                    local velocity = direction:Normalized():Rotated(-30,30)*speed
                    local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                end
            end
        end

    end

end
function mod:SolLaser(entity, data, sprite, target, room, hpStage)
    entity.Velocity = Vector.Zero

    local laserIdles = math.ceil(mod.SolConst.LASER_IDLES*(1+hpStage/9))
    local laserIdles2 = math.floor(1.5*mod.SolConst.LASER_IDLES)

    local laserTimeout = math.floor(mod.SolConst.LASER_TIMEOUT*(1+math.min(3,hpStage)*2))

    if data.StateFrame == 1 then
        local snakes = mod:FindByTypeMod(mod.Entity.SolSnake)
        if (#snakes <= 0) and room:IsPositionInRoom(entity.Position, 1) then
            sprite:Play("Idle",true)
            data.shotLaser = false
            data.isAiming = true
            data.targetPos = nil
            data.ToEnd = nil
            data.laserIdles = 0
    
            --trace
            data.warnings = {}
            for i=-mod.SolConst.LASER_WARNIGNS, mod.SolConst.LASER_WARNIGNS do
                local direction = (target.Position - entity.Position):Normalized()
                local ogPos = entity.Position + Vector(0,-40) + direction*45 
                
                local laser = mod:SpawnEntity(mod.Entity.SolWarningLaser, ogPos, Vector.Zero, entity):ToLaser()
                laser.Angle = direction:GetAngleDegrees() + 45*i
                laser:GetData().AngleOffset = 45*i
                laser.Timeout = laserIdles*30+30
                laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
        
                laser.DisableFollowParent = false
                laser:GetSprite().Color = data.Color
    
                laser:Update()
                laser:SetColor(data.Color, 9999, 99, true, true)
    
                table.insert(data.warnings, laser)
            end
    
            sfx:Play(mod.SFX.Geiger, 2)
        else
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        end

    elseif sprite:IsFinished("Idle") then
        data.laserIdles = data.laserIdles + 1
        sprite:Play("Idle",true)

        if data.ToEnd and data.ToEnd-laserTimeout>-30 and sfx:IsPlaying(mod.SFX.LightBeam) then
            sfx:Stop(mod.SFX.LightBeam)
            sfx:Play(mod.SFX.LightBeamEnd)
        elseif data.ToEnd and data.ToEnd-laserTimeout>0 then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)

        elseif data.laserIdles == laserIdles then
            data.isAiming = false
            data.targetPos = target.Position

            sprite:Play("Attack1",true)
        end

    elseif sprite:IsFinished("Attack1") then
        data.ToEnd = 0
        sprite:Play("Idle",true)

    elseif sprite:IsEventTriggered("Attack") then
        if not data.shotLaser then
            data.shotLaser = true

            mod:PlaySolHandsAnimation(entity, target, "Knuck", false, data.targetPos, 10)

            data.ShaderSpeed = 4

            --laser
            local laserSpinSpeed = mod.SolConst.LASER_SPIN_SPEED*(1 - hpStage/4)

            local direction = (data.targetPos - entity.Position):Normalized()

            local ogPos = entity.Position + Vector(0,-40) + direction*45 
            local laser = mod:SpawnEntity(mod.Entity.HyperBeam, ogPos, Vector.Zero, entity):ToLaser()
            laser.Angle = direction:GetAngleDegrees()
            laser.Timeout = laserTimeout
            laser.Parent = entity
            laser.DisableFollowParent = false

            mod:scheduleForUpdate(function()
                laser.Size = laser.Size*1.25
            end,1)

            laser.DepthOffset = 2000

            --Spin direction
            local p1 = target.Position-entity.Position
            local p2 = direction
            local crossproductZ = p1.X * p2.Y - p1.Y * p2.X
            local dir = 1
            if crossproductZ > 0 then
                dir = -1
            end
            --laser:SetActiveRotation(0, 99999, dir*mod.SolConst.LASER_SPIN_SPEED)


            laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

            laser:GetSprite().Color = data.Color
            laser:Update()
            laser:SetColor(data.Color, 9999, 99, true, true)

            sfx:Play(SoundEffect.SOUND_BEAST_ANGELIC_BLAST, 0.75, 2, false, 2)
            sfx:Play(mod.SFX.LightBeam, 1, 2, true)

            --projectiles
            local step = 15
            local amount = laserTimeout/step
            local n = math.ceil(mod.SolConst.LASER_AMOUNT_RING*(1 + hpStage/3))
            local speed = math.ceil(mod.SolConst.LASER_SPEED*(1 + hpStage/24))

            local sign = -dir

            local angleOffset = rng:RandomFloat()*360

            for j=0, amount - 1 do

                mod:scheduleForUpdate(function()
                    if entity and entity:Exists() and entity.HitPoints > 0 and entity:GetData() and entity:GetData().Color then
                        local a = (360/n*2^0.5)*j
                        
                        local newAngleOffset = angleOffset + a
                        
                        for i=1, n do
                            local angle = i*360/n + newAngleOffset
                            local velocity = Vector.FromAngle(angle)*speed
    
                            local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                            if dot > 0 then
                
                                local star = mod:SpawnEntity(mod.Entity.Star5, entity.Position, velocity, entity):ToProjectile()
                                local starSprite = star:GetSprite()
                    
                                star:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                                star.CurvingStrength = sign*0.0015
                    
                                star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                                starSprite.Color = entity:GetData().Color
                    
                                star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                                
                                star.DepthOffset = 500
        
                                mod:TearFallAfter(star, 150)
                            end
                        end
                        
    
                        --feathers
                        if (not mod.CriticalState) then
                            for i=1, mod.SolConst.FEATHERS_PARTICLES/2 do
                                local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                            end
                        end
                    end
                end, j*step)
            end
              
            sfx:Play(SoundEffect.SOUND_BEAST_SUCTION_START, 1, 2, false, 3)
        end
    end


    --trace
    if data.warnings and #data.warnings>0 then
    
        local tPos = data.targetPos or target.Position
        local direction = (tPos - entity.Position):Normalized()
        local ogPos = entity.Position + Vector(0,-40) + direction*45 
        
        for i, laser in ipairs(data.warnings) do
            i = i - mod.SolConst.LASER_WARNIGNS - 1

            laser = laser:ToLaser()
            local ldata = laser:GetData()
            local lsprite = laser:GetSprite()
    
            laser.Position = ogPos
            if i == 0 and data.isAiming then
                laser.Angle = direction:GetAngleDegrees()
                mod:SolLookAt(entity, target.Position)
            elseif ldata.AngleOffset then
                local h = 0.05
                ldata.AngleOffset = mod:AngleLerp(ldata.AngleOffset, 0, h)
                
                laser.Angle =  direction:GetAngleDegrees() + ldata.AngleOffset
            end
        end

    end

    --idle
    if data.ToEnd then
        data.ToEnd = data.ToEnd+1
    end
end
function mod:SolStarfall(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)

    local nStarfalls = mod.SolConst.N_STARFALLS
    local starfallTimer = mod.SolConst.STARFALL_TIMER

    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        sprite:Play("Attack2",true)
        data.nRepeats = 0

    elseif sprite:IsFinished("Attack2") then
        local bonus = math.floor(4*(data.HpPercent))
        data.nRepeats = data.nRepeats + 1
        if data.nRepeats > nStarfalls + bonus then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
            data.nRepeats = 0
        else
            sprite:Play("Attack2",true)
        end

    elseif sprite:IsEventTriggered("Attack") then
        local position = room:GetRandomPosition(0)

        local target = mod:SpawnEntity(mod.Entity.SolStarTarget, position, Vector.Zero, entity):ToEffect()
        target.Parent = entity
        target:SetTimeout(starfallTimer)
        target:GetSprite().Color = data.Color
        target:GetData().hpStage = hpStage
        
        --target.Velocity = Vector(30*rng:RandomFloat(), 0):Rotated(360*rng:RandomFloat())
    end
end
function mod:SolGaper(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)

    entity.Velocity = Vector.Zero

    local nSummons = math.ceil(mod.SolConst.N_SUMMONS*(1+hpStage/6))

    if data.StateFrame == 1 then
        local bonus = math.floor(5*(data.HpPercent))
        if #mod:FindByTypeMod(mod.Entity.GlassGaper) > nSummons then 
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Idle",true)
        end

        data.nRepeats = 0

    elseif sprite:IsFinished("Idle") then
        data.nRepeats = data.nRepeats + 1
        
        if data.nRepeats > nSummons then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
            data.nRepeats = 0
        else
            sprite:Play("Idle",true)

            local size = entity.SizeMulti.X*entity.Size
            for i=1, 4 do
                if #mod:FindByTypeMod(mod.Entity.GlassGaper) > nSummons then break end

                local position = entity.Position + Vector(size*1.25 + 50*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())
                local counter = 0
                while not room:IsPositionInRoom(position, 20) do
                    position = entity.Position + Vector(size*1.25 + 50*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())

                    counter = counter+1
                    if counter>500 then break end
                end
                local gaper = mod:SpawnEntity(mod.Entity.GlassGaper, position, Vector.Zero, entity)
                gaper:GetSprite().Color = data.Color
                
                if i == 1 then
                    mod:PlaySolHandsAnimation(entity, target, "Palm", false, gaper.Position, 10)
                    data.ShaderSpeed = 3
                end
            end
        end
    end

end
function mod:SolTime(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    mod:SolMove(entity, data, sprite, target, room, hpStage)

    if data.StateFrame == 1 then
        if #mod:FindByTypeMod(mod.Entity.SolTimeVent) > 0 then 
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Attack2",true)
        end
    elseif sprite:IsFinished("Attack2") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    elseif sprite:IsEventTriggered("Attack") then
        
        mod:PlaySolHandsAnimation(entity, target, "Slash", true)

        local direction = (target.Position - entity.Position):Normalized()

        local timeVent = mod:SpawnEntity(mod.Entity.SolTimeVent, entity.Position, direction*15, entity)
        timeVent:GetSprite().Color = data.Color
        timeVent.SpriteScale = (entity.SpriteScale)*0.25 + 0.4*Vector.One

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES_MINI do
                local speed = mod:RandomInt(mod.SolConst.FEATHERS_SPEED.Y, mod.SolConst.FEATHERS_SPEED.X)*mod.SolConst.MINI_FEATHERS_SCALAR
                local velocity = direction:Rotated(-30,30)*speed
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end
        
        data.ShaderSpeed = -4
    end

end
function mod:SolBlast(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    mod:SolMove(entity, data, sprite, target, room, hpStage)

    if data.StateFrame == 1 then
        sprite:Play("Attack4",true)
        data.nRepeats = 0
    elseif sprite:IsFinished("Attack4") then
        
        data.ShaderSpeed = 1

        data.nRepeats = data.nRepeats + 1
        local waves = mod.SolConst.BLAST_WAVES*(1+hpStage/3)
        if data.nRepeats >= waves then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        else
            sprite:Play("Attack4",true)
        end

    elseif sprite:IsEventTriggered("Attack") then
        
        mod:PlaySolHandsAnimation(entity, target, "Slash", true, target.Position, 10)
        data.ShaderSpeed = 3

        local direction = (target.Position - entity.Position):Normalized()

        local blastSpeed = mod.SolConst.BLAST_SPEED*(1+hpStage/12)

        local velocity = direction * blastSpeed
        local flare = mod:SpawnEntity(mod.Entity.BigFlare, entity.Position, velocity, entity):ToProjectile()
        flare.Parent = entity
        flare:GetSprite().Color = data.Color
        flare:GetData().hpStage = hpStage

        flare.SpriteScale = (entity.SpriteScale)*0.5 + 0.5*Vector.One
        flare:SetSize(entity.SpriteScale.X*flare.Size, Vector.One, 12)
        
        flare.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE

        mod:TearFallAfter(flare, 90)

        sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING, 2, 2, false, 0.5)


        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES_MINI do
                local speed = mod:RandomInt(mod.SolConst.FEATHERS_SPEED.Y, mod.SolConst.FEATHERS_SPEED.X)*mod.SolConst.MINI_FEATHERS_SCALAR
                local velocity = direction:Rotated(-30,30)*speed
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end
    end

end
function mod:SolTeleport(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        data.nRepeats = 0
        if entity.HitPoints > entity.MaxHitPoints*0.25 and (#mod:FindByTypeMod(mod.Entity.SolSnake) <= 0) then
            sprite:Play("Attack1",true)
        else
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        end

    elseif sprite:IsFinished("Attack1") then
        data.nRepeats = data.nRepeats + 1
        local nTeleports = mod.SolConst.N_TELEPORTS*(1+hpStage/12)

        if data.nRepeats > nTeleports then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
            data.nRepeats = 0
        else
            sprite:Play("Attack1",true)
        end

    elseif sprite:IsEventTriggered("Attack") then
        
        local position = room:GetRandomPosition(0)
        local i = 0
        while position:Distance(target.Position) < 200 or position:Distance(target.Position) > 400  do
            position = room:GetRandomPosition(0)

            i=i+1
            if i>500 then break end
        end

        entity.Position = position
        mod:SolSpeak("neutral", hpStage)

        mod:RestoreSolHands(entity)

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES do
                local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end

        --rign
        local angleOffset = rng:RandomFloat()*360
        local teleportRing = math.ceil(mod.SolConst.TELEPORT_RING*(1+hpStage/6))
        local speed = mod.SolConst.TELEPORT_SPEED/2


        for i=1, teleportRing do
            local angle = i*360/teleportRing+angleOffset

            local velocity = Vector.FromAngle(angle)*speed

            local flare = mod:SpawnEntity(mod.Entity.Flare, entity.Position, velocity, entity):ToProjectile()
            local flareSprite = flare:GetSprite()

            flare:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
            flare.CurvingStrength = 0.01* (1 - 2*(i%2))

            flare.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)
            flareSprite.Color = data.Color

            flare:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

            mod:TearFallAfter(flare, 480)
        end

        sfx:Play(mod.SFX.Fireblast)
        sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING, 1, 2, false, 1)

        
        game:MakeShockwave(entity.Position, -0.1, 0.05, 90)
    end

end
function mod:SolBlasterA(entity, data, sprite, target, room, hpStage)--sans
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        if true then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
            return
        end

        local f1 = #mod:FindByTypeMod(mod.Entity.SolarBlaster) > 0
        local f2 = not room:IsPositionInRoom(target.Position, mod.SolConst.BLASTER_DISTANCE*0.5)
        local f3 = #mod:FindByTypeMod(mod.Entity.SolSnake) > 0
        if f1 or f2 or f3 then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Attack1",true)

            for i, tear in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
                tear:Remove()
            end
        end
        
    elseif sprite:IsFinished("Attack1") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    elseif sprite:IsEventTriggered("Attack0") then
        
        local nBlasters = math.ceil(mod.SolConst.N_BLASTER_A*(1+hpStage*1.5))
        local blasterAngle = mod.SolConst.BLASTER_ANGLE
        local blasterDistance = mod.SolConst.BLASTER_DISTANCE

        local angleOffset = rng:RandomFloat() * 360
        for i = 1, nBlasters do
            local tpos = target.Position
            mod:scheduleForUpdate(function()
                if entity and entity.HitPoints > 0 then
                    local angle = i*blasterAngle + angleOffset + 5*rng:RandomFloat()

                    local position = tpos + Vector(blasterDistance, 0):Rotated(angle+180)

                    local blaster = mod:SpawnEntity(mod.Entity.SolarBlaster, position, Vector.Zero, entity)
                    blaster:GetData().Angle = angle
                    blaster:GetData().Color = data.Color

                    --blaster:GetSprite().PlaybackSpeed = 0.9
                    --blaster:GetSprite().Color = Color.Lerp(blaster:GetSprite().Color, sprite.Color, 0.5)
                end
            end, i*4)
        end
    end

end
function mod:SolBlasterB(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        local f1 = #mod:FindByTypeMod(mod.Entity.SolarBlaster) > 0
        local f2 = #mod:FindByTypeMod(mod.Entity.SolSnake) > 0
        if f1 or f2 then

            mod:KillEntities(mod:FindByTypeMod(mod.Entity.GlassGaper))

            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Attack4",true)

            for i, tear in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
                tear:Remove()
            end

            data.blasterIdles = 0
        end
        
    elseif sprite:IsFinished("Attack4") then
        sprite:Play("Idle",true)
        
    elseif sprite:IsFinished("Idle") then
        data.blasterIdles = data.blasterIdles + 1
        if data.blasterIdles > mod.SolConst.BLASTER_IDLES then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        else
            sprite:Play("Idle",true)
        end

    elseif sprite:IsEventTriggered("Attack") then
        
        mod:PlaySolHandsAnimation(entity, target, "Palm", false)

        local nBlasters = math.ceil(mod.SolConst.N_BLASTER_B)
        local blasterDistance = mod.SolConst.BLASTER_DISTANCE
        local blasterSpacing = mod.SolConst.BLASTER_SPACING*(1-hpStage/3*0.15)

        for j=-1, 1, 2 do
            local angleOffset = 180 + j*45 + (target.Position-entity.Position):GetAngleDegrees()
            for i = -math.floor(nBlasters/2), math.floor(nBlasters/2) do
                local sign = 1
                if sign < 0 then sign = -1 end

                local position = target.Position + Vector(blasterDistance, 0):Rotated(angleOffset)
                local posoffset = Vector(blasterSpacing*i,0):Rotated(angleOffset + 90*sign)
                position = position + posoffset

                local blaster = mod:SpawnEntity(mod.Entity.SolarBlaster, position, Vector.Zero, entity)
                blaster:GetData().Angle = angleOffset + 180
                blaster:GetData().Color = data.Color
                blaster:GetData().Trace = true
                blaster.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

                blaster:GetSprite().PlaybackSpeed = 0.75
            end
        end
    end

end
function mod:SolFocus(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    mod:SolMove(entity, data, sprite, target, room, hpStage)

    local nGalaxies = math.ceil(mod.SolConst.N_GALAXIES*(1+hpStage/6))
    local k = 1


    if data.StateFrame == 1 then
        
        if true then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
            return
        end
        
        sprite:Play("Attack2",true)
        data.nRepeats = 0

        local sign = 1-mod:RandomInt(0,1)*2
        for i=1, nGalaxies do
            local galaxy = mod:SpawnEntity(mod.Entity.SolarBlaster, entity.Position, Vector.Zero, entity, nil, mod.EntityInf[mod.Entity.SolarBlaster].SUB+1)
            galaxy:GetData().AngleOffset = 360*i/nGalaxies
            galaxy:GetData().Sign = sign
            galaxy.Parent = entity
            galaxy.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        end

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES/2 do
                local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end

    elseif sprite:IsFinished("Attack2") then
        data.nRepeats = data.nRepeats + 1
        if data.nRepeats >= 50 or #mod:FindByTypeMod(mod.Entity.SolarBlaster, mod.EntityInf[mod.Entity.SolarBlaster].VAR, mod.EntityInf[mod.Entity.SolarBlaster].SUB+1) == 0 then
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        else
            sprite:Play("Attack2",true)
        end

    end

end
function mod:SolHell(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    local hellTimer = mod.SolConst.HELL_TIMER*(1+hpStage/6)

    if data.StateFrame == 1 then
        sprite:Play("Attack3Start",true)
        data.AngleOffset = 0

    elseif sprite:IsFinished("Attack3Start") then
        sprite:Play("Attack3",true)
        data.ShaderSpeed = 2.5
    elseif sprite:IsFinished("Attack3") then
        if data.StateFrame >= hellTimer then
            sprite:Play("Attack3End",true)
        else
            sprite:Play("Attack3",true)
        end
    elseif sprite:IsFinished("Attack3End") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    end

    if sprite:IsPlaying("Attack3") then
        local f1 = mod.SolConst.HELL_FREQ
        local f2 = mod.SolConst.HELL_FREQ2
        local f3 = mod.SolConst.HELL_FREQ3
        if entity.FrameCount % f1 == 0 then

            local hellNum = math.ceil(mod.SolConst.HELL_NUM*(1+hpStage/12))
            local hellSpeed = mod.SolConst.HELL_SPEED*(1+hpStage/12)

            data.AngleOffset = data.AngleOffset + math.ceil(20*(1+hpStage/9))
            for i = 1, hellNum do
                local angle = 360*i/hellNum + data.AngleOffset
                local velocity = Vector(hellSpeed, 0):Rotated(angle)

                local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                if dot > 0 then

                    local star = mod:SpawnEntity(mod.Entity.Star8, entity.Position, velocity, entity):ToProjectile()
                    star.DepthOffset = 200
                    local starSprite = star:GetSprite()
    
                    star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                    starSprite.Color = entity:GetData().Color
    
                    star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
                    mod:TearFallAfter(star, 270)
                end
            end
            
            sfx:Play(Isaac.GetSoundIdByName("touhouBullet"), 0.5, 2, false, 1.5)


            --feathers
            if (not mod.CriticalState) then
                for i=1, mod.SolConst.FEATHERS_PARTICLES/16 do
                    local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                    local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                end
            end
        end
        if entity.FrameCount % f2 == 0 then

            local hellNum = math.ceil(mod.SolConst.HELL_NUM*(1+hpStage/6)*1.2)
            local hellSpeed = mod.SolConst.HELL_SPEED*(1+hpStage/9)*1.5

            local angleOffset = rng:RandomFloat()*360 -- data.AngleOffset
            for i = 1, hellNum do
                local angle = 360*i/hellNum + angleOffset
                local velocity = Vector(hellSpeed, 0):Rotated(angle)

                local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                if dot > 0 then

                    local star = mod:SpawnEntity(mod.Entity.Star5, entity.Position, velocity, entity):ToProjectile()
                    star.DepthOffset = 200
                    local starSprite = star:GetSprite()
    
                    star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                    starSprite.Color = entity:GetData().Color
    
                    star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
                    mod:TearFallAfter(star, 270)
                end
            end
            sfx:Play(SoundEffect.SOUND_BEAST_SUCTION_START, 1, 2, false, 3)


            --feathers
            if (not mod.CriticalState) then
                for i=1, mod.SolConst.FEATHERS_PARTICLES/8 do
                    local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                    local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                end
            end
        end
        if false and entity.FrameCount % f3 == 0 then

            local hellNum = math.ceil(mod.SolConst.HELL_NUM*(1+hpStage/6)*0.67)
            local hellSpeed = mod.SolConst.HELL_SPEED*(1+hpStage/9)*0.67

            local angleOffset = 2*data.AngleOffset + 45
            for i = 1, hellNum do
                local angle = 360*i/hellNum + angleOffset
                local velocity = Vector(hellSpeed, 0):Rotated(angle)

                local flare = mod:SpawnEntity(mod.Entity.BigFlare, entity.Position, velocity, entity):ToProjectile()
                flare.Parent = entity
                flare:GetSprite().Color = data.Color
                flare:GetData().hpStage = hpStage
                flare:GetData().NotExplosion = true
        
                flare.SpriteScale = (entity.SpriteScale)*0.5 + 0.5*Vector.One
                flare:SetSize(entity.SpriteScale.X*flare.Size, Vector.One, 12)
                
                flare.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE
        
                mod:TearFallAfter(flare, 270)
        
            end
            sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING, 2, 2, false, 0.5)
        end
    end

end
function mod:SolHell2(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    local hellTimer = mod.SolConst.HELL_TIMER*(1+hpStage/6)

    if data.StateFrame == 1 then
        sprite:Play("Attack3Start",true)
        data.AngleOffset = 0

    elseif sprite:IsFinished("Attack3Start") then
        sprite:Play("Attack3",true)
        data.ShaderSpeed = 2.5
    elseif sprite:IsFinished("Attack3") then
        if data.StateFrame >= hellTimer then
            sprite:Play("Attack3End",true)
        else
            sprite:Play("Attack3",true)
        end
    elseif sprite:IsFinished("Attack3End") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    end

    if sprite:IsPlaying("Attack3") then
        local f1 = mod.SolConst.HELL_FREQ
        local f2 = mod.SolConst.HELL_FREQ2
        local f3 = mod.SolConst.HELL_FREQ3
        if entity.FrameCount % f1 == 0 then

            local hellNum = math.ceil(mod.SolConst.HELL_NUM*(1+hpStage/12))
            local hellSpeed = mod.SolConst.HELL_SPEED*(1+hpStage/12)*0.8

            data.AngleOffset = data.AngleOffset + math.ceil(20*(1+hpStage/9))
            for i = 1, hellNum do
                local angle = 360*i/hellNum + data.AngleOffset
                local velocity = Vector(hellSpeed, 0):Rotated(angle)

                local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                if dot > 0 then

                    local star = mod:SpawnEntity(mod.Entity.Star8, entity.Position, velocity, entity):ToProjectile()
                    star.DepthOffset = 200
                    local starSprite = star:GetSprite()
    
                    star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                    starSprite.Color = entity:GetData().Color
    
                    star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
                    mod:TearFallAfter(star, 270)
                end
            end
            sfx:Play(Isaac.GetSoundIdByName("touhouBullet"), 0.5, 2, false, 1.5)


            --feathers
            if (not mod.CriticalState) then
                for i=1, mod.SolConst.FEATHERS_PARTICLES/16 do
                    local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                    local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                end
            end
        end
        if entity.FrameCount % f3 == 0 then

            local hellNum = math.ceil(mod.SolConst.HELL_NUM*(1+hpStage/6)*0.67)
            local hellSpeed = mod.SolConst.HELL_SPEED*(1+hpStage/9)*0.67

            local angleOffset = rng:RandomFloat()*360
            for i = 1, hellNum do
                local angle = 360*i/hellNum + angleOffset
                local velocity = Vector(hellSpeed, 0):Rotated(angle)

                local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                if dot > 0 then

                    local flare = mod:SpawnEntity(mod.Entity.BigFlare, entity.Position, velocity, entity):ToProjectile()
                    flare.Parent = entity
                    flare:GetSprite().Color = data.Color
                    flare:GetData().hpStage = hpStage
                    flare:GetData().NotExplosion = true
            
                    flare.SpriteScale = (entity.SpriteScale)*0.5 + 0.5*Vector.One
                    flare:SetSize(entity.SpriteScale.X*flare.Size, Vector.One, 12)
                    
                    flare.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE
            
                    mod:TearFallAfter(flare, 270)
                end
        
            end
            sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING, 2, 2, false, 0.5)
        end
    end

end
function mod:SolHell3(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    local hellTimer = mod.SolConst.HELL_TIMER*(1+hpStage/6)

    if data.StateFrame == 1 then
        sprite:Play("Attack3Start",true)
        data.AngleOffset = 0
        data.hellAccel = 1.0001

    elseif sprite:IsFinished("Attack3Start") then
        sprite:Play("Attack3",true)
        data.ShaderSpeed = 2.5
    elseif sprite:IsFinished("Attack3") then
        if data.StateFrame >= hellTimer then
            sprite:Play("Attack3End",true)
        else
            sprite:Play("Attack3",true)
        end
    elseif sprite:IsFinished("Attack3End") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    end

    if sprite:IsPlaying("Attack3") then
        local f1 = mod.SolConst.HELL_FREQ
        if entity.FrameCount % f1 == 0 then

            local hellNum = math.ceil(mod.SolConst.HELL_NUM*(1+hpStage/12))
            local hellSpeed = mod.SolConst.HELL_SPEED*(1+hpStage/12)*0.5

            data.AngleOffset = data.AngleOffset + math.ceil(10*(1+hpStage/9))
            for i = 1, hellNum do
                local angle = 360*i/hellNum + data.AngleOffset
                local velocity = Vector(hellSpeed, 0):Rotated(angle)

                local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                if dot > 0 then

                    local star = mod:SpawnEntity(mod.Entity.Star8, entity.Position, velocity, entity):ToProjectile()
                    star:AddProjectileFlags(ProjectileFlags.ACCELERATE)
                    star.Acceleration = data.hellAccel
                    star.DepthOffset = 200
                    local starSprite = star:GetSprite()
    
                    star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                    starSprite.Color = entity:GetData().Color
    
                    star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
                    mod:TearFallAfter(star, 270)
    
                end
            end
            data.hellAccel = data.hellAccel*1.00125
            sfx:Play(Isaac.GetSoundIdByName("touhouBullet"), 0.5, 2, false, 1.5)


            --feathers
            if (not mod.CriticalState) then
                for i=1, mod.SolConst.FEATHERS_PARTICLES/16 do
                    local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR
                    local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                end
            end
        end
    end

end
function mod:SolHoming(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    mod:SolMove(entity, data, sprite, target, room, hpStage)

    if data.StateFrame == 1 then
        if #mod:FindByTypeMod(mod.Entity.SolEye) == 0 then
            sprite:Play("Attack2",true)
        else
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        end
    elseif sprite:IsFinished("Attack2") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    elseif sprite:IsEventTriggered("Attack") then

        mod:PlaySolHandsAnimation(entity, target, "Slash", true, target.Position, 10)
        data.ShaderSpeed = 3

        local direction = (target.Position - entity.Position):Normalized()

        local eye = mod:SpawnEntity(mod.Entity.SolEye, entity.Position, direction*10, entity)
        eye:GetSprite().Color = data.Color
        eye.SpriteScale = (entity.SpriteScale)*0.25 + 0.4*Vector.One

        eye:GetData().hpStage = hpStage
        eye:GetData().Color = data.Color
        eye.Child = target

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES_MINI do
                local speed = mod:RandomInt(mod.SolConst.FEATHERS_SPEED.Y, mod.SolConst.FEATHERS_SPEED.X)*mod.SolConst.MINI_FEATHERS_SCALAR
                local velocity = direction:Rotated(-30,30)*speed
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end

    end

end
function mod:SolDash(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    --mod.ShaderData.solData.EYETARGET = target.Position

    if data.StateFrame == 1 then
        sprite:Play("AttackWingStart",true)
        data.ShaderSpeed = 4

        data.DashAngle = 0
        data.TargetPos = nil
        data.OgPos = entity.Position
        data.FlagDash = false
        
        sfx:Play(SoundEffect.SOUND_BEAST_GROWL, 1, 2, false, 2)

    elseif sprite:IsFinished("AttackWingStart") then
        data.ShaderSpeed = 1
        sprite:Play("AttackWing",true)

    elseif sprite:IsFinished("AttackWingEnd") then
        sprite:Play("AttackWingEnd",true)
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    end

    if not sprite:IsPlaying("AttackWingEnd") then
        data.DashAngle = data.DashAngle + 10
        if data.DashAngle > 360 and not data.FlagDash then
            data.FlagDash = true

            data.OgPos = entity.Position

            local direction = (target.Position - entity.Position):Normalized()

            data.TargetPos = entity.Position + direction*1000
            data.NextPos = entity.Position - direction*1000

            sfx:Play(SoundEffect.SOUND_GFUEL_EXPLOSION_BIG, 1, 2, false, 2)

        elseif data.DashAngle > 360 then
            local direction = (data.TargetPos - entity.Position):Normalized()
            local velocity = direction*mod.SolConst.DASH_SPEED

            entity.Velocity = velocity

            if entity.Position:Distance(data.TargetPos) < 15 then
                if data.TargetPos == data.OgPos then

                    mod:PlaySolHandsAnimation(entity, target, "Knuck", false)

                    --rign
                    local angleOffset = rng:RandomFloat()*360
                    local amountDash = math.ceil(mod.SolConst.AMOUNT_DASH*(1+hpStage/6))*2
                    local speed = mod.SolConst.DASH_TEAR_SPEED*(1+hpStage/6)


                    for i=1, amountDash do
                        local angle = i*360/amountDash+angleOffset

                        local velocity = Vector.FromAngle(angle)*speed

                        local dot = mod:DotProduct(velocity, target.Position-entity.Position)
                        if dot > 0 then

                            local flare = mod:SpawnEntity(mod.Entity.Flare, entity.Position, velocity, entity):ToProjectile()
                            local flareSprite = flare:GetSprite()
    
                            flare:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                            flare.CurvingStrength = 0.001* (1 - 2*(i%2))
    
                            flare.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)
                            flareSprite.Color = data.Color
    
                            flare:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
    
                            mod:TearFallAfter(flare, 480)
    
                            if i%2 == 0 then
                                angle = angle + 360/amountDash*0.5
                                local velocity = Vector.FromAngle(angle)*speed/2
    
                                local flare = mod:SpawnEntity(mod.Entity.BigFlare, entity.Position, velocity, entity):ToProjectile()
                                flare.Parent = entity
                                flare:GetSprite().Color = data.Color
                                flare:GetData().hpStage = hpStage
                                flare:GetData().NotExplosion = true
                        
                                flare.SpriteScale = (entity.SpriteScale)*0.5 + 0.5*Vector.One
                                flare:SetSize(entity.SpriteScale.X*flare.Size, Vector.One, 12)
                                
                                flare.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE
                        
                                mod:TearFallAfter(flare, 270)
                            end
                        end
                    end
                
                    entity.Velocity = Vector.Zero
                    sfx:Play(mod.SFX.ThunderExplosion)
                    sprite:Play("AttackWingEnd",true)
                else
                    data.TargetPos = data.OgPos
                    entity.Position = data.NextPos

                    mod:RestoreSolHands(entity)
                end
            end

            local dashF = math.ceil(mod.SolConst.DASH_F*(1-hpStage/3*0.5))
            dashF = math.max(dashF, 3)
            if entity.FrameCount % dashF == 0 then
                for i=-1,1,2 do
                    --local velocity = Vector(entity.Velocity:Length()/6,0):Rotated(i*90)
                    local velocity = entity.Velocity:Rotated(i*90)/6
                    local flare = mod:SpawnEntity(mod.Entity.Flare, entity.Position, velocity, entity):ToProjectile()
                    local flareSprite = flare:GetSprite()
        
                    flare.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)
                    flareSprite.Color = data.Color
        
                    flare:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
        
                    mod:TearFallAfter(flare, 180)
                end
            end

        else
            local angle = data.DashAngle*math.pi/180
            local r = 200*(1+hpStage/3)
            --r = r*math.sin(angle)^2 
            r = r*math.sin(angle)*math.cos(angle)

            local position = data.OgPos + Vector(0,r):Rotated(data.DashAngle)
            local direction = (position-entity.Position)/10

            entity.Velocity = direction
        end

        if entity.FrameCount%2==0 and sprite:IsPlaying("AttackWing") then
            local trace = mod:SpawnEntity(mod.Entity.SolWingTrace, entity.Position, Vector.Zero, entity):ToEffect()
            trace.Parent = entity
            trace.Visible = false
            trace:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end
end
function mod:SolSnake(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then

        if true then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
            return
        end

        local f1 = #mod:FindByTypeMod(mod.Entity.SolarBlaster) > 0
        local f2 = #mod:FindByTypeMod(mod.Entity.SolSnake) > 0
        if f1 or f2 then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Attack4",true)
            sfx:Play(mod.SFX.SolarSnakeSummon)
            data.ShaderSpeed = 3
        end
    elseif sprite:IsFinished("Attack4") then
        mod:SolChangeState(entity, data, mod.SolState.IDLE)

    elseif sprite:IsEventTriggered("Attack") then

        mod:PlaySolHandsAnimation(entity, target, "Slash", true, target.Position, 10)

        local snake = mod:SpawnEntity(mod.Entity.SolSnake, entity.Position, Vector.Zero, entity):ToNPC()

        snake.Parent = entity
        snake:GetData().Color = data.Color
        snake:GetSprite().Color = data.Color
        snake:SetColor(data.Color, -1, 99, true, true)
        snake:GetData().hpStage = hpStage

        snake.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        snake.SpriteScale = (entity.SpriteScale)*0.5 + 0.5*Vector.One
        snake.Scale = snake.SpriteScale.X
        snake:SetSize(snake.Size*snake.Scale, Vector.One, 12)

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES_MINI*2 do
                local direction = (target.Position - entity.Position):Normalized()
                local speed = mod:RandomInt(mod.SolConst.FEATHERS_SPEED.Y, mod.SolConst.FEATHERS_SPEED.X)
                local velocity = direction:Rotated(-30,30)*speed
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end
        
    end

end
function mod:SolShine(entity, data, sprite, target, room, hpStage)
    mod:SolLookAt(entity, target.Position)
    entity.Velocity = Vector.Zero

    local waitFrame = 45

    if data.StateFrame == 1 then
        local flag = (not room:IsPositionInRoom(entity.Position, 150)) or (target.Position:Distance(entity.Position)<300)
        if flag then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else
            sprite:Play("Attack2",true)
    
            data.LaserInitiated = false
            data.LaserAngle = 360*rng:RandomFloat()
            data.fixedHpStage = hpStage or 1
    
            local amount = math.ceil(mod.SolConst.SHINE_AMOUNT*(1+hpStage/9))
            for i=1, amount do
                local angle = i/amount*360 + data.LaserAngle
    
                local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()
                if tracer then
                    tracer:FollowParent(entity)
                    tracer.LifeSpan = waitFrame
                    tracer.Timeout = tracer.LifeSpan
                    tracer.TargetPosition = Vector(1, 0):Rotated(angle)
                    tracer:GetSprite().Color = data.Color
        
                    tracer:Update()
                end
            end

            --sound
            sfx:Play(SoundEffect.SOUND_DOGMA_LIGHT_APPEAR)
        end

    elseif sprite:IsFinished("Attack2") then
        local timeout = mod.SolConst.SHINE_TIMEOUT*(1+hpStage/3)
        if data.StateFrame >= timeout or data.ForcedEnd then
            data.ForcedEnd = false
            for i, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER, LaserVariant.LIGHT_BEAM, 0)) do
                laser:Remove()
            end

            sfx:Stop(mod.SFX.LightBeam)
            sfx:Play(mod.SFX.LightBeamEnd, 1, 2, false, 2)

            data.LaserInitiated = false
            
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        else
            sprite:Play("Attack2",true)
        end
        
    end

    hpStage = data.fixedHpStage or hpStage
    local amount = math.ceil(mod.SolConst.SHINE_AMOUNT*(1+hpStage/9))
    local speed = mod.SolConst.SHINE_SPEED*(1+hpStage/9)
    data.LaserAngle = data.LaserAngle or 0
    data.LaserAngle = data.LaserAngle + speed

    if data.LaserInitiated then
        data.RetroLaserAngle = data.RetroLaserAngle - speed

        --close
        local flag = false

        for i=1, amount do

            local miniAngle = i/amount*360

            local a = data.LaserAngle + miniAngle
            local b = data.RetroLaserAngle
            local normDeg = (a-b) % 360

            flag = flag or math.min(360-normDeg, normDeg) < mod.SolConst.SHINE_TRIGGER_ANGLE

            if flag then break end
        end

        if flag then
            if not data.Intangible then
                data.Intangible = mod:RandomInt(0,1)
                if hpStage > 2.5 and math.abs(target.Position.Y - room:GetTopLeftPos().Y) < 150 then
                    if target.Position.X > room:GetCenterPos().X then
                        data.Intangible = 1
                    else
                        data.Intangible = 0
                    end
                end
            end
        else
            data.Intangible = false
        end


        --lasers
        for i, laser in ipairs(data.ShineLasers) do
            local id = laser:GetData().ID
            if id then
                local index = math.ceil(id/2)
                local angle
                if id % 2 == 0 then
                    angle = index/amount*360 + data.LaserAngle
                else
                    angle = index/amount*360 + data.RetroLaserAngle
                end
                laser.Angle = angle

                --intan
                if data.Intangible then
                    if id % 2 == data.Intangible then
                        laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                        laser.CollisionDamage = 0

                        local color = laser:GetSprite().Color
                        color.A = 0.1
                        laser:SetColor(color, 5, 99, true, true)
                        laser.Parent = target
                    end
                else
                    laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    laser.CollisionDamage = 1
                    laser.Parent = entity
                end
            end
            laser.Position = entity.Position
        end

        if hpStage > 2.5 and math.abs(target.Position.Y - room:GetTopLeftPos().Y) < 100 then
            --data.ForcedEnd = true
        end

        if not sfx:IsPlaying(mod.SFX.LightBeam) then
            sfx:Play(mod.SFX.LightBeam, 1, 2, true, 2)
        end

    elseif data.StateFrame > waitFrame then
        data.LaserInitiated = true

        data.ShineLasers = {}
        local index = 1
        for i=1, amount do
            for j=1, 2 do
                local angle = i/amount*360 + data.LaserAngle


                --local laser = mod:SpawnEntity(mod.Entity.SolLaser, entity.Position, Vector.Zero, entity):ToLaser()
                local laser = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.LIGHT_BEAM, 0, entity.Position, Vector.Zero, entity):ToLaser()
                if laser then
                    laser.Angle = angle
                    laser.Timeout = -1
                    laser.Parent = entity
                    laser.DisableFollowParent = true

                    laser:GetData().ID = index

                    laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

                    laser:GetSprite().Color = data.Color
                    laser:Update()
                    laser:SetColor(data.Color, 9999, 99, true, true)

                    laser.CollisionDamage = 1

                    table.insert(data.ShineLasers, laser)

                    index = index + 1
                end
            end
        end

        data.RetroLaserAngle = data.LaserAngle

    else
        local traces = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0)
        local ntraces = #traces
        for i=1, ntraces do
            if traces[i] then
                local tracer = traces[i]

                local angle = i/ntraces*360 + data.LaserAngle
                tracer.TargetPosition = Vector(1, 0):Rotated(angle)
            end
        end
    end

end
function mod:SolSword(entity, data, sprite, target, room, hpStage)
    --mod.ShaderData.solData.EYETARGET = target.Position
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then

        local flag = hpStage >= 3 and (target.Position.Y < room:GetCenterPos().Y)

        if flag then
            mod:SolChangeState(entity, data, mod.SolState.IDLE, true)
        else

            sprite:Play("Idle",true)
    
            for i, sword in ipairs(mod:FindByTypeMod(mod.Entity.SolSword)) do
                sword:Remove()
            end
    
            data.IdleCount = 0
            data.SwordFinish = false
    
            --sword
            local direction = (target.Position - entity.Position)
            local angle = direction:GetAngleDegrees()
    
            local sword = mod:SpawnEntity(mod.Entity.SolSword, entity.Position, Vector.Zero, entity):ToNPC()
            sword:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            local swordData = sword:GetData()
    
            swordData.Size = mod.ShaderData.solData.HPSIZE*2
            swordData.OgAngle = angle
            swordData.Angle = angle
            swordData.Color = data.Color
            
            swordData.Spin = 1-2*mod:RandomInt(0,1)
            if hpStage >= 3 then
                if (target.Position.X > room:GetCenterPos().X) then
                    swordData.Spin = 1
                else
                    swordData.Spin = -1
                end
            end
    
            sword.Parent = entity
            entity.Child = sword
    
    
            swordData.hpStage = hpStage
            swordData.Color = data.Color
            sword:GetSprite().Color = data.Color
            sword:SetColor(data.Color, -1, 99, true, true)
    
            sword.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    
            --trace
            local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()
            if tracer then
                tracer:FollowParent(entity)
                tracer.LifeSpan = 60
                tracer.Timeout = tracer.LifeSpan
                tracer.TargetPosition = Vector(1, 0):Rotated(angle)
                tracer:GetSprite().Color = data.Color
        
                tracer:Update()
            end

            
            sfx:Play(mod.SFX.DrawSword, 2, 2, false, 0.67)
        end

    elseif sprite:IsFinished("Idle") then
        data.IdleCount = data.IdleCount + 1
        
        if data.IdleCount < mod.SolConst.SWORD_IDLES then
            sprite:Play("Idle",true)
        else
            mod:SolChangeState(entity, data, mod.SolState.IDLE)
        end
        
    end

    if entity.Child then
        local sword = entity.Child
        local swordData = sword:GetData()
        
        local n = 60
        local nn = 10

        local nAngle = 180
        if data.StateFrame < n then
            local frame = data.StateFrame
            local frac = frame/n
            --frac = frac*frac

            swordData.Angle = swordData.OgAngle + swordData.Spin*nAngle*frac

            if data.StateFrame == n-1 then
                sfx:Play(SoundEffect.SOUND_SWORD_SPIN, 3, 2, false, 0.67)
                sfx:Play(mod.SFX.Fireblast, 1, 2, false, 1)
            end
        else


            local frame = data.StateFrame - n
            local frac = frame/nn
            --frac = frac*frac

            swordData.Angle = swordData.OgAngle + swordData.Spin*(math.max(-5,nAngle - nAngle*frac))

            if frac > 1 and not data.SwordFinish then
                data.IdleCount = 999
                data.ShaderSpeed = 4

                data.SwordFinish = true
                sword:GetSprite():Play("Death", true)

                entity.Child = nil
            end
        end

        if swordData and swordData.Angle then
            mod:SolLookAt(entity, entity.Position + Vector(1,0):Rotated(swordData.Angle))
        end
    end
end


function mod:SolChangeState(entity, data, force, noIdle)
    data.ShaderSpeed = 1
    data.Hell = nil

    --game:SetColorModifier(ColorModifier(1,1,1, 0, 0, 2))

    if force then
        data.State = force
        data.StateFrame = 0

        if rng:RandomFloat() < mod.SolConst.SAD_CHANCE then
            mod:SolSpeak("sad", data.hpStage)
        end
    else
        local state = data.State
        if state == mod.SolState.IDLE then
            
            local r = rng:RandomFloat()
            for newState, entry in ipairs(data.Chain) do
                if not (newState == mod.SolState.APPEAR or newState == mod.SolState.IDLE) then
                    local idles = entry[1]
                    local chance = entry[2]

                    local hpStage = math.floor(data.hpStage)
                    if hpStage < 3 then
                        local nextChain = mod["ChainSolBase"..tostring(hpStage+1)]
                        local nextEntry = nextChain[newState]
                        local nextChance = nextEntry[2]
                        
                        local hpInterval = data.hpInterval
                        
                        --lerp
                        --chance = mod:Lerp(chance, nextChance, hpInterval)
                        chance = mod:Lerp(nextChance, chance, hpInterval)
                    end

                    if r < chance then

                        if noIdle then
                            idles = 0
                        end

                        data.IdleWaits = idles
                        data.State = newState
                        data.StateFrame = 0
                        
                        sfx:Play(mod.SFX.Evil)

                        local umbral = 10
                        local resto = (180/3.14159 * mod.ShaderData.solData.TIME/30) % 60
                        if resto < umbral or resto > 60-umbral then
                            mod.ShaderData.solData.TIME = 0
                        end


                        if rng:RandomFloat() < mod.SolConst.ANGRY_CHANCE then
                            mod:SolSpeak("angry", data.hpStage)
                        end

                        --data.State = mod.SolState.BLASTER_B

                        return
                    else
                        r = r - chance
                    end
                end
            end

            if rng:RandomFloat() < mod.SolConst.NEUTRAL_CHANCE then
                mod:SolSpeak("neutral", data.hpStage)
            end

            data.State = mod.SolState.IDLE
            data.StateFrame = 0
        else
            if rng:RandomFloat() < mod.SolConst.SAD_CHANCE then
                mod:SolSpeak("sad", data.hpStage)
            end

            data.State = mod.SolState.IDLE
            data.StateFrame = 0

        end
        
    end

end


function mod:SolDeath(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Sol].VAR and entity.SubType == mod.EntityInf[mod.Entity.Sol].SUB then
        local sprite = entity:GetSprite()
        local data = entity:GetData()
		local room = game:GetRoom()

        mod.ShaderData.solData.ENABLED = false


        sfx:Stop(SoundEffect.SOUND_DOGMA_BLACKHOLE_LOOP)
        sfx:Stop(mod.SFX.Geiger)

        room:MamaMegaExplosion(entity.Position)
        

        --feathers
        if (not mod.CriticalState) then
            for i=1, mod.SolConst.FEATHERS_PARTICLES*2 do
                local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR*2
                local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
            end
        end

        if game.Challenge > 0 then
            --trophy
            if true then
                local trophy = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY, 0, room:GetCenterPos() + Vector(20,100), Vector.Zero, nil)
            end
        else
            --chest
            if false then
                local winChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 0, room:GetCenterPos() + Vector(20,100), Vector.Zero, nil)
                mod:HeavenifyChest()
            end
            
            --void portal
            local void_position = room:GetCenterPos() + Vector(20, -80)
            if true then
                local voidPortal = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, void_position, true)
                voidPortal.VarData = 1
                
                -- Replace the spritesheet to make it look like a Void Portal
                local vsprite = voidPortal:GetSprite()
                vsprite:Load("gfx/grid/voidtrapdoor.anm2", true)
                mod:scheduleForUpdate(function()
                    vsprite.Color = Color(1,1,0.5,1, 1)
                end, 5)
            end

            --edens
            if true then
                for i=-1,1,2 do
                    local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_EDENS_BLESSING, void_position + Vector(i*80, 80), Vector.Zero, nil)
                end
            end

            --cards
            if true then
                for i=0, game:GetNumPlayers ()-1 do
                    local player = game:GetPlayer(i)
                    if player then
                        player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
                        player:UseCard(Card.CARD_SUN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
                    end
                end
            end
        end

        --background
        if true then
			mod:ChangeRoomBackdrop(mod.Backdrops.DELI, true)
        else
            for i, background in ipairs(mod:FindByTypeMod(mod.Entity.Background)) do
                local bsprite = background:GetSprite()
                bsprite.Color = Color(0,0,0,1)
            end
        end

        --unlock
        if entity.I1 == 1 then
            local player = Isaac.GetPlayer(0)
            mod:TrySolUnlock(player:GetPlayerType())
        end

        mod:UpdateDefeat(entity)
    end
end
function mod:SolDying(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Sol].VAR and entity.SubType == mod.EntityInf[mod.Entity.Sol].SUB then

        local sprite = entity:GetSprite()
        local data = entity:GetData()
		local room = game:GetRoom()

        --entity.Visible = false
        --entity.Position = room:GetBottomRightPos()
        --sprite.Color = Color(1,1,1,0)

        room:SetBrokenWatchState(0)

        if sprite:IsPlaying("Death") then
            mod.ShaderData.solData.POSITION = entity.Position + mod.ShaderData.solData.HPSIZE*Vector(0,-100)


            local camera = room:GetCamera()
            camera:SetFocusPosition(entity.Position + Vector(0,-150))
        
            if data.deathFrame == nil then data.deathFrame = 1 end
            sprite.PlaybackSpeed = 1

            mod.ShaderData.solData.TIME = mod.ShaderData.solData.TIME + sprite:GetFrame()/60 + 2

            if sprite:GetFrame() == data.deathFrame then
                data.deathFrame = data.deathFrame + 1

                if sprite:GetFrame() == 1 then
                    mod:KillEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE))
                    mod:KillEntities(mod:FindByTypeMod(mod.Entity.SolHand))
                    --mod:KillEntities(Isaac.FindByType(EntityType.ENTITY_LASER))
                    for i, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
                        if laser.SpawnerEntity and not laser.SpawnerEntity:ToPlayer() then
                            laser:Die()
                        end
                    end

                    game:ShakeScreen(60)

                    local pitch = 0.4
                    sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_CHARGE, 2, 2, false, pitch)
                    sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_OPEN, 2, 2, false, pitch)
                    sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_LOOP, 2, 2, true, pitch)
                    sfx:Stop(mod.SFX.LightBeam)

                    music:Crossfade(Music.MUSIC_DARK_CLOSET, 0.003)

                    mod.ShaderData.solData.EYETARGET = mod.ShaderData.solData.TRUEPOSITION 

                    mod:SolSpeak("sad", 4, 2)

                    data.eyeSprite:Play("Death", true)


                elseif sprite:GetFrame() > 182 and mod.ShaderData.solData.HPSIZE > 0.1 then
                    data.CollapseFlag = true
                elseif sprite:GetFrame() == 331 then--end

                end

                if data.CollapseFlag then
                    mod.ShaderData.solData.HPSIZE = math.max(0.1, mod.ShaderData.solData.HPSIZE - 1/135)
                    
                    local color = Color(1,1,1,1,0,0,0.5)
                    mod.ShaderData.solData.CORONACOLOR = Color.Lerp(mod.ShaderData.solData.CORONACOLOR,color,0.01)
                    mod.ShaderData.solData.BODYCOLOR = Color.Lerp(mod.ShaderData.solData.BODYCOLOR,color,0.01)


                    if mod.ShaderData.solData.HPSIZE == 0.1 then
                        data.CollapseFlag = false
                    end
                end

                if (not mod.CriticalState) then
                    local total = sprite:GetFrame()/20
                    for i=1, total do
                        local velocity = mod:RandomVector(mod.SolConst.FEATHERS_SPEED.X, mod.SolConst.FEATHERS_SPEED.Y)*mod.SolConst.MINI_FEATHERS_SCALAR*2
                        local feather = mod:SpawnEntity(mod.Entity.SolarPaticle, entity.Position, velocity, entity):ToEffect()
                    end
                end
            end
        end
    end
end

function mod:SolLookAt(entity, position)
    mod.ShaderData.solData.EYETARGET = position

    --mod.ShaderData.solData.EYETARGET = mod.ShaderData.solData.EYETARGET or Vector.Zero
    --local direction = (position - entity.Position):Normalized()
    --position = entity.Position + direction
    --mod.ShaderData.solData.EYETARGET = mod:Lerp(mod.ShaderData.solData.EYETARGET, position, 0.5)
end

--Callbacks
--Sol updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SolUpdate, mod.EntityInf[mod.Entity.Sol].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.SolRender, mod.EntityInf[mod.Entity.Sol].ID)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.SolRenderUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.SolDeath, mod.EntityInf[mod.Entity.Sol].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.SolDying, mod.EntityInf[mod.Entity.Sol].ID)


function mod:SolSpeak(tipo, hpStage, div)
    div = div or 1
    local r = 0.1*(1+hpStage/2)
    local p1 = (1-r) + 2*(rng:RandomFloat()*r)
    local p2 = (1-r) + 2*(rng:RandomFloat()*r)
    local p3 = (1-r) + 2*(rng:RandomFloat()*r)

    local mv = 0.8
    local dv = 1.3
    if tipo == "angry" then
        sfx:Play(Isaac.GetSoundIdByName("IsaacAngryIsaac"), 1, 2, false, p1)
        sfx:Play(Isaac.GetSoundIdByName("IsaacAngryMom"), mv, 2, false, p2)
        sfx:Play(Isaac.GetSoundIdByName("IsaacAngryDad"), dv, 2, false, p3)
    elseif tipo == "sad" then
        sfx:Play(Isaac.GetSoundIdByName("IsaacSadIsaac"), 1/div, 2, false, p1)
        sfx:Play(Isaac.GetSoundIdByName("IsaacSadMom"), mv/div, 2, false, p2)
        sfx:Play(Isaac.GetSoundIdByName("IsaacSadDad"), dv/div, 2, false, p3)
    elseif tipo == "neutral" then
        sfx:Play(Isaac.GetSoundIdByName("IsaacNeutralIsaac"), 1, 2, false, p1)
        sfx:Play(Isaac.GetSoundIdByName("IsaacNeutralMom"), mv, 2, false, p2)
        sfx:Play(Isaac.GetSoundIdByName("IsaacNeutralDad"), dv, 2, false, p3)
    end
end



--OTHERS------------------------------------
--GlassGaper
function mod:GlassGaperUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.GlassGaper].VAR and entity.SubType == mod.EntityInf[mod.Entity.GlassGaper].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
    
        if not data.Init then
            data.Init = true
            data.Flaged = false
            
            local limit = 4
            if rng:RandomFloat() < 0.5 then
                limit = 8
            end
            sprite:PlayOverlay("Head"..tostring(mod:RandomInt(1,limit)), true)
            sprite:SetOverlayRenderPriority(false)
    
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
    
            entity:SetColor(mod.Colors.white, 30, 1, true, true)
    
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position, Vector.Zero, entity)
        end
    
        sprite.FlipX = false
        if entity.Velocity:Length() <= 0 then
            sprite:Play("WalkV", true)
            sprite:Stop()
        else
            if entity.Velocity.X > 0 then
                if not sprite:IsPlaying("WalkR") then
                    sprite:Play("WalkR", true)
                end
            elseif entity.Velocity.X < 0 then
                if not sprite:IsPlaying("WalkL") then
                    sprite:Play("WalkL", true)
                end
            else
                if not sprite:IsPlaying("WalkV") then
                    sprite:Play("WalkV", true)
                end
            end
        end
    
        if not data.Flaged and entity.FrameCount > 300 then
            if rng:RandomFloat() < 0.025 then
                data.Flaged = true
                entity:SetColor(mod.Colors.white, 90, 1, true, true)
                mod:scheduleForUpdate(function()
                    if entity and entity:Exists() then
                        for i=0, 8 do
                            local angle = i*360/8
                            --Ring projectiles:
                            local glass = mod:SpawnEntity(mod.Entity.GlassShard, entity.Position, Vector(mod.UConst.TURD_ICICLE_SPEED,0):Rotated(angle), entity):ToProjectile()
                            glass:GetData().Sol = true
                            entity:Die()
                        end
                    end
                end, 60)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.GlassGaperUpdate, mod.EntityInf[mod.Entity.GlassGaper].ID)
function mod:GlassGaperDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.GlassGaper].VAR and entity.SubType == mod.EntityInf[mod.Entity.GlassGaper].SUB then
		sfx:Play(Isaac.GetSoundIdByName("IceBreak"), 0.45)
		game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 25, 6,  mod.Colors.yellowGlass)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.GlassGaperDeath, mod.EntityInf[mod.Entity.GlassGaper].ID)

--Solar Blaster------------------------------------------------------------------------------------------------------------------------------
function mod:SolarBlasterUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.SolarBlaster].VAR and entity.SubType == mod.EntityInf[mod.Entity.SolarBlaster].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if not data.Init then
            data.Init = true

            data.Color = data.Color or Color.Default

            data.Angle = data.Angle or 0
            sprite.Rotation = data.Angle

            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_HIDE_HP_BAR)
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            sprite:Play("Idle", true)

            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

            --trace
            if data.Trace then
                local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()
                if tracer then
                    tracer:FollowParent(entity)
                    tracer.LifeSpan = 30
                    tracer.Timeout = tracer.LifeSpan
                    tracer.TargetPosition = Vector(1, 0):Rotated(data.Angle)
                    tracer:GetSprite().Color = data.Color

                    tracer:Update()
                end
            end

            sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE, 0.8, 2, false, 1.5)
            sfx:Play(SoundEffect.SOUND_BOSS_LITE_HISS, 0.8, 2, false, 0.67)
        end

        entity.Velocity = Vector.Zero

        if sprite:IsEventTriggered("Attack") then
                
            local timeout = 5

            local laser = mod:SpawnEntity(mod.Entity.SolLaser, entity.Position, Vector.Zero, entity):ToLaser()
            laser.Angle = data.Angle
            laser.Timeout = timeout
            laser.Parent = entity

            laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

            laser:GetSprite().Color = data.Color
            laser:Update()
            laser:SetColor(data.Color, 9999, 99, true, true)

            laser:SetScale(0.75)

            laser.CollisionDamage = 1

        end

        if sprite:IsFinished() then
            entity.Velocity = -Vector.FromAngle(data.Angle)*50
        end

        if entity.FrameCount > 70 then
            entity:Remove()
        end

    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SolarBlasterUpdate, mod.EntityInf[mod.Entity.SolarBlaster].ID)

--Solar Galaxy------------------------------------------------------------------------------------------------------------------------------
function mod:GalaxyBlasterUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.SolarBlaster].VAR and entity.SubType == mod.EntityInf[mod.Entity.SolarBlaster].SUB+1 then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        local parent = entity.Parent and entity.Parent:ToNPC()

        if parent then
            local target = parent:GetPlayerTarget()
            local parentData = parent:GetData()

            if not data.Init then
                data.Init = true
    
                data.Color = parentData.Color
                entity:SetColor(data.Color, 9999, 99, true, true)
    
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_HIDE_HP_BAR)
                entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                sprite:Play("Idle", true)
    
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    
                sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE, 0.8, 2, false, 1.5)
                sfx:Play(SoundEffect.SOUND_BOSS_LITE_HISS, 0.8, 2, false, 0.67)

                data.Sign = data.Sign or 1

                data.AngleOffset = data.AngleOffset or 0
                data.DistFromParent = ((parentData.HpPercentSqrd)*210 + (1-parentData.HpPercentSqrd)*125)
                data.OrbitPosition = Vector(data.DistFromParent, 0):Rotated(data.AngleOffset)

                data.RealTargetPos = target.Position + target.Velocity*10
                data.CurrentTargetPos = data.RealTargetPos

                data.WarningCount = 0

                
                local laser = mod:SpawnEntity(mod.Entity.SolWarningLaser, entity.Position, Vector.Zero, entity):ToLaser()
                laser.Angle = data.AngleOffset
                laser.Timeout = 30*15
                laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
        
                laser.DisableFollowParent = false
                laser.Parent = entity
                laser:GetSprite().Color = parentData.Color

                --laser.SpriteOffset = Vector(0,40)

                laser:Update()
                laser:SetColor(data.Color, 9999, 99, true, true)

                entity.Child = laser
            end

            if entity.Child then


                local p1 = target.Position:Distance(entity.Position) + entity.Position:Distance(parent.Position)
                local p2 = target.Position:Distance(parent.Position)
    
                local flag = target.Position:Distance(parent.Position) < data.DistFromParent
    
                if (math.abs(p1-p2) < data.DistFromParent and entity.FrameCount > 75) or flag then
                    data.WarningCount = data.WarningCount + 1
                    if (math.abs(p1-p2) < 15 or flag) and data.WarningCount > 30 then
                        if entity.Child then 
                            entity.Child.Visible = false
                            entity.Child:Remove() 
                        end
    
                        data.ShotAngle = (data.CurrentTargetPos - entity.Position):GetAngleDegrees()
    
                        local laser = mod:SpawnEntity(mod.Entity.SolLaser, entity.Position, Vector.Zero, entity):ToLaser()
                        laser.Angle = data.ShotAngle
                        laser.Timeout = 5
                        laser.Parent = entity
            
                        laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
            
                        laser:GetSprite().Color = data.Color
                        laser:Update()
                        laser:SetColor(data.Color, 9999, 99, true, true)
            
                        laser.CollisionDamage = 1
    
                        data.DeadFrame = entity.FrameCount + 70
                        sprite:Play("Death", true)
    
                    end
    
                    local laser = entity.Child
                    if laser  then 
                        laser.Visible = true
                        laser:GetSprite().Color.A = math.min(1, data.WarningCount/15)
                        laser:SetColor(laser:GetSprite().Color, 9999, 99, true, true)
                    end
                else
                    if entity.Child  then entity.Child.Visible = false end
                    data.WarningCount = 0
                end

                --trace
                local laser = entity.Child:ToLaser()

                data.RealTargetPos = target.Position + target.Velocity*10
                data.CurrentTargetPos = mod:Lerp(data.CurrentTargetPos, data.RealTargetPos, 0.05)
    
                data.OrbitPosition = data.OrbitPosition:Rotated(data.Sign*(2+parentData.hpStage/8))
                local orbitPos = data.OrbitPosition + parent.Position
                entity.Position = mod:Lerp(entity.Position, orbitPos, 0.05)
                local direction = (orbitPos - entity.Position)
                entity.Velocity = direction/15


                local angle = (data.CurrentTargetPos - entity.Position):GetAngleDegrees()
                laser.Angle = angle
            else
                --entity.Velocity = -Vector.FromAngle(data.ShotAngle)*50
            end

            if sprite:IsFinished("Death") or entity.FrameCount >= 30*20 or (entity.SpriteScale.X < 0.1 or data.DeadFrame and entity.FrameCount >= data.DeadFrame) then
                entity:Remove()
            end
            
        else
            entity:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.GalaxyBlasterUpdate, mod.EntityInf[mod.Entity.SolarBlaster].ID)

--Solar Snake---------------------------------
function mod:SolSnakeHeadUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.SolSnake].VAR and entity.SubType == mod.EntityInf[mod.Entity.SolSnake].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()

        if not data.Init then
            data.Init = true
            sprite:Play("Idle", true)

            data.hpStage = data.hpStage or 1
            data.Color = data.Color or sprite.Color

            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_HIDE_HP_BAR)

            data.UnitVelocity = Vector.Zero

            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            
            local amount = math.ceil(mod.SolConst.SNAKE_AMOUNT * (1+data.hpStage/12))
            local parent = entity
            for i=1, amount do
                local newSnake = mod:SpawnEntity(mod.Entity.SolSnake, parent.Position, Vector.Zero, parent, nil, mod.EntityInf[mod.Entity.SolSnake].SUB+1):ToNPC()
                newSnake:GetSprite():Play("Tail", true)
                newSnake:GetSprite().Color = data.Color
                newSnake:SetColor(data.Color, -1, 99, true, true)
                newSnake:GetData().hpStage = data.hpStage
                
                newSnake.EntityCollisionClass = entity.EntityCollisionClass
                newSnake:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)

                newSnake.SpriteScale = entity.SpriteScale*(1 - i/amount*0.5)
                newSnake.Scale = newSnake.SpriteScale.X
                newSnake:SetSize(newSnake.Size*newSnake.Scale, Vector.One, 12)

                newSnake.Parent = parent
                parent.Child = newSnake

                parent = newSnake
            end
        end

        local timeout = mod.SolConst.SNAKE_TIMEOUT * (1+data.hpStage/6)
        if data.Returning then

            if entity.FrameCount > timeout + 180 then
                entity:Remove()
                for i, segment in ipairs(mod:FindByTypeMod(mod.Entity.SolSnake, nil, mod.EntityInf[mod.Entity.SolSnake].SUB+1)) do
                    segment:Remove()    
                end
            end

            
            data.UnitVelocity = data.UnitVelocity*1.1
            entity.Velocity = data.UnitVelocity
            
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            local direction = (target.Position - entity.Position):Normalized()
            data.UnitVelocity = mod:Lerp(data.UnitVelocity, direction, 0.02)

            local dot = ((data.UnitVelocity.X * direction.X) + (data.UnitVelocity.Y * direction.Y) + 0.5)*2
            local speed = mod.SolConst.SNAKE_SPEED * (1+data.hpStage/6)
            entity.Velocity = data.UnitVelocity * (dot * speed)


            if entity.FrameCount > timeout then
                data.UnitVelocity = entity.Velocity
                data.Returning = true
            end
        end

        local child = entity.Child
        while child do
            mod:FamiliarParentMovement(child, 2, 1.5, 10)

            if false and rng:RandomFloat() < (0.01*(1+data.hpStage/4)) then
                local direction = child.Velocity:Rotated(180):Normalized():Rotated(mod:RandomInt(-45,45))
                local speed = mod.SolConst.SNAKE_STAR_SPEED*(1+data.hpStage/6)
                local velocity = direction*speed

                local star = mod:SpawnEntity(mod.Entity.Star8, child.Position, velocity, entity):ToProjectile()
                local starSprite = star:GetSprite()

                star.SpriteScale = ((entity.SpriteScale)*0.2 + 0.8*Vector.One)/2
                starSprite.Color = data.Color

                star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

                mod:TearFallAfter(star, 270)

            end

            child.EntityCollisionClass = entity.EntityCollisionClass
            child = child.Child
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SolSnakeHeadUpdate, mod.EntityInf[mod.Entity.SolSnake].ID)

--Solar Statue---------------------------------
function mod:StatueAppearSol(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.BossSolStatue].VAR and entity.SubType == mod.EntityInf[mod.Entity.BossSolStatue].SUB then
        if #mod:FindByTypeMod(mod.Entity.Sol) == 0 then
            local sol = mod:SpawnEntity(mod.Entity.Sol, entity.Position, Vector.Zero, nil):ToNPC()
            sol:Update()
            game:ShakeScreen(60)
    
            sfx:Play(SoundEffect.SOUND_BEAST_ANGELIC_BLAST, 0.67)
            sfx:Play(mod.SFX.SolSummon)
    
            sol.I1 = 1
        end
    end
end
function mod:SolarStatueUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.BossSolStatue].VAR and entity.SubType == mod.EntityInf[mod.Entity.BossSolStatue].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()

        if not data.Init then
            data.Init = true
            
            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_HIDE_HP_BAR)

            sprite:Play("Idle", true)
                
            --Music
            mod:PlayRoomMusic(mod.Music.HEAVEN_FLOOR)
        end

        entity.Position = room:GetCenterPos()

        local n = 30*5
        if entity.FrameCount == n then
            sprite:Play("Crack1", true)
        elseif entity.FrameCount > n then
            game:ShakeScreen(15)

            if sprite:IsFinished("Crack1") then
                sprite:Play("Crack2", true)
            elseif sprite:IsFinished("Crack2") then
                sprite:Play("Crack3", true)
            elseif sprite:IsFinished("Crack3") then
                sprite:Play("Death", true)
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            elseif sprite:IsFinished("Death") then
                entity:Remove()
            end

            if sprite:IsEventTriggered("Appear") then
                mod:StatueAppearSol(entity)

            elseif sprite:IsEventTriggered("Crack") then

                sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK)
        
                entity:SetColor(Color(1, 1, 1, 1, 1,1,1), 15, 1, true, true)
                sfx:Play(SoundEffect.SOUND_GLASS_BREAK)
                game:SpawnParticles (entity.Position, EffectVariant.DIAMOND_PARTICLE, 15, 9,  mod.Colors.yellowGlass)
                game:ShakeScreen(15)
            end
        end

    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SolarStatueUpdate, mod.EntityInf[mod.Entity.BossSolStatue].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.StatueAppearSol, mod.EntityInf[mod.Entity.BossSolStatue].ID)


--Solar Sword------------------------------------------------------------------------------------------------------------------------------
function mod:SolSwordUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.SolSword].VAR and entity.SubType == mod.EntityInf[mod.Entity.SolSword].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        local parent = entity.Parent and entity.Parent:ToNPC()

        if parent then
            if not data.Init then
                data.Init = true
    
                data.hpStage = data.hpStage or 1
                data.Size = data.Size or 1
                data.Spin = data.Spin or 1
                data.SSize = data.Size*30
                data.Angle = data.Angle or 0
                data.OgAngle = data.OgAngle or 0
                data.Color = data.Color or Color.Default
                
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_HIDE_HP_BAR)
                
                --entity:SetSize(data.SSize, Vector(3*data.Size, 1), 12)

                entity.SpriteScale = (data.Size*0.5 + 0.5)*Vector.One
                entity.Scale = entity.SpriteScale.X

                sprite:Play("Appear", true)
            end
    
            if sprite:IsFinished("Appear") then
                sprite:Play("Extend2", true)
            elseif sprite:IsFinished("Extend") or sprite:IsFinished("Extend2") then
                sprite:Play("Idle", true)
            elseif sprite:IsFinished("Death") then

                --ded
                entity:Remove()
            end

            if sprite:IsPlaying("Death") and sprite:GetFrame() == 0 then
                local repeats = data.hpStage

                local entitypos = entity.Position
                local entityscale = entity.SpriteScale
                local color = {data.Color.R, data.Color.G, data.Color.B, data.Color.A, data.Color.RO, data.Color.GO, data.Color.BO}

                for i=0, repeats do
                    mod:scheduleForUpdate(function()

                        --projs
                        local space = 50
                        local amount = math.sqrt(data.Size)*6
                        local offset = (i%2)*space/2
        
                        for i=-amount/2, amount/2 do
                            local ni = amount/2 + i
                            local nni = ni/amount
        
                            local position = entitypos + i*Vector(space+offset, 0):Rotated(data.OgAngle)
        
                            local speed = mod.SolConst.SWORD_PROJ_SPEED*(1+data.hpStage/6)*(1+nni)
                            local angle = data.OgAngle - 120*data.Spin*(1-nni)
                            local velocity = Vector(speed, 0):Rotated(angle)
        
                            local flare = mod:SpawnEntity(mod.Entity.Flare, position, velocity, entity or parent):ToProjectile()
                            local flareSprite = flare:GetSprite()
            
                            flare.SpriteScale = (entityscale*0.2 + 0.8*Vector.One)
                            flareSprite.Color = Color(color[1],color[2],color[3],color[4],color[5],color[6],color[7])
            
                            flare:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            
                            mod:TearFallAfter(flare, 480)
                        end
                        sfx:Play(mod.SFX.Fireblast, 1, 2, false, 1)
                    end, i*12)
                end
            end

            if sprite:IsPlaying("Appear") then
                entity:SetSize(1, Vector(3*data.Size, 0.5), 12)
            elseif sprite:IsPlaying("Extend") or sprite:IsPlaying("Extend2") then
                local size = sprite:GetFrame()/30
                entity:SetSize(size*data.SSize, Vector(size*3*data.Size, 0.5), 12)
            elseif sprite:IsPlaying("Idle") then
                entity:SetSize(data.SSize, Vector(3*data.Size, 0.5), 12)
            end
    
            local angle = data.Angle

            sprite.Rotation = angle
            local offset = Vector(250*math.sqrt(data.Size),0):Rotated(angle)
            entity.Position = parent.Position + offset

            --trace
            if true then
                local trace = mod:SpawnEntity(mod.Entity.SolSwordTrace, entity.Position, Vector.Zero, entity):ToEffect()
                trace.Parent = entity
                trace.Visible = false
                trace:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            end
        else
            entity:Remove()
        end
        
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SolSwordUpdate, mod.EntityInf[mod.Entity.SolSword].ID)

--EFFECTS------------------------------------------------------------------------------------------------------------------------------
--StarBig
function mod:StarBigUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.StarBig].SUB then
        local data = effect:GetData()
        local sprite = effect:GetSprite()

        if not data.Init then
            data.Init = true

            sfx:Play(mod.SFX.Starfall)

            local parent = effect.Parent or effect.SpawnerEntity
            if parent then
                data.SpriteScale = parent.SpriteScale
                data.Color = parent:GetData().Color
            else
                data.SpriteScale = Vector.One * 0.5
                data.Color = Color(1,1,1,1,1,1,1)
            end
            
        end

        if sprite:IsFinished("Idle") then
            local parent = effect.Parent or effect.SpawnerEntity
            local hpStage = data.hpStage or 1
        
            --rign
            local angleOffset = rng:RandomFloat()*360
            local amount = math.ceil(mod.SolConst.ZODIAC_RING*(1+hpStage/12))
            local speed = mod.SolConst.ZODIAC_RING_SPEED*3--*(1+hpStage/6)


            for i=1, amount do
                local angle = i*360/amount+angleOffset

                local velocity = Vector.FromAngle(angle)*speed

                local star = mod:SpawnEntity(mod.Entity.Star5, effect.Position, velocity, parent):ToProjectile()
                local starSprite = star:GetSprite()

                star.Acceleration = 0.9 - 0.05*rng:RandomFloat()

                star.SpriteScale = (data.SpriteScale*0.2 + 0.8*Vector.One)/2
                starSprite.Color = data.Color

                star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.ACCELERATE)

                mod:TearFallAfter(star, 160)
            end
            
            game:ShakeScreen(15)

            game:BombExplosionEffects(effect.Position, 10, TearFlags.TEAR_NORMAL, mod.Colors.white, nil, 1, true, false, DamageFlag.DAMAGE_EXPLOSION )
            mod:scheduleForUpdate(function()
                sfx:Stop(SoundEffect.SOUND_BOSS1_EXPLOSIONS)
                sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 2, false, 5)
            end, 2)

                
            sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER, 1, 2, false, 1)
            sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1.5, 2, false, 1)
            
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.StarBigUpdate, mod.EntityInf[mod.Entity.StarBig].VAR)

--Projectile Death
function mod:ProjectileDeathUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolProjectileDeath].SUB then
        local sprite = effect:GetSprite()
    
        if sprite:IsFinished() then
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ProjectileDeathUpdate, mod.EntityInf[mod.Entity.SolProjectileDeath].VAR)

--StarTarget
function mod:SolStarTargetUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolStarTarget].SUB then
        local data = effect:GetData()
        local sprite = effect:GetSprite()

        if data.Init == nil then
            data.Init = true
            sprite:Play("Blink",true)
            effect.DepthOffset = -100

            data.hpStage = data.hpStage or 1
        end

        if effect.Timeout == math.floor(mod.SolConst.STARFALL_TIMER/2) then

            local star = mod:SpawnEntity(mod.Entity.StarBig, effect.Position, Vector.Zero, effect.Parent)
            star.Parent = effect.Parent
            star:GetSprite().Color = sprite.Color
            star:GetData().hpStage = data.hpStage or 1

        elseif effect.Timeout <= 1 then

            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolStarTargetUpdate, mod.EntityInf[mod.Entity.SolStarTarget].VAR)
--LightTarget
function mod:SolLightTargetUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolLightTarget].SUB then
        local data = effect:GetData()
        local sprite = effect:GetSprite()

        if data.Init == nil then
            data.Init = true
            sprite:Play("Blink",true)
            effect.DepthOffset = -100
        end

        if effect.Timeout <= 1 then
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolLightTargetUpdate, mod.EntityInf[mod.Entity.SolLightTarget].VAR)

--TimeVent
function mod:SolTimeVentUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolTimeVent].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()
        local room = game:GetRoom()

        if not data.Init then
            data.Init = true
            data.TimeCounter = 0
            data.Valid = false

            local timestuck = mod:SpawnEntity(mod.Entity.TimeFreezeSource, effect.Position, Vector.Zero, effect):ToEffect()
            timestuck:FollowParent(effect)
            timestuck:GetSprite().Color = sprite.Color
            timestuck.SpriteScale = (effect.SpriteScale)*0.75
    	    timestuck:GetData().Timestop_inmune = 2
        
            data.OriginState = room:GetBrokenWatchState()
            
            sfx:Play(mod.SFX.FcukClock, 1, 2, false)
            sfx:Play(mod.SFX.TimeResume, 1)
        end

        effect.Velocity = effect.Velocity*0.95

        local flag = false
        if data.Valid then
            local scale = effect.SpriteScale.X*260
            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                if player.Position:Distance(effect.Position) < scale and not player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
                    flag = true
                    break
                end
            end
        end

        if flag then
            if data.OriginState == 0 then
                room:SetBrokenWatchState(2)
            elseif data.OriginState == 1 then
                room:SetBrokenWatchState(0)
            end
        else
            room:SetBrokenWatchState(data.OriginState or 0)
        end
        

        if sprite:IsFinished("Appear") then
            sprite:Play("Idle", true)
            data.Valid = true
        elseif sprite:IsFinished("Idle") then
            data.TimeCounter = data.TimeCounter + 1
            if data.TimeCounter >= mod.SolConst.TIME_VENT_TIME then
                data.Valid = false
                sprite:Play("Death", true)
                room:SetBrokenWatchState(data.OriginState)
            else
                sprite:Play("Idle", true)
            end
        elseif sprite:IsFinished("Death") then
            room:SetBrokenWatchState(data.OriginState)
            effect:Remove()

            sfx:Stop(mod.SFX.FcukClock)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolTimeVentUpdate, mod.EntityInf[mod.Entity.SolTimeVent].VAR)
--Sol Eye
function mod:SolEyeUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolEye].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()
        local room = game:GetRoom()

        if not data.Init then
            data.Init = true
            data.hpStage = data.hpStage or 1
            data.Color = data.Color or Color.Default

            data.Tears = {}
            local homingRing = math.ceil(mod.SolConst.HOMING_RING*(1+data.hpStage/6))*2
            for i = 1, homingRing do
                local star = mod:SpawnEntity(mod.Entity.Star4, effect.Position, Vector.Zero, effect.SpawnerEntity):ToProjectile()
                local starSprite = star:GetSprite()

                star.SpriteScale = ((effect.SpriteScale)*0.2 + 0.8*Vector.One)/2
                starSprite.Color = data.Color

                star:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                star.GridCollisionClass = GridCollisionClass.COLLISION_NONE

                star:GetData().Redirected = true

                mod:TearFallAfter(star, 9999)
                table.insert(data.Tears, star)
            end

            data.Angle = 0

            sfx:Play(SoundEffect.SOUND_GFUEL_EXPLOSION_BIG, 2, 2, false, 4)
        end
        local hpStage = data.hpStage
        local angle = data.Angle

        local homingRing = math.ceil(mod.SolConst.HOMING_RING*(1+hpStage/9))*2
        local homingDist = mod.SolConst.HOMING_DIST*(1-hpStage/3*0.15)*1.1

        if data.Catched then
            if data.ShotFrame and effect.FrameCount >= data.ShotFrame then
                --stars
                for i, star in ipairs(data.Tears) do
                    star = star:ToProjectile()
                    local direction = (effect.Position-star.Position):Normalized()
                    star.Velocity = direction*30
                    mod:TearFallAfter(star, 120)
                end
                effect:Remove()

                sfx:Play(SoundEffect.SOUND_GFUEL_RICOCHET, 2)
                sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD, 1)

            else
                --stars
                for i, star in ipairs(data.Tears) do
                    star = star:ToProjectile()
                    star.Height = -23
                    star.FallingAccel = 0
                    local trueAngle = 360*i/homingRing + angle
                    local position = effect.Position + Vector(homingDist,0):Rotated(trueAngle)
    
                    local direction = (position-star.Position)/10
    
                    star.Velocity = direction
                end

            end
        else
            data.Angle = data.Angle + 1
            --stars
            for i, star in ipairs(data.Tears) do
                star = star:ToProjectile()
                star.Height = -23
                star.FallingAccel = 0
                local trueAngle = 360*i/homingRing + angle
                local position = effect.Position + Vector(homingDist,0):Rotated(trueAngle)

                local direction = (position-star.Position)/10

                star.Velocity = direction
            end

            --eye
            local target = effect.Child
            if target then
                local direction = (target.Position - effect.Position)/30
                effect.Velocity = direction

                if target.Position:Distance(effect.Position) < 20 then
                    data.Catched = true
                    data.ShotFrame = effect.FrameCount + 30
                    effect.Velocity = Vector.Zero
                    
                    sfx:Play(SoundEffect.SOUND_GFUEL_ROCKETLAUNCHER, 2, 2, false, 4)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolEyeUpdate, mod.EntityInf[mod.Entity.SolEye].VAR)
--Sol Sword trace
function mod:SolSwordTraceUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolSwordTrace].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()
        local room = game:GetRoom()

        local parent = effect.Parent and effect.Parent:ToNPC()

        if parent then
            local pSprite = parent:GetSprite()
            local pData = parent:GetData()

            if not data.Init then
                data.Init = true

                sprite:SetFrame(pSprite:GetAnimation(), pSprite:GetFrame())
                sprite:Stop()

                sprite.Rotation = pSprite.Rotation

                local color = parent:GetData().Color or Color.Default
                sprite.Color = color

                effect.SpriteScale = parent.SpriteScale
                effect.Scale = effect.SpriteScale.X
                
                effect.Visible = true
            end
            
        elseif not data.Init then
            effect:Remove()
        end

        if data.Init then

            sprite.Color.A = mod:Lerp(sprite.Color.A, 0, 0.1)
            
            effect.SpriteScale = effect.SpriteScale*1.005

            if sprite.Color.A < 0.01 then
                effect:Remove()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolSwordTraceUpdate, mod.EntityInf[mod.Entity.SolSwordTrace].VAR)
--Sol Wing trace
function mod:SolWingTraceUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolWingTrace].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()
        local room = game:GetRoom()

        local parent = effect.Parent and effect.Parent:ToNPC()

        if parent then
            local pSprite = parent:GetSprite()
            local pData = parent:GetData()

            if not data.Init then
                data.Init = true

                sprite:Play("Idle")
                sprite:SetFrame("Idle", pSprite:GetFrame())

                sprite.Rotation = pSprite.Rotation

                local color = parent:GetData().Color or Color.Default
                sprite.Color = color

                effect.SpriteScale = parent.SpriteScale
                effect.Scale = effect.SpriteScale.X
                
                effect.Visible = true
            end
            
        elseif not data.Init then
            effect:Remove()
        end

        if data.Init then
            sprite:Update()

            sprite.Color.A = mod:Lerp(sprite.Color.A, 0, 0.1)
            
            effect.SpriteScale = effect.SpriteScale*1.005

            if sprite.Color.A < 0.01 then
                effect:Remove()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolWingTraceUpdate, mod.EntityInf[mod.Entity.SolWingTrace].VAR)

--Star zodiac
function mod:StarZodiacUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.StarZodiac].SUB then
        if effect:GetSprite():IsFinished("Idle") then
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.StarZodiacUpdate, mod.EntityInf[mod.Entity.StarZodiac].VAR)

--Solar particle
function mod:SolarParticleUpdate(effect)
    if effect.SubType == mod.EntityInf[mod.Entity.SolarPaticle].SUB then
        local sprite = effect:GetSprite()
        local data = effect:GetData()

        if not data.Init then
            effect.Visible = true
            data.Init = true
            data.Speed = 5*(1+rng:RandomFloat())
            data.FromPlayer = data.FromPlayer or false
            data.FromFamiliar = data.FromFamiliar or false

            sprite.PlaybackSpeed = 0.1 + 0.1*rng:RandomFloat()

            if data.FromPlayer then
                sprite.Scale = Vector.One*0.25
                local h = 1
                local color = Color.Lerp(Color.Default, Color(1,1,1,1,1,1,2), h)
                sprite.Color = color
                sprite.Color.A = 0.5

            elseif data.FromFamiliar then
                sprite.Scale = Vector.One*0.15
                local h = 1
                local color = Color.Lerp(Color.Default, Color(1,1,1,1,1,1,1), h)
                sprite.Color = color
                sprite.Color.A = 0.5

                sprite.PlaybackSpeed = sprite.PlaybackSpeed*2

            else
                sprite.Scale = Vector.One*mod.ShaderData.solData.HPSIZE
                local h = -1.49925*mod.ShaderData.solData.HPSIZE + 1.87406
                local color = Color.Lerp(Color.Default, Color(1,1,1,1,1,1,1), h)
                sprite.Color = color
                sprite.Color.A = 0.5

            end

        end
        sprite.Rotation = sprite.Rotation + data.Speed
        data.Speed = data.Speed*0.99

        effect.Velocity = effect.Velocity * 0.9 

        sprite.Scale = sprite.Scale*0.98
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.SolarParticleUpdate, mod.EntityInf[mod.Entity.SolarPaticle].VAR)

--PROJECTILES------------------------------------------------------------------------------------------------------------------------------
--SolarFlare
function mod:SolFlareUpdate(tear, collider, collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

	if tear.SubType == mod.EntityInf[mod.Entity.Flare].SUB then

		if data.Init == nil then
			data.Init = true
			--Sprite
			sprite:Play("Idle", true)
			--sprite.Rotation = tear.Velocity:GetAngleDegrees()
			
			sprite:SetFrame(mod:RandomInt(1,31))
			sprite.PlaybackSpeed = rng:RandomFloat()*0.5 + 1.5

			sprite.FlipX = mod:RandomInt(0,1)==0
			sprite.FlipY = mod:RandomInt(0,1)==0

			sprite.Rotation = rng:RandomFloat()*360

		end
        tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        
        
        if (not game:GetRoom():IsPositionInRoom(tear.Position, 0)) and mod:DotProduct(tear.Velocity, game:GetRoom():GetCenterPos() - tear.Position) < 0 then
            tear:Die()
        end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)
			impact:GetSprite().Color = sprite.Color
			impact.SpriteScale = tear.SpriteScale
			
			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.SolFlareUpdate, mod.EntityInf[mod.Entity.Flare].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.SolFlareUpdate, mod.EntityInf[mod.Entity.Flare].VAR)

--4Star------------------------------------------------------------------------------------------------------------------------------
function mod:Star4Update(tear, collider, collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

	if tear.SubType == mod.EntityInf[mod.Entity.Star4].SUB then

		if data.Init == nil then
			data.Init = true
			data.Redirected = data.Redirected or false
			--Sprite
			sprite:Play("Idle", true)

            
            if (not mod.CriticalState) then
                local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, tear.Position, Vector.Zero, nil):ToEffect()
                if trail then
                    trail:FollowParent(tear)
                    trail.Color = tear.SpawnerEntity:GetData().Color
                    trail.MinRadius = 0.05
                    trail.SpriteScale = tear.SpriteScale*3.5
                    trail.ParentOffset = Vector(0,-45 * tear.SpriteScale.Y)
    
                    trail:GetData().HC = true
            
                    trail:Update()
                end
            end
		end

        if not data.Redirected then
            if (tear.FrameCount >= 50) and rng:RandomFloat() < 0.5 then
                data.Redirected = true
                tear.ProjectileFlags = tear.ProjectileFlags

                mod:TearFallAfter(tear, 150)

                local target = tear.Parent and tear.Parent:ToNPC() and tear.Parent:ToNPC():GetPlayerTarget()
                if target then
                    tear.Velocity = (target.Position - tear.Position):Normalized()*mod.SolConst.BURST_SPEED_2
                end
                
                tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

                sfx:Play(SoundEffect.SOUND_BEAST_SURFACE_GROWL, 1, 2, false, 2.5)

            else
                tear.Velocity = mod:Lerp(tear.Velocity, Vector.Zero, 0.01)

            end

        elseif (tear.FrameCount >= 100) then
            if not game:GetRoom():IsPositionInRoom(tear.Position, 0) then
                tear:Die()
            end
        end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)
			impact:GetSprite().Color = sprite.Color
			impact.SpriteScale = tear.SpriteScale
			
			local star = mod:SpawnEntity(mod.Entity.SolProjectileDeath, tear.Position, Vector.Zero, nil)
			star:GetSprite():Play("4Star", true)
			star:GetSprite().Color = sprite.Color
            star.SpriteOffset = Vector(0, tear.Height)
			star.SpriteScale = tear.SpriteScale
			
			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.Star4Update, mod.EntityInf[mod.Entity.Star4].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.Star4Update, mod.EntityInf[mod.Entity.Star4].VAR)

--5Star------------------------------------------------------------------------------------------------------------------------------
function mod:Star5Update(tear, collider, collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()
    local spawnerEntity = tear.SpawnerEntity

	if tear.SubType == mod.EntityInf[mod.Entity.Star5].SUB then

		if data.Init == nil then
			data.Init = true
			--Sprite
			sprite:Play("Idle", true)
			--sprite.Rotation = tear.Velocity:GetAngleDegrees()

			sprite.Rotation = rng:RandomFloat()*360

            if (not mod.CriticalState) then
                local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, tear.Position, Vector.Zero, nil):ToEffect()
                if trail then
                    trail:FollowParent(tear)
                    trail.Color = spawnerEntity and spawnerEntity:GetData().Color or Color.Default
                    trail.MinRadius = 0.05
                    trail.SpriteScale = tear.SpriteScale*3.5
                    trail.ParentOffset = Vector(0,-45 * tear.SpriteScale.Y)
            
                    trail:GetData().HC = true
    
                    trail:Update()
                end
            end
		end
        
        if not game:GetRoom():IsPositionInRoom(tear.Position, 0) then
            tear:Die()
        end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)
			impact:GetSprite().Color = sprite.Color
			impact.SpriteScale = tear.SpriteScale
			
			local star = mod:SpawnEntity(mod.Entity.SolProjectileDeath, tear.Position, Vector.Zero, nil)
			star:GetSprite():Play("5Star", true)
			star:GetSprite().Color = sprite.Color
            star.SpriteOffset = Vector(0, tear.Height)
			star.SpriteScale = tear.SpriteScale

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.Star5Update, mod.EntityInf[mod.Entity.Star5].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.Star5Update, mod.EntityInf[mod.Entity.Star5].VAR)

--8Star------------------------------------------------------------------------------------------------------------------------------
function mod:Star8Update(tear, collider, collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

	if tear.SubType == mod.EntityInf[mod.Entity.Star8].SUB then

		if data.Init == nil then
			data.Init = true
			--Sprite
			sprite:Play("Idle", true)
			--sprite.Rotation = tear.Velocity:GetAngleDegrees()

			sprite.Rotation = rng:RandomFloat()*360

            if false then
                if (not mod.CriticalState) then
                    local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, tear.Position, Vector.Zero, nil):ToEffect()
                    if trail then
                        trail:FollowParent(tear)
                        trail.Color = tear.SpawnerEntity:GetData().Color
                        trail.MinRadius = 0.05
                        trail.SpriteScale = tear.SpriteScale*3.5
                        trail.ParentOffset = Vector(0,-46 * tear.SpriteScale.Y)
                
                        trail:GetData().HC = true
    
                        trail:Update()
                    end
                end
            end
		end
        
        if not game:GetRoom():IsPositionInRoom(tear.Position, 0) then
            tear:Die()
        end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)
			impact:GetSprite().Color = sprite.Color
			impact.SpriteScale = tear.SpriteScale
			
			local star = mod:SpawnEntity(mod.Entity.SolProjectileDeath, tear.Position, Vector.Zero, nil)
			star:GetSprite():Play("8Star", true)
			star:GetSprite().Color = sprite.Color
            star.SpriteOffset = Vector(0, tear.Height)
			star.SpriteScale = tear.SpriteScale

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.Star8Update, mod.EntityInf[mod.Entity.Star8].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.Star8Update, mod.EntityInf[mod.Entity.Star8].VAR)

--SolarBigFlare------------------------------------------------------------------------------------------------------------------------------
function mod:SolBigFlareUpdate(tear, collider, collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

	if tear.SubType == mod.EntityInf[mod.Entity.BigFlare].SUB then
		if data.Init == nil then
			data.Init = true
			--Sprite
			sprite:Play("Appear", true)

			sprite.FlipX = mod:RandomInt(0,1)==0
			sprite.FlipY = mod:RandomInt(0,1)==0

			sprite.Rotation = rng:RandomFloat()*360

		end
        tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

		if sprite:IsFinished("Appear") then
			sprite:Play("Idle", true)
		end
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			if tear.Parent then
                local parent = tear.Parent
                local hpStage = data.hpStage or 1
                    --rign
                    local angleOffset = rng:RandomFloat()*360
                    local blastRing = math.ceil(mod.SolConst.BLAST_RING*(1+hpStage/6))
                    local speed = mod.SolConst.BLAST_SPEED/2
        
        
                for i=1, blastRing do
                    local angle = i*360/blastRing+angleOffset
    
                    local velocity = Vector.FromAngle(angle)*speed
    

                    if not data.NotExplosion then
                        local flare = mod:SpawnEntity(mod.Entity.Flare, tear.Position, velocity, parent):ToProjectile()
                        local flareSprite = flare:GetSprite()
        
                        flare.SpriteScale = ((parent.SpriteScale)*0.2 + 0.8*Vector.One)
                        flareSprite.Color = parent:GetData().Color
        
                        flare:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
        
                        mod:TearFallAfter(flare, 480)

                    else
                        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, velocity, parent)
                        local dustSprite = dust:GetSprite()
        
                        dust.SpriteScale = ((parent.SpriteScale)*0.2 + 0.8*Vector.One)*3
                        dustSprite.Color = parent:GetData().Color

                    end
                end

                sfx:Play(mod.SFX.Fireblast)
                --sfx:Play(SoundEffect.SOUND_BEAST_FIRE_RING, 1, 2, false, 1)
			end

			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.SolBigFlareUpdate, mod.EntityInf[mod.Entity.BigFlare].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.SolBigFlareUpdate, mod.EntityInf[mod.Entity.BigFlare].VAR)

--Glass Shard-------------------------------------------------------------------------------------------------------------------------------
function mod:GlassShardUpdate(tear, collider, collided)
	if tear.SubType == mod.EntityInf[mod.Entity.GlassShard].SUB then
        local sprite = tear:GetSprite()
        local data = tear:GetData()

        if data.Init == nil then
            data.Init = true

            if data.Sol then
                sprite:Play("IdleYellow")
            else
                sprite:Play("Idle")
            end
            sprite.Rotation = tear.Velocity:GetAngleDegrees()
        end

        --If tear collided then
        if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then

            sfx:Play(Isaac.GetSoundIdByName("IceBreak"), 0.25)
            if data.Sol then
                game:SpawnParticles (tear.Position, EffectVariant.DIAMOND_PARTICLE, 5, 4, mod.Colors.yellowGlass)
            else
                game:SpawnParticles (tear.Position, EffectVariant.DIAMOND_PARTICLE, 5, 4)
            end
            tear:Die()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.GlassShardUpdate, mod.EntityInf[mod.Entity.GlassShard].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.GlassShardUpdate, mod.EntityInf[mod.Entity.GlassShard].VAR)

--Feather-------------------------------------------------------------------------------------------------------------------------------
function mod:SolFeatherUpdate(tear, collider, collided)
	local data = tear:GetData()
	local sprite = tear:GetSprite()

	if tear.SubType == mod.EntityInf[mod.Entity.SolFeather].SUB then

		if data.Init == nil then
			data.Init = true
			--Sprite
			sprite:Play("Idle", true)


		end
        sprite.Rotation = tear.Velocity:GetAngleDegrees()
		
		--If tear collided then
		if tear:IsDead() or (collider and collider.Type == EntityType.ENTITY_PLAYER) then
			local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, nil)
			impact:GetSprite().Color = sprite.Color
			impact.SpriteScale = tear.SpriteScale
			
			tear:Die()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.SolFeatherUpdate, mod.EntityInf[mod.Entity.SolFeather].VAR)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.SolFeatherUpdate, mod.EntityInf[mod.Entity.SolFeather].VAR)


--HAND--------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

mod.SolHandState = {
    IDLE = 0,
    SLASH = 1,
    SMASH = 2,
    GUN = 3,

    SWORD = 4,
}

function mod:SolHandUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.SolHand].VAR and entity.SubType == mod.EntityInf[mod.Entity.SolHand].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if entity.Parent and entity.Parent:ToNPC() then
            local parent = entity.Parent:ToNPC()

            local psprite = parent:GetSprite()
            local pdata = parent:GetData()
            local psize = parent.SpriteScale.X

            local size = 0.75*mod.ShaderData.solData.HPSIZE
            local target = parent:GetPlayerTarget()

            local hpStage = pdata.hpStage

            if not data.Init then
                data.Init = true

                data.State = mod.SolHandState.IDLE
                data.StateFrame = 0

                data.Hand = data.Hand or 1 --1=right, -1=left
                if data.Hand == -1 then
                    sprite.FlipX = true
                end

                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                entity:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

                data.AttackHand = false
            end
            data.defaultPosition = parent.Position + Vector(data.Hand*100, -20)* psize

            data.StateFrame = data.StateFrame + 1

            --idle position
            if data.State == mod.SolHandState.IDLE then
                sprite.Offset.Y = mod:Lerp(sprite.Offset.Y, 0, 0.1)

                if data.StateFrame == 1 or sprite:IsFinished() then
                    sprite:Play("Idle", true)
                end

                --mod:MoveSolHand(entity, data, psize, target.Position, data.defaultPosition, nil, nil, nil, 0.25)
                local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 25 * psize
                mod:MoveSolHand2(entity, data, psize, targetPosition, 0.25)

                local ogtdirection = (target.Position - entity.Position)
                mod:RotateSolHand(entity, data, sprite, ogtdirection, 0.05, -30, true)

                entity.Velocity = entity.Velocity / 2

                local r = 1--rng:RandomFloat()
                if r < mod.SolConst.SLASH_CHANCE then
                    local oldVel = entity.Velocity
                    local correct = mod:ChangeSolHandState(entity, parent, data, target, mod.SolHandState.GUN, true)
                    if not correct then
                        entity.Velocity = oldVel
                    end
                end

            elseif data.State == mod.SolHandState.SLASH then
                if data.StateFrame == 1 then
                    sprite:Play("Idle", true)
                    sfx:Play(Isaac.GetSoundIdByName("SolHiss"))
                elseif sprite:IsFinished("Slash") then
                    local correct = mod:ChangeSolHandState(entity, parent, data, target, mod.SolHandState.IDLE, false)
                elseif sprite:IsEventTriggered("Attack") then

                    --entity.Velocity = entity.Velocity * 10
                    sfx:Play(Isaac.GetSoundIdByName("Slash"), 1, 2, false, 2)
                
                    local fNum = math.ceil(mod.SolConst.N_SLASH_FEATHERS*(1+hpStage/6)*0.67)
                    local fSpeed = mod.SolConst.SLASH_FEATHER_SPEED*(1+hpStage/9)*0.67
        
                    for i = 1, fNum do
                        local direction = target.Position - entity.Position
                        local angle = 10*(i-0.5 - fNum/2) + direction:GetAngleDegrees()
                        local velocity = Vector(fSpeed, 0):Rotated(angle)

                        local feather = mod:SpawnEntity(mod.Entity.SolFeather, entity.Position, velocity, parent):ToProjectile()
                        feather.Parent = parent
                        feather:GetSprite().Color = pdata.Color
                        feather:GetData().hpStage = hpStage
                
                        feather.SpriteScale = (parent.SpriteScale)*0.5 + 0.5*Vector.One
                        feather:SetSize(parent.SpriteScale.X*feather.Size, Vector.One, 12)
                        
                        feather.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE
                
                        mod:TearFallAfter(feather, 30*5)
                    end

                end

                local ogtdirection = (target.Position - entity.Position)
                if sprite:GetAnimation() == "Idle" then
                    if data.StateFrame > 5 then
                        sprite:Play("Slash", true)
                    end

                    --mod:MoveSolHand(entity, data, psize, nil, data.defaultPosition, target.Position, parent.Position, 50, 0.05)
                    local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 25 * psize
                    mod:MoveSolHand2(entity, data, psize, targetPosition, 0.25)
                    mod:RotateSolHand(entity, data, sprite, ogtdirection, 0.1, -60, false)
                else

                    if sprite:WasEventTriggered("Attack") then
                        --mod:MoveSolHand(entity, data, psize, nil, data.defaultPosition, data.defaultPosition, parent.Position, 1, 0.01)
                        local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 40 * psize
                        mod:MoveSolHand2(entity, data, psize, targetPosition, 0.25)
                        mod:RotateSolHand(entity, data, sprite, ogtdirection, 0.5, -60, false)
                    else
                        --mod:MoveSolHand(entity, data, psize, nil, data.defaultPosition, target.Position, parent.Position, 100, 0.075)
                        local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 80 * psize
                        mod:MoveSolHand2(entity, data, psize, targetPosition, 0.25)
                        mod:RotateSolHand(entity, data, sprite, ogtdirection, 0.5, 60, false)
                    end
                end

            elseif data.State == mod.SolHandState.SMASH then
                if data.StateFrame == 1 then
                    sprite:Play("Punch", true)
                    sfx:Play(Isaac.GetSoundIdByName("SolHiss"))
                elseif sprite:IsFinished("Smash") then
                    local correct = mod:ChangeSolHandState(entity, parent, data, target, mod.SolHandState.IDLE, false)

                elseif sprite:IsEventTriggered("Attack") then
                
                    local fNum = math.ceil(mod.SolConst.N_SMASH_FEATHERS*(1+hpStage/6)*0.67)
                    local fSpeed = mod.SolConst.SMASH_FEATHER_SPEED*(1+hpStage/9)*0.67
                    
                    local angleOffset = rng:RandomFloat() * 360
                    for i = 1, fNum do
                        local direction = target.Position - entity.Position
                        local angle = angleOffset + i/fNum*360
                        local velocity = Vector(fSpeed, 0):Rotated(angle)

                        local feather = mod:SpawnEntity(mod.Entity.SolFeather, entity.Position, velocity, parent):ToProjectile()
                        feather.Parent = parent
                        feather:GetSprite().Color = pdata.Color
                        feather:GetData().hpStage = hpStage
                
                        feather.SpriteScale = (parent.SpriteScale)*0.5 + 0.5*Vector.One
                        feather:SetSize(parent.SpriteScale.X*feather.Size, Vector.One, 12)
                        
                        feather.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE
                
                        mod:TearFallAfter(feather, 30*5)
                    end
                    
                    local intensity = math.floor(math.min(1, target.Position:Distance(entity.Position)/300))*15
                    game:ShakeScreen(intensity)
                    sfx:Play(SoundEffect.SOUND_MOTHER_LAND_SMASH, 1, 2, false, 2)

                end

                if sprite:GetAnimation() == "Punch" then
                    if data.StateFrame > 30 then
                        sprite:Play("Smash", true)
                    end

                    local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 150 * psize
                    mod:MoveSolHand2(entity, data, psize, targetPosition, 0.01)

                    sprite.Offset.Y = mod:Lerp(sprite.Offset.Y, -100, 0.1)
                else
                    sprite.Offset.Y = mod:Lerp(sprite.Offset.Y, 0, 0.5)

                    if sprite:WasEventTriggered("Attack") then
                        local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 100 * psize
                        mod:MoveSolHand2(entity, data, psize, targetPosition, 0.25)
                    else
                        local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 100 * psize
                        mod:MoveSolHand2(entity, data, psize, targetPosition, 0.01)
                    end
                end
                mod:RotateSolHand(entity, data, sprite, Vector(data.Hand, 0), 0.1, 0, false)

            elseif data.State == mod.SolHandState.GUN then
                if data.StateFrame == 1 then
                    sprite:Play("Finger", true)
                    sfx:Play(Isaac.GetSoundIdByName("SolHiss"))
                elseif sprite:IsFinished("FingerShot") then
                    sprite:Play("FingerEnd", true)
                elseif sprite:IsFinished("FingerEnd") then
                    local correct = mod:ChangeSolHandState(entity, parent, data, target, mod.SolHandState.IDLE, false)

                elseif sprite:IsEventTriggered("Attack") then

                    local angle = (sprite.Rotation) % 360
                    if data.Hand == -1 then
                        angle = (180 - angle) % 360
                    end
                    
                    local position = entity.Position + Vector.FromAngle(angle) * 100 * psize

                    local laser = mod:SpawnEntity(mod.Entity.SolLaser, position, Vector.Zero, entity):ToLaser()
                    laser.Angle = angle
                    laser.Timeout = 1
                    laser.Parent = entity
                    laser.DisableFollowParent = true
                    laser.Position = position

                    laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

                    laser:GetSprite().Color = pdata.Color
                    laser:Update()
                    laser:SetColor(pdata.Color, 9999, 99, true, true)

                    laser.CollisionDamage = 1

                end

                if sprite:GetAnimation() == "Finger" then
                    if data.StateFrame > 45 then
                        sprite:Play("FingerShot", true)
                    end
                    
                end

                local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 30 * psize
                mod:MoveSolHand2(entity, data, psize, targetPosition, 0.01)
                mod:RotateSolHand(entity, data, sprite, target.Position - entity.Position, 0.025, 0, false)

            elseif data.State == mod.SolHandState.SWORD then
                if data.StateFrame == 1 then
                    sprite:Play("Punch", true)
                
                elseif sprite:IsPlaying("PuchEnd") then
                    local correct = mod:ChangeSolHandState(entity, parent, data, target, mod.SolHandState.IDLE, false)
                end

                if sprite:GetAnimation() == "Punch" then
                    local sword = mod:FindByTypeMod(mod.Entity.SolSword)[1]
                    if sword then
                        local position = parent.Position + (sword.Position - parent.Position):Normalized() * psize * 100
                        mod:MoveSolHand2(entity, data, psize, position, 0.5)
                        mod:RotateSolHand(entity, data, sprite, sword.Position - entity.Position, 0.05, 0, false)
                    else
                        sprite:Play("PuchEnd", true)
                    end
                else
                    local targetPosition = data.defaultPosition + (target.Position - entity.Position):Normalized() * 50 * psize
                    mod:MoveSolHand2(entity, data, psize, targetPosition, 0.25)
                end

            end

            --color
            sprite.Color = psprite.Color
            --size
            entity.SpriteScale = Vector.One*size
            entity.Scale = size
        else
            local sol = mod:FindByTypeMod(mod.Entity.Sol)[1]
            if sol then
                entity.Parent = sol
            else
                entity:Remove()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SolHandUpdate, mod.EntityInf[mod.Entity.SolHand].ID)

function mod:ChanceSolHandsStates(entity, target, state, isAttack)
    for i, hand in ipairs(mod:FindByTypeMod(mod.Entity.SolHand)) do
        mod:ChangeSolHandState(hand, entity, hand:GetData(), target, state, isAttack)
    end
end
function mod:ChangeSolHandState(entity, parent, data, target, newState, isAttack)

    local ogState = data.State

    if isAttack and (ogState ~= mod.SolHandState.IDLE) or (ogState == mod.SolHandState.GUN and newState ~= mod.SolHandState.IDLE) then
        return
    end

    data.State = newState
    data.StateFrame = 0
    
    data.AttackHand = false

    if newState == mod.SolHandState.SLASH or newState == mod.SolHandState.SMASH or newState == mod.SolHandState.GUN then
        if (parent.Position.X > target.Position.X and data.Hand == -1) or (parent.Position.X <= target.Position.X and data.Hand == 1) then
            data.AttackHand = true
        end
    end

    if isAttack and not data.AttackHand then
        data.State = ogState
        return false
    end
    return true
end

function mod:PlaySolHandsAnimation(entity, target, animation, closer, targetPos, speed)
    speed = speed or 1
    speed = speed * 0.5

    for i, hand in ipairs(mod:FindByTypeMod(mod.Entity.SolHand)) do

        if hand:GetData().State ~= mod.SolHandState.IDLE then return end

        local htargetPos = (targetPos and Vector(targetPos.X, targetPos.Y)) or hand.Position
        local direction = (htargetPos - hand.Position):Normalized()
        local velocity = direction * speed

        local knockVel = velocity * speed
        knockVel.X = knockVel.X * hand:GetData().Hand

        if closer then
            if (entity.Position.X > target.Position.X and hand:GetData().Hand == -1) or (entity.Position.X <= target.Position.X and hand:GetData().Hand == 1) then
                hand:GetSprite():Play(animation, true)
                hand:AddKnockback(EntityRef(entity), knockVel, 15, false)
            end
        else
            hand:GetSprite():Play(animation, true)
            hand:AddKnockback(EntityRef(entity), knockVel, 15, false)
        end
    end
end

function mod:RotateSolHand(entity, data, sprite, direction, h, offset, restricted)
    if data.Hand == 1 then
        local angle = direction:GetAngleDegrees() + offset
        if restricted then
            angle = math.max(-60, angle)
            angle = math.min(100, angle)
        end
        sprite.Rotation = mod:AngleLerp(sprite.Rotation, angle, h)
    else
        local angle = 180-direction:GetAngleDegrees() + offset

        if restricted then
            angle = (angle + 180) % 360
            angle = math.min(300, angle)
            angle = math.max(100, angle)
            angle = (angle - 180) % 360
        end

        sprite.Rotation = mod:AngleLerp(sprite.Rotation, angle, h)
    end
end
function mod:MoveSolHand(entity, data, psize, targetPosition, defaultPosition, forcedPosition, parentPosition, maxDistance, h)
    if forcedPosition then
        local direction = defaultPosition - entity.Position

        local tdirection = forcedPosition - entity.Position
        if tdirection:Length() > maxDistance then tdirection = tdirection:Normalized() * maxDistance end

        local final_direction = (direction + tdirection) * psize
    
        entity.Velocity = mod:Lerp(entity.Velocity, final_direction, h)

    else
        local direction = defaultPosition - entity.Position
    
        local tdirection = targetPosition - entity.Position
        if tdirection:Length() > mod.SolConst.MAX_SOL_HAND_DIST then tdirection = tdirection:Normalized() * mod.SolConst.MAX_SOL_HAND_DIST end
        tdirection = tdirection * Vector(0.5, 2.5)
    
        local final_direction = (direction + tdirection) * psize
    
        entity.Velocity = mod:Lerp(entity.Velocity, final_direction, h)
    end
end
function mod:MoveSolHand2(entity, data, psize, targetPosition, h)
    local direction = targetPosition - entity.Position

    local final_direction = (direction) * psize

    entity.Velocity = mod:Lerp(entity.Velocity, final_direction, h)
end

function mod:RestoreSolHands(entity)
    
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.SolHand))
    
    for i=-1,1,2 do
        local hand = mod:SpawnEntity(mod.Entity.Sol, entity.Position, Vector.Zero, nil, nil, mod.EntityInf[mod.Entity.Sol].SUB+1)
        hand:GetData().Hand = i
        hand.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        hand:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
        hand:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

        hand:Update()
    end
    
end


--little fucker
function mod:BetelgeuseUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Sol].VAR+1 and entity.SubType == mod.EntityInf[mod.Entity.Sol].SUB and not game:IsPaused() then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
        
		if data.Init == nil then
			data.Init = true
			
            entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            sprite:Play("Idle", true)

            data.eyeSprite = Sprite()
            data.eyeSprite:Load("hc/gfx/entity_BetelgeuseEye.anm2", true)
            data.eyeSprite:Play("Idle", true)
		end
        data.eyeSprite.Scale = Vector.One*1.5

        mod.ShaderData.solData.EYESPRITE = data.eyeSprite

        if sprite:IsFinished() then
            sprite:Play("Idle", true)
        end

        --local direction = (room:GetCenterPos() - entity.Position)
        local direction2 = (target.Position - entity.Position):Normalized()*1
        entity.Velocity = direction2

        --entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES

        --Update solData
        mod.ShaderData.solData.POSITION = entity.Position + mod.ShaderData.solData.HPSIZE*Vector(0,-100)
        mod.ShaderData.solData.TIME = mod.ShaderData.solData.TIME + 1

        local position = entity.Position+Vector(0,-100)
        local direction = (target.Position - position)
        local m = 370
        if direction:Length() > m then direction = direction:Normalized()*m end
        mod.ShaderData.solData.TRUEPOSITION = position + direction

        --rotation offset
        mod.ShaderData.solData.ROTATIONOFFSET = -1

        mod.ShaderData.solData.HPSIZE = 4
            
        local color1 = Color(1,-0.1,-0.2)
        local color2 = Color(-1,-1,-1)

        mod.ShaderData.solData.CORONACOLOR = color1
        mod.ShaderData.solData.BODYCOLOR = color2
        
        mod.ShaderData.solData.ENABLED = true

        --Others
        local redColor = Color(1,-0.5,-0.5,1, 1,-1,-1)
        sprite.Color = redColor

        local size = 1.75*mod.ShaderData.solData.HPSIZE
        entity.SpriteScale = Vector.One*size
        entity.Scale = size
        entity:SetSize(75*mod.ShaderData.solData.HPSIZE, Vector(1.25,0.75), 12)

        mod:scheduleForUpdate(function ()
            if entity and entity.FrameCount % 30 == 0 then
                room:MamaMegaExplosion(entity.Position)
            end
        end, 1)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.BetelgeuseUpdate, mod.EntityInf[mod.Entity.Sol].ID)