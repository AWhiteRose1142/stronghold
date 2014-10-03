local class = require 'libs/middleclass'

Crossbolt = class('crossbolt')

local animationDefinitions = {
  exist = {
    startFrame = 1,
    frameCount = 1,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
}

function Crossbolt:initialize( position, layer, target, strength )
  self.type = "arrow"
  self.timer = nil
  self.target = target
  self.layer = layer
  self.strength = strength
  self.remove = false
  
  local selfx, selfy = unpack( position )
  local targetx, targety = unpack( self.target:getPosition() )
  local x = ( targetx - selfx )
  local y = ( targety - selfy )
  local length = math.sqrt( ( x * x ) + ( y * y ) )
  self.pytx = x / length
  self.pyty = y / length
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'arrow' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  layer:insertProp( self.prop )
  
  -- Setup physics
  self:initializePhysics( position )
  
  table.insert( Level.entities, self )
end

function Crossbolt:update()
  if self.remove == true then self:destroy() end
end

function Crossbolt:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Crossbolt:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Event handlers
--===========================================

function Crossbolt:onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop!" )
  self.physics.body:setAngularVelocity(0)
  self.physics.body:setLinearVelocity(0, 0)
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "wall" or entityB.type == "archer" then
      print( "gnarly!" )
      entityB.damage( strength )
      self.remove = true
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Crossbolt:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  print( "destroying Crossbolt" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  --PhysicsHandler:sceduleForRemoval( self.physics.body )
  --self.physics.body:destroy()
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function Crossbolt:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.DYNAMIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -6, -2, 5, 1 )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x02, 0x04 )
  self.physics.fixture:setSensor( true )
  self.prop:setParent( self.physics.body )

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end