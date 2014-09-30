local class = require 'libs/middleclass'

Arrow = class('arrow')

function Arrow:initialize( position, layer, aim, strength )
  self.type = "arrow"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.aim = aim
  self.force = (strength * 10)
  local X, Y = unpack(position)
  

  self.deck = ResourceManager:get( 'arrow' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setLoc((X+8), Y)
  self.prop:setDeck( self.deck )
  layer:insertProp( self.prop )
  
  -- Setup physics
  self:initializePhysics( parent, position )
  self.physics.body:setLinearVelocity(self.force, self.aim)
end

function Arrow:update()
  --can go?
end

function Arrow:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Arrow:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Actions
--===========================================

function Arrow:attack( )
  self.target:damage( 10 )
  self:destroy()
end

function Arrow:damage( damage )
  --should do nothing
end

--===========================================
-- Event handlers
--===========================================

function Arrow:onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop!" )
  
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "footman" then
      print( "hit" )
      self.target = entityB
      self:attack( )
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Arrow:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen
  print( "destroying arrow" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  --PhysicsHandler:sceduleForRemoval( self.physics.body )
  --self.physics.body:destroy()
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function Arrow:initializePhysics( parent, position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.DYNAMIC )
  --self.physics.body:setTransform( parent )
  self.physics.fixture = self.physics.body:addRect( -3, -8, 5, 8 )
  self.prop:setParent( self.physics.body )
  

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end