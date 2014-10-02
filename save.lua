--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x031E2088 ]
	table [ 1 ]	= objects [ 0x031E2420 ]

	table = objects [ 0x031E20D8 ]
	table [ 1 ]	= 2
	table [ 2 ]	= 60

	table = objects [ 0x031E2100 ]
	table [ 1 ]	= objects [ 0x031E29E8 ]
	table [ 2 ]	= objects [ 0x031E2920 ]
	table [ 3 ]	= objects [ 0x031E26F0 ]
	table [ 4 ]	= objects [ 0x031E2628 ]

	table = objects [ 0x031E21C8 ]
	table [ "type" ] = "footman"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x031E23A8 ]

	table = objects [ 0x031E2268 ]
	table [ "entities" ] = objects [ 0x031E2308 ]
	table [ "stats" ] = objects [ 0x031E23F8 ]

	table = objects [ 0x031E2290 ]
	table [ "orcs" ] = objects [ 0x031E22E0 ]
	table [ "skeletons" ] = objects [ 0x031E2510 ]
	table [ "footmen" ] = objects [ 0x031E2330 ]

	table = objects [ 0x031E22E0 ]
	table [ 1 ]	= objects [ 0x031E2470 ]

	table = objects [ 0x031E2308 ]
	table [ "archers" ] = objects [ 0x031E2358 ]
	table [ "sorcerer" ] = objects [ 0x031E2088 ]
	table [ "walls" ] = objects [ 0x031E2100 ]
	table [ "tower" ] = objects [ 0x031E2498 ]

	table = objects [ 0x031E2330 ]
	table [ 1 ]	= objects [ 0x031E21C8 ]

	table = objects [ 0x031E2358 ]

	table = objects [ 0x031E23A8 ]
	table [ 1 ]	= -115.9999371469
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x031E23D0 ]
	table [ "enemyEntities" ] = objects [ 0x031E2290 ]
	table [ "player" ] = objects [ 0x031E2268 ]

	table = objects [ 0x031E23F8 ]
	table [ "score" ] = 1

	table = objects [ 0x031E2420 ]
	table [ "type" ] = "sorcerer"
	table [ "health" ] = 15
	table [ "position" ] = objects [ 0x031E20D8 ]

	table = objects [ 0x031E2470 ]
	table [ "type" ] = "orc"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x031E24C0 ]

	table = objects [ 0x031E2498 ]

	table = objects [ 0x031E24C0 ]
	table [ 1 ]	= -95.999941110611
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x031E2510 ]

	table = objects [ 0x031E2628 ]
	table [ "height" ] = 4
	table [ "type" ] = "wall"
	table [ "health" ] = 232
	table [ "position" ] = objects [ 0x031E2A38 ]

	table = objects [ 0x031E26F0 ]
	table [ "height" ] = 3
	table [ "type" ] = "wall"
	table [ "health" ] = 182
	table [ "position" ] = objects [ 0x031E29C0 ]

	table = objects [ 0x031E27B8 ]
	table [ 1 ]	= -185.99999575317
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x031E2880 ]
	table [ 1 ]	= -170.0000025481
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x031E2920 ]
	table [ "height" ] = 2
	table [ "type" ] = "wall"
	table [ "health" ] = 132
	table [ "position" ] = objects [ 0x031E27B8 ]

	table = objects [ 0x031E29C0 ]
	table [ 1 ]	= -202.00000707805
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x031E29E8 ]
	table [ "height" ] = 1
	table [ "type" ] = "wall"
	table [ "health" ] = 82
	table [ "position" ] = objects [ 0x031E2880 ]

	table = objects [ 0x031E2A38 ]
	table [ 1 ]	= -218.00000028312
	table [ 2 ]	= -120.00000339746

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x031E2088 ] = {},
	[ 0x031E20D8 ] = {},
	[ 0x031E2100 ] = {},
	[ 0x031E21C8 ] = {},
	[ 0x031E2268 ] = {},
	[ 0x031E2290 ] = {},
	[ 0x031E22E0 ] = {},
	[ 0x031E2308 ] = {},
	[ 0x031E2330 ] = {},
	[ 0x031E2358 ] = {},
	[ 0x031E23A8 ] = {},
	[ 0x031E23D0 ] = {},
	[ 0x031E23F8 ] = {},
	[ 0x031E2420 ] = {},
	[ 0x031E2470 ] = {},
	[ 0x031E2498 ] = {},
	[ 0x031E24C0 ] = {},
	[ 0x031E2510 ] = {},
	[ 0x031E2628 ] = {},
	[ 0x031E26F0 ] = {},
	[ 0x031E27B8 ] = {},
	[ 0x031E2880 ] = {},
	[ 0x031E2920 ] = {},
	[ 0x031E29C0 ] = {},
	[ 0x031E29E8 ] = {},
	[ 0x031E2A38 ] = {},

}

init ( objects )

--Returning Tables
return objects [ 0x031E23D0 ]
