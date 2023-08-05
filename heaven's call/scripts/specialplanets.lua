local mod = HeavensCall
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local json = require("json")
local music = MusicManager()

--LUNA---------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&%(*,,,*(%@@@@@@@@@@@@@@@@@@@@@@@@@@@%(,,,,,/#%@@@@@@@@@@@@@@@
@@@&#&@@@@@@@@@&#/,,,,,,,,,,#&@@@@@@@@@@@@@@@@@@@@@@@&(,,****,,,,,(%@@@@@@@@@@@@
@@@@@@@@@@@@&%/,,,,****,,,,,/%@@@@@@@@@@@@@@@@@@@@@@@%*,,***/***,,,,/%@@@@@@@@@@
@@@@@@@@@@&#*,,********,,,,,(&@@@@@@@@@@@@@@@@@@@@@@@&(,,***//********/%@@@@@@@@
@@@@@@@@&#*,***********,,,,*%@@@@@@@@@@@@@@@@@@@@@@@@@%/****///////*****#&@@@@@@
@@@@@@@#***************,,,*%@@@@@@@@@@@@@@@@@@@@@@@@@@@#***///////////***(%@@@@@
@@@@@&#****///********,,,*#@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#///////////////**/%@@@@
@@@@@#***/////***********#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(//////////////***/%@@@
@@@@&(**//////**********/%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(**/////////////***(&@@
@@@@&(**///////*********#&@@@@%#*.  (@@@@@@@@@&@@@@@@@@@&#**/////////////***/%@@
@@@@&(*//(((///////*****#@@@%.       %@@@@@@@@@@@@@@@@@@&(**/////////////****%@@
&&@@@#///(((////////****#@@@@(    ,/####(((((((##%%&@@@@&(**/////////////***(&@@
@@@@@&///((((///////***/%@@@@%///*,,,,,,***,,,,,,,,,,,/((/*////((///////***(&@@@
@@@@@@%///(((////////**/%%#/*****///////////////******,,,*//((((///////***(&@@@@
@@@@@@@%////((///////****,,**//(((((//////////////////////((((((/////****(&@@@@@
&@@@@@@@&(*////////////***///((((((((((((/////////////////(((((////****(%@@@@@@@
@@@@@@@@@@%/**/////////////((((((((((((((((((((///((((/(//((((/////**(%@@@@@@@@@
@@@@@@@@@@@@&#/***/////((((#((((((((((((((((((((//(//(((((((////////(%@@@@@@@@@@
@@@@@@@@@@@@@@@%#///((((###((((((((((((/(((((((((((((((((((((((////**/%@@@@@@@@@
@@@@@@@@@@@@&@@%///(((###((((((((((((((((((((((((((((((((((((((((((/**/%@@@@@@@@
@@@@@@@@@@@@@@&(//(((((((((((((((((((((((((((((((((((////((((((((((//**(%@@@&@@@
@@@@@@@@@@@@&@#//((###(((((((((((((((((((((((((/(////////////////((//***#@@@@@@@
@@@@@@@@@@@@@&#*/((###((((((((((((/((((((///((//////////////*///*////***#@@@@@@@
@@@@@@@@@@@@@@#*/((##(((((((((((((//////////////////////*******//////***#@@@@@@@
@@@@@@@@@@@@@@%*/((###((((((((((((/////////////////*//*********//((//***%@@@@&@@
@@@@@@@@@@@&@@&(*/(#%%%(((//(((((((/////////***//*********,***(###//***(&@@@@@@@
@@@@@@@@@@@@@@@%/*/(%%%#(((//((((((((((////***********,,,,,,**(%%#****/%@@@@@@@@
@@@@@@@@@@@@@@@&%**/(%%((((///((((((((//////***,**,,,,,,,,,,****/****/#@@@@@@@@@
@@@@@@@@@@@@@&@@@%(**/((((((((((((((((((((****,,,,,,,,,,,,,*******,,/%@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&#*,*//(((((((((((((////***,,,,.....,,,,******,,*#&@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@%#*,**//////////////****,,,,....,,,,,****,,,*#&@@@@@@@@@@@@@
@@@@&@@@@@@@@@@@@@@@@@&%(,,****//////********,,,,,,,,,,,,,,,,,(%@@@@@@@@@@@@@@&@
@@@@@@@@@@@@@@@@@@@@@@@@@&%(*,,,***********,,,,,,,,,,,,,,.,(%&@@@@@@@@@@@@@@@@@@
@@@@&@@@@%@@@@@@@@@@@@@@@@@@@&%##*,,,,,,,,,,,,,......,/#%&@@&@@@@@@@@%@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
  
mod.LMSState = {
    APPEAR = 0,
    IDLE = 1,
    ATTACK = 2,
    CHARGE = 3,
    TELEPORT = 4,
    ITEM = 5,
    BOSSROOM = 6,
    MEGASATAN = 7,
    CURSE = 8,
    ARCADE = 9,
    BEDROOM = 10,
    DICE = 11,
    PLANETARIUM = 12,
    VAULT = 13,
    SPECIAL = 14,
    SACRIFICE = 15,

    MEGA_MUSH = 100,
    MOMS_SHOVEL = 99,
    FLIP = 98,
    MAW = 97,
    REVELATION = 96,
    DARK_ARTS = 95,
}

--TOTAL ITEMS = 46 [0-45]
mod.LActives = {
    ABYSS = 0,
    BOOK_VIRTUDES = 1,
    BIBLE = 2,
    BOOK_BELIAL = 3,
    BOOK_SHADOWS = 4,
    ANARCHIST = 5,
    BOOK_DEAD = 6,
    KIDNYE_BEAN = 41,
    DARK_ARTS = 43,
    ANIMA_SOLA = 44,
    LEMON_MISHAP = 45,
}
mod.LSpecials = {
    FLIP = 7,
    MEGA_MUSH = 8,
    MOMS_SHOVEL = 9,
}
mod.LAssistPassives = {
    INCUBUS = 10,
    MOMS_KNIFE = 11,
    HOLY_MANTLE = 12,
    WAFER = 13,
    MAGIC_MUSHROOM = 14,
    POLYPHEMUS = 15,
    MAW_VOID = 16,
    --PARASITOID = 17,
    BOWL_TEARS = 18, --COMMUNITY REMIX
    STOPWATCH = 40,
    REVELATIONS = 42,
}
mod.LMainPassive = {
    C_SECTION = 19,
    DR_FETUS = 20,
    TECH_X = 21,
    HEMOLACRYA = 22,
    BRIMSTONE = 23,
    --EPIC_FETUS = 24,
    --REVELATIONS = 25,
    MUTANT_SPIDER = 39,
}
mod.LSecondaryPassives = {
    IPECAC = 26,
    _20_20 = 27,
    GOD_HEAD = 28,
    SACRED_HEART = 29,
    PARASITE = 30,
    CONTINUUM = 31,
    CLASSIC_WORM = 32, --CLASSIC
}

mod.LItemDoor = {
    [mod.LActives.ABYSS] = mod.DoorType.DEVIL,
    [mod.LActives.BOOK_VIRTUDES] = mod.DoorType.LIBRARY,
    [mod.LActives.BIBLE] = mod.DoorType.LIBRARY,
    [mod.LActives.BOOK_BELIAL] = mod.DoorType.LIBRARY,
    [mod.LActives.BOOK_SHADOWS] = mod.DoorType.LIBRARY,
    [mod.LActives.ANARCHIST] = mod.DoorType.LIBRARY,
    [mod.LActives.BOOK_DEAD] = mod.DoorType.LIBRARY,
    [mod.LActives.KIDNYE_BEAN] = mod.DoorType.TREASURE,
    [mod.LActives.DARK_ARTS] = mod.DoorType.DEVIL,
    [mod.LActives.ANIMA_SOLA] = mod.DoorType.TREASURE,
    [mod.LActives.LEMON_MISHAP] = mod.DoorType.TREASURE,
    
    [mod.LSpecials.FLIP] = mod.DoorType.SECRET,
    [mod.LSpecials.MEGA_MUSH] = mod.DoorType.SECRET,
    [mod.LSpecials.MOMS_SHOVEL] = mod.DoorType.SECRET,
    
    [mod.LAssistPassives.INCUBUS] = mod.DoorType.DEVIL,
    [mod.LAssistPassives.MOMS_KNIFE] = mod.DoorType.DEVIL,
    [mod.LAssistPassives.HOLY_MANTLE] = mod.DoorType.ANGEL,
    [mod.LAssistPassives.WAFER] = mod.DoorType.ANGEL,
    [mod.LAssistPassives.MAGIC_MUSHROOM] = mod.DoorType.TREASURE,
    [mod.LAssistPassives.POLYPHEMUS] = mod.DoorType.TREASURE,
    [mod.LAssistPassives.MAW_VOID] = mod.DoorType.DEVIL,
    --[mod.LAssistPassives.PARASITOID] = mod.DoorType.TREASURE,
    [mod.LAssistPassives.BOWL_TEARS] = mod.DoorType.TREASURE,
    [mod.LAssistPassives.STOPWATCH] = mod.DoorType.SHOP,
    [mod.LAssistPassives.REVELATIONS] = mod.DoorType.ANGEL,
    
    [mod.LMainPassive.C_SECTION] = mod.DoorType.TREASURE,
    [mod.LMainPassive.DR_FETUS] = mod.DoorType.TREASURE,
    [mod.LMainPassive.TECH_X] = mod.DoorType.TREASURE,
    [mod.LMainPassive.HEMOLACRYA] = mod.DoorType.TREASURE,
    [mod.LMainPassive.BRIMSTONE] = mod.DoorType.DEVIL,
    --[mod.LMainPassive.EPIC_FETUS] = mod.DoorType.SECRET,
    --[mod.LMainPassive.REVELATIONS] = mod.DoorType.ANGEL,
    [mod.LMainPassive.MUTANT_SPIDER] = mod.DoorType.TREASURE,
    
    [mod.LSecondaryPassives.IPECAC] = mod.DoorType.TREASURE,
    [mod.LSecondaryPassives._20_20] = mod.DoorType.TREASURE,
    [mod.LSecondaryPassives.GOD_HEAD] = mod.DoorType.ANGEL,
    [mod.LSecondaryPassives.SACRED_HEART] = mod.DoorType.ANGEL,
    [mod.LSecondaryPassives.PARASITE] = mod.DoorType.TREASURE,
    [mod.LSecondaryPassives.CONTINUUM] = mod.DoorType.TREASURE,
    [mod.LSecondaryPassives.CLASSIC_WORM] = mod.DoorType.TREASURE,
}
mod.LItemPath = {
    [mod.LActives.ABYSS] = "gfx/items/collectibles/collectibles_706_abyss.png",
    [mod.LActives.BOOK_VIRTUDES] = "gfx/items/collectibles/collectibles_584_bookofvirtues.png",
    [mod.LActives.BIBLE] = "gfx/items/collectibles/collectibles_033_thebible.png",
    [mod.LActives.BOOK_BELIAL] = "gfx/items/collectibles/collectibles_034_thebookofbelial.png",
    [mod.LActives.BOOK_SHADOWS] = "gfx/items/collectibles/collectibles_058_bookofshadows.png",
    [mod.LActives.ANARCHIST] = "gfx/items/collectibles/collectibles_065_anarchistcookbook.png",
    [mod.LActives.BOOK_DEAD] = "gfx/items/collectibles/collectibles_545_bookofthedead.png",
    [mod.LActives.KIDNYE_BEAN] = "gfx/items/collectibles/collectibles_421_kidneybean.png",
    [mod.LActives.DARK_ARTS] = "gfx/items/collectibles/collectibles_705_darkarts.png",
    [mod.LActives.ANIMA_SOLA] = "gfx/items/collectibles/collectibles_722_animasola.png",
    [mod.LActives.LEMON_MISHAP] = "gfx/items/collectibles/collectibles_056_lemonmishap.png",
    
    [mod.LSpecials.FLIP] = "gfx/items/collectibles/collectibles_711_flip.png",
    [mod.LSpecials.MEGA_MUSH] = "gfx/items/collectibles/collectibles_625_megamush.png",
    [mod.LSpecials.MOMS_SHOVEL] = "gfx/items/collectibles/collectibles_552_momsshovel.png",
    
    [mod.LAssistPassives.INCUBUS] = "gfx/items/collectibles/collectibles_360_incubus.png",
    [mod.LAssistPassives.MOMS_KNIFE] = "gfx/items/collectibles/collectibles_114_momsknife.png",
    [mod.LAssistPassives.HOLY_MANTLE] = "gfx/items/collectibles/collectibles_313_holymantle.png",
    [mod.LAssistPassives.WAFER] = "gfx/items/collectibles/collectibles_108_thewafer.png",
    [mod.LAssistPassives.MAGIC_MUSHROOM] = "gfx/items/collectibles/collectibles_012_magicmushroom.png",
    [mod.LAssistPassives.POLYPHEMUS] = "gfx/items/collectibles/collectibles_169_polyphemus.png",
    [mod.LAssistPassives.MAW_VOID] = "gfx/items/collectibles/collectibles_399_mawofthevoid.png",
    --[mod.LAssistPassives.PARASITOID] = "gfx/items/collectibles/collectibles_461_parasitoid.png",
    [mod.LAssistPassives.BOWL_TEARS] = "gfx/items/collectibles/collectibles_109_bowloftears.png",--REMIX
    [mod.LAssistPassives.STOPWATCH] = "gfx/items/collectibles/collectibles_232_stopwatch.png",
    [mod.LAssistPassives.REVELATIONS] = "gfx/items/collectibles/collectibles_643_revelation.png",
    
    [mod.LMainPassive.C_SECTION] = "gfx/items/collectibles/collectibles_678_csection.png",
    [mod.LMainPassive.DR_FETUS] = "gfx/items/collectibles/collectibles_052_drfetus.png",
    [mod.LMainPassive.TECH_X] = "gfx/items/collectibles/collectibles_395_techx.png",
    [mod.LMainPassive.HEMOLACRYA] = "gfx/items/collectibles/collectibles_531_haemolacria.png",
    [mod.LMainPassive.BRIMSTONE] = "gfx/items/collectibles/collectibles_118_brimstone.png",
    --[mod.LMainPassive.EPIC_FETUS] = "gfx/items/collectibles/collectibles_168_epicfetus.png",
    --[mod.LMainPassive.REVELATIONS] = "gfx/items/collectibles/collectibles_643_revelation.png",
    [mod.LMainPassive.MUTANT_SPIDER] = "gfx/items/collectibles/collectibles_153_mutantspider.png",
    
    [mod.LSecondaryPassives.IPECAC] = "gfx/items/collectibles/collectibles_149_ipecac.png",
    [mod.LSecondaryPassives._20_20] = "gfx/items/collectibles/collectibles_245_2020.png",
    [mod.LSecondaryPassives.GOD_HEAD] = "gfx/items/collectibles/collectibles_331_godhead.png",
    [mod.LSecondaryPassives.SACRED_HEART] = "gfx/items/collectibles/collectibles_182_sacredheart.png",
    [mod.LSecondaryPassives.PARASITE] = "gfx/items/collectibles/collectibles_104_theparasite.png",
    [mod.LSecondaryPassives.CONTINUUM] = "gfx/items/collectibles/collectibles_369_continuum.png",
    [mod.LSecondaryPassives.CLASSIC_WORM] = "gfx/items/collectibles/collectibles_109_wiggleworm.png",--CLASSIC

}

mod.LItemType = {
    ACTIVE = 1<<0,
    MAIN = 1<<1,
    SECONDARY = 1<<2,
    ASSIST = 1<<3,
    SPECIAL = 1<<4
}

if TaintedTreasure then
    mod.LMainPassive.LIL_SLUGGER = 33
    --mod.LAssistPassives.BUGULON = 34
    mod.LMainPassive.SPIDER_FREAK = 35

    mod.LItemDoor[mod.LMainPassive.LIL_SLUGGER] = mod.DoorType.TAINTED
    mod.LItemPath[mod.LMainPassive.LIL_SLUGGER] = "gfx/items/collectibles/collectible_lilslugger.png"
    --mod.LItemDoor[mod.LAssistPassives.BUGULON] = mod.DoorType.TAINTED
    --mod.LItemPath[mod.LAssistPassives.BUGULON] = "gfx/items/collectibles/collectible_bugulonsuperfan.png"
    mod.LItemDoor[mod.LMainPassive.SPIDER_FREAK] = mod.DoorType.TAINTED
    mod.LItemPath[mod.LMainPassive.SPIDER_FREAK] = "gfx/items/collectibles/collectible_spiderfreak.png"
end
if FiendFolio then
    mod.LActives.FIEND_FOLIO = 36
    mod.LActives.HORSE_PASTE = 37
    
    mod.LItemDoor[mod.LActives.FIEND_FOLIO] = mod.DoorType.LIBRARY
    mod.LItemPath[mod.LActives.FIEND_FOLIO] = "gfx/items/collectibles/012_the_fiend_folio.png"
    mod.LItemDoor[mod.LActives.HORSE_PASTE] = mod.DoorType.SHOP
    mod.LItemPath[mod.LActives.HORSE_PASTE] = "gfx/items/collectibles/collectibles_horse_paste.png"
end
if Althorsemen then
    mod.LActives.BOOK_REVELATIONS = 38
    
    mod.LItemDoor[mod.LActives.BOOK_REVELATIONS] = mod.DoorType.LIBRARY
    mod.LItemPath[mod.LActives.BOOK_REVELATIONS] = "gfx/items/collectibles/collectibles_078_bookofrevelations.png"
end

mod.chainL = {                    --Appear  Idle   Attack Charge Telep  Item   Boss   MegaS  Curse  Arcad  Bed    Dice   Planet Vault  Speci  Sacrfice
    [mod.LMSState.APPEAR] =         {0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.IDLE] =           {0.000, 0.150, 0.480, 0.000, 0.050, 0.020, 0.030, 0.040, 0.030, 0.030, 0.000, 0.030, 0.030, 0.040, 0.030, 0.040},
    --[mod.LMSState.IDLE] =           {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000, 1.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.ATTACK] =         {0.000, 0.095, 0.500, 0.000, 0.000, 0.350, 0.000, 0.000, 0.000, 0.000, 0.000, 0.100, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.CHARGE] =         {0.000, 0.400, 0.400, 0.000, 0.200, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.TELEPORT] =       {0.000, 0.400, 0.200, 0.000, 0.000, 0.400, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.ITEM] =           {0.000, 0.095, 0.700, 0.000, 0.000, 0.250, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.BOSSROOM] =       {0.000, 0.300, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.300, 0.000, 0.400, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.MEGASATAN] =      {0.000, 0.100, 0.000, 0.000, 0.000, 0.400, 0.000, 0.000, 0.300, 0.200, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.CURSE] =          {0.000, 0.750, 0.250, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.ARCADE] =         {0.000, 0.300, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.300, 0.000, 0.300, 0.100, 0.000},
    [mod.LMSState.BEDROOM] =        {0.000, 0.700, 0.300, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.DICE] =           {0.000, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    --[mod.LMSState.DICE] =           {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.PLANETARIUM] =    {0.000, 0.300, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.300, 0.000, 0.400, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.VAULT] =          {0.000, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.SPECIAL] =        {0.000, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    [mod.LMSState.SACRIFICE] =      {0.000, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000},
    
}
mod.LConst = {--Some constant variables of Luna
    idleTimeInterval = Vector(10,15),
    speed = 1.4,
    superSpeed = 1.5,

    dashSpeed = 60,

    hpSS = 0,

    minDistanceToReappear = 120,

    curseSpeed = 20,

    sleepShield = 80,
    healPerSleep = 20,--10

    nCoins = 3,

    xTechSpeed = 6,
    xTechSize = 30,

    _20_20_distance = 20,

    spiderFreakAngle = 13,
    spiderAngle = 16,

    healPerGlue = 75,

    shadowShieldFrames = 30*5,
    belialFrames = 30*7,

    nLocust = 8,
    nBones = 8,
    nWisps = 5,

    wispShotSpeed = 5,

    bowlChance = 0.1,

    knifeRange = 65,

    mawFrames = 30*5,
    mawTimeout = 100,
    mawRadius = 45,
    
    revelationFrames = 30*3 + 15*1,

    incubusScale = 0.65,

    sluggerSpeed = 7,

    impactDamage = 25,
    maxImpacts = 5,
    impactBlastAngle = 5,
    nBlasts = 5,
    shovelSpeed = 40,
    maxShovels = 6,
    nFinalPatas = 6,
    maxFlipAttacks = 5,
    wave1Flip = 8,
    wave2Flip = 16,
    wave3Flip = 12,
    waveFlipSpeed = 12,
    maxAngels = 3,

    lemonTime = 5*30,

    animaTime = 10*30,
    chainsL = 7,

    darkSpeed = 45,
    darkAttackFrame = {[1] = 51, [2] = 85, [3] = 119, [4] = 153, [5] = 186, [6] = 220},

}

function mod:LunaUpdate(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Luna].VAR and entity.SubType == mod.EntityInf[mod.Entity.Luna].SUB then
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        local target = entity:GetPlayerTarget()
        local room = game:GetRoom()
        
        --Custom data:
        if data.State == nil then 
            data.State = 0 
            data.StateFrame = 0
            data.SSFlag = false

            data.MainP = 0
            data.SecondaryP = 0
            data.AssistP = 0

            data.SleepShield = 0
            data.ShieldTime = 0
            data.StrengthTime = 0
            data.HasMantle = false

            data.HasMaw = false
            data.MawTime = 0
            data.MawColor = Color.Default

            data.HasRevelation = false
            data.RevelationTime = 0
            data.RevelationColor = Color.Default

            data.TargetAim = Vector.Zero

            data.ImpactsDone = 0
            data.ShovelsDone = 0
            data.FlipAttacksDone = 0

            data.TargetPos = Vector.Zero

            data.DarkPos = {}
            data.DarkCount = 0
        end
        
        --print(data.State)
        --print(data.StateFrame)
        --print(mod.ModFlags.LunaTriggered)

        --Frame
        --data.StateFrame = 0
        data.StateFrame = data.StateFrame + 1
        
        if not data.SSFlag and entity.HitPoints < entity.MaxHitPoints * mod.LConst.hpSS and data.State == mod.LMSState.IDLE then
            data.SSFlag = true
            data.StateFrame = 0
        end

        if data.SSFlag then
            mod:LunaSS(entity, data, sprite, target,room)
        else
            if data.State == mod.LMSState.APPEAR then
                if data.StateFrame == 1 then
                    mod:AppearPlanet(entity)
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
                    mod:LunaChangeState(entity)
                elseif sprite:IsEventTriggered("EndAppear") then
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                elseif sprite:GetFrame()==40 and sprite:IsPlaying("AppearSlow") then--Turn black
                    mod.ModFlags.pitchBlack = true
                elseif sprite:GetFrame()==75 and sprite:IsPlaying("AppearSlow") then--Turn no black
                    mod.ModFlags.pitchBlack = false
                elseif sprite:GetFrame()==60 and sprite:IsPlaying("AppearSlow") then--Red
                    for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0)) do
                        e:Remove()
                    end
                    mod:UltraRedSetup(room, true)

                    mod.ModFlags.LunaTriggered = true

                    --Re-close doors
                    for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                        local door = room:GetDoor(i)
                        if door then
                            door:Close()
                            door:GetSprite():Play("Closed")
                        end
                    end
                end
                
            elseif data.State == mod.LMSState.IDLE then
                if data.StateFrame == 1 then
                    sprite:Play("Idle",true)
                elseif sprite:IsFinished("Idle") then
                    mod:LunaChangeState(entity)
                    
                else
                    mod:LunaMove(entity, data, room, target)
                end
                
            elseif data.State == mod.LMSState.ATTACK then
                mod:LunaAttack(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.CHARGE then
                mod:LunaCharge(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.TELEPORT then
                mod:LunaTeleport(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.ITEM then
                mod:LunaItem(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.BOSSROOM then
                mod:LunaBoss(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.MEGASATAN then
                mod:LunaMegaSatan(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.CURSE then
                mod:LunaCurse(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.ARCADE then
                mod:LunaArcade(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.BEDROOM then
                mod:LunaBed(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.DICE then
                mod:LunaDice(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.PLANETARIUM then
                mod:LunaPlanetarium(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.VAULT then
                mod:LunaVault(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.SPECIAL then
                mod:LunaSpecial(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.SACRIFICE then
                mod:LunaSacrifice(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.MEGA_MUSH then
                mod:LunaMegaMush(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.MOMS_SHOVEL then
                mod:LunaShovel(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.FLIP then
                entity:ClearEntityFlags(EntityFlag.FLAG_CHARM)

                mod:LunaFlip(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.MAW then
                mod:LunaMaw(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.REVELATION then
                mod:LunaRevelation(entity, data, sprite, target,room)
            elseif data.State == mod.LMSState.DARK_ARTS then
                mod:LunaDark(entity, data, sprite, target,room)
            end
        end

        --Stats
        data.ShieldTime = data.ShieldTime - 1
        data.StrengthTime = data.StrengthTime - 1
        if data.StrengthTime == 0 then
            mod:LunaChangeCostumes(entity, data, sprite)
        end

        if data.AssistP == mod.LAssistPassives.MAGIC_MUSHROOM then
            entity.SpriteScale = Vector.One*1.15
            entity.Scale = 1.15

        elseif data.AssistP == mod.LAssistPassives.BOWL_TEARS and not (data.State == mod.LMSState.MEGA_MUSH) then
            if entity.FrameCount % 5 == 0 then
                local position = entity.Position + Vector(10*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())

                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, position, Vector.Zero, entity):ToEffect()
                mod:scheduleForUpdate(function()
                    creep:GetSprite().Color = Color(0,0,1,1,2,2,2)
                end,1)
                creep.Timeout = 15
            end
        else
            entity.SpriteScale = Vector.One
            entity.Scale = 1
        end
        
        if data.AssistP == mod.LAssistPassives.STOPWATCH then
            sprite.PlaybackSpeed = 1.1
        else
            sprite.PlaybackSpeed = 1
        end

        if data.ShieldTime > 0 and entity.FrameCount%15==0 then

            local shield = mod:SpawnEntity(mod.Entity.ICUP, entity.Position + Vector(0,-30), Vector.Zero, entity):ToEffect()
            shield:FollowParent(entity)
            shield.DepthOffset = 500

            local shieldSprite = shield:GetSprite()
            shieldSprite:Load("gfx/effect_LunaShield.anm2", true)
            shieldSprite:ReplaceSpritesheet(2, "gfx/effects/bishop_shield.png")
            shieldSprite:ReplaceSpritesheet(1, "gfx/effects/bishop_shield.png")
            shieldSprite:Play("Idle", true)
            shieldSprite:LoadGraphics()
        end
        
        if data.HasMaw and data.State ~= mod.LMSState.FLIP then
            data.MawTime = data.MawTime + 1

            data.MawColor = Color.Lerp(data.MawColor, mod.Colors.maw, 0.01)
            sprite.Color = data.MawColor

        elseif data.HasRevelation and not data.State ~= mod.LMSState.FLIP then
            data.RevelationTime = data.RevelationTime + 1

            data.RevelationColor = Color.Lerp(data.RevelationColor, mod.Colors.revelation, 0.01)
            sprite.Color = data.RevelationColor

        end

        
        
        if false then
            mod:TestCostumes(entity, data, sprite)
            return
        end
        
       --[[if entity.FrameCount % 200 == 0 then
            mod:LunaUseActive(entity, nil)
        end
        data.StateFrame = 0]]

    end
end
function mod:LunaAttack(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        if data.MainP == mod.LMainPassive.BRIMSTONE or data.MainP == mod.LMainPassive.REVELATIONS then
            if data.SecondaryP == mod.LSecondaryPassives.GOD_HEAD then
                sprite:Play("LongLaser",true)
            else
                sprite:Play("NormalLaser",true)
            end
        else
            sprite:Play("NormalAttack",true)
        end
    elseif sprite:IsEventTriggered("Aim") then
        data.TargetAim = target.Position
        
        if (data.MainP == mod.LMainPassive.BRIMSTONE or data.MainP == mod.LMainPassive.REVELATIONS) then

            sfx:Play(SoundEffect.SOUND_FRAIL_CHARGE, 0.8, 2, false, 1.5)

            if data.SecondaryP == mod.LSecondaryPassives.SACRED_HEART then
                local direction = (data.TargetAim - entity.Position)
                local angulo = direction:GetAngleDegrees()
                angulo = mod:Takeclosest({0,90,180,-180,-90}, angulo)

                local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()

                tracer:FollowParent(entity)
                tracer.LifeSpan = 25
                tracer.Timeout = tracer.LifeSpan
                tracer.TargetPosition = Vector(1, 0):Rotated(angulo)
                

                
            elseif data.SecondaryP == mod.LSecondaryPassives.CONTINUUM and (data.MainP == mod.LMainPassive.BRIMSTONE or data.MainP == mod.LMainPassive.REVELATIONS) then
                mod:LunaTraceLaser(entity, data, sprite, target, room, false)
            end
        end
    elseif sprite:IsFinished("NormalAttack") or sprite:IsFinished("NormalLaser") or sprite:IsFinished("LongLaser") then
        mod:LunaChangeState(entity)

    elseif sprite:IsEventTriggered("Attack") then
        mod:LunaSynergy(entity, data, sprite, target, room, false)
    end

end
function mod:LunaCharge(entity, data, sprite, target, room)
    if data.Height then
        entity.Position = Vector(entity.Position.X, data.Height)
    end

    if data.StateFrame == 1 then
        mod:LunaChangeState(entity)
        --XDDDDD

        data.Height = entity.Position.Y
        local direction = mod.RoomWalls.RIGHT
        local rotation = 90

        if (entity.Position.X - target.Position.X) < 0 then
            sprite:Play("DashR",true)
            data.Direcion = 1
        else
            sprite:Play("DashL",true)
            rotation = -90
            direction = mod.RoomWalls.LEFT
            data.Direcion = -1
        end

        local position = mod.BorderRoom[direction][room:GetRoomShape()] - data.Direcion*70

        local door = mod:SpawnLunaDoor(entity, mod.DoorType.NORMAL, Vector(position, entity.Position.Y))
        door:GetSprite().Rotation = rotation

    elseif sprite:IsFinished("DashR") or sprite:IsFinished("DashL") or sprite:IsFinished("TrapdoorOut") then
        data.Height = nil
        data.DashFlag = false
        mod:LunaChangeState(entity)

    elseif sprite:IsEventTriggered("Attack") then
        data.DashFlag = true
    end

    if data.DashFlag then
        entity.Velocity = Vector(mod.LConst.dashSpeed * data.Direcion, 0)
    end

end
function mod:LunaTeleport(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        sprite:Play("TrapdoorIn",true)

		local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position, Vector.Zero, entity)
        trapdoor:GetSprite():Play("BigIdle", true)

    elseif sprite:IsFinished("TrapdoorOut") then
        mod:LunaChangeState(entity)
    elseif sprite:IsFinished("TrapdoorIn") and entity.Visible then

        entity.Visible = false
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        mod:scheduleForUpdate(function()
            sprite:Play("TrapdoorOut",true)
            entity.Visible = true
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end, 5,ModCallbacks.MC_POST_UPDATE)

        local position = Isaac.GetRandomPosition(0)
        while position:Distance(target.Position) < mod.LConst.minDistanceToReappear do
            position = Isaac.GetRandomPosition(0)
        end
		mod:LunaTeleportTo(entity, position)

		local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, position, Vector.Zero, entity)
        trapdoor:GetSprite():Play("BigIdle", true)

        for _, r in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER, LaserVariant.THICK_RED, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT)) do
            r:Remove()
        end

    end

end
function mod:LunaItem(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        
        --mod:LunaChangeState(entity)
        --return

        sprite:Play("SummonDoor",true)
    elseif sprite:IsFinished("PickUp") then
        
        local special = mod:GiveItemLuna(entity, data.LastItem)
        if not special then
            mod:LunaChangeState(entity)
        end
        mod:LunaChangeCostumes(entity, data, sprite)
    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("PickUp",true)

    elseif sprite:IsEventTriggered("PickUp") then
		sfx:Play(SoundEffect.SOUND_POWERUP1)

    elseif sprite:IsEventTriggered("SummonDoor") then

        local itemType = 0 -- 00001 active, 00010 a.passive, 00100 m.passive, 01000 s.passive, 10000 special
        local itemNum = -1
        local oldItem = 0

        local random = mod:RandomInt(1,12)

        if random <= 2 then
            itemType = mod.LItemType.ACTIVE
            itemNum = mod:LunaChooseItem(mod.LActives, nil, false, entity)
        elseif random <= 5 then
            itemType = mod.LItemType.MAIN
            oldItem = data.MainP
            itemNum = mod:LunaChooseItem(mod.LMainPassive, data.MainP, false, entity)
        elseif random <= 8 then
            itemType = mod.LItemType.SECONDARY
            oldItem = data.SecondaryP
            itemNum = mod:LunaChooseItem(mod.LSecondaryPassives, data.SecondaryP, false, entity)
        elseif random <= 11 then
            itemType = mod.LItemType.ASSIST
            oldItem = data.AssistP
            itemNum = mod:LunaChooseItem(mod.LAssistPassives, data.AssistP, false, entity)
        else
            itemType = mod.LItemType.SPECIAL
            itemNum = mod:LunaChooseItem(mod.LSpecials, nil, false, entity)
        end

        --itemNum = mod.LSecondaryPassives.GOD_HEAD
        --itemType = mod.LItemType.SECONDARY
        --itemNum = mod.LSecondaryPassives.CONTINUUM
        --itemType = mod.LItemType.SECONDARY
        --itemType = mod.LItemType.ACTIVE
        --itemNum = mod.LActives.DARK_ARTS

        data.LastItem = itemNum
        data.LastItemType = itemType
        
        sprite:ReplaceSpritesheet(1, mod.LItemPath[itemNum])
        if oldItem == 0 then
            sprite:ReplaceSpritesheet(2, "")
        else
            sprite:ReplaceSpritesheet(2, mod.LItemPath[oldItem])
        end
        sprite:LoadGraphics()

        local door = mod:SpawnLunaDoor(entity, mod.LItemDoor[itemNum], entity.Position + Vector(50,0))
    end

end
function mod:LunaBoss(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        if mod:LunaBossCount() <= 0 then
            sprite:Play("SummonDoor",true)
        else
            mod:LunaChangeState(entity)
        end
    elseif sprite:IsFinished("Cheer") or data.StateFrame > 150 then
        mod:LunaChangeState(entity)
    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("Idle",true)
    elseif entity.Child and entity.Child:GetData().Frame == 30 then
        sprite:Play("Cheer",true)

    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.BOSS)
    end

end
function mod:LunaMegaSatan(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("SummonDoorMega",true)
    elseif sprite:IsFinished("SummonDoorMega") then
        mod:LunaChangeState(entity)

    elseif sprite:IsEventTriggered("SummonDoor") then
        
        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1)

        local position, rotation = mod:RandomUpDown()
        local door = mod:SpawnEntity(mod.Entity.LunaMegaSatanDoor, position, Vector.Zero, entity)
        door:GetSprite().Rotation = rotation
        door.Parent = entity
        entity.Child = door
    end

end
function mod:LunaCurse(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        sprite:Play("SummonDoor",true)
    elseif sprite:IsFinished("Snap") then
        mod:LunaChangeState(entity)
        data.CuseFlag = false
    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("Snap",true)

    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.CURSE, entity.Position + Vector(0,20))
        data.CuseFlag = true
    elseif sprite:IsEventTriggered("Snap") then
        sfx:Play(Isaac.GetSoundIdByName("Snap"),2)
        entity.Child.Velocity = (target.Position - entity.Position):Normalized() * mod.LConst.curseSpeed
    end

    if entity.Child and entity.Child.Velocity:Length()<mod.LConst.curseSpeed and data.CuseFlag then
        entity.Child:GetSprite().Rotation = (target.Position - entity.Position):GetAngleDegrees() - 90
    end

end
function mod:LunaArcade(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("SummonDoor",true)
    elseif sprite:IsFinished("SummonDoor") then
        mod:LunaChangeState(entity)

    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.ARCADE)
    end

end
function mod:LunaBed(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        sprite:Play("SummonDoor",true)
    elseif sprite:IsFinished("SleepEnd") then
        mod:LunaChangeState(entity)

    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("GoToSleep",true)
        sfx:Play(SoundEffect.SOUND_SUMMONSOUND,1)

    elseif sprite:IsFinished("GoToSleep") then
        sprite:Play("Sleeping",true)
        data.SleepShield = mod.LConst.sleepShield
        local zzz = mod:SpawnEntity(mod.Entity.SleepZZZ, entity.Position + Vector(0, -100), Vector.Zero, nil)
        zzz.DepthOffset = 250

    elseif sprite:IsFinished("Sleeping") then
        sprite:Play("Sleeping",true)
        local zzz = mod:SpawnEntity(mod.Entity.SleepZZZ, entity.Position + Vector(0, -100), Vector.Zero, nil)
        zzz.DepthOffset = 250
        --Heal
        mod:LunaHeal(entity, mod.LConst.healPerSleep, true)
        sfx:Play(Isaac.GetSoundIdByName("SleepHeal"), 100, 2, false, 1.5)

    elseif sprite:IsPlaying("Sleeping") and entity.HitPoints == entity.MaxHitPoints then
        sprite:Play("SleepEnd",true)

    elseif sprite:IsEventTriggered("Attack") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.BEDROOM, entity.Position)
    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.BEDROOM, entity.Position + Vector(0, -75))
    end

end
function mod:LunaDice(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("SummonDoor",true)
    elseif sprite:IsFinished("Dice") then
        mod:LunaChangeState(entity)
    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("Dice",true)

    elseif sprite:IsEventTriggered("Dice") then
        sfx:Play(SoundEffect.SOUND_EDEN_GLITCH,1)
        
        mod:GiveItemLuna(entity, mod:LunaChooseItem(mod.LMainPassive, data.MainP, true, entity), mod.LItemType.MAIN)
        mod:GiveItemLuna(entity, mod:LunaChooseItem(mod.LSecondaryPassives, data.SecondaryP, true, entity), mod.LItemType.SECONDARY)
        mod:GiveItemLuna(entity, mod:LunaChooseItem(mod.LAssistPassives, data.AssistP, true, entity), mod.LItemType.ASSIST)

        mod:LunaChangeCostumes(entity, data, sprite)
    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.DICE)
    end

end
function mod:LunaPlanetarium(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        if mod:KuiperHealtFraction() <= 0 then
            sprite:Play("SummonDoor",true)
        else
            mod:LunaChangeState(entity)
        end
    elseif sprite:IsFinished("Cheer") or data.StateFrame > 150 then
        mod:LunaChangeState(entity)
    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("Idle",true)
    elseif entity.Child and entity.Child:GetData().Frame == 30 then
        sprite:Play("Cheer",true)

    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.PLANETARIUM)
    end

end
function mod:LunaVault(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        if true then 
            mod:LunaChangeState(entity)
        else
            sprite:Play("SummonDoor",true)
        end
    elseif sprite:IsFinished("SummonDoor") then
        mod:LunaChangeState(entity)

    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.VAULT)
    end

end
function mod:LunaSpecial(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        if REVEL then
            sprite:Play("SummonDoor",true)
            data.Revel = 1
            if rng:RandomFloat() < 0.5 then
                data.Revel = 2
            end
        else
            mod:LunaChangeState(entity)
        end
    elseif sprite:IsFinished("SummonDoor") then
        if data.Revel == 1 then
            mod:LunaChangeState(entity)
        else
            sprite:Play("Jump",true)
        end
    elseif sprite:IsFinished("Jump") then
        mod:LunaChangeState(entity)

    elseif sprite:IsEventTriggered("SummonDoor") then
        if data.Revel == 1 then
            local door = mod:SpawnLunaDoor(entity, mod.DoorType.GLACIAR)
        else
            local door = mod:SpawnLunaDoor(entity, mod.DoorType.TOMB, entity.Position)
        end

    elseif sprite:IsEventTriggered("Preland") and entity.Child then
        entity.Child:GetSprite():Play("Close",true)
    elseif sprite:IsEventTriggered("Land") then
        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1)

        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        --TRAPS
        for i=1,2 do
            local position = room:GetGridPosition(room:GetClampedGridIndex (room:GetRandomPosition(0)))
            local trap = mod:SpawnEntity(mod.Entity.TrapTile, position, Vector.Zero, entity)
            trap:GetData().Selfdestruct = true
            trap:GetData().MaxFrames = 30*30
        end
    end

end
function mod:LunaSacrifice(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero

    if data.StateFrame == 1 then
        sprite:Play("SummonDoor",true)
    elseif sprite:IsFinished("Jump") then
        mod:LunaChangeState(entity)
    elseif sprite:IsFinished("SummonDoor") then
        sprite:Play("Jump",true)

    elseif sprite:IsEventTriggered("Jump") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    elseif sprite:IsEventTriggered("Land") then
        sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1)

        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        --SPIKES
        local nSpikes = 9
        if (room:GetRoomShape()>=RoomShape.ROOMSHAPE_2x2) then
            nSpikes = 27
        end

        for i=1,nSpikes do
            local position = room:GetGridPosition(room:GetClampedGridIndex (room:GetRandomPosition(0)))
            local spike = mod:SpawnEntity(mod.Entity.Spike, position, Vector.Zero, entity)
            spike.Parent = entity
        end
        
    elseif sprite:IsEventTriggered("Preland") and entity.Child then
        entity.Child:GetSprite():Play("Close",true)

    elseif sprite:IsEventTriggered("SummonDoor") then
        local door = mod:SpawnLunaDoor(entity, mod.DoorType.SACRIFICE, entity.Position)
    end

end
function mod:LunaSS(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        mod:LunaChangeState(entity, fixState)

    elseif sprite:IsEventTriggered("Attack") then

    end

end
function mod:LunaMegaMush(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("MegaMush",true)
        entity.Child = nil
        
        sfx:Play(Isaac.GetSoundIdByName("MarioGrow"),1.5, 2, false, 0.75)

    elseif sprite:IsFinished("MegaMush") then
        mod:LunaTurnInvisible(entity, true)
        sprite:Play("TrapdoorOut")
        sprite:Stop()

        local position = room:GetRandomPosition(0)
        local moon = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, position, Vector.Zero, entity)
        moon:GetData().TargetPos = position
        moon.DepthOffset = -1500

        moon.DepthOffset = 10
        moon:GetSprite():Load("gfx/effect_LunaMegaMush.anm2", true)
        moon:GetSprite():Play("In1", true)
        entity.Child = moon

        for _, f in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 0)) do
            f:Remove()
        end

    elseif entity.Child then
        local moon = entity.Child
        local moonSprite = moon:GetSprite()
        local moonData = moon:GetData()
        if moonSprite:IsFinished("In1") or moonSprite:IsFinished("In") then
            data.ImpactsDone = data.ImpactsDone + 1
            if data.ImpactsDone > mod.LConst.maxImpacts then
                data.ImpactsDone = 0
                moonData.TargetPos = Vector.Zero
                moonSprite:Play("Bounce2")
            else
                moonSprite:Play("Bounce")
            end
            
            --Self Damage
            local hp = entity.HitPoints - mod.LConst.impactDamage
            if hp > 0 then
                entity:TakeDamage(mod.LConst.impactDamage, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
            end

            --Explosion
            sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 2)
            mod:SpawnGlassFracture(moon, 2, 5)
            game:ShakeScreen(70)

            local offset = 360*rng:RandomFloat()
            for i=1, mod.LConst.nBlasts do
                local direction = Vector(1,0):Rotated(360*i/mod.LConst.nBlasts + offset)
                local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 1, moon.Position, Vector.Zero, entity):ToEffect()
                explosion:GetSprite().Color = Color(1,0,0,1)
                explosion.Parent = entity
                local explosionData = explosion:GetData()
                explosionData.Direction = direction
                explosionData.IsActive_HC = true
                explosionData.HeavensCall = true
                
		        sfx:Stop(SoundEffect.SOUND_FART)
            end


        elseif moonSprite:IsPlaying("In1") or moonSprite:IsPlaying("In") or moonSprite:IsPlaying("Bounce2") then
            moon.Position = mod:Lerp(moon.Position, moonData.TargetPos, 0.1)


        elseif moonSprite:IsFinished("Bounce") then
            moonData.TargetPos = mod:GetRandomPosition(moon.Position, 200)
            moon:GetSprite():Play("In", true)

        elseif moonSprite:IsFinished("Bounce2") then
            mod:LunaTurnInvisible(entity, false)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("TrapdoorOut", true)


            local position = Isaac.GetRandomPosition(0)
            while position:Distance(target.Position) < mod.LConst.minDistanceToReappear do
                position = Isaac.GetRandomPosition(0)
            end
            mod:LunaTeleportTo(entity, position)

            local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position + Vector(0,-5), Vector.Zero, entity)
            trapdoor:GetSprite():Play("BigIdle", true)

            entity.Child = nil
            moon:Remove()
        end

    elseif sprite:IsFinished("TrapdoorOut") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        mod:LunaChangeState(entity, mod.LMSState.IDLE)
    end
end
function mod:LunaShovel(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("ShovelSummon",true)
    elseif sprite:IsFinished("ShovelSummon") then
        local diff = (entity.Position - target.Position).X
        if diff < 0 then
            sprite:Play("ShovelR", true)
        else
            sprite:Play("ShovelL", true)
        end

        for i=0, game:GetNumPlayers ()-1 do
            local player = game:GetPlayer(i)
            local stomp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MOM_FOOT_STOMP, 0, player.Position, Vector.Zero, entity)
        end

    elseif sprite:IsPlaying("ShovelL") or sprite:IsPlaying("ShovelR") then
        if sprite:IsEventTriggered("Aim") then
            local diff = (entity.Position - target.Position).X
            local frame = sprite:GetFrame()+1
            if diff < 0 then
                sprite:Play("ShovelR", true)
            else
                sprite:Play("ShovelL", true)
            end
            sprite:SetFrame(frame)

            data.TargetPos = target.Position

        elseif sprite:IsEventTriggered("Attack") then
			sfx:Play(Isaac.GetSoundIdByName("Throw"),1)
            local direction = (data.TargetPos - entity.Position):Normalized()
            entity.Velocity = direction * mod.LConst.shovelSpeed
        end

    elseif sprite:IsFinished("ShovelL") or sprite:IsFinished("ShovelR") then
        local stomp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MOM_FOOT_STOMP, 0, data.TargetPos, Vector.Zero, entity)

        data.ShovelsDone = data.ShovelsDone + 1
        if data.ShovelsDone > mod.LConst.maxShovels then
            data.ShovelsDone = 0
            sprite:Play("ShovelJump", true)
        else
            local diff = (entity.Position - target.Position).X
            if diff < 0 then
                sprite:Play("ShovelR", true)
            else
                sprite:Play("ShovelL", true)
            end
        end
        
    elseif sprite:IsPlaying("ShovelJump") then
        if sprite:IsEventTriggered("Jump") then
            entity.Velocity = Vector.Zero
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            --Patas
            local offset = 360*rng:RandomFloat()
            for i=1, mod.LConst.nFinalPatas do 
                local position = entity.Position + Vector(100, 0):Rotated(360*i/mod.LConst.nFinalPatas + offset)
                local stomp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MOM_FOOT_STOMP, 0, position, Vector.Zero, entity)
            end
        elseif sprite:IsEventTriggered("Land") then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			sfx:Play(Isaac.GetSoundIdByName("ShovelHit"),2)


        end
    elseif sprite:IsFinished("ShovelJump") then
        mod:LunaChangeState(entity, mod.LMSState.ITEM)
    end

end
function mod:LunaFlip(entity, data, sprite, target, room)
    
    if data.StateFrame == 1 then
        sprite:Play("Flip",true)
        sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE)

    elseif sprite:IsFinished("Flip") then
        entity.Visible = false

        local lunaFlip = Isaac.Spawn(EntityType.ENTITY_DOGMA, 10, 160, entity.Position, Vector.Zero, entity)
        lunaFlip.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        lunaFlip:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
        lunaFlip.Parent = entity
        entity.Child = lunaFlip
        data.FlipFlag = true
        
        sprite:Play("Idle",true)
        sprite:Stop()

        if HPBars then
            HPBars.BossDefinitions[tostring(mod.EntityInf[mod.Entity.Luna].ID).."."..tostring(mod.EntityInf[mod.Entity.Luna].VAR)] = {
                sprite = "gfx/bosses/icon_lunaflip.png",
                barStyle = "Dogma"
            }
        end
        --Room
        if mod:IsRoomDescAstralChallenge(game:GetLevel():GetCurrentRoomDesc()) then
            for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0)) do
                e.Visible = false
            end
            for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WORMWOOD_HOLE, 0)) do
                e.Visible = false
            end
            --Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
            game:ShowHallucination (1,BackdropType.DOGMA)
            sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx
            for _, f in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 0)) do
                f:Remove()
            end
        end

    end

    if data.FlipFlag then
        if entity.Child then
            entity.Position = entity.Child.Position
        else
            data.FlipFlag = false
        end
    end

end
function mod:LunaMaw(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Maws",true)
    elseif sprite:IsFinished("Maws") then
        mod:LunaChangeState(entity, mod.LMSState.IDLE)

    elseif sprite:IsEventTriggered("Attack") then
        sprite.Color = Color.Default
        data.MawColor = Color.Default
        data.MawTime = -30

        sfx:Play(SoundEffect.SOUND_MAW_OF_VOID)

        local ring = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.THICK_RED, LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT, entity.Position, Vector.Zero, entity):ToLaser()
        ring.Parent = entity
        ring:GetSprite().Color = mod.Colors.black
        ring.Radius = 0
        ring.Shrink = true
        ring.DepthOffset = 500

        ring:GetData().HeavensCall = true
        ring:GetData().LunaMaw = true
    end
end
function mod:LunaRevelation(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("RevelationLaser",true)
    elseif sprite:IsFinished("RevelationLaser") then
        mod:LunaChangeState(entity, mod.LMSState.IDLE)

    elseif sprite:IsEventTriggered("Aim") then
        sfx:Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 0.8, 2, false, 1.2)
        data.TargetAim = target.Position

    elseif sprite:IsEventTriggered("Attack") then
        sprite.Color = Color.Default
        data.RevelationColor = Color.Default
        data.RevelationTime = -30
        
        local direction = (data.TargetAim - entity.Position):Normalized()
        local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, entity.Position, direction:GetAngleDegrees(), 15, Vector.Zero, entity):ToLaser()

    end
end
function mod:LunaDark(entity, data, sprite, target, room)

    if data.StateFrame == 1 then
        sprite:Play("Dark",true)

        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, entity.Position, Vector.Zero, nil):ToEffect()
        trail:FollowParent(entity)
        --trail:GetSprite().Color = Color(1,0,0,1)
        trail.MinRadius = 0.05
        trail.SpriteScale = 3*Vector.One

        trail:Update()

        trail:GetSprite():Load("gfx/effect_LunaTrail.anm2", true)
        --trail:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_trail.png")
        trail:GetSprite():Play("Idle")
        
    elseif sprite:IsFinished("Dark") then
        data.DarkPos = {}
        data.DarkCount = 0
        data.DarkMove = false
        mod:LunaChangeState(entity, mod.LMSState.IDLE)

        sfx:Play(SoundEffect.SOUND_BLACK_POOF, 5)
        
        for i = 1, 3 do
            local position = entity.Position + Vector(50*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())
            local velocity = Vector(15*rng:RandomFloat(),0):Rotated(360*rng:RandomFloat())
            local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, position, velocity, nil):ToEffect()
            cloud:GetSprite().Scale = 4*Vector.One
            cloud:GetSprite().Color = mod.Colors.black
            cloud:GetSprite().PlaybackSpeed = 0.75
            cloud.DepthOffset = 50
        end

        for _, trail in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0)) do
            trail:Remove()
        end

    elseif sprite:IsEventTriggered("Aim") then
        local position = room:GetRandomPosition(0)

        for i=1, 100 do
            local flag = true
            for _, target in ipairs(mod:FindByTypeMod(mod.Entity.LunaTarget)) do
                if position:Distance(target.Position) < 100 then
                    position = room:GetRandomPosition(0)
                    flag = false
                    break
                end
            end
            if flag then break end
        end

        data.DarkPos[#(data.DarkPos)+1] = position

        local target = mod:SpawnEntity(mod.Entity.LunaTarget, position, Vector.Zero, entity):ToEffect()
        target.Timeout = 220

    elseif sprite:IsEventTriggered("Attack") then
        data.DarkMove = true
        data.DarkCount = data.DarkCount + 1

        data.DarkAim = data.DarkPos[data.DarkCount]
    end

    if data.DarkMove then
        local velocity = (data.DarkAim - entity.Position):Normalized() * mod.LConst.darkSpeed
        entity.Velocity = velocity

        if (data.DarkAim - entity.Position):Length() < 30 then
            entity.Velocity = Vector.Zero
            sprite:SetFrame(mod.LConst.darkAttackFrame[data.DarkCount + 1])
            data.DarkMove = false

            local targets = mod:FindByTypeMod(mod.Entity.LunaTarget)
            targets[1]:Remove()
            sfx:Play(SoundEffect.SOUND_TOOTH_AND_NAIL, 1)
        end

    end

end

function mod:LunaFlipUpdate(entity)
    if entity.Variant == 10 and entity.SubType == 160 then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        if not entity.Parent then entity:Die() end
        
        if not data.Init then
            data.Init = true

            sprite:Play("Idle", true)

            data.FlipAttacksDone = 0
        end
    
        if sprite:IsFinished("Idle") then
            if data.FlipAttacksDone < mod.LConst.maxFlipAttacks then
                if rng:RandomFloat() < 0.8 then
                    data.FlipAttacksDone = data.FlipAttacksDone + 1
    
                    local random = mod:RandomInt(1,3)
                    if random == 1 then
                        sprite:Play("Attack1", true)
                        data.WaveOffset = 360*rng:RandomFloat()
                    elseif random == 2 then
                        sfx:Play(Isaac.GetSoundIdByName("Pray"),3)
                        sprite:Play("Attack2", true)
                    else
                        sprite:Play("Attack3", true)
                    end
                else
                    sprite:Play("Idle", true)
                end

            else
                data.FlipAttacksDone = 0
                sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_DEAD)
                sprite:Play("Flip", true)
            end

        elseif sprite:IsFinished("Flip") or sprite:IsEventTriggered("End") then
            entity.Parent:GetSprite():Play("Idle", true)
            mod:LunaChangeState(entity.Parent, mod.LMSState.IDLE)
            entity.Parent.Visible = true
            entity.Parent:GetSprite():Play("Idle",true)
            entity:Remove()

            if HPBars then
                HPBars.BossDefinitions[tostring(mod.EntityInf[mod.Entity.Luna].ID).."."..tostring(mod.EntityInf[mod.Entity.Luna].VAR)] = {
                    sprite = "gfx/bosses/icon_luna.png",
                    barStyle = "LunarHC"
                }
            end

            --Room
            if mod:IsRoomDescAstralChallenge(game:GetLevel():GetCurrentRoomDesc()) then
                for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0)) do
                    e.Visible = true
                end
                for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WORMWOOD_HOLE, 0)) do
                    e.Visible = true
                end
                --Change background, but not the actual background but the floor and walls, but there are no walls. Was it clear? good
                game:ShowHallucination (1,BackdropType.PLANETARIUM)
                sfx:Stop (SoundEffect.SOUND_DEATH_CARD)--Silence the ShowHallucination sfx
            end

        elseif sprite:IsFinished("Attack1") or sprite:IsFinished("Attack2") or sprite:IsFinished("Attack3") then
            data.Dir1 = nil
            data.Dir2 = nil
            data.Dir3 = nil
            sprite:Play("Idle", true)

        elseif sprite:IsPlaying("Attack1") then
            local n
            if sprite:IsEventTriggered("Attack1") then
                entity:SetColor(mod.Colors.glitch, 10, 1, true, false)
                n = mod.LConst.wave1Flip
            elseif sprite:IsEventTriggered("Attack2") then
                entity:SetColor(mod.Colors.glitch, 10, 1, true, false)
                n = mod.LConst.wave2Flip
            elseif sprite:IsEventTriggered("Attack3") then
                entity:SetColor(mod.Colors.glitch, 10, 1, true, false)
                n = mod.LConst.wave3Flip
            end

            if n then
                for i=1, n do
                    local velocity = Vector(1,0):Rotated(i*360/n + data.WaveOffset) * mod.LConst.waveFlipSpeed
                    local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_WING, 0, entity.Position, velocity, entity):ToProjectile()

                    shot:GetSprite():ReplaceSpritesheet(0, "gfx/effects/static_diamond.png")
                    shot:GetSprite():LoadGraphics()
                end
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1.2)
            end

        elseif sprite:IsPlaying("Attack2") then
            if sprite:IsEventTriggered("Attack1") then

                local offset = 360*rng:RandomFloat()
                for i=1,2 do
                    local position = entity.Position + Vector(50, 0):Rotated(i*360/2+offset)

                    if #Isaac.FindByType(EntityType.ENTITY_DOGMA, 10, 0) < mod.LConst.maxAngels then
                        local angel = Isaac.Spawn(EntityType.ENTITY_DOGMA, 10, 0, position, Vector.Zero, entity)
                    end
                end
            end

        elseif sprite:IsPlaying("Attack3") then
            if sprite:IsEventTriggered("Attack1") then
                entity:SetColor(mod.Colors.glitch, 5, 1, true, false)

                local dirs
                if not data.Dir1 then
                    dirs = {360*rng:RandomFloat(), 360*rng:RandomFloat(), 360*rng:RandomFloat(), 360*rng:RandomFloat()}
                    data.Dir1 = dirs
                elseif not data.Dir2 then
                    dirs = {360*rng:RandomFloat(), 360*rng:RandomFloat(), 360*rng:RandomFloat(), 360*rng:RandomFloat()}
                    data.Dir2 = dirs
                elseif not data.Dir3 then
                    dirs = {360*rng:RandomFloat(), 360*rng:RandomFloat(), 360*rng:RandomFloat(), 360*rng:RandomFloat()}
                    data.Dir3 = dirs
                end

                for i=1,3 do
                    local direction = dirs[i]
                    local laser = EntityLaser.ShootAngle(LaserVariant.TRACTOR_BEAM, entity.Position , direction, 5, Vector.Zero, entity)
                    laser:GetSprite().Color = Color(1,1,1,1, 2, 2, 2)
                end
                sfx:Play(SoundEffect.SOUND_DOGMA_JACOBS)

            elseif sprite:IsEventTriggered("Attack2") then
                entity:SetColor(mod.Colors.glitch, 30, 1, true, false)

                local dirs
                if data.Dir1 then
                    dirs = data.Dir1
                    data.Dir1 = nil
                elseif data.Dir2 then
                    dirs = data.Dir2
                    data.Dir2 = nil
                elseif data.Dir3 then
                    dirs = data.Dir3
                    data.Dir3 = nil
                end

                for i=1,3 do
                    local direction = dirs[i]
                    local laser = EntityLaser.ShootAngle(LaserVariant.THICK_RED, entity.Position , direction, 25, Vector.Zero, entity)
                    laser:Update()
                    laser:GetSprite().Color = Color.Default
                    laser.Size = 0.5

                    laser:GetSprite():ReplaceSpritesheet(0, "gfx/effects/static_brimstone.png")
                    laser:GetSprite():LoadGraphics()

                    sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
                    sfx:Play(SoundEffect.SOUND_DOGMA_JACOBS_ZAP)
                end
            end

        end

        mod:LunaFlipMove(entity, data, game:GetRoom())
        sprite.Color = entity.Parent:GetSprite().Color
    end
end

function mod:LunaSynergy(entity, data, sprite, target, room, incubus)

    local mainP
    local secondaryP

    local parent

    local scale = 1
    local laserFrac = 1

    if incubus then
        parent = entity.Parent:ToNPC()

        mainP = parent:GetData().MainP
        secondaryP = parent:GetData().SecondaryP

        scale = mod.LConst.incubusScale
        laserFrac = 2

        data.TargetAim = parent:GetData().TargetAim + (entity.Position - parent.Position)

    else
        mainP = data.MainP
        secondaryP = data.SecondaryP

        local strong = data.StrengthTime >= 0 or data.AssistP == mod.LAssistPassives.POLYPHEMUS or data.AssistP == mod.LAssistPassives.MAGIC_MUSHROOM
        if strong then
            scale = scale + 0.5
        end
    end

    --mainP = mod.LMainPassive.BRIMSTONE
    --secondaryP = mod.LSecondaryPassives.SACRED_HEART
    --scale = 3

    if mainP == 0 then

        sfx:Play(SoundEffect.SOUND_TEARS_FIRE, 2)

        local velocity = (target.Position - entity.Position):Normalized()*10
        local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity):ToProjectile()
        tear.Scale = scale

        if secondaryP == mod.LSecondaryPassives.IPECAC then

            local variance = (Vector(mod:RandomInt(-15, 15),mod:RandomInt(-15, 15))*0.03)
            local vector = (target.Position-entity.Position)*0.028 + variance

            tear.Velocity = vector*scale
            
            tear.Scale = 2*scale
            tear.FallingSpeed = -45;
            tear.FallingAccel = 1.5;

            tear:GetSprite().Color = mod.Colors.boom

            tear:AddProjectileFlags(ProjectileFlags.EXPLODE)

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            tear.Position = tear.Position + tear.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance
            
            local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, tear.Velocity, entity):ToProjectile()
            tear2.Position = tear2.Position + tear2.Velocity:Normalized():Rotated(-90)*mod.LConst._20_20_distance
            tear2.Scale = scale

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            tear:Remove()

            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH, 0, entity.Position, velocity, entity):ToProjectile()
            tear.Scale = 1.5*scale
            --tear:AddProjectileFlags(ProjectileFlags.GODHEAD)
            tear.Velocity = tear.Velocity/3
            mod:TearFallAfter(tear, 300)

            --tear:GetSprite().Color = mod.Colors.whiteish


            local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear.Position, tear.Velocity, tear):ToEffect()
            aura.Parent = tear
            tear.Child = aura
            aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
            aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
            aura:GetSprite():LoadGraphics()
            aura:GetSprite():Play("Idle", true)
            aura.SpriteScale = aura.SpriteScale*1.3
            aura:FollowParent(tear)
            tear:Update()

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaGodHead = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            tear.Scale = 1.75*scale
            tear:AddProjectileFlags(ProjectileFlags.SMART)
            tear.HomingStrength = tear.HomingStrength*0.9
            mod:TearFallAfter(tear, 300)
            
            tear:GetData().LunaProjectile = true
            tear:GetData().LunaSacred = true

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then

            tear:GetSprite().Color = mod.Colors.parasite

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaParasite = true

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then

            tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
            mod:TearFallAfter(tear, 30*7)

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            tear.Velocity = tear.Velocity * 0.5

            tear:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            tear.WiggleFrameOffset = 2000
            mod:TearFallAfter(tear, 30*5)

        end

    elseif mainP == mod.LMainPassive.C_SECTION then

        sfx:Play(Isaac.GetSoundIdByName("Pop2"),1)

        local velocity = (target.Position - entity.Position):Normalized()*10
        --local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity):ToProjectile()
        local tear = mod:SpawnEntity(mod.Entity.LunaFetus, entity.Position, velocity, entity):ToProjectile()
        
        tear.Velocity = tear.Velocity/3*2
        mod:TearFallAfter(tear, 100*scale)
        tear.Scale = scale

        if secondaryP == mod.LSecondaryPassives.IPECAC then
            
            tear.Scale = 1.5*scale

            tear:GetSprite().Color = mod.Colors.boom

            tear:AddProjectileFlags(ProjectileFlags.EXPLODE)

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            tear.Position = tear.Position + tear.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance
            
            --local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, tear.Velocity, entity):ToProjectile()
            local tear2 = mod:SpawnEntity(mod.Entity.LunaFetus, entity.Position, velocity, entity):ToProjectile()
            tear2.Position = tear2.Position + tear2.Velocity:Normalized():Rotated(-90)*mod.LConst._20_20_distance
            
            tear2.Velocity = tear2.Velocity/3*2
            tear2.Scale = scale
            mod:TearFallAfter(tear2, 100*scale)

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            tear.Scale = 1.5*scale
            --tear:AddProjectileFlags(ProjectileFlags.GODHEAD)
            tear.Velocity = tear.Velocity/3
            mod:TearFallAfter(tear, 300*scale)

            tear:GetSprite().Color = mod.Colors.whiteish


            local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear.Position, tear.Velocity, tear):ToEffect()
            aura.Parent = tear
            tear.Child = aura
            aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
            aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
            aura:GetSprite():LoadGraphics()
            aura:GetSprite():Play("Idle", true)
            aura.SpriteScale = aura.SpriteScale*1.3
            aura:FollowParent(tear)
            tear:Update()

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaGodHead = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            tear.Scale = 1.75*scale
            tear:AddProjectileFlags(ProjectileFlags.SMART)
            tear.HomingStrength = tear.HomingStrength
            mod:TearFallAfter(tear, 30*3*scale)
            
            tear:GetData().LunaProjectile = true
            tear:GetData().LunaSacred = true

            tear.Velocity = tear.Velocity * 1.25

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then

            tear:GetSprite().Color = mod.Colors.parasite

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaParasite = true

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then

            tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
            mod:TearFallAfter(tear, 30*7*scale)

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            tear.Velocity = tear.Velocity * 0.5

            tear:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            tear.WiggleFrameOffset = 2000
            mod:TearFallAfter(tear, 30*5*scale)

        end

    elseif mainP == mod.LMainPassive.DR_FETUS then

        sfx:Play(Isaac.GetSoundIdByName("Throw"),1)

        local velocity = (target.Position - entity.Position):Normalized()*10

        local bombVar = BombVariant.BOMB_NORMAL
        if incubus then bombVar = BombVariant.BOMB_SMALL end

        local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, bombVar, 0, entity.Position+5*velocity, velocity, entity):ToBomb()
        local bombSprite = bomb:GetSprite()

        if secondaryP == mod.LSecondaryPassives.IPECAC then

            mod:scheduleForUpdate(function()
                bombSprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/poison.png")
                bombSprite:LoadGraphics()
            end,2)
            
            bomb:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)

            bomb:GetData().LunaBomb = true
            bomb:GetData().LunaIpecac = true
            

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            bomb.Position = bomb.Position + bomb.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance
            
            local bomb2 = Isaac.Spawn(EntityType.ENTITY_BOMB, bombVar, 0, entity.Position+5*velocity, bomb.Velocity, entity):ToBomb()
            bomb2.Position = bomb2.Position + bomb2.Velocity:Normalized():Rotated(-90)*mod.LConst._20_20_distance

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            bomb:GetSprite().Color = mod.Colors.whiteish

            local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, bomb.Position, bomb.Velocity, bomb):ToEffect()
            aura.Parent = bomb
            bomb.Child = aura
            aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
            aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
            aura:GetSprite():LoadGraphics()
            aura:GetSprite():Play("Idle", true)
            aura.SpriteScale = aura.SpriteScale*1.3
            aura:FollowParent(bomb)
            bomb:Update()

            bomb:GetData().LunaBomb = true
            bomb:GetData().LunaGodHead = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            bomb:AddTearFlags(TearFlags.TEAR_HOMING)

            bombSprite.Color = mod.Colors.white
            
            bomb.Parent = entity

            bomb:GetData().LunaBomb = true
            bomb:GetData().LunaSacred = true

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then

            bomb:GetSprite().Color = mod.Colors.parasite

            bomb:GetData().LunaBomb = true
            bomb:GetData().LunaParasite = true

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then
            --Nothing :(
        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            bomb:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

            bomb:GetData().lunaBomb = true
            bomb:GetData().lunaWorm = true
            bomb:GetData().velocity = bomb.Velocity
        end

    elseif mainP == mod.LMainPassive.TECH_X then
        
        local velocity = (target.Position - entity.Position):Normalized()*mod.LConst.xTechSpeed
        local ring = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, 2, entity.Position+Vector(0,-40), velocity, entity):ToLaser()
        ring.Parent = entity
        entity.Child = ring
        ring.Radius = mod.LConst.xTechSize*scale
        ring.DepthOffset = 500

        if secondaryP == mod.LSecondaryPassives.IPECAC then

            ring:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
            ring:GetSprite().Color = mod.Colors.boom

            ring:GetData().LunaRing = true
            ring:GetData().LunaIpecac = true
            ring:GetData().HeavensCall = true

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            ring.Position = ring.Position + ring.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance*1.5
            
            local ring2 = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, 2, entity.Position+Vector(0,-40), ring.Velocity, entity):ToLaser()
            ring2.Parent = entity
            entity.Child = ring2
            ring2.Radius = mod.LConst.xTechSize*scale
            ring2.DepthOffset = 500
            ring2.Position = ring2.Position - ring2.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance*1.5

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            ring:GetSprite().Color = mod.Colors.whiteish
            ring.Velocity = ring.Velocity/2


            local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, ring.Position, ring.Velocity, ring):ToEffect()
            aura.Parent = ring
            aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
            aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
            aura:GetSprite():LoadGraphics()
            aura:GetSprite():Play("Idle", true)
            aura.SpriteScale = aura.SpriteScale*1.3
            aura:FollowParent(ring)

            ring:GetData().LunaRing = true
            ring:GetData().LunaGodHead = true
            ring:GetData().HeavensCall = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            ring.Parent = entity
            ring:GetData().LunaRing = true
            ring:GetData().LunaSacred = true
            ring:GetData().HeavensCall = true
            ring:GetSprite().Color = mod.Colors.white

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then

            ring.Parent = entity
            ring:GetData().LunaRing = true
            ring:GetData().LunaParasite = true
            ring:GetData().HeavensCall = true
            ring:GetSprite().Color = mod.Colors.parasite2

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then
            ring.Velocity = ring.Velocity*1.3
            ring:AddTearFlags(TearFlags.TEAR_CONTINUUM)

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            ring:AddTearFlags(TearFlags.TEAR_WIGGLE)
            ring.Radius = mod.LConst.xTechSize*1.2*scale

        end

    elseif mainP == mod.LMainPassive.HEMOLACRYA then
        sfx:Play(SoundEffect.SOUND_STONESHOOT, 1.3, 2, false, 1.5)

        --Ipecac-like projectile technique from Alt Horsemen
        local variance = (Vector(mod:RandomInt(-15, 15),mod:RandomInt(-15, 15))*0.03)
        local vector = (target.Position-entity.Position)*0.028 + variance
        
        local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, vector, entity):ToProjectile();
        tear.Scale = 2*scale
        tear.FallingSpeed = -45;
        tear.FallingAccel = 1.5;

        tear:GetData().LunaProjectile = true
        tear:GetData().LunaBrust = true
        
        if secondaryP == mod.LSecondaryPassives.IPECAC then
            
            tear:GetSprite().Color = mod.Colors.boom
            tear:AddProjectileFlags(ProjectileFlags.EXPLODE)
            tear:GetData().LunaIpecac = true

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            tear.Position = tear.Position + tear.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance
            
            local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, tear.Velocity, entity):ToProjectile();
            tear2.Scale = 2*scale
            tear2.FallingSpeed = -45;
            tear2.FallingAccel = 1.5;

            tear2:GetData().LunaProjectile = true
            tear2:GetData().LunaBrust = true
            
            tear2.Position = tear.Position - tear.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            tear:Remove()

            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH, 0, entity.Position, vector, entity):ToProjectile();
            tear.Scale = 2*scale
            tear.FallingSpeed = -45;
            tear.FallingAccel = 1.5;
    
            tear:GetData().LunaProjectile = true
            tear:GetData().LunaBrust = true

            --tear:GetSprite().Color = mod.Colors.whiteish

            local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear.Position, tear.Velocity, tear):ToEffect()
            aura.Parent = tear
            tear.Child = aura
            aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
            aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
            aura:GetSprite():LoadGraphics()
            aura:GetSprite():Play("Idle", true)
            aura.SpriteScale = aura.SpriteScale*1.3
            aura:FollowParent(tear)
            tear:Update()

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaGodHead = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            tear:AddProjectileFlags(ProjectileFlags.SMART_PERFECT)
            tear.HomingStrength = tear.HomingStrength*0.5
            
            tear:GetData().LunaProjectile = true
            tear:GetData().LunaSacred = true

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then

            tear:GetSprite().Color = mod.Colors.parasite
            tear:GetData().LunaParasite = true

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then
            tear.Velocity = tear.Velocity*3
            tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
            tear:GetData().LunaContinnum = true

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            tear:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            tear.WiggleFrameOffset = 2000

        end

    elseif mainP == mod.LMainPassive.BRIMSTONE then
    
        local laserVar = LaserVariant.THICK_RED

        local direction = (data.TargetAim - entity.Position):Normalized()
        local laser = EntityLaser.ShootAngle(laserVar, entity.Position, direction:GetAngleDegrees(), 15, Vector.Zero, entity):ToLaser()
        laser.Size = laser.Size/laserFrac

        if secondaryP == mod.LSecondaryPassives.IPECAC then

            laser:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
            laser:GetSprite().Color = mod.Colors.boom

            mod:scheduleForUpdate(function()
                --Need to get end of laser
                local position = laser:GetEndPoint()
                game:BombExplosionEffects (position, 100, TearFlags.TEAR_NORMAL, mod.Colors.boom, nil, 1*scale, true, false, DamageFlag.DAMAGE_EXPLOSION )
            end, 3)

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            laser:Remove()
            
            local pos2 = entity.Position - direction:Rotated(90)*mod.LConst._20_20_distance
            local laser2 = EntityLaser.ShootAngle(laserVar, pos2, direction:GetAngleDegrees(), 15, Vector.Zero, entity)
            laser2.Size = laser2.Size/laserFrac
            
            local pos3 = entity.Position + direction:Rotated(90)*mod.LConst._20_20_distance
            local laser3 = EntityLaser.ShootAngle(laserVar, pos3, direction:GetAngleDegrees(), 15, Vector.Zero, entity)
            laser3.Size = laser3.Size/laserFrac

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            laser:GetSprite().Color = mod.Colors.whiteish
            laser.Timeout = 45
            
            local laser2 = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, entity.Position + direction*80 , direction:GetAngleDegrees(), 45, Vector.Zero, entity)
            laser2.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            laser2:GetSprite().Color = Color(1,1,1,0.5)
            mod:scheduleForUpdate(function()
                laser2.SpriteScale = 7*Vector.One
            end,5)

            laser2:GetData().LunaLaser = true
            laser2:GetData().LunaGodHead = true
            laser2:GetData().HeavensCall = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then --TODO

            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            laser:Remove()

            local adversary = Isaac.Spawn(EntityType.ENTITY_ADVERSARY, 0, 0, entity.Position, Vector.Zero, entity):ToNPC()
            adversary:GetData().HeavensCall = true
            adversary.Visible = false
            adversary.State = 8
            adversary.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            adversary:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            adversary:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            local adversarySprite = adversary:GetSprite()
            adversarySprite:Play("Attack2Up", true)
            adversarySprite.PlaybackSpeed = 100

            local angulo = direction:GetAngleDegrees()
            angulo = mod:Takeclosest({0,90,180,-180,-90}, angulo)
            if angulo == 0 then
                adversary.I1 = 2
            elseif angulo == 90 then
                adversary.I1 = 3
            elseif angulo == 180 or angulo == -180 then
                adversary.I1 = 0
            elseif angulo == -90 then
                adversary.I1 = 1
            end

            mod:scheduleForUpdate(function()
                local laser2
                for _,l in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER, LaserVariant.THICK_RED, 0)) do
                    if l.Parent.Type == EntityType.ENTITY_ADVERSARY then
                        laser2 = l
                        laser2.Parent = entity
                        laser2.SpawnerEntity = entity
                        laser2 = laser2:ToLaser()
                        break
                    end
                end

                if laser2 then
                    --laser2.Angle = direction:GetAngleDegrees()
                    --laser2.AngleDegrees = direction:GetAngleDegrees()
                    laser2.Position = entity.Position
                    laser2.ParentOffset = Vector.Zero
                    laser2:GetSprite().Color = mod.Colors.white
                    
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end

                adversary:Remove()
                laser = laser2
            end,3)

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then
            
            laser:GetSprite().Color = mod.Colors.parasite2
            mod:scheduleForUpdate(function()
                --Need to get end of laser
                local position = laser:GetEndPoint()
                for i = 0, 1 do
                    local laser = EntityLaser.ShootAngle(laserVar, position , direction:GetAngleDegrees() + 90*(2*i-1), 15, Vector.Zero, entity)
                end
            end, 3)

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then
            laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

            mod:scheduleForUpdate(function()
                if data.TraceAngle then
                    local laser2 = EntityLaser.ShootAngle(laserVar, data.TraceOrigin, data.TraceAngle, 15, Vector.Zero, entity)
                    laser2:AddTearFlags(TearFlags.TEAR_CONTINUUM)
                    laser2.Size = laser2.Size/laserFrac
                    laser2.DisableFollowParent = true
                end
            end, 3)

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then --TODO
            
            laser:AddTearFlags(TearFlags.TEAR_WIGGLE)
            laser.CurveStrength = 100

        end
    elseif mainP == mod.LMainPassive.REVELATIONS then
        
        local direction = (data.TargetAim - entity.Position):Normalized()
        local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, entity.Position, direction:GetAngleDegrees(), 15, Vector.Zero, entity):ToLaser()
        laser.Size = laser.Size/laserFrac

        if secondaryP == mod.LSecondaryPassives.IPECAC then

            laser:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
            laser:GetSprite().Color = mod.Colors.boom

            
            local laser2 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, entity.Position, direction:GetAngleDegrees(), 15, Vector.Zero, entity):ToLaser()
            laser2.Visible = false
            laser2.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            laser2:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)

            mod:scheduleForUpdate(function()
                --Need to get end of laser
                local position = laser2:GetEndPoint()
                game:BombExplosionEffects (position, 100, TearFlags.TEAR_NORMAL, mod.Colors.boom, nil, 1*scale, true, false, DamageFlag.DAMAGE_EXPLOSION )
            end, 3)

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            laser:Remove()
            
            local pos2 = entity.Position - direction:Rotated(90)*mod.LConst._20_20_distance
            local laser2 = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, pos2, direction:GetAngleDegrees(), 15, Vector.Zero, entity)
            laser2.Size = laser2.Size/laserFrac
            
            local pos3 = entity.Position + direction:Rotated(90)*mod.LConst._20_20_distance
            local laser3 = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, pos3, direction:GetAngleDegrees(), 15, Vector.Zero, entity)
            laser3.Size = laser3.Size/laserFrac

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            laser:GetSprite().Color = mod.Colors.whiteish
            laser.Timeout = 45
            
            local laser2 = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, entity.Position + direction*80 , direction:GetAngleDegrees(), 45, Vector.Zero, entity)
            laser2.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            laser2:GetSprite().Color = Color(1,1,1,0.5)
            mod:scheduleForUpdate(function()
                laser2.SpriteScale = 7*Vector.One
            end,5)

            laser2:GetData().LunaLaser = true
            laser2:GetData().LunaGodHead = true
            laser2:GetData().HeavensCall = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            laser:Remove()

            local adversary = Isaac.Spawn(EntityType.ENTITY_ADVERSARY, 0, 0, entity.Position, Vector.Zero, entity):ToNPC()
            adversary:GetData().HeavensCall = true
            adversary.Visible = false
            adversary.State = 8
            adversary.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            adversary:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            adversary:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            local adversarySprite = adversary:GetSprite()
            adversarySprite:Play("Attack2Up", true)
            adversarySprite.PlaybackSpeed = 100

            local angulo = direction:GetAngleDegrees()
            angulo = mod:Takeclosest({0,90,180,-180,-90}, angulo)
            if angulo == 0 then
                adversary.I1 = 2
            elseif angulo == 90 then
                adversary.I1 = 3
            elseif angulo == 180 or angulo == -180 then
                adversary.I1 = 0
            elseif angulo == -90 then
                adversary.I1 = 1
            end

            mod:scheduleForUpdate(function()
                local laser2
                for _,l in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER, LaserVariant.THICK_RED, 0)) do
                    if l.Parent.Type == EntityType.ENTITY_ADVERSARY then
                        laser2 = l
                        laser2.Parent = entity
                        laser2.SpawnerEntity = entity
                        laser2 = laser2:ToLaser()

                        --local laser2Sprite = laser2:GetSprite()
                        --laser2Sprite:Load("gfx/007.005_lightbeam.anm2", true)
                        --laser2Sprite:LoadGraphics()

                        sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
                        sfx:Play(SoundEffect.SOUND_ANGEL_BEAM)

                        break
                    end
                end

                if laser2 then
                    --laser2.Angle = direction:GetAngleDegrees()
                    --laser2.AngleDegrees = direction:GetAngleDegrees()
                    laser2.Position = entity.Position
                    laser2.ParentOffset = Vector.Zero
                    laser2:GetSprite().Color = mod.Colors.white

                    laser2:GetSprite():ReplaceSpritesheet(0, "gfx/effects/light_brimstone.png")
                    laser2:GetSprite():ReplaceSpritesheet(1, "gfx/effects/light_brimstone.png")
                    laser2:GetSprite():LoadGraphics()
                    
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end

                adversary:Remove()
                laser = laser2
            end,3)

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then
            
            laser:GetSprite().Color = mod.Colors.parasite

            local laser2 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, entity.Position, direction:GetAngleDegrees(), 15, Vector.Zero, entity):ToLaser()
            laser2.Visible = false
            laser2.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            laser2:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)

            mod:scheduleForUpdate(function()
                --Need to get end of laser
                local position = laser2:GetEndPoint()
                for i = 0, 1 do
                    local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, position , direction:GetAngleDegrees() + 90*(2*i-1), 15, Vector.Zero, entity)
                end
            end, 3)

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then
            laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

            local laser2 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, entity.Position, direction:GetAngleDegrees(), 15, Vector.Zero, entity)
            laser2.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            laser2.Visible = false

            mod:scheduleForUpdate(function()
                --Need to get end of laser
                local endPos = laser2:GetEndPoint()
                local vector = endPos - room:GetCenterPos()
                local position = room:GetCenterPos() - vector*1.4

                local laser3 = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, position, direction:GetAngleDegrees(), 15, Vector.Zero, entity)
                laser3:AddTearFlags(TearFlags.TEAR_CONTINUUM)
                laser3.Size = laser3.Size/laserFrac

            end, 3)

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then --TODO
            --:(
        end
    elseif mainP == mod.LMainPassive.MUTANT_SPIDER or mainP == mod.LMainPassive.SPIDER_FREAK then

        sfx:Play(SoundEffect.SOUND_TEARS_FIRE, 2)

        local nTears = 4
        local spiderAngle = mod.LConst.spiderAngle
        if mainP == mod.LMainPassive.SPIDER_FREAK then 
            nTears = 6
            spiderAngle = mod.LConst.spiderFreakAngle
        end

        local tears = {}

        for i=1,nTears do
            local velocity = (target.Position - entity.Position):Normalized():Rotated((i-3)*spiderAngle - 5)*7

            local var = ProjectileVariant.PROJECTILE_NORMAL
            if secondaryP == mod.LSecondaryPassives.GOD_HEAD then
                var = ProjectileVariant.PROJECTILE_HUSH
            end

            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, var, 0, entity.Position, velocity, entity):ToProjectile()
            tear.Height = tear.Height - 25
            tears[i] = tear
            tear.Scale = scale
        end


        if secondaryP == mod.LSecondaryPassives.IPECAC then

            for i=1,nTears do
                local tear = tears[i]

                local vector = (tear.Velocity*25)*0.028

                tear.Velocity = vector*scale
                
                tear.Scale = 2*scale
                tear.FallingSpeed = -45;
                tear.FallingAccel = 1.5;

                tear:GetSprite().Color = mod.Colors.boom

                tear:AddProjectileFlags(ProjectileFlags.EXPLODE)
            end


        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            for i=0,nTears+1,nTears+1 do
                local velocity = (target.Position - entity.Position):Normalized():Rotated((i-3)*spiderAngle - 5)*7

                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity):ToProjectile()
                tear.Height = tear.Height - 25
                tears[i] = tear
                tear.Scale = scale
            end

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            for i=1,nTears do
                local tear = tears[i]

                tear.Scale = 1.5*scale
                tear.Velocity = tear.Velocity*0.8
                mod:TearFallAfter(tear, 300*scale)

                tear:GetSprite().Color = mod.Colors.whiteish


                local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear.Position, tear.Velocity, tear):ToEffect()
                aura.Parent = tear
                tear.Child = aura
                aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
                aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
                aura:GetSprite():LoadGraphics()
                aura:GetSprite():Play("Idle", true)
                aura.SpriteScale = aura.SpriteScale*1.3
                aura:FollowParent(tear)
                tear:Update()

                tear:GetData().LunaProjectile = true
                tear:GetData().LunaGodHead = true
            end

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            for i=1,nTears do
                local tear = tears[i]

                tear.Scale = 1.75*scale
                tear:AddProjectileFlags(ProjectileFlags.SMART)
                tear.HomingStrength = tear.HomingStrength*0.9
                mod:TearFallAfter(tear, 300*scale)
                
                tear:GetData().LunaProjectile = true
                tear:GetData().LunaSacred = true

            end

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then

            for i=1,nTears do
                local tear = tears[i]

                tear:GetSprite().Color = mod.Colors.parasite

                tear:GetData().LunaProjectile = true
                tear:GetData().LunaParasite = true

            end

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then

            for i=1,nTears do
                local tear = tears[i]

                tear:AddProjectileFlags(ProjectileFlags.CONTINUUM)
                mod:TearFallAfter(tear, 30*2.5)

            end

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            for i=1,nTears do
                local tear = tears[i]

                tear.Velocity = tear.Velocity * 0.5

                tear:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
                tear:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                tear.WiggleFrameOffset = 2000
                mod:TearFallAfter(tear, 30*5)
            end

        end
    elseif mainP == mod.LMainPassive.LIL_SLUGGER then

        local tear
        local saw
        local tears = {}

        local velocity = (target.Position - entity.Position):Normalized()*mod.LConst.sluggerSpeed
        saw, tear, tears = mod:SpawnSaw(entity, velocity, scale, tears)

        tear.Scale = scale

        local function AdjustSawScale(newScale)
            saw.Scale = newScale
            local n = math.floor(5*scale)

            for i=1, n do
                tears[i]:GetData().SawPosition = tears[i]:GetData().SawPosition/scale*newScale
            end
        end

        if secondaryP == mod.LSecondaryPassives.IPECAC then

            saw:GetSprite().Color = mod.Colors.boom
            tear:GetSprite().Color = mod.Colors.boom
            tear:AddProjectileFlags(ProjectileFlags.EXPLODE)
            tear:GetData().LunaSawIpecac = true

        elseif secondaryP == mod.LSecondaryPassives._20_20 then

            saw.Position = saw.Position + saw.Velocity:Normalized():Rotated(90)*mod.LConst._20_20_distance
            
            local saw2
            saw2, tear, tears = mod:SpawnSaw(entity, velocity, scale, tears)
            saw2.Position = saw2.Position + saw2.Velocity:Normalized():Rotated(-90)*mod.LConst._20_20_distance

        elseif secondaryP == mod.LSecondaryPassives.GOD_HEAD then

            AdjustSawScale(scale*1.5)
            saw.Velocity = saw.Velocity/3

            saw:GetSprite().Color = mod.Colors.whiteish


            local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear.Position, tear.Velocity, tear):ToEffect()
            aura.Parent = tear
            tear.Child = aura
            aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
            aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
            aura:GetSprite():LoadGraphics()
            aura:GetSprite():Play("Idle", true)
            aura.SpriteScale = aura.SpriteScale*1.3
            aura:FollowParent(tear)
            tear:Update()

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaGodHead = true

        elseif secondaryP == mod.LSecondaryPassives.SACRED_HEART then

            AdjustSawScale(scale*1.75)
            
            tear:AddProjectileFlags(ProjectileFlags.SMART)
            tear.HomingStrength = tear.HomingStrength*0.9
            
            tear:GetData().LunaSacredSaw = true
            tear.Velocity = velocity

        elseif secondaryP == mod.LSecondaryPassives.PARASITE then
            
            saw:GetSprite().Color = mod.Colors.parasite

            tear:GetData().LunaProjectile = true
            tear:GetData().LunaSawParasite = true

        elseif secondaryP == mod.LSecondaryPassives.CONTINUUM then

            saw:AddTearFlags(TearFlags.TEAR_CONTINUUM)

        elseif secondaryP == mod.LSecondaryPassives.CLASSIC_WORM then

            saw:AddTearFlags(TearFlags.TEAR_WIGGLE)
            saw:AddTearFlags(TearFlags.TEAR_SQUARE)
            --saw:AddTearFlags(TearFlags.TEAR_BIG_SPIRAL)
            --saw:AddTearFlags(TearFlags.TEAR_TURN_HORIZONTAL)

        end

    end
