module( "Game", package.seeall )

require "index"

-- Start function, is called from main, also contains the gameloop
function Game:start()
  -- Do the initial setup
  
  self:initialize()
  
  
  while ( true ) do
    if Level.initialized then
      Level:update()
    end
    --PhysicsManager.update()
    coroutine.yield() -- Andere threads laten draaien
  end
end

function Game:initialize()
  print( GAMENAME .. " is initializing" )
  
  -- Load the resource definitions
  Index:loadDefinitions()
  
  self.camera = MOAICamera2D.new() -- Make a new camera
  self:setupLayers()
  
  --self.corout = MOAICoroutine.new()
  
  PhysicsManager:initialize( --[=[ self.layers.active ]=] )
  Gesture:initialize()
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
-- Gesture stuff, mostly unused now
--================================================

function terms()
    --checks to see if sorcerer is 'dead'
    local x, y = Level.entities.sorcerer:getLoc()
    if(y < 0) then
      print "Tower took wizard down."
    end
end



function handleClickorTouch(x, y)
  -- This is an electrocution test
  for key, entity in pairs( Level:getEntitiesNearPos( { x, y }, { 50, 50 } ) ) do
    if entity.electrocute ~= nil then
      entity:electrocute()
    end
  end
  
  local obj = Game.partitions.active.propForPoint( Game.partitions.active, Game.layers.active:wndToWorld(MOAIInputMgr.device.pointer:getLoc()))
  print (Game.layers.active:wndToWorld(MOAIInputMgr.device.pointer:getLoc()))
end
