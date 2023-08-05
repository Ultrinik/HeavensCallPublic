local mod = HeavensCall

mod.EntityInf = {}
mod.Entity ={
    Statue = 0,

    Jupiter = 1,
    Saturn = 2,
    Uranus = 3,
    Neptune = 4,

    Mercury = 5,
    Venus = 6,
    Terra1 = 7,
    Terra2 = 56,
    Terra3 = 57,
    Mars = 8,

    Luna = 9,
    Pluto = 10,
    Charon1 = 11,
    Charon2 = 88,
    Eris = 12,
    Makemake = 13,
    Haumea = 14,
    Errant = 75,
    Interloper = 85,

    Sol = 15,

    ---------

    IETDDATD = 16,
    Hyperion = 17,
    IceTurd = 18,
    NeptuneFaker = 19,
    Ulcers = 36,
    Candle = 37,
    CandleGurdy = 38,
    CandleSiren = 39,
    SirenRag = 40,
    CandleColostomia = 41,
    CandleMist = 42,
    Deimos = 49,
    Phobos = 50,
    MercuryBird = 54,
    Horsemen = 61,
    Turd = 53,
    LunaWisp = 78,
    LunaKnife = 79,
    LunaIncubus = 80,
    AltHorsemen = 82,
    PlutoBone = 86,
    MiniBranbleSeed = 89,
    BrambleCord = 90,
    BrambleSeed = 91,
    BrambleSpike = 92,
    Attlerock = 93,
    WhiteHole = 94,
    HollowsLantern = 95,
    AshTwin = 96,
    TwinChain = 97,

    ---------

    TimeFreezeSource = 20,
    TimeFreezeObjective = 21,
    Snowflake = 22,
    Tornado = 23,
    RedTrapdoor = 24,
    Thunder = 25,
    IceCreep = 26,
    Aurora = 27,
    MarsTarget = 43,
    MarsAirstrike = 44,
    TerraTarget = 59,
    Meteor = 60,
    TarBomb = 62,
    Tongue = 63,
    TongueCord = 64,
    SonicBoom = 65,
    MarsBoost = 66,
    LaserSword = 67,
    MercuryTrace = 69,
    ICUP = 71,
    GlassFracture = 72,
    LunaDoor = 73,
    LunaMegaSatanDoor = 74,
    Card = 76,
    Spike = 77,
    TrapTile = 83,
    Trap = 84,
    ErisNaue = 87,
    TritonHole = 112,
    SleepZZZ = 113,
    AnimaSola = 114,
    LunaTarget = 98,
    GreedDoor = 110,

    ---------
    
    KeyKnife = 28,
    KeyKnifeRed = 29,
    Icicle = 30,
    BigIcicle = 31,
    Hail = 32,
    Flame = 33,
    Fireball = 34,
    Kiss = 35,
    Missile = 45,
    Horn = 55,
    Bubble = 51,
    Leaf = 58,
    ChaosCard = 68,
    Bismuth = 70,
    LunaFetus = 81,
    Projectile3D = 120,
    
    ---------

    MarsGigaBomb = 46,
    MarsRocket = 47,
    MarsGigaRocket = 48,

    ---------

    FamiliarCandle = 101,
    Willo = 102,
    BlazeHeart = 103,
    Apple = 99,
    Snake1 = 100,
    Snake2 = 104,
    Snake3 = 105,
    Trident = 106,
    Price = 107,
    Telescope = 108,
    Moon = 109,
    
    ---------

    JupiterLaser = 111,

}
mod.DefaultSub = 160
mod.DefaultEntitySub = 0

--BOSSES-----------------------------------------------------------------------------------------------