end
function mod:LunaHeal(entity, amount, mute)
    --Heal
    local healHeart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, entity.Position + Vector(0,-100), Vector.Zero, entity)
    healHeart.DepthOffset = 200
    
    if not mute then
        sfx:Play(SoundEffect.SOUND_VAMP_GULP,1)
    end

    entity:AddHealth(amount)
end
function mod:SpawnSaw(entity, velocity, scale, tears)
    
    local saw = TaintedTreasure:FireSawblade(Isaac.GetPlayer(0), velocity, Color.Default, nil, entity.Position):ToTear()
    saw.Scale = scale
    saw.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    local function SpawnSawHit(offset)
        local tear_ = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, Vector.Zero, entity):ToProjectile()
        tear_.Visible = false
        tear_.FallingSpeed = 0
        tear_.FallingAccel = -0.1
        tear_.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        tear_:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)

        tear_:GetData().HeavensCall = true
        tear_:GetData().LunaProjectile = true
        tear_:GetData().LunaSaw = true
        tear_:GetData().SawPosition = offset

        tear_.Parent = saw

        return tear_
    end

    local n = math.floor(5*scale)
    for i=0,n-1 do        
        local position =  Vector(scale*15, 0):Rotated(360/n*i)
        tears[i+1] = SpawnSawHit(position)
    end
    tear = SpawnSawHit(Vector.Zero)
    tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    saw.TearFlags = TearFlags.TEAR_NORMAL

    return saw, tear, tears
