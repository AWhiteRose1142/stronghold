--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x034FCA68 ]
	table [ "enemyEntities" ] = objects [ 0x034FCA90 ]
	table [ "player" ] = objects [ 0x034FD210 ]

	table = objects [ 0x034FCA90 ]
	table [ "orcs" ] = objects [ 0x034FCC20 ]
	table [ "skeletons" ] = objects [ 0x034FCD60 ]
	table [ "footmen" ] = objects [ 0x034FCBF8 ]

	table = objects [ 0x034FCB30 ]
	table [ "type" ] = "orc"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x034FCCC0 ]

	table = objects [ 0x034FCB80 ]
	table [ "type" ] = "archer"
	table [ "health" ] = 10
	table [ "position" ] = objects [ 0x034FCF68 ]

	table = objects [ 0x034FCBA8 ]
	table [ "type" ] = "footman"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x034FCCE8 ]

	table = objects [ 0x034FCBF8 ]
	table [ 1 ]	= objects [ 0x034FCBA8 ]

	table = objects [ 0x034FCC20 ]
	table [ 1 ]	= objects [ 0x034FCB30 ]

	table = objects [ 0x034FCCC0 ]
	table [ 1 ]	= -94.333280814191
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x034FCCE8 ]
	table [ 1 ]	= -114.33327685048
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x034FCD60 ]

	table = objects [ 0x034FCEF0 ]
	table [ "height" ] = 2
	table [ "type" ] = "wall"
	table [ "health" ] = 132
	table [ "position" ] = objects [ 0x034FD300 ]

	table = objects [ 0x034FCF68 ]
	table [ 1 ]	= -185.99999575317
	table [ 2 ]	= -76.999995611608

	table = objects [ 0x034FCF90 ]
	table [ "height" ] = 3
	table [ "type" ] = "wall"
	table [ "health" ] = 182
	table [ "position" ] = objects [ 0x034FD260 ]

	table = objects [ 0x034FCFB8 ]
	table [ "score" ] = 1

	table = objects [ 0x034FD008 ]
	table [ 1 ]	= -218.00000028312
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x034FD058 ]
	table [ "type" ] = "sorcerer"
	table [ "health" ] = 15
	table [ "position" ] = objects [ 0x034FD2D8 ]

	table = objects [ 0x034FD0D0 ]
	table [ "height" ] = 4
	table [ "type" ] = "wall"
	table [ "health" ] = 232
	table [ "position" ] = objects [ 0x034FD008 ]

	table = objects [ 0x034FD148 ]
	table [ 1 ]	= objects [ 0x034FD350 ]
	table [ 2 ]	= objects [ 0x034FCEF0 ]
	table [ 3 ]	= objects [ 0x034FCF90 ]
	table [ 4 ]	= objects [ 0x034FD0D0 ]

	table = objects [ 0x034FD210 ]
	table [ "entities" ] = objects [ 0x034FD238 ]
	table [ "stats" ] = objects [ 0x034FCFB8 ]

	table = objects [ 0x034FD238 ]
	table [ "archers" ] = objects [ 0x034FD288 ]
	table [ "sorcerer" ] = objects [ 0x034FD328 ]
	table [ "walls" ] = objects [ 0x034FD148 ]
	table [ "tower" ] = objects [ 0x034FD2B0 ]

	table = objects [ 0x034FD260 ]
	table [ 1 ]	= -202.00000707805
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x034FD288 ]
	table [ 1 ]	= objects [ 0x034FCB80 ]

	table = objects [ 0x034FD2B0 ]

	table = objects [ 0x034FD2D8 ]
	table [ 1 ]	= -214.99999362975
	table [ 2 ]	= -44.000003963709

	table = objects [ 0x034FD300 ]
	table [ 1 ]	= -185.99999575317
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x034FD328 ]
	table [ 1 ]	= objects [ 0x034FD058 ]

	table = objects [ 0x034FD350 ]
	table [ "height" ] = 1
	table [ "type" ] = "wall"
	table [ "health" ] = 82
	table [ "position" ] = objects [ 0x034FD378 ]

	table = objects [ 0x034FD378 ]
	table [ 1 ]	= -170.0000025481
	table [ 2 ]	= -120.00000339746

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x034FCA68 ] = {},
	[ 0x034FCA90 ] = {},
	[ 0x034FCB30 ] = {},
	[ 0x034FCB80 ] = {},
	[ 0x034FCBA8 ] = {},
	[ 0x034FCBF8 ] = {},
	[ 0x034FCC20 ] = {},
	[ 0x034FCCC0 ] = {},
	[ 0x034FCCE8 ] = {},
	[ 0x034FCD60 ] = {},
	[ 0x034FCEF0 ] = {},
	[ 0x034FCF68 ] = {},
	[ 0x034FCF90 ] = {},
	[ 0x034FCFB8 ] = {},
	[ 0x034FD008 ] = {},
	[ 0x034FD058 ] = {},
	[ 0x034FD0D0 ] = {},
	[ 0x034FD148 ] = {},
	[ 0x034FD210 ] = {},
	[ 0x034FD238 ] = {},
	[ 0x034FD260 ] = {},
	[ 0x034FD288 ] = {},
	[ 0x034FD2B0 ] = {},
	[ 0x034FD2D8 ] = {},
	[ 0x034FD300 ] = {},
	[ 0x034FD328 ] = {},
	[ 0x034FD350 ] = {},
	[ 0x034FD378 ] = {},

}

init ( objects )

--Returning Tables
return objects [ 0x034FCA68 ]
