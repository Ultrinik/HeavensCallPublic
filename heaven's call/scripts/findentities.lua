local mod = HeavensCall
local rng = mod:GetRunRNG()

mod.EntityInf = {}
mod.Entity ={}

--------------------------------
local entityCount = 0
function mod:AddEntityInf(dicName, entName)
    mod.Entity[dicName] = entityCount
    entityCount = entityCount + 1

    mod.EntityInf[mod.Entity[dicName]] = {ID = Isaac.GetEntityTypeByName(entName), VAR = Isaac.GetEntityVariantByName(entName), SUB = Isaac.GetEntitySubTypeByName(entName)}
end

--BOSSES-----------------------------------------------------------------------------------------------
mod:AddEntityInf("Statue", "Astral Statue")
mod:AddEntityInf("LunarStatue", "Luna Statue")
mod:AddEntityInf("BossStatue", "Boss Statue (HC)")

mod:AddEntityInf("Jupiter", "Jupiter the Gargantuan")
mod:AddEntityInf("Saturn", "Saturn the Intransigent")
mod:AddEntityInf("Uranus", "Uranus the Unpleasant")
mod:AddEntityInf("Neptune", "Neptune the Unfathomable")

mod:AddEntityInf("Mercury", "Mercury the Unwary")
mod:AddEntityInf("Venus", "Venus the Termagant")
mod:AddEntityInf("Terra1", "Terra the Fatalist (Green)")
mod:AddEntityInf("Terra2", "Terra the Fatalist (Stoned)")
mod:AddEntityInf("Terra3", "Terra the Fatalist (Eden)")
mod:AddEntityInf("Mars", "Mars the Vainglorious")

mod:AddEntityInf("Luna", "Luna the Tainted")
mod:AddEntityInf("Pluto", "Pluto the Frivolous")
mod:AddEntityInf("Charon1", " Charon the Benumbed ")
mod:AddEntityInf("Charon2", "Charon the Benumbed")
mod:AddEntityInf("Eris", "Eris the Vehement")
mod:AddEntityInf("Makemake", "Makemake the Phlegmatic")
mod:AddEntityInf("Haumea", "Haumea the Diffident")
mod:AddEntityInf("Ceres", "Ceres the Cauterized")
mod:AddEntityInf("Errant", "The Errant")

mod:AddEntityInf("Sol", "Sol the Absolute")
mod:AddEntityInf("RSaturn", "Ouroboros (Paradox Saturn)")
mod:AddEntityInf("Everchanger", " Everchanger ")
--ENEMIES-----------------------------------------------------------------------------------------------

mod:AddEntityInf("IETDDATD", "Invisible entity that does damage and then dies")
mod:AddEntityInf("Hyperion", "Hyperion the Restrained")

mod:AddEntityInf("IceTurd", "Ice Turd (HC)")
mod:AddEntityInf("Turd", "Tasty Ice Turd (HC)")
mod:AddEntityInf("IceCrystal", "Ice Crystal (HC)")
mod:AddEntityInf("Oberon", " Oberon ")

mod:AddEntityInf("NeptuneFaker", "Neptune Faker (HC)")

mod:AddEntityInf("MercuryBird", "Mercury Bird (HC)")

mod:AddEntityInf("Ulcers", "Ulcers")
mod:AddEntityInf("Candle", "Venus Candle")
mod:AddEntityInf("CandleGurdy", "Candle Gurdy")
mod:AddEntityInf("CandleSiren", "Candle Siren")
mod:AddEntityInf("SirenRag", "Siren Rag (HC)")
mod:AddEntityInf("CandleColostomia", "Candle Colostomia")
mod:AddEntityInf("CandleMist", "Candle Maid in the Mist")
mod:AddEntityInf("CandleDevil", "Candle Dust Devil")
mod:AddEntityInf("CandleBall", "Candle Ball")

mod:AddEntityInf("Horsemen", "Horsemen (HC)")
mod:AddEntityInf("TarBomb", "Tar Bomb (HC)")
mod:AddEntityInf("Tongue", "Tongue (HC)")
mod:AddEntityInf("TongueCord", "Tongue Cord (HC)")

mod:AddEntityInf("Deimos", "Deimos the Tarnished")
mod:AddEntityInf("Phobos", "Phobos the Tarnished")