end
function mod:LunaChangeState(entity, fixState)
    local data = entity:GetData()

    if data.MawTime >= mod.LConst.mawFrames and (fixState==nil) then
        data.State = mod.LMSState.MAW
        data.StateFrame = 0
        return
    end
    if data.RevelationTime >= mod.LConst.revelationFrames and (fixState==nil) then
        data.State = mod.LMSState.REVELATION
        data.StateFrame = 0
        return
    end
    if data.ForceDark and (fixState==nil) then
        data.ForceDark = false
        data.State = mod.LMSState.DARK_ARTS
        data.StateFrame = 0
        return
    end


    if fixState then
        data.State = fixState
    elseif data.State ~= mod.LMSState.MEGA_MUSH and data.State ~= mod.LMSState.FLIP and data.State ~= mod.LMSState.MOMS_SHOVEL then
        data.State = mod:MarkovTransition(data.State, mod.chainL)
    end
    data.StateFrame = 0

    if data.AssistP ~= mod.LAssistPassives.MAW_VOID then
        entity:GetSprite().Color = Color.Default
        data.MawColor = Color.Default
    end

end
function mod:LunaTraceLaser(entity, data, sprite, target, room, incubus)
    local mainP
    local secondaryP

    local parent

    local scale = 1
    local laserFrac = 1

    if incubus then
        parent = entity.Parent:ToNPC()

        mainP = parent:GetData().MainP
        secondaryP = parent:GetData().SecondaryP

        scale = mod.LConst.incubusScale
        laserFrac = 2

        data.TargetAim = parent:GetData().TargetAim + (entity.Position - parent.Position)

    else
        mainP = data.MainP
        secondaryP = data.SecondaryP

        local strong = data.StrengthTime >= 0 or data.AssistP == mod.LAssistPassives.POLYPHEMUS or data.AssistP == mod.LAssistPassives.MAGIC_MUSHROOM
        if strong then
            scale = scale + 0.5
        end
    end

    scale = scale/2

    if mainP == mod.LMainPassive.REVELATIONS or mainP == mod.LMainPassive.BRIMSTONE then
        
        local direction = (data.TargetAim - entity.Position):Normalized()
        local laser = EntityLaser.ShootAngle(LaserVariant.TRACTOR_BEAM, entity.Position, direction:GetAngleDegrees(), 10, Vector.Zero, entity):ToLaser()
        laser.Size = laser.Size/laserFrac

        --sfx:Stop(SoundEffect.SOUND_ANGEL_BEAM)

        if secondaryP == mod.LSecondaryPassives.CONTINUUM then
            laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)

            mod:scheduleForUpdate(function()
                --Need to get end of laser
                local endPos = laser:GetEndPoint()
                local vector = endPos - room:GetCenterPos()
                local position = room:GetCenterPos() - vector*1.4

                local laser2 = EntityLaser.ShootAngle(LaserVariant.TRACTOR_BEAM, position, direction:GetAngleDegrees(), 10, Vector.Zero, entity)
                laser2:AddTearFlags(TearFlags.TEAR_CONTINUUM)
                laser2.Size = laser2.Size/laserFrac

                --sfx:Stop(SoundEffect.SOUND_ANGEL_BEAM)
                data.TraceOrigin = laser2.Position
                data.TraceAngle = laser2.Angle

            end, 3)
        end
    end
