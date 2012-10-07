local E, L, V, P, G = unpack(select(2, ...)); --Engine

G['extracd']['data'] = {
	-- talent
		-- type = "talent" 
		-- talent = the location of the talent(from 1 to 18)
	-- monk
	[121283] = {
		desc = "",
		type = "talent",
		class = "MONK",
		talent = 7,
		cd = 20,
	}, -- Power Strike
	[122281] = {
		desc = "",
		type = "talent",
		class = "MONK",
		talent = 13,
		cd = 15,
	}, -- Healing Elixirs
	-- shaman
	[31616] = {
		desc = "",
		type = "talent",
		class = "SHAMAN",
		talent = 1,
		cd = 30,
		duration = 10,
	}, -- Nature's Guardian
	
	-- mage
	[87023] = {
		desc = "",
		type = "talent",
		class = "MAGE",
		talent = 11,
		cd = 120,
		duration = 6,
	}, -- Cauterize
	
	-- rogue
	[45182] = {
		desc = "",
		type = "talent",
		class = "ROGUE",
		talent = 7,
		cd = 90,
		duration = 3,
	}, -- Cheated Death
	
	-- priest
	[114214] = {
		desc = "",
		type = "talent",
		class = "PRIEST",
		talent = 12,
		cd = 90,
	}, -- Angelic Bulwark
	
	-- dk
	[116888] = {
		desc = "",
		type = "talent",
		class = "DEATHKNIGHT",
		talent = 6,
		cd = 180,
		duration = 3,
	}, -- Purgatory	
	
-- spec
	-- type = "spec" 
	-- spec = {the numbers of the spec(from 1 to 3(4 for druid))}
	-- druid
	[34299] = {
		desc = "",
		type = "spec",
		class = "DRUID",
		spec = {2, 3},
		cd = 6,
	}, -- Leader of the Pack
	
	-- hunter
	[56453] = {
		desc = "",
		type = "spec",
		class = "HUNTER",
		spec = {3},
		cd = 10,
	}, -- Lock and Load
	
	-- priest
	[47755] = {
		desc = "",
		type = "spec",
		class = "PRIEST",
		spec = {1},
		cd = 12,
	}, -- Rapture
	
	--dk
	[96171] = {
		desc = "",
		type = "spec",
		class = "DEATHKNIGHT",
		spec = {1},
		cd = 45,
		duration = 8,
	}, -- Will of the Necropolis	

	
-- item
	-- type = "item" 
	-- item = {the item id}
	
	-- Cataclysm 4.3
	-- Ti'tahk, the Steps of Time
	[109844] = {
		desc = "",
		type = "item",
		item = {78477},
		cd = 45,
		duration = 10,
	}, -- H
	[107804] = {
		desc = "",
		type = "item",
		item = {77190},
		cd = 45,
		duration = 10,
	}, -- N
	[109842] = {
		desc = "",
		type = "item",
		item = {78486},
		cd = 45,
		duration = 10,
	}, -- LFR
	-- Maw of the Dragonlord
	[109849] = {
		desc = "",
		type = "item",
		item = {78476},
		cd = 15
	}, -- H
	[107835] = {
		desc = "",
		type = "item",
		item = {77196},
		cd = 15
	}, -- N
	[109847] = {
		desc = "",
		type = "item",
		item = {78485},
		cd = 15
	}, -- LFR
	-- Rathrak, the Poisonous Mind
	[109854] = {
		desc = "",
		type = "item",
		item = {78475},
		cd = 15,
		duration = 10,
	}, -- H
	[107831] = {
		desc = "",
		type = "item",
		item = {77195},
		cd = 15,
		duration = 10,
	}, -- N
	[109851] = {
		desc = "",
		type = "item",
		item = {78484},
		cd = 15,
		duration = 10,
	}, -- LFR
	-- Kiril, Fury of Beasts
	[109864] = {
		desc = "",
		type = "item",
		item = {78473},
		cd = 55,
		duration = 20,
	}, -- H
	[108011] = {
		desc = "",
		type = "item",
		item = {77194},
		cd = 55,
		duration = 20,
	}, -- N
	[109861] = {
		desc = "",
		type = "item",
		item = {78482},
		cd = 55,
		duration = 20,
	}, -- LFR
	-- Creche of the Final Dragon
	[109744] = {
		desc = "",
		type = "item",
		item = {77992},
		cd = 100,
		duration = 20,
	}, -- H
	[107988] = {
		desc = "",
		type = "item",
		item = {77205},
		cd = 100,
		duration = 20,
	}, -- N
	[109742] = {
		desc = "",
		type = "item",
		item = {77972},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Indomitable Pride
	[108008] = {
		desc = "",
		type = "item",
		item = {78003, 77211, 77983},
		cd = 60,
		duration = 6,
	}, 
	-- Insignia of the Corrupted Mind
	[109789] = {
		desc = "",
		type = "item",
		item = {77991},
		cd = 100,
		duration = 20,
	}, -- H
	[107982] = {
		desc = "",
		type = "item",
		item = {77203, 77204, 77202},
		cd = 100,
		duration = 20,
	}, -- N Starcatcher Compass and Insignia of the Corrupted Mind and Seal of the Seven Signs
	[109787] = {
		desc = "",
		type = "item",
		item = {77971},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Seal of the Seven Signs
	[109804] = {
		desc = "",
		type = "item",
		item = {77989},
		cd = 100,
		duration = 20,
	}, -- H
	[109802] = {
		desc = "",
		type = "item",
		item = {77969},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Soulshifter Vortex
	[109776] = {
		desc = "",
		type = "item",
		item = {77990},
		cd = 100,
		duration = 20,
	}, -- H
	[107986] = {
		desc = "",
		type = "item",
		item = {77206},
		cd = 100,
		duration = 20,
	}, -- N
	[109774] = {
		desc = "",
		type = "item",
		item = {77970},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Starcatcher Compass
	[109711] = {
		desc = "",
		type = "item",
		item = {77993},
		cd = 100,
		duration = 20,
	}, -- H
	[109709] = {
		desc = "",
		type = "item",
		item = {77973},
		cd = 100,
		duration = 20,
	}, -- LFR
	-- Windward Heart
	[109825] = {
		desc = "",
		type = "item",
		item = {78001},
		cd = 25,
	}, -- H
	[108000] = {
		desc = "",
		type = "item",
		item = {77209},
		cd = 25
	}, -- N
	[109822] = {
		desc = "",
		type = "item",
		item = {77981},
		cd = 25
	}, -- LFR
	
	-- Bone-Link Fetish
	[109754] = {
		desc = "",
		type = "item",
		item = {78002},
		cd = 25
	}, -- H
	[107997] = {
		desc = "",
		type = "item",
		item = {77210},
		cd = 25
	}, -- N
	[109752] = {
		desc = "",
		type = "item",
		item = {77982},
		cd = 25
	}, -- LFR
	-- Cunning of the Cruel
	[109800] = {
		desc = "",
		type = "item",
		item = {78000},
		cd = 10}, -- H
	[108005] = {
		desc = "",
		type = "item",
		item = {77208},
		cd = 10
	}, -- N
	[109798] = {
		desc = "",
		type = "item",
		item = {77980},
		cd = 10
	}, -- LFR
	-- Vial of Shadows
	[109724] = {
		desc = "",
		type = "item",
		item = {77999},
		cd = 10
	}, -- H
	[107994] = {
		desc = "",
		type = "item",
		item = {77207},
		cd = 10
	}, -- N
	[109721] = {
		desc = "",
		type = "item",
		item = {77979},
		cd = 10
	}, -- LFR
	-- S11 PVP
	[105135] = {
		desc = "",
		type = "item",
		item = {73643},
		cd = 50,
		duration = 20,
	},
	[105137] = {
		desc = "",
		type = "item",
		item = {73497},
		cd = 50,
		duration = 20,
	},
	[105139] = {
		desc = "",
		type = "item",
		item = {73491},
		cd = 50,
		duration = 20,
	},
	
	[102439] = {
		desc = "",
		type = "item",
		item = {72309},
		cd = 50,
		duration = 20,
	},
	[102435] = {
		desc = "",
		type = "item",
		item = {72449},
		cd = 50,
		duration = 20,
	},
	[102432] = {
		desc = "",
		type = "item",
		item = {72455},
		cd = 50,
		duration = 20,
	},
	
	-- 378 others
	[102659] = {
		desc = "",
		type = "item",
		item = {72897},
		cd = 50,
		duration = 20,
	},
	[102662] = {
		desc = "",
		type = "item",
		item = {72898},
		cd = 50,
		duration = 20,
	},
	[102664] = {
		desc = "",
		type = "item",
		item = {72899},
		cd = 50,
		duration = 20,
	},
	
	[109993] = {
		desc = "",
		type = "item",
		item = {74035},
		cd = 50,
		duration = 20,
	},
	[102660] = {
		desc = "",
		type = "item",
		item = {72901},
		cd = 50,
		duration = 20,
	},
	[102667] = {
		desc = "",
		type = "item",
		item = {72900},
		cd = 50,
		duration = 20,
	},
	
	-- Cataclysm Raid T12 378 - 397
	-- Matrix Restabilizer H
	[97139] = {
		desc = "",
		type = "item",
		item = {69150},
		cd = 105,
		duration = 30,
	},
	[97140] = {
		desc = "",
		type = "item",
		item = {69150},
		cd = 105,
		duration = 30,
	},
	[97141] = {
		desc = "",
		type = "item",
		item = {69150},
		cd = 105,
		duration = 30,
	},
	-- Matrix Restabilizer
	[96978] = {
		desc = "",
		type = "item",
		item = {68994},
		cd = 105,
		duration = 30,
	},
	[96977] = {
		desc = "",
		type = "item",
		item = {68994},
		cd = 105,
		duration = 30,
	},
	[96979] = {
		desc = "",
		type = "item",
		item = {68994},
		cd = 105,
		duration = 30,
	},
	[97136] = {
		desc = "",
		type = "item",
		item = {69149},
		cd = 45
	}, -- Eye of Blazing Power H
	[96966] = {
		desc = "",
		type = "item",
		item = {68983},
		cd = 45
	}, -- Eye of Blazing Power
	[97129] = {
		desc = "",
		type = "item",
		item = {69138},
		cd = 60
	}, -- Spidersilk Spindle H
	[96945] = {
		desc = "",
		type = "item",
		item = {68981},
		cd = 60
	}, -- Spidersilk Spindle
	[97125] = {
		desc = "",
		type = "item",
		item = {69112},
		cd = 60,
		duration = 15,
	}, -- The Hungerer H
	[96911] = {
		desc = "",
		type = "item",
		item = {68927},
		cd = 60,
		duration = 15,
	}, -- The Hungerer
	
	-- S10 PVP
	[99721] = {
		desc = "",
		type = "item",
		item = {70579},
		cd = 50,
		duration = 20,
	},
	[99719] = {
		desc = "",
		type = "item",
		item = {70578},
		cd = 50,
		duration = 20,
	},
	[99717] = {
		desc = "",
		type = "item",
		item = {70577},
		cd = 50,
		duration = 20,
	},
	[99742] = {
		desc = "",
		type = "item",
		item = {70402},
		cd = 50,
		duration = 20,
	},
	[99748] = {
		desc = "",
		type = "item",
		item = {70404},
		cd = 50,
		duration = 20,
	},
	[99746] = {
		desc = "",
		type = "item",
		item = {70403},
		cd = 50,
		duration = 20,
	},
	
	-- Festival Trinket 365
	[101289] = {
		desc = "",
		type = "item",
		item = {71336},
		cd = 50,
		duration = 10,
	}, -- Petrified Pickled Egg
	[101291] = {
		desc = "",
		type = "item",
		item = {71337},
		cd = 50,
		duration = 10,
	}, -- Mithril Stopwatch
	[101287] = {
		desc = "",
		type = "item",
		item = {71335},
		cd = 50,
		duration = 10,
	}, -- Coren's Chilled Chromium Coaster
	
	-- Mount Hyjal 365
	[100322] = {
		desc = "",
		type = "item",
		item = {70141},
		cd = 45,
		duration = 20,
	}, -- Dwyer's Caber
	
	-- Darkmoon Cards
	[89091] = {
		desc = "",
		type = "item",
		item = {62047},
		cd = 45,
		duration = 12,
	}, -- Darkmoon Card: Volcano

	-- Tol Barad factions
	[91192] = {
		desc = "",
		type = "item",
		item = {62467, 62472},
		cd = 50,
		duration = 10
	}, -- Mandala of Stirring Patterns
	[91047] = {
		desc = "",
		type = "item",
		item = {62465, 62470},
		cd = 75,
		duration = 15
	}, -- Stump of Time

	-- Valour Vendor 4.0
	[92233] = {
		desc = "",
		type = "item",
		item = {58182},
		cd = 30,
		duration = 10,
	}, -- Bedrock Talisman

	-- Cataclysm Raid 372
	[92320] = {
		desc = "",
		type = "item",
		item = {65105},
		cd = 90,
		duration = 20,
	}, -- Theralion's Mirror
	[92355] = {
		desc = "",
		type = "item",
		item = {65048},
		cd = 30,
		duration = 10,
	}, -- Symbiotic Worm
	[92349] = {
		desc = "",
		type = "item",
		item = {65026},
		cd = 75,
		duration = 15,
	}, -- Prestor's Talisman of Machination
	[92345] = {
		desc = "",
		type = "item",
		item = {65072},
		cd = 100,
		duration = 20,
	}, -- Heart of Rage
	[92332] = {
		desc = "",
		type = "item",
		item = {65124},
		cd = 75,
		duration = 15,
	}, -- Fall of Mortality
	[92351] = {
		desc = "",
		type = "item",
		item = {65140},
		cd = 50,
		duration = 10,
	}, -- Essence of the Cyclone
	[92342] = {
		desc = "",
		type = "item",
		item = {65118},
		cd = 75,
		duration = 15,
	}, -- Crushing Weight
	[92318] = {
		desc = "",
		type = "item",
		item = {65053},
		cd = 100,
		duration = 20,
	}, -- Bell of Enraging Resonance
	
	-- Cataclysm Raid 359
	[92108] = {
		desc = "",
		type = "item",
		item = {59520},
		cd = 50,
		duration = 10,
	}, -- Unheeded Warning
	[91024] = {
		desc = "",
		type = "item",
		item = {59519},
		cd = 90,
		duration = 20,
	}, -- Theralion's Mirror
	[92235] = {
		desc = "",
		type = "item",
		item = {59332},
		cd = 30,
		duration = 10,
	}, -- Symbiotic Worm
	[92124] = {
		desc = "",
		type = "item",
		item = {59441},
		cd = 75,
		duration = 15,
	}, -- Prestor's Talisman of Machination
	[91816] = {
		desc = "",
		type = "item",
		item = {59224},
		cd = 100,
		duration = 20,
	}, -- Heart of Rage
	[91184] = {
		desc = "",
		type = "item",
		item = {59500},
		cd = 75,
		duration = 15,
	}, -- Fall of Mortality
	[92126] = {
		desc = "",
		type = "item",
		item = {59473},
		cd = 50,
		duration = 10,
	}, -- Essence of the Cyclone
	[91821] = {
		desc = "",
		type = "item",
		item = {59506},
		cd = 75,
		duration = 15,
	}, -- Crushing Weight
	[91007] = {
		desc = "",
		type = "item",
		item = {59326},
		cd = 100,
		duration = 20,
	}, -- Bell of Enraging Resonance
	
	-- Cataclysm Dungeon 346
	[90992] = {
		desc = "",
		type = "item",
		item = {56407},
		cd = 50,
		duration = 10,
	}, -- Anhuur's Hymnal
	[91149] = {
		desc = "",
		type = "item",
		item = {56414},
		cd = 100,
		duration = 20,
	}, -- Blood of Isiset
	[92087] = {
		desc = "",
		type = "item",
		item = {56295},
		cd = 50,
		duration = 10,
	}, -- Grace of the Herald
	[91364] = {
		desc = "",
		type = "item",
		item = {56393},
		cd = 100,
		duration = 20,
	}, -- Heart of Solace
	[92091] = {
		desc = "",
		type = "item",
		item = {56328},
		cd = 75,
		duration = 15,
	}, -- Key to the Endless Chamber
	[92184] = {
		desc = "",
		type = "item",
		item = {56347},
		cd = 30,
		duration = 10,
	}, -- Leaden Despair
	[92094] = {
		desc = "",
		type = "item",
		item = {56427},
		cd = 50,
		duration = 10,
	}, -- Left Eye of Rajh
	[92174] = {
		desc = "",
		type = "item",
		item = {56280},
		cd = 80,
		duration = 20,
	}, -- Porcelain Crab
	[91143] = {
		desc = "",
		type = "item",
		item = {56377},
		cd = 75,
		duration = 15,
	}, -- Rainsong
	[91368] = {
		desc = "",
		type = "item",
		item = {56431},
		cd = 50,
		duration = 10,
	}, -- Right Eye of Rajh
	[91002] = {
		desc = "",
		type = "item",
		item = {56400},
		cd = 20,
		duration = 10,
	}, -- Sorrowsong
	[91139] = {
		desc = "",
		type = "item",
		item = {56351},
		cd = 75,
		duration = 15,
	}, -- Tear of Blood
	[90898] = {
		desc = "",
		type = "item",
		item = {56339},
		cd = 75,
		duration = 15,
	}, -- Tendrils of Burrowing Dark
	[92205] = {
		desc = "",
		type = "item",
		item = {56449},
		cd = 60,
		duration = 12,
	}, -- Throngus's Finger
	[90887] = {
		desc = "",
		type = "item",
		item = {56320},
		cd = 75,
		duration = 15,
	}, -- Witching Hourglass

	-- Cataclysm Dungeon and World drops 308-333
	[90989] = {
		desc = "",
		type = "item",
		item = {55889},
		cd = 50,
		duration = 10,
	}, -- Anhuur's Hymnal
	[91147] = {
		desc = "",
		type = "item",
		item = {55995},
		cd = 100,
		duration = 20,
	}, -- Blood of Isiset
	[91363] = {
		desc = "",
		type = "item",
		item = {55868},
		cd = 100,
		duration = 20,
	}, -- Heart of Solace
	[92096] = {
		desc = "",
		type = "item",
		item = {56102},
		cd = 50,
		duration = 10,
	}, -- Left Eye of Rajh
	[91370] = {
		desc = "",
		type = "item",
		item = {56100},
		cd = 50,
		duration = 10,
	}, -- Right Eye of Rajh
	[90996] = {
		desc = "",
		type = "item",
		item = {55879},
		cd = 20,
		duration = 10,
	}, -- Sorrowsong
	[92208] = {
		desc = "",
		type = "item",
		item = {56121},
		cd = 60,
		duration = 12,
	}, -- Throngus's Finger
	[92052] = {
		desc = "",
		type = "item",
		item = {66969},
		cd = 50,
		duration = 10,
	}, -- Heart of the Vile
	[92069] = {
		desc = "",
		type = "item",
		item = {55795},
		cd = 75,
		duration = 15,
	}, -- Key to the Endless Chamber
	[92179] = {
		desc = "",
		type = "item",
		item = {55816},
		cd = 30,
		duration = 10,
	}, -- Leaden Despair
	[91141] = {
		desc = "",
		type = "item",
		item = {55854},
		cd = 75,
		duration = 15,
	}, -- Rainsong
	[91138] = {
		desc = "",
		type = "item",
		item = {55819},
		cd = 75,
		duration = 15,
	}, -- Tear of Blood
	[90896] = {
		desc = "",
		type = "item",
		item = {55810},
		cd = 75,
		duration = 15,
	}, -- Tendrils of Burrowing Dark
	[92052] = {
		desc = "",
		type = "item",
		item = {55266},
		cd = 50,
		duration = 10,
	}, -- Grace of the Herald
	[90885] = {
		desc = "",
		type = "item",
		item = {55787},
		cd = 75,
		duration = 15,
	}, -- Witching Hourglass

	-- S9 PvP
	[85027] = {
		desc = "",
		type = "item",
		item = {61045},
		cd = 50,
		duration = 20,
	}, -- Vicious Gladiator's Insignia of Dominance
	[85032] = {
		desc = "",
		type = "item",
		item = {61046},
		cd = 50,
		duration = 20,
	}, -- Vicious Gladiator's Insignia of Victory
	[85022] = {
		desc = "",
		type = "item",
		item = {61047},
		cd = 50,
		duration = 20,
	}, -- Vicious Gladiator's Insignia of Conquest
	[92218] = {
		desc = "",
		type = "item",
		item = {64762},
		cd = 50,
		duration = 20,
	}, -- Bloodthirsty Gladiator's Insignia of Dominance
	[92216] = {
		desc = "",
		type = "item",
		item = {64763},
		cd = 50,
		duration = 20,
	}, -- Bloodthirsty Gladiator's Insignia of Victory
	[92220] = {
		desc = "",
		type = "item",
		item = {64761},
		cd = 50,
		duration = 20,
	}, -- Bloodthirsty Gladiator's Insignia of Conquest		

-- item set
	-- type = "itemset"
	-- items = {all items of this set(including all difficulties)}
	-- piece = the minimum pieces of the item set to get the bonus
	[105919] = {
		type = "itemset",
		class = "HUNTER",
		items = {77028,77029,77030,77031,77032,78793,78832,78756,78769,78804,78698,78737,78661,78674,78709},
		piece = 4,
		cd = 105,
		duration = 15
	}, -- Hunter T13 4P Bonus
	[105582] = {
		type = "itemset",
		class = "DEATHKNIGHT",
		items = {77008,77009,77010,77011,77012,78792,78846,78758,78773,78881,78697,78751,78663,78678,78716},
		piece = 2,
		cd = 45
	}, -- Tank DK T13 2P Bonus 
	[99063] = {
		type = "itemset",
		class = "MAGE",
		items = {71286,71287,71288,71289,71290,71507,71508,71509,71510,71511},
		piece = 2,
		cd = 45,
		duration = 15
	}, -- Mage T12 2P Bonus
	[99221] = {
		type = "itemset",
		class = "WARLOCK",
		items = {71281,71282,71283,71284,71295,71594,71595,71596,71597,71598},
		piece = 2,
		cd = 45,
		duration = 15
	}, -- Warlock T12 2P Bonus
	[99035] = {
		type = "itemset",
		class = "DRUID",
		items = {71107,71108,71109,71110,71111,71496,71497,71498,71499,71500},
		piece = 2,
		cd = 45,
		duration = 15
	}, -- Balance Druid T12 2P Bonus
	[99202] = {
		type = "itemset",
		class = "SHAMAN",
		items = {71552,71553,71554,71555,71556,71291,71292,71293,71294,71295},
		piece = 2,
		cd = 90
	}, -- Elemental Shaman T12 2P Bonus 

-- enchant
	-- type = "enchant",
	-- slot = 16 main hand(two hand have the same enchant may cause mistakes), 15 cloak  
	-- enchant = {enchant Id}
	-- Cataclysm
	[74241] = {
		type = "enchant",
		enchant = {4097},
		slot = 16,
		cd = 45,
		duration = 12
	}, -- Power Torrent
	[99621] = {
		type = "enchant",
		enchant = {4267},
		slot = 16,
		cd = 40,
		duration = 10
	}, -- Flintlocke's Woodchucker
	[74221] = {
		type = "enchant",
		enchant = {4083},
		slot = 16,
		cd = 45,
		duration = 12
	}, -- Hurricane
	[74224] = {
		type = "enchant",
		enchant = {4084},
		slot = 16,
		cd = 20,
		duration = 15
	}, -- Heartsong
	[59626] = {
		type = "enchant",
		enchant = {3790},
		slot = 16,
		cd = 35,
		duration = 10
	}, -- Black Magic
	
	-- MOP
	[125488] = {
		desc = "need test",
		type = "enchant",
		enchant = {4893, 4116, 3728},
		slot = 15,
		cd = 60,
		duration = 15
	},	-- Darkglow Embroidery
	[125489] = {
		desc = "need test",
		type = "enchant",
		enchant = {4894, 3730, 4118},
		slot = 15,
		cd = 60,
		duration = 15
	}, -- Swordguard Embroidery
	[125487] = {
		desc = "need test",
		type = "enchant",
		enchant = {4892, 3722, 4115},
		slot = 15,
		cd = 60,
		duration = 15
	}, -- Lightweave Embroidery
}