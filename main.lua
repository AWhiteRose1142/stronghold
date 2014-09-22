
require "resource_definitions"
require "resource_manager"
require "config"
require "helpers/wall"
require "helpers/footman"
require "helpers/sorcerer"

--=============================================
-- Resource types
--=============================================

RESTYPE_IMAGE     = 1
RESTYPE_TILESHEET = 2
RESTYPE_FONT      = 3
RESTYPE_SOUND     = 4

--=============================================
-- Setup
--=============================================

-- Open a window
MOAISim.openWindow( GAMENAME, SCREENRES_X, SCREENRES_Y)

--Viewport for the game screensize is twee keer zo groot als de world, voor scaling.
gameViewport = MOAIViewport.new()
gameViewport:setSize( SCREENRES_X, SCREENRES_Y )
gameViewport:setScale( WORLDRES_X, WORLDRES_Y )

--=============================================
-- Main loop, starts off the game
--=============================================

require 'game'

function mainLoop()
  Game:start()
end

gameThread = MOAICoroutine.new()
gameThread:run( mainLoop )