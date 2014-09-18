require "helpers/footman"
require "helpers/wall"
require "resource_definitions"
require "resource_manager"
require "helpers/wall"

--=============================================
-- Setup
--=============================================

--Variables
gameName = "Stronghold"
gameWidth = 800
gameHeight = 460
MOAISim.openWindow(gameName, gameWidth, gameHeight)

--Viewport for the game
gameViewport = MOAIViewport.new()
gameViewport:setSize(gameWidth, gameHeight)
gameViewport:setScale(gameWidth, gameHeight)

--Background layer, meant for wallpaper and information boxes
backgroundLayer = MOAILayer2D.new()
backgroundLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(backgroundLayer)

--Active layer, meant for walls, player and enemy sprites
activeLayer = MOAILayer2D.new()
activeLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(activeLayer)

--User (interface) layer, meant for player control
userLayer = MOAILayer2D.new()
userLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(userLayer)

--=============================================
-- Enemies
--=============================================
footmanArray = {}

--=============================================
-- Resource definitions
--=============================================

local resource_definitions = {
  wallTop = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'wall_top.png', 
    width = 16, height = 16,
  },
  background = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'wall_middle.png', 
    width = 16, height = 16,
  },background = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_base.png', 
    width = 16, height = 16,
  },
  archer = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/archer_sheet.png',
    tileMapSize = {4, 1},
    width = 16, height = 16,
  },
}

--=============================================
-- Game start
--=============================================

ResourceDefinitions:setDefinitions ( resource_definitions )

function footmanSpawn()
  table.insert(footmanArray, footman(360, -160, activeLayer))
end

function footmanMove()
  for i = 1, table.getn(footmanArray), 1 do
    footman:move()
  end
end

--footman1 = footman(360, -160, activeLayer)

--=============================================
-- Gameloop ( in the future )
--=============================================

MOAIGfxDevice.getFrameBuffer():setClearColor(1,1,1,1)