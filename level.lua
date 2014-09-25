module( "Level", package.seeall )

GROUND_LEVEL = -120
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
  self:loadBackground()
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
  Gesture:update()
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
  table.insert( self.entities, Footman:new( { -100, GROUND_LEVEL }, Game.layers.active ) )
  --Bolt:new( { 0, 0 }, Game.layers.active )
  
  
  timer = MOAITimer.new()
  timer:setMode( MOAITimer.LOOP )
  timer:setSpan( 5 )
  timer:setListener( 
    MOAITimer.EVENT_TIMER_END_SPAN, 
    function() Level:footmanSpawner( 1 ) end
  )
  timer:start()
  
  
  --Bolt:new( { 10, 10 }, Game.layers.active )
end

-- Hier wordt nog ook de grond ingeladen.
function Level:loadBackground()
  self.backgroundDeck = ResourceManager:get( 'background' )
  
  -- Make the prop
  self.backgroundProp = MOAIProp2D.new()
  self.backgroundProp:setDeck( self.backgroundDeck )
  self.backgroundProp:setScl( 2.5, 2.5 )
  Game.layers.background:insertProp( self.backgroundProp )

  self.groundProp = MOAIProp2D.new()
  self.groundProp:setDeck( ResourceManager:get( 'ground' ) )
  self.groundProp:setLoc( 0, GROUND_LEVEL - 36 )
  Game.layers.background:insertProp( self.groundProp )
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

function Level:footmanSpawner( amount )
  for i = 1, amount do
    table.insert( self.entities, Footman:new( { 0 + ( 16 * amount ), GROUND_LEVEL }, Game.layers.active ) )
  end
end

--====================================================
-- Utility functions
--====================================================

-- Takes { x, y }, { x, y }
function Level:getEntitiesNearPos( position, tolerance )
  posX, posY = unpack( position  )
  tolX, tolY = unpack( tolerance )
  local closeEntities = {}
  for key, entity in pairs( self.entities ) do
    local entityX, entityY = unpack( entity:getPosition() )
    if math.abs( entityX - posX ) <= tolX and math.abs( entityY - posY ) <= tolY then
      --print( tostring( entityX - posX ) .. "tolerance: " .. tostring( tolX ) )
      table.insert( closeEntities, entity )
    end
  end
  return closeEntities
end

function Level:getEntityFromFixture( fixture )
  for key, entity in pairs( self.entities ) do
    if entity.physics.fixture == fixture then
      return entity
    end
  end
  return nil
end

function Level:removeEntity( killMe )
  for i = 1, table.getn( self.entities ) do
    if self.entities[i] == killMe then
      self.entities[i] = nil
    end
  end
end

function Level:spawnBolts( position )
  for i = 1, 6 do
    Bolt:new( { position[1] + math.random( -30, 30 ), GROUND_LEVEL + math.random( 30 ) }, Game.layers.active )
  end
end