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

function Crossbolt:initialize( position, layer, aim, strength )
  self.type = "arrow"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.strength = strength
  self.aim = aim
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'arrow' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  layer:insertProp( self.prop )
  
  -- Setup physics
  self:initializePhysics( position )
    
  -- Code for testing
  self.physics.body:setLinearVelocity( -(self.strength * 10), self.aim )
  table.insert( Level.entities, self )
  table.insert( Level.objects, self )
end

function Crossbolt:update()
  self:move( self.strength )
end

function Crossbolt:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Crossbolt:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Actions
--===========================================

function Crossbolt:move( direction )
  velX, velY = self.physics.body:getLinearVelocity()
  self.physics.body:setLinearVelocity( -(direction * 10), velY )
end

function Crossbolt:stopMoving()
  self.physics.body:setLinearVelocity ( 0, 0 )
end

function Crossbolt:attack( )
  if self.target.health >= 0 then
    self.target:damage( self.strength )
  end
  self:destroy()
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
      self.target = entityB
      self:attack( )
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
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.KINEMATIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -3, -8, 5, 8 )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x02, 0x04 )
  self.prop:setParent( self.physics.body )

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end

function Crossbolt:addAnimation( name, startFrame, frameCount, time, mode )
  -- This curve is going to do shit, yo
  local curve = MOAIAnimCurve.new()
  -- Reserve start and end keys
  curve:reserveKeys( 2 )
  -- Params: starting key, time, value ( index of in tilesheet ), animcurve type
  curve:setKey( 1, 0, startFrame, MOAIEaseType.LINEAR )
  curve:setKey( 2, time * frameCount, startFrame + frameCount, MOAIEaseType.LINEAR )
  
  -- Making the animation
  local anim = MOAIAnim:new()
  -- Reserve a link to connect the curve with the remapper
  anim:reserveLinks( 1 )
  anim:setLink( 1, curve, self.remapper, 1 )
  anim:setMode( mode )
  self.animations[name] = anim
end