end

--Move
function mod:LunaMove(entity, data, room, target)

    local speed = mod.LConst.speed
    if data.AssistP == mod.LAssistPassives.MAGIC_MUSHROOM or data.AssistP == mod.LAssistPassives.STOPWATCH then
        speed = mod.LConst.superSpeed
    end
    
    --idle move taken from 'Alt Death' by hippocrunchy
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.LConst.idleTimeInterval.X, mod.LConst.idleTimeInterval.Y)
		--V distance of Jupiter from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > 100 then
			data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		--Else, get closer to the player
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
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * speed
    data.targetvelocity = data.targetvelocity * 0.99
end
function mod:LunaFlipMove(entity, data, room)
    local center = room:GetCenterPos()
    --idleTime == frames moving in the same direction
    if not data.idleTime then 
        data.idleTime = mod:RandomInt(mod.VConst.idleTimeInterval.X, mod.VConst.idleTimeInterval.Y)--Venus things

        if center:Distance(entity.Position) < 25 then
            data.targetvelocity = (-(center - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-45, 45))
        else
            data.targetvelocity = ((center - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
        end
    end
    
    --If run out of idle time
    if data.idleTime <= 0 and data.idleTime ~= nil then
        data.idleTime = nil
    else
        data.idleTime = data.idleTime - 1
    end
    
    --Do the actual movement
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * 1.2
    data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:LunaDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Luna].VAR then
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.LunaIncubus)) do
            e:Remove()
        end
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.LunaKnife)) do
            e:Remove()
        end
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.LunaWisp)) do
            e:Remove()
        end
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.AltHorsemen)) do
            e:Remove()
        end
        for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_CLUTCH, 1)) do
            e:Remove()
        end

        mod:NormalDeath(entity, true, true)
    end
end
--deding
function mod:LunaDying(entity)
    
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.deathFrame == nil then data.deathFrame = 1 end

    if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
        if data.deathFrame == 2 then
			local customMusic = Isaac.GetMusicIdByName("Luna_Death")
			music:Crossfade (customMusic, 2)
		
        elseif data.deathFrame == 50 then
            local trapdoor = mod:SpawnEntity(mod.Entity.RedTrapdoor, entity.Position, Vector.Zero, entity)
            trapdoor:GetSprite():Play("BigIdle", true)
        end
	end

end

--Teleport Luna
function mod:LunaTeleportTo(entity, position)
    entity.Position = position

    for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Luna].ID)) do
        if e.Variant ~= mod.EntityInf[mod.Entity.Luna].VAR and e.Parent == entity then
            e.Position = position
        end
    end
end
function mod:LunaTurnInvisible(entity, into)
    if into then--Turn invisible
        entity.Visible = false
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Luna].ID)) do
            if e.Variant ~= mod.EntityInf[mod.Entity.Luna].VAR and e.Parent == entity then
                e.Visible = false
                e.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                e.AddEntityFlags(EntityFlag.FLAG_FREEZE)
            end
        end

    else--Turn visible
        entity.Visible = true
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Luna].ID)) do
            if e.Variant ~= mod.EntityInf[mod.Entity.Luna].VAR and e.Parent == entity then
                e.Visible = true
                e.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                e.ClearEntityFlags(EntityFlag.FLAG_FREEZE)
            end
        end

    end
end

--Count bosses summones
function mod:LunaBossCount()
    local total = #Isaac.FindByType(EntityType.ENTITY_MONSTRO) + #Isaac.FindByType(EntityType.ENTITY_DUKE) + #Isaac.FindByType(EntityType.ENTITY_GEMINI) + #Isaac.FindByType(EntityType.ENTITY_LARRYJR)

    return total