mod:AddEntityInf("LunaWisp", "Luna Wisp (HC)")
mod:AddEntityInf("LunaKnife", "Luna Knife (HC)")
mod:AddEntityInf("LunaIncubus", "Luna Incubus (HC)")
mod:AddEntityInf("AltHorsemen", "Alt Horsemen (HC)")

mod:AddEntityInf("PlutoBone", "Pluto Bone (HC)")

mod:AddEntityInf("BrambleSeed", "Bramble Seed (HC)")
mod:AddEntityInf("MiniBranbleSeed", "Brample Mini-seed (HC)")
mod:AddEntityInf("BrambleCord", "Bramble Cord (HC)")
mod:AddEntityInf("BrambleSpike", "Bramble Spike (HC)")
mod:AddEntityInf("WhiteHole", "The Errant (WH)")
mod:AddEntityInf("Attlerock", "The Errant (AR)")
mod:AddEntityInf("HollowsLantern", "The Errant (HL)")
mod:AddEntityInf("AshTwin", "The Errant (AT)")
mod:AddEntityInf("TwinChain", "Twin Chain (HC)")


mod:AddEntityInf("SolarBlaster", "Solar Blaster (HC)")
mod:AddEntityInf("Projectile3D", "3D Projectile (HC)")
mod:AddEntityInf("GlassGaper", " Glass Gaper ")
mod:AddEntityInf("SolHand", "Sol Hand (HC)")

mod:AddEntityInf("LilSteven", "Ouroboros Steven (HC)")
mod:AddEntityInf("Steven", "Ouroboros Steven Depression (HC)")
mod:AddEntityInf("Drifter", " Drifter  ")
mod:AddEntityInf("Froh", " Froh  ")
mod:AddEntityInf("Warper", " Warper  ")
mod:AddEntityInf("OuroborosFakeTrace", "Ouroboros Fake (HC)")
mod:AddEntityInf("StevenBall", "Ouroboros Ball (HC)")
mod:AddEntityInf("StevenLaser", "Steven Laser (HC)")
mod:AddEntityInf("SaturnGhost", "Steven Ghost (HC)")
mod:AddEntityInf("StevenBox", "Steven Box (HC)")

--EFFECTS-----------------------------------------------------------------------------------------------

mod:AddEntityInf("Background", "Wall (HC)")

mod:AddEntityInf("Aurora", "Aurora (HC)")
mod:AddEntityInf("Thunder", "Thunder (HC)")
mod:AddEntityInf("InstantThunder", "Instant Thunder (HC)")

mod:AddEntityInf("TimeFreezeSource", "Timestuck Source (HC)")
mod:AddEntityInf("TimeFreezeObjective", "Timestuck Objective (HC)")
mod:AddEntityInf("SaturnTrace", "Timestuck Saturn (HC)")

mod:AddEntityInf("Snowflake", "Snowflake (HC)")
mod:AddEntityInf("IceCreep", "Slippery Ice Creep (HC)")

mod:AddEntityInf("Tornado", "Tornado (HC)")

mod:AddEntityInf("Horn", "Horn (HC)")
mod:AddEntityInf("SonicBoom", "Sonic Boom (HC)")
mod:AddEntityInf("MercuryTrace", "Mercury Trace (HC)")
mod:AddEntityInf("GlassFracture", "Glass Fracture (HC)")
mod:AddEntityInf("MercuryTarget", "Mercury Target (HC)")

mod:AddEntityInf("TerraTarget", "Terra Target (HC)")
mod:AddEntityInf("Meteor", "Meteor (HC)")
mod:AddEntityInf("TerraNova", "Terra Nova (HC)")
mod:AddEntityInf("Pollen", "Pollen (HC)")

mod:AddEntityInf("MarsTarget", "Mars Target (HC)")
mod:AddEntityInf("MarsAirstrike", "Mars Airstrike (HC)")
mod:AddEntityInf("MarsBoost", "Mars Boost (HC)")
mod:AddEntityInf("LaserSword", "Laser Sword (HC)")
mod:AddEntityInf("MarsGun", "Laser Gun (HC)")
mod:AddEntityInf("MarsLilGun", "Laser Lil Gun (HC)")

