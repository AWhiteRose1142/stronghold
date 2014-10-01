
require "resource_definitions"
require "resource_manager"
require "config"
require "physics_manager"
require "input_manager"
require "level"
require "hud"
require "helpers/wall"
require "helpers/footman"
require "helpers/sorcerer"
require "helpers/bolt"
require "helpers/line"
require "gesture"
require "helpers/fireball"

--=============================================
-- Resource types
--=============================================

RESOURCE_TYPE_IMAGE     = 1
RESOURCE_TYPE_TILESHEET = 2
RESOURCE_TYPE_FONT      = 3
RESOURCE_TYPE_SOUND     = 4

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
