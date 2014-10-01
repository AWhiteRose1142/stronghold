--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x032E38F0 ]
	table [ "archers" ] = objects [ 0x032E3AD0 ]
	table [ "sorcerer" ] = objects [ 0x032E3A80 ]
	table [ "walls" ] = objects [ 0x032E3AF8 ]
	table [ "tower" ] = objects [ 0x032E3918 ]

	table = objects [ 0x032E3918 ]

	table = objects [ 0x032E39B8 ]

	table = objects [ 0x032E39E0 ]
	table [ "type" ] = "footman"
	table [ "health" ] = 6
	table [ "position" ] = objects [ 0x032E3D00 ]

	table = objects [ 0x032E3A08 ]

	table = objects [ 0x032E3A58 ]
	table [ "score" ] = 1

	table = objects [ 0x032E3A80 ]
	table [ 1 ]	= objects [ 0x032E3D28 ]

	table = objects [ 0x032E3AA8 ]
	table [ "enemyEntities" ] = objects [ 0x032E3B48 ]
	table [ "player" ] = objects [ 0x032E3B70 ]

	table = objects [ 0x032E3AD0 ]

	table = objects [ 0x032E3AF8 ]
	table [ 1 ]	= objects [ 0x032E3FF8 ]
	table [ 2 ]	= objects [ 0x032E3EE0 ]
	table [ 3 ]	= objects [ 0x032E4188 ]
	table [ 4 ]	= objects [ 0x032E3E68 ]

	table = objects [ 0x032E3B48 ]
	table [ "skeletons" ] = objects [ 0x032E39B8 ]
	table [ "orks" ] = objects [ 0x032E3A08 ]
	table [ "footmen" ] = objects [ 0x032E3BE8 ]

	table = objects [ 0x032E3B70 ]
	table [ "entities" ] = objects [ 0x032E38F0 ]
	table [ "stats" ] = objects [ 0x032E3A58 ]

	table = objects [ 0x032E3BE8 ]
	table [ 1 ]	= objects [ 0x032E39E0 ]

	table = objects [ 0x032E3D00 ]
	table [ 1 ]	= -124.16657259936
	table [ 2 ]	= -116.4300199417

	table = objects [ 0x032E3D28 ]
	table [ "type" ] = "sorcerer"
	table [ "health" ] = 15
	table [ "position" ] = objects [ 0x032E4228 ]

	table = objects [ 0x032E3DC8 ]
	table [ 1 ]	= -202.00000707805
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x032E3E18 ]
	table [ 1 ]	= -170.0000025481
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x032E3E40 ]
	table [ 1 ]	= -185.99999575317
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x032E3E68 ]
	table [ "height" ] = 4
	table [ "type" ] = "wall"
	table [ "health" ] = 232
	table [ "position" ] = objects [ 0x032E3F08 ]

	table = objects [ 0x032E3EE0 ]
	table [ "height" ] = 2
	table [ "type" ] = "wall"
	table [ "health" ] = 132
	table [ "position" ] = objects [ 0x032E3E40 ]

	table = objects [ 0x032E3F08 ]
	table [ 1 ]	= -218.00000028312
	table [ 2 ]	= -120.00000339746

	table = objects [ 0x032E3FF8 ]
	table [ "height" ] = 1
	table [ "type" ] = "wall"
	table [ "health" ] = 82
	table [ "position" ] = objects [ 0x032E3E18 ]

	table = objects [ 0x032E4188 ]
	table [ "height" ] = 3
	table [ "type" ] = "wall"
	table [ "health" ] = 182
	table [ "position" ] = objects [ 0x032E3DC8 ]

	table = objects [ 0x032E4228 ]
	table [ 1 ]	= 2
	table [ 2 ]	= 60

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x032E38F0 ] = {},
	[ 0x032E3918 ] = {},
	[ 0x032E39B8 ] = {},
	[ 0x032E39E0 ] = {},
	[ 0x032E3A08 ] = {},
	[ 0x032E3A58 ] = {},
	[ 0x032E3A80 ] = {},
	[ 0x032E3AA8 ] = {},
	[ 0x032E3AD0 ] = {},
	[ 0x032E3AF8 ] = {},
	[ 0x032E3B48 ] = {},
	[ 0x032E3B70 ] = {},
	[ 0x032E3BE8 ] = {},
	[ 0x032E3D00 ] = {},
	[ 0x032E3D28 ] = {},
	[ 0x032E3DC8 ] = {},
	[ 0x032E3E18 ] = {},
	[ 0x032E3E40 ] = {},
	[ 0x032E3E68 ] = {},
	[ 0x032E3EE0 ] = {},
	[ 0x032E3F08 ] = {},
	[ 0x032E3FF8 ] = {},
	[ 0x032E4188 ] = {},
	[ 0x032E4228 ] = {},

}

init ( objects )

--Returning Tables
return objects [ 0x032E3AA8 ]