end
--Pick item
function mod:LunaChooseItem(itemList, itemOld, dice, entity)

    local data = entity:GetData()

    if dice then
        if itemOld == 0 then
            return 0
        end
    end

    local itemNum = mod:LunaPick(itemList, itemOld)

    local laser = false --itemNum == mod.LMainPassive.BRIMSTONE or itemNum == mod.LMainPassive.REVELATIONS

    local spider = false
    if TaintedTreasure then
        spider = itemNum == mod.LMainPassive.MUTANT_SPIDER or itemNum == mod.LMainPassive.SPIDER_FREAK
    end

    if (laser or spider) and rng:RandomFloat() < 0.5 then
        itemNum = mod:LunaPick(itemList, itemOld)
    end

    local function IncombatibleItem()
        local incombatible = ((not mod:IsGlassRoom(game:GetLevel():GetCurrentRoomDesc()) ) and itemNum == mod.LSpecials.MEGA_MUSH) or
        (((itemNum == mod.LMainPassive.MUTANT_SPIDER or itemNum == mod.LMainPassive.SPIDER_FREAK) and data.SecondaryP == mod.LSecondaryPassives.GOD_HEAD) or (itemNum == mod.LSecondaryPassives.GOD_HEAD and (data.MainP == mod.LMainPassive.MUTANT_SPIDER or data.MainP == mod.LMainPassive.SPIDER_FREAK))) or
        (((itemNum == mod.LMainPassive.BRIMSTONE or itemNum == mod.LMainPassive.REVELATIONS) and data.SecondaryP == mod.LSecondaryPassives.CLASSIC_WORM) or (itemNum == mod.LSecondaryPassives.CLASSIC_WORM and (data.MainP == mod.LMainPassive.BRIMSTONE or data.MainP == mod.LMainPassive.REVELATIONS))) or
        ((itemNum == mod.LMainPassive.DR_FETUS and data.SecondaryP == mod.LSecondaryPassives.CONTINUUM) or (itemNum == mod.LSecondaryPassives.CONTINUUM and data.MainP == mod.LMainPassive.DR_FETUS)) or
        ((itemNum == mod.LMainPassive.C_SECTION and data.SecondaryP == mod.LSecondaryPassives.CONTINUUM) or (itemNum == mod.LSecondaryPassives.CONTINUUM and data.MainP == mod.LMainPassive.C_SECTION)) or
        (((itemNum == mod.LMainPassive.MUTANT_SPIDER or itemNum == mod.LMainPassive.SPIDER_FREAK) and data.SecondaryP == mod.LSecondaryPassives.SACRED_HEART) or (itemNum == mod.LSecondaryPassives.SACRED_HEART and (data.MainP == mod.LMainPassive.MUTANT_SPIDER or data.MainP == mod.LMainPassive.SPIDER_FREAK))) or
        (itemNum == mod.LActives.KIDNYE_BEAN and (#Isaac.FindByType(EntityType.ENTITY_FAMILIAR)==0 or mod:IsThereLilith())) or
        ((itemNum == mod.LMainPassive.DR_FETUS and data.SecondaryP == mod.LSecondaryPassives.CLASSIC_WORM) or (itemNum == mod.LSecondaryPassives.CLASSIC_WORM and data.MainP == mod.LMainPassive.DR_FETUS)) or
        (itemNum == mod.LActives.FIEND_FOLIO and mod:CountFiends()>0)
            
        return incombatible
    end

    
    while IncombatibleItem() do
        itemNum = mod:LunaPick(itemList, itemOld)
    end

    return itemNum
end
function mod:LunaPick(itemList, itemOld)
    local itemNum = mod:random_elem(itemList)
    while itemOld == itemNum do
        itemNum = mod:random_elem(itemList)
    end
    return itemNum
end

--Give item to luna
function mod:GiveItemLuna(entity, itemNum, tipo)
    local data = entity:GetData()

    if not tipo then
        tipo = data.LastItemType
    end

    if tipo == mod.LItemType.ACTIVE then
        mod:LunaUseActive(entity, itemNum)
    elseif tipo == mod.LItemType.MAIN then
        --itemNum = mod.LMainPassive.BRIMSTONE

        data.MainP = itemNum
    elseif tipo == mod.LItemType.SECONDARY then
        --itemNum = mod.LSecondaryPassives.REVELATIONS

        data.SecondaryP = itemNum
    elseif tipo == mod.LItemType.ASSIST then

        --itemNum = mod.LAssistPassives.REVELATIONS

        for _,k in ipairs(mod:FindByTypeMod(mod.Entity.LunaKnife)) do
            k:Remove()
        end
        for _,i in ipairs(mod:FindByTypeMod(mod.Entity.LunaIncubus)) do
            i:Remove()
        end
        
        data.MawTime = 0
        data.HasMaw = false
        entity:GetSprite().Color = Color.Default
        data.MawColor = Color.Default
        
        data.RevelationTime = 0
        data.HasRevelation = false
        entity:GetSprite().Color = Color.Default
        data.RevelationColor = Color.Default

        data.AssistP = itemNum

        if itemNum == mod.LAssistPassives.MOMS_KNIFE then
            local knife = mod:SpawnEntity(mod.Entity.LunaKnife, entity.Position, Vector.Zero, entity)
            knife.Parent = entity
            knife.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

        elseif itemNum == mod.LAssistPassives.INCUBUS then
            local incubus = mod:SpawnEntity(mod.Entity.LunaIncubus, entity.Position, Vector.Zero, entity)
            incubus.Parent = entity
            incubus.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        elseif itemNum == mod.LAssistPassives.HOLY_MANTLE then
            data.HasMantle = true
        elseif itemNum == mod.LAssistPassives.MAW_VOID then
            data.HasMaw = true
        elseif itemNum == mod.LAssistPassives.REVELATIONS then
            data.HasRevelation = true
        elseif itemNum == mod.LAssistPassives.STOPWATCH then
            
        sfx:Play(Isaac.GetSoundIdByName("TikTok"),3)
        end
    else --SPECIAL
        if itemNum == mod.LSpecials.MEGA_MUSH then
            mod:LunaChangeState(entity, mod.LMSState.MEGA_MUSH)
        elseif itemNum == mod.LSpecials.MOMS_SHOVEL then
            mod:LunaChangeState(entity, mod.LMSState.MOMS_SHOVEL)
        elseif itemNum == mod.LSpecials.FLIP then
            mod:LunaChangeState(entity, mod.LMSState.FLIP)
        end

        return true
    end
    return false
end
function mod:LunaChangeCostumes(entity, data, sprite)

    sprite:ReplaceSpritesheet(8, "") --Mask4
    sprite:ReplaceSpritesheet(7, "") --Mask3
    sprite:ReplaceSpritesheet(6, "") --Mask2
    sprite:ReplaceSpritesheet(5, "") --Mask1
    sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_vanilla.png")
    sprite:ReplaceSpritesheet(3, "") --Wings
    sprite:ReplaceSpritesheet(4, "") --Glow

    local main = data.MainP
    local secondary = data.SecondaryP
    local assist = data.AssistP

    local belial = data.StrengthTime > 0

    if main == 0 then --No main item

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm_maw.png")

            end

        end

    elseif main == mod.LMainPassive.C_SECTION then
        sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_maw.png")
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_polyphemus.png")
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_Csection_sacred.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_Csection_sacred_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_continuum.png")
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_worm_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_Csection_maw.png")

            end

        end

    elseif main == mod.LMainPassive.DR_FETUS then
        sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_drFetus.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_drFetus_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_drFetus_godhead.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_drFetus_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm_maw.png")

            end

        end

    elseif main == mod.LMainPassive.TECH_X then
        sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_parasite.png")
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_parasite_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(6, "")
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_techX_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_techX_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_techX_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_techX_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        end

    elseif main == mod.LMainPassive.HEMOLACRYA then
        sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_polyphemus.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_haemolacrya_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        end

    elseif main == mod.LMainPassive.BRIMSTONE then
        sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_brimstone_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_brimstone_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_brimstone_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_brimstone_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_brimstone_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_brimstone_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_brimstone_continuum_maw.png")

            end

        end

    elseif main == mod.LMainPassive.MUTANT_SPIDER then
        sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_mutant_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_sacred_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_mutant_continuum.png")
            sprite:ReplaceSpritesheet(5, "")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_mutant_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_mutant_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_mutant_worm_maw.png")

            end

        end

    elseif main == mod.LMainPassive.SPIDER_FREAK then
        sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_spiderfreak_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_2020_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_sacred_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_sacred_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_spiderfreak_continuum.png")
            sprite:ReplaceSpritesheet(5, "")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_spiderfreak_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_spiderfreak_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_spiderfreak_worm_maw.png")

            end

        end

    elseif main == mod.LMainPassive.LIL_SLUGGER then
        sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger.png")

        if secondary == 0 then --No secondary item

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_ipecac_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_ipecac_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives._20_20 then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_slugger.png")
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger_2020.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger.png")
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_slugger_2020.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.GOD_HEAD then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger_godhead.png")
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_godhead.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_slugger_godhead.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_godhead.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.SACRED_HEART then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred.png")
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger_sacred.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_sacred_polyphemus.png")
                sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger_sacred.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.PARASITE then
            sprite:ReplaceSpritesheet(6, "gfx/bosses/luna/luna_slugger_parasite.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CONTINUUM then
            sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_continuum_maw.png")

            end

        elseif secondary == mod.LSecondaryPassives.CLASSIC_WORM then
            sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm.png")

            if assist == 0 then
                --nothing lol
            elseif assist == mod.LAssistPassives.POLYPHEMUS then
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm_polyphemus.png")

            elseif assist == mod.LAssistPassives.MAW_VOID then
                sprite:ReplaceSpritesheet(0, "gfx/bosses/luna/luna_maw.png")
                sprite:ReplaceSpritesheet(5, "gfx/bosses/luna/luna_worm_maw.png")

            end

        end

    end

    if assist == mod.LAssistPassives.WAFER then
        sprite:ReplaceSpritesheet(3, "gfx/bosses/luna/luna_wafer.png")

    elseif assist == mod.LAssistPassives.STOPWATCH then
        sprite:ReplaceSpritesheet(7, "gfx/bosses/luna/luna_stopwatch.png")

    elseif assist == mod.LAssistPassives.REVELATIONS then
        if main == mod.LMainPassive.BRIMSTONE then
            if secondary == mod.LSecondaryPassives.IPECAC then
                sprite:ReplaceSpritesheet(3, "gfx/bosses/luna/luna_revelation_black_green.png")
            else
                sprite:ReplaceSpritesheet(3, "gfx/bosses/luna/luna_revelation_black.png")
            end
        elseif secondary == mod.LSecondaryPassives.IPECAC then
            sprite:ReplaceSpritesheet(3, "gfx/bosses/luna/luna_revelation_green.png")
        else
            sprite:ReplaceSpritesheet(3, "gfx/bosses/luna/luna_revelation.png")
        end

    end

    if belial then
        sprite:ReplaceSpritesheet(4, "gfx/bosses/luna/luna_belial.png")
        sprite:ReplaceSpritesheet(8, "gfx/bosses/luna/luna_belialCross.png")
    end

    sprite:LoadGraphics()
end

if false then
    
    mod.testMains = {
        [1] = mod.LMainPassive.C_SECTION,
        [2] = mod.LMainPassive.DR_FETUS,
        [3] = mod.LMainPassive.TECH_X,
        [4] = mod.LMainPassive.HEMOLACRYA,
        [5] = mod.LMainPassive.BRIMSTONE,
        [6] = mod.LMainPassive.MUTANT_SPIDER,
    }
    mod.testSecondaries = {
        [1] = mod.LSecondaryPassives.IPECAC,
        [2] = mod.LSecondaryPassives._20_20,
        [3] = mod.LSecondaryPassives.GOD_HEAD,
        [4] = mod.LSecondaryPassives.SACRED_HEART,
        [5] = mod.LSecondaryPassives.PARASITE,
        [6] = mod.LSecondaryPassives.CONTINUUM,
        [7] = mod.LSecondaryPassives.CLASSIC_WORM,
    }
    mod.testPassives = {
        [1] = mod.LAssistPassives.INCUBUS,
        [2] = mod.LAssistPassives.MOMS_KNIFE,
        [3] = mod.LAssistPassives.HOLY_MANTLE,
        [4] = mod.LAssistPassives.WAFER,
        [5] = mod.LAssistPassives.MAGIC_MUSHROOM,
        [6] = mod.LAssistPassives.POLYPHEMUS,
        [7] = mod.LAssistPassives.MAW_VOID,
        [8] = mod.LAssistPassives.BOWL_TEARS,
        [9] = mod.LAssistPassives.STOPWATCH,
        [10] = mod.LAssistPassives.REVELATIONS,
    }
    
end
function mod:TestCostumes(entity, data, sprite)

    if not sprite:IsPlaying("Idle") then sprite:Play("Idle", true) end

    local f = 5
    if game:GetFrameCount()%f ~= 0 then return end

    local n = game:GetFrameCount()/f
    n = n % (6*7*10) + 1

    data.MainP = math.ceil(n/70)
    data.SecondaryP = math.ceil((n%70)/(10))
    data.AssistP = math.ceil((n%70)%(10))

    if data.AssistP == 0 then data.AssistP = 10 end

    data.MainP = mod.testMains[data.MainP]
    data.SecondaryP = mod.testSecondaries[data.SecondaryP]
    data.AssistP = mod.testPassives[data.AssistP]

    print("")
    --print(n)
    print(data.MainP)
    print(data.SecondaryP)
    print(data.AssistP)


    mod:LunaChangeCostumes(entity, data, sprite)

end

function mod:LunaUseActive(entity, itemNum)
    local data = entity:GetData()

    --itemNum = mod.LActives.KIDNYE_BEAN

    if itemNum == mod.LActives.ABYSS then
        local direction = (entity:GetPlayerTarget().Position - entity.Position):Normalized()

        local nLocust = 0
        for _, f in ipairs(Isaac.FindByType(EntityType.ENTITY_ATTACKFLY, 0, 0)) do
            if f:GetData().HeavensCall then
                nLocust = nLocust + 1
            end
        end

        for i=1+nLocust, mod.LConst.nLocust do
            local position = entity.Position + Vector(20,0):Rotated(i/mod.LConst.nLocust*360)
            local locust = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, position, direction*10, entity)
            locust:GetSprite().Color = mod.Colors.red
            locust.MaxHitPoints = 35
            locust.HitPoints = 35
            locust:GetData().HeavensCall = true

            locust.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end

    elseif itemNum == mod.LActives.BOOK_VIRTUDES then
		sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)  
        
        for _,w in ipairs(mod:FindByTypeMod(mod.Entity.LunaWisp)) do
            w:Remove()
        end

        for i=1, mod.LConst.nWisps do
            local orbitDistance = 14
            local position = entity.Position + Vector(orbitDistance,0):Rotated(i/mod.LConst.nWisps*360)
            local wisp = mod:SpawnEntity(mod.Entity.LunaWisp, position, Vector.Zero, entity)
            wisp.Parent = entity
            
            local wispData = wisp:GetData()
            wispData.orbitIndex = i
            wispData.orbitTotal = mod.LConst.nWisps
            wispData.orbitDistance = orbitDistance
            wispData.orbitSpin = 1
            wispData.orbitSpeed = 4

            wisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end

    elseif itemNum == mod.LActives.BIBLE then
		sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 1.5)  
        local target = entity:ToNPC():GetPlayerTarget()

        local velocity = (target.Position - entity.Position):Normalized()*20
        local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, entity.Position, velocity, entity):ToProjectile()
        local tearSprite = tear:GetSprite()

        tear:GetData().LunaProjectile = true
        tear:GetData().LunaBible = true

        tear:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)

        mod:scheduleForUpdate(function()
            tearSprite:Load("gfx/effect_ICUP.anm2", true)
            tearSprite:ReplaceSpritesheet(2, "gfx/items/collectibles/collectibles_033_thebible.png")
            tearSprite:ReplaceSpritesheet(3, "gfx/items/collectibles/collectibles_033_thebible.png")
            tearSprite:Play("Bible", true)
            tearSprite:LoadGraphics()
        end,2)

    elseif itemNum == mod.LActives.BOOK_BELIAL then
		sfx:Play(SoundEffect.SOUND_DEVIL_CARD)
        data.StrengthTime = mod.LConst.belialFrames

    elseif itemNum == mod.LActives.BOOK_SHADOWS then
		sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)  
        data.ShieldTime = mod.LConst.shadowShieldFrames

    elseif itemNum == mod.LActives.ANARCHIST then
		sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)  
        for i=1,6 do
            mod:scheduleForUpdate(function()
                Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, game:GetRoom():GetRandomPosition(0), Vector.Zero, entity)
            end, i*5)
        end

    elseif itemNum == mod.LActives.BOOK_DEAD then
        
        sfx:Play(SoundEffect.SOUND_BONE_BREAK,1)

        for _,b in ipairs(Isaac.FindByType(EntityType.ENTITY_CLUTCH, 1)) do
            b:Remove()
        end

        for i=1, mod.LConst.nBones do
            local orbitDistance = 20
            local position = entity.Position + Vector(orbitDistance,0):Rotated(i/mod.LConst.nBones*360)
            local bone = Isaac.Spawn(EntityType.ENTITY_CLUTCH, 1, 0, position, Vector.Zero, entity):ToNPC()
            bone.Parent = entity

            local boneData = bone:GetData()
            boneData.orbitIndex = i
            boneData.orbitTotal = mod.LConst.nBones
            boneData.orbitDistance = orbitDistance
            boneData.orbitParent = true
            boneData.HeavensCall = true
            boneData.orbitSpin = -1
            boneData.orbitSpeed = 7

            bone.HitPoints = 60
            bone.CollisionDamage = 0

            bone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end

    elseif itemNum == mod.LActives.HORSE_PASTE then
        mod:LunaHeal(entity, mod.LConst.healPerGlue)

    elseif itemNum == mod.LActives.FIEND_FOLIO then
		sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)  

        local random = mod:RandomInt(1,3)

        local position = entity.Position + Vector(75, 0):Rotated(rng:RandomFloat()*360)
		for i=0, 100 do
			if (not mod:IsOutsideRoom(position, game:GetRoom())) then break end
			position = entity.Position + Vector(50, 0):Rotated(rng:RandomFloat()*360)
		end

        local boss 
        if random == 1 then
            boss = Isaac.Spawn(Isaac.GetEntityTypeByName("Monsoon"), Isaac.GetEntityVariantByName("Monsoon"), 0, position, Vector.Zero, entity)
        elseif random == 2 then
            boss = Isaac.Spawn(Isaac.GetEntityTypeByName("Battie"), Isaac.GetEntityVariantByName("Battie"), 0, position, Vector.Zero, entity)
        else
            boss = Isaac.Spawn(Isaac.GetEntityTypeByName("Buster"), Isaac.GetEntityVariantByName("Buster"), 0, position, Vector.Zero, entity)
        end

        boss:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)

        boss.MaxHitPoints = 150
        boss.HitPoints = 150

    elseif itemNum == mod.LActives.BOOK_REVELATIONS then
		sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)

        local room = game:GetRoom()
        local margen = -900

        for i=0, 2 do
            
            local delay = 0
            if i==0 then
                delay = 25
            elseif i==1 then
                delay = 90
            end

            mod:scheduleForUpdate(function()
                local position = Vector(margen*i, room:GetCenterPos().Y + mod:RandomInt(-150,150))
                position = room:GetCenterPos() - (position - room:GetCenterPos())

                if i==2 then
                    position = Vector(margen*i, room:GetCenterPos().Y + mod:RandomInt(-130,130))
                    position = room:GetCenterPos() - (position - room:GetCenterPos())
                    position = position + Vector(margen + 200, 0)
                end
    
                local horsemen = mod:SpawnEntity(mod.Entity.AltHorsemen, position, Vector.Zero, entity):ToNPC()
                horsemen.I1 = i
            end,delay)

        end
        
        local position = Vector(margen*2, room:GetCenterPos().Y + mod:RandomInt(-50,50))
        position = room:GetCenterPos() - (position - room:GetCenterPos())
        local i = -1
        local horsemen = mod:SpawnEntity(mod.Entity.AltHorsemen, Vector(position.X, position.Y + 150*i), Vector.Zero, entity):ToNPC()
        horsemen.I1 = i/2 + 7/2

    elseif itemNum == mod.LActives.KIDNYE_BEAN then

        local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, entity.Position, Vector.Zero, entity)
        fart:GetSprite().Color = Color(1,0,1,1,0.5,0.5,0.5,1)

        for i=1, 3 do
            local sirenRag = mod:SpawnEntity(mod.Entity.SirenRag, entity.Position, Vector.Zero, entity)
            sirenRag.Parent = entity
            mod:SirenRagSprite(sirenRag)

            sirenRag:GetData().Selfdestruct = 600
            sirenRag:GetData().MaxFrames = true
            sirenRag:GetData().NoPoof = true
        end

    elseif itemNum == mod.LActives.DARK_ARTS then
        data.ForceDark = true
    elseif itemNum == mod.LActives.ANIMA_SOLA then
        local anima = mod:SpawnEntity(mod.Entity.AnimaSola, game:GetRoom():GetCenterPos(), Vector.Zero, entity)
    elseif itemNum == mod.LActives.LEMON_MISHAP then
        sfx:Play(SoundEffect.SOUND_GASCAN_POUR)
        for i=1, 5 do
            mod:scheduleForUpdate(function()
                if not entity then return end
                local position = entity.Position + Vector(60*rng:RandomFloat(), 0):Rotated(360*rng:RandomFloat())
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CREEP_YELLOW, 0, position, Vector.Zero, entity):ToEffect()
                creep.Timeout = mod.LConst.lemonTime
                creep.SpriteScale = 2*Vector.One
            end, i*3)
        end
    end
end

--Count Fiend Folio summons
function mod:CountFiends()
    local n =  #Isaac.FindByType(Isaac.GetEntityTypeByName("Monsoon"), Isaac.GetEntityVariantByName("Monsoon")) + #Isaac.FindByType(Isaac.GetEntityTypeByName("Battie"), Isaac.GetEntityVariantByName("Battie")) + #Isaac.FindByType(Isaac.GetEntityTypeByName("Buster"), Isaac.GetEntityVariantByName("Buster"))
    return n
end

--Make tear fall after
function mod:TearFallAfter(projectile, frames)

    frames = math.floor(frames)

    projectile:AddProjectileFlags(ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
    projectile.ChangeFlags = ProjectileFlags.TRACTOR_BEAM
    projectile.ChangeTimeout = frames
    
    projectile.FallingSpeed = 0
    projectile.FallingAccel = -0.1

end
--Get vertial up/down wall postion
function mod:RandomUpDown(direction)

    local rotation = 0
    if not direction then
        direction = mod.RoomWalls.UP
        if rng:RandomFloat() < 0.5 then
            rotation = 180
            direction = mod.RoomWalls.DOWN
        end
    else
        if direction == mod.RoomWalls.DOWN then
            rotation = 180
        end
    end

    local room = game:GetRoom()
    local shape = room:GetRoomShape()
    local vertical = mod.BorderRoom[direction][shape]
    local position = Vector(mod:RandomInt(70+mod.BorderRoom[mod.RoomWalls.LEFT][shape],-70+mod.BorderRoom[mod.RoomWalls.RIGHT][shape]),vertical)
    return position, rotation
end
--Get random post
function mod:GetRandomPosition(originalPos, range, targetPos)
    if not targetPos then
        targetPos = originalPos
    end
    local room = game:GetRoom()

    local position = room:GetRandomPosition(0)
    if originalPos and range then
        for i=1, 100 do
            if position:Distance(originalPos) > range and position:Distance(targetPos) > range then break end
            position = room:GetRandomPosition(0)
        end
    end
    return position
end

--Projectile collision effects
function mod:LunaProjectile(tear,collided)
    tear = tear:ToProjectile()
	local data = tear:GetData()
    local sprite = tear:GetSprite()
	
    if data.LunaSaw then
        if tear.Parent then
            if data.LunaSacredSaw then
                tear.Parent.Position = tear.Position
                if tear.FrameCount >= 50 or mod:IsOutsideRoom(tear.Position, game:GetRoom()) then
                    data.LunaSacredSaw = false
                    tear.Parent.Velocity = tear.Velocity

                    local dir, cc = TaintedTreasure:GetOrientationFromVector(tear.Parent.Velocity)
                    TaintedTreasure:WallStickerInit(tear.Parent:ToTear(), dir, cc, GridCollisionClass.COLLISION_PIT, 6, true)
                end
            else
                tear.Position = tear.Parent.Position + tear:GetData().SawPosition
                data.Velocity = tear.Parent.Velocity
            end

            if data.LunaSawIpecac and tear.FrameCount%5==0 then
                local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, nil):ToEffect()
                gas.Timeout = mod.JConst.idleGasTime
                gas.SpriteScale = 0.75*Vector.One
            end

        else
            tear:Die()
        end
    end

    if data.LunaGodHead then
        mod:LunaGodHead(tear.Position, 80 * tear.SpriteScale.X/1.3)
    elseif data.LunaSacred then
        tear:GetSprite().Color = mod.Colors.white
    end

	--If tear collided then
	if tear:IsDead() or collided then
		
        --[[if data.LunaParasitoid then
            for i=1,3 do
                if rng:RandomFloat() < 0.5 then
                    local spider = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0, 0, tear.Position. Vector.Zero, nil)
                else
                    local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, tear.Position. Vector.Zero, nil)
                end
            end
        end]]

        if data.LunaParasite and not data.LunaBrust then
            for i=0,1 do
                local velocity = tear.Velocity:Rotated(90*(2*i-1))
                local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, velocity, nil):ToProjectile()
                tear2.Scale = tear.Scale*mod.LConst.incubusScale^2
            end

        elseif data.LunaParasite and data.LunaBrust then
            for i=0,1 do
                local velocity = tear.Velocity:Rotated(90*(2*i-1))
                local variance = (Vector(mod:RandomInt(-15, 15),mod:RandomInt(-15, 15))*0.03)
                local vector = (velocity*20)*0.028 + variance
                
                local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, vector, nil):ToProjectile();
                tear2.Scale = tear.Scale*mod.LConst.incubusScale*1.2
                tear2.FallingSpeed = -45;
                tear2.FallingAccel = 1.5;

                tear2:GetData().LunaBrust = true
                tear2:GetData().LunaProjectile = true
            end

        elseif data.LunaSawParasite and tear then
            for i=0,1 do
                local velocity = data.Velocity:Rotated(90*(2*i-1))
                saw2, tear2 = mod:SpawnSaw(tear, velocity, tear.Scale*mod.LConst.incubusScale, {})
            end

        elseif data.LunaBible then
		    game:SpawnParticles (tear.Position, EffectVariant.NAIL_PARTICLE, 9, 5, mod.Colors.wax)
            sfx:Play(Isaac.GetSoundIdByName("BookSlam"),2)
        end
        
        if data.LunaBrust then
            --Splash of projectiles:
            for i=0, mod.JConst.nCloudRingProjectiles do
                --Ring projectiles:
                local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, Vector(10,0):Rotated(i*360/mod.JConst.nCloudRingProjectiles)/2, tear):ToProjectile()
                if data.LunaGodHead then
                    tear2:Remove()
                    tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH, 0, tear.Position, Vector(10,0):Rotated(i*360/mod.JConst.nCloudRingProjectiles)/2, tear):ToProjectile()
                end
                tear2.Scale = tear.Scale*mod.LConst.incubusScale^2
                tear2.FallingSpeed = -0.1
                tear2.FallingAccel = 0.35 + rng:RandomFloat()*0.15
                tear2:GetSprite().Color = tear:GetSprite().Color

                if data.LunaGodHead then
                    local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear2.Position, tear2.Velocity, tear2):ToEffect()
                    aura.Parent = tear2
                    tear2.Child = aura
                    aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
                    aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
                    aura:GetSprite():LoadGraphics()
                    aura:GetSprite():Play("Idle", true)
                    aura.SpriteScale = aura.SpriteScale*0.5
                    aura:FollowParent(tear2)
                    tear2:Update()
    
                    tear2:GetData().LunaProjectile = true
                    tear2:GetData().LunaGodHead = true
                elseif data.LunaIpecac then
                    tear2:AddProjectileFlags(ProjectileFlags.EXPLODE)
                elseif data.LunaContinnum then
                    tear2:AddProjectileFlags(ProjectileFlags.CONTINUUM)
                end
            end
            for i=0, mod.JConst.nCloudRndProjectiles do
                --Random projectiles:
                local angle = mod:RandomInt(0, 360)

                local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, tear.Position, Vector(7,0):Rotated(angle)/2, tear.Parent):ToProjectile()
                if data.LunaGodHead then
                    tear2:Remove()
                    tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH, 0, tear.Position, Vector(7,0):Rotated(angle)/2, tear.Parent):ToProjectile()
                end
                tear2.Scale = tear.Scale*mod.LConst.incubusScale^2
                local randomFall = - rng:RandomFloat()*0.5
                tear2.FallingSpeed = randomFall
                tear2.FallingAccel = 0.3 + rng:RandomFloat()*0.1
                tear2:GetSprite().Color = tear:GetSprite().Color

                if data.LunaGodHead then
                    local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, tear2.Position, tear2.Velocity, tear2):ToEffect()
                    aura.Parent = tear2
                    tear2.Child = aura
                    aura:GetSprite():Load("gfx/1000.123_Halo (Static Prerendered).anm2", true)
                    aura:GetSprite():ReplaceSpritesheet(0, "gfx/effects/luna_god.png")
                    aura:GetSprite():LoadGraphics()
                    aura:GetSprite():Play("Idle", true)
                    aura.SpriteScale = aura.SpriteScale*0.5
                    aura:FollowParent(tear2)
                    tear2:Update()
    
                    tear2:GetData().LunaProjectile = true
                    tear2:GetData().LunaGodHead = true
                elseif data.LunaIpecac then
                    tear2:AddProjectileFlags(ProjectileFlags.EXPLODE)
                elseif data.LunaContinnum then
                    tear2:AddProjectileFlags(ProjectileFlags.CONTINUUM)
                end
            end
        end


		tear:Die()
	end
end

function mod:LunaBombs(bomb)
    local data = bomb:GetData()

    if data.LunaGodHead then
        mod:LunaGodHead(bomb.Position)
    elseif data.LunaSacred and bomb.Parent then
        bomb.Velocity = (bomb.Parent:ToNPC():GetPlayerTarget().Position - bomb.Position):Normalized()*4
    elseif data.LunaWorm then
        bomb.Velocity = bomb.Velocity/20 + bomb.Velocity:Rotated(math.sin(bomb.FrameCount)*20)*1.001
    end

    if bomb:GetSprite():IsPlaying("Explode") then
        if data.LunaIpecac then
            local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, bomb.Position, Vector.Zero, nil):ToEffect()
            gas.Timeout = mod.JConst.chargeGasTime
        elseif data.LunaParasite then
            for i=0,1 do
                local vector = bomb.Velocity:Normalized():Rotated(90*(2*i-1))*10
                local bomb2 = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_SMALL, 0, bomb.Position+5*vector, Vector.Zero, entity):ToBomb()
                bomb2:SetExplosionCountdown(10)
                bomb2.ExplosionDamage = 20
            end
        end
    end
end

function mod:LunaRings(ring)

    local data = ring:GetData()
    local sprite = ring:GetSprite()

    if data.LunaGodHead then
        mod:LunaGodHead(ring.Position)
    elseif data.LunaSacred then
        if ring.FrameCount < 30*3 and ring.Parent then
            ring.Velocity = (ring.Parent:ToNPC():GetPlayerTarget().Position - ring.Position):Normalized()*4
        end
    elseif data.LunaIpecac then
        if sprite:IsPlaying("Laser0Fade") and sprite:GetFrame()==1 then
            game:BombExplosionEffects (ring.Position, 100, TearFlags.TEAR_NORMAL, mod.Colors.boom, nil, 1, true, false, DamageFlag.DAMAGE_EXPLOSION )
        end
    elseif data.LunaParasite then
        if sprite:IsPlaying("Laser0Fade") and sprite:GetFrame()==1 then
            for i=0,1 do
                local velocity = ring.Velocity:Rotated(90*(2*i-1))
                local ring2 = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.THIN_RED, 2, ring.Position, velocity, nil):ToLaser()
                ring2.Parent = ring.Parent
                ring2.Radius = mod.LConst.xTechSize*0.75
                ring2.DepthOffset = 500
            end
        end
    end
end

function mod:LunaLasers(laser)
    local data = laser:GetData()

    if data.LunaGodHead then
        local position = laser:GetEndPoint()
        for i=0,20 do
            local point = (position-laser.Position):Normalized()*laser.LaserLength/20*i
            mod:LunaGodHead(point+laser.Position, 80, 2)
        end
    end
    
end

function mod:LunaGodHead(point, dist, suma)
    if not dist then dist = 80 end
    if not suma then suma = 3 end

    for i=0, game:GetNumPlayers ()-1 do
        local player = game:GetPlayer(i)
        local playerData = player:GetData()

        if player.Position:Distance(point) < dist+40 then
            if playerData.GodheadTime_HC then
                if playerData.GodheadIncrease_HC then
                    playerData.GodheadIncrease_HC = math.max(playerData.GodheadIncrease_HC,suma)
                else
                    playerData.GodheadIncrease_HC = suma
                end

                player:GetSprite().Color = Color.Lerp(player:GetSprite().Color, mod.Colors.white, 0.075)
            else
                playerData.GodheadTime_HC = 1
            end

            if playerData.GodheadTime_HC > 40 then
                playerData.GodheadTime_HC = 0

                local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, player.Position, Vector.Zero, nil)
            end
        end
    end
end

--Callbacks
--Luna updates
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.LunaUpdate, mod.EntityInf[mod.Entity.Luna].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.LunaDeath, mod.EntityInf[mod.Entity.Luna].ID)
--Luna flip update
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.LunaFlipUpdate, EntityType.ENTITY_DOGMA)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
	if entity.Type == mod.EntityInf[mod.Entity.Luna].ID and entity.Variant == mod.EntityInf[mod.Entity.Luna].VAR then
        local data = entity:GetData()
        local sprite = entity:GetSprite()

        --DAMAGE NULLIFICATION
        if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.MOM_FOOT_STOMP then
            return false
        elseif source.Type == EntityType.ENTITY_DOGMA and source.Variant == 10 then
            return false
        end

        --DAMAGE REDUCTION
        if flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION and source.Type == EntityType.ENTITY_BOMB and source.Entity and source.Entity.SpawnerEntity and source.Entity.SpawnerEntity.Type == mod.EntityInf[mod.Entity.Luna].ID  then
            entity:TakeDamage(math.floor(amount/10), flags - DamageFlag.DAMAGE_EXPLOSION, source, frames)
            return false

        elseif data.AssistP == mod.LAssistPassives.WAFER and (flags & DamageFlag.DAMAGE_INVINCIBLE == 0) then
            entity:TakeDamage(math.floor(amount/2), flags | DamageFlag.DAMAGE_INVINCIBLE, source, frames)
            return false

        elseif data.AssistP == mod.LAssistPassives.BOWL_TEARS and rng:RandomFloat() < mod.LConst.bowlChance then

            local position = game:GetRoom():GetRandomPosition(0)

            local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, position, Vector.Zero, entity):ToEffect()
            target:SetTimeout(15)
            target:GetSprite().Color = mod.Colors.white
            mod:scheduleForUpdate(function()
                local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, position, Vector.Zero, nil)
                light:GetSprite().PlaybackSpeed = 0.6
            end, 10)
        end

        --NO SHIELD
        if data.ShieldTime and data.ShieldTime <= 0 then

            --MANTLE
            if data.HasMantle then
                local mantle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 11, entity.Position, Vector.Zero, entity)
                mantle.DepthOffset =400
                mantle.SpriteScale = 1.5*Vector.One
                data.HasMantle = false

                sfx:Play(SoundEffect.SOUND_HOLY_MANTLE)

                return false
            end

            --SLEEPING
            data.SleepShield = data.SleepShield - amount
            if sprite:IsPlaying("Sleeping") and data.SleepShield <= 0 then
                data.SleepShield = 0
                sprite:Play("SleepEnd", true)
            end

        --SHIELD
        elseif data.ShieldTime then
            sfx:Play(SoundEffect.SOUND_BISHOP_HIT)
            return false
        end
	end
