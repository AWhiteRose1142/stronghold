local class = require 'libs/middleclass'

IceBolt = class('icebolt')

local animationDefinitions = {
  burn = {
    startFrame = 1,
    frameCount = 2,
    time = 0.1,
    mode = MOAITimer.LOOP
  },
}

function IceBolt:initialize( position, layer )
  self.health = 6
  self.type = "icebolt"
  self.timer = nil
  self.layer = layer
  self.remove = false
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( "iceBolt" )
  
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
  self.physics.body:setLinearVelocity( 0, -100 + math.random( -10, 10 ) )
  table.insert( Level.entities, self )
  -- Waarom toevoegen aan de objects?
  --table.insert( Level.objects, self )
  
  self:startAnimation ( 'burn' )
end

function IceBolt:update()
  if self.remove == true or self:isOutOfBounds() then 
    self:destroy()
  end
end

function IceBolt:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function IceBolt:getTransform()
  return self.physics.body.transform
end

function IceBolt:isOutOfBounds()
  local x, y = unpack( self:getPosition() )
  if x < -350 or x > 350 then return true end
  if y < Level.GROUND_LEVEL - 5 or y > 400 then return true end
  return false
end

--===========================================
-- Animation control
--===========================================

function IceBolt:getAnimation( name )
  return self.animations[name]
end

function IceBolt:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function IceBolt:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Event handlers
--===========================================

function IceBolt:onCollide( phase, fixtureA, fixtureB, arbiter )
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "orc" or entityB.type == "goblin" or entityB.type == "imp" then
      print( "burn baby!" )
      entityB:slow()
      self.remove = true
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function IceBolt:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function IceBolt:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.KINEMATIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -5, -4, 5, 5 )
  self.physics.fixture:setSensor( true )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x04, 0x02 )
  self.prop:setParent( self.physics.body )

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
end

function IceBolt:addAnimation( name, startFrame, frameCount, time, mode )
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