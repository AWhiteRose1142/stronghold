--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x0332E018 ]
	table [ "type" ] = "archer"
	table [ "health" ] = 10
	table [ "position" ] = objects [ 0x0332E540 ]

	table = objects [ 0x0332E0B8 ]
	table [ "enemyEntities" ] = objects [ 0x0332E310 ]
	table [ "player" ] = objects [ 0x0332E158 ]

	table = objects [ 0x0332E0E0 ]
	table [ 1 ]	= -125.33316232761
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x0332E158 ]
	table [ "entities" ] = objects [ 0x0332E248 ]
	table [ "stats" ] = objects [ 0x0332E450 ]

	table = objects [ 0x0332E180 ]
	table [ 1 ]	= objects [ 0x0332E798 ]
	table [ 2 ]	= objects [ 0x0332E658 ]
	table [ 3 ]	= objects [ 0x0332E888 ]
	table [ 4 ]	= objects [ 0x0332E900 ]

	table = objects [ 0x0332E248 ]
	table [ "archers" ] = objects [ 0x0332E298 ]
	table [ "sorcerer" ] = objects [ 0x0332E4A0 ]
	table [ "walls" ] = objects [ 0x0332E180 ]
	table [ "tower" ] = objects [ 0x0332E270 ]

	table = objects [ 0x0332E270 ]

	table = objects [ 0x0332E298 ]
	table [ 1 ]	= objects [ 0x0332E018 ]

	table = objects [ 0x0332E310 ]
	table [ "orcs" ] = objects [ 0x0332E4C8 ]
	table [ "skeletons" ] = objects [ 0x0332E360 ]
	table [ "footmen" ] = objects [ 0x0332E338 ]

	table = objects [ 0x0332E338 ]
	table [ 1 ]	= objects [ 0x0332E3B0 ]

	table = objects [ 0x0332E360 ]

	table = objects [ 0x0332E3B0 ]
	table [ "type" ] = "footman"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x0332E428 ]

	table = objects [ 0x0332E400 ]
	table [ "type" ] = "orc"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x0332E0E0 ]

	table = objects [ 0x0332E428 ]
	table [ 1 ]	= -145.3331583639
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x0332E450 ]
	table [ "score" ] = 1

	table = objects [ 0x0332E4A0 ]
	table [ 1 ]	= objects [ 0x0332E4F0 ]

	table = objects [ 0x0332E4C8 ]
	table [ 1 ]	= objects [ 0x0332E400 ]

	table = objects [ 0x0332E4F0 ]
	table [ "type" ] = "sorcerer"
	table [ "health" ] = 15
	table [ "position" ] = objects [ 0x0332E8D8 ]

	table = objects [ 0x0332E540 ]
	table [ 1 ]	= -185.99999575317
	table [ 2 ]	= -76.999995611608

	table = objects [ 0x0332E568 ]
	table [ 1 ]	= -185.99999575317
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x0332E5E0 ]
	table [ 1 ]	= -170.0000025481
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x0332E658 ]
	table [ "height" ] = 2
	table [ "type" ] = "wall"
	table [ "health" ] = 132
	table [ "position" ] = objects [ 0x0332E568 ]

	table = objects [ 0x0332E720 ]
	table [ 1 ]	= -218.00000028312
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x0332E798 ]
	table [ "height" ] = 1
	table [ "type" ] = "wall"
	table [ "health" ] = 82
	table [ "position" ] = objects [ 0x0332E5E0 ]

	table = objects [ 0x0332E860 ]
	table [ 1 ]	= -202.00000707805
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x0332E888 ]
	table [ "height" ] = 3
	table [ "type" ] = "wall"
	table [ "health" ] = 182
	table [ "position" ] = objects [ 0x0332E860 ]

	table = objects [ 0x0332E8D8 ]
	table [ 1 ]	= -214.99999362975
	table [ 2 ]	= -44.000003963709

	table = objects [ 0x0332E900 ]
	table [ "height" ] = 4
	table [ "type" ] = "wall"
	table [ "health" ] = 232
	table [ "position" ] = objects [ 0x0332E720 ]

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x0332E018 ] = {},
	[ 0x0332E0B8 ] = {},
	[ 0x0332E0E0 ] = {},
	[ 0x0332E158 ] = {},
	[ 0x0332E180 ] = {},
	[ 0x0332E248 ] = {},
	[ 0x0332E270 ] = {},
	[ 0x0332E298 ] = {},
	[ 0x0332E310 ] = {},
	[ 0x0332E338 ] = {},
	[ 0x0332E360 ] = {},
	[ 0x0332E3B0 ] = {},
	[ 0x0332E400 ] = {},
	[ 0x0332E428 ] = {},
	[ 0x0332E450 ] = {},
	[ 0x0332E4A0 ] = {},
	[ 0x0332E4C8 ] = {},
	[ 0x0332E4F0 ] = {},
	[ 0x0332E540 ] = {},
	[ 0x0332E568 ] = {},
	[ 0x0332E5E0 ] = {},
	[ 0x0332E658 ] = {},
	[ 0x0332E720 ] = {},
	[ 0x0332E798 ] = {},
	[ 0x0332E860 ] = {},
	[ 0x0332E888 ] = {},
	[ 0x0332E8D8 ] = {},
	[ 0x0332E900 ] = {},

}

init ( objects )

--Returning Tables
return objects [ 0x0332E0B8 ]