mod:AddEntityInf("RedTrapdoor", "Red Trapdoor (HC)")
mod:AddEntityInf("ICUP", "ICUP (HC)")
mod:AddEntityInf("LunaDoor", "Luna Door (HC)")
mod:AddEntityInf("LunaMegaSatanDoor", "Mega Satan Luna Door (HC)")
mod:AddEntityInf("Card", "Card (HC)")
mod:AddEntityInf("GreedDoor", "Luna Greed Door (HC)")
mod:AddEntityInf("Spike", "Luna Spike (HC)")
mod:AddEntityInf("TrapTile", "Tomb Traptile (HC)")
mod:AddEntityInf("Trap", "Tomb Trap (HC)")
mod:AddEntityInf("SleepZZZ", "Sleep ZZZ (HC)")
mod:AddEntityInf("AnimaSola", "Luna Anima Sola (HC)")
mod:AddEntityInf("LunaTarget", "Luna Target (HC)")

mod:AddEntityInf("ErisNaue", "Eris Naue (HC)")

mod:AddEntityInf("StarZodiac", "Sol Zodiac Star (HC)")
mod:AddEntityInf("StarBig", "Sol Big Star (HC)")
mod:AddEntityInf("SolLightTarget", "Sol Airstrike Light (HC)")
mod:AddEntityInf("SolStarTarget", "Sol Airstrike Star (HC)")
mod:AddEntityInf("SolTimeVent", "Sol TimeVent (HC)")
mod:AddEntityInf("SolProjectileDeath", "Sol Projectile Death (HC)")
mod:AddEntityInf("SolEye", "Sol Eye (HC)")
mod:AddEntityInf("SolSwordTrace", "Sol Sword Trace (HC)")
mod:AddEntityInf("SolWingTrace", "Sol Wing Trace (HC)")
mod:AddEntityInf("SolarPaticle", "Solar Particle (HC)")
mod:AddEntityInf("SolSnake", "Sol Snake Head (HC)")
mod:AddEntityInf("SolSword", "Sol Sword (HC)")
mod:AddEntityInf("BossSolStatue", "Sol Statue Spawn (HC)")

mod:AddEntityInf("CeresWatch", "Ceres Watcher (HC)")

mod:AddEntityInf("LoopController", "Loop Controler (HC)")

mod:AddEntityInf("StevenScreen", "Steven Screen (HC)")

mod:AddEntityInf("Deintegration", "Deintegration (HC)")

mod:AddEntityInf("Debuff", "Debuff (HC)")

mod:AddEntityInf("QuantumPlayer", "Quantum Player (HC)")
mod:AddEntityInf("Glitch", "EC Glitch (HC)")
mod:AddEntityInf("ECEye", "EC Eye (HC)")

mod:AddEntityInf("StarAstral", "Astral Zodiac Star (HC)")

--PROJECTILES-----------------------------------------------------------------------------------------------

mod:AddEntityInf("KeyKnife", "Key Knife (HC)")
mod:AddEntityInf("KeyKnifeRed", "Key Knife Special (HC)")

mod:AddEntityInf("Icicle", "Icicle (HC)")
mod:AddEntityInf("BigIcicle", "Big Icicle (HC)")
mod:AddEntityInf("Hail", "Hail (HC)")

mod:AddEntityInf("DarkMatter", "Dark Matter (HC)")
mod:AddEntityInf("NemoFish", "Nemo Fish (HC)")

mod:AddEntityInf("Bismuth", "Bismuth (HC)")

mod:AddEntityInf("Bubble", "Bubble (HC)")
mod:AddEntityInf("Leaf", "Leaf (HC)")
mod:AddEntityInf("Cloud", "Cloud (HC)")

mod:AddEntityInf("Kiss", "Kiss (HC)")
mod:AddEntityInf("Flame", "Flame (HC)")
mod:AddEntityInf("Fireball", "Fireball (HC)")

mod:AddEntityInf("Missile", "Missile (HC)")
mod:AddEntityInf("ChaosCard", "Chaos Card (HC)")

mod:AddEntityInf("LunaFetus", "Luna Fetus (HC)")

mod:AddEntityInf("Star4", "Sol 4Star (HC)")
mod:AddEntityInf("Star5", "Sol 5Star (HC)")
mod:AddEntityInf("Star8", "Sol 8Star (HC)")
mod:AddEntityInf("Flare", "Sol Flare (HC)")
mod:AddEntityInf("BigFlare", "Sol Big Flare (HC)")
mod:AddEntityInf("SolarSaw", "Sol Saw (HC)")
mod:AddEntityInf("Galaxy", "Sol Galaxy (HC)")
mod:AddEntityInf("GlassShard", "Glass Shard (HC)")
mod:AddEntityInf("SolFeather", "Solar Feather (HC)")