end)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
	if entity.Variant == 10 and entity.SubType == 160 then
        return false
    end
end, EntityType.ENTITY_DOGMA)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, tear, collider)
	if tear:GetData().LunaProjectile and collider.Type == EntityType.ENTITY_PLAYER then
		mod:LunaProjectile(tear,true)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, tear)
	if tear:GetData().LunaProjectile then
		mod:LunaProjectile(tear,false)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
    if bomb:GetData().LunaBomb then
        mod:LunaBombs(bomb)
    end
     
end, BombVariant.BOMB_NORMAL)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
    if bomb:GetData().LunaBomb then
        mod:LunaBombs(bomb)
    end
     
end, BombVariant.BOMB_POISON)

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
    local data = laser:GetData()
    if data.HeavensCall then
        if data.LunaRing then
            mod:LunaRings(laser)
        elseif data.LunaLaser then
            mod:LunaLasers(laser)
        elseif data.LunaMaw then
            mod:LunaMawUpdate(laser)
        end
    end
end)



--KUIPER BELT--------------------------------------------------------------------------------------------
--PLUTO--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*******************/&@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@(********************************%@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@/****************************************#@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@***********************************************/@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@(/////***********************************************&@@@@@@@@@@@
@@@@@@@@@@@@@///////******/*******************************************#@@@@@@@@@
@@@@@@@@@@@(**//*******///**********************************************@@@@@@@@
@@@@@@@@@@****************************************************************@@@%/(
@@@@@@@@%*********,,,,,,,,**********,,,,,,*********************************@(##&
@@@@@@@%*****,,,,,......,,,,,***,,,,,,....,,,,,,,,**************************#%%%
@@@@@@@//*(,,,..        ..,,,,,......     .. .../,,,************/***//*****//&&&
@@@@@@///*%&@@@@@@@@@*     .....              .&@@@@@@@@&&&*****//////*/*/*//#@@
@@@@@&//&&&@@@@@@@@@@@@@                    &@@@@@@@@@@@@&&&&(////////*/*/*//(@@
@@@@@((&&&&@@@@@@@@@@@@@@                  @@@@@@@@@@@@@@&&&&&////((///////(((@@
@@@@@((&&&&@@@@@@@@@@@@@@                 *@@@@@@@@@@@@@@&&&&&#((((((((((/((##@@
@@@@@##&&&&&@@@@@@@@@@@@@                 /@@@@@@@@@@@@@@&&&&&((#(((#(((((####@@
@@@@@&#&&&&&@@@@@@@@@@@@                  .@@@@@@@@@@@@@@&&&&&####(##((#((###%@@
@@@@@@%#&&&&@@@@@@@@@@(          %         *@@@@@@@@@@@@&&&&&#######%%%#%####%@@
@@@@@@&%#(&&&@@@@@@@.       @@@@@@       ....%@@@@@@@@@@&&&%#%%&%%%%%%%%%%%%%@@@
@@@@@@@%%###(//*,,..         %@@.      ....,**///#&&&@%%%%%@@@@@&&&%%%%%%%%%@@@@
@@@@@@@@@@@@#((///,,,..              ....**/(((##%%%%%%%%@@@@@@&&&&&%%%%%%%@@@@@
@@@@@@@@@@@@@&#&((((,#,...     &  ...,,,/(((##%%%%%%%%%%@@@@@@@&&&&&%%%%%%@@@@@@
@@@@@@@@@@@@@@@@@@%##@%,,...  .@ . ,**/(((%@%%%%%%&@@@@@@@@@@@@&&&&%%%%%%@@@@@@@
@@@@@@@@@@@@&%%%@@@@@@@%/**...#@#,**/((####@@&@@@@@@%%%%%%@@@@@&&##%###@@@@@@@@@
@@@@@@@@@@@@@@@%%&##%@@@@@@@@@@@@&@@@@@@@@@@@@@%###@%%%#%%%##%#######@@@@@@@@@@@
@@@@@@@@@@@@@@@@@%%###@@%%%#((#&@&&&%%%####@&######%%#############%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@############%%####%####@#############(##(((#@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@####(((###((########((((#######((#(#@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#((((((((((((((((((((((((%@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

mod.PMSState = {
	APPEAR = 0,
	IDLE = 1,
    ATTACK = 2,
    SNAP = 3,
}
mod.chainP = {
	[mod.PMSState.APPEAR] = 	{0,   1,   0,   0},
	[mod.PMSState.IDLE] = 	    {0,   0.5, 0.3, 0.2},
	--[mod.PMSState.IDLE] = 	{0,   0,   0,   1},
	[mod.PMSState.ATTACK] = 	{0,   1,   0,   0},
	[mod.PMSState.SNAP] = 	    {0,   1,   0,   0},
	
}
mod.PConst = {--Some constant variables of Pluto

	idleTimeInterval = Vector(20,30),
	speed = 1.3,
    distanceToleration = 150,

    projectileSpeed = 11,
    nBones = 5+1,
    boneAngle = 15,
}

function mod:PlutoUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR and entity.SubType == mod.EntityInf[mod.Entity.Pluto].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0 

            data.ObjectivePosition = room:GetCenterPos()

            data.FlagCharon = false
            data.FlagEris = false
            data.FlagMakemake = false
            data.FlagHaumea = false

            --data.FlagEris = true
            --data.FlagMakemake = true
            --data.FlagHaumea = true
		end
		
		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.PMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
                if mod.savedata.planetAlive then
                    mod.savedata.planetAlive1 = true
                    mod.savedata.planetKilled11 = false
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainP)
				data.StateFrame = 0

                --Tail spawn
                local parent = entity
                for i=1,mod.PConst.nBones do 
                    local bone = mod:SpawnEntity(mod.Entity.PlutoBone, entity.Position, Vector.Zero, entity):ToNPC()
                    bone:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    bone:GetSprite():Play("Normal", true)
                    bone.CollisionDamage = 0
                    bone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    parent.Child = bone
                    bone.Parent = parent
                    bone.I1 = i
                    bone:GetSprite().Offset = Vector(0,-math.max(0,math.min(2*(mod.PConst.nBones/2-i+1), 2)))
                    bone.DepthOffset = -10
                    
                    parent = bone

                    if i==mod.PConst.nBones then
                        bone:GetSprite():Play("Spike", true)
                        bone:GetSprite().Offset = Vector(0,-3)
                    end
                end
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			
		elseif data.State == mod.PMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainP)
				data.StateFrame = 0

                if rng:RandomFloat() < 0.3 then
                    data.ObjectivePosition = room:GetRandomPosition(0)
                end
				
			else
				mod:PlutoMove(entity, data, room, target)
			end
			
		elseif data.State == mod.PMSState.ATTACK then
			mod:PlutoAttack(entity, data, sprite, target, room)
			
		elseif data.State == mod.PMSState.SNAP then
			mod:PlutoSnap(entity, data, sprite, target, room)
		
		end


        local yourBattle = mod.savedata.planetNum == mod.Entity.Pluto
        if yourBattle and mod.savedata.planetAlive and (entity.FrameCount + 5) % 10 == 0 then
            if not data.FlagCharon and mod:KuiperHealtFraction() < 0.9 and (#mod:FindByTypeMod(mod.Entity.Charon1) + #mod:FindByTypeMod(mod.Entity.Charon2)) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Charon1, position, Vector.Zero, nil)
                data.FlagCharon = true
                planet:GetSprite():Play("AppearSlow", true)


            elseif not data.FlagEris and not mod.savedata.planetKilled12 and mod:KuiperHealtFraction() < 0.8 and #mod:FindByTypeMod(mod.Entity.Eris) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Eris, position, Vector.Zero, nil)
                data.FlagEris = true
                mod.savedata.planetHP2 = planet.HitPoints
                planet:GetSprite():Play("AppearSlow", true)

                mod.savedata.planetAlive2 = true

            elseif not data.FlagMakemake and not mod.savedata.planetKilled13 and mod:KuiperHealtFraction() < 0.8 and #mod:FindByTypeMod(mod.Entity.Makemake) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Makemake, position, Vector.Zero, nil)
                data.FlagMakemake = true
                mod.savedata.planetHP3 = planet.HitPoints
                planet:GetSprite():Play("AppearSlow", true)
                
                mod.savedata.planetAlive3 = true

            elseif not data.FlagHaumea and not mod.savedata.planetKilled14 and mod:KuiperHealtFraction() < 0.8 and #mod:FindByTypeMod(mod.Entity.Haumea) == 0 then
				local position = mod:GetRandomPosition(Isaac.GetPlayer(0).Position, 200)
				local planet = mod:SpawnEntity(mod.Entity.Haumea, position, Vector.Zero, nil)
                data.FlagHaumea = true
                mod.savedata.planetHP4 = planet.HitPoints
                planet:GetSprite():Play("AppearSlow", true)
                
                mod.savedata.planetAlive4 = true

            end

            if not data.FlagCharon and (#mod:FindByTypeMod(mod.Entity.Charon1) + #mod:FindByTypeMod(mod.Entity.Charon2)) > 0 then
                data.FlagCharon = true

            elseif not data.FlagEris and #mod:FindByTypeMod(mod.Entity.Eris) > 0 then
                data.FlagEris = true

            elseif not data.FlagMakemake and #mod:FindByTypeMod(mod.Entity.Makemake) > 0 then
                data.FlagMakemake = true

            elseif not data.FlagHaumea and #mod:FindByTypeMod(mod.Entity.Haumea) > 0 then
                data.FlagHaumea = true

            end

        end

	end
end
function mod:PlutoAttack(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Attack",true)
    elseif sprite:IsFinished("Attack") then
        data.State = mod:MarkovTransition(data.State, mod.chainP)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 1.25)

        local velocity = (target.Position - entity.Position):Normalized():Rotated(mod:RandomInt(-mod.PConst.boneAngle,mod.PConst.boneAngle))*mod.PConst.projectileSpeed
        local bone = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_BONE, 0, entity.Position, velocity, entity):ToProjectile()
    end
end
function mod:PlutoSnap(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        
        local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
        if charon and charon:GetData().Anchored then
            data.State = mod:MarkovTransition(data.State, mod.chainP)
            data.StateFrame = 0
        else
            data.TargetPosition = target.Position
            sprite:Play("Snap",true)
        end
    elseif sprite:IsFinished("Snap") then
        data.State = mod:MarkovTransition(data.State, mod.chainP)
        data.StateFrame = 0

        local spike = entity.Child
        for i=1,mod.PConst.nBones-1 do
            spike = spike.Child
        end
        spike.Velocity = (target.Position - entity.Position):Normalized() * 20
        spike:GetData().Launch = false
        spike.CollisionDamage = 0
        spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_WHIP, 1.25)

        local spike = entity.Child
        for i=1,mod.PConst.nBones-1 do
            spike = spike.Child
        end

        local charon = mod:FindByTypeMod(mod.Entity.Charon2)[1]
        if charon then
            spike.Velocity = (charon.Position - spike.Position):Normalized() * 20
            spike:GetData().Launch = true
            spike.CollisionDamage = 1
            spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        else
            spike.Velocity = (data.TargetPosition - entity.Position):Normalized() * 20
            spike:GetData().Launch = true
            spike.CollisionDamage = 1
            spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end
    end
end


--Move
function mod:PlutoMove(entity, data, room, target)

    local objectibe = data.ObjectivePosition

	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.PConst.idleTimeInterval.X, mod.PConst.idleTimeInterval.Y)
		--distance of Saturn from the center of the room
		local distance = 0.95*(objectibe.X-entity.Position.X)^2 + 2*(objectibe.Y-entity.Position.Y)^2
		
		--If its too far away, return to the center
		if distance > mod.PConst.distanceToleration then
			data.targetvelocity = ((objectibe - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		--Else, get closer to the player
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
	entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.PConst.speed
	data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:PlutoDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Pluto].VAR then

        mod.savedata.planetAlive1 = false
        mod.savedata.planetKilled11 = true
        local allDead = (mod.savedata.planetKilled11 and mod.savedata.planetKilled12 and mod.savedata.planetKilled13 and mod.savedata.planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, false, false)
        else
            mod:SpawnGlassFracture(entity, 1.5)
            game:BombExplosionEffects (entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
            sfx:Play(Isaac.GetSoundIdByName("SuperExplosion"),0.6)
            game:ShakeScreen(60)
        end

    end
end
--deding
function mod:PlutoDying(entity)
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.deathFrame == nil then data.deathFrame = 1 end

    if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
        if data.deathFrame == 2 then

        end
	end

end

--Tail
function mod:TailUpdate(entity)--This is such a convoluted way to create a chain
    if entity.Parent then
        local sprite = entity:GetSprite()

        if sprite:GetAnimation() == "Spike" then
            local data = entity:GetData()

            sprite.Rotation = ( - entity.Parent.Position + entity.Position):GetAngleDegrees()

            if data.Launch then
                sprite.Rotation = entity.Velocity:GetAngleDegrees()

                if entity:CollidesWithGrid() then
                    data.Launch = false
                    entity.CollisionDamage = 0
                    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                end 

                return
            end
        end

        mod:FamiliarParentMovement(entity, 2, 1.5, 15)

        local child = entity.Child
        if child then

            local spike = child
            for i=entity.I1+1,mod.PConst.nBones-1 do
                spike = spike.Child
            end

            if spike and spike:GetData().Launch then

                local parent = entity.Parent
                entity.Parent = child
                mod:FamiliarParentMovement(entity, 10, 2, 10)
                entity.Parent = parent

            end
        end
    else
        entity:Remove()
    end
end

--Kuiper health
function mod:KuiperHealtFraction()
    local p = mod:FindByTypeMod(mod.Entity.Pluto)
    local e = mod:FindByTypeMod(mod.Entity.Eris)
    local m = mod:FindByTypeMod(mod.Entity.Makemake)
    local h = mod:FindByTypeMod(mod.Entity.Haumea)

    local maxHp = 0
    local currentHp = 0

    for _, entity in ipairs(p) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end
    for _, entity in ipairs(e) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end
    for _, entity in ipairs(m) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end
    for _, entity in ipairs(h) do
        maxHp = maxHp + entity.MaxHitPoints
        currentHp = currentHp + entity.HitPoints
    end

    if currentHp == 0 then
        return 0
    end

    return currentHp / maxHp
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.PlutoUpdate, mod.EntityInf[mod.Entity.Pluto].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.PlutoDeath, mod.EntityInf[mod.Entity.Pluto].ID)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
    if entity.Variant == mod.EntityInf[mod.Entity.PlutoBone].VAR and entity.SubType == mod.EntityInf[mod.Entity.PlutoBone].SUB then
        mod:TailUpdate(entity)
    end
end, mod.EntityInf[mod.Entity.PlutoBone].ID)
--CHARON--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%##%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%#####%%%###########&#####%@@&@@@@@@@@@@@@@@@@&@@@
@@@@@@@@@@@@@@@@@@@@@@@%########%%%###############@@%########%@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&########%#####################@@@%###((####(#@@@@@@@@@@@@@@@
@@@@@@@@&@@@@@@@@######%%#############%&@@@@@@@@@@@@@@@@@%###((((((#@@@@@@@@@@@@
@@@@@@@@@@@@@@&%#################################(#@@@@@@@@@@@@&((////@@@@@@@@@@
@@@@@@@@@@@@&%%%%#############################((((((&@@#((((((((#%&&(///@@@@@@@@
@@@@@@@@@@@%%%#############%###############((((((((((@@&((((((((///////((%@@@@@@
@@@@@@@@@@%###############%#################((((((((((@@(((((////////((((((@@@@@
@@@@@@@@@##################%#######@####((((((((((((((&@(((////////(((((((((@@@@
@@@@@@@@%%#################&######%&((#((((((((((((((((@#(//(////((((((((((((@@@
@@@@@@@%####%##############@#####(@@#%((((((((((((((((((((((((((((((((((&@&&&&@@
@@@@@@&#########%#%########@@@#(#@@@%(((((((((#@@@@@%((((((((((@#((#&@@@@@@&&%@@
@@@@@@#############&##%####@@@@@@@@@@@&((///(((@@(((((((/((((((&@@@@@#////(/(/&@
@@@@@@###############&@@@@&%&@@@@@@@@@@((////(((((((&%#((((((@@@@%@@//////((//%@
@@@@@@############((((%%%%&&&@@@@@@@@@@&((((((((((((///%@@@@@@@/(#//@(//((///*%@
@@@@@@%(((((((((((((#(%%&&&@@@@@@@@@@@@#((((((((((////#&#@@@@@(//////(//(/////@@
@@@@@@@(////(((######%%%%&&&&&@@@@@@@@@@&((((//////////@@@&///(@@////////(////@@
@@@@@@@(//##%%&%##%%%%%%%&&&&@@@@@@@@@@@@(#&&((#&&%%#%@@@/////////%(/((((///*@@@
@@@@@@@@(###%%//(####&&(((&&&@@@@@@@@@@@(((/////////@@@&&@@%//////////((((((%@@@
/(((#####%%%%%%%%%%&&&(((#&#((&%&@@(((##((/////////&@@&(////////(((((((((((%@@@@
%%#######%%&&&&&&&%(((((((((((((((#%////#///#/////(@@(///////((((((((((((#@@@@@@
@@####%&&@@@((((///((((////(((//////(//////**/(%@@@@@@((/((((((((((((((##@@@@@@@
&%%%%&&@@@@@@%**////////////////******/***///////#@@@&(((((((((((((((##@@@@@@@@@
&&&&@@@@@@@@@@@%******,,****,,,,,,,,,,***********////((((((((((((####@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@*,,,,,,,,,,,,,,,,,,***********///((((((((((((((#&@@@@@@@@@@@@@
@@@@@@@@@@@@&@@@@@@@@/,,,,,,,,,,,,,,,*********///(((((((((((###&@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@(,,,,******/////////((((((((######&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@&(*****/////((((((((###&@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
function mod:CharonUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Charon1].VAR and entity.SubType == mod.EntityInf[mod.Entity.Charon1].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0

		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == 0 then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova") or music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova_loop") then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = 1
				data.StateFrame = 0

			elseif sprite:IsEventTriggered("EndAppear") then
                local charon = mod:SpawnEntity(mod.Entity.Charon2, entity.Position, Vector.Zero, entity)
                charon:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                entity:Remove()
			end

		end
	end
end

function mod:Charon2Update(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Charon2].VAR and entity.SubType == mod.EntityInf[mod.Entity.Charon2].SUB then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        local data = entity:GetData()

        if not data.Init then
            entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
            data.Init = true

            data.Anchored = false

            for _, b in ipairs(mod:FindByTypeMod(mod.Entity.PlutoBone)) do
                if b:GetSprite():GetAnimation()=="Spike" then
                    entity.Parent = b
                    break
                end
            end

        end

        if entity.Parent then

            local spikeData = entity.Parent:GetData()
            if spikeData.Launch then
                if entity.Parent.Position:Distance(entity.Position) < 20 then
                    data.Anchored = true
                end
            end

            if data.Anchored then
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                mod:FamiliarParentMovement(entity, 2, 1.5, 20)
                --entity.Position = entity.Parent.Position

                if rng:RandomFloat() < 0.002 then
                    data.Anchored = false
                end
            end
        end

    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CharonUpdate, mod.EntityInf[mod.Entity.Charon1].ID)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.Charon2Update, mod.EntityInf[mod.Entity.Charon2].ID)
--ERIS--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#.*@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. .***@
@@@@@@@@@@@@@@@@@@@@/,,,,,,,************(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. .***@@
@@@@@@@@@@@@@@@%**,,,,,,,,*******************%@@@@@@@@@@@@@@@@@@@@@@@@@. .***@@@
@@@@@@@@@@@@(/*********,,,*********,************#@@@@@@@@@@@@@@@@@@@@@, .***@@@@
@@@@@@@@@@//////***(**,,,,,,**#&*,,,,,,,***********@@@@@@@@@@@@@@@@@@, .**(@@@@@
@@@@@@@@///%**//*******&*%&*,,,,,,...,&,,,,(*,,,*,***@@@@@@@@@@@@@@@, .**#@@@@@@
@@@@@@&/(&*#*********&#*,,#/,,,,,,...,,.,@%.&,&/*%/,,*@@@@@@@@@@@@@, .**%@@@@@@@
@@@@@#(/&%*@******&****,,,,*,&,.......@..@/@.&,((,,(*,*%@@@@@@@@@@* .**@@@@@@@@@
@@@@@(*****,*,,,**********,***,,,,,,.#.......,@&%,,*#,**& .(##/***..**@@@@@@@@@@
@@@@*#%%%%%&&&#,****************,**,,,*%&%%%#,,,&******####(@@@#(((**@@@@@@@@@@@
@@@@/%%%%%&&&&&&&/******///******&&&&&&&&%%%%%%*&*****###(@@@@@*.#(*@@@@@@@@@@@@
@@@%,%%%%&&&&&&&&&&/**////////&&&&&&&&&&&&%%%%%**/*/*.(#(%###(((((*%(@@@@@@@@@@@
@@@@../%%&&&&&&&&&&&&***////&&&&&&&&&&&&&&%%%%//////,.##/@@@@@#####%(/@&%%@@@@@@
@@@@.....%&&&&&&&&&&&*/*///#&&&&&&&&&&&&&%%%////////.##(/@@@@@@@@@@@@*%(@@@@@&@@
@@@@&,@.......(&&(,,,,*****/#&&&&&&&&&&%////////////,##(@@@@@@@@@@@@@(@@@@@@@@@@
@@@@@/&...........,,,,,,*****////////////////@////%//(##@@@###(%@@@@%(@@@@@@@@@@
@@@@@@#.............,,,,,,*****/*///*////////@/%//&//..,#@@@@@@@@@@@,/@@@@@@@@@@
@@@@@@@@.&,&*...../&&&&&&&&#***********#(////&///////@..*((@@@@@@@&(*@@@@@@@@@@@
@@@@@@@@@@..(.....(&&&&&&&&&&&*******(&***(//&/////@@@@@.(((((%#(*./@@@@@@@@@@@@
@@@@@@@@@@@@*...........,.,,,,,,,*,,,,&,,**/&///(@@@@@@@@@(./.,(,/@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@/...........,,,,,,,,,,,,,*/***#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&,.....,,,.,,,.,,,,,**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
mod.EMSState = {
	APPEAR = 0,
	IDLE = 1,
    CHARGE = 2,
}
mod.chainE = {
	[mod.EMSState.APPEAR] = 	{0,   1,   0},
	[mod.EMSState.IDLE] = 	    {0,   0.9, 0.1},
	--[mod.EMSState.IDLE] = 	{0,   0,   1},
	[mod.EMSState.CHARGE] = 	{0,   1,   0},
	
}
mod.EConst = {--Some constant variables of Eris

	idleTime = 2,
	speed = 1.35,
    distanceToleration = 15,

    chargeSpeed = 50,

}

function mod:ErisUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR and entity.SubType == mod.EntityInf[mod.Entity.Eris].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.EMSState.APPEAR then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova") or music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova_loop") then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainE)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			elseif sprite:IsEventTriggered("SpawnSword") then
                local naue = mod:SpawnEntity(mod.Entity.ErisNaue, entity.Position, Vector.Zero, entity):ToEffect()
                naue.DepthOffset = -5
                naue:FollowParent(entity)
                naue.Parent = entity
                entity.Child = naue
            elseif sprite:IsEventTriggered("Sound") then
                sfx:Play(Isaac.GetSoundIdByName("DrawSword"), 1)
            end
			
		elseif data.State == mod.EMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainE)
				data.StateFrame = 0
				
			else
				mod:ErisMove(entity, data, room, target)
			end
			
		elseif data.State == mod.EMSState.CHARGE then
			mod:ErisCharge(entity, data, sprite, target, room)
		end

        if entity.Child and not sprite:IsPlaying("Spin") and not sprite:IsPlaying("Prepare") then
            local naue = entity.Child
            local naueSprite = naue:GetSprite()
            local amount = 0.1
            if sprite:IsPlaying("Attack") then amount = 0.5 end
            naueSprite.Rotation = mod:AngleLerp(naueSprite.Rotation, (-entity.Velocity):GetAngleDegrees(), amount)

            if naueSprite:IsFinished("Spin") then
                naueSprite:Play("Idle", true)

            end
        end
	end
end
function mod:ErisCharge(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        entity.Velocity = Vector.Zero
        sprite:Play("Prepare",true)
        data.TargetPos = target.Position
        mod:FaceTarget(entity, target)
        
        sfx:Play(Isaac.GetSoundIdByName("Shine"), 1)


        local direction = (data.TargetPos - entity.Position)
        local angulo = direction:GetAngleDegrees()

        local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position, Vector.Zero, entity):ToEffect()

        tracer:FollowParent(entity)
        tracer.LifeSpan = 25
        tracer.Timeout = tracer.LifeSpan
        tracer.TargetPosition = Vector(1, 0):Rotated(angulo)

    elseif sprite:IsFinished("Prepare") then
        sprite:Play("Attack",true)
        entity.Velocity = (data.TargetPos - entity.Position):Normalized()*mod.EConst.chargeSpeed
        mod:FaceTarget(entity, target)
        data.Charged = true
        
        sfx:Play(SoundEffect.SOUND_MOTHER_CHARGE1, 1.5, 2, false, 3)

    elseif sprite:IsFinished("Attack") or (entity:CollidesWithGrid() and data.Charged) then
        data.Charged = false
        entity.Velocity = Vector.Zero
        sprite:Play("Spin",true)

        --Spin sword
        if entity.Child then
            local naue = entity.Child
            --naue:GetSprite().Rotation = 0
            naue:GetSprite():Play("Spin", true)
        end
        
        sfx:Play(SoundEffect.SOUND_SWORD_SPIN, 1.5)

    elseif sprite:IsFinished("Spin") then
        data.State = mod:MarkovTransition(data.State, mod.chainE)
        data.StateFrame = 0
    end
end


--Move
function mod:ErisMove(entity, data, room, target)
	mod:FaceTarget(entity, target)
    --idle move taken from 'Alt Death' by hippocrunchy
    --It just basically stays around a something
    
    --idleTime == frames moving in the same direction
    if not data.idleTime then 
        data.idleTime = mod.EConst.idleTime

        local localAntipode = (target.Position - room:GetCenterPos()):Rotated(180)
        local antipode = localAntipode + room:GetCenterPos()
        if localAntipode:Length() < 100 then
            antipode = localAntipode:Normalized()*100 + room:GetCenterPos()
        end
        -- distance of Eris from the oposite place of the player
        local distance = antipode:Distance(entity.Position)
        
        --If its too far away, return to the center
        if distance > mod.EConst.distanceToleration then
            data.targetvelocity = ((antipode - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
        end

    end

    --Not that close to the plater
    if target.Position:Distance(entity.Position) < 100  or data.targetvelocity == nil then
        data.targetvelocity = (-(target.Position - entity.Position):Normalized()*6):Rotated(mod:RandomInt(-45, 45))
    end
    
    --If run out of idle time
    if data.idleTime <= 0 and data.idleTime ~= nil then
        data.idleTime = nil
    else
        data.idleTime = data.idleTime - 1
    end
    
    --Do the actual movement
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.EConst.speed
    data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:ErisDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Eris].VAR then
        
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 10, 6, Color(0.8,0.8,1,1))
        
        mod.savedata.planetAlive2 = false
        mod.savedata.planetKilled12 = true
        local allDead = (mod.savedata.planetKilled11 and mod.savedata.planetKilled12 and mod.savedata.planetKilled13 and mod.savedata.planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, false, false)
        else
            mod:SpawnGlassFracture(entity, 1.5)
            game:BombExplosionEffects (entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
            sfx:Play(Isaac.GetSoundIdByName("SuperExplosion"),0.6)
            game:ShakeScreen(60)
        end

    end
end
--deding
function mod:ErisDying(entity)
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.deathFrame == nil then data.deathFrame = 1 end

    if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
        if data.deathFrame == 2 then

        end
	end

end

--Angle lerp
function mod:AngleLerp(angle1, angle2, amount)
    local v1 = Vector.FromAngle(angle1)
    local v2 = Vector.FromAngle(angle2)

    return mod:Lerp(v1, v2, amount):GetAngleDegrees()
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ErisUpdate, mod.EntityInf[mod.Entity.Eris].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ErisDeath, mod.EntityInf[mod.Entity.Eris].ID)

--MAKEMAKE--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@##@@
#@@@@@@@@@@@@@@@@@@@@@@@/@@@%%((((((((((((((((((((((%%@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@%@@@@@@@@@@@@@@&#(((((((((((((((((((((((((((((((((((//////(@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@%####((((((((((((((((((((((((((((((((((((((((//////////@@@@@@@@@@@@
@@@@@@@@@########((((((((((((((((((((((((((((((((((((////////////////@@@@@@@@@@@
@@@@@@@#############(((((((((((((((((((((((((((((/////////////////////@@@@@@@@@@
@@@@@@#############################(#((((((((((((((///////////////////#@@@@@@@@@
@@@@@@###################################((((((((((((((((//////////////@@@@@@@@@
@@@@@@###############################((((((((((/////////((//////////////@@@@@@@@
@@@@@@################################((((((((((((((((((((((((//////////(@@@@@@@
@@@@@@%##############################((((((%&&&&&&&&&&&&&&&&%%(((((((/////@@@@@@
@@@@@@@###%%%%%&&&&&&&&&&#############(((#&&&&&&&&&&&&&&&&&&%%(((((((//////@@@@@
@@@@@@####%%&&&&&&&&&&&&&#############(###&&&&&&&&&&&&&&&&&&%%((((((((//////@@@@
@@@@@#####%&&&&&&&&&&&&&##################(&&&&&&&&&&&&&&&&&#(((((((((((/////@@@
@@@@&############&&&##%%##################(((###&&%##(((((((((((((((((((/////(@@
@@@@#################%%%##########################(((((((((((((((((((((((/////@@
@@@@##############%%%#############################((((((((((((((((((((((((////@@
@@@@############%%%%#######################%%(####(#####(((#######(#((((((///(@@
@@@@############%%%%######################%%%(((((#######(###########((((((/((@@
@@@@###########%%%%%######################%%%((###################(#((((((/(((@@
@@@@@##########%%%%#######################%%%#((#################((((((((((((&@@
@@@@@%#########%%%%######################%%%%%(((#(#############(((((((((((((@@@
@@@@@@#########%%%%######################%%%%%##(###(###############((((((((@@@@
@@@@@@@########%%%%%##################%%%%%%%%######################(((((((@@@@@
@@@@@@@@@######%%%%%%###########%%%%%%%%%%%%%%################((((###((((#@@@@@@
@@@@@@@@@@######%%%%%%%%###%%%%%%%%%%%%%%%%%%###########################@@@@@@@@
@@@@@@@@@@@@#######%%%%%%%%%%%%((((###################################@@@@@@@@@@
@@@@@@@@@@@@@@######################################################@@@@@@@@@@@@
@@@@@@@@@@@@@@@@#############%%##################################@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@#####(#(((((((#############################@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@((((((((((########################@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&((##################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--

function mod:MakemakeUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR and entity.SubType == mod.EntityInf[mod.Entity.Makemake].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0
            
            data.Direction = Vector(1,0):Rotated(360*rng:RandomFloat())
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == 0 then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova") or music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova_loop") then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = 1
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			
		elseif data.State == 1 then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			else
				mod:MakemakeMove(entity, data, room)
			end

		end

	end
end

function mod:MakemakeMove(entity, data, room)
    entity.Velocity = data.Direction * 3.5

    if entity:CollidesWithGrid() then
        sfx:Play(Isaac.GetSoundIdByName("LightHit"), 1)
        mod:scheduleForUpdate(function()
            data.Direction = entity.Velocity:Normalized()
        end, 2)
    end
end
--ded
function mod:MakemakeDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Makemake].VAR then
        
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 10, 6)

        mod.savedata.planetAlive3 = false
        mod.savedata.planetKilled13 = true
        local allDead = (mod.savedata.planetKilled11 and mod.savedata.planetKilled12 and mod.savedata.planetKilled13 and mod.savedata.planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, false, false)
        else
            mod:SpawnGlassFracture(entity, 1.5)
            game:BombExplosionEffects (entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
            sfx:Play(Isaac.GetSoundIdByName("SuperExplosion"),0.6)
            game:ShakeScreen(60)
        end

    end
end
--deding
function mod:MakemakeDying(entity)
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.deathFrame == nil then data.deathFrame = 1 end

    if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
        if data.deathFrame == 2 then

        end
	end

end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MakemakeUpdate, mod.EntityInf[mod.Entity.Makemake].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.MakemakeDeath, mod.EntityInf[mod.Entity.Makemake].ID)

--HAUMEA--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@&(@@*@@@@**@@@#**@@@*&@@**@@@@#@@@@@@@@@@@#@@@@@@@@@@@
@@@@@@/@@@@@@*@@@@@@@@%*@@@**@@*@@@@**@@@**@@@@@@@@@@#@@@@&/*********/@@@@@@@@@@
@@@@@@/*@@@@@@*@@@@@@@@**@@@**@**@@@@*&@@@@@&@@@@@@@@@/////////////********@@@@@
@@@@@@@**@@@%***@@@@****/@@@@@/**@@@@@@@@@@@@@@@@@@@///////////////***********@@
@@@@@@@@*#@@@@@@*@@@***@@@@@@@(@@@@@@@@@@@@@@@@@@@//////////((//(//////****@&@@@
@@@@@@@#@*%@@@@@@*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/**//////((##@####((((@(/#@@@@@
@@@@@@@@@@*@@@@@#@&@@@@@@@@@&@@@@@@@@@@@&@@@@@@@////////(###@%@. ###%@@@&@&@@@@@
@@@@@@@@@@@*@@@@@@@@@@@@@@@@@@@@@@*********,,,,*/@/////               #@@@&@@@@@
@@@@@@@@@@&@@@@@@@@&@@@@@@@/////************//*,     /                  *@@@@@@@
@@@&@@@@@@@@@@@@@@@@@@@////////////////////((          ,                ..  #@@@
@@@@%@@@@@@@@@@@@@@@*****//////////////(((###%%( ,..,**,,,,,,      @@@ ....   @@
@@@@@@@@@@@@@@@@@@*******//////////////((####%%%%%,,,*,*,,,,.,     @@@@ ..... @@
@@@@@@@@@@@@@@@&********//////////***///((#%%%##.,,,,,,,,,,,,,,      @@@.... @@@
@@@&@@@@@@@@@@@*******//////////******//((#%%%%####%#,,,,*,,,,,      @@@....@@@@
@@@@&@@@@@@@@@******////////////*****///((#%%%%#%%,,,,,,,,,,,,.      @@....@@@@@
@@@@@@@@@@@@@&*****////////////////*///((##%%%%%%#,,,,,,,,,,,          ... @@@@@
@@@@@@@@@@@...****/////////////////////((####%%%###*,,,,,,.          ...  @@@@@@
@@@@@@@@@...../////////(((((////////////((((#######(.              .... @@@@@@@@
@@@#@@@@.,,,,,*///////((((((((((//////////////((((///***     ((   .....@@@#@@@@@
@@@@@@,,,,,,,,,,///////((((((((//////////////***********  @@@@   ....(%@@@@@@@@@
@@@@@..,,,,,,,,@@(//////////////*/////////////////*****@@@@@@ ......#@@@@@@@@@@@
@@@@...,,,,,,,*@@@@@////////////***********/////////@&@@@#, .......@@@@@@@@@@@@@
@@@....,,,,,,@@@#@@@@@@@/******************////@@@@@&@@   ......@@@@@@#@@@@@@@@@
@@@ ....,,,@@@@@@&@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@(  .......  @@@@@@@@@@@@@&@&@@
@@@ .......@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@(%................@@@@@@@@@@@@@@@@@@@@
@@@. .........,.,.,,,,,.........&@@@@...................@@@@@@@@@@@@@@@@@@@@@@@@
@@@   ........,,,,,,,,,,,,,,,,..........,,,,,,,,,.....*@@@&@@#@@@@@@@@@@@@@@@@@@
@@@@.  .......,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,,....@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@*  ......,,,,,,,,,,,,,,,,,,,,,,...*@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,....@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&....&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--
mod.HMSState = {
	APPEAR = 0,
	IDLE = 1,
    JUMP = 2,
}
mod.chainH = {
	[mod.HMSState.APPEAR] = 	{0,   1,   0},
	[mod.HMSState.IDLE] = 	    {0,   0.75, 0.25},
	--[mod.HMSState.IDLE] = 	{0,   0,   1},
	[mod.HMSState.JUMP] = 	    {0,   1,   0},
	
}

function mod:HaumeaUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR and entity.SubType == mod.EntityInf[mod.Entity.Haumea].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.HMSState.APPEAR then
			if data.StateFrame == 1 then
                if music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova") or music:GetCurrentMusicID() == Isaac.GetMusicIdByName("Supernova_loop") then
                    mod:AppearPlanet(entity, true)
                else
                    mod:AppearPlanet(entity)
                end
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod:MarkovTransition(data.State, mod.chainH)
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			
		elseif data.State == mod.HMSState.IDLE then
			if data.StateFrame == 1 then
				sprite:Play("Idle",true)
			elseif sprite:IsFinished("Idle") then
				data.State = mod:MarkovTransition(data.State, mod.chainH)
				data.StateFrame = 0
			end
			
		elseif data.State == mod.HMSState.JUMP then
			mod:HaumeaJump(entity, data, sprite, target, room)
		end

        entity.Velocity = Vector.Zero
	end
end
function mod:HaumeaJump(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Jump",true)
    elseif sprite:IsFinished("Jump") then
        entity.Position = data.TargetPos
        sprite:Play("Land",true)
        entity.Visible = true
    elseif sprite:IsFinished("Land") then
        data.State = mod:MarkovTransition(data.State, mod.chainH)
        data.StateFrame = 0

    elseif sprite:IsEventTriggered("Out") then
        entity.Visible = false
    elseif sprite:IsEventTriggered("Jump") then
        sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1)

        data.TargetPos = target.Position
        local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, data.TargetPos, Vector.Zero, entity):ToEffect()
        target:SetTimeout(45)

        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    elseif sprite:IsEventTriggered("Land") then
        sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE, 1)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        for i=1,mod.NConst.nSplash do
            local waterParams = ProjectileParams()
            waterParams.Variant = ProjectileVariant.PROJECTILE_NORMAL
            waterParams.FallingAccelModifier = 2.5
            local angle = i*360/mod.NConst.nSplash
            entity:FireBossProjectiles (3, entity.Position + Vector(1,0):Rotated(angle), 0, waterParams)
        end
    end
end

--ded
function mod:HaumeaDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Haumea].VAR then
        
		--Particles
		game:SpawnParticles (entity.Position, EffectVariant.BLOOD_PARTICLE, 10, 6)
		local bloody = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, entity)
        
        mod.savedata.planetAlive4 = false
        mod.savedata.planetKilled14 = true
        local allDead = (mod.savedata.planetKilled11 and mod.savedata.planetKilled12 and mod.savedata.planetKilled13 and mod.savedata.planetKilled14)
        local luna = mod:FindByTypeMod(mod.Entity.Luna)[1]
        if allDead and (entity:GetData().LunaSummon ~= true) and not luna then
            mod:NormalDeath(entity, false, false)
        else
            mod:SpawnGlassFracture(entity, 1.5)
            game:BombExplosionEffects (entity.Position, 100, TearFlags.TEAR_NORMAL, Color.Default, nil, 1.45, true, false, DamageFlag.DAMAGE_EXPLOSION )
            sfx:Play(Isaac.GetSoundIdByName("SuperExplosion"),0.6)
            game:ShakeScreen(60)
        end

    end
end
--deding
function mod:HaumeaDying(entity)
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.deathFrame == nil then data.deathFrame = 1 end

    if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
        if data.deathFrame == 2 then

        end
	end

end


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.HaumeaUpdate, mod.EntityInf[mod.Entity.Haumea].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.HaumeaDeath, mod.EntityInf[mod.Entity.Haumea].ID)

--HERRANT--------------------------------------------------------------------------------------------------
--[[
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&%&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%%############%%##%%%&@@@ ,@@@@@@@@@@@@@@@@@ @@@@@
@@@@@@@@@@@@@@@@@@@@@&&&&%#############(###(((((((######%%%%&@@@@@ @@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@&%%&###/(////(((((######(((((((/((((((((((###%@@@@@@@@@@@@.@@@@
@@@@@@@@@@@@@@%###(((/%///////////////%(/((((((/////((((((((((###%&@@@@@@@@@@@@@
@@@@@@@@@@@&%#//*******##,***********/%////////((((((%((((####((((#%@@@@@@@@@@@@
@@@@@@@@@%%#((/**********##(*****////%%////((((###&%%###(((((((//////(#%@@@@@@@@
@@@@@@@&%%#(,***,,,*****##(*****//**/##///%((//(##((((((((///////*#///((#@@@@@@@
@@@@@@&%#((///**,,,,,,##,*,***,,####/*****#//%%/(//(((((((((///#%///*///(%@@@@@@
@@@@@@&%##((/////****//%#****/,,,(,###/**#*///#//((/(#(((((((%%(//////((((%&@@@@
@@@@@(((((((((((//(/%///(##/*/###*******##///%/////%((((((%%((((((#(#((//(%&@@@@
@@@&%##(%((/////////%///**####**********///%%////#(/////%%(////////(/////(#%%@@@
@@@#((///*#******/*/##****#*****,,,**,,,**,,*(###****###**********///////((((#@@
@&(((//*****#,,,,,,**,((#,,,,,,,,#((,,,.,,,,..,,((,((,,.......,,*,,,,,**//(*(#%@
@@%(///**,,,*,####/**##,,,,((,...,....,,(/,,,,,,,.((,.,.,/(...,*,,,****//(((((%@
@@&##((/***,,,,****##*,,,,*##,,(##(///.(((,,,,,,,,..(/(*..,(,,,/*,((,,*/////(((%
@@@%###(///*****,,#**,,*,,,,,*#####////********,,,,,,,(..,,,///****,,,,*******/&
@@&%####(((/////*/****,,******(#####///.**********,,,,,.........*/..,,,,,***/(%,
@@&%%##((((((/%////#*/****###**######**(##(*****,*,*(,,.//......*.....,,,*//(#&@
@@@###/(/////%%/*/*/##,********,*##***********,**#(,,,,./*....*...,,,,,,*/*(#%@@
@%@@#((/**********#(***#,,*,,,.,,##*,,*,,,,***##/*,,,,,.,//./,...,,,****//(#%@ @
@@@&&##(/********#*****#,#/**.,****,,*,****##***##,,,**../,,,,,,,,,**//(##%%&&@@
@@@@&&%%(//**,**/***********((*********###************,#(,,,,,******//(###&&&@@@
@@@@@&&%%((/*,*,,,,,,,,***#(***######****#**,,*,,,,*****,(*********/(((##%%@@@@@
@@@@@@@@&%#(//**,,,,*******#////////#////#///*******///****(******/(((((#%@@@@@@
@@@@@@@@@#&(##((////*/***(#*///***(//////##//******/**/******#**//(((((#@@@@@@@@
@@@@@@@@@@@@@&,%#(((////#/**/***,,,(*,,,#,****************,,**/#(((##&@@@@@@@@@@
@@@/@ @@@@@@@@&&%&(#((%//////////////****/****************///(##((%&@@@@@@@@%@@@
@@@@@@@@@@@@@@@@@@@@#&##((((/////////////#****///****/((((##%%&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&&%%%###(#####(((((((########%%%%%%#&@@%@@%@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@ @@(@@@@@@&&&&&&%(%%&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@ @@@@@@@@@@
]]--
mod.QMSState = {
	APPEAR = 0,
	IDLE = 1,
    ATTACK1 = 2,
    ATTACK2 = 3,
    STILL = 4,
}

mod.QForms = {
    THE_EYE = 0,
    EMBER_TWIN = 1,
    ASH_TWIN = 2,
    TIMBER_HEART = 3,
    BRITTLE_HOLLOW = 4,
    DEEPS_GIANT = 5,
    DARK_BRAMBLE = 6,
}

mod.chainTransformQ = {
    [mod.QForms.THE_EYE] =          {0,   0.2, 0,   0.2, 0.2, 0.2, 0.2},
    [mod.QForms.EMBER_TWIN] =       {0,   0,   0,   0.25,0.25,0.25,0.25},
    [mod.QForms.ASH_TWIN] =         {1,   0,   0,   0,   0,   0,   0},
    [mod.QForms.TIMBER_HEART] =     {0,   0.25,0,   0,   0.25,0.25,0.25},
    [mod.QForms.BRITTLE_HOLLOW] =   {0,   0.25,0,   0.25,0,   0.25,0.25},
    [mod.QForms.DEEPS_GIANT] =      {0,   0.25,0,   0.25,0.25,0,   0.25},
    [mod.QForms.DARK_BRAMBLE] =     {0,   0.25,0,   0.25,0.25,0.25,0},
}

mod.QConst = {
    speed = 1.3,--1.3
    idleTimeInterval = Vector(10,20),

    attlerockSpeed = 13,
    moonOrbitDistance = 14,

    absorbSpeed = 15,
    
	nRainDrop = 6,
	rainDropRadius = 80,

    nElectricities = 9,
    electricityDist = 60,
    electricityAngle = 90,
    electricityTimeout = 30,--Even

    nSpikes = 32,

    nChains = 7,

    rockSpeed = 6,
    nRock1 = 15,
    nRock2 = 12,
    nRock3 = 8,
    rockAngle = 30,

}

mod.QProjectiles = {}
mod.QTears = {}
mod.QEntities = {}
mod.QFamiliars = {}

function mod:ErrantUpdate(entity)
	if entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR and entity.SubType == mod.EntityInf[mod.Entity.Errant].SUB then
		local data = entity:GetData()
		local sprite = entity:GetSprite()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()
		
		--Custom data:
		if data.State == nil then 
			data.State = 0
			data.StateFrame = 0
            data.StateAttack = 1
            data.Form = mod.QForms.THE_EYE
            data.ForceTransform = true
            data.EmberLaunched = false
            data.AttleLaunched = false

            sprite:SetOverlayRenderPriority(true)
		end

		--Frame
		data.StateFrame = data.StateFrame + 1
		
		if data.State == mod.QMSState.APPEAR then
			if data.StateFrame == 1 then
				mod:AppearPlanet(entity)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			elseif sprite:IsFinished("Appear") or sprite:IsFinished("AppearSlow") then
				data.State = mod.QMSState.IDLE
				data.StateFrame = 0
			elseif sprite:IsEventTriggered("EndAppear") then
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			elseif sprite:GetFrame()==40 and sprite:IsPlaying("AppearSlow") then--Turn black
                mod.ModFlags.pitchBlack = true
            elseif sprite:GetFrame()==75 and sprite:IsPlaying("AppearSlow") then--Turn no black
                mod.ModFlags.pitchBlack = false
            elseif sprite:GetFrame()==60 and sprite:IsPlaying("AppearSlow") then--Red
                for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0)) do
                    e:Remove()
                end
                mod:QuantumSetup(room)

                mod.ModFlags.ErrantTriggered = true

                --Re-close doors
                for i = 0, DoorSlot.NUM_DOOR_SLOTS do
                    local door = room:GetDoor(i)
                    if door then
                        door:Close()
                        door:GetSprite():Play("Closed")
                    end
                end
            end
			
		elseif data.State == mod.QMSState.IDLE then
			if data.StateFrame == 1 then
                if data.EmberLaunched then
                    sprite:Play("Idle1",true)
                else
                    sprite:Play("Idle",true)
                end
			elseif sprite:IsFinished("Idle") or sprite:IsFinished("Idle1") then
				if data.ForceTransform then
                    mod:ChangeForm(entity, sprite, data)
                else
                    if rng:RandomFloat() < 0.5 then
                        data.State = mod.QMSState.IDLE
                    else
                        if rng:RandomFloat() < 0.5 then
                            data.State = mod.QMSState.ATTACK1
                        else
                            data.State = mod.QMSState.ATTACK2
                        end
                    end
                end
				data.StateFrame = 0
                if data.Form == mod.QForms.BRITTLE_HOLLOW then
                    sprite:Play("Idle",true)
                end
			end
            mod:ErrantMove(entity, data, room, target)
			
		elseif data.Form == mod.QForms.EMBER_TWIN  and (data.State == mod.QMSState.ATTACK1 or data.State == mod.QMSState.ATTACK2) then
            if not data.EmberLaunched then
                mod:EmberLaunch(entity, data, sprite, target, room)
            else
                mod:EmberBlast(entity, data, sprite, target, room)
            end

        elseif data.Form == mod.QForms.TIMBER_HEART then
            if data.State == mod.QMSState.ATTACK1 then
                mod:TimberWater(entity, data, sprite, target, room)
            else
                if data.AttleLaunched then
                    mod:TimberWater(entity, data, sprite, target, room)
                else
                    mod:TimberAttleThrow(entity, data, sprite, target, room)
                end
            end

		elseif data.State == mod.QMSState.ATTACK1 then    
        
            if data.Form == mod.QForms.BRITTLE_HOLLOW then
                mod:BrittleTeleport(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DEEPS_GIANT then
                mod:GiantTornado(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DARK_BRAMBLE then
                mod:BrambleBite(entity, data, sprite, target, room)
            end

		elseif data.State == mod.QMSState.ATTACK2 then    
        
            if data.Form == mod.QForms.BRITTLE_HOLLOW then
                mod:BrittleAbsorb(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DEEPS_GIANT then
                mod:GiantElectricity(entity, data, sprite, target, room)
            elseif data.Form == mod.QForms.DARK_BRAMBLE then
                mod:BrambleSeed(entity, data, sprite, target, room)
            end

		end

        if data.Form == mod.QForms.BRITTLE_HOLLOW then

            for i=0, game:GetNumPlayers ()-1 do
                local player = game:GetPlayer(i)
                local dist = player.Position:Distance(entity.Position)
                if dist < 75 then
                    local direction = (player.Position - entity.Position)
                    player.Velocity = player.Velocity - direction:Length()/75 * direction:Normalized() / 2
                end
            end
            for _, t in ipairs(mod.QProjectiles) do
                if t then
                    local dist = t.Position:Distance(entity.Position)
                    if t:GetData().NoAbsorb and dist < 100 then
                        local direction = (t.Position - entity.Position)
                        t.Velocity = t.Velocity - direction:Length()/100 * direction:Normalized()/2
                    end
                end
            end
            for _, t in ipairs(mod.QTears) do
                if t then
                    local dist = t.Position:Distance(entity.Position)
                    if dist < 100 then
                        local direction = (t.Position - entity.Position)
                        t.Velocity = t.Velocity - direction:Length()/100 * direction:Normalized()*2
                    end
                end
            end

            if entity.FrameCount % 2 == 0 then
                mod.QProjectiles = Isaac.FindByType(EntityType.ENTITY_PROJECTILE)
                mod.QTears = Isaac.FindByType(EntityType.ENTITY_TEAR)
            end

        elseif data.Form == mod.QForms.EMBER_TWIN then
            local ash = entity.Parent
            if ash then
                local ashData = ash:GetData()
                local ashSprite = ash:GetSprite()

                if not ashData.StateFrame then
                    ashData.State = mod.QMSState.IDLE
                    ashData.StateFrame = 0
                    ashData.StateAttack = 1
                end

                ashData.StateFrame = ashData.StateFrame + 1

                if ashData.State == mod.QMSState.IDLE then
                    mod:ErrantMove(ash, ashData, room, target)
                elseif ashData.State == mod.QMSState.ATTACK1 then
                    mod:AshTime(entity, ash, ashData, ashSprite, target, room)
                elseif ashData.State == mod.QMSState.ATTACK2 then
                    mod:AshColumn(entity, ash, ashData, ashSprite, target, room)
                end
            end

        end
	end
end
--Ember twin
function mod:EmberLaunch(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Launch",true)
    elseif sprite:IsFinished("Launch") then
        mod:ErrantEndAttack(entity, data, sprite)
        data.StateAttack = 1
        data.EmberLaunched = true
        --[[sprite:Play("Idle",true)
    elseif sprite:IsFinished("Idle") then
        sprite:Play("Idle",true)]]

    elseif sprite:IsEventTriggered("Launch") then
        
        --sfx:Play(Isaac.GetSoundIdByName("TwinLaunch"),1)
        sfx:Play(SoundEffect.SOUND_CHAIN_BREAK,2)

        --Ash spawn
        local parent = entity
        for i=1,mod.QConst.nChains do
            local chain = mod:SpawnEntity(mod.Entity.TwinChain, entity.Position, Vector.Zero, entity):ToNPC()
            chain:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            chain:GetSprite():Play("Normal", true)
            chain.CollisionDamage = 0
            chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            parent.Child = chain
            chain.Parent = parent
            chain.I1 = i
            chain.DepthOffset = -15
            
            parent = chain
        end
        local ash = mod:SpawnEntity(mod.Entity.AshTwin, entity.Position, Vector.Zero, entity):ToNPC()
        ash:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        ash:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
        ash:GetSprite():Play("Idle", true)
        ash.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        parent.Child = ash
        ash.Parent = parent
        ash.I1 = mod.QConst.nChains+1

        entity.Parent = ash

        ash.Velocity = (target.Position - entity.Position):Normalized()*15

    end
        
end
function mod:EmberBlast(entity, data, sprite, target, room)
    entity.Velocity = Vector.Zero
    local n
    if data.StateFrame == 1 then
        sprite:Play("Rocks",true)
        sfx:Play(Isaac.GetSoundIdByName("Crumbling"),2)

        local ash = entity.Parent
        if ash then
            local ashData = ash:GetData()
            local ashSprite = ash:GetSprite()

            if not ashSprite:IsPlaying("Time") then
                ashData.StateFrame = 0
                if ashData.StateAttack == 1 then
                    ashData.StateAttack = 2
                    ashData.State = mod.QMSState.ATTACK1
                else
                    ashData.State = mod.QMSState.ATTACK2
                end
            end
        end
    elseif sprite:IsFinished("Rocks") then
        sfx:Stop(Isaac.GetSoundIdByName("Crumbling"))
        mod:ErrantEndAttack(entity, data, sprite)
        
    elseif sprite:IsEventTriggered("Attack1") then
        n = mod.QConst.nRock1
        local direction = (target.Position - entity.Position):Normalized()
        data.TargetDirection = direction
    elseif sprite:IsEventTriggered("Attack2") then
        n = mod.QConst.nRock2
    elseif sprite:IsEventTriggered("Attack3") then
        n = mod.QConst.nRock3
    end

    if sprite:IsEventTriggered("Attack1") or sprite:IsEventTriggered("Attack2") or sprite:IsEventTriggered("Attack3") then
        local a = -(n-1)*mod.QConst.rockAngle/2
        local b = (n-1)*mod.QConst.rockAngle/2
        for angle = a, b, mod.QConst.rockAngle do
            local velocity = data.TargetDirection:Rotated(angle)*mod.QConst.rockSpeed
            local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0, entity.Position, velocity, entity):ToProjectile()
            rock:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            mod:TearFallAfter(rock, 30*10)
            rock:GetSprite().Color = mod.Colors.ember
        end
    end
        
end
--AshTwin twin
function mod:AshTime(ember, ash, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Time",true)
    elseif sprite:IsFinished("Time") then
        data.State = mod.QMSState.IDLE
        data.StateFrame = 0
        sprite:Play("Idle",true)

    elseif sprite:IsEventTriggered("TimeSave") then
        sfx:Play(Isaac.GetSoundIdByName("AshTime1"),5)

        local count = 1
        for i, f in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
            mod.QFamiliars[count] = f
            mod.QFamiliars[count+1] = f.Position
            mod.QFamiliars[count+2] = f.Velocity
            mod.QFamiliars[count+3] = f:GetSprite():GetAnimation()
            mod.QFamiliars[count+4] = f:GetSprite():GetFrame()

            count = count + 5
        end
        local count = 1
        for i, p in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
            p = p:ToProjectile()
            mod.QProjectiles[count] = p
            mod.QProjectiles[count+1] = p.Position
            mod.QProjectiles[count+2] = p.Velocity
            mod.QProjectiles[count+3] = p.Height

            p:GetData().Saved = true

            count = count + 4
        end
        local count = 1
        for i, t in ipairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
            t = t:ToTear()
            mod.QTears[count] = t
            mod.QTears[count+1] = t.Position
            mod.QTears[count+2] = t.Velocity
            mod.QTears[count+3] = t.Height
            
            t:GetData().Saved = true

            count = count + 4
        end

        local count = 1
        for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.Errant].ID)) do
            mod.QEntities[count] = e
            mod.QEntities[count+1] = e.Position
            mod.QEntities[count+2] = e.Velocity
            mod.QEntities[count+3] = e.HitPoints
            mod.QEntities[count+4] = e:GetSprite():GetAnimation()
            mod.QEntities[count+5] = e:GetSprite():GetFrame()

            count = count + 6
        end
        for _, e in ipairs(Isaac.FindByType(mod.EntityInf[mod.Entity.TwinChain].ID, mod.EntityInf[mod.Entity.TwinChain].VAR, mod.EntityInf[mod.Entity.TwinChain].SUB)) do
            mod.QEntities[count] = e
            mod.QEntities[count+1] = e.Position
            mod.QEntities[count+2] = e.Velocity
            mod.QEntities[count+3] = e.HitPoints
            mod.QEntities[count+4] = e:GetSprite():GetAnimation()
            mod.QEntities[count+5] = e:GetSprite():GetFrame()

            count = count + 6
        end
        for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
            mod.QEntities[count] = e
            mod.QEntities[count+1] = e.Position
            mod.QEntities[count+2] = e.Velocity
            mod.QEntities[count+3] = e.HitPoints
            mod.QEntities[count+4] = e:GetSprite():GetAnimation()
            mod.QEntities[count+5] = e:GetSprite():GetFrame()

            count = count + 6
        end

    elseif sprite:IsEventTriggered("TimeLoad") then

        for i=1, #mod.QFamiliars, 5 do
            if mod.QFamiliars[i] then
                local entity = mod.QFamiliars[i]
                entity.Position = mod.QFamiliars[i+1]
                entity.Velocity = mod.QFamiliars[i+2]
                entity:GetSprite():Play(mod.QFamiliars[i+3], true)
                entity:GetSprite():SetFrame(mod.QFamiliars[i+4])
            end
        end
        for i=1, #mod.QProjectiles, 4 do
            if mod.QProjectiles[i] then
                local entity = mod.QProjectiles[i]
                entity = entity:ToProjectile()
                entity.Position = mod.QProjectiles[i+1]
                entity.Velocity = mod.QProjectiles[i+2]
                entity.Height = mod.QProjectiles[i+3]

                if entity.ChangeTimeout and entity.ChangeTimeout > 0 then
                    entity.ChangeTimeout = 30*10
                end
            end
        end
        for i=1, #mod.QTears, 4 do
            if mod.QTears[i] then
                local entity = mod.QTears[i]
                entity = entity:ToTear()

                entity.Position = mod.QTears[i+1]
                entity.Velocity = mod.QTears[i+2]
                entity.Height = mod.QTears[i+3]
            end
        end
        for i=1, #mod.QEntities, 6 do
            if mod.QEntities[i] then
                local entity = mod.QEntities[i]

                entity.Position = mod.QEntities[i+1]
                entity.Velocity = mod.QEntities[i+2]
                entity.HitPoints = mod.QEntities[i+3]

                if not (entity.Type == mod.EntityInf[mod.Entity.Errant].ID or entity.Type == EntityType.ENTITY_PLAYER) then
                    entity:GetSprite():Play(mod.QEntities[i+4], true)
                    entity:GetSprite():SetFrame(mod.QEntities[i+5])
                end
            end
        end

        --Destroy new
        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE))
        mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_TEAR))
    elseif sprite:IsEventTriggered("Sound") then
        sfx:Play(Isaac.GetSoundIdByName("AshTime2"),1.2)
    end
        
end
function mod:AshColumn(ember, ash, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Sand",true)
    elseif sprite:IsFinished("Sand") then
        data.State = mod.QMSState.IDLE
        data.StateFrame = 0
        sprite:Play("Idle",true)

    elseif sprite:IsEventTriggered("Summon") then
        sfx:Play(Isaac.GetSoundIdByName("Earthquake"),2)
        local pillar = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, 0, ash.Position, Vector.Zero, ash):ToEffect()
        --pillar:GetSprite():ReplaceSpritesheet(2, "gfx/effects/static_laser.png")
        pillar:GetSprite():LoadGraphics()
        pillar.Parent = ash
        pillar.Timeout = 60
        pillar:GetData().HeavensCall = true
        pillar:GetSprite().Color = mod.Colors.sand
    end
        
end
--Timber Heart
function mod:TimberAttleThrow(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Throw",true)
        local attlerock = entity.Child
        if attlerock then
            attlerock:GetData().orbitSpeed = attlerock:GetData().orbitSpeed*2
        end
    elseif sprite:IsFinished("Throw") then
        data.AttleLaunched = true
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        
        sfx:Play(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,1)

        local attlerock = entity.Child
        if attlerock then
            entity.Child = nil
            attlerock.Parent = nil
            attlerock.Velocity = (target.Position - attlerock.Position):Normalized()*mod.QConst.attlerockSpeed
            attlerock:GetSprite():Play("Spin", true)
        end
    end 
end
function mod:TimberWater(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Water",true)
    elseif sprite:IsFinished("Water") then
        data.Geyser = false
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("Geyser"),1.8)

        data.Geyser = true

        local waterParams = ProjectileParams()
		waterParams.Variant = ProjectileVariant.PROJECTILE_TEAR
		waterParams.FallingAccelModifier = 0.5
		local angle = 180
        if sprite.FlipX then
            angle = 0
        end
		entity:FireBossProjectiles (7, entity.Position + Vector(5,0):Rotated(angle), 0, waterParams)

        local n = mod:RandomInt(1,4)
        for i=1, 4 do
            local bubble = mod:SpawnEntity(mod.Entity.Bubble, entity.Position, Vector(10,0):Rotated(angle), entity)
            bubble:GetData().IsBubble_HC = true
        end

        entity.Velocity = Vector(20,0):Rotated(180-angle)

    end

    if data.Geyser then
        if entity:CollidesWithGrid() then
            game:ShakeScreen(30)
            game:SpawnParticles (entity.Position, EffectVariant.ROCK_PARTICLE, 10, 5)
        end
    end
end
--Brittle Hollow
function mod:BrittleTeleport(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Out",true)
        sfx:Play(Isaac.GetSoundIdByName("Warp"),1)
    elseif sprite:IsFinished("Out") then
        entity.Position = mod:GetRandomPosition(entity.Position, 200, target.Position)
        sprite:Play("In",true)
    elseif sprite:IsFinished("In") then
        local lantern = entity.Child
        if lantern then
            lantern:GetData().orbitDistance = mod.QConst.moonOrbitDistance
            lantern.SpriteScale = Vector.One
        end
        mod:ErrantEndAttack(entity, data, sprite)

    elseif sprite:IsPlaying("In") then
        local lantern = entity.Child
        if lantern then
            lantern:GetData().orbitDistance = math.min(mod.QConst.moonOrbitDistance, lantern:GetData().orbitDistance + 0.5) 
            lantern.SpriteScale = lantern.SpriteScale*2
        end
    elseif sprite:IsPlaying("Out") then
        local lantern = entity.Child
        if lantern then
            lantern:GetData().orbitDistance = math.max(0, lantern:GetData().orbitDistance - 0.5) 
            lantern.SpriteScale = lantern.SpriteScale*0.5
        end

    end 
end
function mod:BrittleAbsorb(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Absorb",true)
        if entity.Parent then
            entity.Parent:GetData().Queue = 0
        end
    elseif sprite:IsFinished("Absorb") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:WasEventTriggered("Attack") then
        
        for _,r in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, 0)) do
            if not r:GetData().NoAbsorb then
                r.Velocity = (-r.Position + entity.Position):Normalized() * mod.QConst.absorbSpeed
            end
            if r.Position:Distance(entity.Position) < 250 and not r:GetData().Marked then
                r:GetData().Marked = true
                entity.Parent:GetData().Queue = entity.Parent:GetData().Queue + 1
                
                if not entity.Parent:GetSprite():IsPlaying("Attack") then
                    entity.Parent:GetSprite():Play("Attack", true)
                end

            elseif r.Position:Distance(entity.Position) < 10 then
                r:Remove()
            end
        end
    end
end
--Giant's Deep
function mod:GiantElectricity(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Jump",true)
    elseif sprite:IsFinished("Jump") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Jump") then
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(Isaac.GetSoundIdByName("Electricity"),1)
    elseif sprite:IsEventTriggered("Land") then
        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST,1)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        for i=1, mod.QConst.nElectricities do
            local angle = i*360/mod.QConst.nElectricities
            local position = entity.Position + Vector(20,0):Rotated(angle)

            local glow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, position, Vector.Zero, entity):ToEffect()
            glow:GetSprite().Color = mod.Colors.red
            glow.Parent = entity
            glow.Timeout = mod.QConst.electricityTimeout
			glow.SpriteScale = Vector.One*0.5

            local glowData = glow:GetData()
            glowData.HeavensCall = true
            glowData.Direction = Vector(1,0):Rotated(angle)
            glowData.IsActive_HC = true
        end
    end
        
end
function mod:GiantTornado(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Tornado",true)
    elseif sprite:IsFinished("Tornado") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        
        sfx:Play(Isaac.GetSoundIdByName("GiantsTornado"),1)

        local velocity = (target.Position - entity.Position):Normalized()*3

		local tornado = mod:SpawnEntity(mod.Entity.Tornado, entity.Position+Vector(0,1), Vector.Zero, entity)
        tornado.Parent = entity
        tornado:GetSprite().Color = mod.Colors.giant
		tornado:GetData().Lifespan = 8
		tornado:GetData().Height = 6
		tornado:GetData().Scale = 0.75
		tornado:GetData().FastSpawn = true
		tornado:GetData().Velocity = velocity
		tornado:GetData().Rain = true
		tornado:GetData().IsGiants = true
    end
end
--Dark Bramble
function mod:BrambleBite(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Bite",true)
    elseif sprite:IsFinished("Bite") then
        mod:ErrantEndAttack(entity, data, sprite)

    elseif sprite:IsEventTriggered("Spawn") then
        sfx:Play(SoundEffect.SOUND_ANGRY_GURGLE,1)

        local spikes = {}
        for i=1, mod.QConst.nSpikes do
            local direction = mod.RoomWalls.UP
            if i<mod.QConst.nSpikes/2 then
                direction = mod.RoomWalls.DOWN
            end
            
            local position, rotation = mod:RandomUpDown(direction)
            local spike = mod:SpawnEntity(mod.Entity.BrambleSpike, position, Vector.Zero, entity)
            spike.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

            if direction == mod.RoomWalls.DOWN then
                spike:GetSprite().FlipY = true
            end

            spikes[i] = spike

            for j, s in ipairs(spikes) do
                if j~=i and s.Position:Distance(spike.Position) < 60 then
                    i = i - 1
                    spike:Remove()
                end
            end
        end
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(Isaac.GetSoundIdByName("Chomp"),1)

    end 
end
function mod:BrambleSeed(entity, data, sprite, target, room)
    if data.StateFrame == 1 then
        sprite:Play("Seed",true)
    elseif sprite:IsFinished("Seed") then
        mod:ErrantEndAttack(entity, data, sprite)
    elseif sprite:IsEventTriggered("Attack") then
        sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,1)

        local velocity = (target.Position-entity.Position):Normalized()*20
        local seed = mod:SpawnEntity(mod.Entity.BrambleSeed, entity.Position, velocity, entity)
        seed:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        seed:GetSprite():Play("Appear", true)
        seed.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end

--Move
function mod:ErrantMove(entity, data, room, target)
    if not (data.Form == mod.QForms.DARK_BRAMBLE or data.Form == mod.QForms.BRITTLE_HOLLOW) then
        mod:FaceTarget(entity, target)
    else
        entity:GetSprite().FlipX = false
    end
    --idle move taken from 'Alt Death' by hippocrunchy
	--idleTime == frames moving in the same direction
	if not data.idleTime then 
		data.idleTime = mod:RandomInt(mod.QConst.idleTimeInterval.X, mod.QConst.idleTimeInterval.Y)
		--V distance of Jupiter from the center of the room
		local distance = room:GetCenterPos():Distance(entity.Position)
		
		--If its too far away, return to the center
		if distance > 100 then
			data.targetvelocity = ((room:GetCenterPos() - entity.Position):Normalized()*2):Rotated(mod:RandomInt(-10, 10))
		--Else, get closer to the player
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
    entity.Velocity = ((data.targetvelocity * 0.3) + (entity.Velocity * 0.7)) * mod.QConst.speed
    data.targetvelocity = data.targetvelocity * 0.99
end
--ded
function mod:ErrantDeath(entity)
    if entity.Variant == mod.EntityInf[mod.Entity.Errant].VAR then
        mod.savedata.errantKilled = true
        mod.savedata.errantAlive = false
        
        mod:ClearEntities()

        mod:PausePool()
        local reward = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,  2^32-2, entity.Position, Vector.Zero, nil)
        reward:AddEntityFlags(EntityFlag.FLAG_GLITCH)
        
        local shard = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.Trinkets.Shard, entity.Position, Vector((rng:RandomFloat() * 4) + 3.5,0):Rotated(rng:RandomFloat()*360), nil)

        if game:GetLevel():GetCurrentRoomDesc().Data.Type == RoomType.ROOM_ERROR then
            local trapdoor = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, game:GetRoom():GetCenterPos(), true)
        end
    end
end
--deding
function mod:ErrantDying(entity)
    local sprite = entity:GetSprite()
    local data = entity:GetData()

    if data.deathFrame == nil then data.deathFrame = 1 end
    if sprite:GetFrame() == data.deathFrame and sprite:IsPlaying("Death") then
		data.deathFrame = data.deathFrame + 1
        if data.deathFrame == 2 then
            mod:ClearEntities()
            sprite:Load("gfx/entity_Errant.anm2", true)
            sprite:PlayOverlay("", true)
            sprite:LoadGraphics()
            sprite:Play("Death", true)
        end

        if sprite:IsEventTriggered("Sound") then
            sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1)
        end
	end

end

--State switch things
function mod:ErrantEndAttack(entity, data, sprite)
    if data.StateAttack == 1 then
        data.StateAttack = 2
    elseif data.StateAttack == 2 then
        data.StateAttack = 1
        data.ForceTransform = true
    end
    data.State = mod.QMSState.IDLE
    data.StateFrame = 0
end
function mod:ChangeForm(entity, sprite, data)

    --Datas
    data.StateAttack = 1
    data.ForceTransform = false
    data.EmberLaunched = false
    data.AttleLaunched = false

    local form = mod:MarkovTransition(data.Form, mod.chainTransformQ)
    data.Form = mod.QForms.THE_EYE
    --data.Form = mod.QForms.EMBER_TWIN
    
    mod.QProjectiles = {}
    mod.QTears = {}
    mod.QEntities = {}
    mod.QFamiliars = {}

    sfx:Play(Isaac.GetSoundIdByName("QuantumThunder"),1.3)

    --Entities
    mod:ClearEntities()


    sprite:PlayOverlay("", true)
    --Switch Animation
    sprite:Load("gfx/entity_Errant.anm2", true)
    sprite:LoadGraphics()
    sprite:Play("Switch", true)
    sprite:SetFrame(mod:RandomInt(0, sprite:GetFrame(sprite:SetLastFrame())-1))
    data.State = mod.QMSState.STILL

    mod:scheduleForUpdate(function()
        if not entity then return end
        sfx:Play(SoundEffect.SOUND_EDEN_GLITCH,1)

        data.State = mod.QMSState.IDLE
        data.Form = form
        --Sprites

        if data.Form == mod.QForms.EMBER_TWIN then
            sprite:Load("gfx/entity_ErrantEmber.anm2", true)

        elseif data.Form == mod.QForms.TIMBER_HEART then
            sprite:Load("gfx/entity_ErrantTimber.anm2", true)
            
        elseif data.Form == mod.QForms.BRITTLE_HOLLOW then
            sprite:Load("gfx/entity_ErrantBrittle.anm2", true)
            
        elseif data.Form == mod.QForms.DEEPS_GIANT then
            sprite:Load("gfx/entity_ErrantGiant.anm2", true)
            
        elseif data.Form == mod.QForms.DARK_BRAMBLE then
            sprite:Load("gfx/entity_ErrantBramble.anm2", true)

            sprite:PlayOverlay("Brambles", true)

        end
        sprite:LoadGraphics()
        sprite:Play("Idle", true)
        
        if data.Form == mod.QForms.TIMBER_HEART then
            local orbitDistance = mod.QConst.moonOrbitDistance
            local position = entity.Position + Vector(orbitDistance,0)
            local attlerock = mod:SpawnEntity(mod.Entity.Attlerock, position, Vector.Zero, entity)
            attlerock:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
            attlerock:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            attlerock:GetSprite():Play("Idle", true)
            attlerock.Parent = entity
            entity.Child = attlerock
            
            local arData = attlerock:GetData()
            arData.orbitIndex = 1
            arData.orbitTotal = 1
            arData.orbitDistance = orbitDistance
            arData.orbitSpin = 1
            arData.orbitSpeed = 4

            attlerock.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        elseif data.Form == mod.QForms.BRITTLE_HOLLOW then
            local orbitDistance = mod.QConst.moonOrbitDistance
            local position = entity.Position + Vector(orbitDistance,0)
            local lantern = mod:SpawnEntity(mod.Entity.HollowsLantern, position, Vector.Zero, entity)
            lantern:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
            lantern:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            lantern:GetSprite():Play("Idle", true)
            lantern.Parent = entity
            entity.Child = lantern
            
            local lanternData = lantern:GetData()
            lanternData.orbitIndex = 1
            lanternData.orbitTotal = 1
            lanternData.orbitDistance = orbitDistance
            lanternData.orbitSpin = 1
            lanternData.orbitSpeed = 4

            lantern.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

            
            local whitehole = mod:SpawnEntity(mod.Entity.WhiteHole, position, Vector.Zero, entity)
            whitehole:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_DONT_COUNT_BOSS_HP | EntityFlag.FLAG_PERSISTENT)
            whitehole:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            whitehole:GetSprite():Play("Idle", true)
            whitehole.Parent = entity
            whitehole.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            entity.Parent = whitehole

        end

    end, 15)

end
function mod:ClearEntities()
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.Attlerock))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.WhiteHole))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.HollowsLantern))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.AshTwin))
    mod:DeleteEntities(mod:FindByTypeMod(mod.Entity.TwinChain))
    mod:DeleteEntities(Isaac.FindByType(EntityType.ENTITY_PROJECTILE), true)
end
function mod:DeleteEntities(list, forced)
    for i=1, #list do
        local v = list[i]

        if (not v:GetData().Saved) or forced then
            v:Remove()
        end
    end
end


function mod:FamiliarParentMovement2(entity, distance, speed, stopness) --srsl... stopness??
    if not entity.Parent then
        entity:Remove()
    else
        local parent = entity.Parent
        local originalVel = entity.Velocity
    
        entity.Velocity = mod:Lerp(entity.Velocity, Vector.Zero, speed)
    
        local direction = parent.Position - entity.Position
    
        if parent.Position:Distance(entity.Position) > distance then
            entity.Velocity = mod:Lerp(entity.Velocity, direction / stopness, speed)
        end
    
        local newVel = entity.Velocity
    
        entity.Velocity = originalVel
        return newVel
    end

end
function mod:ChainUpdate(entity)

    if entity.Parent then
        local parent = entity.Parent
        local sprite = entity:GetSprite()

        local v1 = mod:FamiliarParentMovement2(entity, 2, 1.5, 15)
        local v2 = Vector.Zero

        local child = entity.Child
        entity.Parent = child
        v2 = mod:FamiliarParentMovement2(entity, 2, 1.5, 15)
        entity.Parent = parent

       --[[if v1:Length() > v2:Length() then
            entity.Velocity = v1
        else
            entity.Velocity = v2
        end]]
        entity.Velocity = (v1+v2)*1.65

    else
        entity:Remove()
    end

    if entity:GetData().Glued then
        entity.Velocity = Vector.Zero
        if entity.Child then
            entity.Position = entity.Child.Position
        end
    end
end


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ErrantUpdate, mod.EntityInf[mod.Entity.Errant].ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ErrantDeath, mod.EntityInf[mod.Entity.Errant].ID)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)

    if entity:GetData().Form == mod.QForms.BRITTLE_HOLLOW then
		game:MakeShockwave(entity.Position + Vector(0,-45), -0.075, 0.00025, 2)
		--game:MakeShockwave(entity.Position + Vector(0,-45), 0.175, 0.005, 2)
        --game:MakeShockwave(entity.Position + Vector(0,-45), -0.05, 0.00000001, 30)
        --game:MakeShockwave(entity.Position + Vector(0,-45), -0.01, 0.01, 30)
    elseif entity.Variant == mod.EntityInf[mod.Entity.WhiteHole].VAR and entity.SubType == mod.EntityInf[mod.Entity.WhiteHole].SUB then
		--game:MakeShockwave(entity.Position + Vector(0,-15), -0.25, 0.01, 2)
		--game:MakeShockwave(entity.Position + Vector(0,-15), 0.175, 0.005, 2)
        --game:MakeShockwave(entity.Position + Vector(0,-15), -0.05, 0.00000001, 60)
        game:MakeShockwave(entity.Position + Vector(0,-45), 0.04, 0.01, 2)
    end
end, mod.EntityInf[mod.Entity.Errant].ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
    if entity.Variant == mod.EntityInf[mod.Entity.TwinChain].VAR and entity.SubType == mod.EntityInf[mod.Entity.TwinChain].SUB then
        mod:ChainUpdate(entity)
    end
end, mod.EntityInf[mod.Entity.TwinChain].ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, frames)
    if entity.Variant == mod.EntityInf[mod.Entity.AshTwin].VAR and entity.SubType == mod.EntityInf[mod.Entity.AshTwin].SUB then
        for _, e in ipairs(mod:FindByTypeMod(mod.Entity.Errant)) do
            e:TakeDamage(amount, flags, source, frames)
        end
        if not entity.Parent then
            entity:Remove()
        end
    end
end, mod.EntityInf[mod.Entity.AshTwin].ID)
