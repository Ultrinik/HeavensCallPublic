local mod = HeavensCall
local game = Game()
local rng = mod:GetRunRNG()
local sfx = SFXManager()

mod.Trinkets = {
	Sputnik = Isaac.GetTrinketIdByName("Sputnik"),
	Flag = Isaac.GetTrinketIdByName("Faded Flag"),

	Void = Isaac.GetTrinketIdByName("​​​Void Matter"),
	Noise = Isaac.GetTrinketIdByName("Background Noise"),

	BismuthPenny = Isaac.GetTrinketIdByName("Bismuth Penny"),
	Incense = Isaac.GetTrinketIdByName("Fervent Incense"),
	BadApple = Isaac.GetTrinketIdByName("Bad Apple"),
	Nanite = Isaac.GetTrinketIdByName("Nanite"),
	Battery = Isaac.GetTrinketIdByName("Broken Battery"),
	Gear = Isaac.GetTrinketIdByName("Golden Gear"),
	ClayBrick = Isaac.GetTrinketIdByName("Clay Brick"),
	Lure = Isaac.GetTrinketIdByName("Neptune's Lure"),
	Effigy = Isaac.GetTrinketIdByName("Cursed Effigy"),
	Crown = Isaac.GetTrinketIdByName("Lunar Crown"),
	Sol = Isaac.GetTrinketIdByName("Fine Tuning"),
	i = Isaac.GetTrinketIdByName("i"),

	Shard = Isaac.GetTrinketIdByName("Quantum Shard"),
}

mod.Trash = {
	Soldier = Isaac.GetTrinketIdByName("Toy Soldier"),
	Silver = Isaac.GetTrinketIdByName("Mirror Shard"),
}



include("scripts.items.trinkets.quantumshard")
include("scripts.items.trinkets.fadedflag")
include("scripts.items.trinkets.sputnik")
include("scripts.items.trinkets.voidmatter")


include("scripts.items.trinkets.bismuthpenny")
include("scripts.items.trinkets.incense")
include("scripts.items.trinkets.badapple")
include("scripts.items.trinkets.nanite")
include("scripts.items.trinkets.battery")
include("scripts.items.trinkets.goldengear")
include("scripts.items.trinkets.claybrick")
include("scripts.items.trinkets.lure")
include("scripts.items.trinkets.effigy")
include("scripts.items.trinkets.crown")
include("scripts.items.trinkets.i")
include("scripts.items.trinkets.sol")
