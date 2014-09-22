require "helpers/footman"
require "resource_definitions"
require "resource_manager"
require "helpers/wall"
require "helpers/sorcerer"

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

activePartition = MOAIPartition.new()
activeLayer:setPartition(activePartition)

--User (interface) layer, meant for player control
userLayer = MOAILayer2D.new()
userLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(userLayer)

--=============================================
-- Resource definitions
--=============================================

local resource_definitions = {
  wallTop = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_top.png', 
    width = 16, height = 16,
  },
  wallMiddle = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_middle.png', 
    width = 16, height = 16,
  },
  wallBase = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_base.png', 
    width = 16, height = 16,
  },
  background = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/background.png', 
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
-- Gameloop ( in the future )
--=============================================

MOAIGfxDevice.getFrameBuffer():setClearColor(1,1,1,1)

--=============================================
-- Walls
--=============================================

ResourceDefinitions:setDefinitions( resource_definitions )
wall1 = Wall:new( 1, { 0, 0 }, activeLayer )
wall2 = Wall:new( 2, { -16, 0 }, activeLayer )
wall3 = Wall:new( 3, { -32, 0 }, activeLayer )
wall4 = Wall:new( 10, { -48, 0 }, activeLayer )

--=============================================
-- Units
--=============================================

sorcerer1 = Sorcerer:new( wall4:getTransform(), { wall4:getTopLoc() }, activeLayer, activePartition )

--=============================================
-- Loop
--=============================================

timer = MOAITimer.new()
timer:setMode( MOAITimer.LOOP )
timer:setSpan( 1 )
timer:setListener( MOAITimer.EVENT_TIMER_END_SPAN, function() wall4:damage(10) end ) 
timer:start()

function terms()
    --checks to see if sorcerer is 'dead'
    local x, y = sorcerer1:getLoc()
    if(y < 0) then
      print "Tower took wizard down."
    end
end

--checks for mouseclick
    if MOAIInputMgr.device.pointer then
      MOAIInputMgr.device.mouseLeft:setCallback(
      function(isMouseDown)
        if(isMouseDown) then
          print "click"
          handleClickorTouch(MOAIInputMgr.device.pointer:getLoc())
        end
        -- Do nothing on mouseUp
      end)
    end

function handleClickorTouch(x, y)
  local obj = activePartition.propForPoint( activePartition, activeLayer:wndToWorld(MOAIInputMgr.device.pointer:getLoc()))
  print (activeLayer:wndToWorld(MOAIInputMgr.device.pointer:getLoc()))
end