module( "Game", package.seeall )

-- Resource definition of the tilesheet
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
  
  self.camera = MOAICamera2D.new() -- Make a new camera
  self:setupLayers()
  
  ResourceDefinitions:setDefinitions( resource_definitions )
  self:setupDemo()
  
end

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
  
  -- And pass them to the render manager
  MOAIRenderMgr.setRenderTable( renderTable )
end

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