mod.EntityInf[mod.Entity.Statue] = {ID = Isaac.GetEntityTypeByName("Astral Statue"), VAR = Isaac.GetEntityVariantByName("Astral Statue"), SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Jupiter] = {ID = Isaac.GetEntityTypeByName("Jupiter the Gargantuan"), VAR = Isaac.GetEntityVariantByName("Jupiter the Gargantuan"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Saturn] = {ID = Isaac.GetEntityTypeByName("Saturn the Intransigent"),  VAR = Isaac.GetEntityVariantByName("Saturn the Intransigent"),   SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Uranus] = {ID = Isaac.GetEntityTypeByName("Uranus the Unpleasant"),  VAR = Isaac.GetEntityVariantByName("Uranus the Unpleasant"),   SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Neptune] = {ID = Isaac.GetEntityTypeByName("Neptune the Unfathomable"), VAR = Isaac.GetEntityVariantByName("Neptune the Unfathomable"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Mercury] =  {ID = Isaac.GetEntityTypeByName("Mercury the Unwary"), VAR = Isaac.GetEntityVariantByName("Mercury the Unwary"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Venus] =  {ID = Isaac.GetEntityTypeByName("Venus the Termagant"), VAR = Isaac.GetEntityVariantByName("Venus the Termagant"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Terra1] =  {ID = Isaac.GetEntityTypeByName("Terra the Fatalist (green)"), VAR = Isaac.GetEntityVariantByName("Terra the Fatalist (green)"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Terra2] =  {ID = Isaac.GetEntityTypeByName("Terra the Fatalist (rock)"), VAR = Isaac.GetEntityVariantByName("Terra the Fatalist (rock)"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Terra3] =  {ID = Isaac.GetEntityTypeByName("Terra the Fatalist (eden)"), VAR = Isaac.GetEntityVariantByName("Terra the Fatalist (eden)"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Mars] =  {ID = Isaac.GetEntityTypeByName("Mars the Vainglorious"), VAR = Isaac.GetEntityVariantByName("Mars the Vainglorious"), SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Luna] =  {ID = Isaac.GetEntityTypeByName("Luna the Tainted"), VAR = Isaac.GetEntityVariantByName("Luna the Tainted"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Pluto] =  {ID = Isaac.GetEntityTypeByName("Pluto the Frivolous"), VAR = Isaac.GetEntityVariantByName("Pluto the Frivolous"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Charon1] =  {ID = Isaac.GetEntityTypeByName("Charon the Benumbed Pre"), VAR = Isaac.GetEntityVariantByName("Charon the Benumbed Pre"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Charon2] =  {ID = Isaac.GetEntityTypeByName("Charon the Benumbed"), VAR = Isaac.GetEntityVariantByName("Charon the Benumbed"), SUB = 36}
mod.EntityInf[mod.Entity.Eris] =  {ID = Isaac.GetEntityTypeByName("Eris the Vehement"), VAR = Isaac.GetEntityVariantByName("Eris the Vehement"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Makemake] =  {ID = Isaac.GetEntityTypeByName("Makemake the Phlegmatic"), VAR = Isaac.GetEntityVariantByName("Makemake the Phlegmatic"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Haumea] =  {ID = Isaac.GetEntityTypeByName("Haumea the Diffident"), VAR = Isaac.GetEntityVariantByName("Haumea the Diffident"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Errant] =  {ID = Isaac.GetEntityTypeByName("The Errant"), VAR = Isaac.GetEntityVariantByName("The Errant"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Interloper] =  {ID = Isaac.GetEntityTypeByName("The Interloper"), VAR = Isaac.GetEntityVariantByName("The Interloper"), SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Sol] =  {ID = Isaac.GetEntityTypeByName("Sol the Absolute"), VAR = Isaac.GetEntityVariantByName("Sol the Absolute"), SUB = mod.DefaultEntitySub}
--ENEMIES-----------------------------------------------------------------------------------------------

mod.EntityInf[mod.Entity.IETDDATD] = {ID = Isaac.GetEntityTypeByName("Invisible entity that does damage and then dies"), VAR = Isaac.GetEntityVariantByName("Invisible entity that does damage and then dies"), SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Hyperion] = {ID = EntityType.ENTITY_SUB_HORF, VAR = 1, SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.IceTurd] = {ID = Isaac.GetEntityTypeByName("Ice Turd (HC)"), VAR = Isaac.GetEntityVariantByName("Ice Turd (HC)"), SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Turd] = {ID = Isaac.GetEntityTypeByName("Tasty ice turd"), VAR = Isaac.GetEntityVariantByName("Tasty ice turd"), SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.NeptuneFaker] = {ID = Isaac.GetEntityTypeByName("Neptune Faker (HC)"), VAR = Isaac.GetEntityVariantByName("Neptune Faker (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.MercuryBird] = {ID = Isaac.GetEntityTypeByName("Mercury Bird (HC)"), VAR = Isaac.GetEntityVariantByName("Mercury Bird (HC)"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Ulcers] = {ID = Isaac.GetEntityTypeByName("Ulcers"), VAR = Isaac.GetEntityVariantByName("Ulcers"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Candle] = {ID = Isaac.GetEntityTypeByName("Venus Candle"), VAR = Isaac.GetEntityVariantByName("Venus Candle"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.CandleGurdy] = {ID = Isaac.GetEntityTypeByName("Candle Gurdy"), VAR = Isaac.GetEntityVariantByName("Candle Gurdy"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.CandleSiren] = {ID = Isaac.GetEntityTypeByName("Candle Siren"), VAR = Isaac.GetEntityVariantByName("Candle Siren"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.SirenRag] = {ID = Isaac.GetEntityTypeByName("Siren Rag (HC)"), VAR = Isaac.GetEntityVariantByName("Siren Rag (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.CandleColostomia] = {ID = Isaac.GetEntityTypeByName("Candle Colostomia"), VAR = Isaac.GetEntityVariantByName("Candle Colostomia"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.CandleMist] = {ID = Isaac.GetEntityTypeByName("Candle Maid in the Mist"), VAR = Isaac.GetEntityVariantByName("Candle Maid in the Mist"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Horsemen] = {ID = Isaac.GetEntityTypeByName("Horsemen (HC)"), VAR = Isaac.GetEntityVariantByName("Horsemen (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.TarBomb] = {ID = Isaac.GetEntityTypeByName("Tar Bomb (HC)"), VAR = Isaac.GetEntityVariantByName("Tar Bomb (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Tongue] = {ID = Isaac.GetEntityTypeByName("Tongue (HC)"), VAR = Isaac.GetEntityVariantByName("Tongue (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.TongueCord] = {ID = Isaac.GetEntityTypeByName("Tongue Cord (HC)"), VAR = Isaac.GetEntityVariantByName("Tongue Cord (HC)"),  SUB = 60}

mod.EntityInf[mod.Entity.Deimos] = {ID = Isaac.GetEntityTypeByName("Deimos the Tarnished"), VAR = Isaac.GetEntityVariantByName("Deimos the Tarnished"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Phobos] = {ID = Isaac.GetEntityTypeByName("Phobos the Tarnished"), VAR = Isaac.GetEntityVariantByName("Phobos the Tarnished"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.LunaWisp] = {ID = Isaac.GetEntityTypeByName("Luna Wisp (HC)"), VAR = Isaac.GetEntityVariantByName("Luna Wisp (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.LunaKnife] = {ID = Isaac.GetEntityTypeByName("Luna Knife (HC)"), VAR = Isaac.GetEntityVariantByName("Luna Knife (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.LunaIncubus] = {ID = Isaac.GetEntityTypeByName("Luna Incubus (HC)"), VAR = Isaac.GetEntityVariantByName("Luna Incubus (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.AltHorsemen] = {ID = Isaac.GetEntityTypeByName("Alt Horsemen (HC)"), VAR = Isaac.GetEntityVariantByName("Alt Horsemen (HC)"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.PlutoBone] = {ID = Isaac.GetEntityTypeByName("Pluto Bone (HC)"), VAR = Isaac.GetEntityVariantByName("Pluto Bone (HC)"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.BrambleSeed] = {ID = Isaac.GetEntityTypeByName("Bramble Seed (HC)"), VAR = Isaac.GetEntityVariantByName("Bramble Seed (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.MiniBranbleSeed] = {ID = Isaac.GetEntityTypeByName("Brample Mini-seed (HC)"), VAR = Isaac.GetEntityVariantByName("Brample Mini-seed (HC)"),  SUB = mod.DefaultSub+1}
mod.EntityInf[mod.Entity.BrambleCord] = {ID = Isaac.GetEntityTypeByName("Bramble Cord (HC)"), VAR = Isaac.GetEntityVariantByName("Bramble Cord (HC)"),  SUB = 60+1}
mod.EntityInf[mod.Entity.BrambleSpike] = {ID = Isaac.GetEntityTypeByName("Bramble Spike (HC)"), VAR = Isaac.GetEntityVariantByName("Bramble Spike (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.WhiteHole] = {ID = Isaac.GetEntityTypeByName("The Errant (WH)"), VAR = Isaac.GetEntityVariantByName("The Errant (WH)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Attlerock] = {ID = Isaac.GetEntityTypeByName("The Errant (AR)"), VAR = Isaac.GetEntityVariantByName("The Errant (AR)"),  SUB = mod.DefaultEntitySub+1}
mod.EntityInf[mod.Entity.HollowsLantern] = {ID = Isaac.GetEntityTypeByName("The Errant (HL)"), VAR = Isaac.GetEntityVariantByName("The Errant (HL)"),  SUB = mod.DefaultEntitySub+2}
mod.EntityInf[mod.Entity.AshTwin] = {ID = Isaac.GetEntityTypeByName("The Errant (AT)"), VAR = Isaac.GetEntityVariantByName("The Errant (AT)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.TwinChain] = {ID = Isaac.GetEntityTypeByName("Twin Chain (HC)"), VAR = Isaac.GetEntityVariantByName("Twin Chain (HC)"),  SUB = mod.DefaultEntitySub + 1}


mod.EntityInf[mod.Entity.Projectile3D] = {ID = Isaac.GetEntityTypeByName("3D Projectile (HC)"), VAR = Isaac.GetEntityVariantByName("3D Projectile (HC)"),  SUB = mod.DefaultSub}

--EFFECTS-----------------------------------------------------------------------------------------------

mod.EntityInf[mod.Entity.Aurora] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Aurora (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Thunder] = {ID = EntityType.ENTITY_EFFECT, VAR = EffectVariant.CRACK_THE_SKY,  SUB = 5}

mod.EntityInf[mod.Entity.TimeFreezeSource] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Timestuck Source (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.TimeFreezeObjective] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Timestuck Objective (HC)"),  SUB = mod.DefaultSub+1}

mod.EntityInf[mod.Entity.Snowflake] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Snowflake (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.IceCreep] = {ID = EntityType.ENTITY_EFFECT, VAR = EffectVariant.CREEP_SLIPPERY_BROWN,  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Tornado] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Tornado (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Horn] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Horn (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.SonicBoom] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Sonic Boom (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.MercuryTrace] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Mercury Trace (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.TerraTarget] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Terra Target (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Meteor] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Meteor (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.MarsTarget] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Mars Target (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.MarsAirstrike] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Mars Airstrike (HC)"),  SUB = mod.DefaultSub+1}
mod.EntityInf[mod.Entity.MarsBoost] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Mars Boost (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.LaserSword] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Laser Sword (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.RedTrapdoor] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Red Trapdoor (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.ICUP] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("ICUP (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.LunaDoor] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Luna Door (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.LunaMegaSatanDoor] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Mega Satan Luna Door (HC)"),  SUB = mod.DefaultSub+1}
mod.EntityInf[mod.Entity.Card] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Card (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.GreedDoor] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Luna Greed Door (HC)"),  SUB = mod.DefaultSub + 1}
mod.EntityInf[mod.Entity.Spike] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Luna Spike (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.TrapTile] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Tomb Traptile (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Trap] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Tomb Trap (HC)"),  SUB = mod.DefaultSub + 1}
mod.EntityInf[mod.Entity.SleepZZZ] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Sleep ZZZ (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.AnimaSola] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Luna Anima Sola (HC)"),  SUB = mod.DefaultSub+1}
mod.EntityInf[mod.Entity.LunaTarget] = {ID = Isaac.GetEntityTypeByName("Luna Target (HC)"), VAR = Isaac.GetEntityVariantByName("Luna Target (HC)"),  SUB = mod.DefaultSub + 2}

mod.EntityInf[mod.Entity.ErisNaue] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Eris Naue (HC)"),  SUB = mod.DefaultSub + 1}

--PROJECTILES-----------------------------------------------------------------------------------------------

mod.EntityInf[mod.Entity.KeyKnife] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Key Knife (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.KeyKnifeRed] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Key Knife Special (HC)"),  SUB = mod.DefaultSub+1}

mod.EntityInf[mod.Entity.Icicle] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Icicle (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.BigIcicle] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Big Icicle (HC)"),  SUB = mod.DefaultSub+1}
mod.EntityInf[mod.Entity.Hail] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Hail (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Bismuth] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Bismuth (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Bubble] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Bubble (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Leaf] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Leaf (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Flame] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Flame (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Fireball] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Fireball (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Kiss] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Kiss (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Missile] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Missile (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.ChaosCard] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Chaos Card (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.LunaFetus] = {ID = EntityType.ENTITY_PROJECTILE, VAR = Isaac.GetEntityVariantByName("Luna Fetus (HC)"),  SUB = mod.DefaultSub}

--OTHERS-------------------------------------------------------------------------------------------------

mod.EntityInf[mod.Entity.MarsGigaBomb] = {ID = EntityType.ENTITY_BOMB, VAR = BombVariant.BOMB_NORMAL,  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.MarsRocket] = {ID = EntityType.ENTITY_BOMB, VAR = BombVariant.BOMB_ROCKET,  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.MarsGigaRocket] = {ID = EntityType.ENTITY_BOMB, VAR = BombVariant.BOMB_ROCKET,  SUB = mod.DefaultSub+1}

mod.EntityInf[mod.Entity.JupiterLaser] = {ID = EntityType.ENTITY_LASER, VAR = Isaac.GetEntityVariantByName("Jupiter Laser (HC)"),  SUB = mod.DefaultEntitySub}

--ITEMS THINGS--------------------------------------------------------------------------------------------

mod.EntityInf[mod.Entity.FamiliarCandle] = {ID = EntityType.ENTITY_FAMILIAR, VAR = Isaac.GetEntityVariantByName("Candle (HC)"),  SUB = 0}
mod.EntityInf[mod.Entity.Willo] = {ID = EntityType.ENTITY_FAMILIAR, VAR = Isaac.GetEntityVariantByName("Attack Willo (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.BlazeHeart] = {ID = EntityType.ENTITY_PICKUP, VAR = Isaac.GetEntityVariantByName("Blaze Heart (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Apple] = {ID = EntityType.ENTITY_PICKUP, VAR = Isaac.GetEntityVariantByName("Apple (HC)"),  SUB = mod.DefaultSub}
mod.EntityInf[mod.Entity.Snake1] = {ID = Isaac.GetEntityTypeByName("Snake big (HC)"), VAR = Isaac.GetEntityVariantByName("Snake big (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Snake2] = {ID = Isaac.GetEntityTypeByName("Snake madium (HC)"), VAR = Isaac.GetEntityVariantByName("Snake madium (HC)"),  SUB = mod.DefaultEntitySub}
mod.EntityInf[mod.Entity.Snake3] = {ID = Isaac.GetEntityTypeByName("Snake small (HC)"), VAR = Isaac.GetEntityVariantByName("Snake small (HC)"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Trident] = {ID = EntityType.ENTITY_FAMILIAR, VAR = Isaac.GetEntityVariantByName("Trident (HC)"),  SUB = 0}
mod.EntityInf[mod.Entity.TritonHole] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Triton Hole (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Price] = {ID = EntityType.ENTITY_EFFECT, VAR = Isaac.GetEntityVariantByName("Price (HC)"),  SUB = mod.DefaultSub}

mod.EntityInf[mod.Entity.Telescope] = {ID = EntityType.ENTITY_SLOT, VAR = Isaac.GetEntityVariantByName("Telescope (HC)"),  SUB = mod.DefaultEntitySub}

mod.EntityInf[mod.Entity.Moon] = {ID = EntityType.ENTITY_FAMILIAR, VAR = Isaac.GetEntityVariantByName("Moon Jupiter (HC)"),  SUB = 0}

--BLABLA
mod.PlanetName = {
    [mod.Entity.Jupiter] = "Jupiter the Gargantuan",
    [mod.Entity.Saturn] = "Saturn the Intransigent",
    [mod.Entity.Uranus] = "Uranus the Unpleasant",
    [mod.Entity.Neptune] = "Neptune the Unfathomable",
    
    [mod.Entity.Mercury] = "Mercury the Unwary",
    [mod.Entity.Venus] = "Venus the Termagant",
    [mod.Entity.Terra1] = "Terra the Fatalist",
    [mod.Entity.Mars] = "Mars the Vainglorious",
    
    [mod.Entity.Luna] = "Luna the Tainted",
    [mod.Entity.Pluto] = "Pluto the Frivolous",
    [mod.Entity.Charon1] = "Charon the Benumbed",
    [mod.Entity.Eris] = "Eris the Vehement",
    [mod.Entity.Makemake] = "Makemake the Phlegmatic",
    [mod.Entity.Haumea] = "Haumea the Diffident",
    [mod.Entity.Errant] = "The Errant",
    
}
