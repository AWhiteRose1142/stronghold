local class = require 'libs/middleclass'

Footman = class('footman')

local animationDefinitions = {
  walk = {
    startFrame = 1,
    frameCount = 2,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
  piss = {
    startFrame = 3,
    frameCount = 3,
    time = 0.2,
    mode = MOAITimer.NORMAL
  },
  attack = {
    startFrame = 6,
    frameCount = 2,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
}

function Footman:initialize( position, layer )
  self.health = 6
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'footman' )
  
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
  --self:startAnimation( "attack" )
end

function Footman:damage( damage )
  self.health = self.health - damage
  if self.health <= 0 then
    print( "the footman is dead" )
  end
end

function Footman:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Actions
--===========================================

function Footman:move( direction )
  self.prop:setScl( -direction, 1 )
  velX, velY = self.physics.body:getLinearVelocity()
  self.physics.body:setLinearVelocity( direction * 10, velY )
  
  if ( self.currentAnimation ~= self:getAnimation ( 'walk' ) ) and not self.attacking then
    self:startAnimation ( 'walk' )
  end
end

function Footman:stopMoving()
  self.physics.body:setLinearVelocity ( 0, 0 )
  self:stopCurrentAnimation()
end

function Footman:attack()
  -- Find a wall to attack, does Box2D have some sort of raytracing? Then call damage on the wall
  
  self:startAnimation( "attack" )
end

--===========================================
-- Animation control
--===========================================

function Footman:getAnimation( name )
  return self.animations[name]
end

function Footman:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Footman:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Event handlers
--===========================================

function onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop!" )
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Footman:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.DYNAMIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -8, -8, 8, 8 )
  self.prop:setParent( self.physics.body )
  self.physics.fixture:setCollisionHandler( onCollide, MOAIBox2DArbiter.BEGIN )
end

function Footman:addAnimation( name, startFrame, frameCount, time, mode )
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