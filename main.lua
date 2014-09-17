require "helpers.footman"
require "helpers.wall"

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

function footmanSpawn()
  table.insert(footmanArray, footman(360, -160, activeLayer))
end

function footmanMove()
  for i = 1, table.getn(footmanArray), 1 do
    footman:move()
end

--footman1 = footman(360, -160, activeLayer)

--=============================================
-- Walls
--=============================================

wall( -200, -160, 1, activeLayer )
wall( -256, -160, 2, activeLayer )
wall( -312, -160, 3, activeLayer )

--=============================================
-- Gameloop ( in the future )
--=============================================

MOAIGfxDevice.getFrameBuffer():setClearColor(1,1,1,1)