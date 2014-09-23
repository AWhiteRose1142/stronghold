module( "Level", package.seeall )

GROUND_LEVEL = -100
initialized = false

--==================================================
-- Basic objects that are the same for every level
--==================================================

local base_objects = {
  floor = {
    type = MOAIBox2DBody.STATIC,
    position = { 0, GROUND_LEVEL - 10 },
    friction = 0,
    size = { 2 * WORLDRES_X, 10 }
  },
}

function Level:initialize( difficulty )
  self:loadScene()
  self:loadEntities()
  self.initialized = true
end

--=============================================================
-- Update() is called by the gameLoop and updates all entities
--=============================================================

function Level:update()
  -- Doet nu nog niets.
  for key, entity in pairs( self.entities ) do
    entity:update()
  end
end

--==================================================
-- Setting up
--==================================================

function Level:loadEntities()
  self.entities = {}
  self.walls = {}
  startX = -170  
  
  for i = 0, 3 do
    local wall = Wall:new( i + 1 , { startX - (i * 16), GROUND_LEVEL }, Game.layers.active )
    table.insert( self.entities, wall )
    table.insert( self.walls, wall )
  end
  
  table.insert( self.entities, Sorcerer:new( 
      Level.walls[3]:getTransform(), 
      { Level.walls[3]:getTopLoc() }, 
      Game.layers.active, 
      Game.partitions.active )
  )
  table.insert( self.entities, Footman:new( { -80, GROUND_LEVEL }, Game.layers.active ) )
  
  --[=[
  timer = MOAITimer.new()
  timer:setMode( MOAITimer.LOOP )
  timer:setSpan( .3 )
  timer:setListener( 
    MOAITimer.EVENT_TIMER_END_SPAN, 
    function() 
      wall4:damage(10) 
    end
  )
  timer:start()
  ]=]
end

function Level:loadScene()
  self.objects = {}
  for key, attr in pairs( base_objects ) do
    local body = PhysicsManager.world:addBody( attr.type )
    body:setTransform( unpack( attr.position ) )
    width, height = unpack( attr.size )
    local fixture = body:addRect( - width / 2, - height / 2, width / 2, height / 2 )
    fixture:setFriction( attr.friction )
    self.objects[key] = { body = body, fixture = fixture }
  end
end

--====================================================
-- Utility functions
--====================================================

function Level:getEntityFromFixture( fixture )
  for key, entity in pairs( self.entities ) do
    if entity.physics.fixture == fixture then
      return entity
    end
  end
  return nil
end