mod:AddEntityInf("ElectricWisp", "Electric Wisp (HC)")
mod:AddEntityInf("CallistoEye", "Callisto Eye (HC)")

--OTHERS-------------------------------------------------------------------------------------------------

mod:AddEntityInf("MarsGigaBomb", "Mars Giga Bomb (HC)")
mod:AddEntityInf("MarsRocket", "Mars Rocket (HC)")
mod:AddEntityInf("MarsGigaRocket", "Mars Giga Rocket (HC)")

mod:AddEntityInf("JupiterLaser", "Jupiter Laser (HC)")

mod:AddEntityInf("SolLaser", "Sol Laser (HC)")
mod:AddEntityInf("SolWarningLaser", "Sol Warning Laser (HC)")
mod:AddEntityInf("HyperBeam", "Hyper Laser (HC)")

mod:AddEntityInf("House", "House (HC)")
mod:AddEntityInf("Tree", "Tree Empty (HC)")
mod:AddEntityInf("BabelButton", "Babel Button (HC)")
mod:AddEntityInf("Grass", "Grass (HC)")

--LUNAR ITEMS THINGS--------------------------------------------------------------------------------------------

mod:AddEntityInf("FamiliarCandle", "Candle (HC)")
mod:AddEntityInf("Willo", "Attack Willo (HC)")
mod:AddEntityInf("BlazeHeart", "Blaze Heart (HC)")

mod:AddEntityInf("Apple", "Apple (HC)")
mod:AddEntityInf("Snake1", "Snake big (HC)")
mod:AddEntityInf("Snake2", "Snake madium (HC)")
mod:AddEntityInf("Snake3", "Snake small (HC)")
mod:AddEntityInf("BadApple", "Bad Apple (HC)")

mod:AddEntityInf("Trident", "Trident (HC)")
mod:AddEntityInf("TritonHole", "Triton Hole (HC)")

mod:AddEntityInf("Price", "Price (HC)")

mod:AddEntityInf("Telescope", "Telescope (HC)")
mod:AddEntityInf("Titan", "Lil Titan Beggar")

mod:AddEntityInf("Moon", "Moon Jupiter (HC)")


--SOLAR ITEMS THINGS--------------------------------------------------------------------------------------------
mod:AddEntityInf("Mothership", "Mothership (HC)")
mod:AddEntityInf("AlienCharger", "Alien Charger (HC)")
mod:AddEntityInf("Computer", "Computer (HC)")


mod:AddEntityInf("Cow", "Cow in a trash farm (HC)")
mod:AddEntityInf("Spell", "Scepter Spell (HC)")


mod:AddEntityInf("RopeNode", "Rope Node (HC)")
mod:AddEntityInf("RopeCord", "Rope Cord (HC)")


mod:AddEntityInf("BismuthOre", "Bismuth 1 (HC)")
mod:AddEntityInf("ItemSelection", "Item Selection (HC)")


mod:AddEntityInf("Wormhole", "Wormhole (HC)")


mod:AddEntityInf("EngineLaser", "Engine Laser (HC)")


mod:AddEntityInf("Theia", "Theia (HC)")
mod:AddEntityInf("RuneMeteor", "Rune Meteor (HC)")
mod:AddEntityInf("MeteorRune", "Meteor Rune (HC)")


mod:AddEntityInf("Hyperdice", "Hyperdice (HC)")
mod:AddEntityInf("Hypersquare", "Hypersqueare (HC)")
mod:AddEntityInf("Hyperhole", "Hypersquare (HC)")
mod:AddEntityInf("Hyperfloor", "Hyperfloor generator (HC)")


mod:AddEntityInf("PickupFamiliar", "Penny Orbital (HC)")

mod:AddEntityInf("LilSol", "Moon Sol (HC)")


mod:AddEntityInf("TransformLight", "Transform Light (HC)")


mod:AddEntityInf("GlassHeart", "Glass Heart (HC)")


mod:AddEntityInf("Friend", "Friend (HC)")
mod:AddEntityInf("FriendHook", "Friend Hook (HC)")

mod:AddEntityInf("FleshWhip", "Flesh Whip (HC)")
mod:AddEntityInf("Teratomato", "Teratomato")

mod:AddEntityInf("NeptuneMirrorTimer", "Neptune Mirror Timer (HC)")

