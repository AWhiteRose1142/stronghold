
require "resource_definitions"
require "resource_manager"
require "config"
require "physics_manager"
require "input_manager"
require "level"
require "hud"
require "menu_main"
require "upgrade_menu"
require "gesture"
require "wave_generator"
require "player"
require "soundmachine"
require "helpers/wall"
require "helpers/tower"
require "helpers/footman"
require "helpers/sorcerer"
require "helpers/bolt"
require "helpers/line"
require "helpers/archer"
require "helpers/fireball"
require "helpers/ice_bolt"
require "helpers/orc"
require "helpers/imp"
require "helpers/arrow"
require "helpers/goblin"
require "helpers/crossbolt"
require "helpers/button"
require "helpers/manabar"
require "helpers/floatyText"
require "helpers/tut_prompt"

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
MOAISim.openWindow( GAMENAME, WORLDRES_X, WORLDRES_Y)

DEVICE_WIDTH, DEVICE_HEIGHT = MOAIGfxDevice.getViewSize()

local gameAspect = WORLDRES_Y / WORLDRES_X
local realAspect = DEVICE_HEIGHT / DEVICE_WIDTH

if realAspect > gameAspect then
  SCREEN_WIDTH = DEVICE_WIDTH
  SCREEN_HEIGHT = DEVICE_WIDTH * gameAspect
else
  SCREEN_WIDTH = DEVICE_HEIGHT / gameAspect
  SCREEN_HEIGHT = DEVICE_HEIGHT
end

if SCREEN_WIDTH < DEVICE_WIDTH then
  SCREEN_X_OFFSET = ( DEVICE_WIDTH - SCREEN_WIDTH ) * 0.5
end

if SCREEN_HEIGHT < DEVICE_HEIGHT then
  SCREEN_Y_OFFSET = ( DEVICE_HEIGHT - SCREEN_HEIGHT ) * 0.5
end

gameViewport = MOAIViewport.new()
gameViewport:setSize( SCREEN_X_OFFSET, SCREEN_Y_OFFSET, SCREEN_X_OFFSET + SCREEN_WIDTH, SCREEN_Y_OFFSET + SCREEN_HEIGHT )
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
