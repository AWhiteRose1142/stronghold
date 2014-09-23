module( "Game", package.seeall )

require "index"

-- Start function, is called from main, also contains the gameloop
function Game:start()
  -- Do the initial setup
  self:initialize()
  
  
  while ( true ) do
    coroutine.yield() -- Andere threads laten draaien
  end
end

function Game:initialize()
  print( GAMENAME .. " is initializing" )
  
  -- Load the resource definitions
  Index:loadDefinitions()
  
  self.camera = MOAICamera2D.new() -- Make a new camera
  self:setupLayers()
  PhysicsManager:initialize( self.layers.active )
  
  Level:initialize( 1 )
  
end

-- setup of layers and partitions

function Game:setupLayers()  
  
  self.layers = {}
  self.layers.background = MOAILayer2D.new()
  self.layers.active = MOAILayer2D.new()
  self.layers.user = MOAILayer2D.new()
  
  -- Set the viewport and camera for each layer
  for key, layer in pairs ( self.layers ) do
    layer:setViewport( gameViewport )
    layer:setCamera( self.camera )
  end
  
  -- Create a table with the layers in order
  local renderTable = {
    self.layers.background,
    self.layers.active,
    self.layers.user
  }
  
  -- Set up partitions
  self.partitions = {}
  self.partitions.active = MOAIPartition.new()
  self.layers.active:setPartition( self.partitions.active )
  
  -- And pass them to the render manager
  MOAIRenderMgr.setRenderTable( renderTable )
end


-- DEPRECATED, use level.lua's :loadEntities()
function Game:setupDemo()
  startX = -170
  startY = -100
  wall1 = Wall:new( 1 , { startX     , startY }, self.layers.active )
  wall2 = Wall:new( 2 , { startX - 16, startY }, self.layers.active )
  wall3 = Wall:new( 3 , { startX - 32, startY }, self.layers.active )
  wall4 = Wall:new( 10, { startX - 48, startY }, self.layers.active )
  
  
  
  timer = MOAITimer.new()
  timer:setMode( MOAITimer.LOOP )
  timer:setSpan( .3 )
  timer:setListener( 
    MOAITimer.EVENT_TIMER_END_SPAN, 
    function() 
      wall4:damage(10) 
    end
  )
  --[=[
  timer:setListener( 
    MOAITimer.EVENT_TIMER_BEGIN_SPAN, 
    function() 
      sorcerer1:clicked() 
    end 
  )
  ]=]
  timer:start()
  
  
  
end

--===============================================
-- Utility functions
--===============================================

function sleepCoroutine ( time )
  local timer = MOAITimer.new ()
  timer:setSpan ( time )
  timer:start ()
  MOAICoroutine.blockOnAction ( timer )
end

function footmanSpawn()
  table.insert(footmanArray, footman(360, -160, activeLayer))
end

function footmanMove()
  for i = 1, table.getn(footmanArray), 1 do
    footman:move()
  end
end

--================================================
-- Gesture stuff
--================================================

function terms()
    --checks to see if sorcerer is 'dead'
    local x, y = Level.entities.sorcerer:getLoc()
    if(y < 0) then
      print "Tower took wizard down."
    end
end

--================================================
-- Gesture idea:
-- When left mouse down is called, start a timer.
-- let timer compare mouse location.
-- store type of movement somewhere.
-- if movements match up to set pattern,
-- execute the right function for that pattern.
--================================================

--checks for mouseclick
local a, b, c, d, e, f

local swipeTimer = MOAITimer.new()
swipeTimer:setSpan(1)
swipeTimer:setMode(MOAITimer.LOOP)
swipeTimer:setListener(MOAITimer.EVENT_TIMER_BEGIN_SPAN,
  function()
    e, f = Gesture:getMouseLocation()
  end)
swipeTimer:setListener(MOAITimer.EVENT_TIMER_END_SPAN, 
  function() 
    Gesture:storeSwipe(e, f) 
  end)

    if MOAIInputMgr.device.pointer then
      MOAIInputMgr.device.mouseLeft:setCallback(
      function(isMouseDown)
        if MOAIInputMgr.device.mouseLeft:isDown() then
          -- Left mouse button is down, mark coordinates
          a, b = Gesture:getMouseLocation(Game.layers.active)
          swipeTimer:start()
        end
        if MOAIInputMgr.device.mouseLeft:isUp() then
          swipeTimer:stop()
          
          
          
          -- left mouse button went up. the if/else determines if mouse moved in between down and up
          if Gesture:mouseMoved(a, b, Gesture:getMouseLocation(Game.layers.active)) then
            c, d = Gesture:getMouseLocation(Game.layers.active)
            Gesture:targetLine(a, b, c, d)
          else
            Gesture:click()
          end
        end
      end)
    end