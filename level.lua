module( "Level", package.seeall )

GROUND_LEVEL = -100

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
end

--=============================================================
-- Update() is called by the gameLoop and updates all entities
--=============================================================

function Level:update()
  -- Doet nu nog niets.
end

--==================================================
-- Setting up
--==================================================

function Level:loadEntities()
  self.entities = {}
  startX = -170
  self.entities.wall1 = Wall:new( 1 , { startX     , GROUND_LEVEL }, Game.layers.active )
  self.entities.wall2 = Wall:new( 2 , { startX - 16, GROUND_LEVEL }, Game.layers.active )
  self.entities.wall3 = Wall:new( 3 , { startX - 32, GROUND_LEVEL }, Game.layers.active )
  self.entities.footman = Footman:new( { 0, GROUND_LEVEL }, Game.layers.active )
  self.entities.footman:move( -1 )
  
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
-- Maybe a spawner here?
--====================================================