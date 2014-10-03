local class = require 'libs/middleclass'

Arrow = class('arrow')

local animationDefinitions = {
  exist = {
    startFrame = 1,
    frameCount = 1,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
}

function Arrow:initialize( position, layer, aim, strength )
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
  self.physics.body:setLinearVelocity( (self.strength * 10), self.aim )
  table.insert( Level.entities, self )
  table.insert( Level.objects, self )
end

function Arrow:update()
  self:move( self.strength )
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

function Arrow:move( direction )
  velX, velY = self.physics.body:getLinearVelocity()
  self.physics.body:setLinearVelocity( direction * 10, velY )
end

function Arrow:stopMoving()
  self.physics.body:setLinearVelocity ( 0, 0 )
end

function Arrow:attack( )
  if self.target.health >= 0 then
    self.target:damage( self.strength )
  end
  self:destroy()
end

--===========================================
-- Event handlers
--===========================================

function Arrow:onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop!" )
  self.physics.body:setAngularVelocity(0)
  self.physics.body:setLinearVelocity(0, 0)
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "orc" or entityB.type == "footman" then
      print( "headshot!" )
      self.target = entityB
      self:attack( )
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Arrow:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  print( "destroying arrow" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  --PhysicsHandler:sceduleForRemoval( self.physics.body )
  --self.physics.body:destroy()
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function Arrow:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.DYNAMIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -6, -2, 5, 1 )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x04, 0x02 )
  self.prop:setParent( self.physics.body )

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end

function Arrow:addAnimation( name, startFrame, frameCount, time, mode )
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