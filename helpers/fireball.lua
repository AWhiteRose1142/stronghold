local class = require 'libs/middleclass'

Fireball = class('fireball')

local animationDefinitions = {
  burn = {
    startFrame = 1,
    frameCount = 2,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
}

function Fireball:initialize( position, layer, strength, target )
  self.health = 6
  self.strength = strength
  self.type = "fireball"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.target = target
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'fireball' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  layer:insertProp( self.prop )
  
  -- Initialize animations
  self.remapper = MOAIDeckRemapper.new()
  self.remapper:reserve( 1 )
  self.prop:setRemapper( self.remapper )
  
  self.animations = {}
  for name, def in pairs( animationDefinitions ) do
    self:addAnimation( name, def.startFrame, def.frameCount, def.time, def.mode )
  end
  
  -- Setup physics
  self:initializePhysics( position )
    
  -- Code for testing
  local t1, t2 = unpack( target )
  self.physics.body:applyLinearImpulse( -1 )
  table.insert( Level.entities, self )
  table.insert( Level.objects, self )
end

function Fireball:update()
  -- Makes sure animation is always 'burn'
  if ( self.currentAnimation ~= self:getAnimation ( 'burn' ) ) and not self.attacking then
    self:startAnimation ( 'burn' )
  end
end

function Fireball:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Fireball:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Actions
--===========================================

function Fireball:move( direction )
  self.prop:setScl( -direction, 1 )
  velX, velY = self.physics.body:getLinearVelocity()
  self.physics.body:setLinearVelocity( direction * 10, velY )
end

function Fireball:stopMoving()
  self.physics.body:setLinearVelocity ( 0, 0 )
  self:stopCurrentAnimation()
end

function Fireball:attack( )
  if self.target.health >= 0 then
    if self.timer ~= nil then
      self.target:damage( self.strength )
    else
      self.timer = MOAITimer.new()
      self.timer:setMode( MOAITimer.LOOP )
      self.timer:setSpan( 0.6 )
      self.timer:setListener( 
        MOAITimer.EVENT_TIMER_END_SPAN,
        bind( self, "attack" )
      )
      self.timer:start()
      self:stopMoving()
      self.target:damage( self.strength )
      self:startAnimation( "burn" )
    end
  else
    self:move( -1 )
    self.timer:stop()
    self.timer = nil
    self.target = nil
  end
end

function Fireball:damage( damage )
  --does nothing
end

--===========================================
-- Animation control
--===========================================

function Fireball:getAnimation( name )
  return self.animations[name]
end

function Fireball:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Fireball:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Event handlers
--===========================================

function Fireball:onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop!" )
  
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "orc" or entityB.type == "footman" then
      print( "burn baby!" )
      self.target = entityB
      self:attack( )
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Fireball:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  Level.score = Level.score + 10
  print( "destroying a Fireball" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  --PhysicsHandler:sceduleForRemoval( self.physics.body )
  --self.physics.body:destroy()
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function Fireball:initializePhysics( position )
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

function Fireball:addAnimation( name, startFrame, frameCount, time, mode )
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