--MOUNT THINGS--------------------------------------------------------------------------------------------
mod:AddEntityInf("SnakeHead", "Snake head (HC)")
mod:AddEntityInf("SnakeBody", "Snake body (HC)")


--BLABLA
function mod:SetPlanetNames(lenguaje)
    if lenguaje == "es" then
        mod.PlanetName = {
            [mod.Entity.Jupiter] = "Jupiter el Colosal",
            [mod.Entity.Saturn] = "Saturno la Intransigente",
            [mod.Entity.Uranus] = "Urano el Desagradable",
            [mod.Entity.Neptune] = "Neptuno el Insondable",
            
            [mod.Entity.Mercury] = "Mercurio el Imprudente",
            [mod.Entity.Venus] = "Venus la Arpía",
            [mod.Entity.Terra1] = "Terra la Fatalista",
            [mod.Entity.Mars] = "Marte el Vanaglorioso",
            
            [mod.Entity.Luna] = "Luna la Corrupta",
            [mod.Entity.Pluto] = "Plutón el Frivolo",
            [mod.Entity.Charon1] = "Caronte el Entumecido",
            [mod.Entity.Eris] = "Eris la Vehemente",
            [mod.Entity.Makemake] = "Makemake el Flemático",
            [mod.Entity.Haumea] = "Haumea la Cohibida",
            [mod.Entity.Ceres] = "Ceres el Cauterizado",
            [mod.Entity.Errant] = "El Errante",
            
            [mod.Entity.Sol] = "Sol el Abosluto",
            [mod.Entity.RSaturn] = "Otro Saturno",
            
        }
    else
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
            [mod.Entity.Ceres] = "Ceres the Cauterized",
            [mod.Entity.Errant] = "The Errant",
            
            [mod.Entity.Sol] = "Sol the Absolute",
            [mod.Entity.RSaturn] = "Another Saturn",
            
        }
    end

    mod.PlanetName2 = {
        [Isaac.GetEntityTypeByName("Jupiter the Gargantuan")] = mod.PlanetName[mod.Entity.Jupiter],
        [Isaac.GetEntityTypeByName("Saturn the Intransigent")] = mod.PlanetName[mod.Entity.Saturn],
        [Isaac.GetEntityTypeByName("Uranus the Unpleasant")] = mod.PlanetName[mod.Entity.Uranus],
        [Isaac.GetEntityTypeByName("Neptune the Unfathomable")] = mod.PlanetName[mod.Entity.Neptune],
        
        [Isaac.GetEntityTypeByName("Mercury the Unwary")] = mod.PlanetName[mod.Entity.Mercury],
        [Isaac.GetEntityTypeByName("Venus the Termagant")] = mod.PlanetName[mod.Entity.Venus],
        [Isaac.GetEntityTypeByName("Terra the Fatalist (Green)")] = mod.PlanetName[mod.Entity.Terra1],
        [Isaac.GetEntityTypeByName("Mars the Vainglorious")] = mod.PlanetName[mod.Entity.Mars],
        
        [Isaac.GetEntityTypeByName("Luna the Tainted")] = mod.PlanetName[mod.Entity.Luna],
        [Isaac.GetEntityTypeByName("Pluto the Frivolous")] = mod.PlanetName[mod.Entity.Pluto],
        [Isaac.GetEntityTypeByName(" Charon the Benumbed ")] = mod.PlanetName[mod.Entity.Charon1],
        [Isaac.GetEntityTypeByName("Eris the Vehement")] = mod.PlanetName[mod.Entity.Eris],
        [Isaac.GetEntityTypeByName("Makemake the Phlegmatic")] = mod.PlanetName[mod.Entity.Makemake],
        [Isaac.GetEntityTypeByName("Haumea the Diffident")] = mod.PlanetName[mod.Entity.Haumea],
        [Isaac.GetEntityTypeByName("Ceres the Cauterized")] = mod.PlanetName[mod.Entity.Ceres],
        [Isaac.GetEntityTypeByName("The Errant")] = mod.PlanetName[mod.Entity.Errant],
        
        [Isaac.GetEntityTypeByName("Sol the Absolute")] = mod.PlanetName[mod.Entity.Sol],
        [Isaac.GetEntityTypeByName("Ouroboros (Paradox Saturn)")] = mod.PlanetName[mod.Entity.RSaturn],
        
    }
end
mod:SetPlanetNames(Options.Language)
